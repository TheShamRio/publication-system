# seed_publication_types.py
# Скрипт для первоначального заполнения типов публикаций и их отображаемых названий

from app import create_app, db
from app.models import PublicationType, PublicationTypeDisplayName # Убедитесь, что модели импортированы правильно

# --- ДАННЫЕ ДЛЯ ЗАПОЛНЕНИЯ ---
# Ключ: внутреннее имя типа (в таблице PublicationType.name)
# Значение: список отображаемых названий (в таблице PublicationTypeDisplayName.display_name)
publication_types_data = {
    'article': ['Статья', 'Статья ВАК', 'Статья WoS', 'Статья Scopus'],
    'conference': ['Конференция', 'Конференция РИНЦ', 'Конференция WoS', 'Конференция Scopus'],
    'misc': ['Интеллектуальная собственность', 'Депонированная рукопись'],
    'book': ['Пособие', 'Монография', 'Учебное пособие'],
    'phdthesis': ['Докторская диссертация'],
    'mastersthesis': ['Магистерская диссертация'],
    'techreport': ['Отчёт'],
    'ppc': ['ПЭВМ'],
}
# -----------------------------

# Создаём приложение и контекст
app = create_app()
app.app_context().push()

print("Начало заполнения типов публикаций и их отображаемых названий...")

try:
    added_types_count = 0
    added_dn_total = 0
    skipped_types_count = 0
    skipped_dn_total = 0

    for type_name, display_names_list in publication_types_data.items():
        print(f"\nОбработка типа: '{type_name}'")

        # 1. Проверяем/Создаем основной тип (PublicationType)
        pub_type = PublicationType.query.filter_by(name=type_name).first()

        if not pub_type:
            pub_type = PublicationType(name=type_name)
            db.session.add(pub_type)
            # !!! Важно сделать flush, чтобы получить ID для связи перед добавлением DisplayName !!!
            db.session.flush()
            print(f"  + Тип '{type_name}' СОЗДАН (ID: {pub_type.id}).")
            added_types_count += 1
        else:
            print(f"  - Тип '{type_name}' уже существует (ID: {pub_type.id}), добавление/проверка названий...")
            skipped_types_count += 1

        # 2. Проверяем/Добавляем отображаемые названия (PublicationTypeDisplayName) для этого типа
        current_added_dn = 0
        current_skipped_dn = 0
        for dn_text in display_names_list:
            # Проверяем, существует ли УЖЕ такое отображаемое имя ДЛЯ ЭТОГО ТИПА
            existing_dn = PublicationTypeDisplayName.query.filter_by(
                publication_type_id=pub_type.id, # Проверка связи с КОНКРЕТНЫМ типом
                display_name=dn_text
            ).first()

            if not existing_dn:
                display_name_entry = PublicationTypeDisplayName(
                    publication_type_id=pub_type.id, # Связываем с ID основного типа
                    display_name=dn_text
                )
                db.session.add(display_name_entry)
                current_added_dn += 1
                # print(f"    + Название '{dn_text}' будет добавлено.") # Можно раскомментировать для детального лога
            else:
                # print(f"    - Название '{dn_text}' уже существует для этого типа, пропуск.") # Можно раскомментировать
                current_skipped_dn += 1

        if current_added_dn > 0:
            print(f"    -> Добавлено {current_added_dn} новых отображаемых названий.")
            added_dn_total += current_added_dn
        if current_skipped_dn > 0:
            print(f"    -> Пропущено {current_skipped_dn} уже существующих отображаемых названий.")
            skipped_dn_total += current_skipped_dn

    # Фиксируем все изменения в базе данных одним коммитом
    db.session.commit()
    print("\n--------------------------------------------------")
    print("Заполнение типов публикаций успешно завершено.")
    print(f" Итог: Создано типов: {added_types_count}, Пропущено типов: {skipped_types_count}")
    print(f"       Добавлено отображаемых названий: {added_dn_total}, Пропущено названий: {skipped_dn_total}")
    print("--------------------------------------------------")


except Exception as e:
    db.session.rollback() # Откатываем транзакцию в случае ошибки
    print(f"\n!!! Ошибка при заполнении типов публикаций: {str(e)} !!!")
    print("Изменения были отменены.")

finally:
    # Важно удалить контекст приложения, если он больше не нужен
    # (в простом скрипте не критично, но хорошая практика)
    # db.session.remove() # Или как у вас настроено управление сессией
    pass