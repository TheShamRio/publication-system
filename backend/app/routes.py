from flask import Blueprint, jsonify
from .extensions import db
from .models import Publication

bp = Blueprint('api', __name__)

@bp.route('/publications', methods=['GET'])
def get_publications():
    publications = Publication.query.all()
    return jsonify([{
        'id': pub.id,
        'title': pub.title,
        'year': pub.year
    } for pub in publications])