from flask import Flask
from .extensions import db, migrate

def create_app():
    app = Flask(__name__)
    app.config.from_object('config.Config')

    # Инициализация расширений
    db.init_app(app)
    migrate.init_app(app, db)

    # Регистрация Blueprint
    from .routes import bp
    app.register_blueprint(bp, url_prefix='/api')

    return app