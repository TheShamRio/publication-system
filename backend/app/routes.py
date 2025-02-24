from flask import Blueprint, jsonify, request, make_response
from .extensions import db, login_manager, csrf
from .models import User, Publication
from .utils import allowed_file
from flask_login import login_user, current_user, logout_user, login_required
from werkzeug.utils import secure_filename
from flask_wtf.csrf import generate_csrf  # Добавляем импорт generate_csrf
import os
import logging
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from .analytics import get_publications_by_year
import bibtexparser

bp = Blueprint('api', __name__)

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

@bp.route('/login', methods=['POST'])
@csrf.exempt
def login():
    logger.debug(f"Получен POST запрос для /login")
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    user = User.query.filter_by(username=username).first()
    if user and check_password_hash(user.password_hash, password):
        login_user(user)
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

@bp.route('/csrf-token', methods=['GET'])
@login_required
def get_csrf_token():
    logger.debug(f"Получен GET запрос для /api/csrf-token")
    token = generate_csrf()  # Используем функцию generate_csrf()
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
    publications = Publication.query.filter_by(status='published').all()
    return jsonify([{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': pub.type,
        'status': pub.status,
        'file_url': pub.file_url,
        'updated_at': pub.updated_at.isoformat() if pub.updated_at else None
    } for pub in publications]), 200

@bp.route('/publications', methods=['GET'])
@login_required
def get_publications():
    logger.debug(f"Получен GET запрос для /publications")
    publications = Publication.query.filter_by(user_id=current_user.id).all()
    return jsonify([{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': pub.type,
        'status': pub.status,
        'file_url': pub.file_url,
        'updated_at': pub.updated_at.isoformat() if pub.updated_at else None
    } for pub in publications]), 200

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
        publication.status = data.get('status', publication.status)

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
                    'file_url': publication.file_url
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
    if file and allowed_file(file.filename):
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
            status='draft',
            file_url=file_path,
            user_id=current_user.id
        )
        db.session.add(publication)
        db.session.commit()

        return jsonify({'message': 'Публикация успешно загружена'}), 200
    return jsonify({'error': 'Недопустимый файл'}), 400

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
                    status='draft',
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
            return jsonify({'message': 'Файл успешно прикреплен'}), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка прикрепления файла к публикации {pub_id}: {str(e)}")
            return jsonify({"error": "Ошибка при прикреплении файла. Попробуйте позже."}), 500
    return jsonify({'error': 'Недопустимый файл'}), 400

@bp.route('/publications/export-bibtex', methods=['GET'])
@login_required
def export_bibtex():
    logger.debug(f"Получен GET запрос для /publications/export-bibtex")
    publications = Publication.query.filter_by(user_id=current_user.id).all()
    bibtex = bibtexparser.BibDatabase()
    bibtex.entries = [{
        'entrytype': pub.type,
        'id': f'pub{pub.id}',
        'title': pub.title,
        'author': pub.authors,
        'year': str(pub.year)
    } for pub in publications]
    writer = bibtexparser.BibTexWriter()
    bibtex_str = writer.write(bibtex)
    response = make_response(bibtex_str)
    response.headers['Content-Disposition'] = 'attachment; filename=publications.bib'
    response.headers['Content-Type'] = 'application/x-bibtex'
    return response

@bp.route('/analytics/yearly', methods=['GET'])
@login_required
def get_analytics_yearly():
    logger.debug(f"Получен GET запрос для /analytics/yearly")
    analytics = get_publications_by_year(current_user.id)
    return jsonify([{
        'year': year,
        'count': count
    } for year, count in analytics]), 200