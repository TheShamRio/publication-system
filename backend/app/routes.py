from flask import Blueprint, jsonify, request
from .extensions import db
from .models import Publication, User
import bibtexparser
from flask_login import login_user, current_user, logout_user
from functools import wraps
from flask_login import login_required
from .analytics import get_publications_by_year
from flask import current_app
from werkzeug.utils import secure_filename
import os



bp = Blueprint('api', __name__)

	
@bp.route('/publications', methods=['GET'])
def get_publications():
    publications = Publication.query.all()
    return jsonify([{
        'id': pub.id,
        'title': pub.title,
        'year': pub.year
    } for pub in publications])



@bp.route('/publications/upload-file', methods=['POST'])
@login_required
def upload_file():
    # Проверяем, передан ли файл в запросе
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400

    file = request.files['file']

    if file.filename == '':
        return jsonify({"error": "No file selected"}), 400

    # Проверяем, разрешено ли расширение
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
        file.save(file_path)
        
        # Получаем дополнительные данные из формы (метаданные публикации)
        # Можно передавать их через form-data
        title = request.form.get('title', 'Untitled')
        authors = request.form.get('authors', 'Unknown')
        year = request.form.get('year', 2023)
        pub_type = request.form.get('type', 'article')
        
        # Создаем объект Publication и сохраняем в БД
        publication = Publication(
            title=title,
            authors=authors,
            year=int(year),
            type=pub_type,
            file_url=file_path,
            status='draft',
            user_id=current_user.id
        )
        db.session.add(publication)
        db.session.commit()
        
        return jsonify({"message": "Publication created with file", "id": publication.id}), 201
    else:
        return jsonify({"error": "File type not allowed"}), 400

@bp.route('/publications/upload-bibtex', methods=['POST'])
def upload_bibtex():
    if 'file' not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "Empty filename"}), 400

    bibtex_str = file.read().decode('utf-8')
    parser = bibtexparser.bparser.BibTexParser(common_strings=True)
    bib_database = bibtexparser.loads(bibtex_str, parser=parser)

    for entry in bib_database.entries:
        publication = Publication(
            title=entry.get('title', 'Untitled'),
            authors=entry.get('author', 'Unknown'),
            year=int(entry.get('year', 2023)),
            type=entry.get('ENTRYTYPE', 'article'),
            status='draft'
        )
        db.session.add(publication)

    db.session.commit()
    return jsonify({"message": f"Uploaded {len(bib_database.entries)} publications"}), 201

@bp.route('/register', methods=['POST'])
def register():
    data = request.json
    user = User(username=data['username'])
    user.set_password(data['password'])
    db.session.add(user)
    db.session.commit()
    return jsonify({"message": "User created"}), 201

@bp.route('/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(username=data['username']).first()
    if user and user.check_password(data['password']):
        login_user(user)
        return jsonify({"message": "Logged in"})
    return jsonify({"error": "Invalid credentials"}), 401

@bp.route('/logout')
def logout():
    logout_user()
    return jsonify({"message": "Logged out"})

def admin_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if current_user.role != 'admin':
            return jsonify({"error": "Access denied"}), 403
        return f(*args, **kwargs)
    return decorated

@bp.route('/admin/stats')
@login_required
@admin_required
def admin_stats():
    # Логика для админ-панели
    return jsonify({"total_publications": Publication.query.count()})

@bp.route('/analytics/yearly')
def yearly_analytics():
    data = get_publications_by_year()
    return jsonify([{"year": year, "count": count} for year, count in data])

def allowed_file(filename):
    with current_app.app_context():
        return '.' in filename and \
            filename.rsplit('.', 1)[1].lower() in current_app.config['ALLOWED_EXTENSIONS']
    

@bp.route('/publications/<int:pub_id>', methods=['PUT'])
@login_required
def update_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    
    # Проверяем, что текущий пользователь является автором публикации
    if publication.user_id != current_user.id:
        return jsonify({"error": "Access denied"}), 403

    data = request.json
    publication.title = data.get('title', publication.title)
    publication.authors = data.get('authors', publication.authors)
    publication.year = int(data.get('year', publication.year))
    publication.type = data.get('type', publication.type)
    publication.status = data.get('status', publication.status)
    
    db.session.commit()
    return jsonify({"message": "Publication updated"})

@bp.route('/publications/<int:pub_id>', methods=['DELETE'])
@login_required
def delete_publication(pub_id):
    publication = Publication.query.get_or_404(pub_id)
    
    # Проверяем, что текущий пользователь является автором публикации
    if publication.user_id != current_user.id:
        return jsonify({"error": "Access denied"}), 403

    db.session.delete(publication)
    db.session.commit()
    return jsonify({"message": "Publication deleted"})


@bp.route('/publications/search', methods=['GET'])
@login_required
def search_publications():
    # Получаем параметры запроса
    year = request.args.get('year')
    author = request.args.get('author')
    title = request.args.get('title')
    
    query = Publication.query

    if year:
        query = query.filter(Publication.year == int(year))
    if author:
        query = query.filter(Publication.authors.ilike(f'%{author}%'))
    if title:
        query = query.filter(Publication.title.ilike(f'%{title}%'))

    publications = query.all()
    results = [{
        'id': pub.id,
        'title': pub.title,
        'authors': pub.authors,
        'year': pub.year,
        'type': pub.type,
        'status': pub.status,
        'file_url': pub.file_url
    } for pub in publications]

    return jsonify(results)