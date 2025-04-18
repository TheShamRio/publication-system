from flask import Blueprint, jsonify, request, make_response, current_app, send_file
from .extensions import db, login_manager, csrf
from .models import User, Publication, Comment, Plan, PlanEntry, PublicationActionHistory, PublicationType, PublicationTypeDisplayName
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
        'type': {
            'id': publication.type.id,
            'name': publication.type.name,
            'display_name': publication.display_name.display_name if publication.display_name else None,
            'display_names': [dn.display_name for dn in publication.type.display_names],
            'display_name_id': publication.display_name_id
        } if publication.type else None,
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
        return jsonify({"error": "У вас нет прав для публикации этой работы."}), 403
    if publication.status != 'needs_review':
        return jsonify({"error": "Публикация не находится на стадии проверки."}), 400
    if not publication.file_url:
        return jsonify({"error": "Нельзя опубликовать работу без прикреплённого файла."}), 400

    publication.status = 'published'
    publication.published_at = datetime.utcnow()
    publication.returned_for_revision = False

    action = PublicationActionHistory(
        publication_id=publication.id,
        user_id=current_user.id,
        action_type='approved',
        timestamp=publication.published_at,
        comment=None
    )
    db.session.add(action)

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

    data = request.get_json()
    comment = data.get('comment', '')

    if not comment.strip():
        return jsonify({"error": "Необходимо добавить комментарий перед возвратом на доработку."}), 400

    publication.status = 'returned_for_revision'
    publication.returned_for_revision = True
    publication.published_at = None
    publication.returned_at = datetime.utcnow()
    publication.return_comment = comment

    action = PublicationActionHistory(
        publication_id=publication.id,
        user_id=current_user.id,
        action_type='returned',
        timestamp=publication.returned_at,
        comment=comment
    )
    db.session.add(action)

    try:
        db.session.commit()
        logger.debug(f"Публикация {pub_id} возвращена на доработку пользователем {current_user.id}, returned_at: {publication.returned_at}")
        return jsonify({
            'message': 'Публикация отправлена на доработку',
            'publication': {
                'id': publication.id,
                'title': publication.title,
                'status': publication.status,
                'returned_for_revision': publication.returned_for_revision,
                'returned_at': publication.returned_at.isoformat() if publication.returned_at else None,
                'return_comment': publication.return_comment
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
    pub_type = request.args.get('type', 'all')
    search = request.args.get('search', '').lower()
    year = request.args.get('year', type=str)

    query = Publication.query.filter_by(status='published')

    if pub_type and pub_type != 'all':
        type_ = PublicationType.query.filter_by(name=pub_type).first()
        if type_:
            logger.debug(f"Фильтр по типу: {pub_type}, type_id: {type_.id}")
            query = query.filter(Publication.type_id == type_.id)
        else:
            logger.warning(f"Тип публикации не найден: {pub_type}")
            return jsonify({
                'publications': [],
                'total': 0,
                'pages': 0,
                'current_page': page
            }), 200

    if search:
        query = query.filter(
            db.or_(
                Publication.title.ilike(f'%{search}%'),
                Publication.authors.ilike(f'%{search}%')
            )
        )

    if year:
        try:
            year_int = int(year)
            query = query.filter(Publication.year == year_int)
        except ValueError:
            logger.warning(f"Недопустимый год: {year}")

    query = query.order_by(
        db.func.coalesce(Publication.published_at, Publication.updated_at).desc()
    )

    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    publications = pagination.items

    response = [{
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
        } if pub.type else {'id': None, 'name': 'Неизвестный тип', 'display_names': [], 'display_name': None, 'display_name_id': None},
        'status': pub.status,
        'file_url': pub.file_url,
        'updated_at': pub.updated_at.isoformat() if pub.updated_at else None,
        'published_at': pub.published_at.isoformat() if pub.published_at else None,
        'returned_for_revision': pub.returned_for_revision,
        'user': {
            'full_name': pub.user.full_name if pub.user else 'Не указан'
        } if pub.user else None
    } for pub in publications]

    logger.debug(f"Возвращено {len(response)} публикаций, всего: {pagination.total}")

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
    display_name_id = request.args.get('display_name_id', type=int)
    status = request.args.get('status', 'all')

    query = Publication.query.filter_by(user_id=current_user.id)

    if search:
        query = query.filter(
            db.or_(
                Publication.title.ilike(f'%{search}%'),
                Publication.authors.ilike(f'%{search}%'),
                db.cast(Publication.year, db.String).ilike(f'%{search}%')
            )
        )

    if display_name_id:
        query = query.filter(Publication.display_name_id == display_name_id)
    elif pub_type != 'all':
        type_ = PublicationType.query.filter_by(name=pub_type).first()
        if type_:
            query = query.filter(Publication.type_id == type_.id)
        else:
            return jsonify({'error': 'Недопустимый тип публикации'}), 400

    if status != 'all':
        query = query.filter(Publication.status == status)

    query = query.order_by(Publication.updated_at.desc())

    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    publications = pagination.items

    response = [{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'display_name_id': pub.display_name_id,
        'type': {
            'id': pub.type.id,
            'name': pub.type.name,
            'display_name': pub.display_name.display_name if pub.display_name else None,
            'display_names': [dn.display_name for dn in pub.type.display_names]
        } if pub.type else None,
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
    publication = Publication.query.get_or_404(pub_id)

    # Общая проверка прав: только владелец может управлять своей публикацией через этот эндпоинт
    # Администратор или менеджер должны использовать другие эндпоинты или логику
    if publication.user_id != current_user.id:
        logger.warning(f"Пользователь {current_user.id} (роль: {current_user.role}) пытался {request.method} публикацию {pub_id} другого пользователя.")
        return jsonify({'error': 'У вас нет прав на управление этой публикацией'}), 403

    # Проверка статуса, запрещающая управление (PUT/DELETE) для публикаций на проверке
    # Эта логика применима к обоим методам PUT и DELETE, как вы ее реализовали.
    if publication.status == 'needs_review':
        logger.warning(f"Пользователь {current_user.id} пытался {request.method} публикацию {pub_id} в статусе 'needs_review'.")
        return jsonify({'error': 'Нельзя управлять публикацией (редактировать или удалить), пока она на проверке.'}), 403

    if request.method == 'PUT':
        # --- ЛОГИКА ДЛЯ PUT ЗАПРОСА (ОСТАЕТСЯ КАК ЕСТЬ И ДОЛЖНА СОДЕРЖАТЬ return) ---
        # (ваш существующий код для PUT начинается здесь)
        if request.content_type == 'application/json':
            data = request.get_json()
        elif 'file' in request.files or request.content_type.startswith('multipart/form-data'):
            data = request.form
        else:
            return jsonify({"error": "Неподдерживаемый формат данных. Используйте application/json или multipart/form-data."}), 415

        old_status = publication.status

        # Логика загрузки/обновления файла (из существующего PUT кода)
        if 'file' in request.files:
            file = request.files['file']
            if file and allowed_file(file.filename):
                # Удаление старого файла, если есть
                if publication.file_url:
                    try:
                         old_file_path_segment = publication.file_url.split('/uploads/')[-1]
                         old_file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], old_file_path_segment)
                         if os.path.exists(old_file_path):
                             os.remove(old_file_path)
                             logger.debug(f"Старый файл '{old_file_path_segment}' удален для публикации {pub_id}.")
                    except Exception as file_del_e:
                         logger.error(f"Ошибка при удалении старого файла '{publication.file_url}': {str(file_del_e)}")
                         # Продолжаем, так как удаление файла не должно блокировать обновление БД

                filename = secure_filename(file.filename)
                # Убедимся, что путь для загрузки сконфигурирован
                if not os.path.exists(current_app.config['UPLOAD_FOLDER']):
                    os.makedirs(current_app.config['UPLOAD_FOLDER'])
                    logger.debug(f"Создана директория загрузки: {current_app.config['UPLOAD_FOLDER']}")

                file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
                # Логика для предотвращения перезаписи файла с таким же именем
                if os.path.exists(file_path):
                    base, extension = os.path.splitext(filename)
                    counter = 1
                    while os.path.exists(file_path):
                        filename = f"{base}_{counter}{extension}"
                        file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
                        counter += 1
                file.save(file_path)
                publication.file_url = f"/uploads/{filename}"
                logger.debug(f"Новый файл '{filename}' успешно прикреплен к публикации {pub_id}.")


        # Обновление текстовых полей и типа (из существующего PUT кода)
        # Используем .get() с None в качестве дефолта, чтобы отличать явно переданные null
        # от отсутствия поля в запросе. Иначе "" от формы могут перезаписать существующие данные.
        # НО, ваши текстовые поля title/authors/year в модели nullable=False,
        # поэтому "" или None не подходят, нужно проверять на пустую строку.
        # Уберем data.get(..., publication....) для обязательных полей, если поле в data, используем его.
        # А для nullable=True можно оставить get(..., publication...).
        
        # Для обязательных полей (title, authors, year, type_id):
        if 'title' in data and data['title'] is not None: # Проверяем наличие ключа и не None
            publication.title = data['title'].strip()
        if 'authors' in data and data['authors'] is not None:
             publication.authors = data['authors'].strip()
        if 'year' in data and data['year'] is not None:
            try:
                 year_int = int(data['year'])
                 # Добавьте валидацию диапазона лет, если нужно
                 publication.year = year_int
            except (ValueError, TypeError):
                 # Обработка ошибки, если год пришел не числом. Возможно, 400 ошибка.
                 logger.error(f"Ошибка обновления публикации {pub_id}: Неверный формат года '{data.get('year')}'")
                 return jsonify({'error': 'Неверный формат года.'}), 400
        
        # Для nullable=True полей, таких как type_id и display_name_id
        type_id_data = data.get('type_id')
        display_name_id_data = data.get('display_name_id')
        
        # Обновление type_id
        if type_id_data is not None: # Проверяем, что type_id было явно передано (даже null)
            try:
                 type_id = int(type_id_data) if type_id_data != '' else None # Convert '' to None
                 type_ = None
                 if type_id is not None:
                     type_ = PublicationType.query.get(type_id)
                     if not type_:
                         return jsonify({'error': f'Недопустимый type_id: {type_id}'}), 400
                 publication.type_id = type_id
            except ValueError:
                 return jsonify({'error': 'type_id должен быть числом или null.'}), 400

        # Обновление display_name_id (теперь зависит от нового type_id или существующего type_id)
        current_type_id_for_dn_check = type_id if type_id is not None else publication.type_id
        
        if display_name_id_data is not None: # Проверяем, что display_name_id было явно передано (даже null)
             try:
                 display_name_id = int(display_name_id_data) if display_name_id_data != '' else None # Convert '' to None
                 display_name = None
                 if display_name_id is not None:
                     display_name = PublicationTypeDisplayName.query.get(display_name_id)
                     # Проверяем соответствие display_name переданному type_id или текущему type_id публикации
                     if not display_name or (current_type_id_for_dn_check is not None and display_name.publication_type_id != current_type_id_for_dn_check):
                         return jsonify({'error': f'Недопустимое русское название с ID: {display_name_id} для выбранного типа публикации.'}), 400
                 publication.display_name_id = display_name_id
             except ValueError:
                  return jsonify({'error': 'display_name_id должен быть числом или null.'}), 400


        # Обновление статуса
        new_status = data.get('status') # Используем .get() для статуса
        if new_status is not None: # Только если статус был передан в запросе
            # Валидация нового статуса, если требуется
            # if new_status not in ['draft', 'needs_review', 'published', 'returned_for_revision']:
            #     return jsonify({'error': 'Недопустимый статус публикации.'}), 400
            publication.status = new_status
            if publication.status == 'published' and old_status != 'published':
                if not publication.file_url: # Проверка наличия файла при переходе в status=published
                    logger.warning(f"Пользователь {current_user.id} пытался установить статус 'published' для публикации {pub_id} без файла.")
                    return jsonify({'error': 'Нельзя установить статус "Опубликовано" без прикреплённого файла.'}), 400
                publication.published_at = datetime.utcnow()
                logger.debug(f"Публикация {pub_id} переведена в статус 'published'.")
            elif publication.status != 'published' and old_status == 'published':
                 # Сброс даты публикации при уходе со статуса 'published', если нужно
                 # publication.published_at = None
                 pass # Пока ничего не сбрасываем
            # Логика для статуса returned_for_revision (возвращается через отдельный эндпоинт?)
            # Ваш фронтенд устанавливает status='draft' при сохранении/редактировании владельцем,
            # так что эта часть логики может быть избыточной здесь, если только админ/менеджер
            # не используют PUT для смены статуса. Предполагаем, что owner ставит status='draft'
            # и submit_for_review ставит 'needs_review', админ/менеджер используют свои эндпоинты.
            if old_status == 'returned_for_revision' and publication.status != 'returned_for_revision':
                 publication.returned_for_revision = False
                 publication.return_comment = None # Сбросить комментарий, если владелец "принял" возврат

        publication.updated_at = datetime.utcnow() # Обновляем дату изменения

        try:
            db.session.commit()
            logger.debug(f"Публикация {pub_id} успешно обновлена пользователем {current_user.id}.")

            # Возвращаем обновленную публикацию
            # Убедитесь, что метод to_dict() в модели Publication включает display_name и display_name_id
            return jsonify({
                'message': 'Публикация успешно обновлена',
                'publication': publication.to_dict() # Используем метод to_dict()
            }), 200

        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка при сохранении обновления публикации {pub_id} пользователем {current_user.id}: {str(e)}", exc_info=True)
            return jsonify({"error": "Ошибка при обновлении публикации. Попробуйте позже."}), 500

    # --- ДОБАВЛЕННАЯ ЛОГИКА ДЛЯ DELETE ЗАПРОСА ---
    elif request.method == 'DELETE':
        # Дополнительная проверка: нельзя удалить опубликованную публикацию (для владельца)
        # Администратор может иметь возможность, но этот эндпоинт только для владельца
        if publication.status == 'published':
             logger.warning(f"Пользователь {current_user.id} пытался удалить опубликованную публикацию {pub_id}.")
             return jsonify({'error': 'Нельзя удалить опубликованную публикацию через этот интерфейс.'}), 403

        try:
            db.session.delete(publication)
            db.session.commit()
            logger.debug(f"Публикация {pub_id} успешно удалена пользователем {current_user.id}")
            return jsonify({'message': 'Публикация успешно удалена!'}), 200 # Успешный ответ с сообщением
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка при удалении публикации {pub_id} из базы данных пользователем {current_user.id}: {str(e)}", exc_info=True)
            return jsonify({'error': 'Произошла ошибка при удалении публикации из базы данных.'}), 500

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
    type_id = request.form.get('type_id')  # Теперь ожидаем type_id
    display_name_id = request.form.get('display_name_id')  # Новый параметр
    
    if not title or not authors or not year or not type_id:
        return jsonify({'error': 'Название, авторы, год и тип обязательны'}), 400

    try:
        year = int(year)
        if year < 1900 or year > datetime.now().year:
            return jsonify({'error': 'Недопустимый год'}), 400
        type_id = int(type_id)
        display_name_id = int(display_name_id) if display_name_id else None
    except ValueError:
        return jsonify({'error': 'Год, type_id и display_name_id должны быть числами'}), 400

    type_ = PublicationType.query.get(type_id)
    if not type_:
        return jsonify({'error': 'Недопустимый тип публикации'}), 400

    if display_name_id:
        display_name = PublicationTypeDisplayName.query.get(display_name_id)
        if not display_name or display_name.publication_type_id != type_id:
            return jsonify({'error': 'Недопустимое русское название'}), 400

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
        type_id=type_id,
        display_name_id=display_name_id,
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
            'type': {
                'id': type_.id,
                'name': type_.name,
                'display_name': publication.display_name.display_name if publication.display_name else None,
                'display_names': [dn.display_name for dn in type_.display_names],
                'display_name_id': publication.display_name_id
            },
            'status': publication.status,
            'file_url': publication.file_url,
            'updated_at': publication.updated_at.isoformat() if publication.updated_at else None,
            'returned_for_revision': publication.returned_for_revision,
        }
    }), 200
