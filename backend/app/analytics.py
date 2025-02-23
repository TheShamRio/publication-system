from .extensions import db
from .models import Publication
from sqlalchemy import func

def get_publications_by_year(user_id=None):
    query = db.session.query(
        Publication.year, 
        func.count(Publication.id)
    ).group_by(Publication.year)
    if user_id:
        query = query.filter(Publication.user_id == user_id)
    return query.all()
