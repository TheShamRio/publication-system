from .extensions import db
from .models import Publication
from sqlalchemy import func

def get_publications_by_year():
    return db.session.query(
        Publication.year, 
        func.count(Publication.id)
    ).group_by(Publication.year).all()