BIBTEX_TO_APP_TYPE_MAP = {
    'article': 'article',
    'inproceedings': 'conference', # Доклады/статьи конференций
    'conference': 'conference',    # Синоним inproceedings
    'book': 'book',
    'inbook': 'book',      # Часть книги (глава, диапазон страниц)
    'incollection': 'book',  # Статья или глава в сборнике/редактируемой книге
    'phdthesis': 'phdthesis',
    'mastersthesis': 'mastersthesis',
    'misc': 'misc',          # Прочее
    'unpublished': 'misc',   # Неопубликованные работы, часто подходит для депонированных
    'techreport': 'misc',    # Технические отчеты
    'manual': 'misc',        # Руководства
    # Добавьте сюда другие BibTeX типы, если встретятся и нужно их маппить
}

# Определяем маппинг внутренних имен типов приложения (из PublicationType.name)
# на их ожидаемые русские display names (из PublicationTypeDisplayName.display_name)
# Ключ - app type name, Значение - ожидаемое русское display_name
APP_TYPE_TO_DISPLAY_NAME_MAP = {
    'article': 'Статья',
    'conference': 'Конференция',
    'book': 'Книга',
    'misc': 'Депонированная рукопись', # Ваше специфическое маппирование 'misc'
    'phdthesis': 'Докторская диссертация',
    'mastersthesis': 'Магистерская диссертация',
    # Убедитесь, что у вас есть соответствующие записи в БД в таблицах PublicationType
    # и PublicationTypeDisplayName
}

