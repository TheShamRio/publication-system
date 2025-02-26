from functools import wraps
from flask import jsonify
from flask_login import current_user
import logging

logging.basicConfig(level=logging.DEBUG)  # Установите уровень DEBUG для более детальных логов
logger = logging.getLogger(__name__)

def admin_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        logger.debug(f"Проверка прав доступа для пользователя: {current_user}")
        logger.debug(f"Роль пользователя: {current_user.role if current_user.is_authenticated else 'Not authenticated'}")
        if not current_user.is_authenticated or current_user.role != 'admin':
            logger.warning(f"Доступ запрещён для пользователя {current_user.username if current_user.is_authenticated else 'неавторизованного'}")
            return jsonify({"error": "Доступ запрещён. Требуется роль администратора."}), 403
        logger.debug(f"Доступ предоставлен для пользователя {current_user.username}")
        return f(*args, **kwargs)
    return decorated