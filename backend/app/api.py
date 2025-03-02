from flask import Blueprint, jsonify, request
from .extensions import db
from .models import Publication, User
from .utils import allowed_file
import bibtexparser
from flask_login import login_user, current_user, logout_user, login_required
from .middleware import admin_required
from .analytics import get_publications_by_year
from flask import current_app
from werkzeug.utils import secure_filename
import os
import logging
import secrets
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from sqlalchemy import func, desc
from functools import wraps

bp = Blueprint('admin_api', __name__)

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

@bp.before_request
def log_request():
    logger.debug(f"Received request for {request.path} with method {request.method}")

@bp.route('/admin/register', methods=['POST', 'OPTIONS'])
@login_required
@admin_required
def admin_register():
    if request.method == 'OPTIONS':
        logger.debug("Handling OPTIONS for /admin_api/admin/register")
        return jsonify({}), 200

    logger.debug("Получен POST запрос для /admin_api/admin/register")
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    last_name = data.get('last_name')
    first_name = data.get('first_name')
    middle_name = data.get('middle_name')

    if not username or not password or not last_name or not first_name or not middle_name:
        logger.error("Не все обязательные поля заполнены")
        return jsonify({'error': 'Все поля (логин, пароль, ФИО) обязательны'}), 400

    if User.query.filter_by(username=username).first():
        logger.error(f"Пользователь с логином {username} уже существует")
        return jsonify({'error': 'Пользователь с таким логином уже существует'}), 400

    user = User(
        username=username,
        last_name=last_name,
        first_name=first_name,
        middle_name=middle_name,
        role='user'  # Устанавливаем роль user по умолчанию
    )
    user.set_password(password)
    try:
        db.session.add(user)
        db.session.commit()
        logger.info(f"Пользователь {username} успешно зарегистрирован администратором")
        return jsonify({
            'message': 'Пользователь успешно зарегистрирован',
            'user': {
                'username': user.username,
                'role': user.role,
                'last_name': user.last_name,
                'first_name': user.first_name,
                'middle_name': user.middle_name
            }
        }), 201
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка регистрации пользователя {username}: {str(e)}")
        return jsonify({'error': 'Ошибка при регистрации. Попробуйте позже.'}), 500

@bp.route('/admin/check-username', methods=['POST', 'OPTIONS'])
@login_required
@admin_required
def check_username():
    if request.method == 'OPTIONS':
        logger.debug("Handling OPTIONS for /admin_api/admin/check-username")
        return jsonify({}), 200

    logger.debug("Получен POST запрос для /admin_api/admin/check-username")
    data = request.get_json()
    username = data.get('username')

    if not username:
        return jsonify({'error': 'Логин не указан'}), 400

    user = User.query.filter_by(username=username).first()
    if user:
        return jsonify({'exists': True, 'message': 'Пользователь с таким логином уже существует'}), 200
    return jsonify({'exists': False, 'message': 'Логин доступен'}), 200

@bp.route('/admin/generate-password', methods=['GET', 'OPTIONS'])
@login_required
@admin_required
def generate_password():
    if request.method == 'OPTIONS':
        logger.debug("Handling OPTIONS for /admin_api/admin/generate-password")
        return jsonify({}), 200

    logger.debug("Получен GET запрос для /admin_api/admin/generate-password")
    
    # Генерация надёжного пароля
    chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+'
    password_length = 12
    password = ''.join(secrets.choice(chars) for _ in range(password_length))
    
    return jsonify({'password': password}), 200

@bp.route('/admin/users', methods=['GET', 'OPTIONS'])
@login_required
@admin_required
def get_all_users():
    if request.method == 'OPTIONS':
        logger.debug("Handling OPTIONS for /admin_api/admin/users")
        return jsonify({}), 200

    logger.debug(f"Получен GET запрос для /admin_api/admin/users")
    logger.debug(f"Current user: {current_user}, Role: {current_user.role if current_user.is_authenticated else 'Not authenticated'}")
    
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '').lower()
    
    # Базовый запрос
    query = User.query
    
    # Фильтрация по поиску
    if search:
        query = query.filter(
            db.or_(
                User.username.ilike(f'%{search}%'),
                User.last_name.ilike(f'%{search}%'),
                User.first_name.ilike(f'%{search}%'),
                User.middle_name.ilike(f'%{search}%')
            )
        )
    
    # Сортировка по updated_at или created_at от новых к старым
    pagination = query.order_by(db.func.coalesce(User.updated_at, User.created_at).desc()).paginate(page=page, per_page=per_page, error_out=False)
    users = pagination.items
    
    return jsonify({
        'users': [{
            'id': user.id,
            'username': user.username,
            'role': user.role,
            'last_name': user.last_name,
            'first_name': user.first_name,
            'middle_name': user.middle_name,
            'created_at': user.created_at.isoformat() if user.created_at else None,
            'updated_at': user.updated_at.isoformat() if hasattr(user, 'updated_at') and user.updated_at else None
        } for user in users],
        'total': pagination.total,
        'pages': pagination.pages,
        'current_page': pagination.page
    }), 200

