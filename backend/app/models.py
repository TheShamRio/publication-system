from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from .extensions import db
from flask_login import UserMixin


class Comment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.Text, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    publication_id = db.Column(db.Integer, db.ForeignKey('publication.id'), nullable=False)
    parent_id = db.Column(db.Integer, db.ForeignKey('comment.id'), nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.utcnow(), nullable=False)

    user = db.relationship('User', backref='comments', lazy=True)
    publication = db.relationship('Publication', backref='comments', lazy=True)
    parent = db.relationship('Comment', remote_side=[id], backref='replies', lazy=True)

class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    publications = db.relationship('Publication', back_populates='user', lazy=True)
    password_hash = db.Column(db.Text)
    role = db.Column(db.String(20), default='user')
    last_name = db.Column(db.String(100), nullable=True)
    first_name = db.Column(db.String(100), nullable=True)
    middle_name = db.Column(db.String(100), nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.utcnow(), nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)  # Добавлено
    @property
    def full_name(self):
        return f"{self.last_name or ''} {self.first_name or ''} {self.middle_name or ''}".strip()
    
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    def is_active(self):
        return True

    def is_authenticated(self):
        return True

    def is_anonymous(self):
        return False
    
    def get_id(self):
        return str(self.id)

class Publication(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    authors = db.Column(db.String(200), nullable=False)
    year = db.Column(db.Integer, nullable=False)
    type = db.Column(db.String(50), nullable=False)
    status = db.Column(db.String(50), nullable=False, default='draft')
    file_url = db.Column(db.String(200), nullable=True)  # Оставляем как nullable=True
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete='SET NULL'), nullable=True)
    updated_at = db.Column(db.DateTime, default=lambda: datetime.utcnow(), onupdate=lambda: datetime.utcnow(), nullable=False)
    published_at = db.Column(db.DateTime, nullable=True)

    user = db.relationship('User', back_populates='publications', lazy=True)

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
            'published': 'Оп-published'
        }.get(self.status, self.status)
class Achievement(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    badge = db.Column(db.String(50))
    date_earned = db.Column(db.DateTime, default=lambda: datetime.utcnow(), nullable=False)

    user = db.relationship('User', backref='achievements', lazy=True)

    @staticmethod
    def check_achievements(user_id):
        user = User.query.get_or_404(user_id)
        pub_count = Publication.query.filter_by(user_id=user_id).count()

        achievements = [
            ('top_author', pub_count >= 10),
            ('10_publications', pub_count >= 10),
            ('50_publications', pub_count >= 50)
        ]

        for badge, condition in achievements:
            if condition and not Achievement.query.filter_by(user_id=user_id, badge=badge).first():
                new_achievement = Achievement(user_id=user_id, badge=badge)
                db.session.add(new_achievement)
        db.session.commit()