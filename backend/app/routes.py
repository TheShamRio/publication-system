from flask import Blueprint, jsonify, request, make_response, current_app, send_file
from .extensions import db, login_manager, csrf
from .models import User, Publication, Comment, Plan, PlanEntry, PublicationActionHistory, PublicationType, PublicationAuthor , PublicationTypeDisplayName
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
import json
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

    # --- Возвращаем данные через обновленный to_dict ---
    publication_data = publication.to_dict()
    # --- Добавляем комментарии вручную, так как они не часть to_dict ---
    comments_query = Comment.query.filter_by(publication_id=pub_id, parent_id=None).order_by(Comment.created_at.asc())
    comments = comments_query.all()

    def build_comment_tree(comment):
        return {
            'id': comment.id,
            'content': comment.content,
            'user': {'username': comment.user.username, 'full_name': comment.user.full_name, 'role': comment.user.role},
            'created_at': comment.created_at.isoformat(),
            'replies': [build_comment_tree(reply) for reply in comment.replies]
        }

    publication_data['comments'] = [build_comment_tree(comment) for comment in comments]
    # --- Конец добавления комментариев ---

    return jsonify(publication_data), 200


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
    # ... (пагинация и фильтрация как раньше) ...
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    pub_type = request.args.get('type', 'all')
    search = request.args.get('search', '').lower()
    year = request.args.get('year', type=str)
    # Новый поиск по автору
    author_search = request.args.get('author', '').lower()


    query = Publication.query.filter_by(status='published')

    if pub_type and pub_type != 'all':
        type_ = PublicationType.query.filter_by(name=pub_type).first()
        if type_:
            logger.debug(f"Фильтр по типу: {pub_type}, type_id: {type_.id}")
            query = query.filter(Publication.type_id == type_.id)
        else:
            # Если тип не найден, возвращаем пустой результат
            logger.warning(f"Тип публикации не найден: {pub_type}")
            return jsonify({'publications': [], 'total': 0, 'pages': 0, 'current_page': page}), 200

    search_filters = []
    if search:
        search_filters.append(Publication.title.ilike(f'%{search}%'))
        # Искать в поле year как строку (менее эффективно)
        search_filters.append(db.cast(Publication.year, db.String).ilike(f'%{search}%'))

    # Добавляем поиск по авторам в новой таблице
    if search or author_search:
        # Объединяем поисковые строки для авторов
        combined_author_search = f"%{search}%" if search else f"%{author_search}%"
        author_subquery = db.session.query(PublicationAuthor.publication_id)\
            .filter(PublicationAuthor.name.ilike(combined_author_search))\
            .subquery()
        # Ищем публикации, ID которых есть в результатах поиска по авторам ИЛИ по другим полям
        author_filter = Publication.id.in_(db.select(author_subquery.c.publication_id))
        if search: # Если искали и в других полях
            search_filters.append(author_filter)
            query = query.filter(db.or_(*search_filters))
        else: # Если искали только по автору
             query = query.filter(author_filter)
    elif search_filters: # Если был только поиск по title/year
        query = query.filter(db.or_(*search_filters))


    if year:
        try:
            year_int = int(year)
            query = query.filter(Publication.year == year_int)
        except ValueError:
            logger.warning(f"Недопустимый год: {year}")

    # --- Сортировка как раньше ---
    query = query.order_by(
        db.func.coalesce(Publication.published_at, Publication.updated_at).desc()
    )


    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    publications = pagination.items

    # --- Формирование ответа использует to_dict ---
    response = [pub.to_dict() for pub in publications] # Проще!

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
    logger.debug(f"Получен GET запрос для /publications от пользователя {current_user.id}")
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '').lower()
    pub_type = request.args.get('type', 'all') # Если используется фронтом для старого фильтра
    display_name_id = request.args.get('display_name_id', type=int)
    status = request.args.get('status', 'all')
    # Новый поиск по автору
    author_search = request.args.get('author', '').lower()


    query = Publication.query.filter_by(user_id=current_user.id)

    # --- Логика фильтрации по типу/display_name как раньше ---
    if display_name_id:
        query = query.filter(Publication.display_name_id == display_name_id)
    elif pub_type != 'all': # Устаревший фильтр, возможно, убрать?
        type_ = PublicationType.query.filter_by(name=pub_type).first()
        if type_:
            query = query.filter(Publication.type_id == type_.id)
        # Если тип не найден, возвращаем пустой результат
        else:
            return jsonify({'publications': [], 'total': 0, 'pages': 0, 'current_page': page}), 200

    if status != 'all':
        query = query.filter(Publication.status == status)


    # --- Логика поиска ---
    search_filters = []
    if search:
        search_filters.append(Publication.title.ilike(f'%{search}%'))
        search_filters.append(db.cast(Publication.year, db.String).ilike(f'%{search}%'))

    # Добавляем поиск по авторам
    if search or author_search:
        combined_author_search = f"%{search}%" if search else f"%{author_search}%"
        author_subquery = db.session.query(PublicationAuthor.publication_id)\
            .filter(PublicationAuthor.publication_id == Publication.id).filter(PublicationAuthor.name.ilike(combined_author_search))\
                            .exists() # Используем exists() для фильтра
        # Фильтруем основную таблицу
        author_filter = author_subquery
        if search: # Если искали и в других полях
            search_filters.append(author_filter)
            query = query.filter(db.or_(*search_filters))
        else: # Если искали только по автору
            query = query.filter(author_filter)
    elif search_filters: # Если был только поиск по title/year
        query = query.filter(db.or_(*search_filters))


    # --- Сортировка как раньше ---
    query = query.order_by(Publication.updated_at.desc())


    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    publications = pagination.items

    # --- Формирование ответа использует to_dict ---
    response = [pub.to_dict() for pub in publications]

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

    # --- Проверки прав и статуса (как раньше) ---
    if publication.user_id != current_user.id:
        logger.warning(f"Пользователь {current_user.id} (роль: {current_user.role}) пытался {request.method} публикацию {pub_id} другого пользователя.")
        return jsonify({'error': 'У вас нет прав на управление этой публикацией'}), 403

    if publication.status == 'needs_review':
        logger.warning(f"Пользователь {current_user.id} пытался {request.method} публикацию {pub_id} в статусе 'needs_review'.")
        return jsonify({'error': 'Нельзя управлять публикацией (редактировать или удалить), пока она на проверке.'}), 403
    # Дополнительно: возможно, запретить PUT/DELETE для published тоже?
    # if publication.status == 'published':
    #      logger.warning(f"Пользователь {current_user.id} пытался {request.method} опубликованную публикацию {pub_id}.")
    #      return jsonify({'error': 'Нельзя управлять опубликованной публикацией через этот интерфейс.'}), 403


    if request.method == 'PUT':
        # --- Получение данных (как раньше) ---
        if request.content_type == 'application/json':
            data = request.get_json()
            # Ожидаем authors как список объектов в data
            authors_data_received = data.get('authors')
            if authors_data_received is not None and not isinstance(authors_data_received, list):
                 return jsonify({'error': 'Поле authors должно быть массивом'}), 400
        elif 'file' in request.files or request.content_type.startswith('multipart/form-data'):
            data = request.form
            # Ожидаем authors как JSON-строку в form
            authors_json = data.get('authors_json')
            try:
                # authors_data_received может быть None, если поле не передано
                authors_data_received = json.loads(authors_json) if authors_json else None
                if authors_data_received is not None and not isinstance(authors_data_received, list):
                    raise ValueError("Authors data must be a list.")
            except (json.JSONDecodeError, ValueError) as e:
                logger.error(f"Invalid authors_json format during update: {authors_json}. Error: {e}")
                return jsonify({'error': f'Некорректный формат JSON для authors_json: {e}'}), 400
        else:
            return jsonify({"error": "Неподдерживаемый формат данных."}), 415


        # --- Валидация полученных данных авторов (если они передавались) ---
        if authors_data_received is not None:
             if not authors_data_received: # Запрещаем пустой список, если поле было передано
                  return jsonify({'error': 'Список авторов не может быть пустым, если он передается.'}), 400
             try:
                 for author_item in authors_data_received:
                     if not isinstance(author_item, dict) or 'name' not in author_item or 'is_employee' not in author_item:
                         raise ValueError("Each author must be an object with 'name' and 'is_employee'.")
                     if not isinstance(author_item['name'], str) or not author_item['name'].strip():
                         raise ValueError("Author name cannot be empty.")
                     if not isinstance(author_item['is_employee'], bool):
                         raise ValueError("Author 'is_employee' must be boolean.")
             except ValueError as e:
                 logger.error(f"Invalid authors format during update: {authors_data_received}. Error: {e}")
                 return jsonify({'error': f'Некорректный формат данных авторов: {e}'}), 400
        # --- Конец валидации ---

        old_status = publication.status

        # --- Обработка файла (как раньше) ---
        if 'file' in request.files:
            file = request.files['file']
            if file and allowed_file(file.filename):
                # Удаление старого файла...
                if publication.file_url:
                    try:
                        old_file_path_segment = publication.file_url.split('/uploads/')[-1]
                        old_file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], old_file_path_segment)
                        if os.path.exists(old_file_path):
                            os.remove(old_file_path)
                            logger.debug(f"Старый файл '{old_file_path_segment}' удален для публикации {pub_id}.")
                    except Exception as file_del_e:
                        logger.error(f"Ошибка при удалении старого файла '{publication.file_url}': {str(file_del_e)}")
                # Сохранение нового файла...
                filename = secure_filename(file.filename)
                upload_folder = current_app.config['UPLOAD_FOLDER']
                if not os.path.exists(upload_folder):
                    os.makedirs(upload_folder)
                    logger.debug(f"Создана директория загрузки: {upload_folder}")

                file_path = os.path.join(upload_folder, filename)
                # Логика предотвращения перезаписи...
                if os.path.exists(file_path):
                    base, extension = os.path.splitext(filename)
                    counter = 1
                    while os.path.exists(file_path):
                        filename = f"{base}_{counter}{extension}"
                        file_path = os.path.join(upload_folder, filename)
                        counter += 1
                try:
                    file.save(file_path)
                    publication.file_url = f"/uploads/{filename}" # Путь относительно корня сайта
                    logger.debug(f"Новый файл '{filename}' успешно прикреплен к публикации {pub_id}.")
                except Exception as save_err:
                    logger.error(f"Ошибка сохранения файла {filename}: {save_err}")
                    return jsonify({'error': 'Ошибка при сохранении файла.'}), 500

        # --- Обновление полей публикации (кроме authors) ---
        # Обязательные поля
        if 'title' in data and data.get('title') is not None:
            publication.title = data['title'].strip()
            if not publication.title: return jsonify({'error': 'Название не может быть пустым.'}), 400
        if 'year' in data and data.get('year') is not None:
            try:
                 year_int = int(data['year'])
                 if year_int < 1900 or year_int > datetime.now().year + 5: # Допуск +5 лет
                     raise ValueError("Invalid year range")
                 publication.year = year_int
            except (ValueError, TypeError):
                 logger.error(f"Ошибка обновления публикации {pub_id}: Неверный формат года '{data.get('year')}'")
                 return jsonify({'error': 'Неверный формат года.'}), 400

        # Типы (Nullable поля)
        type_id_data = data.get('type_id')
        display_name_id_data = data.get('display_name_id')
        type_id = None # Для проверки display_name
        if type_id_data is not None:
            try:
                 type_id = int(type_id_data) if str(type_id_data).strip() else None
                 if type_id is not None and not PublicationType.query.get(type_id):
                      return jsonify({'error': f'Недопустимый type_id: {type_id}'}), 400
                 publication.type_id = type_id
            except (ValueError, TypeError):
                 return jsonify({'error': 'type_id должен быть числом или null.'}), 400
        else:
             type_id = publication.type_id # Используем текущий для проверки display_name


        if display_name_id_data is not None:
             try:
                 display_name_id = int(display_name_id_data) if str(display_name_id_data).strip() else None
                 if display_name_id is not None:
                      display_name = PublicationTypeDisplayName.query.get(display_name_id)
                      if not display_name or (type_id is not None and display_name.publication_type_id != type_id):
                           return jsonify({'error': f'Недопустимое русское название (ID: {display_name_id}) для выбранного типа публикации (ID: {type_id}).'}), 400
                 publication.display_name_id = display_name_id
             except (ValueError, TypeError):
                  return jsonify({'error': 'display_name_id должен быть числом или null.'}), 400


        # Обновление статуса (остается без изменений, так как не влияет на авторов)
        new_status = data.get('status') # ПОЛЬЗОВАТЕЛЬ НЕ МОЖЕТ МЕНЯТЬ СТАТУС ЭТИМ ЭНДПОИНТОМ
                                        # Он всегда должен быть 'draft' или 'returned_for_revision' при сохранении
        # Поэтому мы НЕ ОБНОВЛЯЕМ статус здесь. Статус меняется через отдельные эндпоинты (/submit-for-review)
        # или админом (/publish, /return-for-revision)
        # При редактировании пользователем публикации со статусом 'returned_for_revision',
        # можно автоматически менять статус обратно на 'draft' или делать это на фронте
        # Если публикация 'returned_for_revision', сбрасываем флаг и коммент при любом сохранении пользователем
        if publication.status == 'returned_for_revision':
             publication.returned_for_revision = False
             publication.return_comment = None
             publication.returned_at = None # Сбросим дату возврата
             # Можно автоматически вернуть в draft, но безопаснее ожидать submit_for_review
             # publication.status = 'draft'


        # --- Обновление авторов ---
        if authors_data_received is not None:
            # 1. Удаляем старых авторов (самый простой способ при использовании cascade=all, delete-orphan)
            publication.authors.clear() # SQLAlchemy удалит связанные объекты при commit
            # 2. Создаем новых (без commit пока)
            for author_data in authors_data_received:
                new_author = PublicationAuthor(
                    name=author_data['name'].strip(),
                    is_employee=author_data['is_employee'],
                    publication=publication # Связь устанавливается, но в БД добавится при commit
                )
                db.session.add(new_author)
            logger.debug(f"Authors for publication {pub_id} are set to be updated.")
        # --- Конец обновления авторов ---

        publication.updated_at = datetime.utcnow() # Обновляем дату изменения

        try:
            db.session.commit() # Фиксируем все изменения
            logger.debug(f"Публикация {pub_id} успешно обновлена пользователем {current_user.id}.")
            db.session.refresh(publication)
            return jsonify({
                'message': 'Публикация успешно обновлена',
                'publication': publication.to_dict() # Используем to_dict
            }), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка при сохранении обновления публикации {pub_id}: {str(e)}", exc_info=True)
            return jsonify({"error": "Ошибка при обновлении публикации. Попробуйте позже."}), 500


    elif request.method == 'DELETE':
        # --- Логика DELETE (как раньше) ---
        # Можно добавить проверку, если нужно запретить удаление опубликованных
        if publication.status == 'published' and current_user.role != 'admin':
             logger.warning(f"Пользователь {current_user.id} пытался удалить опубликованную публикацию {pub_id}.")
             return jsonify({'error': 'Нельзя удалить опубликованную публикацию.'}), 403

        try:
            # Удаление файла, если есть
            if publication.file_url:
                 try:
                     file_path_segment = publication.file_url.split('/uploads/')[-1]
                     file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], file_path_segment)
                     if os.path.exists(file_path):
                          os.remove(file_path)
                          logger.debug(f"Файл '{file_path_segment}' удален перед удалением публикации {pub_id}.")
                 except Exception as file_del_e:
                      logger.error(f"Ошибка при удалении файла '{publication.file_url}' при удалении публикации: {str(file_del_e)}")
                      # Не прерываем удаление из БД

            # SQLAlchemy обработает удаление авторов благодаря cascade='all, delete-orphan'
            db.session.delete(publication)
            db.session.commit()
            logger.debug(f"Публикация {pub_id} успешно удалена пользователем {current_user.id}")
            return jsonify({'message': 'Публикация успешно удалена!'}), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка при удалении публикации {pub_id}: {str(e)}", exc_info=True)
            return jsonify({'error': 'Произошла ошибка при удалении публикации.'}), 500

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
    # --- Удаляем старое поле authors ---
    # authors = request.form.get('authors')
    # --- Получаем новое поле authors_json ---
    authors_json = request.form.get('authors_json')

    year = request.form.get('year')
    type_id = request.form.get('type_id')
    display_name_id = request.form.get('display_name_id')

    # --- Обновляем проверку ---
    if not title or not year or not type_id or not authors_json:
        return jsonify({'error': 'Название, год, тип и хотя бы один автор обязательны'}), 400

    # --- Парсинг и валидация JSON авторов ---
    try:
        authors_data = json.loads(authors_json)
        if not isinstance(authors_data, list) or not authors_data:
             raise ValueError("Authors data must be a non-empty list.")
        for author_item in authors_data:
             if not isinstance(author_item, dict) or 'name' not in author_item or 'is_employee' not in author_item:
                 raise ValueError("Each author must be an object with 'name' and 'is_employee'.")
             if not isinstance(author_item['name'], str) or not author_item['name'].strip():
                 raise ValueError("Author name cannot be empty.")
             if not isinstance(author_item['is_employee'], bool):
                  raise ValueError("Author 'is_employee' must be boolean.")
    except (json.JSONDecodeError, ValueError) as e:
        logger.error(f"Invalid authors_json format: {authors_json}. Error: {e}")
        return jsonify({'error': f'Некорректный формат данных авторов: {e}'}), 400
    # --- Конец парсинга ---

    # --- Проверка года, type_id, display_name_id (как раньше) ---
    try:
        year_int = int(year)
        if year_int < 1900 or year_int > datetime.now().year + 5: # Допуск +5 лет
             raise ValueError("Invalid year range")
        type_id_int = int(type_id) if type_id else None
        display_name_id_int = int(display_name_id) if display_name_id else None
    except (ValueError, TypeError):
        return jsonify({'error': 'Год, type_id и display_name_id (если переданы) должны быть числами'}), 400

    type_ = PublicationType.query.get(type_id_int) if type_id_int else None
    if not type_:
        return jsonify({'error': 'Недопустимый тип публикации'}), 400

    if display_name_id_int:
        display_name = PublicationTypeDisplayName.query.get(display_name_id_int)
        if not display_name or display_name.publication_type_id != type_id_int:
            return jsonify({'error': 'Недопустимое русское название для выбранного типа'}), 400
    else:
         display_name = None # Явно


    # --- Загрузка файла (как раньше, но с улучшенной обработкой ошибок) ---
    filename = secure_filename(file.filename)
    upload_folder = current_app.config['UPLOAD_FOLDER']
    if not os.path.exists(upload_folder):
        os.makedirs(upload_folder)
        logger.debug(f"Создана директория загрузки: {upload_folder}")
    file_path = os.path.join(upload_folder, filename)
    if os.path.exists(file_path):
        base, extension = os.path.splitext(filename)
        counter = 1
        while os.path.exists(file_path):
            filename = f"{base}_{counter}{extension}"
            file_path = os.path.join(upload_folder, filename)
            counter += 1
    try:
        file.save(file_path)
    except Exception as save_err:
        logger.error(f"Ошибка сохранения файла {filename}: {save_err}")
        return jsonify({'error': 'Ошибка при сохранении файла.'}), 500


    # --- Создание объектов Publication и PublicationAuthor ---
    publication = Publication(
        title=title.strip(),
        # authors=authors, # Удалено
        year=year_int,
        type_id=type_id_int,
        display_name_id=display_name_id_int,
        status='draft',
        file_url=f"/uploads/{filename}", # Путь относительно корня сайта
        user_id=current_user.id,
        returned_for_revision=False,
    )
    # Сразу добавляем авторов к объекту Publication перед commit
    for author_data in authors_data:
        pub_author = PublicationAuthor(
            name=author_data['name'].strip(),
            is_employee=author_data['is_employee'],
            publication=publication # Устанавливаем связь
        )
        # publication.authors.append(pub_author) # SQLAlchemy >= 1.4 сделает это неявно
                                                 # при установке publication=publication

    db.session.add(publication) # Добавляем публикацию (авторы добавятся через cascade)

    # --- Сохранение в БД ---
    try:
        db.session.commit()
        logger.debug(f"Publication {publication.id} created with {len(authors_data)} authors.")
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error creating publication with authors: {e}", exc_info=True)
        # Удаляем загруженный файл, если запись в БД не удалась
        if os.path.exists(file_path):
            try:
                os.remove(file_path)
                logger.debug(f"Removed uploaded file {filename} due to DB error.")
            except OSError as file_err:
                logger.error(f"Error removing file {filename} after DB error: {file_err}")
        return jsonify({'error': 'Ошибка при сохранении публикации и авторов'}), 500

    # --- Возврат результата (использует обновленный to_dict) ---
    return jsonify({
        'message': 'Публикация успешно загружена',
        'publication': publication.to_dict()
    }), 201 # Используем статус 201 Created


