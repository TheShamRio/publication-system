from flask import Flask, send_from_directory, make_response, request
from flask_cors import CORS
from .extensions import db, migrate, login_manager, csrf
from .models import User
import os
import logging
from flask_session import Session

# Настройка логирования
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def create_app():
    app = Flask(__name__)
    app.config.from_object('config.Config')

    # Устанавливаем секретный ключ
    app.secret_key = os.getenv("SECRET_KEY", "your-fixed-secret-key-here")

    # Настройка Flask-Session
    app.config['SESSION_TYPE'] = 'sqlalchemy'
    app.config['SESSION_SQLALCHEMY'] = db
    app.config['SESSION_PERMANENT'] = True
    app.config['PERMANENT_SESSION_LIFETIME'] = 60 * 60 * 24 * 7  # 7 дней
    app.config['SESSION_COOKIE_HTTPONLY'] = True
    app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
    app.config['SESSION_COOKIE_SECURE'] = False  # Установите True в продакшене с HTTPS

    # Инициализация расширений
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)
    Session(app)
    csrf.init_app(app)

    # Настройка CORS
    CORS(app, resources={r"/*": {"origins": "http://localhost:3001"}}, supports_credentials=True)

    # Обработка предварительных запросов
    @app.before_request
    def handle_preflight():
        if request.method == 'OPTIONS':
            response = make_response()
            response.headers['Access-Control-Allow-Origin'] = 'http://localhost:3001'
            response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
            response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-CSRFToken'
            response.headers['Access-Control-Allow-Credentials'] = 'true'
            response.headers['Access-Control-Max-Age'] = '86400'
            return response, 200

    # Регистрация Blueprint'ов
    from .routes import bp as user_bp
    app.register_blueprint(user_bp, url_prefix='/api')
    logger.debug("Зарегистрирован Blueprint 'api' с префиксом '/api'")

    from .api import bp as admin_bp
    app.register_blueprint(admin_bp, url_prefix='/admin_api')
    logger.debug("Зарегистрирован Blueprint 'admin_api' с префиксом '/admin_api'")

    # Обработчик для загрузки файлов
    @app.route('/uploads/<path:filename>')
    def download_file(filename):
        logger.debug(f"Отправка файла из /uploads/{filename}")
        return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

    with app.app_context():
        db.create_all()

    return app

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))