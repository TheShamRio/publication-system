from app import create_app, db
from app.models import PublicationType, Publication
from datetime import datetime

app = create_app()

with app.app_context():
    # Список стандартных типов BibTeX
    types = [
        {'name': 'article', 'name_ru': 'Статья'},
        {'name': 'book', 'name_ru': 'Книга'},
        {'name': 'booklet', 'name_ru': 'Буклет'},
        {'name': 'conference', 'name_ru': 'Доклад/конференция'},
        {'name': 'inbook', 'name_ru': 'Глава в книге'},
        {'name': 'incollection', 'name_ru': 'Статья в сборнике'},
        {'name': 'inproceedings', 'name_ru': 'Доклад в сборнике конференции'},
        {'name': 'manual', 'name_ru': 'Руководство'},
        {'name': 'mastersthesis', 'name_ru': 'Магистерская диссертация'},
        {'name': 'misc', 'name_ru': 'Прочее'},
        {'name': 'phdthesis', 'name_ru': 'Докторская диссертация'},
        {'name': 'proceedings', 'name_ru': 'Сборник конференции'},
        {'name': 'techreport', 'name_ru': 'Технический отчёт'},
        {'name': 'unpublished', 'name_ru': 'Неопубликованное'},
        {'name': 'monograph', 'name_ru': 'Монография'}  # Ваш кастомный тип
    ]

    # Добавляем типы в базу
    for type_data in types:
        if not PublicationType.query.filter_by(name=type_data['name']).first():
            new_type = PublicationType(
                name=type_data['name'],
                name_ru=type_data['name_ru'],
                created_at=datetime.utcnow()
            )
            db.session.add(new_type)

    db.session.commit()

    # Обновляем существующие записи в Publication
    type_mapping = {pt.name.lower(): pt.id for pt in PublicationType.query.all()}
    publications = Publication.query.all()
    for pub in publications:
        # Проверяем, есть ли старое поле type (для миграции)
        if hasattr(pub, 'type') and isinstance(pub.type, str) and pub.type.lower() in type_mapping:
            pub.type_id = type_mapping[pub.type.lower()]
            pub.type = None  # Очищаем старое поле type

    db.session.commit()
    print("Стандартные типы BibTeX добавлены и существующие записи обновлены.")