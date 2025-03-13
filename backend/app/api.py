from flask import Blueprint, jsonify, request, send_file
from werkzeug.utils import secure_filename
from flask_login import login_required, current_user
from flask import current_app
from app.extensions import db
from app.models import Publication, User, Plan, PlanEntry
import os
import logging
from io import BytesIO
import bibtexparser
from datetime import datetime

bp = Blueprint('admin_api', __name__, url_prefix='/admin_api')
logger = logging.getLogger(__name__)

def admin_or_manager_required(f):
    @login_required
    def wrapper(*args, **kwargs):
        if current_user.role not in ['admin', 'manager']:
            logger.warning(f"Unauthorized access attempt by user {current_user.id} with role {current_user.role}")
            return jsonify({"error": "Доступ запрещён. Требуется роль администратора или управляющего."}), 403
        return f(*args, **kwargs)
    wrapper.__name__ = f.__name__
    return wrapper

def admin_required(f):
    @login_required
    def wrapper(*args, **kwargs):
        if current_user.role != 'admin':
            logger.warning(f"Unauthorized access attempt by user {current_user.id} with role {current_user.role}")
            return jsonify({"error": "Доступ запрещён. Требуется роль администратора."}), 403
        return f(*args, **kwargs)
    wrapper.__name__ = f.__name__
    return wrapper

@bp.route('/admin/users', methods=['GET'])
@admin_required
def get_users():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '', type=str)

    query = User.query
    if search:
        search_pattern = f'%{search}%'
        query = query.filter(
            (User.username.ilike(search_pattern)) |
            (User.last_name.ilike(search_pattern)) |
            (User.first_name.ilike(search_pattern)) |
            (User.middle_name.ilike(search_pattern))
        )

    paginated_users = query.paginate(page=page, per_page=per_page, error_out=False)
    users = [{
        'id': user.id,
        'username': user.username,
        'role': user.role,
        'last_name': user.last_name,
        'first_name': user.first_name,
        'middle_name': user.middle_name,
        'full_name': user.full_name,
    } for user in paginated_users.items]

    return jsonify({
        'users': users,
        'pages': paginated_users.pages,
        'total': paginated_users.total
    }), 200

@bp.route('/admin/users/<int:user_id>', methods=['PUT'])
@admin_required
def update_user(user_id):
    user = User.query.get_or_404(user_id)
    data = request.get_json()

    user.username = data.get('username', user.username)
    user.role = data.get('role', user.role)
    user.last_name = data.get('last_name', user.last_name)
    user.first_name = data.get('first_name', user.first_name)
    user.middle_name = data.get('middle_name', user.middle_name)

    if 'new_password' in data and data['new_password']:
        user.set_password(data['new_password'])

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
        logger.error(f"Ошибка при обновлении пользователя {user_id}: {str(e)}")
        return jsonify({"error": "Ошибка при обновлении пользователя. Попробуйте позже."}), 500

@bp.route('/admin/users/<int:user_id>', methods=['DELETE'])
@admin_required
def delete_user(user_id):
    user = User.query.get_or_404(user_id)

    if user.id == current_user.id:
        return jsonify({"error": "Нельзя удалить самого себя."}), 400

    try:
        db.session.delete(user)
        db.session.commit()
        return jsonify({"message": "Пользователь успешно удалён."}), 200
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка при удалении пользователя {user_id}: {str(e)}")
        return jsonify({"error": "Ошибка при удалении пользователя. Попробуйте позже."}), 500

@bp.route('/admin/publications', methods=['GET'])
@admin_required
def get_publications():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '', type=str)
    pub_type = request.args.get('type', 'all', type=str)
    status = request.args.get('status', 'all', type=str)

    query = Publication.query
    if search:
        search_pattern = f'%{search}%'
        query = query.filter(
            (Publication.title.ilike(search_pattern)) |
            (Publication.authors.ilike(search_pattern)) |
            (Publication.year.ilike(search_pattern))
        )

    if pub_type != 'all':
        query = query.filter_by(type=pub_type)
    if status != 'all':
        query = query.filter_by(status=status)

    paginated_publications = query.paginate(page=page, per_page=per_page, error_out=False)

    publications = [{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': pub.type,
        'status': pub.status,
        'file_url': pub.file_url,
        'user': {
            'id': pub.user.id if pub.user else None,
            'full_name': pub.user.full_name if pub.user else None
        },
        'returned_for_revision': pub.returned_for_revision,
        'published_at': pub.published_at.isoformat() if pub.published_at else None
    } for pub in paginated_publications.items]

    return jsonify({
        'publications': publications,
        'pages': paginated_publications.pages,
        'total': paginated_publications.total
    }), 200

