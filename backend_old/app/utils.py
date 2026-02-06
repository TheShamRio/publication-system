from werkzeug.utils import secure_filename
import os

def allowed_file(filename, allowed_extensions=['pdf', 'docx', 'bib']):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in allowed_extensions
