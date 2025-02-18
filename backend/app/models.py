from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from .extensions import db

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    publications = db.relationship('Publication', backref='author', lazy=True)
    password_hash = db.Column(db.String(128))
    role = db.Column(db.String(20), default='teacher')

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

class Publication(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    authors = db.Column(db.String(500), nullable=False)
    year = db.Column(db.Integer, nullable=False)
    type = db.Column(db.String(50), nullable=False)
    status = db.Column(db.String(20), default='draft')
    file_url = db.Column(db.String(300))
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

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