from flask import Blueprint, jsonify, request, make_response, current_app, send_file
from .extensions import db, login_manager, csrf
from .models import User, Publication, Comment, Plan, PlanEntry, PublicationActionHistory, PublicationType, PublicationAuthor , PublicationTypeDisplayName, PublicationFieldHint  
from .utils import allowed_file
from flask_login import login_user, current_user, logout_user, login_required
from werkzeug.utils import secure_filename
from flask_wtf.csrf import generate_csrf
import os
from .report_generator import generate_excel_report # Импортируйте вашу новую функцию
from io import BytesIO
from .analytics import get_publications_by_year
import bibtexparser
from reportlab.platypus import SimpleDocTemplate, Paragraph
from reportlab.lib.pagesizes import letter
from bibtexparser.bibdatabase import BibDatabase
from bibtexparser.bwriter import BibTexWriter
from bibtexparser.customization import homogenize_latex_encoding, splitname # Для парсинга авторов
import logging
from datetime import datetime, timedelta, UTC
import json
from werkzeug.security import generate_password_hash, check_password_hash

bp = Blueprint('api', __name__, url_prefix='/api')

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

@bp.route('/publication-hints', methods=['GET'])
@login_required # Подсказки доступны авторизованным пользователям
def get_publication_hints():
    """Возвращает все сохраненные подсказки для полей публикации."""
    try:
        hints = PublicationFieldHint.query.all()
        hints_dict = {hint.field_name: hint.hint_text for hint in hints}
        return jsonify(hints_dict), 200
    except Exception as e:
        logger.error(f"Ошибка получения подсказок полей публикации: {str(e)}")
        return jsonify({"error": "Не удалось загрузить подсказки."}), 500

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

