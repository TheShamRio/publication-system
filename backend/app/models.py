from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from .extensions import db
from flask_login import UserMixin

class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    publications = db.relationship('Publication', back_populates='user', lazy=True)  # Убираем backref, используем back_populates
    password_hash = db.Column(db.Text)
    role = db.Column(db.String(20), default='user')  # Изменил на 'user' по умолчанию
    last_name = db.Column(db.String(100), nullable=True)  # Фамилия
    first_name = db.Column(db.String(100), nullable=True)  # Имя
    middle_name = db.Column(db.String(100), nullable=True)  # Отчество
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    @property
    def full_name(self):
        return f"{self.first_name} {self.middle_name} {self.last_name}"
		
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    # Flask-Login methods
    def is_active(self):
        return True  # Всегда активный пользователь, измените, если нужны проверки

    def is_authenticated(self):
        return True

    def is_anonymous(self):
        return False
    
    def get_id(self):
        return str(self.id)  # Flask-Login требует строковый идентификатор

class Publication(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    authors = db.Column(db.String(200), nullable=False)
    year = db.Column(db.Integer, nullable=False)
    type = db.Column(db.String(50), nullable=False)
    status = db.Column(db.String(50), nullable=False, default='draft')
    file_url = db.Column(db.String(200))
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = db.relationship('User', back_populates='publications', lazy=True)  # Убираем backref, используем back_populates
    # Убираем конфликтное relationship 'author', так как оно дублирует user

    @property
    def type_ru(self):
        return {
            'article': 'Статья',
            'monograph': 'Монография',
            'conference': 'Доклад/конференция'
        }.get(self.type, self.type)

    @property
    def status_ru(self):
        return {
            'draft': 'Черновик',
            'review': 'На проверке',
            'published': 'Опубликовано'
        }.get(self.status, self.status)

class Achievement(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    badge = db.Column(db.String(50))  # 'top_author', '10_publications'
    date_earned = db.Column(db.DateTime, default=datetime.utcnow)

    @staticmethod
    def check_achievements(user_id):
        count = Publication.query.filter_by(user_id=user_id).count()
        if count >= 10:
            achievement = Achievement(user_id=user_id, badge='10_publications')
            db.session.add(achievement)
            db.session.commit()