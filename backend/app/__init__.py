from flask import Flask, send_from_directory, jsonify, make_response
from flask_cors import CORS  # Добавляем CORS
from .extensions import db, migrate, login_manager
from .models import User
import os
from flask_wtf import CSRFProtect
from flask_wtf.csrf import generate_csrf
from .routes import bp as user_bp
from .api import bp as admin_bp

def create_app():
    app = Flask(__name__)
    app.config.from_object('config.Config')

    # Генерация секретного ключа
    import secrets
    app.secret_key = os.getenv("SECRET_KEY", secrets.token_hex(16))

    # Инициализация расширений
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)

    # Настройка CORS
    CORS(app, resources={r"/api/*": {"origins": ["http://localhost:3000", "http://localhost:3001"]},
                         r"/admin_api/*": {"origins": ["http://localhost:3000", "http://localhost:3001"]}},
         supports_credentials=True)

    # CSRF защита
    csrf = CSRFProtect(app)

    # Регистрация Blueprint'ов
    app.register_blueprint(user_bp, url_prefix='/api')
    app.register_blueprint(admin_bp, url_prefix='/admin_api')

    @app.route('/uploads/<path:filename>')
    def download_file(filename):
        return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

    @app.route('/api/csrf-token', methods=['GET'])
    def get_csrf_token():
        token = generate_csrf()
        response = make_response(jsonify({'csrf_token': token}))
        response.set_cookie('csrf_token', token, httponly=True, secure=False, samesite='Strict')
        return response

    with app.app_context():
        db.create_all()

    return app

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))