@bp.route('/admin/publications/<int:pub_id>', methods=['PUT'])
@admin_or_manager_required
def update_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
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
            try:
                file.save(file_path)
                publication.file_url = f"/uploads/{filename}"
            except Exception as e:
                logger.error(f"Ошибка при сохранении файла: {str(e)}")
                return jsonify({"error": "Ошибка при сохранении файла. Попробуйте снова."}), 500

    data = request.form if 'file' in request.files else request.get_json()
    publication.title = data.get('title', publication.title)
    publication.authors = data.get('authors', publication.authors)
    publication.year = int(data.get('year', publication.year))
    publication.type = data.get('type', publication.type)
    publication.status = data.get('status', publication.status)

    if publication.status == 'published' and not publication.published_at:
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
                'published_at': publication.published_at.isoformat() if publication.published_at else None
            }
        }), 200
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка при обновлении публикации {pub_id}: {str(e)}")
        return jsonify({"error": "Ошибка при обновлении публикации. Попробуйте позже."}), 500

@bp.route('/admin/publications/<int:pub_id>', methods=['DELETE'])
@admin_or_manager_required
def delete_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    try:
        if publication.file_url:
            file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], publication.file_url.split('/')[-1])
            if os.path.exists(file_path):
                os.remove(file_path)

        db.session.delete(publication)
        db.session.commit()
        return jsonify({"message": "Публикация успешно удалена."}), 200
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка при удалении публикации {pub_id}: {str(e)}")
        return jsonify({"error": "Ошибка при удалении публикации. Попробуйте позже."}), 500

@bp.route('/admin/publications/needs-review', methods=['GET'])
@admin_or_manager_required
def get_needs_review_publications():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '', type=str)

    query = Publication.query.filter_by(status='needs_review')
    if search:
        search_pattern = f'%{search}%'
        query = query.filter(
            (Publication.title.ilike(search_pattern)) |
            (Publication.authors.ilike(search_pattern)) |
            (Publication.year.ilike(search_pattern))
        )

    paginated_publications = query.paginate(page=page, per_page=per_page, error_out=False)

    publications = [{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': pub.type,
        'status': pub.status,
        'file_url': pub.file_url,
        'user': {
            'id': pub.user.id if pub.user else None,
            'full_name': pub.user.full_name if pub.user else None
        },
        'returned_for_revision': pub.returned_for_revision,
        'published_at': pub.published_at.isoformat() if pub.published_at else None
    } for pub in paginated_publications.items]

    return jsonify({
        'publications': publications,
        'pages': paginated_publications.pages,
        'total': paginated_publications.total
    }), 200 

@bp.route('/admin/register', methods=['POST'])
@admin_or_manager_required
def register():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    last_name = data.get('last_name')
    first_name = data.get('first_name')
    middle_name = data.get('middle_name')

    if not username or not password:
        return jsonify({"error": "Логин и пароль обязательны."}), 400

    existing_user = User.query.filter_by(username=username).first()
    if existing_user:
        return jsonify({"error": "Пользователь с таким логином уже существует."}), 400

    new_user = User(
        username=username,
        last_name=last_name,
        first_name=first_name,
        middle_name=middle_name,
    )
    new_user.set_password(password)

    try:
        db.session.add(new_user)
        db.session.commit()
        logger.debug(f"User registered successfully: {username}, response: {'Пользователь успешно зарегистрирован.'}")
        return jsonify({"message": "Пользователь успешно зарегистрирован."}), 201
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка при регистрации пользователя {username}: {str(e)}")
        return jsonify({"error": "Ошибка при регистрации. Попробуйте позже."}), 500

@bp.route('/admin/check-username', methods=['POST'])
@admin_or_manager_required
def check_username():
    data = request.get_json()
    username = data.get('username')
    user = User.query.filter_by(username=username).first()
    return jsonify({'exists': user is not None})

@bp.route('/admin/generate-password', methods=['GET'])
@admin_or_manager_required
def generate_password():
    import secrets
    import string
    # Используем только буквы (строчные и заглавные) и цифры
    characters = string.ascii_letters + string.digits
    password = ''.join(secrets.choice(characters) for _ in range(12))
    return jsonify({'password': password})

@bp.route('/admin/plans', methods=['GET'])
@admin_or_manager_required
def get_all_plans():
    logger.debug(f"Получен GET запрос для /admin_api/admin/plans")
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    pagination = Plan.query.order_by(Plan.year.desc()).paginate(page=page, per_page=per_page)
    plans = pagination.items
    return jsonify({
        'plans': [plan.to_dict() for plan in plans],
        'total': pagination.total,
        'pages': pagination.pages,
        'current_page': pagination.page
    }), 200

