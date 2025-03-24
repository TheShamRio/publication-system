from flask import Blueprint, jsonify, request, make_response, current_app, send_file
from .extensions import db, login_manager, csrf
from .models import User, Publication, Comment, Plan, PlanEntry
from .utils import allowed_file
from flask_login import login_user, current_user, logout_user, login_required
from werkzeug.utils import secure_filename
from flask_wtf.csrf import generate_csrf
import os
from .analytics import get_publications_by_year
import bibtexparser
from reportlab.platypus import SimpleDocTemplate, Paragraph
from reportlab.lib.pagesizes import letter
from bibtexparser.bibdatabase import BibDatabase
from bibtexparser.bwriter import BibTexWriter
import logging
from datetime import datetime, UTC
from werkzeug.security import generate_password_hash, check_password_hash

bp = Blueprint('api', __name__, url_prefix='/api')

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

@bp.route('/uploads/<path:filename>')
def download_file(filename):
    file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
    logger.debug(f"Serving file from {file_path}")
    if not os.path.exists(file_path):
        logger.error(f"File not found: {file_path}")
        return jsonify({'error': 'Файл не найден'}), 404
    response = send_file(file_path, as_attachment=True)
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response

@bp.route('/publications/<int:pub_id>', methods=['GET'])
@login_required
def get_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)

    if publication.user_id != current_user.id and current_user.role not in ['admin', 'manager']:
        logger.warning(f"Unauthorized access attempt to publication {pub_id} by user {current_user.id} with role {current_user.role}")
        return jsonify({"error": "У вас нет прав для просмотра этой публикации."}), 403

    comments = Comment.query.filter_by(publication_id=pub_id, parent_id=None).order_by(Comment.created_at.asc()).all()
    
    def build_comment_tree(comment):
        return {
            'id': comment.id,
            'content': comment.content,
            'user': {'username': comment.user.username, 'full_name': comment.user.full_name, 'role': comment.user.role},
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
        'file_url': publication.file_url if publication.file_url else None,
        'user': {
            'id': publication.user.id if publication.user else None,
            'full_name': publication.user.full_name if publication.user else None},
        'updated_at': publication.updated_at.isoformat() if publication.updated_at else None,
        'published_at': publication.published_at.isoformat() if publication.published_at else None,
        'returned_for_revision': publication.returned_for_revision,
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
            'user': {'username': current_user.username, 'full_name': current_user.full_name, 'role': current_user.role},
            'created_at': comment.created_at.isoformat(),
            'replies': []
        }
    }), 201

@bp.route('/publications/<int:pub_id>/submit-for-review', methods=['POST'])
@login_required
def submit_for_review(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    
    if publication.user_id != current_user.id:
        logger.warning(f"Несанкционированная попытка отправить публикацию {pub_id} на проверку пользователем {current_user.id}")
        return jsonify({'error': 'У вас нет прав на отправку этой публикации на проверку'}), 403

    if publication.status not in ['draft', 'returned_for_revision']:
        logger.debug(f"Публикация {pub_id} со статусом {publication.status} не может быть отправлена на проверку")
        return jsonify({'error': 'Публикация уже отправлена на проверку или опубликована'}), 400

    if not publication.file_url:
        logger.debug(f"Попытка отправить публикацию {pub_id} без файла")
        return jsonify({'error': 'Нельзя отправить на проверку публикацию без прикреплённого файла'}), 400

    publication.status = 'needs_review'
    publication.updated_at = datetime.utcnow()
    publication.returned_for_revision = False

    try:
        db.session.commit()
        logger.debug(f"Публикация {pub_id} успешно отправлена на проверку пользователем {current_user.id}")
        return jsonify({'message': 'Публикация отправлена на проверку'}), 200
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка отправки на проверку публикации {pub_id}: {str(e)}")
        return jsonify({'error': 'Ошибка при отправке на проверку. Попробуйте позже.'}), 500

@bp.route('/publications/<int:pub_id>/publish', methods=['POST'])
@login_required
def publish_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)

    if current_user.role not in ['admin', 'manager']:
        logger.warning(f"Несанкционированная попытка опубликовать публикацию {pub_id} пользователем {current_user.id} с ролью {current_user.role}")
        return jsonify({"error": "У вас нет прав для публикации этой работы."}), 403

    if publication.status != 'needs_review':
        return jsonify({"error": "Публикация не находится на стадии проверки."}), 400

    if not publication.file_url:
        return jsonify({"error": "Нельзя опубликовать работу без прикреплённого файла."}), 400

    publication.status = 'published'
    publication.published_at = datetime.utcnow()
    publication.returned_for_revision = False

    try:
        db.session.commit()
        logger.debug(f"Публикация {pub_id} успешно опубликована пользователем {current_user.id}")
        return jsonify({
            'message': 'Публикация успешно опубликована',
            'publication': {
                'id': publication.id,
                'title': publication.title,
                'status': publication.status,
                'published_at': publication.published_at.isoformat()
            }
        }), 200
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка при публикации публикации {pub_id}: {str(e)}")
        return jsonify({"error": "Ошибка при публикации. Попробуйте позже."}), 500

