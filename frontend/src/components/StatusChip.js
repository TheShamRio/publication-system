import React from 'react';
import { Chip } from '@mui/material';

const StatusChip = ({ status }) => {
	let label = status; // Значение по умолчанию
	let backgroundColor = '#D1D1D6'; // Серый по умолчанию
	let textColor = '#1D1D1F'; // Черный текст по умолчанию

	// Определяем метки и цвета для статусов
	switch (status) {
		case 'draft':
		case 'planned':
			label = 'Черновик';
			backgroundColor = '#6E6E73';
			textColor = '#FFFFFF';
			break;
		case 'needs_review':
		case 'in_progress':
			label = 'На проверке';
			backgroundColor = '#FF9500';
			textColor = '#FFFFFF';
			break;
		case 'returned':
			label = 'Требуется доработка';
			backgroundColor = '#FF3B30';
			textColor = '#FFFFFF';
			break;
		case 'published':
		case 'completed':
		case 'approved':
			label = 'Успешно';
			backgroundColor = '#2EBB4A';
			textColor = '#FFFFFF';
			break;
		default:
			label = status; // Если статус неизвестен, оставляем как есть
			backgroundColor = '#D1D1D6';
			textColor = '#1D1D1F';
	}

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
				// Унифицированный стиль для всех чипов
				transition: 'all 0.3s ease',
				'&:hover': {
					filter: 'brightness(1.1)',
				},
			}}
		/>
	);
};

export default StatusChip;