// Файл: D:\publication-system\frontend\src\components\StatusChip.js
import React from 'react';
import { Chip } from '@mui/material';

const StatusChip = ({ status, role }) => {
	// Шаг 1: Добавляем отладочный вывод для проверки пропсов
	console.log('StatusChip: status=', status, 'role=', role);

	let label = status; // Значение по умолчанию
	let backgroundColor = '#D1D1D6'; // Серый по умолчанию
	let textColor = '#1D1D1F'; // Черный текст по умолчанию

	// Шаг 2: Логика для статусов
	switch (status) {
		case 'draft':
		case 'planned':
			label = 'Черновик';
			backgroundColor = '#6E6E73';
			textColor = '#FFFFFF';
			break;
		case 'needs_review':
		case 'in_progress':
			if (role === 'manager') {
				label = 'Требуется проверка'; // Текст для менеджера
				backgroundColor = '#FF3B30'; // Оранжевый фон
				textColor = '#FFFFFF'; // Белый текст
			} else {
				label = 'На проверке'; // Для user или undefined
				backgroundColor = '#FF9500'; // Красный фон
				textColor = '#FFFFFF'; // Белый текст
			}
			break;
		case 'returned_for_revision':
		case 'returned': // Добавляем обработку статуса "returned" для планов
			if (role === 'manager') {
				label = 'Отправлено на доработку'; // Текст для менеджера
				backgroundColor = '#FF9500'; // Оранжевый фон
				textColor = '#FFFFFF'; // Белый текст
			} else {
				label = 'Требуется доработка'; // Для user или undefined
				backgroundColor = '#FF3B30'; // Красный фон
				textColor = '#FFFFFF'; // Белый текст
			}
			break;
		case 'published':
		case 'completed':
		case 'approved':
			label = 'Успешно';
			backgroundColor = '#2EBB4A';
			textColor = '#FFFFFF';
			break;
		default:
			label = status;
			backgroundColor = '#D1D1D6';
			textColor = '#1D1D1F';
	}

	// Шаг 3: Рендеринг компонента
	return (
		<Chip
			label={label}
			sx={{
				backgroundColor: backgroundColor,
				color: textColor,
				fontSize: '0.75rem',
				fontWeight: 600,
				borderRadius: '12px',
				padding: '2px 8px',
				height: '24px',
				'& .MuiChip-label': {
					padding: '0 4px',
				},
				transition: 'all 0.3s ease',
				'&:hover': {
					filter: 'brightness(1.1)',
				},
			}}
		/>
	);
};

export default StatusChip;