@bp.route('/publications/<int:pub_id>/return-for-revision', methods=['POST'])
@login_required
def return_for_revision(pub_id):
    publication = Publication.query.get_or_404(pub_id)

    if current_user.role not in ['admin', 'manager']:
        logger.warning(f"Несанкционированная попытка вернуть публикацию {pub_id} на доработку пользователем {current_user.id} с ролью {current_user.role}")
        return jsonify({"error": "У вас нет прав для возврата этой работы на доработку."}), 403

    if publication.status != 'needs_review':
        return jsonify({"error": "Публикация не находится на стадии проверки."}), 400

    comments = Comment.query.filter_by(publication_id=pub_id).all()
    has_reviewer_comment = any(
        comment.user.role in ['admin', 'manager'] or any(reply.user.role in ['admin', 'manager'] for reply in comment.replies)
        for comment in comments
    )
    if not has_reviewer_comment:
        return jsonify({"error": "Необходимо добавить комментарий перед возвратом на доработку."}), 400

    # Исправляем статус на 'returned_for_revision'
    publication.status = 'returned_for_revision'
    publication.returned_for_revision = True
    publication.published_at = None

    try:
        db.session.commit()
        logger.debug(f"Публикация {pub_id} возвращена на доработку пользователем {current_user.id}")
        return jsonify({
            'message': 'Публикация отправлена на доработку',
            'publication': {
                'id': publication.id,
                'title': publication.title,
                'status': publication.status,
                'returned_for_revision': publication.returned_for_revision
            }
        }), 200
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка при возврате публикации {pub_id} на доработку: {str(e)}")
        return jsonify({"error": "Ошибка при возврате на доработку. Попробуйте позже."}), 500
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

@bp.route('/csrf-token', methods=['GET'])
def get_csrf_token():
    logger.debug(f"Получен GET запрос для /api/csrf-token")
    token = generate_csrf()
    return jsonify({'csrf_token': token}), 200

@bp.route('/logout', methods=['POST'])
@login_required
def logout():
    logger.debug(f"Получен POST запрос для /logout")
    logout_user()
    response = jsonify({'message': 'Успешный выход'})
    response.set_cookie('session', '', expires=0)
    return response, 200

@bp.route('/user', methods=['GET', 'PUT'])
@login_required
def user():
    logger.debug(f"Получен {request.method} запрос для /user")
    logger.debug(f"Текущий пользователь: {current_user.id if current_user.is_authenticated else 'Не аутентифицирован'}")
    logger.debug(f"Куки сессии: {request.cookies.get('session')}")
    if request.method == 'GET':
        response_data = {
            'id': current_user.id,
            'username': current_user.username,
            'role': current_user.role,
            'last_name': current_user.last_name,
            'first_name': current_user.first_name,
            'middle_name': current_user.middle_name,
            'created_at': current_user.created_at.isoformat() if current_user.created_at else None
        }
        logger.debug(f"Ответ сервера для /api/user: {response_data}")
        return jsonify(response_data), 200
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
    
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)

    query = Publication.query.filter_by(status='published').order_by(
        db.func.coalesce(Publication.published_at, Publication.updated_at).desc()
    )

    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    publications = pagination.items

    logger.debug(f"Returning {len(publications)} published publications, sorted by published_at/updated_at: {[pub.published_at.isoformat() if pub.published_at else pub.updated_at.isoformat() for pub in publications]}")
    logger.debug(f"Total published publications: {pagination.total}, pages: {pagination.pages}, current page: {pagination.page}")

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
        'returned_for_revision': pub.returned_for_revision,
        'user': {
            'full_name': pub.user.full_name if pub.user else 'Не указан'
        } if pub.user else None
    } for pub in publications]

    return jsonify({
        'publications': response,
        'total': pagination.total,
        'pages': pagination.pages,
        'current_page': pagination.page
    }), 200

