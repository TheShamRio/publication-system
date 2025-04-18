from flask import Blueprint, jsonify, request, send_file
from werkzeug.utils import secure_filename
from flask_login import login_required, current_user
from flask import current_app
from collections import defaultdict
from app.extensions import db
from app.models import Publication, User, Plan, PlanEntry, PlanActionHistory, PublicationActionHistory, PublicationType, PublicationTypeDisplayName
import os
import logging
from io import BytesIO
import bibtexparser
from datetime import datetime
from sqlalchemy import or_

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
@admin_or_manager_required
def get_publications():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '', type=str)
    pub_type = request.args.get('type', 'all', type=str)
    status = request.args.get('status', 'all', type=str)
    sort_status = request.args.get('sort_status', None, type=str)
    sort_by = request.args.get('sort_by', 'updated_at', type=str)
    sort_order = request.args.get('sort_order', 'desc', type=str)

    query = Publication.query

    if search:
        search_pattern = f'%{search}%'
        query = query.filter(
            (Publication.title.ilike(search_pattern)) |
            (Publication.authors.ilike(search_pattern)) |
            (db.cast(Publication.year, db.String).ilike(search_pattern))
        )

    if pub_type != 'all':
        type_ = PublicationType.query.filter_by(name=pub_type).first()
        if type_:
            query = query.filter_by(type_id=type_.id)
        else:
            return jsonify({'error': 'Invalid publication type'}), 400

    valid_statuses = ['draft', 'needs_review', 'returned_for_revision', 'published']
    if status != 'all':
        status_list = status.split(',')
        filtered_statuses = [s for s in status_list if s in valid_statuses]
        if not filtered_statuses:
            return jsonify({"error": "Указаны недопустимые статусы"}), 400
        query = query.filter(Publication.status.in_(filtered_statuses))
    else:
        filtered_statuses = valid_statuses

    if current_user.role == 'manager':
        allowed_statuses = ['needs_review', 'returned_for_revision', 'published']
        query = query.filter(Publication.status.in_(allowed_statuses))
        filtered_statuses = allowed_statuses

    valid_sort_fields = ['id', 'title', 'year', 'updated_at', 'published_at']
    if sort_by not in valid_sort_fields:
        sort_by = 'updated_at'
    sort_column = getattr(Publication, sort_by)

    if sort_order == 'desc':
        sort_column = sort_column.desc()
    else:
        sort_column = sort_column.asc()

    if sort_status and sort_status in filtered_statuses:
        sort_case = db.case(
            {sort_status: 0},
            value=Publication.status,
            else_=1
        ).label('status_priority')
        query = query.order_by(sort_case, sort_column)
    else:
        query = query.order_by(sort_column)

    try:
        paginated_publications = query.paginate(page=page, per_page=per_page, error_out=False)
    except Exception as e:
        logger.error(f"Ошибка пагинации: {str(e)}")
        return jsonify({"error": "Ошибка сервера при загрузке публикаций"}), 500

    publications = [{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': {
            'id': pub.type.id,
            'name': pub.type.name,
            'display_name': pub.display_name.display_name if pub.display_name else None,
            'display_names': [dn.display_name for dn in pub.type.display_names],
            'display_name_id': pub.display_name_id
        } if pub.type else None,
        'status': pub.status,
        'file_url': pub.file_url,
        'user': {
            'id': pub.user.id if pub.user else None,
            'full_name': pub.user.full_name if pub.user else None
        },
        'returned_for_revision': pub.returned_for_revision,
        'published_at': pub.published_at.isoformat() if pub.published_at else None,
        'updated_at': pub.updated_at.isoformat() if pub.updated_at else None
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
    type_id = data.get('type_id')  # Теперь ожидаем type_id
    display_name_id = data.get('display_name_id')  # Новый параметр
    if type_id:
        try:
            type_id = int(type_id)
            type_ = PublicationType.query.get(type_id)
            if not type_:
                return jsonify({'error': 'Invalid publication type'}), 400
            publication.type_id = type_id
        except ValueError:
            return jsonify({'error': 'type_id должен быть числом'}), 400

    if display_name_id:
        try:
            display_name_id = int(display_name_id)
            display_name = PublicationTypeDisplayName.query.get(display_name_id)
            if not display_name or (type_id and display_name.publication_type_id != type_id):
                return jsonify({'error': 'Недопустимое русское название'}), 400
            publication.display_name_id = display_name_id
        except ValueError:
            return jsonify({'error': 'display_name_id должен быть числом'}), 400

    new_status = data.get('status', publication.status)
    comment = data.get('return_comment', '')

    if new_status != publication.status:
        timestamp = datetime.utcnow()
        if new_status == 'published':
            publication.published_at = timestamp
            publication.returned_for_revision = False
            publication.returned_at = None
            publication.return_comment = None
            action_type = 'published'
        elif new_status == 'returned_for_revision':
            publication.returned_for_revision = True
            publication.returned_at = timestamp
            publication.return_comment = comment
            action_type = 'returned'
        else:
            action_type = new_status
            if publication.status in ['published', 'returned_for_revision']:
                publication.published_at = None
                publication.returned_at = None
                publication.return_comment = None
                publication.returned_for_revision = False

        action = PublicationActionHistory(
            publication_id=publication.id,
            user_id=current_user.id,
            action_type=action_type,
            timestamp=timestamp,
            comment=comment if comment.strip() else None
        )
        db.session.add(action)

    publication.status = new_status

    try:
        db.session.commit()
        logger.debug(f"Публикация {pub_id} обновлена пользователем {current_user.id}, новый статус: {new_status}")
        return jsonify({
            'message': 'Публикация успешно обновлена',
            'publication': publication.to_dict()
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
        'type': {
            'id': pub.type.id,
            'name': pub.type.name,
            'display_name': pub.display_name.display_name if pub.display_name else None,
            'display_names': [dn.display_name for dn in pub.type.display_names],
            'display_name_id': pub.display_name_id
        } if pub.type else None,
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
    plan = Plan.query.get_or_404(plan_id)
    plan.status = 'approved'
    plan.approved_at = datetime.utcnow()

    action = PlanActionHistory(
        plan_id=plan.id,
        action_type='approved',
        timestamp=plan.approved_at,
        user_id=current_user.id
    )
    db.session.add(action)
    db.session.commit()
    return jsonify({"message": "План утверждён"}), 200

@bp.route('/admin/plans/<int:plan_id>/return-for-revision', methods=['POST'])
@admin_or_manager_required
def return_plan_for_revision(plan_id):
    plan = Plan.query.get_or_404(plan_id)
    data = request.get_json()
    comment = data.get('comment', '')
    plan.status = 'returned'
    plan.return_comment = comment
    plan.returned_at = datetime.utcnow()

    action = PlanActionHistory(
        plan_id=plan.id,
        action_type='returned',
        timestamp=plan.returned_at,
        comment=comment,
        user_id=current_user.id
    )
    db.session.add(action)
    db.session.commit()
    return jsonify({"message": "План возвращён на доработку"}), 200

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'pdf', 'docx'}

def get_publications_by_year(user_id):
    publications = Publication.query.filter_by(user_id=user_id).all()
    yearly_counts = {}
    for pub in publications:
        year = pub.year
        yearly_counts[year] = yearly_counts.get(year, 0) + 1
    return sorted(yearly_counts.items(), key=lambda x: x[0])

@bp.route('/admin/plan-action-history', methods=['GET'])
@admin_or_manager_required
def get_plan_action_history():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    start_date = request.args.get('start_date', type=str)
    end_date = request.args.get('end_date', type=str)

    query = PlanActionHistory.query.join(Plan).filter(
        PlanActionHistory.action_type.in_(['approved', 'returned'])
    )

    if start_date:
        try:
            start_datetime = datetime.strptime(start_date, '%Y-%m-%d')
            query = query.filter(PlanActionHistory.timestamp >= start_datetime)
        except ValueError as e:
            logger.error(f"Некорректный формат start_date: {start_date}, ошибка: {str(e)}")
            return jsonify({"error": "Некорректный формат даты начала"}), 400

    if end_date:
        try:
            end_datetime = datetime.strptime(end_date, '%Y-%m-%d')
            query = query.filter(PlanActionHistory.timestamp <= end_datetime)
        except ValueError as e:
            logger.error(f"Некорректный формат end_date: {end_date}, ошибка: {str(e)}")
            return jsonify({"error": "Некорректный формат даты окончания"}), 400

    query = query.order_by(db.desc(PlanActionHistory.timestamp))

    paginated_actions = query.paginate(page=page, per_page=per_page, error_out=False)
    
    logger.debug(f"Найдено действий: {paginated_actions.total}")
    for action in paginated_actions.items:
        logger.debug(f"Действие ID={action.id}, план ID={action.plan_id}, тип={action.action_type}, время={action.timestamp}")

    history = []
    for action in paginated_actions.items:
        history.append({
            'id': action.plan_id,
            'year': action.plan.year,
            'action_type': action.action_type,
            'timestamp': action.timestamp.isoformat(),
            'comment': action.comment,
            'user_full_name': action.plan.user.full_name if action.plan.user else "Не указан"
        })

    return jsonify({
        'history': history,
        'pages': paginated_actions.pages,
        'total': paginated_actions.total
    }), 200

@bp.route('admin/plans/needs-review', methods=['GET'])
@login_required
def get_needs_review_plans():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    plans_query = Plan.query.filter_by(status='needs_review')
    pagination = plans_query.paginate(page=page, per_page=per_page, error_out=False)
    
    plans = [plan.to_dict() for plan in pagination.items]
    
    return jsonify({
        'plans': plans,
        'pages': pagination.pages,
        'total': pagination.total
    })

from sqlalchemy import case, or_, desc, func

@bp.route('/admin/publication-action-history', methods=['GET'])
@admin_or_manager_required
def get_publication_action_history():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    start_date = request.args.get('start_date', type=str)
    end_date = request.args.get('end_date', type=str)

    query = PublicationActionHistory.query.join(Publication).filter(
        PublicationActionHistory.action_type.in_(['approved', 'returned'])
    )

    if start_date:
        try:
            start_datetime = datetime.strptime(start_date, '%Y-%m-%d')
            query = query.filter(PublicationActionHistory.timestamp >= start_datetime)
        except ValueError:
            return jsonify({"error": "Некорректный формат даты начала"}), 400

    if end_date:
        try:
            end_datetime = datetime.strptime(end_date, '%Y-%m-%d')
            query = query.filter(PublicationActionHistory.timestamp <= end_datetime)
        except ValueError:
            return jsonify({"error": "Некорректный формат даты окончания"}), 400

    query = query.order_by(db.desc(PublicationActionHistory.timestamp))
    paginated_actions = query.paginate(page=page, per_page=per_page, error_out=False)

    history = [{
        'id': action.publication_id,
        'title': action.publication.title,
        'action_type': action.action_type,
        'timestamp': action.timestamp.isoformat(),
        'comment': action.comment,
        'user_full_name': action.user.full_name if action.user else "Не указан"
    } for action in paginated_actions.items]

    return jsonify({
        'history': history,
        'pages': paginated_actions.pages,
        'total': paginated_actions.total
    }), 200

@bp.route('/admin/statistics', methods=['GET'])
@admin_or_manager_required
def get_statistics():
    from collections import defaultdict

    year = request.args.get('year', type=int, default=datetime.utcnow().year)
    users = User.query.filter_by(role='user').all()
    result = []

    try:
        for user in users:
            plan_data = defaultdict(int)
            actual_data = defaultdict(int)

            plan = Plan.query.filter_by(user_id=user.id, year=year, status='approved').first()

            if plan:
                for entry in plan.entries:
                    # Получаем display_name (русское или fallback)
                    if entry.display_name:
                        display_name = entry.display_name.display_name
                    elif entry.type and entry.type.display_names.count() > 0:
                        display_name = entry.type.display_names.first().display_name
                    elif entry.type:
                        display_name = entry.type.name
                    else:
                        display_name = 'Не указано'

                    # Считаем план
                    plan_data[display_name] += 1

                    # Считаем факт, если есть опубликованная публикация
                    if entry.publication and entry.publication.status == 'published':
                        actual_data[display_name] += 1

                # Гарантируем, что в actual будут все ключи из plan
                for key in plan_data:
                    if key not in actual_data:
                        actual_data[key] = 0

            result.append({
                'user_id': user.id,
                'full_name': user.full_name or user.username,
                'username': user.username,
                'plan': dict(plan_data),
                'actual': dict(actual_data)
            })

        return jsonify(result), 200

    except Exception as e:
        current_app.logger.exception("Ошибка при генерации статистики:")
        return jsonify({"error": "Ошибка при обработке статистики."}), 500

@bp.route('/admin/publication-types', methods=['GET'])
@admin_or_manager_required
def get_publication_types():
    """
    Эндпоинт для получения типов публикаций для админов и менеджеров.
    Возвращает каждый display_name как отдельный вариант.
    """
    try:
        types = PublicationType.query.all()
        response = []
        for t in types:
            for dn in t.display_names:
                response.append({
                    'id': t.id,
                    'name': t.name,
                    'display_name_id': dn.id,
                    'display_name': dn.display_name
                })
        return jsonify(response), 200
    except Exception as e:
        logger.error(f"Ошибка получения типов публикаций: {str(e)}")
        return jsonify({'error': 'Ошибка при получении типов публикаций.'}), 500

@bp.route('/admin/publication-types', methods=['POST'])
@admin_or_manager_required
def create_publication_type():
    data = request.get_json()
    name = data.get('name')
    display_names = data.get('display_names', [])
    if not name or not display_names:
        return jsonify({'error': 'Name and at least one display_name are required'}), 400
    if PublicationType.query.filter_by(name=name).first():
        return jsonify({'error': 'Type with this name already exists'}), 400
    new_type = PublicationType(name=name)
    db.session.add(new_type)
    db.session.flush()  # Получаем ID нового типа
    for display_name in display_names:
        new_display_name = PublicationTypeDisplayName(
            publication_type_id=new_type.id,
            display_name=display_name
        )
        db.session.add(new_display_name)
    db.session.commit()
    return jsonify({
        'message': 'Type created',
        'type': {
            'id': new_type.id,
            'name': new_type.name,
            'display_names': [dn.display_name for dn in new_type.display_names]
        }
    }), 201

@bp.route('/admin/publication-types/<int:type_id>', methods=['PUT'])
@admin_or_manager_required
def update_publication_type(type_id):
    type_ = PublicationType.query.get_or_404(type_id)
    data = request.get_json()
    name = data.get('name')
    display_names = data.get('display_names', [])
    if name and name != type_.name and PublicationType.query.filter_by(name=name).first():
        return jsonify({'error': 'Type with this name already exists'}), 400
    type_.name = name or type_.name
    if display_names:
        PublicationTypeDisplayName.query.filter_by(publication_type_id=type_.id).delete()
        for display_name in display_names:
            new_display_name = PublicationTypeDisplayName(
                publication_type_id=type_.id,
                display_name=display_name
            )
            db.session.add(new_display_name)
    db.session.commit()
    return jsonify({
        'message': 'Type updated',
        'type': {
            'id': type_.id,
            'name': type_.name,
            'display_names': [dn.display_name for dn in type_.display_names]
        }
    }), 200

@bp.route('/admin/publication-types/<int:type_id>', methods=['DELETE'])
@admin_or_manager_required
def delete_publication_type(type_id):
    type_ = PublicationType.query.get_or_404(type_id)
    logger.info(f"Attempting to delete publication type {type_id}")
    publications = Publication.query.filter_by(type_id=type_id).count()
    plan_entries = PlanEntry.query.filter_by(type_id=type_id).count()
    if publications or plan_entries:
        logger.warning(f"Cannot delete type {type_id}: used in {publications} publications and {plan_entries} plan entries")
        return jsonify({
            'error': f'Cannot delete type: it is used in {publications} publication(s) and {plan_entries} plan entry(ies).'
        }), 400
    db.session.delete(type_)
    db.session.commit()
    logger.info(f"Publication type {type_id} deleted successfully")
    return jsonify({'message': 'Type deleted'}), 200