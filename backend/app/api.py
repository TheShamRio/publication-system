from flask import Blueprint, jsonify, request, send_file
from werkzeug.utils import secure_filename
from flask_login import login_required, current_user
from flask import current_app
from collections import defaultdict
from app.extensions import db
from app.models import Publication, User, Plan, PlanEntry, PlanActionHistory, PublicationActionHistory, PublicationType, PublicationTypeDisplayName, PublicationFieldHint, PublicationAuthor
import os
import logging
from io import BytesIO
import bibtexparser
from datetime import datetime
from sqlalchemy import or_
import json


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

@bp.route('/admin/publication-hints', methods=['GET'])
@admin_or_manager_required
def get_admin_publication_hints():
    """Возвращает все подсказки, создавая записи для отсутствующих полей."""
    try:
        hints_db = PublicationFieldHint.query.all()
        hints_dict = {hint.field_name: hint.hint_text for hint in hints_db}

        # Убедимся, что для всех полей из списка есть запись (даже с пустой подсказкой)
        for field_name in PUBLICATION_FIELDS_WITH_HINTS:
            if field_name not in hints_dict:
                hints_dict[field_name] = '' # Добавляем поле с пустой подсказкой

        return jsonify(hints_dict), 200
    except Exception as e:
        logger.error(f"Ошибка получения админских подсказок полей публикации: {str(e)}")
        return jsonify({"error": "Не удалось загрузить подсказки для редактирования."}), 500

@bp.route('/admin/publication-hints', methods=['PUT'])
@admin_or_manager_required
def update_admin_publication_hints():
    """Обновляет подсказки для полей публикации."""
    data = request.get_json()
    if not isinstance(data, dict):
        return jsonify({"error": "Ожидается объект с подсказками."}), 400

    try:
        updated_count = 0
        created_count = 0
        for field_name, hint_text in data.items():
            # Обновляем только те поля, которые есть в нашем списке
            if field_name in PUBLICATION_FIELDS_WITH_HINTS:
                hint = PublicationFieldHint.query.filter_by(field_name=field_name).first()
                cleaned_hint_text = hint_text.strip() if isinstance(hint_text, str) else ''

                if hint:
                    if hint.hint_text != cleaned_hint_text:
                        hint.hint_text = cleaned_hint_text
                        hint.updated_at = datetime.utcnow()
                        # Опционально: hint.updated_by_user_id = current_user.id
                        updated_count += 1
                else:
                    new_hint = PublicationFieldHint(
                        field_name=field_name,
                        hint_text=cleaned_hint_text
                        # Опционально: updated_by_user_id=current_user.id
                    )
                    db.session.add(new_hint)
                    created_count += 1

        db.session.commit()
        logger.info(f"Подсказки обновлены пользователем {current_user.id}. Обновлено: {updated_count}, Создано: {created_count}")
        # Получаем и возвращаем актуальный список подсказок
        all_hints = PublicationFieldHint.query.all()
        hints_dict = {hint.field_name: hint.hint_text for hint in all_hints}
        # Дополняем отсутствующими полями
        for field_name in PUBLICATION_FIELDS_WITH_HINTS:
            if field_name not in hints_dict:
                 hints_dict[field_name] = ''
        return jsonify(hints_dict), 200
    except Exception as e:
        db.session.rollback()
        logger.error(f"Ошибка обновления подсказок: {str(e)}")
        return jsonify({"error": "Ошибка при сохранении подсказок."}), 500

PUBLICATION_FIELDS_WITH_HINTS = [
    'type_id', # ID базового типа (статья, монография)
    'display_name_id', # ID отображаемого названия (Статья РИНЦ, Статья ВАК)
    'title',
    'authors_json', # Или просто 'authors', если на фронте ключ такой
    'year',
    'journal_conference_name',
    'doi',
    'issn',
    'isbn',
    'quartile',
    'volume',
    'number',
    'pages',
    'department',
    'publisher',
    'publisher_location',
    'printed_sheets_volume',
    'circulation',
    'classification_code',
    'notes',
    'file', # Подсказка для поля загрузки файла
]

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
    