@bp.route('/publications', methods=['GET'])
@login_required
def get_publications():
    logger.debug(f"Получен GET запрос для /publications")
    
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '').lower()
    pub_type = request.args.get('type', 'all')
    status = request.args.get('status', 'all')

    query = Publication.query.filter_by(user_id=current_user.id)

    total_records_before_filters = query.count()
    logger.debug(f"Total records before filters: {total_records_before_filters}")

    if search:
        query = query.filter(
            db.or_(
                Publication.title.ilike(f'%{search}%'),
                Publication.authors.ilike(f'%{search}%'),
                db.cast(Publication.year, db.String).ilike(f'%{search}%')
            )
        )

    total_records_after_search = query.count()
    logger.debug(f"Total records after search: {total_records_after_search}")

    if pub_type != 'all':
        query = query.filter(Publication.type == pub_type)

    total_records_after_type = query.count()
    logger.debug(f"Total records after type filter: {total_records_after_type}")

    if status != 'all':
        query = query.filter(Publication.status == status)

    total_records_after_status = query.count()
    logger.debug(f"Total records after status filter: {total_records_after_status}")

    query = query.order_by(Publication.updated_at.desc())

    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    publications = pagination.items

    logger.debug(f"Publications on page {page}: {len(publications)}")

    response = [{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': pub.type,
        'status': pub.status,
        'file_url': pub.file_url,
        'updated_at': pub.updated_at.isoformat() if pub.updated_at else None,
        'returned_for_revision': pub.returned_for_revision,
    } for pub in publications]

    return jsonify({
        'publications': response,
        'total': pagination.total,
        'pages': pagination.pages,
        'current_page': pagination.page
    }), 200

