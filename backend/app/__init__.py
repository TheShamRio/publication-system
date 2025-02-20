from flask import Flask
from .extensions import db, migrate, login_manager  
from .models import User
import os
from flask_cors import CORS

def create_app():
    app = Flask(__name__)
    app.config.from_object('config.Config')

    app.secret_key = os.getenv("SECRET_KEY", "your-unique-secret-key-here")

    # Инициализация расширений
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)

    # Настройка CORS — разрешаем запросы с localhost:3001 и включаем учетные данные
    CORS(app, resources={r"/api/*": {"origins": "http://localhost:3001", "supports_credentials": True}})

    from .routes import bp
    app.register_blueprint(bp, url_prefix='/api')

    with app.app_context():
        db.create_all()

    return app

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))