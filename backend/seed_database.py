# seed_database.py
# Скрипт для заполнения БД тестовыми данными: пользователи, публикации, планы, комментарии, история.

import random
from datetime import datetime, timedelta
from faker import Faker # Используем Faker для генерации данных
from app import create_app, db
from app.models import (
    User, Publication, PublicationAuthor, PublicationType,
    PublicationTypeDisplayName, Plan, PlanEntry, Comment,
    PublicationActionHistory, PlanActionHistory
)

# --- Добавлен недостающий импорт ---
from sqlalchemy.orm import joinedload, selectinload
# ------------------------------------
from sqlalchemy.exc import IntegrityError

# --- КОНФИГУРАЦИЯ ---
NUM_USERS = 3
PUBS_PER_USER = 10
PLANS_PER_USER = 2 # Создадим по 2 плана на пользователя (например, 2023 и 2024)
MAX_AUTHORS_PER_PUB = 4 # Макс. число соавторов (включая основного)
# ---------------------

# Инициализация Faker для русских данных
fake = Faker('ru_RU')

# Создаём приложение и контекст
app = create_app()
app.app_context().push()

print("Запуск скрипта заполнения базы данных...")

# --- Вспомогательная функция для случайной даты ---
def get_random_past_datetime(start_date=None):
    if start_date:
        # Генерация даты между start_date и сейчас
        return fake.date_time_between(start_date=start_date, end_date='now', tzinfo=None)
    else:
        # Генерация даты за последний год
        return fake.date_time_between(start_date='-1y', end_date='now', tzinfo=None)