@bp.route('/publications/export-excel', methods=['GET'])
@login_required
def export_excel_report():
    """
    Генерирует и отдает Excel отчет по публикациям текущего пользователя.
    Принимает опциональные параметры start_date и end_date для фильтрации.
    """
    user_id = current_user.id
    logger.debug(f"Запрос на генерацию Excel отчета для пользователя {user_id}")

    # --- ПОЛУЧЕНИЕ И ПАРСИНГ ДАТ ---
    start_date_str = request.args.get('start_date')
    end_date_str = request.args.get('end_date')

    start_date = None
    end_date = None

    if start_date_str:
        try:
            start_date = datetime.strptime(start_date_str, '%Y-%m-%d')
            logger.debug(f"Парсинг start_date: {start_date_str} -> {start_date}")
        except ValueError:
            logger.warning(f"Неверный формат start_date: {start_date_str}")
            return jsonify({'error': 'Неверный формат начальной даты. Используйте YYYY-MM-DD.'}), 400

    if end_date_str:
        try:
            # Парсим как дату, время будет 00:00:00
            end_date = datetime.strptime(end_date_str, '%Y-%m-%d')
            logger.debug(f"Парсинг end_date: {end_date_str} -> {end_date}")
        except ValueError:
            logger.warning(f"Неверный формат end_date: {end_date_str}")
            return jsonify({'error': 'Неверный формат конечной даты. Используйте YYYY-MM-DD.'}), 400

    # Проверка: начальная дата не должна быть позже конечной
    if start_date and end_date and start_date > end_date:
        logger.warning("Начальная дата позже конечной.")
        return jsonify({'error': 'Начальная дата не может быть позже конечной даты.'}), 400
    # --- КОНЕЦ ПОЛУЧЕНИЯ И ПАРСИНГА ДАТ ---

    try:
        # --- ПЕРЕДАЧА ДАТ В ФУНКЦИЮ ГЕНЕРАЦИИ ---
        excel_data_bytes = generate_excel_report(user_id, start_date, end_date)
        # --- КОНЕЦ ПЕРЕДАЧИ ДАТ ---

        # Формируем имя файла
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        date_range_suffix = ""
        if start_date or end_date:
            date_range_suffix += "_"
            if start_date: date_range_suffix += f"from_{start_date.strftime('%Y%m%d')}"
            if end_date: date_range_suffix += f"_to_{end_date.strftime('%Y%m%d')}"

        filename = f"publications_report_{current_user.username}{date_range_suffix}_{timestamp}.xlsx"

        logger.debug(f"Excel отчет сгенерирован. Отправка файла: {filename}")

        # Отправляем файл пользователю
        return send_file(
            BytesIO(excel_data_bytes),
            mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            as_attachment=True,
            download_name=filename
        )

    except Exception as e:
        logger.error(f"Ошибка при генерации Excel отчета для пользователя {user_id} ({start_date_str}-{end_date_str}): {str(e)}", exc_info=True)
        return jsonify({'error': f'Не удалось сгенерировать отчет: {str(e)}'}), 500

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
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    display_name_id = request.args.get('display_name_id', type=int) # Получаем ID русского названия
    search = request.args.get('search', '').lower()
    year = request.args.get('year', type=str)
    author_search = request.args.get('author', '').lower()


    query = Publication.query.filter_by(status='published')

    if display_name_id:
        display_name_exists = db.session.query(PublicationTypeDisplayName.id)\
        .filter_by(id=display_name_id).scalar() is not None
        if display_name_exists:
         logger.debug(f"Фильтр по русскому названию: display_name_id={display_name_id}")
         # Фильтруем публикации напрямую по display_name_id
         query = query.filter(Publication.display_name_id == display_name_id)
    else:
         logger.warning(f"Русское название с ID {display_name_id} не найдено. Игнорируем фильтр.")
         # Можно вернуть пустой список, если ID неверный
         # return jsonify({'publications': [], 'total': 0, 'pages': 0, 'current_page': page}), 200

    search_filters = []
    if search:
        search_filters.append(Publication.title.ilike(f'%{search}%'))
        search_filters.append(db.cast(Publication.year, db.String).ilike(f'%{search}%'))
        # Добавим поиск по новым текстовым полям
        search_filters.append(Publication.journal_conference_name.ilike(f'%{search}%'))
        search_filters.append(Publication.doi.ilike(f'%{search}%'))
        search_filters.append(Publication.issn.ilike(f'%{search}%'))
        search_filters.append(Publication.isbn.ilike(f'%{search}%'))
        search_filters.append(Publication.quartile.ilike(f'%{search}%'))
        # search_filters.append(Publication.number_volume_pages.ilike(f'%{search}%')) 
        search_filters.append(Publication.volume.ilike(f'%{search}%'))              
        search_filters.append(Publication.number.ilike(f'%{search}%'))              
        search_filters.append(Publication.pages.ilike(f'%{search}%'))               
        search_filters.append(Publication.department.ilike(f'%{search}%'))
        search_filters.append(Publication.publisher.ilike(f'%{search}%'))
        search_filters.append(Publication.publisher_location.ilike(f'%{search}%'))
        search_filters.append(Publication.classification_code.ilike(f'%{search}%'))
        search_filters.append(Publication.notes.ilike(f'%{search}%'))

    if search or author_search:
        combined_author_search = f"%{search}%" if search else f"%{author_search}%"
        author_subquery = db.session.query(PublicationAuthor.publication_id)\
            .filter(PublicationAuthor.name.ilike(combined_author_search))\
            .subquery()
        author_filter = Publication.id.in_(db.select(author_subquery.c.publication_id))
        if search:
            search_filters.append(author_filter)
            query = query.filter(db.or_(*search_filters))
        else:
             query = query.filter(author_filter)
    elif search_filters:
        query = query.filter(db.or_(*search_filters))


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

    response = [pub.to_dict() for pub in publications]

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
    pub_type = request.args.get('type', 'all') # Старый фильтр по имени типа
    display_name_id = request.args.get('display_name_id', type=int) # Новый фильтр по ID русского названия
    status = request.args.get('status', 'all')
    author_search = request.args.get('author', '').lower() # Отдельный поиск по автору


    query = Publication.query.filter_by(user_id=current_user.id)

    # Приоритет новому фильтру по display_name_id
    if display_name_id:
        query = query.filter(Publication.display_name_id == display_name_id)
    elif pub_type != 'all': # Если новый не задан, используем старый
        type_ = PublicationType.query.filter_by(name=pub_type).first()
        if type_:
            query = query.filter(Publication.type_id == type_.id)
        else:
            return jsonify({'publications': [], 'total': 0, 'pages': 0, 'current_page': page}), 200

    if status != 'all':
        query = query.filter(Publication.status == status)


    # --- Обновленный блок поиска ---
    search_filters = []
    if search:
        search_filters.append(Publication.title.ilike(f'%{search}%'))
        search_filters.append(db.cast(Publication.year, db.String).ilike(f'%{search}%'))
        # Добавляем поиск по новым текстовым полям
        search_filters.append(Publication.journal_conference_name.ilike(f'%{search}%'))
        search_filters.append(Publication.doi.ilike(f'%{search}%'))
        search_filters.append(Publication.issn.ilike(f'%{search}%'))
        search_filters.append(Publication.isbn.ilike(f'%{search}%'))
        search_filters.append(Publication.quartile.ilike(f'%{search}%'))
        search_filters.append(Publication.department.ilike(f'%{search}%'))
        search_filters.append(Publication.publisher.ilike(f'%{search}%'))
        search_filters.append(Publication.publisher_location.ilike(f'%{search}%'))
        search_filters.append(Publication.classification_code.ilike(f'%{search}%'))
        search_filters.append(Publication.notes.ilike(f'%{search}%'))

    if search or author_search:
        combined_author_search = f"%{search}%" if search else f"%{author_search}%"
        # Ищем публикации, где ХОТЯ БЫ ОДИН автор соответствует
        author_subquery = PublicationAuthor.query\
            .filter(PublicationAuthor.publication_id == Publication.id)\
            .filter(PublicationAuthor.name.ilike(combined_author_search))\
            .exists()
        author_filter = author_subquery
        if search: # Если основной поиск тоже есть
            search_filters.append(author_filter) # Добавляем условие по автору к остальным
            query = query.filter(db.or_(*search_filters)) # Ищем по ЛЮБОМУ из условий
        else: # Если ищем ТОЛЬКО по автору
            query = query.filter(author_filter) # Ищем только те, где есть такой автор
    elif search_filters: # Если был только основной поиск (без авторов)
        query = query.filter(db.or_(*search_filters))


    # --- Сортировка ---
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

    # --- Проверки прав и статуса ---
    if publication.user_id != current_user.id:
        logger.warning(f"Пользователь {current_user.id} (роль: {current_user.role}) пытался {request.method} публикацию {pub_id} другого пользователя.")
        return jsonify({'error': 'У вас нет прав на управление этой публикацией'}), 403

    # Нельзя редактировать/удалять, если на проверке
    if publication.status == 'needs_review':
        logger.warning(f"Пользователь {current_user.id} пытался {request.method} публикацию {pub_id} в статусе 'needs_review'.")
        return jsonify({'error': 'Нельзя управлять публикацией (редактировать или удалить), пока она на проверке.'}), 403
    # Доп: запрет изменения опубликованных? (Раскомментировать, если нужно)
    # if publication.status == 'published' and current_user.role != 'admin':
    #      logger.warning(f"Пользователь {current_user.id} пытался {request.method} опубликованную публикацию {pub_id}.")
    #      return jsonify({'error': 'Нельзя управлять опубликованной публикацией.'}), 403


    if request.method == 'PUT':
        data = None
        authors_data_received = None
        form_data = None # Для обработки данных из multipart

        # Определяем тип контента и парсим данные
        if request.content_type.startswith('application/json'):
            data = request.get_json()
            authors_data_received = data.get('authors')
            if authors_data_received is not None and not isinstance(authors_data_received, list):
                 return jsonify({'error': 'Поле authors должно быть массивом'}), 400
        elif request.content_type.startswith('multipart/form-data'):
            form_data = request.form.to_dict() # Получаем все поля формы как словарь
            data = form_data # Используем form_data для дальнейшей обработки
            authors_json = data.get('authors_json')
            try:
                authors_data_received = json.loads(authors_json) if authors_json else None
                if authors_data_received is not None and not isinstance(authors_data_received, list):
                    raise ValueError("Authors data must be a list.")
            except (json.JSONDecodeError, ValueError) as e:
                logger.error(f"Invalid authors_json format during update: {authors_json}. Error: {e}")
                return jsonify({'error': f'Некорректный формат JSON для authors_json: {e}'}), 400
        else:
            return jsonify({"error": "Неподдерживаемый формат данных."}), 415

        # --- Валидация авторов (если переданы) ---
        if authors_data_received is not None:
             # Проверяем, что список не пустой, если он передан
             if not authors_data_received:
                 return jsonify({'error': 'Список авторов не может быть пустым, если он передан.'}), 400
             # Валидируем каждый элемент списка
             try:
                 for author_item in authors_data_received:
                     if not isinstance(author_item, dict) or 'name' not in author_item or 'is_employee' not in author_item:
                         raise ValueError("Каждый автор должен быть объектом с полями 'name' и 'is_employee'.")
                     if not isinstance(author_item['name'], str) or not author_item['name'].strip():
                         raise ValueError("Имя автора не может быть пустым.")
                     if not isinstance(author_item['is_employee'], bool):
                         raise ValueError("'is_employee' автора должно быть булевым значением.")
             except ValueError as e:
                 logger.error(f"Неверный формат данных авторов при обновлении: {authors_data_received}. Ошибка: {e}")
                 return jsonify({'error': f'Некорректный формат данных авторов: {e}'}), 400


        # --- Обработка файла (если передан через multipart) ---
        if request.content_type.startswith('multipart/form-data') and 'file' in request.files:
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
                # Сохранение нового файла
                filename = secure_filename(file.filename)
                upload_folder = current_app.config['UPLOAD_FOLDER']
                os.makedirs(upload_folder, exist_ok=True) # Создаем, если не существует

                file_path = os.path.join(upload_folder, filename)
                # Предотвращение перезаписи файла
                counter = 1
                base, extension = os.path.splitext(filename)
                while os.path.exists(file_path):
                    filename = f"{base}_{counter}{extension}"
                    file_path = os.path.join(upload_folder, filename)
                    counter += 1
                try:
                    file.save(file_path)
                    publication.file_url = f"/uploads/{filename}" # Обновляем путь к файлу
                    logger.debug(f"Новый файл '{filename}' успешно прикреплен к публикации {pub_id}.")
                except Exception as save_err:
                    logger.error(f"Ошибка сохранения файла {filename}: {save_err}")
                    return jsonify({'error': 'Ошибка при сохранении файла.'}), 500
            elif file: # Если файл есть, но некорректный
                return jsonify({'error': 'Недопустимый тип файла при обновлении.'}), 400

        # --- Обновление полей публикации (основные и новые) ---
        try:
            # Основные поля
            if 'title' in data and data.get('title') is not None: publication.title = data['title'].strip()
            if not publication.title: return jsonify({'error': 'Название не может быть пустым.'}), 400

            if 'year' in data and data.get('year') is not None:
                year_int = int(data['year'])
                if year_int < 1900 or year_int > datetime.now().year + 5: raise ValueError("Недопустимый год")
                publication.year = year_int

            if 'type_id' in data and data.get('type_id') is not None:
                type_id = int(data['type_id']) if data['type_id'] else None
                if type_id is not None and not PublicationType.query.get(type_id): raise ValueError("Недопустимый type_id")
                publication.type_id = type_id
            else: # Нужен для проверки display_name_id
                type_id = publication.type_id

            if 'display_name_id' in data and data.get('display_name_id') is not None:
                display_name_id = int(data['display_name_id']) if data['display_name_id'] else None
                if display_name_id is not None:
                      dn = PublicationTypeDisplayName.query.get(display_name_id)
                      if not dn or (type_id is not None and dn.publication_type_id != type_id): raise ValueError("Недопустимое русское название")
                publication.display_name_id = display_name_id
						
            if 'is_vak' in data:
                publication.is_vak = bool(data.get('is_vak')) if isinstance(data.get('is_vak'), bool) else str(data.get('is_vak', '')).lower() == 'true'
            if 'is_wos' in data:
                publication.is_wos = bool(data.get('is_wos')) if isinstance(data.get('is_wos'), bool) else str(data.get('is_wos', '')).lower() == 'true'
            if 'is_scopus' in data:
                publication.is_scopus = bool(data.get('is_scopus')) if isinstance(data.get('is_scopus'), bool) else str(data.get('is_scopus', '')).lower() == 'true'

            if 'journal_conference_name' in data: publication.journal_conference_name = data.get('journal_conference_name')
            # ... Обновите остальные поля по аналогии (doi, issn, isbn, quartile, volume, number, pages, etc.)
            # Используйте проверку 'in data' и data.get('field_name') для всех новых полей.
            # Это позволит клиенту отправлять частичные обновления, если не все поля были показаны/изменены.
            if 'doi' in data: publication.doi = data.get('doi')
            if 'issn' in data: publication.issn = data.get('issn')
            if 'isbn' in data: publication.isbn = data.get('isbn')
            if 'quartile' in data: publication.quartile = data.get('quartile')
            if 'volume' in data: publication.volume = data.get('volume')
            if 'number' in data: publication.number = data.get('number')
            if 'pages' in data: publication.pages = data.get('pages')
            if 'department' in data: publication.department = data.get('department')
            if 'publisher' in data: publication.publisher = data.get('publisher')
            if 'publisher_location' in data: publication.publisher_location = data.get('publisher_location')

            # Обработка числовых полей - также через проверку 'in data'
            if 'printed_sheets_volume' in data:
                psv = data.get('printed_sheets_volume')
                publication.printed_sheets_volume = float(psv) if psv is not None and psv != '' else None
            if 'circulation' in data:
                circ = data.get('circulation')
                publication.circulation = int(circ) if circ is not None and circ != '' else None

            if 'classification_code' in data: publication.classification_code = data.get('classification_code')
            if 'notes' in data: publication.notes = data.get('notes')


            # Статус не меняем здесь! Если вернули на доработку, сбрасываем флаги
            if publication.status == 'returned_for_revision':
                publication.returned_for_revision = False
                publication.return_comment = None
                publication.returned_at = None

            # --- Обновление авторов ---
            if authors_data_received is not None:
                # Удаляем старых авторов
                PublicationAuthor.query.filter_by(publication_id=pub_id).delete()
                # Создаем новых
                for author_data in authors_data_received:
                    new_author = PublicationAuthor(
                        name=author_data['name'].strip(),
                        is_employee=author_data['is_employee'],
                        publication_id=pub_id # Прямая установка ID
                    )
                    db.session.add(new_author)
                logger.debug(f"Авторы для публикации {pub_id} были обновлены.")

            publication.updated_at = datetime.utcnow() # Обновляем дату изменения

        except (ValueError, TypeError) as val_err:
            logger.error(f"Ошибка валидации при обновлении публикации {pub_id}: {val_err}", exc_info=True)
            return jsonify({'error': f'Ошибка в значении поля: {val_err}'}), 400

        # --- Фиксация изменений ---
        try:
            db.session.commit()
            logger.debug(f"Публикация {pub_id} успешно обновлена пользователем {current_user.id}.")
            # db.session.refresh(publication) # Не всегда нужно, to_dict() и так получит свежие данные
            return jsonify({
                'message': 'Публикация успешно обновлена',
                'publication': publication.to_dict() # Возвращаем обновленные данные
            }), 200
        except Exception as e:
            db.session.rollback()
            logger.error(f"Ошибка при сохранении обновления публикации {pub_id}: {str(e)}", exc_info=True)
            return jsonify({"error": "Ошибка при обновлении публикации. Попробуйте позже."}), 500


    elif request.method == 'DELETE':
        # --- Логика DELETE (без изменений, но проверим удаление файла) ---
        # Можно добавить проверку, если нужно запретить удаление опубликованных
        if publication.status == 'published' and current_user.role not in ['admin', 'manager']:
             logger.warning(f"Пользователь {current_user.id} пытался удалить опубликованную публикацию {pub_id}.")
             return jsonify({'error': 'Нельзя удалить опубликованную публикацию.'}), 403

        try:
            # Удаление файла, если есть
            file_path_to_delete = None
            if publication.file_url:
                 try:
                     file_path_segment = publication.file_url.split('/uploads/')[-1]
                     file_path_to_delete = os.path.join(current_app.config['UPLOAD_FOLDER'], file_path_segment)
                 except Exception as path_err:
                     logger.error(f"Ошибка определения пути к файлу '{publication.file_url}' при удалении публикации {pub_id}: {path_err}")

            # Удаление из БД (SQLAlchemy удалит авторов через cascade)
            db.session.delete(publication)
            db.session.commit() # Сначала коммит БД

            # Удаление файла после успешного коммита БД
            if file_path_to_delete and os.path.exists(file_path_to_delete):
                 try:
                     os.remove(file_path_to_delete)
                     logger.debug(f"Файл '{file_path_to_delete}' успешно удален после удаления публикации {pub_id} из БД.")
                 except Exception as file_del_e:
                      # Логируем ошибку, но удаление из БД уже прошло успешно
                      logger.error(f"Ошибка при удалении файла '{file_path_to_delete}' ПОСЛЕ удаления публикации {pub_id} из БД: {str(file_del_e)}")

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

    # Получаем основные поля
    title = request.form.get('title')
    authors_json = request.form.get('authors_json')
    year = request.form.get('year')
    type_id = request.form.get('type_id')
    display_name_id = request.form.get('display_name_id')

    # --- Получаем НОВЫЕ поля ---
    journal_conference_name = request.form.get('journal_conference_name')
    doi = request.form.get('doi')
    issn = request.form.get('issn')
    isbn = request.form.get('isbn')
    quartile = request.form.get('quartile')
    # number_volume_pages = request.form.get('number_volume_pages') # <- УДАЛИТЬ
    volume = request.form.get('volume') # <- ДОБАВИТЬ
    number = request.form.get('number') # <- ДОБАВИТЬ
    pages = request.form.get('pages')   # <- ДОБАВИТЬ
    department = request.form.get('department')
    publisher = request.form.get('publisher')
    publisher_location = request.form.get('publisher_location')
    printed_sheets_volume_str = request.form.get('printed_sheets_volume')
    circulation_str = request.form.get('circulation')
    classification_code = request.form.get('classification_code')
    notes = request.form.get('notes')
    # --- Конец получения новых полей ---
    is_vak_str = request.form.get('is_vak', 'false') # Дефолтное значение - строка 'false'
    is_wos_str = request.form.get('is_wos', 'false')
    is_scopus_str = request.form.get('is_scopus', 'false')

    is_vak = is_vak_str.lower() == 'true'
    is_wos = is_wos_str.lower() == 'true'
    is_scopus = is_scopus_str.lower() == 'true'
    # --- Конец получения новых полей ---

    # --- Валидация обязательных полей ---
    if not title or not year or not type_id or not authors_json:
        return jsonify({'error': 'Название, год, тип и хотя бы один автор обязательны'}), 400

    # --- Валидация JSON авторов (без изменений) ---
    try:
        authors_data = json.loads(authors_json)
        if not isinstance(authors_data, list) or not authors_data:
             raise ValueError("Authors data must be a non-empty list.")
        # ... (остальная валидация авторов как раньше) ...
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

    # --- Валидация типов и числовых полей ---
    try:
        year_int = int(year)
        if year_int < 1900 or year_int > datetime.now().year + 5: raise ValueError("Invalid year range")
        type_id_int = int(type_id) if type_id else None
        display_name_id_int = int(display_name_id) if display_name_id else None
        # Новые числовые поля
        printed_sheets_volume = float(printed_sheets_volume_str) if printed_sheets_volume_str is not None and printed_sheets_volume_str != '' else None
        circulation = int(circulation_str) if circulation_str is not None and circulation_str != '' else None
    except (ValueError, TypeError) as e:
        logger.error(f"Ошибка конвертации числовых полей: {e}", exc_info=True)
        return jsonify({'error': 'Год, type_id, display_name_id, тираж и объем п.л. (если переданы) должны быть числами'}), 400

    # Проверка существования типа и русского названия (без изменений)
    type_ = PublicationType.query.get(type_id_int) if type_id_int else None
    if not type_:
        return jsonify({'error': 'Недопустимый тип публикации'}), 400
    if display_name_id_int:
        display_name = PublicationTypeDisplayName.query.get(display_name_id_int)
        if not display_name or display_name.publication_type_id != type_id_int:
            return jsonify({'error': 'Недопустимое русское название для выбранного типа'}), 400
    else:
         display_name_id_int = None # Убедимся, что ID это None, если не передано


    # --- Загрузка файла (без изменений, но проверим путь сохранения) ---
    filename = secure_filename(file.filename)
    upload_folder = current_app.config['UPLOAD_FOLDER']
    os.makedirs(upload_folder, exist_ok=True) # Убедимся, что папка есть
    file_path = os.path.join(upload_folder, filename)
    # Предотвращение перезаписи файла
    counter = 1
    base, extension = os.path.splitext(filename)
    while os.path.exists(file_path):
        filename = f"{base}_{counter}{extension}"
        file_path = os.path.join(upload_folder, filename)
        counter += 1
    try:
        file.save(file_path)
    except Exception as save_err:
        logger.error(f"Ошибка сохранения файла {filename}: {save_err}")
        # ВАЖНО: Не оставлять мусор, если файл не удалось сохранить
        return jsonify({'error': 'Ошибка при сохранении файла.'}), 500


    # --- Создание объекта Publication со всеми полями ---
    publication = Publication(
        title=title.strip(),
        year=year_int,
        type_id=type_id_int,
        display_name_id=display_name_id_int,
        status='draft',
        file_url=f"/uploads/{filename}",
        user_id=current_user.id,
        returned_for_revision=False,
        # --- Передаем новые поля ---
        is_vak=is_vak,         # <-- НОВОЕ
        is_wos=is_wos,         # <-- НОВОЕ
        is_scopus=is_scopus,		 # <-- НОВОЕ
        journal_conference_name=journal_conference_name,
        doi=doi,
        issn=issn,
        isbn=isbn,
        quartile=quartile,
        # number_volume_pages=number_volume_pages, # <- УДАЛИТЬ
        volume=volume, # <- ДОБАВИТЬ
        number=number, # <- ДОБАВИТЬ
        pages=pages,   # <- ДОБАВИТЬ
        department=department,
        publisher=publisher,
        publisher_location=publisher_location,
        printed_sheets_volume=printed_sheets_volume,
        circulation=circulation,
        classification_code=classification_code,
        notes=notes
    )

    # Создание авторов (без изменений)
    for author_data in authors_data:
        pub_author = PublicationAuthor(
            name=author_data['name'].strip(),
            is_employee=author_data['is_employee'],
            publication=publication # Устанавливаем связь
        )
        # SQLAlchemy добавит в сессию через relationship/cascade

    db.session.add(publication) # Добавляем саму публикацию

    # --- Сохранение в БД (с удалением файла при ошибке) ---
    try:
        db.session.commit()
        logger.debug(f"Publication {publication.id} created with {len(authors_data)} authors and new fields.")
    except Exception as e:
        db.session.rollback()
        logger.error(f"Error creating publication with authors: {e}", exc_info=True)
        # Удаляем загруженный файл, так как запись в БД не удалась
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
    }), 201