@bp.route('/admin/users/<int:user_id>/check-dependencies', methods=['GET'])
@admin_required  # Доступно только администратору
def check_user_dependencies(user_id):
    """Проверяет, есть ли у пользователя зависимости, мешающие удалению."""
    try:
        # Проверка наличия опубликованных публикаций
        has_published_publications = db.session.query(Publication.id)\
            .filter_by(user_id=user_id, status='published')\
            .limit(1).scalar() is not None # Эффективно проверить хотя бы одну

        # Проверка наличия любых планов (независимо от статуса)
        has_plans = db.session.query(Plan.id)\
            .filter_by(user_id=user_id)\
            .limit(1).scalar() is not None # Эффективно проверить хотя бы один

        logger.debug(f"Проверка зависимостей для user {user_id}: "\
                     f"опубл. публикации={has_published_publications}, планы={has_plans}")

        return jsonify({
            "has_published_publications": has_published_publications,
            "has_plans": has_plans
        }), 200

    except Exception as e:
        logger.error(f"Ошибка при проверке зависимостей пользователя {user_id}: {str(e)}")
        return jsonify({"error": "Ошибка сервера при проверке зависимостей пользователя."}), 500

@bp.route('/admin/publications', methods=['GET'])
@admin_or_manager_required
def get_publications():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '', type=str)
    display_name_id_filter = request.args.get('display_name_id', default=None, type=int) # Получаем ID как int или None
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

    if display_name_id_filter is not None:
        query = query.filter(Publication.display_name_id == display_name_id_filter)

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

    publications = [pub.to_dict() for pub in paginated_publications.items]

    return jsonify({
        'publications': publications,
        'pages': paginated_publications.pages,
        'total': paginated_publications.total
    }), 200