@bp.route('/publications/<int:pub_id>', methods=['PUT', 'DELETE'])
@login_required
def manage_publication(pub_id):
    logger.debug(f"Получен {request.method} запрос для /publications/{pub_id}")
    publication = Publication.query.get_or_404(pub_id)
    if publication.user_id != current_user.id:
        return jsonify({'error': 'У вас нет прав на управление этой публикацией'}), 403

    if publication.status == 'needs_review':
        return jsonify({'error': 'Нельзя редактировать публикацию, пока она на проверке'}), 403

    if request.method == 'PUT':
        if request.content_type == 'application/json':
            data = request.get_json()
        elif 'file' in request.files or request.content_type.startswith('multipart/form-data'):
            data = request.form
        else:
            return jsonify({"error": "Неподдерживаемый формат данных. Используйте application/json или multipart/form-data."}), 415

        old_status = publication.status

        if 'file' in request.files:
            file = request.files['file']
            if file and allowed_file(file.filename):
                if publication.file_url:
                    old_file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], publication.file_url.split('/')[-1])
                    if os.path.exists(old_file_path):
                        os.remove(old_file_path)
                filename = secure_filename(file.filename)
                file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
                if os.path.exists(file_path):
                    base, extension = os.path.splitext(filename)
                    counter = 1
                    while os.path.exists(file_path):
                        filename = f"{base}_{counter}{extension}"
                        file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
                        counter += 1
                file.save(file_path)
                publication.file_url = f"/uploads/{filename}"

        publication.title = data.get('title', publication.title)
        publication.authors = data.get('authors', publication.authors)
        publication.year = data.get('year', publication.year)
        publication.type = data.get('type', publication.type)
        new_status = data.get('status', publication.status)

        if new_status == 'published' and not publication.file_url:
            return jsonify({'error': 'Нельзя опубликовать работу без прикреплённого файла.'}), 400

        publication.status = new_status

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
                    'published_at': publication.published_at.isoformat() if publication.published_at else None,
                    'returned_for_revision': publication.returned_for_revision,
                }
            }), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка обновления публикации {pub_id}: {str(e)}")
            return jsonify({"error": "Ошибка при обновлении публикации. Попробуйте позже."}), 500

    elif request.method == 'DELETE':
        try:
            if publication.file_url:
                file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], publication.file_url.split('/')[-1])
                if os.path.exists(file_path):
                    os.remove(file_path)
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
    if os.path.exists(file_path):
        base, extension = os.path.splitext(filename)
        counter = 1
        while os.path.exists(file_path):
            filename = f"{base}_{counter}{extension}"
            file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
            counter += 1
    file.save(file_path)

    publication = Publication(
        title=title,
        authors=authors,
        year=year,
        type=type,
        status='draft',
        file_url=f"/uploads/{filename}",
        user_id=current_user.id,
        returned_for_revision=False,
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
            'updated_at': publication.updated_at.isoformat() if publication.updated_at else None,
            'returned_for_revision': publication.returned_for_revision,
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
                    status='draft',
                    user_id=current_user.id,
                    returned_for_revision=False,
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

    if publication.status == 'needs_review':
        return jsonify({'error': 'Нельзя редактировать публикацию, пока она на проверке'}), 403

    if 'file' not in request.files:
        return jsonify({'error': 'Файл не предоставлен'}), 400

    file = request.files['file']
    if file and allowed_file(file.filename):
        if publication.file_url:
            old_file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], publication.file_url.split('/')[-1])
            if os.path.exists(old_file_path):
                os.remove(old_file_path)
        filename = secure_filename(file.filename)
        file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
        if os.path.exists(file_path):
            base, extension = os.path.splitext(filename)
            counter = 1
            while os.path.exists(file_path):
                filename = f"{base}_{counter}{extension}"
                file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
                counter += 1
        file.save(file_path)
        publication.file_url = f"/uploads/{filename}"

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
                    'updated_at': publication.updated_at.isoformat() if publication.updated_at else None,
                    'returned_for_revision': publication.returned_for_revision,
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

        bib_db = BibDatabase()
        bib_db.entries = [{
            'ENTRYTYPE': pub.type or 'article',
            'ID': f'pub{pub.id}',
            'title': pub.title or 'Без названия',
            'author': pub.authors or 'Неизвестный автор',
            'year': str(pub.year) if pub.year else str(datetime.now().year)
        } for pub in publications]

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
    analytics = get_publications_by_year(current_user.id)
    return jsonify([{
        'year': year,
        'count': count
    } for year, count in analytics]), 200

@bp.route('/plans', methods=['GET'])
@login_required
def get_plans():
    logger.debug(f"Получен GET запрос для /plans")
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    plans = Plan.query.filter_by(user_id=current_user.id).order_by(Plan.year.desc()).paginate(page=page, per_page=per_page)
    return jsonify({
        'plans': [plan.to_dict() for plan in plans.items],
        'total': plans.total,
        'pages': plans.pages,
        'current_page': plans.page
    })

@bp.route('/plans', methods=['POST'])
@login_required
def create_plan():
    logger.debug(f"Получен POST запрос для /plans")
    data = request.get_json()
    if not all(k in data for k in ('year', 'expectedCount', 'fillType', 'entries')):
        return jsonify({'error': 'Missing required fields'}), 400
    
    if not isinstance(data['year'], int) or data['year'] < 1900 or data['year'] > 2100:
        return jsonify({'error': 'Invalid year'}), 400
    
    if not isinstance(data['expectedCount'], int) or data['expectedCount'] < 1:
        return jsonify({'error': 'Expected count must be at least 1'}), 400
    
    if data['fillType'] not in ['manual', 'link']:
        return jsonify({'error': 'Invalid fill type'}), 400

    plan = Plan(
        year=data['year'],
        expectedCount=data['expectedCount'],
        fillType=data['fillType'],
        user_id=current_user.id,
        status='draft'
    )
    db.session.add(plan)

    for entry_data in data['entries']:
        entry = PlanEntry(
            title=entry_data.get('title'),
            type=entry_data.get('type'),
            publication_id=entry_data.get('publication_id'),
            status=entry_data.get('status', 'planned'),
            isPostApproval=False,
            plan=plan
        )
        if entry.publication_id:
            publication = Publication.query.filter_by(id=entry.publication_id, user_id=current_user.id, status='published').first()
            if not publication:
                db.session.rollback()
                return jsonify({'error': f'Publication with ID {entry.publication_id} not found or not published'}), 404
        db.session.add(entry)

    db.session.commit()
    return jsonify({'message': f'Plan created with ID {plan.id}', 'plan': plan.to_dict()}), 201