# --- Обновленный эндпоинт upload_bibtex ---

@bp.route('/publications/upload-bibtex', methods=['POST'])
@login_required
def upload_bibtex():
    logger.debug(f"Получен POST запрос для /publications/upload-bibtex")
    
    if 'file' not in request.files:
        logger.warning("BibTeX файл не предоставлен в запросе.")
        return jsonify({'error': 'BibTeX файл не предоставлен'}), 400

    file = request.files['file']
    if not file or not file.filename.lower().endswith('.bib'):
        filename = file.filename if file else 'Нет файла'
        logger.warning(f"Получен недопустимый файл: {filename}. Ожидается .bib")
        return jsonify({'error': 'Недопустимый файл. Ожидается .bib'}), 400

    try:
        content = file.read().decode('utf-8')
        logger.debug(f"Файл {file.filename} успешно прочитан и декодирован (предполагается UTF-8).")

        bib_database = bibtexparser.loads(content)
        logger.debug(f"Парсинг BibTeX файла завершен. Найдено {len(bib_database.entries)} записей.")

        publications_added_count = 0
        skipped_entries = []
        error_entries = []

        try:
            app_types_by_name = {pt.name: pt for pt in PublicationType.query.all()}
            app_display_names_by_key = {(pnd.publication_type_id, pnd.display_name): pnd
                                        for pnd in PublicationTypeDisplayName.query.all()}
            logger.debug(f"Загружено {len(app_types_by_name)} типов PublicationType и {len(app_display_names_by_key)} объектов PublicationTypeDisplayName.")
        except Exception as e:
             logger.error(f"Ошибка предварительной загрузки типов и названий из БД: {str(e)}", exc_info=True)
             db.session.rollback()
             return jsonify({'error': 'Ошибка настройки базы данных типов публикаций.'}), 500


        for entry in bib_database.entries:
            entry_key = entry.get('ID', 'Без ключа') # Получаем BibTeX ключ

            # --- ИЗМЕНЕНА ЭТА ЧАСТЬ: Получение BibTeX entrytype ---
            # Попробуем получить тип по ключам 'ENTRYTYPE' и 'entrytype'
            # Если оба не найдены, получим пустую строку
            bibtex_type_raw = entry.get('ENTRYTYPE', entry.get('entrytype', ''))
            bibtex_type_lower = bibtex_type_raw.lower() if isinstance(bibtex_type_raw, str) else ''

            if not bibtex_type_lower:
                 logger.warning(f"Запись с ключом '{entry_key}': Не удалось извлечь тип BibTeX или он пустой ('{bibtex_type_raw}'). Пропускаем.")
                 skipped_entries.append(entry_key)
                 continue


            # Шаг 1: Определить внутренний app_type_name на основе bibtex_type_lower
            app_type_name = BIBTEX_TO_APP_TYPE_MAP.get(bibtex_type_lower)

            if not app_type_name:
                # Пропускаем, если BibTeX тип известен парсеру, но мы не настроили его маппинг в BIBTEX_TO_APP_TYPE_MAP
                logger.warning(f"Запись с ключом '{entry_key}', тип BibTeX '{bibtex_type_lower}': Не маппируется ни на один внутренний тип приложения. Пропускаем.")
                skipped_entries.append(entry_key)
                continue

            # Шаг 2: Найти объект PublicationType в предзагруженных данных по app_type_name
            type_obj = app_types_by_name.get(app_type_name)
            if not type_obj:
                logger.error(f"Запись с ключом '{entry_key}': Внутренний тип приложения '{app_type_name}' (сопоставленный с BibTeX '{bibtex_type_lower}') не найден в базе данных (PublicationType). Пропускаем.")
                skipped_entries.append(entry_key)
                continue

            # Шаг 3 & 4: Найти объект PublicationTypeDisplayName
            expected_display_name_text = APP_TYPE_TO_DISPLAY_NAME_MAP.get(app_type_name)
            if not expected_display_name_text:
                 logger.error(f"Запись с ключом '{entry_key}': Для внутреннего типа '{app_type_name}' не указано ожидаемое русское отображаемое имя в словаре APP_TYPE_TO_DISPLAY_NAME_MAP. Пропускаем.")
                 skipped_entries.append(entry_key)
                 continue

            display_name_obj_key = (type_obj.id, expected_display_name_text)
            display_name_obj = app_display_names_by_key.get(display_name_obj_key)

            if not display_name_obj:
                 logger.error(f"Запись с ключом '{entry_key}': Отображаемое имя '{expected_display_name_text}' для типа '{app_type_name}' (id={type_obj.id}) не найдено в базе данных (PublicationTypeDisplayName). Пропускаем.")
                 skipped_entries.append(entry_key)
                 continue

            # --- Извлечение основных полей (оставлено как было, только strip) ---
            try: # Добавим try/except и для извлечения основных полей на случай неожиданностей
                 title = entry.get('title', 'Без названия').strip()
                 authors = entry.get('author', entry.get('editor', 'Неизвестный автор')).strip()
                 if authors == '': authors = 'Неизвестный автор'

                 year = None
                 year_str = entry.get('year')
                 if year_str:
                     try:
                         year_str_cleaned = "".join(filter(str.isdigit, year_str))
                         if year_str_cleaned:
                             if len(year_str_cleaned) >= 4:
                                year = int(year_str_cleaned[:4])
                             else:
                                # Возможно, стоит более строго проверять год
                                pass # год останется None
                         else:
                            pass

                     except (ValueError, TypeError) as ve:
                         logger.warning(f"Запись с ключом '{entry_key}': Некорректный или нераспознанный формат года '{year_str}'. Год оставлен пустым.", exc_info=True)


                 if year is None:
                     # Можно присвоить текущий год или сделать поле year в модели nullable
                     # Текущий код в models.py имеет year nullable=False, поэтому нужно установить значение
                     year = datetime.now().year # Используем текущий год, если не удалось распознать

                 # Создаём объект Publication
                 publication = Publication(
                     title=title,
                     authors=authors,
                     year=year,
                     type_id=type_obj.id,
                     display_name_id=display_name_obj.id,
                     status='draft',
                     user_id=current_user.id,
                     returned_for_revision=False,
                 )

                 db.session.add(publication)
                 publications_added_count += 1
                 logger.debug(f"Запись с ключом '{entry_key}' (BibTeX: {bibtex_type_lower}, App: {app_type_name}, Display: '{expected_display_name_text}') успешно подготовлена к добавлению.")

            except Exception as field_e:
                 # Логируем ошибки извлечения или создания объекта для конкретной записи
                 logger.error(f"Ошибка извлечения полей или создания объекта для записи с ключом '{entry_key}': {str(field_e)}", exc_info=True)
                 error_entries.append(entry_key)
                 continue # Продолжаем к следующей записи

        # Фиксация изменений
        db.session.commit()
        logger.debug(f"Импорт завершен. Успешно подготовлены и зафиксированы {publications_added_count} публикаций.")

        # Формирование ответа
        response_message = f'Импорт завершен. Добавлено {publications_added_count} публикаций.'
        if skipped_entries:
            skipped_sample = skipped_entries[:10] # Покажем до 10 ключей
            skipped_info = f'Пропущено {len(skipped_entries)} записей из-за неизвестного типа BibTeX или проблем с конфигурацией типов/названий в БД'
            if len(skipped_entries) > 0: # Показываем ключи только если что-то пропущено
                 skipped_info += f' (ключи: {", ".join(skipped_sample)}{"..." if len(skipped_entries) > len(skipped_sample) else ""}).'
            response_message += ' ' + skipped_info
            logger.warning(skipped_info)


        if error_entries:
             error_sample = error_entries[:10] # Покажем до 10 ключей
             error_info = f'Ошибка при обработке {len(error_entries)} записей'
             if len(error_entries) > 0: # Показываем ключи только если были ошибки
                error_info += f' (ключи: {", ".join(error_sample)}{"..." if len(error_entries) > len(error_sample) else ""}). Подробности смотрите в логах.'
             response_message += ' ' + error_info
             logger.error(error_info)


        return jsonify({
            'message': response_message,
            'added_count': publications_added_count,
            'skipped_count': len(skipped_entries),
            'error_count': len(error_entries)
        }), 200

    except UnicodeDecodeError:
         db.session.rollback()
         logger.error(f"Ошибка декодирования файла. Попробуйте использовать UTF-8.", exc_info=True)
         return jsonify({'error': 'Ошибка чтения файла. Проверьте кодировку файла (ожидается UTF-8).'}), 400

    except Exception as e:
        db.session.rollback()
        logger.error(f"Критическая ошибка при обработке BibTeX файла: {str(e)}", exc_info=True)
        return jsonify({'error': f'Внутренняя ошибка при обработке BibTeX файла: {str(e)}'}), 500

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

        # Проверяем, есть ли type_id и display_name_id в форме
        type_id = request.form.get('type_id')
        display_name_id = request.form.get('display_name_id')
        if type_id:
            try:
                type_id = int(type_id)
                type_ = PublicationType.query.get(type_id)
                if not type_:
                    return jsonify({'error': 'Недопустимый тип публикации'}), 400
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

        try:
            db.session.commit()
            return jsonify({
                'message': 'Файл успешно прикреплён',
                'publication': {
                    'id': publication.id,
                    'title': publication.title,
                    'authors': publication.authors,
                    'year': publication.year,
                    'type': {
                        'id': publication.type.id,
                        'name': publication.type.name,
                        'display_name': publication.display_name.display_name if publication.display_name else None,
                        'display_names': [dn.display_name for dn in publication.type.display_names],
                        'display_name_id': publication.display_name_id
                    } if publication.type else None,
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
            'ENTRYTYPE': pub.type.name if pub.type else 'article',
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
    # Получаем данные из запроса
    data = request.get_json()
    # Проверяем наличие обязательных полей
    if not data.get('year') or not data.get('fillType') or 'entries' not in data:
        return jsonify({'error': 'Отсутствуют обязательные поля'}), 400
    
    # Валидация года
    if not isinstance(data['year'], int) or data['year'] < 1900 or data['year'] > 2100:
        return jsonify({'error': 'Недопустимый год'}), 400
    
    # Валидация типа заполнения
    if data['fillType'] not in ['manual', 'link']:
        return jsonify({'error': 'Недопустимый тип заполнения'}), 400

    # Проверяем, нет ли уже утверждённого плана на этот год
    existing_approved_plan = Plan.query.filter_by(
        user_id=current_user.id,
        year=data['year'],
        status='approved'
    ).first()
    if existing_approved_plan:
        return jsonify({'error': f'У вас уже есть утверждённый план на {data["year"]} год.'}), 403

    # Создаём новый план
    plan = Plan(
        year=data['year'],
        fillType=data['fillType'],
        user_id=current_user.id,
        status='draft'
    )
    db.session.add(plan)

    # Обрабатываем записи плана
    for entry_data in data['entries']:
        type_name = entry_data.get('type')
        display_name_id = entry_data.get('display_name_id')  # Новое поле
        # Проверяем тип публикации
        type_ = PublicationType.query.filter_by(name=type_name).first() if type_name else None
        if type_name and not type_:
            db.session.rollback()
            return jsonify({'error': f'Недопустимый тип публикации: {type_name}'}), 400
        
        # Проверяем display_name_id
        display_name = None
        if display_name_id:
            try:
                display_name_id = int(display_name_id)
                display_name = PublicationTypeDisplayName.query.get(display_name_id)
                if not display_name or (type_ and display_name.publication_type_id != type_.id):
                    db.session.rollback()
                    return jsonify({'error': f'Недопустимое русское название с ID: {display_name_id}'}), 400
            except ValueError:
                db.session.rollback()
                return jsonify({'error': 'display_name_id должен быть числом'}), 400

        # Создаём запись плана
        entry = PlanEntry(
            title=entry_data.get('title'),
            type_id=type_.id if type_ else None,
            display_name_id=display_name_id if display_name else None,  # Сохраняем display_name_id
            publication_id=entry_data.get('publication_id'),
            status=entry_data.get('status', 'planned'),
            isPostApproval=False,
            plan=plan
        )
        # Проверяем публикацию, если указан publication_id
        if entry.publication_id:
            publication = Publication.query.filter_by(id=entry.publication_id, user_id=current_user.id, status='published').first()
            if not publication:
                db.session.rollback()
                return jsonify({'error': f'Публикация с ID {entry.publication_id} не найдена или не опубликована'}), 404
        db.session.add(entry)

    # Сохраняем изменения в базе данных
    try:
        db.session.commit()
        logger.debug(f"План создан с ID {plan.id}")
        return jsonify({'message': f'План создан с ID {plan.id}', 'plan': plan.to_dict()}), 201
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка при создании плана: {str(e)}")
        return jsonify({'error': 'Ошибка при создании плана. Попробуйте позже.'}), 500

@bp.route('/plans/<int:plan_id>', methods=['PUT'])
@login_required
def update_plan(plan_id):
    plan = Plan.query.get_or_404(plan_id)
    if plan.user_id != current_user.id:
        return jsonify({'error': 'Unauthorized'}), 403

    data = request.get_json()
    plan.year = data.get('year', plan.year)
    plan.fillType = data.get('fillType', plan.fillType)  # Исправлено

    existing_entries = {entry.id: entry for entry in plan.entries}
    new_entries_data = data.get('entries', [])

    for entry_data in new_entries_data:
        entry_id = entry_data.get('id')
        type_id = entry_data.get('type_id')  # Ожидаем type_id
        display_name_id = entry_data.get('display_name_id')  # Ожидаем display_name_id

        # Валидация type_id
        if type_id is not None:
            type_ = PublicationType.query.get(type_id)
            if not type_:
                return jsonify({'error': f'Invalid type_id: {type_id}'}), 400

        # Валидация display_name_id
        if display_name_id is not None:
            display_name = PublicationTypeDisplayName.query.get(display_name_id)
            if not display_name or (type_id and display_name.publication_type_id != type_id):
                return jsonify({'error': f'Invalid display_name_id: {display_name_id}'}), 400

        if entry_id and entry_id in existing_entries:
            entry = existing_entries[entry_id]
            entry.title = entry_data.get('title', entry.title)
            entry.type_id = type_id if type_id is not None else entry.type_id
            entry.display_name_id = display_name_id if display_name_id is not None else entry.display_name_id
            entry.publication_id = entry_data.get('publication_id', entry.publication_id)
            entry.status = entry_data.get('status', entry.status)
            entry.isPostApproval = entry_data.get('isPostApproval', entry.isPostApproval)
        else:
            new_entry = PlanEntry(
                title=entry_data.get('title'),
                type_id=type_id,
                display_name_id=display_name_id,
                publication_id=entry_data.get('publication_id'),
                status=entry_data.get('status', 'planned'),
                isPostApproval=entry_data.get('isPostApproval', False),
                plan_id=plan.id
            )
            db.session.add(new_entry)

    # Удаление записей, отсутствующих в новом списке
    entry_ids = [entry_data.get('id') for entry_data in new_entries_data if entry_data.get('id')]
    for entry_id, entry in existing_entries.items():
        if entry_id not in entry_ids:
            db.session.delete(entry)

    try:
        db.session.commit()
        return jsonify({'plan': plan.to_dict()}), 200
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error updating plan {plan_id}: {str(e)}")
        return jsonify({'error': 'Error updating plan'}), 500

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

@bp.route('/publication-types', methods=['GET'])
@login_required
def get_publication_types():
    """
    Эндпоинт для получения списка типов публикаций с отдельными русскими названиями.
    Доступен для всех аутентифицированных пользователей.
    """
    logger.debug(f"Получен GET запрос для /api/publication-types от пользователя {current_user.id}")
    
    try:
        types = PublicationType.query.all()
        response = []
        # Для каждого типа создаём запись для каждого display_name
        for type_ in types:
            for dn in type_.display_names:
                response.append({
                    'id': type_.id,  # ID типа публикации
                    'name': type_.name,  # Английское название (например, 'article')
                    'display_name_id': dn.id,  # ID русского названия
                    'display_name': dn.display_name  # Русское название (например, 'Статья')
                })
        
        logger.debug(f"Возвращено {len(response)} вариантов типов публикаций")
        return jsonify(response), 200
    
    except Exception as e:
        logger.error(f"Ошибка получения типов публикаций: {str(e)}")
        return jsonify({'error': 'Ошибка при получении типов публикаций. Попробуйте позже.'}), 500
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