@bp.route('/admin/plans/<int:plan_id>', methods=['PUT'])
@admin_required
def update_plan(plan_id):
    logger.debug(f"Получен PUT запрос для /admin_api/admin/plans/{plan_id}")
    plan = Plan.query.get_or_404(plan_id)
    data = request.get_json()
    if not all(k in data for k in ('year', 'expectedCount', 'fillType', 'user_id', 'entries')):
        return jsonify({'error': 'Missing required fields'}), 400
    
    if not isinstance(data['year'], int) or data['year'] < 1900 or data['year'] > 2100:
        return jsonify({'error': 'Invalid year'}), 400
    
    if not isinstance(data['expectedCount'], int) or data['expectedCount'] < 1:
        return jsonify({'error': 'Expected count must be at least 1'}), 400
    
    if data['fillType'] not in ['manual', 'link']:
        return jsonify({'error': 'Invalid fill type'}), 400

    plan.year = data['year']
    plan.expectedCount = data['expectedCount']
    plan.fillType = data['fillType']
    plan.user_id = data['user_id']

    PlanEntry.query.filter_by(plan_id=plan.id).delete()
    for entry_data in data['entries']:
        entry = PlanEntry(
            title=entry_data.get('title'),
            type=entry_data.get('type'),
            publication_id=entry_data.get('publication_id'),
            status=entry_data.get('status', 'planned'),
            plan=plan
        )
        if entry.publication_id:
            publication = Publication.query.filter_by(id=entry.publication_id, user_id=plan.user_id, status='published').first()
            if not publication:
                db.session.rollback()
                return jsonify({'error': f'Publication with ID {entry.publication_id} not found or not published'}), 404
        db.session.add(entry)

    db.session.commit()
    return jsonify({'message': 'Plan updated successfully', 'plan': plan.to_dict()}), 200

@bp.route('/admin/plans/<int:plan_id>', methods=['DELETE'])
@admin_required
def delete_plan(plan_id):
    logger.debug(f"Получен DELETE запрос для /admin_api/admin/plans/{plan_id}")
    plan = Plan.query.get_or_404(plan_id)
    if plan.status not in ['draft', 'returned']:
        return jsonify({'error': 'Cannot delete plan that is under review or approved'}), 403
    
    db.session.delete(plan)
    db.session.commit()
    return jsonify({'message': 'Plan deleted successfully'}), 200

@bp.route('/admin/plans/<int:plan_id>/approve', methods=['POST'])
@admin_or_manager_required
def approve_plan(plan_id):
    logger.debug(f"Получен POST запрос для /admin_api/admin/plans/{plan_id}/approve")
    plan = Plan.query.get_or_404(plan_id)
    if plan.status != 'needs_review':
        return jsonify({'error': 'План не находится на проверке'}), 400

    plan.status = 'approved'
    db.session.commit()
    return jsonify({'message': 'План утверждён', 'plan': plan.to_dict()}), 200

@bp.route('/admin/plans/<int:plan_id>/return-for-revision', methods=['POST'])
@admin_or_manager_required
def return_plan_for_revision(plan_id):
    logger.debug(f"Получен POST запрос для /admin_api/admin/plans/{plan_id}/return-for-revision")
    plan = Plan.query.get_or_404(plan_id)
    if plan.status != 'needs_review':
        return jsonify({'error': 'План не находится на проверке'}), 400

    data = request.get_json()
    comment = data.get('comment', '').strip()
    if not comment:
        return jsonify({'error': 'Комментарий обязателен'}), 400

    plan.status = 'returned'
    plan.return_comment = comment
    db.session.commit()
    return jsonify({'message': 'План возвращён на доработку', 'plan': plan.to_dict()}), 200

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'pdf', 'docx'}

def get_publications_by_year(user_id):
    publications = Publication.query.filter_by(user_id=user_id).all()
    yearly_counts = {}
    for pub in publications:
        year = pub.year
        yearly_counts[year] = yearly_counts.get(year, 0) + 1
    return sorted(yearly_counts.items(), key=lambda x: x[0])


@bp.route('admin/plans/needs-review', methods=['GET'])
@login_required
def get_needs_review_plans():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    # Запрос планов со статусом 'needs_review'
    plans_query = Plan.query.filter_by(status='needs_review')
    pagination = plans_query.paginate(page=page, per_page=per_page, error_out=False)
    
    plans = [plan.to_dict() for plan in pagination.items]
    
    return jsonify({
        'plans': plans,
        'pages': pagination.pages,
        'total': pagination.total
    })