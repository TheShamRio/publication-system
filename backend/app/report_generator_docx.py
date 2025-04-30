from docx import Document
from docx.shared import Pt, Cm, Inches
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_ALIGN_VERTICAL, WD_TABLE_ALIGNMENT
# --- ИМПОРТЫ, НЕОБХОДИМЫЕ ДЛЯ ФУНКЦИИ ---
from docx.enum.section import WD_ORIENT # Этот импорт теперь не используется, но оставим на всякий случай
from docx.oxml.ns import qn
from docx.oxml import OxmlElement
from io import BytesIO
from .models import db, Publication, PublicationAuthor, PublicationTypeDisplayName, User # Убедитесь, что User импортирован
from sqlalchemy.orm import joinedload, selectinload
# --- Импортируем нужные datetime компоненты ---
from datetime import datetime, timedelta
from typing import Optional
# --- ---
import logging

logger = logging.getLogger(__name__)

# --- Функция set_cell_border (без изменений) ---
def set_cell_border(cell, **kwargs):
    tcPr = cell._tc.get_or_add_tcPr(); tcBorders = tcPr.first_child_found_in("w:tcBorders")
    if tcBorders is None: tcBorders = OxmlElement("w:tcBorders"); tcPr.append(tcBorders)
    for edge in ("top", "left", "bottom", "right", "start", "end", "insideH", "insideV"):
        if edge in kwargs:
            tag = f"w:{edge}"; border_element = tcBorders.find(qn(tag))
            if border_element is None: border_element = OxmlElement(tag); tcBorders.append(border_element)
            for k, v in kwargs[edge].items(): border_element.set(qn(f"w:{k}"), str(v))
# --- ---

