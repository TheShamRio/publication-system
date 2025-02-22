# app/api.py
from flask import Blueprint, jsonify, request
from .extensions import db
from .models import Publication, User
from .utils import allowed_file  # Импортируем из utils
import bibtexparser
from flask_login import login_user, current_user, logout_user, login_required
from .middleware import admin_required  # Импортируем middleware
from .analytics import get_publications_by_year
from flask import current_app
from werkzeug.utils import secure_filename
import os
import logging
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from sqlalchemy import func, desc

bp = Blueprint('admin_api', __name__)

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Эндпоинты для администратора
@bp.route('/admin/users', methods=['GET'])
@login_required
@admin_required
def get_all_users():
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
@bp.route('/admin/users/<int:user_id>', methods=['PUT'])
@login_required
@admin_required
def update_user(user_id):
    user = User.query.get_or_404(user_id)
    data = request.json
    user.username = data.get('username', user.username)
    user.role = data.get('role', user.role)  # Обновляем роль
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
        return jsonify({"error": "Ошибка при обновлении пользователя. Попробуйте позже."}), 500

@bp.route('/admin/users/<int:user_id>', methods=['DELETE'])
@login_required
@admin_required
def delete_user(user_id):
    user = User.query.get_or_404(user_id)
    try:
        db.session.delete(user)
        db.session.commit()
        return jsonify({'message': 'Пользователь успешно удалён'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": "Ошибка при удалении пользователя. Попробуйте позже."}), 500

@bp.route('/admin/publications', methods=['GET'])
@login_required
@admin_required
def get_all_publications():
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
@bp.route('/admin/publications/<int:pub_id>', methods=['PUT'])
@login_required
@admin_required
def update_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    data = request.json
    publication.title = data.get('title', publication.title)
    publication.authors = data.get('authors', publication.authors)
    publication.year = data.get('year', publication.year)
    publication.type = data.get('type', publication.type)
    publication.status = data.get('status', publication.status)
    publication.file_url = data.get('file_url', publication.file_url)
    
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
        return jsonify({"error": "Ошибка при обновлении публикации. Попробуйте позже."}), 500

@bp.route('/admin/publications/<int:pub_id>', methods=['DELETE'])
@login_required
@admin_required
def delete_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    try:
        if publication.file_url and os.path.exists(publication.file_url):
            os.remove(publication.file_url)
        db.session.delete(publication)
        db.session.commit()
        return jsonify({'message': 'Публикация успешно удалена'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": "Ошибка при удалении публикации. Попробуйте позже."}), 500