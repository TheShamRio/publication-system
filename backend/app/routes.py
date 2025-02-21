from flask import Blueprint, jsonify, request
from .extensions import db
from .models import Publication, User
import bibtexparser
from flask_login import login_user, current_user, logout_user
from functools import wraps
from flask_login import login_required
from .analytics import get_publications_by_year
from flask import current_app
from werkzeug.utils import secure_filename
import os
import logging
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from sqlalchemy import func, desc

bp = Blueprint('api', __name__)

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

@bp.route('/publications/export-bibtex', methods=['GET'])
@login_required
def export_bibtex():
    publications = Publication.query.filter_by(user_id=current_user.id).all()
    if not publications:
        return jsonify({"error": "Нет публикаций для выгрузки"}), 404

    bib_database = bibtexparser.bibdatabase.BibDatabase()
    entries = []

    for pub in publications:
        entry = {
            'ENTRYTYPE': pub.type,
            'ID': f"{pub.title.replace(' ', '_')}_{pub.year}",
            'title': pub.title,
            'author': pub.authors,
            'year': str(pub.year),
        }
        if pub.file_url:
            entry['file'] = pub.file_url
        if pub.status:
            entry['note'] = pub.status
        entries.append(entry)

    bib_database.entries = entries
    writer_instance = bibtexparser.bwriter.BibTexWriter()
    bibtex_str = bibtexparser.dumps(bib_database, writer_instance)

    from flask import make_response
    response = make_response(bibtex_str)
    response.headers['Content-Disposition'] = 'attachment; filename=publications.bib'
    response.mimetype = 'application/x-bibtex'
    return response

@bp.route('/user/password', methods=['PUT'])
@login_required
def update_user_password():
    data = request.json
    if not data or not all(key in data for key in ['current_password', 'new_password']):
        return jsonify({"error": "Отсутствуют обязательные поля (текущий и новый пароль)"}), 400

    if not check_password_hash(current_user.password_hash, data['current_password']):
        return jsonify({"error": "Неверный текущий пароль"}), 400

    current_user.set_password(data['new_password'])
    try:
        db.session.commit()
        return jsonify({"message": "Пароль успешно обновлен"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": "Ошибка при обновлении пароля. Попробуйте позже."}), 500

@bp.route('/publications/<int:pub_id>/attach-file', methods=['POST'])
@login_required
def attach_file_to_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    if publication.user_id != current_user.id:
        return jsonify({"error": "У вас нет прав на изменение этой публикации"}), 403

    if 'file' not in request.files:
        return jsonify({"error": "Не предоставлен файл"}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "Не выбран файл"}), 400

    if not file or not allowed_file(file.filename):
        return jsonify({"error": "Тип файла не разрешен. Разрешены только PDF и DOCX"}), 400

    filename = secure_filename(file.filename)
    file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
    file.save(file_path)

    publication.file_url = os.path.join('uploads', filename)
    db.session.commit()
    return jsonify({"message": "Файл успешно прикреплен", "publication": {
        "id": publication.id,
        "title": publication.title,
        "file_url": publication.file_url,
        "type": publication.type_ru,
        "status": publication.status_ru
    }}), 200

def allowed_file(filename):
    with current_app.app_context():
        return '.' in filename and \
            filename.rsplit('.', 1)[1].lower() in current_app.config['ALLOWED_EXTENSIONS']

@bp.route('/publications', methods=['GET'])
@login_required
def get_publications():
    query = Publication.query.filter_by(user_id=current_user.id)

    # Фильтрация по статусу только если параметр передан (для Home.js)
    status = request.args.get('status')
    if status:
        query = query.filter_by(status=status)

    # Фильтрация по типу
    pub_type = request.args.get('type')
    if pub_type:
        query = query.filter_by(type=pub_type)

    # Фильтрация по году
    year = request.args.get('year')
    if year:
        query = query.filter_by(year=int(year))

    # Поиск по названию или авторам
    search = request.args.get('search', '').lower()
    if search:
        query = query.filter(
            (Publication.title.ilike(f'%{search}%')) |
            (Publication.authors.ilike(f'%{search}%'))
        )

    # Сортировка по дате обновления
    publications = query.order_by(desc(Publication.updated_at)).all()

    return jsonify([{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': pub.type,
        'status': pub.status,
        'file_url': pub.file_url,
        'updated_at': pub.updated_at.isoformat() if pub.updated_at else None,
        'user': {'full_name': pub.user.full_name if pub.user and pub.user.full_name else 'Не указан'}
    } for pub in publications]), 200

@bp.route('/publications/upload-file', methods=['POST'])
@login_required
def upload_file():
    logger.debug(f"User attempting upload: {current_user.username if current_user.is_authenticated else 'Not authenticated'}")
    
    if 'file' not in request.files:
        return jsonify({"error": "Не предоставлен файл"}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "Не выбран файл"}), 400

    if not file or not allowed_file(file.filename):
        return jsonify({"error": "Тип файла не разрешен. Разрешены только PDF и DOCX"}), 400

    title = request.form.get('title', '').strip()
    authors = request.form.get('authors', '').strip()
    year_str = request.form.get('year', '')

    if not title or not authors or not year_str:
        return jsonify({"error": "Все поля (название, авторы, год) должны быть заполнены"}), 400

    try:
        year = int(year_str)
        if year < 1900 or year > datetime.now().year:
            return jsonify({"error": f"Год должен быть в пределах 1900–{datetime.now().year}"}), 400
    except ValueError:
        return jsonify({"error": "Год должен быть числом"}), 400

    pub_type = request.form.get('type', 'article')
    if pub_type not in ['article', 'monograph', 'conference']:
        return jsonify({"error": "Недопустимый тип публикации"}), 400

    filename = secure_filename(file.filename)
    file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
    file.save(file_path)
    
    publication = Publication(
        title=title,
        authors=authors,
        year=year,
        type=pub_type,
        file_url=file_path,
        status='draft',
        user_id=current_user.id
    )
    db.session.add(publication)
    db.session.commit()
    
    return jsonify({"message": "Публикация успешно создана", "id": publication.id}), 201

