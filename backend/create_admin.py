# Импортируем необходимые модули
from app import create_app, db
from app.models import User

# Создаём приложение и контекст
app = create_app()
app.app_context().push()

# Проверяем, существует ли уже пользователь
existing_user = User.query.filter_by(username='admin').first()
if existing_user:
    print("Пользователь с username 'admin' уже существует")
else:
    # Создаём нового пользователя
    admin = User(
        username='admin',
        role='admin',
        last_name='Иванов',
        first_name='Иван',
        middle_name='Иванович'
    )
    admin.set_password('admin')  # Замените на ваш пароль

    try:
        # Сохраняем пользователя в базе данных
        db.session.add(admin)
        db.session.commit()
        print("Администратор успешно создан")
    except Exception as e:
        db.session.rollback()
        print(f"Ошибка при создании администратора: {str(e)}")

    # Проверяем результат
    new_admin = User.query.filter_by(username='admin').first()
    if new_admin:
        print(f"Пользователь найден: username={new_admin.username}, role={new_admin.role}")
    else:
        print("Пользователь не найден")