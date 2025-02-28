import React, { useState } from 'react';
import { Box, Button } from '@mui/material';

function DocxViewer({ fileUrl }) {
	const [pdfUrl, setPdfUrl] = useState(null);
	const [error, setError] = useState(null);

	const convertToPDF = async () => {
		try {
			setError(null); // Сбрасываем предыдущую ошибку
			// Загружаем DOCX-файл
			const response = await fetch(fileUrl);
			if (!response.ok) {
				throw new Error(`Failed to fetch DOCX file: ${response.statusText}`);
			}
			const blob = await response.blob();

			// Создаем FormData для отправки файла
			const formData = new FormData();
			formData.append('file', blob, fileUrl.split('/').pop());

			// Отправляем файл на сервер для конвертации
			const convertResponse = await fetch('http://localhost:5000/convert', {
				method: 'POST',
				body: formData,
			});

			if (!convertResponse.ok) {
				const errorData = await convertResponse.json();
				throw new Error(`Failed to convert DOCX to PDF: ${errorData.error || convertResponse.statusText}`);
			}

			// Получаем PDF как blob
			const pdfBlob = await convertResponse.blob();
			const pdfUrl = URL.createObjectURL(pdfBlob);
			setPdfUrl(pdfUrl);

			// Открываем PDF в новом окне
			window.open(pdfUrl, '_blank');
		} catch (err) {
			console.error('Ошибка конвертации DOCX в PDF:', err);
			setError(err.message);
		}
	};

	return (
		<Box>
			<Button variant="contained" color="primary" onClick={convertToPDF}>
				Convert to PDF
			</Button>
			{pdfUrl && (
				<Box mt={2}>
					<a href={pdfUrl} download="converted.pdf">
						Download PDF
					</a>
				</Box>
			)}
			{error && (
				<Box mt={2} color="red">
					{error}
				</Box>
			)}
		</Box>
	);
}

export default DocxViewer;