# --- Начало основной логики ---
try:
    # --- 1. Получение необходимых данных ---
    print("1. Загрузка существующих данных (менеджер, типы)...")

    # Находим менеджера
    manager_user = User.query.filter_by(username='manager').first()
    if not manager_user:
        print("ОШИБКА: Пользователь 'manager' не найден. Убедитесь, что он создан.")
        exit()
    print(f"  - Менеджер найден (ID: {manager_user.id})")

    # Загружаем все типы и их отображаемые имена один раз
    all_display_names_db = PublicationTypeDisplayName.query.options(
        joinedload(PublicationTypeDisplayName.publication_type) # Загружаем связанный тип
    ).all()

    if not all_display_names_db:
        print("ОШИБКА: В базе данных нет отображаемых имен (PublicationTypeDisplayName). Запустите сначала 'seed_publication_types.py'.")
        exit()

    # Создаем удобные структуры для быстрого доступа
    # Словарь: {display_name_id: {'name': internal_name, 'display_name': display_name_text, 'type_id': type_id}}
    display_name_details = {
        dn.id: {
            'name': dn.publication_type.name,
            'display_name': dn.display_name,
            'type_id': dn.publication_type_id
        }
        for dn in all_display_names_db if dn.publication_type # Доп. проверка связи
    }
    # Список всех валидных display_name_id для случайного выбора
    valid_display_name_ids = list(display_name_details.keys())

    if not valid_display_name_ids:
        print("ОШИБКА: Не удалось создать список ID отображаемых имен.")
        exit()
    print(f"  - Загружено {len(valid_display_name_ids)} вариантов отображаемых имен.")

    # --- 2. Создание пользователей ---
    print("\n2. Создание пользователей...")
    users = []
    for i in range(NUM_USERS):
        username = f'user_{i+1}'
        existing_user = User.query.filter_by(username=username).first()
        if existing_user:
            print(f"  - Пользователь '{username}' уже существует, пропуск.")
            users.append(existing_user)
            continue

        user = User(
            username=username,
            role='user',
            last_name=fake.last_name(),
            first_name=fake.first_name(),
            middle_name=fake.middle_name() if random.choice([True, False]) else None,
            created_at=get_random_past_datetime()
        )
        user.set_password('password') # Простой пароль для всех тестовых пользователей
        users.append(user)
        db.session.add(user)
        print(f"  + Пользователь '{username}' создан.")
    db.session.flush() # Получаем ID пользователей

    # --- 3. Создание публикаций для каждого пользователя ---
    print("\n3. Создание публикаций...")
    all_created_publications = [] # Список всех созданных публикаций для связки с планами

    for user_obj in users:
        print(f"  Создание публикаций для пользователя '{user_obj.username}' (ID: {user_obj.id})...")
        user_publications = [] # Публикации текущего пользователя для плана

        for j in range(PUBS_PER_USER):
            # Случайно выбираем display_name_id, получаем детали
            chosen_dn_id = random.choice(valid_display_name_ids)
            type_details = display_name_details[chosen_dn_id]
            display_name_text = type_details['display_name']
            type_id = type_details['type_id']

            # Генерируем год и дату публикации (дата >= год)
            pub_year = random.randint(2020, datetime.now().year)
            published_date = get_random_past_datetime(start_date=datetime(pub_year, 1, 1))

            pub = Publication(
                title=fake.catch_phrase().capitalize() + f" ({display_name_text} #{j+1})",
                year=pub_year,
                type_id=type_id,
                display_name_id=chosen_dn_id,
                status='published', # Все создаем опубликованными
                file_url=f"/uploads/sample_file_{user_obj.username}_{j+1}.pdf", # Условный URL
                user_id=user_obj.id,
                published_at=published_date,
                updated_at=published_date + timedelta(days=random.randint(1, 30)), # Дата обновления позже публикации
                # --- Заполняем некоторые другие поля ---
                journal_conference_name=fake.company() + (" Journal" if random.random() > 0.5 else " Conf. Proceedings"),
                doi=f"10.{random.randint(1000, 9999)}/j.test.{random.randint(10000, 99999)}" if random.random() > 0.3 else None,
                issn=f"{random.randint(1000,9999)}-{random.randint(1000,9990)}{random.choice(['X', ''])}" if random.random() > 0.6 else None,
                volume=str(random.randint(1, 50)) if random.random() > 0.4 else None,
                number=str(random.randint(1, 12)) if random.random() > 0.4 else None,
                pages=f"{random.randint(10, 50)}--{random.randint(51, 100)}" if random.random() > 0.2 else str(random.randint(10, 200)),
                publisher=fake.company() if random.random() > 0.5 else None,
                publisher_location=fake.city() if random.random() > 0.6 else None,
                printed_sheets_volume=round(random.uniform(0.5, 15.0), 2) if random.random() > 0.3 else None,
                notes=f"Тестовое примечание {j+1}" if random.random() > 0.8 else None,
                work_form=random.choice(['Печатная', 'Электронная']),
                # Случайные флаги (чаще False)
                is_vak = random.random() < 0.2,
                is_wos = random.random() < 0.1,
                is_scopus = random.random() < 0.15,
            )
            all_created_publications.append(pub)
            user_publications.append(pub)
            db.session.add(pub)
            db.session.flush() # Получаем ID публикации для авторов

            # --- Создание авторов ---
            num_authors = random.randint(1, MAX_AUTHORS_PER_PUB)
            authors_list = []
            # Первым автором делаем владельца публикации
            authors_list.append(PublicationAuthor(
                name=user_obj.full_name,
                is_employee=True, # Предположим, владелец - сотрудник
                publication_id=pub.id
            ))
            # Добавляем соавторов
            for k in range(num_authors - 1):
                 authors_list.append(PublicationAuthor(
                      name=fake.name(),
                      is_employee=random.choice([True, False]), # Соавтор может быть или не быть сотрудником
                      publication_id=pub.id
                 ))
            db.session.add_all(authors_list)
            # db.session.flush() # Flush не обязателен здесь перед коммитом

        print(f"    -> Создано {len(user_publications)} публикаций.")


    # --- 4. Создание планов и записей планов ---
    print("\n4. Создание планов и записей...")
    linked_pub_ids = set() # Отслеживаем уже связанные публикации

    for user_obj in users:
        print(f"  Создание планов для пользователя '{user_obj.username}'...")
        user_published_pubs = [p for p in all_created_publications if p.user_id == user_obj.id]

        for plan_year in [2023, 2024]: # Пример: планы на 2 года
            plan_status = random.choice(['draft', 'needs_review', 'approved', 'returned']) # Определяем статус здесь

            plan = Plan(
                year=plan_year,
                user_id=user_obj.id,
                status=plan_status, # Используем plan_status
                # --- ИСПРАВЛЕНО: Используем plan_status в условиях ---
                approved_at=get_random_past_datetime(start_date=datetime(plan_year, 1, 1)) if plan_status == 'approved' else None,
                returned_at=get_random_past_datetime(start_date=datetime(plan_year, 1, 1)) if plan_status == 'returned' else None,
                return_comment="Требуется уточнить тип публикации для записи #3" if plan_status == 'returned' else None
            )
            db.session.add(plan)
            db.session.flush() # Получаем ID плана

            # Создаем 5-15 записей в плане
            num_entries = random.randint(5, 15)
            plan_entries = []
            added_links = 0
            for entry_idx in range(num_entries):
                entry_dn_id = random.choice(valid_display_name_ids)
                entry_type_details = display_name_details[entry_dn_id]
                entry_type_id = entry_type_details['type_id']
                entry_display_name = entry_type_details['display_name']

                # Попытка связать с публикацией (только для 'approved' планов и если есть подходящие)
                linked_publication = None
                link_status = 'planned'
                if plan.status == 'approved' and random.random() < 0.4: # Шанс 40% на попытку связки
                    # Ищем подходящие неопубликованные публикации этого пользователя
                    suitable_pubs = [
                        p for p in user_published_pubs
                        if p.display_name_id == entry_dn_id and p.id not in linked_pub_ids
                    ]
                    if suitable_pubs:
                        linked_publication = random.choice(suitable_pubs)
                        linked_pub_ids.add(linked_publication.id) # Помечаем как использованную
                        link_status = 'completed'
                        added_links += 1

                entry = PlanEntry(
                    plan_id=plan.id,
                    title=f"Планируемая работа ({entry_display_name}) №{entry_idx+1}",
                    type_id=entry_type_id,
                    display_name_id=entry_dn_id,
                    status=link_status,
                    publication_id=linked_publication.id if linked_publication else None
                )
                plan_entries.append(entry)

            db.session.add_all(plan_entries)
            print(f"    + План на {plan_year} создан (Статус: {plan.status}, Записей: {num_entries}, Связано: {added_links})")


    # --- 5. Создание истории действий (Менеджером) ---
    print("\n5. Создание истории действий...")
    pubs_to_action = Publication.query.filter(Publication.status != 'draft').limit(5).all() # Возьмем 5 не-черновиков
    plans_to_action = Plan.query.filter(Plan.status != 'draft').limit(3).all() # Возьмем 3 не-черновика

    history_count = 0
    # Действия с публикациями
    for pub in pubs_to_action:
        action_type = random.choice(['approved', 'returned'])
        comment = fake.sentence(nb_words=10) if action_type == 'returned' else None
        action_time = get_random_past_datetime(start_date=pub.updated_at)

        history = PublicationActionHistory(
            publication_id=pub.id,
            action_type=action_type,
            timestamp=action_time,
            comment=comment,
            user_id=manager_user.id # Действие от менеджера
        )
        db.session.add(history)
        history_count += 1

        # Обновляем статус самой публикации (если еще не был установлен в процессе создания)
        if action_type == 'approved' and pub.status != 'published':
            pub.status = 'published'
            pub.published_at = action_time
            pub.returned_for_revision = False
        elif action_type == 'returned' and pub.status != 'returned_for_revision':
            pub.status = 'returned_for_revision'
            pub.returned_for_revision = True
            pub.return_comment = comment
            pub.returned_at = action_time
        # db.session.flush() # Можно, но не обязательно перед коммитом

    # Действия с планами
    for plan in plans_to_action:
         action_type = random.choice(['approved', 'returned'])
         comment = fake.paragraph(nb_sentences=2) if action_type == 'returned' else None
         action_time = get_random_past_datetime() # Можно привязать к дате создания/обновления плана

         history = PlanActionHistory(
             plan_id=plan.id,
             action_type=action_type,
             timestamp=action_time,
             comment=comment,
             user_id=manager_user.id # Действие от менеджера
         )
         db.session.add(history)
         history_count += 1
         # Обновляем статус плана
         if action_type == 'approved' and plan.status != 'approved':
             plan.status = 'approved'
             plan.approved_at = action_time
         elif action_type == 'returned' and plan.status != 'returned':
             plan.status = 'returned'
             plan.returned_at = action_time
             plan.return_comment = comment
         # db.session.flush()

    print(f"  + Добавлено {history_count} записей в историю действий.")


    # --- 6. Создание комментариев (несколько примеров) ---
    print("\n6. Создание комментариев...")
    pubs_for_comments = Publication.query.order_by(db.func.random()).limit(5).all() # Возьмем 5 случайных
    comment_count = 0

    for pub in pubs_for_comments:
        # Комментарий пользователя
        user_comment = Comment(
            content=fake.sentence(nb_words=15),
            user_id=pub.user_id,
            publication_id=pub.id,
            created_at=get_random_past_datetime(start_date=pub.updated_at)
        )
        db.session.add(user_comment)
        db.session.flush() # Нужен ID для parent_id
        comment_count += 1

        # Ответ менеджера (вероятность 50%)
        if random.random() < 0.5:
            manager_reply = Comment(
                content=fake.sentence(nb_words=8),
                user_id=manager_user.id,
                publication_id=pub.id,
                parent_id=user_comment.id, # Ответ на комментарий пользователя
                created_at=get_random_past_datetime(start_date=user_comment.created_at)
            )
            db.session.add(manager_reply)
            comment_count += 1
    print(f"  + Добавлено {comment_count} комментариев.")

    # --- Фиксация всех изменений ---
    print("\n7. Фиксация изменений в базе данных...")
    db.session.commit()
    print("   -> Изменения успешно сохранены.")


    print("\n-------------------------------------------")
    print("Заполнение базы данных успешно завершено!")
    print("-------------------------------------------")

except IntegrityError as ie:
    db.session.rollback()
    print(f"\n!!! Ошибка целостности базы данных: {str(ie)} !!!")
    print("   Возможно, вы пытаетесь создать дубликат уникального значения (например, username).")
    print("   Изменения были отменены.")
except Exception as e:
    db.session.rollback()
    print(f"\n!!! Произошла ошибка: {str(e)} !!!")
    import traceback
    traceback.print_exc() # Вывод полного стека ошибки для диагностики
    print("   Изменения были отменены.")