@bp.route('/plans/<int:plan_id>', methods=['PUT'])
@login_required
def update_plan(plan_id):
    logger.debug(f"Получен PUT запрос для /plans/{plan_id}")
    plan = Plan.query.filter_by(id=plan_id, user_id=current_user.id).first()
    if not plan:
        return jsonify({'error': 'Plan not found or unauthorized'}), 404
    
    if plan.status not in ['draft', 'returned', 'approved']:
        return jsonify({'error': 'Cannot edit plan that is under review'}), 403

    data = request.get_json()
    if not all(k in data for k in ('year', 'expectedCount', 'fillType', 'entries')):
        return jsonify({'error': 'Missing required fields'}), 400
    
    if not isinstance(data['year'], int) or data['year'] < 1900 or data['year'] > 2100:
        return jsonify({'error': 'Invalid year'}), 400
    
    if data['fillType'] not in ['manual', 'link']:
        return jsonify({'error': 'Invalid fill type'}), 400

    if plan.status == 'approved':
        existing_entries = {entry.id: entry for entry in plan.entries}
        new_entries = []
        for entry_data in data['entries']:
            entry_id = entry_data.get('id')
            if entry_id and entry_id in existing_entries:
                entry = existing_entries[entry_id]
                entry.title = entry_data.get('title', entry.title)
                entry.type = entry_data.get('type', entry.type)
                entry.publication_id = entry_data.get('publication_id', entry.publication_id)
                entry.status = entry_data.get('status', entry.status)
                if entry.publication_id:
                    publication = Publication.query.filter_by(id=entry.publication_id, user_id=current_user.id, status='published').first()
                    if not publication:
                        db.session.rollback()
                        return jsonify({'error': f'Publication with ID {entry.publication_id} not found or not published'}), 404
            else:
                new_entry = PlanEntry(
                    title=entry_data.get('title', ''),
                    type=entry_data.get('type', 'article'),
                    publication_id=entry_data.get('publication_id'),
                    status=entry_data.get('status', 'planned'),
                    isPostApproval=True,
                    plan=plan
                )
                if new_entry.publication_id:
                    publication = Publication.query.filter_by(id=new_entry.publication_id, user_id=current_user.id, status='published').first()
                    if not publication:
                        db.session.rollback()
                        return jsonify({'error': f'Publication with ID {new_entry.publication_id} not found or not published'}), 404
                new_entries.append(new_entry)
                db.session.add(new_entry)
    else:
        plan.year = data['year']
        plan.fillType = data['fillType']
        PlanEntry.query.filter_by(plan_id=plan.id).delete()
        for entry_data in data['entries']:
            entry = PlanEntry(
                title=entry_data.get('title'),
                type=entry_data.get('type'),
                publication_id=entry_data.get('publication_id'),
                status=entry_data.get('status', 'planned'),
                isPostApproval=False,
                plan=plan
            )
            if entry.publication_id:
                publication = Publication.query.filter_by(id=entry.publication_id, user_id=current_user.id, status='published').first()
                if not publication:
                    db.session.rollback()
                    return jsonify({'error': f'Publication with ID {entry.publication_id} not found or not published'}), 404
            db.session.add(entry)

    db.session.commit()
    return jsonify({'message': 'Plan updated successfully', 'plan': plan.to_dict()}), 200