# --- Константы для BibTeX импорта (как раньше) ---
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
APP_TYPE_TO_DISPLAY_NAME_MAP = {
    'article': 'Статья',
    'conference': 'Конференция',
    'book': 'Книга',
    'misc': 'Депонированная рукопись', # Ваше специфическое маппирование 'misc'
    'phdthesis': 'Докторская диссертация',
    'mastersthesis': 'Магистерская диссертация',
}

# --- Обновленный эндпоинт upload_bibtex ---

@bp.route('/publications/upload-bibtex', methods=['POST'])
@login_required
def upload_bibtex():
    logger.debug(f"Получен POST запрос для /publications/upload-bibtex")
    # ... (проверка файла как раньше) ...
    if 'file' not in request.files:
        logger.warning("BibTeX файл не предоставлен в запросе.")
        return jsonify({'error': 'BibTeX файл не предоставлен'}), 400
    file = request.files['file']
    if not file or not file.filename.lower().endswith('.bib'):
        filename = file.filename if file else 'Нет файла'
        logger.warning(f"Получен недопустимый файл: {filename}. Ожидается .bib")
        return jsonify({'error': 'Недопустимый файл. Ожидается .bib'}), 400

    try:
        content = file.read().decode('utf-8') # Предполагаем UTF-8
        logger.debug(f"Файл {file.filename} успешно прочитан и декодирован.")

        bib_database = bibtexparser.loads(content)
        logger.debug(f"Парсинг BibTeX файла завершен. Найдено {len(bib_database.entries)} записей.")

        publications_added_count = 0
        skipped_entries = []
        error_entries = []

        # --- Предзагрузка типов и названий (как раньше) ---
        try:
            app_types_by_name = {pt.name: pt for pt in PublicationType.query.all()}
            app_display_names_by_key = {(pnd.publication_type_id, pnd.display_name): pnd
                                        for pnd in PublicationTypeDisplayName.query.all()}
            logger.debug(f"Загружено {len(app_types_by_name)} типов PublicationType и {len(app_display_names_by_key)} объектов PublicationTypeDisplayName.")
        except Exception as e:
             logger.error(f"Ошибка предварительной загрузки типов и названий из БД: {str(e)}", exc_info=True)
             db.session.rollback() # Откатываем на всякий случай
             return jsonify({'error': 'Ошибка настройки базы данных типов публикаций.'}), 500


        for entry in bib_database.entries:
            entry_key = entry.get('ID', 'Без ключа')

            # --- Определение типа и display name (как раньше) ---
            bibtex_type_raw = entry.get('ENTRYTYPE', entry.get('entrytype', ''))
            bibtex_type_lower = bibtex_type_raw.lower() if isinstance(bibtex_type_raw, str) else ''
            if not bibtex_type_lower:
                 logger.warning(f"Запись с ключом '{entry_key}': Не удалось извлечь тип BibTeX или он пустой ('{bibtex_type_raw}'). Пропускаем.")
                 skipped_entries.append(entry_key)
                 continue

            app_type_name = BIBTEX_TO_APP_TYPE_MAP.get(bibtex_type_lower)
            if not app_type_name:
                logger.warning(f"Запись '{entry_key}', тип BibTeX '{bibtex_type_lower}': Не маппируется. Пропускаем.")
                skipped_entries.append(entry_key)
                continue

            type_obj = app_types_by_name.get(app_type_name)
            if not type_obj:
                logger.error(f"Запись '{entry_key}': Внутренний тип '{app_type_name}' не найден в БД. Пропускаем.")
                skipped_entries.append(entry_key)
                continue

            expected_display_name_text = APP_TYPE_TO_DISPLAY_NAME_MAP.get(app_type_name)
            if not expected_display_name_text:
                 logger.error(f"Запись '{entry_key}': Для типа '{app_type_name}' не настроено русское имя в APP_TYPE_TO_DISPLAY_NAME_MAP. Пропускаем.")
                 skipped_entries.append(entry_key)
                 continue

            display_name_obj_key = (type_obj.id, expected_display_name_text)
            display_name_obj = app_display_names_by_key.get(display_name_obj_key)
            if not display_name_obj:
                 logger.error(f"Запись '{entry_key}': Русское имя '{expected_display_name_text}' для типа '{app_type_name}' (id={type_obj.id}) не найдено в БД. Пропускаем.")
                 skipped_entries.append(entry_key)
                 continue


            # --- Блок создания записи (ОБНОВЛЕН для авторов) ---
            try:
                 # Извлечение title, year
                 title = entry.get('title', 'Без названия').strip()
                 if not title: title = 'Без названия' # Гарантия непустого заголовка
                 year_str = entry.get('year')
                 year = None
                 if year_str:
                     try:
                         year_str_cleaned = "".join(filter(str.isdigit, year_str))
                         if len(year_str_cleaned) >= 4:
                             year = int(year_str_cleaned[:4])
                     except (ValueError, TypeError) as ve:
                         logger.warning(f"Запись '{entry_key}': Некорректный год '{year_str}'. Год оставлен пустым.")
                 if year is None or year < 1900 or year > datetime.now().year + 5:
                     year = datetime.now().year # По умолчанию текущий год при ошибке

                 # --- Парсинг авторов ---
                 author_string = entry.get('author', entry.get('editor', '')).strip()
                 author_names = []
                 if author_string:
                     # Используем простой split, его может потребоваться улучшить для сложных случаев
                     author_names = [name.strip() for name in author_string.split(' and ') if name.strip()]
                 if not author_names:
                     author_names = ['Неизвестный автор'] # Гарантируем хотя бы одного
                 # --- Конец парсинга авторов ---


                 # --- Создание Publication (без авторов пока) ---
                 publication = Publication(
                     title=title,
                     year=year,
                     type_id=type_obj.id,
                     display_name_id=display_name_obj.id,
                     status='draft',
                     user_id=current_user.id,
                     returned_for_revision=False,
                 )
                 # --- Создание PublicationAuthor ---
                 for author_name in author_names:
                     pub_author = PublicationAuthor(
                         name=author_name,
                         is_employee=False, # По умолчанию не сотрудник
                         publication=publication # Связь
                     )
                     # publication.authors.append(pub_author) # Неявно добавится

                 # Добавляем объект Publication в сессию (авторы добавятся через cascade)
                 db.session.add(publication)
                 # НЕ делаем commit внутри цикла!

                 publications_added_count += 1
                 logger.debug(f"Запись '{entry_key}' (BibTeX: {bibtex_type_lower}) успешно подготовлена.")

            except Exception as field_e:
                 logger.error(f"Ошибка обработки записи '{entry_key}': {str(field_e)}", exc_info=True)
                 error_entries.append(entry_key)
                 # ВАЖНО: Не откатываем сессию здесь, чтобы не потерять другие записи.
                 # Обработка ошибок commit будет после цикла.
                 continue
            # --- Конец блока try/except для записи ---


        # --- Фиксация изменений ПОСЛЕ ЦИКЛА ---
        try:
            if publications_added_count > 0: # Только если есть что коммитить
                db.session.commit()
                logger.debug(f"Импорт завершен. Успешно зафиксированы {publications_added_count} публикаций.")
            else:
                logger.debug("Нет публикаций для фиксации.")
        except Exception as commit_e:
             db.session.rollback() # Откатываем ВЕСЬ импорт при ошибке
             logger.error(f"Критическая ошибка при фиксации BibTeX импорта: {str(commit_e)}", exc_info=True)
             # Формируем сообщение об ошибке
             response_message = f'Импорт завершен. Добавлено 0 публикаций. Ошибка базы данных при сохранении.'
             if skipped_entries:
                 response_message += f' Пропущено {len(skipped_entries)} записей.'
             if error_entries:
                  response_message += f' Ошибка при обработке {len(error_entries)} записей.'
             return jsonify({
                'message': response_message,
                'added_count': 0,
                'skipped_count': len(skipped_entries),
                'error_count': len(error_entries),
                'db_error': True # Флаг ошибки БД
             }), 500


        # --- Формирование успешного ответа (как раньше) ---
        response_message = f'Импорт завершен. Добавлено {publications_added_count} публикаций.'
        if skipped_entries:
            skipped_sample = skipped_entries[:10]
            skipped_info = f'Пропущено {len(skipped_entries)} записей из-за типа/названия'
            if skipped_sample: skipped_info += f' (ключи: {", ".join(skipped_sample)}{"..." if len(skipped_entries) > len(skipped_sample) else ""}).'
            response_message += ' ' + skipped_info
            logger.warning(skipped_info)
        if error_entries:
             error_sample = error_entries[:10]
             error_info = f'Ошибка при обработке {len(error_entries)} записей'
             if error_sample: error_info += f' (ключи: {", ".join(error_sample)}{"..." if len(error_entries) > len(error_sample) else ""}). Подробности в логах.'
             response_message += ' ' + error_info
             logger.error(error_info)

        return jsonify({
            'message': response_message,
            'added_count': publications_added_count,
            'skipped_count': len(skipped_entries),
            'error_count': len(error_entries)
        }), 200

    except UnicodeDecodeError:
         # Откатываем, если что-то попало в сессию до ошибки декодирования (маловероятно)
         db.session.rollback()
         logger.error(f"Ошибка декодирования BibTeX файла. Ожидается UTF-8.", exc_info=True)
         return jsonify({'error': 'Ошибка чтения файла. Проверьте кодировку (ожидается UTF-8).'}), 400
    except Exception as e:
        db.session.rollback() # Откат при любых других ошибках парсинга или инициализации
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
                'publication': publication.to_dict() # Используем готовый метод
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
        logger.debug(f"Запрос публикаций для пользователя {current_user.id}")
        publications = Publication.query.filter_by(user_id=current_user.id).all()
        logger.debug(f"Найдено публикаций: {len(publications)}")

        bib_db = BibDatabase()
        entries_list = [] # Собираем записи в список
        for pub in publications:
            # --- Собираем авторов ---
            author_names = [author.name for author in pub.authors] # Получаем список имен
            author_string = ' and '.join(author_names) if author_names else 'Неизвестный автор'
            # --- Конец сборки авторов ---

            entries_list.append({
                # --- Используем 'misc' как запасной вариант, если тип не указан ---
                'ENTRYTYPE': pub.type.name if pub.type else 'misc',
                'ID': f'pub{pub.id}',
                'title': pub.title or 'Без названия',
                'author': author_string, # Используем собранную строку
                'year': str(pub.year) if pub.year else str(datetime.now().year)
            })
        bib_db.entries = entries_list # Присваиваем готовый список

        writer = BibTexWriter()
        # Проверка callable не обязательна для bibtexparser >= 1.4.0
        # if not callable(getattr(writer, 'write', None)):
        #     raise AttributeError("Метод write в BibTexWriter не найден или не callable.")

        bibtex_str = writer.write(bib_db)

        response = make_response(bibtex_str)
        response.headers['Content-Disposition'] = 'attachment; filename=publications.bib'
        response.headers['Content-Type'] = 'application/x-bibtex; charset=utf-8' # Укажем кодировку
        logger.debug("BibTeX успешно сгенерирован и отправлен")
        return response
    except ImportError as e:
        logger.error(f"Ошибка импорта bibtexparser: {str(e)}", exc_info=True)
        return jsonify({'error': 'Ошибка импорта библиотеки bibtexparser.'}), 500
    except AttributeError as e:
        logger.error(f"Ошибка атрибута в bibtexparser: {str(e)}", exc_info=True)
        return jsonify({'error': 'Ошибка в библиотеке bibtexparser. Проверьте версию.'}), 500
    except Exception as e:
        logger.error(f"Ошибка экспорта BibTeX: {str(e)}", exc_info=True)
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