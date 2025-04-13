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
    role = db.Column(db.String(20), default='user', nullable=False)  # 'user', 'admin', 'manager'
    last_name = db.Column(db.String(100), nullable=True)
    first_name = db.Column(db.String(100), nullable=True)
    middle_name = db.Column(db.String(100), nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.utcnow(), nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

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
    
		

class PublicationType(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)  # Например, 'article'
    display_name = db.Column(db.String(100), nullable=False)      # Например, 'Статья'
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

# Обновляем модель Publication
class Publication(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    authors = db.Column(db.String(200), nullable=False)
    year = db.Column(db.Integer, nullable=False)
    # Заменяем type на type_id и добавляем связь
    type_id = db.Column(db.Integer, db.ForeignKey('publication_type.id'), nullable=False)
    type = db.relationship('PublicationType', backref='publications')
    status = db.Column(db.String(50), nullable=False, default='draft')
    file_url = db.Column(db.String(200), nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete='SET NULL'), nullable=True)
    updated_at = db.Column(db.DateTime, default=lambda: datetime.utcnow(), onupdate=lambda: datetime.utcnow(), nullable=False)
    returned_for_revision = db.Column(db.Boolean, default=False)
    published_at = db.Column(db.DateTime, nullable=True)
    returned_at = db.Column(db.DateTime, nullable=True)
    return_comment = db.Column(db.Text, nullable=True)

    user = db.relationship('User', back_populates='publications', lazy=True)
    plan_entries = db.relationship('PlanEntry', back_populates='publication', lazy=True)


    @property
    def status_ru(self):
        return {
            'draft': 'Черновик',
            'needs_review': 'На проверке',
            'published': 'Опубликованные'
        }.get(self.status, self.status)

    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'authors': self.authors,
            'year': self.year,
            'type': {
                'id': self.type.id,
                'name': self.type.name,
                'display_name': self.type.display_name
            } if self.type else None,
            'status': self.status,
            'file_url': self.file_url,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'returned_for_revision': self.returned_for_revision,
            'published_at': self.published_at.isoformat() if self.published_at else None,
            'returned_at': self.returned_at.isoformat() if self.returned_at else None,
            'return_comment': self.return_comment,
            'user': {
                'full_name': self.user.full_name if self.user else None
            } if self.user else None
        }

class PlanActionHistory(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    plan_id = db.Column(db.Integer, db.ForeignKey('plan.id'), nullable=False)
    action_type = db.Column(db.String(20), nullable=False)  # 'approved', 'returned', etc.
    timestamp = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    comment = db.Column(db.Text, nullable=True)  # Комментарий для возврата
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)  # Кто выполнил действие

    plan = db.relationship('Plan', backref=db.backref('action_history', lazy='dynamic'))
    user = db.relationship('User', backref='plan_actions')
    
class PublicationActionHistory(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    publication_id = db.Column(db.Integer, db.ForeignKey('publication.id'), nullable=False)
    action_type = db.Column(db.String(20), nullable=False)  # 'approved', 'returned'
    timestamp = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    comment = db.Column(db.Text, nullable=True)  # Комментарий для возврата
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)  # Кто выполнил действие

    publication = db.relationship('Publication', backref=db.backref('action_history', lazy='dynamic'))
    user = db.relationship('User', backref='publication_actions')		
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

class Plan(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    year = db.Column(db.Integer, nullable=False)
    fillType = db.Column(db.String(10), nullable=False, default='manual')
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    status = db.Column(db.String(20), nullable=False, default='draft')
    return_comment = db.Column(db.Text, nullable=True)
    approved_at = db.Column(db.DateTime, nullable=True)  # Новое поле
    returned_at = db.Column(db.DateTime, nullable=True)  # Новое поле

    user = db.relationship('User', backref='plans', lazy=True)
    entries = db.relationship('PlanEntry', back_populates='plan', lazy=True, cascade='all, delete-orphan')

    def to_dict(self):
        plan_count = len(self.entries)
        fact_count = sum(1 for entry in self.entries if entry.publication_id is not None)
        return {
            'id': self.id,
            'year': self.year,
            'fillType': self.fillType,
            'status': self.status,
            'user': {
                'full_name': self.user.full_name if self.user else None,
                'username': self.user.username if self.user else None
            } if self.user else None,
            'entries': [entry.to_dict() for entry in self.entries],
            'return_comment': self.return_comment,
            'plan_count': plan_count,
            'fact_count': fact_count,
            'approved_at': self.approved_at.isoformat() if self.approved_at else None,  # Добавляем в ответ
            'returned_at': self.returned_at.isoformat() if self.returned_at else None,  # Добавляем в ответ
        }

class PlanEntry(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    plan_id = db.Column(db.Integer, db.ForeignKey('plan.id'), nullable=False)
    title = db.Column(db.String(200), nullable=True)
    # Заменяем type на type_id и добавляем связь
    type_id = db.Column(db.Integer, db.ForeignKey('publication_type.id'), nullable=True)
    type = db.relationship('PublicationType', backref='plan_entries')
    publication_id = db.Column(db.Integer, db.ForeignKey('publication.id'), nullable=True)
    status = db.Column(db.String(50), nullable=False, default='planned')
    isPostApproval = db.Column(db.Boolean, nullable=False, default=False)

    plan = db.relationship('Plan', back_populates='entries')
    publication = db.relationship('Publication', back_populates='plan_entries', lazy=True)

    def to_dict(self):
        from flask_login import current_user
        result = {
            'id': self.id,
            'title': self.title,
            'type': {
                'id': self.type.id,
                'name': self.type.name,
                'display_name': self.type.display_name
            } if self.type else None,
            'publication_id': self.publication_id,
            'status': self.status,
            'isPostApproval': self.isPostApproval,
            'publication': {
                'id': self.publication.id,
                'title': self.publication.title
            } if self.publication else None
        }
        if current_user.is_authenticated and current_user.role in ['admin', 'manager']:
            result['status'] = self.status
        return result