@bp.route('/plans/<int:plan_id>', methods=['DELETE'])
@login_required
def delete_plan(plan_id):
    logger.debug(f"Получен DELETE запрос для /plans/{plan_id}")
    plan = Plan.query.filter_by(id=plan_id, user_id=current_user.id).first()
    if not plan:
        return jsonify({'error': 'Plan not found or unauthorized'}), 404
    
    if plan.status not in ['draft', 'returned']:
        return jsonify({'error': 'Cannot delete plan that is under review or approved'}), 403

    db.session.delete(plan)
    db.session.commit()
    return jsonify({'message': 'Plan deleted successfully'}), 200

@bp.route('/plans/<int:plan_id>/submit-for-review', methods=['POST'])
@login_required
def submit_plan_for_review(plan_id):
    logger.debug(f"Получен POST запрос для /plans/{plan_id}/submit-for-review")
    plan = Plan.query.filter_by(id=plan_id, user_id=current_user.id).first()
    if not plan:
        return jsonify({'error': 'Plan not found or unauthorized'}), 404
    
    if plan.status not in ['draft', 'returned']:
        return jsonify({'error': 'План уже отправлен на проверку или утверждён'}), 400
    
    if not all(entry.title and entry.title.strip() for entry in plan.entries):
        return jsonify({'error': 'Все записи плана должны иметь заполненные заголовки'}), 400

    plan.status = 'needs_review'
    db.session.commit()
    return jsonify({'message': 'План отправлен на проверку', 'plan': plan.to_dict()}), 200

@bp.route('/plans/<int:plan_id>/entries/<int:entry_id>/link', methods=['POST'])
@login_required
def link_publication_to_plan_entry(plan_id, entry_id):
    logger.debug(f"Получен POST запрос для /plans/{plan_id}/entries/{entry_id}/link")
    plan = Plan.query.filter_by(id=plan_id, user_id=current_user.id).first()
    if not plan:
        return jsonify({'error': 'Plan not found or unauthorized'}), 404
    
    entry = PlanEntry.query.filter_by(id=entry_id, plan_id=plan_id).first()
    if not entry:
        return jsonify({'error': 'Entry not found'}), 404
    
    if plan.status != 'approved':
        return jsonify({'error': 'Can only link publications to approved plans'}), 403
    
    if entry.publication_id:
        return jsonify({'error': 'Entry already linked to a publication'}), 400

    data = request.get_json()
    publication_id = data.get('publication_id')
    if not publication_id:
        return jsonify({'error': 'Publication ID is required'}), 400

    publication = Publication.query.filter_by(id=publication_id, user_id=current_user.id, status='published').first()
    if not publication:
        return jsonify({'error': f'Publication with ID {publication_id} not found or not published'}), 404

    existing_link = PlanEntry.query.filter_by(publication_id=publication_id).first()
    if existing_link:
        return jsonify({'error': f'Publication with ID {publication_id} is already linked to another plan entry'}), 400

    entry.publication_id = publication_id
    entry.status = 'completed'
    db.session.commit()
    return jsonify({'message': 'Publication linked successfully', 'entry': entry.to_dict()}), 200

@bp.route('/plans/<int:plan_id>/entries/<int:entry_id>/unlink', methods=['POST'])
@login_required
def unlink_publication_from_plan_entry(plan_id, entry_id):
    logger.debug(f"Получен POST запрос для /plans/{plan_id}/entries/{entry_id}/unlink")
    plan = Plan.query.filter_by(id=plan_id, user_id=current_user.id).first()
    if not plan:
        return jsonify({'error': 'Plan not found or unauthorized'}), 404
    
    entry = PlanEntry.query.filter_by(id=entry_id, plan_id=plan_id).first()
    if not entry:
        return jsonify({'error': 'Entry not found'}), 404
    
    if plan.status != 'approved':
        return jsonify({'error': 'Can only unlink publications from approved plans'}), 403
    
    if not entry.publication_id:
        return jsonify({'error': 'No publication linked to this entry'}), 400

    entry.publication_id = None
    entry.status = 'planned'
    db.session.commit()
    return jsonify({'message': 'Publication unlinked successfully', 'entry': entry.to_dict()}), 200