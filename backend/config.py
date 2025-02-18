import os

class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv(
        'DATABASE_URL',
        'postgresql://postgres:1111@localhost:5432/publication_db'
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    # Конфигурация для загрузки файлов
    UPLOAD_FOLDER = os.path.join(os.getcwd(), 'uploads')
    ALLOWED_EXTENSIONS = {'pdf', 'docx'}  # Переместил ALLOWED_EXTENSIONS сюда

if not os.path.exists(Config.UPLOAD_FOLDER):
    os.makedirs(Config.UPLOAD_FOLDER)