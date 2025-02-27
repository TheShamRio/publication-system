from flask import Blueprint, jsonify, request, make_response, current_app, send_from_directory
from .extensions import db, login_manager, csrf
from .models import User, Publication
from .utils import allowed_file
from flask_login import login_user, current_user, logout_user, login_required
from werkzeug.utils import secure_filename
from flask_wtf.csrf import generate_csrf
import os
from .models import User, Publication, Comment  # Добавляем Comment
import logging
from datetime import datetime, UTC
from werkzeug.security import generate_password_hash, check_password_hash
from .analytics import get_publications_by_year
import bibtexparser
from docx import Document
from reportlab.platypus import SimpleDocTemplate, Paragraph
from reportlab.lib.pagesizes import letter
from bibtexparser.bibdatabase import BibDatabase
from bibtexparser.bwriter import BibTexWriter
from flask import send_file
bp = Blueprint('api', __name__)

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)


@bp.route('/uploads/<path:filename>')
def download_file(filename):
    file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
    logger.debug(f"Requested filename: '{filename}' (raw), full path: {file_path}")
    logger.debug(f"Does filename end with '.docx'? {filename.endswith('.docx')}")
    
    if filename.endswith('.docx'):
        pdf_path = file_path.replace('.docx', '.pdf')
        logger.debug(f"Converting .docx to PDF: {pdf_path}")
        
        if not os.path.exists(pdf_path):
            try:
                logger.debug(f"Opening .docx file: {file_path}")
                doc = Document(file_path)
                pdf = SimpleDocTemplate(pdf_path, pagesize=letter)
                story = [Paragraph(p.text) for p in doc.paragraphs if p.text.strip()]
                logger.debug(f"Building PDF with {len(story)} paragraphs")
                pdf.build(story)
                logger.debug(f"PDF created at: {pdf_path}")
            except Exception as e:
                logger.error(f"Error converting .docx to PDF: {str(e)}")
                # Возвращаем ошибку клиенту вместо отправки .docx
                return jsonify({'error': f'Ошибка конверсии .docx в PDF: {str(e)}'}), 500
        
        response = send_file(pdf_path, mimetype='application/pdf', as_attachment=False)
    else:
        logger.debug(f"Serving file directly: {file_path}")
        if not os.path.exists(file_path):
            logger.error(f"File not found: {file_path}")
            return jsonify({'error': 'Файл не найден'}), 404
        response = send_file(file_path, mimetype='application/pdf', as_attachment=False)
    
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response


@bp.route('/publications/<int:pub_id>', methods=['GET'])
def get_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    comments = Comment.query.filter_by(publication_id=pub_id, parent_id=None).order_by(Comment.created_at.asc()).all()
    
    def build_comment_tree(comment):
        return {
            'id': comment.id,
            'content': comment.content,
            'user': {'username': comment.user.username, 'full_name': comment.user.full_name},
            'created_at': comment.created_at.isoformat(),
            'replies': [build_comment_tree(reply) for reply in comment.replies]
        }

    return jsonify({
        'id': publication.id,
        'title': publication.title,
        'authors': publication.authors,
        'year': publication.year,
        'type': publication.type,
        'status': publication.status,
        'file_url': f"/uploads/{os.path.basename(publication.file_url)}",  # Используем basename
        'user': {'full_name': publication.user.full_name if publication.user else 'Не указан'},
        'updated_at': publication.updated_at.isoformat() if publication.updated_at else None,
        'published_at': publication.published_at.isoformat() if publication.published_at else None,
        'comments': [build_comment_tree(comment) for comment in comments]
    }), 200

