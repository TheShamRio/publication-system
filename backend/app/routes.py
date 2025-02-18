from flask import Blueprint, jsonify, request
from .extensions import db
from .models import Publication, User
import bibtexparser
from flask_login import LoginManager, login_user, current_user, logout_user
from functools import wraps
from flask_login import login_required
from .analytics import get_publications_by_year

login = LoginManager()

bp = Blueprint('api', __name__)

	
@bp.route('/publications', methods=['GET'])
def get_publications():
    publications = Publication.query.all()
    return jsonify([{
        'id': pub.id,
        'title': pub.title,
        'year': pub.year
    } for pub in publications])

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