@bp.route('/publications/upload-bibtex', methods=['POST'])
@login_required
def upload_bibtex():
    logger.debug(f"User attempting BibTeX upload: {current_user.username}")
    
    if 'file' not in request.files:
        return jsonify({"error": "Не загружен файл"}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "Не выбран файл"}), 400

    if not file or not allowed_file(file.filename):
        return jsonify({"error": "Тип файла не разрешен. Разрешены только файлы .bib"}), 400

    try:
        bibtex_str = file.read().decode('utf-8')
        parser = bibtexparser.bparser.BibTexParser(common_strings=True)
        bib_database = bibtexparser.loads(bibtex_str, parser=parser)

        publications_count = 0
        for entry in bib_database.entries:
            title = entry.get('title', 'Untitled')
            authors = entry.get('author', 'Unknown')
            year_str = entry.get('year', '2023')
            
            try:
                year = int(year_str)
                if year < 1900 or year > datetime.now().year:
                    return jsonify({"error": f"Недопустимый год в записи: {year_str}. Должно быть 1900–{datetime.now().year}"}), 400
            except (ValueError, TypeError):
                return jsonify({"error": f"Год в записи должен быть числом: {year_str}"}), 400

            entry_type = entry.get('ENTRYTYPE', 'article').lower()
            if entry_type not in ['article', 'book', 'inproceedings']:
                entry_type = 'article'

            publication = Publication(
                title=title,
                authors=authors,
                year=year,
                type=entry_type,
                status='draft',
                user_id=current_user.id
            )
            db.session.add(publication)
            publications_count += 1

        db.session.commit()
        return jsonify({"message": f"Загружено {publications_count} публикаций"}), 201
    except Exception as e:
        logger.error(f"Error parsing BibTeX: {str(e)}")
        return jsonify({"error": "Ошибка парсинга BibTeX. Проверьте файл и повторите попытку."}), 400

@bp.route('/register', methods=['POST'])
def register():
    data = request.json
    if User.query.filter_by(username=data['username']).first():
        return jsonify({"error": "Пользователь с таким именем уже существует"}), 400

    user = User(
        username=data['username'],
        last_name=data.get('last_name'),
        first_name=data.get('first_name'),
        middle_name=data.get('middle_name')
    )
    user.set_password(data['password'])
    db.session.add(user)
    db.session.commit()
    return jsonify({"message": "Пользователь зарегистрирован", "user": {
        "id": user.id,
        "username": user.username,
        "last_name": user.last_name,
        "first_name": user.first_name,
        "middle_name": user.middle_name
    }}), 201