@bp.route('/publications/<int:pub_id>/comments', methods=['POST'])
@login_required
def add_comment(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    data = request.get_json()
    content = data.get('content')
    parent_id = data.get('parent_id')

    if not content:
        return jsonify({'error': 'Комментарий не может быть пустым'}), 400

    comment = Comment(
        content=content,
        user_id=current_user.id,
        publication_id=pub_id,
        parent_id=parent_id if parent_id else None
    )
    db.session.add(comment)
    db.session.commit()

    return jsonify({
        'message': 'Комментарий добавлен',
        'comment': {
            'id': comment.id,
            'content': comment.content,
            'user': {'username': current_user.username, 'full_name': current_user.full_name},
            'created_at': comment.created_at.isoformat(),
            'replies': []
        }
    }), 201

@bp.route('/register', methods=['POST', 'OPTIONS'])  # Добавляем обработку OPTIONS
def register():
    if request.method == 'OPTIONS':
        # Обработка предварительного запроса CORS
        response = make_response()
        response.headers['Access-Control-Allow-Origin'] = 'http://localhost:3001'
        response.headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS'
        response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-CSRFToken'
        response.headers['Access-Control-Allow-Credentials'] = 'true'
        response.headers['Access-Control-Max-Age'] = '86400'  # Кэширование предварительного запроса на 24 часа
        logger.debug("Обработка предварительного запроса OPTIONS для /register")
        return response, 200

    logger.debug("Получен POST запрос для /api/register")
    logger.debug(f"Принятые данные: {request.get_json()}")  # Логируем полученные данные
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    last_name = data.get('last_name')
    first_name = data.get('first_name')
    middle_name = data.get('middle_name')

    if not username or not password:
        logger.error("Логин или пароль отсутствуют в запросе")
        return jsonify({'error': 'Логин и пароль обязательны'}), 400

    if User.query.filter_by(username=username).first():
        logger.error(f"Пользователь с логином {username} уже существует")
        return jsonify({'error': 'Пользователь с таким логином уже существует'}), 400

    user = User(
        username=username,
        last_name=last_name,
        first_name=first_name,
        middle_name=middle_name
    )
    user.set_password(password)
    try:
        db.session.add(user)
        db.session.commit()
        logger.info(f"Пользователь {username} успешно зарегистрирован")
        return jsonify({'message': 'Пользователь зарегистрирован', 'user': {'username': user.username, 'role': user.role}}), 201
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка регистрации пользователя {username}: {str(e)}")
        return jsonify({'error': 'Ошибка при регистрации. Попробуйте позже.'}), 500

@bp.route('/login', methods=['POST'])
@csrf.exempt
def login():
    logger.debug(f"Получен POST запрос для /login")
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    user = User.query.filter_by(username=username).first()
    if user and check_password_hash(user.password_hash, password):
        login_user(user, remember=True)
        return jsonify({
            'message': 'Успешная авторизация',
            'user': {
                'id': user.id,
                'username': user.username,
                'role': user.role,
                'last_name': user.last_name,
                'first_name': user.first_name,
                'middle_name': user.middle_name
            }
        }), 200
    return jsonify({'error': 'Неверное имя пользователя или пароль'}), 401

@bp.route('/csrf-token', methods=['GET'])  # Убираем @login_required
def get_csrf_token():
    logger.debug(f"Получен GET запрос для /api/csrf-token")
    token = generate_csrf()
    return jsonify({'csrf_token': token}), 200

@bp.route('/logout', methods=['POST'])
@login_required
def logout():
    logger.debug(f"Получен POST запрос для /logout")
    logout_user()
    return jsonify({'message': 'Успешный выход'}), 200

@bp.route('/user', methods=['GET', 'PUT'])
@login_required
def user():
    logger.debug(f"Получен {request.method} запрос для /user")
    if request.method == 'GET':
        return jsonify({
            'id': current_user.id,
            'username': current_user.username,
            'role': current_user.role,
            'last_name': current_user.last_name,
            'first_name': current_user.first_name,
            'middle_name': current_user.middle_name,
            'created_at': current_user.created_at.isoformat() if current_user.created_at else None
        }), 200
    elif request.method == 'PUT':
        data = request.get_json()
        current_user.last_name = data.get('last_name', current_user.last_name)
        current_user.first_name = data.get('first_name', current_user.first_name)
        current_user.middle_name = data.get('middle_name', current_user.middle_name)
        try:
            db.session.commit()
            return jsonify({
                'message': 'Данные пользователя успешно обновлены',
                'user': {
                    'id': current_user.id,
                    'username': current_user.username,
                    'role': current_user.role,
                    'last_name': current_user.last_name,
                    'first_name': current_user.first_name,
                    'middle_name': current_user.middle_name
                }
            }), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка обновления данных пользователя {current_user.id}: {str(e)}")
            return jsonify({"error": "Ошибка при обновлении данных. Попробуйте позже."}), 500

@bp.route('/user/password', methods=['PUT'])
@login_required
def change_password():
    logger.debug(f"Получен PUT запрос для /user/password")
    data = request.get_json()
    current_password = data.get('current_password')
    new_password = data.get('new_password')

    if not check_password_hash(current_user.password_hash, current_password):
        return jsonify({'error': 'Текущий пароль неверен'}), 401

    current_user.password_hash = generate_password_hash(new_password)
    try:
        db.session.commit()
        return jsonify({'message': 'Пароль успешно изменён'}), 200
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка изменения пароля для пользователя {current_user.id}: {str(e)}")
        return jsonify({"error": "Ошибка при изменении пароля. Попробуйте позже."}), 500

@bp.route('/public/publications', methods=['GET'])
def get_public_publications():
    logger.debug(f"Получен GET запрос для /api/public/publications")
    
    # Параметры запроса для пагинации
    page = request.args.get('page', 1, type=int)  # Номер страницы, по умолчанию 1
    per_page = request.args.get('per_page', 10, type=int)  # Публикаций на страницу, по умолчанию 10

    # Базовый запрос для опубликованных работ
    # Используем coalesce для обработки NULL в published_at, чтобы приоритет был у updated_at
    query = Publication.query.filter_by(status='published').order_by(
        db.func.coalesce(Publication.published_at, Publication.updated_at).desc()
    )

    # Пагинация
    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    publications = pagination.items

    # Отладочный лог для проверки порядка
    logger.debug(f"Returning {len(publications)} published publications, sorted by published_at/updated_at: {[pub.published_at.isoformat() if pub.published_at else pub.updated_at.isoformat() for pub in publications]}")
    logger.debug(f"Total published publications: {pagination.total}, pages: {pagination.pages}, current page: {pagination.page}")

    # Форматирование ответа с данными пользователя
    response = [{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': pub.type,
        'status': pub.status,
        'file_url': pub.file_url,
        'updated_at': pub.updated_at.isoformat() if pub.updated_at else None,
        'published_at': pub.published_at.isoformat() if pub.published_at else None,
        'user': {
            'full_name': pub.user.full_name if pub.user else 'Не указан'
        } if pub.user else None  # Добавляем данные пользователя
    } for pub in publications]

    return jsonify({
        'publications': response,
        'total': pagination.total,  # Общее количество публикаций
        'pages': pagination.pages,  # Общее количество страниц
        'current_page': pagination.page  # Текущая страница
    }), 200

@bp.route('/publications', methods=['GET'])
@login_required
def get_publications():
    logger.debug(f"Получен GET запрос для /publications")
    
    # Параметры запроса
    page = request.args.get('page', 1, type=int)  # Номер страницы, по умолчанию 1
    per_page = request.args.get('per_page', 10, type=int)  # Публикаций на страницу, по умолчанию 10
    search = request.args.get('search', '').lower()  # Поиск по названию, авторам или году
    pub_type = request.args.get('type', 'all')  # Фильтр по типу
    status = request.args.get('status', 'all')  # Фильтр по статусу

    # Базовый запрос
    query = Publication.query.filter_by(user_id=current_user.id)

    # Логирование количества записей до фильтрации
    total_records_before_filters = query.count()
    logger.debug(f"Total records before filters: {total_records_before_filters}")

    # Фильтрация по поиску (по названию, авторам или году)
    if search:
        query = query.filter(
            db.or_(
                Publication.title.ilike(f'%{search}%'),
                Publication.authors.ilike(f'%{search}%'),
                db.cast(Publication.year, db.String).ilike(f'%{search}%')
            )
        )

    # Логирование количества записей после поиска
    total_records_after_search = query.count()
    logger.debug(f"Total records after search: {total_records_after_search}")

    # Фильтрация по типу
    if pub_type != 'all':
        query = query.filter(Publication.type == pub_type)

    # Логирование количества записей после фильтрации по типу
    total_records_after_type = query.count()
    logger.debug(f"Total records after type filter: {total_records_after_type}")

    # Фильтрация по статусу
    if status != 'all':
        query = query.filter(Publication.status == status)

    # Логирование количества записей после фильтрации по статусу
    total_records_after_status = query.count()
    logger.debug(f"Total records after status filter: {total_records_after_status}")

    # Сортировка по updated_at в порядке убывания (от новых к старым)
    query = query.order_by(Publication.updated_at.desc())

    # Пагинация
    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    publications = pagination.items

    # Логирование количества записей на текущей странице
    logger.debug(f"Publications on page {page}: {len(publications)}")

    # Форматирование ответа
    response = [{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': pub.type,
        'status': pub.status,
        'file_url': pub.file_url,
        'updated_at': pub.updated_at.isoformat() if pub.updated_at else None
    } for pub in publications]

    return jsonify({
        'publications': response,
        'total': pagination.total,  # Общее количество публикаций
        'pages': pagination.pages,  # Общее количество страниц
        'current_page': pagination.page  # Текущая страница
    }), 200

@bp.route('/publications/<int:pub_id>', methods=['PUT', 'DELETE'])
@login_required
def manage_publication(pub_id):
    logger.debug(f"Получен {request.method} запрос для /publications/{pub_id}")
    publication = Publication.query.get_or_404(pub_id)
    if publication.user_id != current_user.id:
        return jsonify({'error': 'У вас нет прав на управление этой публикацией'}), 403

    if request.method == 'PUT':
        if request.content_type == 'application/json':
            data = request.get_json()
        elif 'file' in request.files or request.content_type.startswith('multipart/form-data'):
            data = request.form
        else:
            return jsonify({"error": "Неподдерживаемый формат данных. Используйте application/json или multipart/form-data."}), 415

        old_status = publication.status  # Сохраняем старый статус
        if 'file' in request.files:
            file = request.files['file']
            if file and allowed_file(file.filename):
                if publication.file_url and os.path.exists(publication.file_url):
                    os.remove(publication.file_url)
                filename = secure_filename(file.filename)
                file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
                file.save(file_path)
                publication.file_url = file_path

        publication.title = data.get('title', publication.title)
        publication.authors = data.get('authors', publication.authors)
        publication.year = data.get('year', publication.year)
        publication.type = data.get('type', publication.type)
        new_status = data.get('status', publication.status)

        # Проверка: нельзя установить статус "published", если файл не прикреплён
        if new_status == 'published' and not publication.file_url:
            return jsonify({'error': 'Нельзя опубликовать работу без прикреплённого файла.'}), 400

        publication.status = new_status

        # Обновляем published_at только если статус меняется на 'published'
        if publication.status == 'published' and old_status != 'published':
            publication.published_at = datetime.utcnow()

        try:
            db.session.commit()
            return jsonify({
                'message': 'Публикация успешно обновлена',
                'publication': {
                    'id': publication.id,
                    'title': publication.title,
                    'authors': publication.authors,
                    'year': publication.year,
                    'type': publication.type,
                    'status': publication.status,
                    'file_url': publication.file_url,
                    'updated_at': publication.updated_at.isoformat() if publication.updated_at else None,
                    'published_at': publication.published_at.isoformat() if publication.published_at else None
                }
            }), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка обновления публикации {pub_id}: {str(e)}")
            return jsonify({"error": "Ошибка при обновлении публикации. Попробуйте позже."}), 500

    elif request.method == 'DELETE':
        try:
            if publication.file_url and os.path.exists(publication.file_url):
                os.remove(publication.file_url)
            db.session.delete(publication)
            db.session.commit()
            return jsonify({'message': 'Публикация успешно удалена'}), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка удаления публикации {pub_id}: {str(e)}")
            return jsonify({"error": "Ошибка при удалении публикации. Попробуйте позже."}), 500

@bp.route('/publications/upload-file', methods=['POST'])
@login_required
def upload_file():
    logger.debug(f"Получен POST запрос для /publications/upload-file")
    if 'file' not in request.files:
        return jsonify({'error': 'Файл не предоставлен'}), 400

    file = request.files['file']
    if not file or not allowed_file(file.filename):
        return jsonify({'error': 'Недопустимый файл'}), 400

    title = request.form.get('title')
    authors = request.form.get('authors')
    year = request.form.get('year')
    type = request.form.get('type', 'article')
    
    if not title or not authors or not year:
        return jsonify({'error': 'Название, авторы и год обязательны'}), 400

    try:
        year = int(year)
        if year < 1900 or year > datetime.now().year:
            return jsonify({'error': 'Недопустимый год'}), 400
    except ValueError:
        return jsonify({'error': 'Год должен быть числом'}), 400

    filename = secure_filename(file.filename)
    file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
    file.save(file_path)

    publication = Publication(
        title=title,
        authors=authors,
        year=year,
        type=type,
        status='draft',  # По умолчанию статус "draft", даже если файл есть
        file_url=file_path,
        user_id=current_user.id
    )
    db.session.add(publication)
    db.session.commit()

    return jsonify({
        'message': 'Публикация успешно загружена',
        'publication': {
            'id': publication.id,
            'title': publication.title,
            'authors': publication.authors,
            'year': publication.year,
            'type': publication.type,
            'status': publication.status,
            'file_url': publication.file_url,
            'updated_at': publication.updated_at.isoformat() if publication.updated_at else None
        }
    }), 200
@bp.route('/publications/upload-bibtex', methods=['POST'])
@login_required
def upload_bibtex():
    logger.debug(f"Получен POST запрос для /publications/upload-bibtex")
    if 'file' not in request.files:
        return jsonify({'error': 'BibTeX файл не предоставлен'}), 400

    file = request.files['file']
    if file and file.filename.endswith('.bib'):
        try:
            content = file.read().decode('utf-8')
            bib_database = bibtexparser.loads(content)
            publications_added = 0

            for entry in bib_database.entries:
                title = entry.get('title', 'Без названия')
                authors = entry.get('author', 'Неизвестный автор')
                year = entry.get('year', datetime.now().year)
                try:
                    year = int(year)
                except (ValueError, TypeError):
                    year = datetime.now().year
                type = entry.get('entrytype', 'article')

                publication = Publication(
                    title=title,
                    authors=authors,
                    year=year,
                    type=type,
                    status='draft',  # По умолчанию статус "draft", так как файла нет
                    user_id=current_user.id
                )
                db.session.add(publication)
                publications_added += 1

            db.session.commit()
            return jsonify({'message': f'Обработано {publications_added} публикаций'}), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка обработки BibTeX: {str(e)}")
            return jsonify({'error': 'Ошибка при обработке BibTeX файла'}), 500
    return jsonify({'error': 'Недопустимый файл. Ожидается .bib'}), 400

@bp.route('/publications/<int:pub_id>/attach-file', methods=['POST'])
@login_required
def attach_file(pub_id):
    logger.debug(f"Получен POST запрос для /publications/{pub_id}/attach-file")
    publication = Publication.query.get_or_404(pub_id)
    if publication.user_id != current_user.id:
        return jsonify({'error': 'У вас нет прав на изменение этой публикации'}), 403

    if 'file' not in request.files:
        return jsonify({'error': 'Файл не предоставлен'}), 400

    file = request.files['file']
    if file and allowed_file(file.filename):
        if publication.file_url and os.path.exists(publication.file_url):
            os.remove(publication.file_url)
        filename = secure_filename(file.filename)
        file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
        file.save(file_path)
        publication.file_url = file_path

        try:
            db.session.commit()
            return jsonify({
                'message': 'Файл успешно прикреплен',
                'publication': {
                    'id': publication.id,
                    'title': publication.title,
                    'authors': publication.authors,
                    'year': publication.year,
                    'type': publication.type,
                    'status': publication.status,
                    'file_url': publication.file_url,
                    'updated_at': publication.updated_at.isoformat() if publication.updated_at else None
                }
            }), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка прикрепления файла к публикации {pub_id}: {str(e)}")
            return jsonify({"error": "Ошибка при прикреплении файла. Попробуйте позже."}), 500
    return jsonify({'error': 'Недопустимый файл'}), 400

@bp.route('/publications/export-bibtex', methods=['GET'])
@login_required
def export_bibtex():
    logger.debug(f"Получен GET запрос для /publications/export-bibtex")
    try:
        logger.debug("Начинаем запрос публикаций для текущего пользователя")
        publications = Publication.query.filter_by(user_id=current_user.id).all()
        logger.debug(f"Найдено публикаций: {len(publications)}")

        # Создаём экземпляр BibDatabase
        bib_db = BibDatabase()
        bib_db.entries = [{
            'ENTRYTYPE': pub.type or 'article',
            'ID': f'pub{pub.id}',
            'title': pub.title or 'Без названия',
            'author': pub.authors or 'Неизвестный автор',
            'year': str(pub.year) if pub.year else str(datetime.now().year)
        } for pub in publications]

        # Создаём экземпляр BibTexWriter и генерируем строку BibTeX
        writer = BibTexWriter()
        if not callable(writer.write):
            raise AttributeError("Метод write в BibTexWriter не является callable. Проверьте версию bibtexparser.")

        bibtex_str = writer.write(bib_db)
        
        response = make_response(bibtex_str)
        response.headers['Content-Disposition'] = 'attachment; filename=publications.bib'
        response.headers['Content-Type'] = 'application/x-bibtex'
        logger.debug("BibTeX успешно сгенерирован и отправлен")
        return response
    except ImportError as e:
        logger.error(f"Ошибка импорта bibtexparser: {str(e)}")
        return jsonify({'error': 'Ошибка импорта библиотеки bibtexparser. Установите или обновите bibtexparser (>=1.4.0).'}), 500
    except AttributeError as e:
        logger.error(f"Ошибка атрибута в bibtexparser: {str(e)}")
        return jsonify({'error': 'Ошибка в библиотеке bibtexparser. Проверьте установку и версию.'}), 500
    except Exception as e:
        logger.error(f"Ошибка экспорта BibTeX: {str(e)}")
        return jsonify({'error': f'Внутренняя ошибка сервера при экспорте BibTeX: {str(e)}'}), 500

@bp.route('/analytics/yearly', methods=['GET'])
@login_required
def get_analytics_yearly():
    logger.debug(f"Получен GET запрос для /analytics/yearly")
    analytics = get_publications_by_year(current_user.id)  # Используем ID текущего пользователя
    return jsonify([{
        'year': year,
        'count': count
    } for year, count in analytics]), 200