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
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from sqlalchemy import func, desc
from functools import wraps

bp = Blueprint('admin_api', __name__)

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

@bp.route('/admin/users', methods=['GET'])
@login_required
@admin_required
def get_all_users():
    logger.debug(f"Получен GET запрос для /admin/users")
    users = User.query.all()
    return jsonify([{
        'id': user.id,
        'username': user.username,
        'role': user.role,
        'last_name': user.last_name,
        'first_name': user.first_name,
        'middle_name': user.middle_name,
        'created_at': user.created_at.isoformat() if user.created_at else None
    } for user in users]), 200

@bp.route('/admin/users/<int:user_id>', methods=['PUT', 'DELETE'])
@login_required
@admin_required
def user_management(user_id):
    logger.debug(f"Получен {request.method} запрос для /admin/users/{user_id}")
    user = User.query.get_or_404(user_id)
    
    if request.method == 'PUT':
        data = request.json
        user.username = data.get('username', user.username)
        user.role = data.get('role', user.role)
        user.last_name = data.get('last_name', user.last_name)
        user.first_name = data.get('first_name', user.first_name)
        user.middle_name = data.get('middle_name', user.middle_name)
        
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

@bp.route('/admin/publications', methods=['GET'])
@login_required
@admin_required
def get_all_publications():
    logger.debug(f"Получен GET запрос для /admin/publications")
    publications = Publication.query.all()
    return jsonify([{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': pub.type,
        'status': pub.status,
        'file_url': pub.file_url,
        'user_id': pub.user_id,
        'updated_at': pub.updated_at.isoformat() if pub.updated_at else None
    } for pub in publications]), 200

@bp.route('/admin/publications/<int:pub_id>', methods=['PUT', 'DELETE'])
@login_required
@admin_required
def publication_management(pub_id):
    logger.debug(f"Получен {request.method} запрос для /admin/publications/{pub_id}")
    publication = Publication.query.get_or_404(pub_id)
    
    if request.method == 'PUT':
        # Проверяем, отправлен ли запрос с JSON или FormData
        if request.content_type == 'application/json':
            # Обработка JSON
            data = request.get_json()
        elif 'file' in request.files or request.content_type.startswith('multipart/form-data'):
            # Обработка FormData (для файлов)
            data = request.form
        else:
            return jsonify({"error": "Неподдерживаемый формат данных. Используйте application/json или multipart/form-data."}), 415

        # Проверяем, есть ли файл в запросе
        if 'file' in request.files:
            file = request.files['file']
            if file and allowed_file(file.filename):
                # Удаляем старый файл, если он существует
                if publication.file_url and os.path.exists(publication.file_url):
                    os.remove(publication.file_url)
                # Сохраняем новый файл
                filename = secure_filename(file.filename)
                file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
                file.save(file_path)
                publication.file_url = file_path
                logger.debug(f"Файл обновлён для публикации {pub_id}: {file_path}")
        
        # Обновляем остальные поля из данных (даже если файл не выбран)
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