@bp.route('/admin/publications/<int:pub_id>', methods=['PUT'])
@admin_or_manager_required
def update_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    data = {} # Инициализируем словарь для данных

    logger = current_app.logger # Используем логгер приложения

    # --- Определяем источник данных (Form или JSON) ---
    is_multipart = 'file' in request.files # Флаг, если есть загрузка файла
    if is_multipart:
        data = request.form.to_dict() # Берем данные из формы
    else:
        # Если не multipart, ожидаем JSON
        content_type = request.content_type
        if content_type and 'application/json' in content_type.lower():
            try:
                json_data = request.get_json()
                if not isinstance(json_data, dict):
                    logger.warning(f"Некорректный JSON получен для публикации {pub_id} (не словарь)")
                    return jsonify({"error": "Ожидались данные в формате JSON."}), 400
                data = json_data
            except Exception as e:
                 logger.error(f"Ошибка парсинга JSON для публикации {pub_id}: {e}")
                 return jsonify({"error": "Не удалось обработать JSON данные."}), 400
        else:
            # Если Content-Type не JSON и нет файла - это ошибка
            logger.error(f"Некорректный Content-Type '{content_type}' для обновления публикации {pub_id} без файла.")
            return jsonify({"error": "Content-Type должен быть 'application/json', если файл не загружается."}), 415

    # --- Обработка Файла (только если is_multipart) ---
    if is_multipart:
        file = request.files['file']
        if file and file.filename != '': # Проверяем, что файл действительно был выбран
            if allowed_file(file.filename):
                # Логика сохранения файла (удаление старого, генерация имени, сохранение)
                if publication.file_url:
                    # Преобразуем URL в путь к файлу на сервере
                    filename_from_url = publication.file_url.split('/')[-1]
                    old_file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename_from_url)
                    if os.path.exists(old_file_path):
                         try:
                              os.remove(old_file_path)
                              logger.info(f"Старый файл {old_file_path} удален для публикации {pub_id}")
                         except OSError as e:
                              logger.error(f"Не удалось удалить старый файл {old_file_path}: {e}")
                # Генерация нового имени файла и сохранение
                filename = secure_filename(file.filename)
                file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
                # Генерация уникального имени, если файл существует
                base, extension = os.path.splitext(filename)
                counter = 1
                while os.path.exists(file_path):
                    filename = f"{base}_{counter}{extension}"
                    file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
                    counter += 1
                try:
                    file.save(file_path)
                    publication.file_url = f"/uploads/{filename}" # Сохраняем относительный URL
                    logger.info(f"Новый файл {filename} сохранен для публикации {pub_id}")
                except Exception as e:
                    logger.error(f"Ошибка при сохранении файла для публикации {pub_id}: {str(e)}")
                    return jsonify({"error": "Ошибка при сохранении файла."}), 500
            else:
                 logger.warning(f"Загружен недопустимый тип файла для публикации {pub_id}: {file.filename}")
                 return jsonify({"error": f"Недопустимый тип файла. Разрешены: {', '.join(ALLOWED_EXTENSIONS)}"}), 400


    # --- Обновление Основных Полей (Работаем со словарем data) ---
    # Используем data.get с запасным вариантом publication.field, чтобы не сбрасывать значение, если ключ отсутствует
    publication.title = data.get('title', publication.title)

    try:
        year_str = data.get('year')
        if year_str is not None: # Обновляем только если год пришел
             publication.year = int(year_str)
    except (ValueError, TypeError):
         logger.warning(f"Не удалось преобразовать год '{data.get('year')}' в число для публикации {pub_id}")
         return jsonify({'error': 'Год должен быть числом'}), 400 # Возвращаем ошибку

    # Обновление Type ID и Display Name ID
    type_id_str = data.get('type_id')
    display_name_id_str = data.get('display_name_id')
    current_type_id = publication.type_id # Запоминаем текущий для проверки display_name_id

    if type_id_str is not None:
        try:
            type_id = int(type_id_str)
            type_ = PublicationType.query.get(type_id)
            if not type_:
                logger.warning(f"Неверный type_id {type_id} при обновлении публикации {pub_id}")
                return jsonify({'error': 'Недопустимый базовый тип публикации'}), 400
            publication.type_id = type_id
            current_type_id = type_id # Обновляем для последующей проверки display_name_id
        except (ValueError, TypeError):
             logger.warning(f"Неверный формат type_id '{type_id_str}' для публикации {pub_id}")
             return jsonify({'error': 'type_id должен быть числом'}), 400

    if display_name_id_str is not None:
        try:
            display_name_id_int = int(display_name_id_str)
            display_name_obj = PublicationTypeDisplayName.query.get(display_name_id_int)
            # Проверяем существование И принадлежность текущему (или новому) базовому типу
            if not display_name_obj or (current_type_id is not None and display_name_obj.publication_type_id != current_type_id):
                logger.warning(f"Недопустимый display_name_id {display_name_id_int} (базовый тип: {current_type_id}) при обновлении публикации {pub_id}")
                return jsonify({'error': 'Недопустимое отображаемое название для выбранного базового типа'}), 400
            publication.display_name_id = display_name_id_int
        except (ValueError, TypeError):
            logger.warning(f"Неверный формат display_name_id '{display_name_id_str}' для публикации {pub_id}")
            return jsonify({'error': 'display_name_id должен быть числом'}), 400
    # Если display_name_id_str не пришел, НЕ сбрасываем publication.display_name_id
    # Оно могло остаться валидным от предыдущего сохранения

    # --- Обновление Авторов ---
    authors_list = None
    if is_multipart and 'authors_json' in data:
        # При multipart данные приходят как строка JSON
        try:
            authors_list = json.loads(data['authors_json'])
            if not isinstance(authors_list, list): raise ValueError("authors_json is not a list")
        except (json.JSONDecodeError, ValueError, TypeError) as e:
            logger.error(f"Ошибка парсинга 'authors_json' из FormData для pub {pub_id}: {e}")
            return jsonify({"error": "Некорректный формат данных авторов в authors_json."}), 400
    elif not is_multipart and 'authors' in data and isinstance(data.get('authors'), list):
        # При JSON данные приходят как список
        authors_list = data['authors']

    if authors_list is not None: # Обновляем только если данные авторов корректны
        try:
            # Эффективное обновление: Удаляем старых, добавляем новых
            PublicationAuthor.query.filter_by(publication_id=publication.id).delete()
            db.session.flush() # Важно применить удаление перед добавлением

            if not authors_list: # Проверяем, что список авторов не пустой после фильтрации на фронте
                 raise ValueError("Список авторов не может быть пустым.")

            for author_data in authors_list:
                if isinstance(author_data, dict) and author_data.get('name', '').strip():
                    name = author_data['name'].strip()
                    is_employee = author_data.get('is_employee', False)
                    # Безопасное преобразование в bool
                    if isinstance(is_employee, str):
                        is_employee = is_employee.lower() in ['true', '1', 'yes']
                    else:
                        is_employee = bool(is_employee)

                    new_author = PublicationAuthor(
                        publication_id=publication.id,
                        name=name,
                        is_employee=is_employee
                    )
                    db.session.add(new_author)
                else:
                    # Если автор пустой или некорректный, но пришел в списке - это ошибка формата
                    logger.warning(f"Некорректные данные автора (отсутствует имя или не словарь) в списке для pub {pub_id}: {author_data}")
                    raise ValueError("Найдены некорректные данные в списке авторов.")
            # db.session.flush() # Flush здесь не обязателен, commit сделает это
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка при обновлении авторов для pub {pub_id}: {str(e)}")
            return jsonify({"error": f"Ошибка при обновлении списка авторов: {str(e)}"}), 500

    # --- Обновление Дополнительных Полей (берем из data) ---
    # Используем get(key, current_value), чтобы не сбрасывать значение, если ключ отсутствует
    publication.journal_conference_name = data.get('journal_conference_name', publication.journal_conference_name)
    publication.doi = data.get('doi', publication.doi)
    publication.issn = data.get('issn', publication.issn)
    publication.isbn = data.get('isbn', publication.isbn)
    publication.quartile = data.get('quartile', publication.quartile)
    publication.volume = data.get('volume', publication.volume)
    publication.number = data.get('number', publication.number)
    publication.pages = data.get('pages', publication.pages)
    publication.department = data.get('department', publication.department)
    publication.publisher = data.get('publisher', publication.publisher)
    publication.publisher_location = data.get('publisher_location', publication.publisher_location)
    publication.classification_code = data.get('classification_code', publication.classification_code)
    publication.notes = data.get('notes', publication.notes)

    # Обновление числовых полей с обработкой None/пустой строки/ошибки
    printed_sheets_str = data.get('printed_sheets_volume')
    if printed_sheets_str is not None: # Только если ключ есть в данных
        if printed_sheets_str == '' or printed_sheets_str is None: publication.printed_sheets_volume = None
        else:
            try: publication.printed_sheets_volume = float(printed_sheets_str)
            except (ValueError, TypeError):
                logger.warning(f"Invalid printed_sheets_volume '{printed_sheets_str}' for pub {pub_id}")
                # Можно вернуть ошибку 400
                return jsonify({"error": f"Некорректное значение для объема (п.л.): '{printed_sheets_str}'"}), 400

    circulation_str = data.get('circulation')
    if circulation_str is not None: # Только если ключ есть в данных
        if circulation_str == '' or circulation_str is None: publication.circulation = None
        else:
            try: publication.circulation = int(circulation_str)
            except (ValueError, TypeError):
                logger.warning(f"Invalid circulation '{circulation_str}' for pub {pub_id}")
                 # Можно вернуть ошибку 400
                return jsonify({"error": f"Некорректное значение для тиража: '{circulation_str}'"}), 400


    # --- Обработка Статуса и Истории ---
    new_status = data.get('status', publication.status)
    # Получаем комментарий, если он пришел (например, для возврата)
    comment = data.get('return_comment', '')

    # Проверка прав на изменение статуса
    allowed_statuses_for_role = {
         'admin': ['draft', 'needs_review', 'published', 'returned_for_revision'],
         'manager': ['needs_review', 'published', 'returned_for_revision'],
     }
    if new_status not in allowed_statuses_for_role.get(current_user.role, []):
         logger.warning(f"Пользователь {current_user.id} ({current_user.role}) попытался установить недопустимый статус '{new_status}' для публикации {pub_id}")
         return jsonify({"error": f"Ваша роль ({current_user.role}) не позволяет установить статус '{new_status}'."}), 403

    # Логика изменения статуса и записи истории
    if new_status != publication.status:
        timestamp = datetime.utcnow()
        action_type = new_status # Тип действия по умолчанию - сам статус
        action_comment = None    # Комментарий по умолчанию

        if new_status == 'published':
             publication.published_at = timestamp
             publication.returned_for_revision = False
             publication.returned_at = None
             publication.return_comment = None
             action_type = 'published'
        elif new_status == 'returned_for_revision':
             # Для админа/менеджера комментарий может быть обязательным
             if current_user.role in ['admin', 'manager'] and not comment:
                 logger.warning(f"Пользователь {current_user.id} не указал комментарий при возврате публикации {pub_id}")
                 # Решите, обязательно ли это для них
                 # return jsonify({"error": "Комментарий обязателен при возврате на доработку."}), 400
                 pass # Пока пропускаем, если админ/менеджер не указал

             publication.returned_for_revision = True
             publication.returned_at = timestamp
             publication.return_comment = comment # Сохраняем комментарий
             publication.published_at = None     # Сбрасываем дату публикации
             action_type = 'returned'
             action_comment = comment if comment else None # Сохраняем непустой комментарий в историю
        else: # Для draft, needs_review
             publication.published_at = None
             publication.returned_for_revision = False
             publication.returned_at = None
             publication.return_comment = None
             action_type = new_status # Тип действия - сам статус

        # Создаем запись истории только при смене статуса
        action = PublicationActionHistory(
             publication_id=publication.id,
             user_id=current_user.id,
             action_type=action_type,
             timestamp=timestamp,
             comment=action_comment
         )
        db.session.add(action)

    # Обновляем статус публикации в любом случае (даже если не менялся, т.к. могли прийти другие данные)
    publication.status = new_status

    # Если статус остался returned_for_revision, но обновился комментарий
    if publication.status == 'returned_for_revision' and comment and publication.return_comment != comment:
         publication.return_comment = comment
         publication.returned_at = datetime.utcnow() # Обновляем дату возврата
         # Опционально: Добавить запись в историю об обновлении комментария
         logger.info(f"Комментарий для возвращенной публикации {pub_id} обновлен пользователем {current_user.id}")


    # --- Сохранение изменений ---
    try:
        db.session.commit()
        logger.info(f"Публикация {pub_id} обновлена пользователем {current_user.id}. Новый статус: {publication.status}, название: '{publication.title}'")
        # Возвращаем обновленные данные публикации
        return jsonify({
            'message': 'Публикация успешно обновлена',
            'publication': publication.to_dict() # Убедитесь, что to_dict актуален
        }), 200
    except Exception as e:
         db.session.rollback()
         logger.exception(f"Ошибка SQLAlchemy при сохранении публикации {pub_id}: {str(e)}") # Используем logger.exception для traceback
         return jsonify({"error": "Внутренняя ошибка сервера при сохранении публикации."}), 500

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

    publications = [pub.to_dict() for pub in paginated_publications.items]

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
            'history_id': action.id,  # <--- Используем ID самой записи истории
            'plan_id': action.plan_id, # <--- Оставляем ID плана, если он нужен
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
        'history_id': action.id, # <--- ID записи истории
        'publication_id': action.publication_id, # <--- ID публикации
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
                    elif entry.type and entry.type.display_names:
                        display_name = entry.type.display_names[0].display_name
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
    """
    Удаляет тип публикации, если он не используется в публикациях или планах.
    Возвращает ошибку, если тип связан с данными.
    """
    # Шаг 1: Находим тип публикации или возвращаем 404
    type_ = PublicationType.query.get_or_404(type_id)
    logger.info(f"Пользователь {current_user.id} пытается удалить тип публикации {type_id}")

    # Шаг 2: Проверяем использование типа в публикациях
    publications_count = Publication.query.filter_by(type_id=type_id).count()

    # Шаг 3: Проверяем использование типа в планах
    plan_entries_count = PlanEntry.query.filter_by(type_id=type_id).count()

    # Шаг 4: Формируем сообщение об ошибке, если тип используется
    if publications_count or plan_entries_count:
        error_parts = []
        if publications_count:
            error_parts.append(f"{publications_count} публикация(й)")
        if plan_entries_count:
            error_parts.append(f"{plan_entries_count} запись(ей) плана")
        error_message = f"Невозможно удалить тип: он используется в {', и '.join(error_parts)}."
        logger.warning(f"Ошибка удаления типа {type_id}: {error_message}")
        return jsonify({'error': error_message}), 400

    # Шаг 5: Удаляем тип, если он не используется
    db.session.delete(type_)
    db.session.commit()
    logger.info(f"Тип публикации {type_id} успешно удалён")
    return jsonify({'message': 'Тип успешно удалён'}), 200