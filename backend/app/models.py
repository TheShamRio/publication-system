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
    
class PublicationFieldHint(db.Model):
    __tablename__ = 'publication_field_hint' # Явное имя таблицы

    # Название поля в модели Publication (e.g., 'title', 'year', 'authors', 'doi', 'journal_conference_name')
    field_name = db.Column(db.String(100), primary_key=True, unique=True)
    # Текст подсказки
    hint_text = db.Column(db.Text, nullable=True, default='') # Разрешаем пустые подсказки
    updated_at = db.Column(db.DateTime, default=lambda: datetime.utcnow(), onupdate=lambda: datetime.utcnow())
    # Опционально: можно добавить user_id, кто последний редактировал
    # updated_by_user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)
    # updated_by = db.relationship('User')

    def to_dict(self):
        return {
            'field_name': self.field_name,
            'hint_text': self.hint_text,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }

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
    __tablename__ = 'publication_type'
    
    # Поля таблицы
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    created_at = db.Column(db.DateTime, default=lambda: datetime.utcnow(), nullable=False)
    updated_at = db.Column(db.DateTime, default=lambda: datetime.utcnow(), onupdate=lambda: datetime.utcnow(), nullable=False)
    
    # Отношение к PublicationTypeDisplayName
    display_names = db.relationship(
        'PublicationTypeDisplayName',
        back_populates='publication_type',  # Явная обратная связь
        cascade='all, delete-orphan'       # Каскадное удаление
    )

class PublicationTypeDisplayName(db.Model):
    __tablename__ = 'publication_type_display_name'
    
    # Поля таблицы
    id = db.Column(db.Integer, primary_key=True)
    publication_type_id = db.Column(db.Integer, db.ForeignKey('publication_type.id', ondelete='CASCADE'), nullable=False)
    display_name = db.Column(db.String(100), nullable=False)
    created_at = db.Column(db.DateTime, default=lambda: datetime.utcnow(), nullable=False)
    updated_at = db.Column(db.DateTime, default=lambda: datetime.utcnow(), onupdate=lambda: datetime.utcnow(), nullable=False)
    
    # Отношение к PublicationType
    publication_type = db.relationship(
        'PublicationType',
        back_populates='display_names'  # Явная обратная связь
    )
class Publication(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(5000), nullable=False)
    year = db.Column(db.Integer, nullable=False)
    type_id = db.Column(db.Integer, db.ForeignKey('publication_type.id', ondelete='SET NULL'), nullable=True)
    type = db.relationship('PublicationType', backref='publications')
    display_name_id = db.Column(db.Integer, db.ForeignKey('publication_type_display_name.id', ondelete='SET NULL'), nullable=True)
    display_name = db.relationship('PublicationTypeDisplayName', backref='publications', lazy=True)
    status = db.Column(db.String(50), nullable=False, default='draft')
    file_url = db.Column(db.String(1000), nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete='SET NULL'), nullable=True)
    updated_at = db.Column(db.DateTime, default=lambda: datetime.utcnow(), onupdate=lambda: datetime.utcnow(), nullable=False)
    returned_for_revision = db.Column(db.Boolean, default=False)
    published_at = db.Column(db.DateTime, nullable=True)
    returned_at = db.Column(db.DateTime, nullable=True)
    return_comment = db.Column(db.Text, nullable=True)

    user = db.relationship('User', back_populates='publications', lazy=True)
    plan_entries = db.relationship('PlanEntry', back_populates='publication', lazy=True)
    authors = db.relationship('PublicationAuthor', backref='publication', lazy='select', cascade='all, delete-orphan')

    # --- НОВЫЕ ПОЛЯ ---
    journal_conference_name = db.Column(db.Text, nullable=True)  # 1.
    doi = db.Column(db.String(100), nullable=True)                      # 2.
    issn = db.Column(db.String(20), nullable=True)                       # 3.
    isbn = db.Column(db.String(20), nullable=True)                       # 4.
    quartile = db.Column(db.String(10), nullable=True)                   # 5.
    # ЗАМЕНЯЕМ number_volume_pages:
    # number_volume_pages = db.Column(db.String(100), nullable=True)     # <- УДАЛИТЬ ЭТУ СТРОКУ
    volume = db.Column(db.String(50), nullable=True)                   # 6. Том
    number = db.Column(db.String(50), nullable=True)                   # 7. Номер/Выпуск
    pages = db.Column(db.String(50), nullable=True)                    # 8. Страницы
    # Сдвигаем нумерацию остальных полей
    department = db.Column(db.String(150), nullable=True)               # 9. Кафедра
    publisher = db.Column(db.String(5000), nullable=True)                # 10. Издательство
    publisher_location = db.Column(db.String(150), nullable=True)       # 11. Место издательства
    printed_sheets_volume = db.Column(db.Float, nullable=True)           # 12. Объем в п.л.
    circulation = db.Column(db.Integer, nullable=True)                   # 13. Тираж
    classification_code = db.Column(db.String(100), nullable=True)      # 14. Направление и код
    notes = db.Column(db.Text, nullable=True)     
    # --- КОНЕЦ НОВЫХ ПОЛЕЙ ---

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
            'authors': [author.to_dict() for author in self.authors],
            'year': self.year,
            'type': {
                'id': self.type.id if self.type else None,
                'name': self.type.name.lstrip('@') if self.type else None, # Убираем @ если оно есть в БД
                'display_name': self.display_name.display_name if self.display_name else None,
                'display_names': [dn.display_name for dn in self.type.display_names] if self.type and hasattr(self.type, 'display_names') else []
            } if self.type else None,
            'display_name_id': self.display_name_id,
            'status': self.status,
            'file_url': self.file_url,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'returned_for_revision': self.returned_for_revision,
            'published_at': self.published_at.isoformat() if self.published_at else None,
            'returned_at': self.returned_at.isoformat() if self.returned_at else None,
            'return_comment': self.return_comment,
            'user': {
                'full_name': self.user.full_name if self.user else None
            } if self.user else None,
            # --- Добавляем новые поля в словарь ---
            'journal_conference_name': self.journal_conference_name,
            'doi': self.doi,
            'issn': self.issn,
            'isbn': self.isbn,
            'quartile': self.quartile,
            # 'number_volume_pages': self.number_volume_pages, # <- УДАЛИТЬ
            'volume': self.volume,                           # <- ДОБАВИТЬ
            'number': self.number,                           # <- ДОБАВИТЬ
            'pages': self.pages,                             # <- ДОБАВИТЬ
            'department': self.department,
            'publisher': self.publisher,
            'publisher_location': self.publisher_location,
            'printed_sheets_volume': self.printed_sheets_volume,
            'circulation': self.circulation,
            'classification_code': self.classification_code,
            'notes': self.notes,
            # --- Конец добавления новых полей ---
        }