@bp.route('/login', methods=['POST'])
def login():
    data = request.json
    print(f"Received login attempt for username: {data['username']}")
    user = User.query.filter_by(username=data['username']).first()
    if user and user.check_password(data['password']):
        login_user(user)
        return jsonify({"message": "Вход выполнен"})
    return jsonify({"error": "Неверные учетные данные"}), 401

@bp.route('/logout')
def logout():
    logout_user()
    return jsonify({"message": "Logged out"})

def admin_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if current_user.role != 'admin':
            return jsonify({"error": "Access denied"}), 403
        return f(*args, **kwargs)
    return decorated

@bp.route('/admin/stats')
@login_required
@admin_required
def admin_stats():
    return jsonify({"total_publications": Publication.query.count()})

@bp.route('/analytics/yearly', methods=['GET'])
@login_required
def get_yearly_analytics():
    yearly_stats = db.session.query(
        Publication.year,
        func.count(Publication.id)
    ).filter(Publication.user_id == current_user.id)\
      .group_by(Publication.year)\
      .all()
    return jsonify([{
        'year': year,
        'count': count
    } for year, count in yearly_stats])

@bp.route('/publications/<int:pub_id>', methods=['PUT'])
@login_required
def update_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    if publication.user_id != current_user.id:
        return jsonify({"error": "У вас нет прав на редактирование этой публикации"}), 403

    data = request.json
    publication.title = data.get('title', publication.title)
    publication.authors = data.get('authors', publication.authors)
    publication.year = data.get('year', publication.year)
    publication.type = data.get('type', publication.type)
    publication.status = data.get('status', publication.status)

    try:
        db.session.commit()
        return jsonify({"message": "Публикация успешно отредактирована", "publication": {
            "id": publication.id,
            "title": publication.title,
            "authors": publication.authors,
            "year": publication.year,
            "type": publication.type,
            "status": publication.status
        }}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": "Ошибка при редактировании публикации. Попробуйте позже."}), 500

@bp.route('/publications/<int:pub_id>', methods=['DELETE'])
@login_required
def delete_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    if publication.user_id != current_user.id:
        return jsonify({"error": "У вас нет прав на удаление этой публикации"}), 403
    
    try:
        if publication.file_url and os.path.exists(publication.file_url):
            os.remove(publication.file_url)
        
        db.session.delete(publication)
        db.session.commit()
        return jsonify({"message": "Публикация успешно удалена"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": "Ошибка при удалении публикации. Попробуйте позже."}), 500

@bp.route('/publications/search', methods=['GET'])
@login_required
def search_publications():
    year = request.args.get('year')
    author = request.args.get('author')
    title = request.args.get('title')
    
    query = Publication.query

    if year:
        query = query.filter(Publication.year == int(year))
    if author:
        query = query.filter(Publication.authors.ilike(f'%{author}%'))
    if title:
        query = query.filter(Publication.title.ilike(f'%{title}%'))

    publications = query.all()
    results = [{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': pub.type,
        'status': pub.status,
        'file_url': pub.file_url
    } for pub in publications]

    return jsonify(results)

@bp.route('/user', methods=['GET'])
@login_required
def get_user():
    return jsonify({
        "id": current_user.id,
        "username": current_user.username,
        "last_name": current_user.last_name,
        "first_name": current_user.first_name,
        "middle_name": current_user.middle_name
    })

@bp.route('/user', methods=['PUT'])
@login_required
def update_user():
    logger.debug(f"Received PUT request for /user with data: {request.json}")
    data = request.json
    if not data or not all(key in data for key in ['last_name', 'first_name', 'middle_name']):
        return jsonify({"error": "Отсутствуют обязательные поля"}), 400

    current_user.last_name = data['last_name'].strip() if data['last_name'] else None
    current_user.first_name = data['first_name'].strip() if data['first_name'] else None
    current_user.middle_name = data['middle_name'].strip() if data['middle_name'] else None

    try:
        db.session.commit()
        logger.debug(f"User data updated successfully for user {current_user.id}")
        return jsonify({
            "message": "Личные данные успешно обновлены",
            "user": {
                "id": current_user.id,
                "username": current_user.username,
                "last_name": current_user.last_name,
                "first_name": current_user.first_name,
                "middle_name": current_user.middle_name
            }
        }), 200
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error updating user data: {str(e)}")
        return jsonify({"error": "Ошибка при обновлении данных. Попробуйте позже."}), 500