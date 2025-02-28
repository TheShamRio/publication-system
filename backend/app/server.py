from flask import Flask, request, send_file
from flask_cors import CORS
import os
import tempfile
from spire.doc import Document, FileFormat

app = Flask(__name__)
CORS(app)  # Разрешаем CORS для всех маршрутов

# Путь для временного хранения файлов
UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/convert', methods=['POST'])
def convert_docx_to_pdf():
    try:
        if 'file' not in request.files:
            return {"error": "No file part in the request"}, 400
        
        file = request.files['file']
        if file.filename == '':
            return {"error": "No selected file"}, 400
        
        if file and file.filename.lower().endswith('.docx'):
            with tempfile.TemporaryDirectory() as temp_dir:
                input_path = os.path.join(temp_dir, file.filename)
                output_path = os.path.join(temp_dir, "converted.pdf")
                
                file.save(input_path)

                document = Document()
                document.LoadFromFile(input_path)
                document.SaveToFile(output_path, FileFormat.PDF)
                document.Close()

                return send_file(
                    output_path,
                    as_attachment=True,
                    download_name='converted.pdf',
                    mimetype='application/pdf'
                )

        return {"error": "Invalid file format, only .docx is supported"}, 400

    except Exception as e:
        return {"error": f"Error converting file: {str(e)}"}, 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)