class PublicationAuthor(db.Model):
    __tablename__ = 'publication_author' # Явно указываем имя таблицы

    id = db.Column(db.Integer, primary_key=True)
    publication_id = db.Column(db.Integer, db.ForeignKey('publication.id', ondelete='CASCADE'), nullable=False, index=True) # Добавлен index
    name = db.Column(db.String(1000), nullable=False) # Имя автора (Хасаншин Ш.Р.)
    is_employee = db.Column(db.Boolean, default=False, nullable=False) # Является ли сотрудником
    # Связь обратно к Publication (опционально, но полезно для некоторых запросов)
    # publication = db.relationship('Publication', back_populates='authors') # Закомментировано, т.к. back_populates определен в Publication

    # Не будем добавлять created_at/updated_at сюда, чтобы не усложнять

    def to_dict(self):
        return {
            'id': self.id, # Может пригодиться на фронте для удаления
            'name': self.name,
            'is_employee': self.is_employee
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
    approved_at = db.Column(db.DateTime, nullable=True)
    returned_at = db.Column(db.DateTime, nullable=True)

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
            'approved_at': self.approved_at.isoformat() if self.approved_at else None,
            'returned_at': self.returned_at.isoformat() if self.returned_at else None,
        }

class PlanEntry(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    plan_id = db.Column(db.Integer, db.ForeignKey('plan.id'), nullable=False)
    title = db.Column(db.String(5000), nullable=True)
    type_id = db.Column(db.Integer, db.ForeignKey('publication_type.id', ondelete='SET NULL'), nullable=True)
    display_name_id = db.Column(db.Integer, db.ForeignKey('publication_type_display_name.id', ondelete='SET NULL'), nullable=True)
    type = db.relationship('PublicationType', backref='plan_entries')
    display_name = db.relationship('PublicationTypeDisplayName', backref='plan_entries', lazy=True)  # Связь
    publication_id = db.Column(db.Integer, db.ForeignKey('publication.id'), nullable=True)
    status = db.Column(db.String(50), nullable=False, default='planned')
    isPostApproval = db.Column(db.Boolean, nullable=False, default=False)

    plan = db.relationship('Plan', back_populates='entries')
    publication = db.relationship('Publication', back_populates='plan_entries', lazy=True)

    def to_dict(self):
        # Существующие поля
        result = {
            'id': self.id,
            'title': self.title,
            'type': {
                'id': self.type.id,
                'name': self.type.name,
                'display_names': [dn.display_name for dn in self.type.display_names]
            } if self.type else None,
            'publication_id': self.publication_id,
            'status': self.status,
            'isPostApproval': self.isPostApproval,
            'plan_id': self.plan_id
        }
        # Добавляем новые поля для display_name_id и display_name
        if self.display_name_id:
            result['display_name_id'] = self.display_name_id
            result['display_name'] = self.display_name.display_name if self.display_name else None
        return result