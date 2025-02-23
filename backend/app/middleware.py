# app/middleware.py
from functools import wraps
from flask import jsonify
from flask_login import current_user
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def admin_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        logger.info(f"Current user: {current_user}")
        logger.info(f"Current user role: {current_user.role if current_user.is_authenticated else 'Not authenticated'}")
        if not current_user.is_authenticated or current_user.role != 'admin':
            return jsonify({"error": "Доступ запрещён. Требуется роль администратора."}), 401
        return f(*args, **kwargs)
    return decorated