BIBTEX_SYNONYM_MAP = {
    'inproceedings': 'conference', # Самый частый случай
    'proceedings': 'conference',   # Сборник трудов тоже можно отнести к типу 'conference' или 'book'? Пока 'conference'
    'inbook': 'book',              # Глава в книге
    'incollection': 'book',        # Тоже часть книги/сборника
    'phdthesis': 'phdthesis',        # Явное совпадение
    'mastersthesis': 'mastersthesis',# Явное совпадение
    'techreport': 'techreport',      # Добавлен явный тип, если есть
    'manual': 'misc',              # Руководство можно к misc
    'unpublished': 'misc',         # Неопубликованное к misc
    'misc': 'misc',                # misc к misc
    'article': 'article',          # Явное совпадение
    'book': 'book',                # Явное совпадение
    'journal': 'article',          # Некоторые могут использовать @journal вместо @article
    'booklet': 'book'              # Буклеты тоже к книгам/misc? Пока book
}

# --- Обновленный эндпоинт upload_bibtex ---

@bp.route('/publications/upload-bibtex', methods=['POST'])
@login_required
def upload_bibtex():
    logger.debug("Получен POST запрос для /publications/upload-bibtex")
    # --- Проверка файла ---
    if 'file' not in request.files:
        logger.warning("BibTeX файл не предоставлен в запросе.")
        return jsonify({'error': 'BibTeX файл не предоставлен'}), 400
    file = request.files['file']
    if not file or not file.filename.lower().endswith('.bib'):
        filename = file.filename if file else 'Нет файла'
        logger.warning(f"Получен недопустимый файл: {filename}. Ожидается .bib")
        return jsonify({'error': 'Недопустимый файл. Ожидается .bib'}), 400

    try:
        # --- Чтение и парсинг файла ---
        content = file.read().decode('utf-8')
        logger.debug(f"Файл {file.filename} успешно прочитан и декодирован.")

        # Устанавливаем common_strings=False, чтобы не заменялись месяцы и др.
        bib_parser = bibtexparser.bparser.BibTexParser(common_strings=False)
        bib_database = bibtexparser.loads(content, parser=bib_parser)
        logger.debug(f"Парсинг BibTeX файла завершен. Найдено {len(bib_database.entries)} записей.")

        publications_added_count = 0
        skipped_entries = []
        error_entries = []

        # --- Предзагрузка типов и названий из БД ---
        try:
            all_types = PublicationType.query.options(
                db.selectinload(PublicationType.display_names) # Загружаем связанные display_names
            ).all()

            # Словарь типов { 'name': PublicationType_object }
            app_types_by_name = {pt.name.lower(): pt for pt in all_types}

            # Словарь отображаемых имен { type_id: [PublicationTypeDisplayName_object, ...] }
            # Сразу сортируем по ID (или другому полю, гарантирующему порядок)
            display_names_by_type_id = {}
            for pt in all_types:
                # Сортируем display_names по ID, чтобы гарантированно брать первое
                sorted_display_names = sorted(pt.display_names, key=lambda dn: dn.id)
                display_names_by_type_id[pt.id] = sorted_display_names

            logger.debug(f"Загружено {len(app_types_by_name)} типов PublicationType и связанные DisplayNames.")

        except Exception as e:
             logger.error(f"Ошибка предварительной загрузки типов и названий из БД: {str(e)}", exc_info=True)
             db.session.rollback()
             return jsonify({'error': 'Ошибка настройки базы данных типов публикаций.'}), 500


        for entry in bib_database.entries:
            entry_key = entry.get('ID', 'Без ключа')
            bibtex_type_raw = entry.get('ENTRYTYPE', '').lower() # Сразу в lower

            # Очистка значений в записи от лишних скобок, если они не заменяются автоматически
            for key, value in entry.items():
                if isinstance(value, str):
                    # Убираем скобки {}, кавычки "" и пробелы по краям
                    entry[key] = value.strip('{} "')

            if not bibtex_type_raw:
                 logger.warning(f"Запись с ключом '{entry_key}': тип BibTeX пустой. Пропускаем.")
                 skipped_entries.append(f"{entry_key} (пустой тип)")
                 continue

            # --- Шаг 1 и 2: Поиск PublicationType (сначала прямой, потом через синонимы) ---
            type_obj = app_types_by_name.get(bibtex_type_raw) # Прямой поиск

            if not type_obj:
                 # Прямого совпадения нет, ищем в синонимах
                 target_app_type_name = BIBTEX_SYNONYM_MAP.get(bibtex_type_raw)
                 if target_app_type_name:
                     type_obj = app_types_by_name.get(target_app_type_name)
                     logger.debug(f"Запись '{entry_key}': BibTeX тип '{bibtex_type_raw}' смаплен на '{target_app_type_name}' через синонимы.")
                 else:
                    # Нет ни прямого совпадения, ни синонима
                    logger.warning(f"Запись '{entry_key}': Тип BibTeX '{bibtex_type_raw}' не найден ни напрямую, ни в синонимах. Пропускаем.")
                    skipped_entries.append(f"{entry_key} (неизв./немапп. тип: {bibtex_type_raw})")
                    continue
            else:
                logger.debug(f"Запись '{entry_key}': BibTeX тип '{bibtex_type_raw}' найден напрямую.")

            if not type_obj: # Если и после поиска по синонимам не нашли (маловероятно, но все же)
                logger.warning(f"Запись '{entry_key}': Соответствующий тип приложения не найден в БД для BibTeX типа '{bibtex_type_raw}'. Пропускаем.")
                skipped_entries.append(f"{entry_key} (тип не в БД)")
                continue

            # --- Шаг 3: Выбор первого PublicationTypeDisplayName ---
            associated_display_names = display_names_by_type_id.get(type_obj.id, [])
            if not associated_display_names:
                logger.error(f"Запись '{entry_key}': Для типа '{type_obj.name}' (ID: {type_obj.id}) не найдено НИ ОДНОГО отображаемого имени в БД. Проверьте целостность данных! Пропускаем.")
                skipped_entries.append(f"{entry_key} (нет рус. имен для типа {type_obj.name})")
                continue

            # Берем первое из отсортированного списка
            first_display_name_obj = associated_display_names[0]
            logger.debug(f"Запись '{entry_key}': Для типа '{type_obj.name}' выбрано первое отображаемое имя: '{first_display_name_obj.display_name}' (ID: {first_display_name_obj.id}).")


            # --- Блок создания записи (с извлечением НОВЫХ полей) ---
            try:
                 # Основные поля
                 title = entry.get('title', 'Без названия').strip()
                 if not title: title = 'Без названия'
                 year_str = entry.get('year')
                 year = None
                 if year_str:
                     try: # Более устойчивый парсинг года
                         year_str_cleaned = "".join(filter(str.isdigit, year_str))
                         if len(year_str_cleaned) >= 4: year = int(year_str_cleaned[:4])
                     except (ValueError, TypeError): year = None
                 if year is None or year < 1900 or year > datetime.now().year + 5:
                     logger.warning(f"Запись '{entry_key}': Некорректный или отсутствующий год ('{year_str}'). Используется текущий год.")
                     year = datetime.now().year

                 # --- Авторы (используем bibtexparser для лучшего парсинга) ---
                 author_string = entry.get('author', entry.get('editor', '')).strip()
                 author_names = []
                 if author_string:
                    try:
                         # Преобразование LaTeX сущностей в Unicode
                         author_string = homogenize_latex_encoding(author_string)
                         # Используем getnames для разделения
                         names = bibtexparser.customization.getnames([a.strip() for a in author_string.split(' and ')])
                         # Форматируем как "Фамилия И." или как есть, если парсинг не дал части
                         formatted_names = []
                         for name_parts in names: # getnames возвращает список списков строк, если используется splitname
                              # getnames возвращает просто список строк
                             if isinstance(name_parts, str):
                                 formatted_names.append(name_parts)
                             else: # Попытка использовать splitname для формата Ф И О - менее надежно
                                try:
                                    p = splitname(name_parts)
                                    last = p.get('last', [''])[0]
                                    first = p.get('first', [''])[0]
                                    von = p.get('von', [''])[0] # частицы типа von, van
                                    jr = p.get('jr', [''])[0]   # суффиксы типа Jr., Sr.
                                    # Склеиваем
                                    name_str = f"{von} {last}".strip()
                                    if first: name_str += f" {first[0]}." if first else ''
                                    # middle = p.get('middle', [''])[0] # среднее имя/отчество пока опускаем
                                    # if middle: name_str += f" {middle[0]}."
                                    if jr: name_str += f", {jr}"
                                    formatted_names.append(name_str.strip())
                                except: # Если splitname не сработал, берем как есть
                                    formatted_names.append(" ".join(name_parts).strip())

                         author_names = [name for name in formatted_names if name]

                    except Exception as author_parse_err:
                         logger.warning(f"Запись '{entry_key}': Ошибка парсинга авторов '{author_string}' ({author_parse_err}), используем простое разделение.")
                         author_names = [name.strip() for name in author_string.split(' and ') if name.strip()]

                 if not author_names:
                     author_names = ['Неизвестный автор']

                 # --- Извлечение полей из BibTeX ---
                 # Journal/Booktitle/Series
                 journal_conf = entry.get('journal', entry.get('booktitle', entry.get('series', ''))).strip()
                 doi = entry.get('doi', '').strip()
                 issn = entry.get('issn', '').strip()
                 isbn = entry.get('isbn', '').strip()

                 volume = entry.get('volume', '').strip()
                 number = entry.get('number', entry.get('issue', '')).strip() # Добавляем 'issue' как синоним
                 pages = entry.get('pages', '').replace('--', '-').strip()

                 # Publisher/Organization/School/Address
                 publisher = entry.get('publisher', entry.get('organization', entry.get('school', ''))).strip()
                 address = entry.get('address', entry.get('location', '')).strip() # Добавляем 'location'
                 notes = entry.get('note', entry.get('annote', '')).strip()
                 # Поля quartile, department, printed_sheets_volume, circulation, classification_code обычно не импортируются

                 # Создание Publication
                 publication = Publication(
                     title=title, year=year,
                     type_id=type_obj.id, # Используем ID найденного типа
                     display_name_id=first_display_name_obj.id, # Используем ID первого отображаемого имени
                     status='draft', user_id=current_user.id, returned_for_revision=False,
                     # --- Передача полей ---
                     journal_conference_name=journal_conf if journal_conf else None,
                     doi=doi if doi else None,
                     issn=issn if issn else None,
                     isbn=isbn if isbn else None,
                     volume=volume if volume else None,
                     number=number if number else None,
                     pages=pages if pages else None,
                     publisher=publisher if publisher else None,
                     publisher_location=address if address else None,
                     notes=notes if notes else None,
                     # Оставляем остальные поля пустыми (quartile, department и т.д.)
                     quartile=None,
                     department=None,
                     printed_sheets_volume=None,
                     circulation=None,
                     classification_code=None
                 )
                 db.session.add(publication)

                 # Создание авторов
                 for author_name in author_names:
                     # Не создаем пустых авторов
                     if author_name:
                         db.session.add(PublicationAuthor(name=author_name, is_employee=False, publication=publication))

                 publications_added_count += 1
                 logger.debug(f"Запись '{entry_key}' (BibTeX: {bibtex_type_raw}) успешно подготовлена для добавления.")

            except Exception as field_e:
                 db.session.rollback() # Откатываем добавление публикации и ее авторов при ошибке
                 logger.error(f"Ошибка обработки полей записи '{entry_key}': {str(field_e)}", exc_info=True)
                 error_entries.append(f"{entry_key} (ошибка полей: {field_e})")
                 continue # Переходим к следующей записи

        # --- Фиксация изменений ---
        try:
            if publications_added_count > 0:
                db.session.commit()
                logger.debug(f"Импорт завершен. Успешно зафиксированы {publications_added_count} публикаций.")
            else:
                logger.debug("Нет публикаций для фиксации.")
                if error_entries or skipped_entries:
                    db.session.rollback() # Важно откатить, если были ошибки/пропуски и ничего не добавилось

        except Exception as commit_e:
             db.session.rollback()
             logger.error(f"Критическая ошибка при фиксации BibTeX импорта: {str(commit_e)}", exc_info=True)
             # Сообщение должно отражать, что коммит не удался
             response_message = f'Импорт прерван из-за ошибки базы данных при сохранении. Добавлено 0 публикаций.'
             if skipped_entries: response_message += f' Пропущено (до ошибки): {len(skipped_entries)} записей.'
             if error_entries: response_message += f' Ошибка обработки (до ошибки): {len(error_entries)} записей.'
             return jsonify({
                'message': response_message, 'added_count': 0,
                'skipped_count': len(skipped_entries), 'error_count': len(error_entries),
                'db_error': True
             }), 500

        # --- Формирование успешного ответа ---
        response_message = f'Импорт завершен. Успешно добавлено {publications_added_count} публикаций.'
        details = []
        if skipped_entries:
            response_message += f' Пропущено: {len(skipped_entries)}.'
            details.append(f"Пропущенные записи: {'; '.join(skipped_entries)}")
            logger.warning(f"Пропущенные записи при импорте BibTeX: {'; '.join(skipped_entries)}")
        if error_entries:
             response_message += f' Ошибок обработки полей: {len(error_entries)}.'
             details.append(f"Ошибки обработки полей: {'; '.join(error_entries)}")
             logger.error(f"Ошибки при обработке полей записей BibTeX: {'; '.join(error_entries)}")

        status_code = 200
        if skipped_entries or error_entries:
            status_code = 207 # Multi-Status, если были и успехи, и проблемы

        response_data = {
            'message': response_message,
            'added_count': publications_added_count,
            'skipped_count': len(skipped_entries),
            'error_count': len(error_entries)
        }
        if details:
            response_data['details'] = " ".join(details) # Добавляем детали в ответ

        return jsonify(response_data), status_code

    except UnicodeDecodeError:
         # Откат не нужен
         logger.error(f"Ошибка декодирования BibTeX файла. Ожидается UTF-8.", exc_info=True)
         return jsonify({'error': 'Ошибка чтения файла. Проверьте кодировку (ожидается UTF-8).'}), 400
    except bibtexparser.bparser.BibTexParserError as parse_err:
         # Откат не нужен
         logger.error(f"Ошибка парсинга BibTeX файла: {parse_err}", exc_info=True)
         return jsonify({'error': f'Ошибка парсинга BibTeX файла: {str(parse_err)}. Проверьте синтаксис файла.'}), 400
    except Exception as e:
        # Откат на всякий случай, если ошибка была после начала работы с сессией
        if db.session.is_active:
            db.session.rollback()
        logger.error(f"Неожиданная ошибка при обработке BibTeX файла: {str(e)}", exc_info=True)
        return jsonify({'error': f'Внутренняя ошибка сервера при обработке BibTeX файла.'}), 500


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
    user_id = current_user.id
    logger.debug(f"Получен GET запрос для /publications/export-bibtex от пользователя {user_id}")

    # --- НОВЫЙ БЛОК: ПОЛУЧЕНИЕ И ПАРСИНГ ДАТ ---
    start_date_str = request.args.get('start_date')
    end_date_str = request.args.get('end_date')

    start_date = None
    end_date = None

    if start_date_str:
        try:
            start_date = datetime.strptime(start_date_str, '%Y-%m-%d')
            logger.debug(f"BibTeX экспорт: Парсинг start_date: {start_date_str} -> {start_date}")
        except ValueError:
            logger.warning(f"BibTeX экспорт: Неверный формат start_date: {start_date_str}")
            # Возвращаем ошибку, а не пустой файл
            return make_response("Ошибка: Неверный формат начальной даты. Используйте YYYY-MM-DD.", 400)

    if end_date_str:
        try:
            end_date = datetime.strptime(end_date_str, '%Y-%m-%d')
            logger.debug(f"BibTeX экспорт: Парсинг end_date: {end_date_str} -> {end_date}")
        except ValueError:
            logger.warning(f"BibTeX экспорт: Неверный формат end_date: {end_date_str}")
            return make_response("Ошибка: Неверный формат конечной даты. Используйте YYYY-MM-DD.", 400)

    if start_date and end_date and start_date > end_date:
        logger.warning("BibTeX экспорт: Начальная дата позже конечной.")
        return make_response("Ошибка: Начальная дата не может быть позже конечной даты.", 400)
    # --- КОНЕЦ НОВОГО БЛОКА ---

    try:
        # --- ОБНОВЛЕННЫЙ ЗАПРОС К БД ---
        query = Publication.query.filter_by(user_id=user_id)\
            .options(
                db.joinedload(Publication.authors),
                db.joinedload(Publication.type)
            )

        # Применяем фильтры по датам, если они заданы
        if start_date:
            query = query.filter(Publication.published_at != None, Publication.published_at >= start_date)
            logger.debug(f"BibTeX фильтр: >= {start_date}")

        if end_date:
            # Как и для Excel, фильтруем по началу следующего дня
            end_of_day_inclusive = end_date + timedelta(days=1)
            query = query.filter(Publication.published_at != None, Publication.published_at < end_of_day_inclusive)
            logger.debug(f"BibTeX фильтр: < {end_of_day_inclusive}")

        # Сортировка и выполнение запроса
        publications = query.order_by(Publication.year.desc(), Publication.title).all()
        # --- КОНЕЦ ОБНОВЛЕННОГО ЗАПРОСА К БД ---

        logger.debug(f"Найдено публикаций для BibTeX экспорта ({start_date_str}-{end_date_str}): {len(publications)}")

        if not publications:
             logger.info(f"Нет публикаций для BibTeX экспорта для пользователя {user_id} за указанный период.")
             bib_db_empty = BibDatabase()
             bibtex_str_empty = BibTexWriter().write(bib_db_empty)
             # --- ОБНОВЛЕНО ИМЯ ФАЙЛА ДЛЯ ПУСТОГО РЕЗУЛЬТАТА ---
             timestamp_empty = datetime.now().strftime("%Y%m%d_%H%M%S")
             date_range_suffix_empty = ""
             if start_date or end_date: date_range_suffix_empty += "_"
             if start_date: date_range_suffix_empty += f"from_{start_date.strftime('%Y%m%d')}"
             if end_date: date_range_suffix_empty += f"_to_{end_date.strftime('%Y%m%d')}"
             filename_empty = f"publications{date_range_suffix_empty}_empty_{timestamp_empty}.bib"
             response_empty = make_response(bibtex_str_empty)
             response_empty.headers['Content-Disposition'] = f'attachment; filename="{filename_empty}"' # Добавлены кавычки на всякий случай
             response_empty.headers['Content-Type'] = 'application/x-bibtex; charset=utf-8'
             return response_empty
             # --- КОНЕЦ ОБНОВЛЕНИЯ ---

        # --- Остальная логика BibTeX генерации без изменений ---
        bib_db = BibDatabase()
        entries_list = []
        for i, pub in enumerate(publications):
            entry = {}
            # Тип записи
            entry['ENTRYTYPE'] = pub.type.name.lower().lstrip('@') if pub.type and pub.type.name else 'misc'
            bibtex_type = entry['ENTRYTYPE']
            # ID
            entry['ID'] = f'user{user_id}_pub{pub.id}_{i}' # Добавлен индекс для большей уникальности
            # Основные поля
            if pub.title: entry['title'] = pub.title
            author_names = [author.name for author in pub.authors if author.name]
            if author_names: entry['author'] = ' and '.join(author_names)
            if pub.year: entry['year'] = str(pub.year)

            # Конкретные поля
            if pub.journal_conference_name:
                 if bibtex_type == 'article': entry['journal'] = pub.journal_conference_name
                 elif bibtex_type in ['inproceedings', 'conference', 'incollection', 'proceedings', 'book']: entry['booktitle'] = pub.journal_conference_name
                 else: entry.setdefault('note', []).append(f"Источник: {pub.journal_conference_name}")

            if pub.doi: entry['doi'] = pub.doi
            if pub.issn: entry['issn'] = pub.issn
            if pub.isbn: entry['isbn'] = pub.isbn
            if pub.volume: entry['volume'] = str(pub.volume)
            if pub.number: entry['number'] = str(pub.number)
            if pub.pages: entry['pages'] = str(pub.pages).replace('-', '--')

            if pub.publisher:
                 if bibtex_type in ['book', 'inbook', 'proceedings', 'booklet', 'manual']: entry['publisher'] = pub.publisher
                 elif bibtex_type in ['phdthesis', 'mastersthesis', 'techreport']: entry['institution'] = pub.publisher
                 else: entry.setdefault('note', []).append(f"Издатель/Организация: {pub.publisher}")

            if pub.publisher_location: entry['address'] = pub.publisher_location

            # Дополнительные поля в note
            note_list = entry.setdefault('note', [])
            if pub.quartile: note_list.append(f"Квартиль: {pub.quartile}")
            if pub.department: note_list.append(f"Кафедра: {pub.department}")
            if pub.printed_sheets_volume is not None: note_list.append(f"Объем (п.л.): {float(pub.printed_sheets_volume):g}")
            if pub.circulation is not None: note_list.append(f"Тираж: {int(pub.circulation)}")
            if pub.classification_code: note_list.append(f"Классификатор: {pub.classification_code}")
            if pub.notes: note_list.append(f"{pub.notes.strip()}")

            # Объединение note
            if note_list:
                entry['note'] = '; '.join(note_list)
            elif 'note' in entry:
                 del entry['note']

            entries_list.append(entry)
        # --- Конец логики BibTeX генерации ---

        bib_db.entries = entries_list

        writer = BibTexWriter()
        writer.indent = '  '
        writer.comma_first = False
        bibtex_str = writer.write(bib_db)

        # --- ОБНОВЛЕНО ИМЯ ФАЙЛА ---
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        date_range_suffix = ""
        if start_date or end_date: date_range_suffix += "_"
        if start_date: date_range_suffix += f"from_{start_date.strftime('%Y%m%d')}"
        if end_date: date_range_suffix += f"_to_{end_date.strftime('%Y%m%d')}"
        filename = f"publications{date_range_suffix}_{timestamp}.bib"
        # --- КОНЕЦ ОБНОВЛЕНИЯ ИМЕНИ ФАЙЛА ---

        response = make_response(bibtex_str)
        response.headers['Content-Disposition'] = f'attachment; filename="{filename}"' # Добавлены кавычки
        response.headers['Content-Type'] = 'application/x-bibtex; charset=utf-8'
        logger.debug(f"BibTeX файл ({filename}) успешно сгенерирован и будет отправлен")
        return response

    except Exception as e:
        logger.error(f"Критическая ошибка при экспорте BibTeX ({start_date_str}-{end_date_str}): {str(e)}", exc_info=True)
        return make_response(f"Ошибка сервера при генерации BibTeX файла: {str(e)}", 500)

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