@bp.route('/admin/users/<int:user_id>', methods=['PUT', 'DELETE', 'OPTIONS'])
@login_required
@admin_required
def user_management(user_id):
    if request.method == 'OPTIONS':
        logger.debug(f"Handling OPTIONS for /admin_api/admin/users/{user_id}")
        return jsonify({}), 200  # CORS уже обрабатывается в __init__.py

    logger.debug(f"Получен {request.method} запрос для /admin_api/admin/users/{user_id}")
    user = User.query.get_or_404(user_id)
    
    if request.method == 'PUT':
        data = request.json
        user.username = data.get('username', user.username)
        user.role = data.get('role', user.role)
        user.last_name = data.get('last_name', user.last_name)
        user.first_name = data.get('first_name', user.first_name)
        user.middle_name = data.get('middle_name', user.middle_name)
        
        # Обновление пароля, если он указан
        new_password = data.get('new_password')
        if new_password:
            user.set_password(new_password)
            logger.debug(f"Пароль пользователя {user.username} обновлён администратором")

        try:
            db.session.commit()
            return jsonify({
                'message': 'Пользователь успешно обновлён',
                'user': {
                    'id': user.id,
                    'username': user.username,
                    'role': user.role,
                    'last_name': user.last_name,
                    'first_name': user.first_name,
                    'middle_name': user.middle_name
                }
            }), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка обновления пользователя {user_id}: {str(e)}")
            return jsonify({"error": "Ошибка при обновлении пользователя. Попробуйте позже."}), 500

    elif request.method == 'DELETE':
        try:
            deleted_user = User.query.filter_by(username='deleted_user').first()
            if not deleted_user:
                deleted_user = User(username='deleted_user', role='deleted')
                deleted_user.set_password('deleted')
                db.session.add(deleted_user)
                db.session.commit()

            publications = Publication.query.filter_by(user_id=user_id).all()
            for pub in publications:
                pub.user_id = deleted_user.id

            db.session.delete(user)
            db.session.commit()
            return jsonify({'message': 'Пользователь успешно удалён, его публикации переназначены'}), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка удаления пользователя {user_id}: {str(e)}")
            return jsonify({"error": "Ошибка при удалении пользователя. Попробуйте позже."}), 500

@bp.route('/admin/publications', methods=['GET', 'OPTIONS'])
@login_required
@admin_required
def get_all_publications():
    if request.method == 'OPTIONS':
        logger.debug("Handling OPTIONS for /admin_api/admin/publications")
        return jsonify({}), 200

    logger.debug(f"Получен GET запрос для /admin_api/admin/publications")
    
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '').lower()
    pub_type = request.args.get('type', 'all')
    status = request.args.get('status', 'all')
    
    # Базовый запрос
    query = Publication.query
    
    # Фильтрация по поиску
    if search:
        query = query.filter(
            db.or_(
                Publication.title.ilike(f'%{search}%'),
                Publication.authors.ilike(f'%{search}%'),
                db.cast(Publication.year, db.String).ilike(f'%{search}%')
            )
        )
    
    # Фильтрация по типу
    if pub_type != 'all':
        query = query.filter(Publication.type == pub_type)
    
    # Фильтрация по статусу
    if status != 'all':
        query = query.filter(Publication.status == status)
    
    # Сортировка по updated_at или published_at от новых к старым
    pagination = query.order_by(db.func.coalesce(Publication.updated_at, Publication.published_at).desc()).paginate(page=page, per_page=per_page, error_out=False)
    publications = pagination.items
    
    return jsonify({
        'publications': [{
            'id': pub.id,
            'title': pub.title,
            'authors': pub.authors,
            'year': pub.year,
            'type': pub.type,
            'status': pub.status,
            'file_url': pub.file_url,
            'user_id': pub.user_id,
            'updated_at': pub.updated_at.isoformat() if pub.updated_at else None,
            'published_at': pub.published_at.isoformat() if pub.published_at else None
        } for pub in publications],
        'total': pagination.total,
        'pages': pagination.pages,
        'current_page': pagination.page
    }), 200

@bp.route('/admin/publications/<int:pub_id>', methods=['PUT', 'DELETE', 'OPTIONS'])
@login_required
@admin_required
def publication_management(pub_id):
    if request.method == 'OPTIONS':
        logger.debug(f"Handling OPTIONS for /admin_api/admin/publications/{pub_id}")
        return jsonify({}), 200  # CORS уже обрабатывается в __init__.py

    logger.debug(f"Получен {request.method} запрос для /admin_api/admin/publications/{pub_id}")
    publication = Publication.query.get_or_404(pub_id)
    
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
                logger.debug(f"Файл обновлён для публикации {pub_id}: {file_path}")
        
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