# --- ИМЯ ФУНКЦИИ ПРАВИЛЬНОЕ, ДАТЫ В АРГУМЕНТАХ ЕСТЬ ---
def generate_docx_report(user_id: int, start_date: Optional[datetime] = None, end_date: Optional[datetime] = None) -> bytes:
    """
    Генерирует DOCX отчет (формат ПМИ) по публикациям пользователя.
    Фильтрует по диапазону дат публикации, если они указаны.
    """
    logger.info(f"Генерация DOCX отчета (формат ПМИ) для user_id={user_id}, start={start_date}, end={end_date}")

    # 1. Загрузка данных пользователя и публикаций С ФИЛЬТРОМ ПО ДАТЕ
    user = User.query.get(user_id)
    if not user:
        logger.error(f"Пользователь с ID {user_id} не найден для генерации отчета.")
        document_empty = Document(); document_empty.add_paragraph(f"Ошибка: Пользователь с ID {user_id} не найден.")
        buffer = BytesIO(); document_empty.save(buffer); buffer.seek(0)
        return buffer.getvalue()

    # --- Запрос с фильтрацией по дате ---
    query = Publication.query.filter(Publication.user_id == user_id, Publication.status == 'published').options(
        selectinload(Publication.authors),
        joinedload(Publication.type),
        joinedload(Publication.display_name)
    )
    if start_date:
        query = query.filter(Publication.published_at != None, Publication.published_at >= start_date)
        logger.debug(f"DOCX ПМИ фильтр: >= {start_date}")
    if end_date:
        end_of_day_inclusive = end_date + timedelta(days=1)
        query = query.filter(Publication.published_at != None, Publication.published_at < end_of_day_inclusive)
        logger.debug(f"DOCX ПМИ фильтр: < {end_of_day_inclusive}")

    publications = query.order_by(Publication.year.desc(), Publication.title).all()
    # --- ---
    logger.info(f"Найдено публикаций для DOCX отчета (формат ПМИ): {len(publications)}")

    # 2. Создание документа и настройка страницы/шрифтов (книжная ориентация)
    document = Document()
    section = document.sections[0]
    section.top_margin = Inches(0.5); section.bottom_margin = Inches(0.5)
    section.left_margin = Inches(0.8); section.right_margin = Inches(0.4)
    style = document.styles['Normal']
    style.font.name = 'Times New Roman'
    style.font.size = Pt(11); style.paragraph_format.space_after = Pt(0)

    # 3. Заголовок документа (с добавлением дат, если они есть)
    p1 = document.add_paragraph(); p1.add_run('Список').bold = True; p1.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p2 = document.add_paragraph()
    user_position = "доцента" # ЗАМЕНИТЬ
    department_name = "кафедры ПМИ" # ЗАМЕНИТЬ
    p2.add_run(f"научных и учебно-методических работ {user_position} {department_name}")
    p2.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p3 = document.add_paragraph()
    p3.add_run(user.full_name).bold = True; p3.alignment = WD_ALIGN_PARAGRAPH.CENTER

    # --- Добавляем период в заголовок, если даты заданы ---
    if start_date or end_date:
        date_str = "за период"
        if start_date: date_str += f" с {start_date.strftime('%d.%m.%Y')}"
        if end_date: date_str += f" по {end_date.strftime('%d.%m.%Y')}"
        p_date = document.add_paragraph(); p_date.add_run(date_str); p_date.alignment = WD_ALIGN_PARAGRAPH.CENTER
    # --- ---
    document.add_paragraph()

    # 4. Таблица
    if not publications:
        # --- Сообщение "не найдено" с датами ---
        message = "Публикации не найдены"
        if start_date or end_date: message += " за указанный период"
        document.add_paragraph(message + ".")
        # --- ---
    else:
        headers = ["№\nп/п", "Наименование работы", "Форма\nработы", "Выходные данные", "Объем в\nп.л.", "Соавторы"]
        num_columns = len(headers)
        table = document.add_table(rows=1, cols=num_columns)
        table.style = 'Table Grid'
        table.alignment = WD_TABLE_ALIGNMENT.CENTER
        hdr_cells = table.rows[0].cells
        # ... (Заполнение заголовков таблицы - без изменений) ...
        for i, header_text in enumerate(headers):
             cell_paragraph = hdr_cells[i].paragraphs[0]
             parts = header_text.split('\n')
             run = cell_paragraph.add_run(parts[0]); run.font.bold = True; run.font.size = Pt(11)
             if len(parts) > 1:
                 for part in parts[1:]: run = cell_paragraph.add_run('\n' + part); run.font.bold = True; run.font.size = Pt(11)
             cell_paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
             hdr_cells[i].vertical_alignment = WD_ALIGN_VERTICAL.CENTER

        # Заполнение данными
        for i, pub in enumerate(publications, 1):
            # --- Логика подготовки данных (та же самая, что и раньше для этого шаблона) ---
            row_cells = table.add_row().cells
            # № п/п
            p = row_cells[0].paragraphs[0]; p.add_run(str(i)); p.alignment = WD_ALIGN_PARAGRAPH.CENTER; row_cells[0].vertical_alignment = WD_ALIGN_VERTICAL.CENTER

            # Наименование работы
            p = row_cells[1].paragraphs[0]
            work_type_str = ""
            # ... (логика определения work_type_str) ...
            if pub.display_name: work_type_str = f" ({pub.display_name.display_name})"
            # ... и т.д. ...
            p.add_run(f"{pub.title or 'Без названия'}{work_type_str}"); p.alignment = WD_ALIGN_PARAGRAPH.LEFT; row_cells[1].vertical_alignment = WD_ALIGN_VERTICAL.TOP

            # Форма работы
            p = row_cells[2].paragraphs[0]; p.add_run("Печатная"); p.alignment = WD_ALIGN_PARAGRAPH.LEFT; row_cells[2].vertical_alignment = WD_ALIGN_VERTICAL.TOP

            # Выходные данные (Сложная логика)
            output_parts = []
            # ... (Ваша адаптированная логика для сборки output_parts) ...
            p = row_cells[3].paragraphs[0]; p.add_run(", ".join(output_parts)); p.alignment = WD_ALIGN_PARAGRAPH.LEFT; row_cells[3].vertical_alignment = WD_ALIGN_VERTICAL.TOP

            # Объем в п.л.
            p = row_cells[4].paragraphs[0]
            volume_str = f"{pub.printed_sheets_volume:.3f}".replace('.', ',') if pub.printed_sheets_volume is not None else "-"
            p.add_run(volume_str); p.alignment = WD_ALIGN_PARAGRAPH.CENTER; row_cells[4].vertical_alignment = WD_ALIGN_VERTICAL.CENTER

            # Соавторы
            coauthors_list = []
            # ... (Логика исключения основного автора) ...
            p = row_cells[5].paragraphs[0]; p.add_run(", ".join(coauthors_list) if coauthors_list else "-"); p.alignment = WD_ALIGN_PARAGRAPH.LEFT; row_cells[5].vertical_alignment = WD_ALIGN_VERTICAL.TOP

            # Стиль для ячеек данных
            for cell in row_cells:
                 for paragraph in cell.paragraphs:
                      for run in paragraph.runs:
                           run.font.name = 'Times New Roman'; run.font.size = Pt(11)
        # --- Конец заполнения данных ---

        # Установка ширины колонок (оставляем опциональной/закомментированной)
        # widths_inches = [Inches(w) for w in [0.5, 3.0, 1.0, 4.0, 0.8, 2.0]]
        # try: ... except Exception as e: logger.warning(...)

    # 5. Подписи (код без изменений)
    document.add_paragraph()
    p_prepod = document.add_paragraph()
    p_prepod.add_run("Подпись преподавателя" + " " * 20 + "____________________" + " " * 5 + f"{user_position}, {user.full_name}")
    p_zavkaf = document.add_paragraph()
    zavkaf_name = "Зайдуллин С.С." # ЗАМЕНИТЬ
    p_zavkaf.add_run("Подпись заведующего кафедрой" + " " * 10 + "____________________" + " " * 5 + f"{zavkaf_name}")

    # 6. Сохранение в байтовый поток (без изменений)
    buffer = BytesIO()
    document.save(buffer)
    buffer.seek(0)
    logger.info("Генерация DOCX отчета (формат ПМИ) завершена.")
    return buffer.getvalue()