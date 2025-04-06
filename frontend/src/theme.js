import { createTheme } from '@mui/material/styles';
import { styled } from '@mui/system';
import Select from '@mui/material/Select';

// Кастомный AppleSelect с объединёнными стилями
export const AppleSelect = styled(Select)(({ theme }) => ({
	// Стили для метки (InputLabel)
	'& .MuiInputLabel-root.MuiInputLabel-root': {
		color: '#6E6E73 !important',
		fontSize: '16px !important',
		transform: 'translate(14px, 12px) scale(1) !important', // Положение метки в неактивном состоянии
		'&.MuiInputLabel-shrink': {
			transform: 'translate(14px, -12px) scale(0.75) !important', // Положение метки при фокусе
			color: '#0071E3 !important', // Цвет метки при фокусе
		},
	},
	// Стили для самого поля Select
	'& .MuiSelect-select': {
		padding: '10px 14px',
		color: '#1D1D1F',
		fontSize: '14px',
		fontWeight: 400,
		display: 'flex',
		alignItems: 'center',
		height: '40px !important',
		boxSizing: 'border-box',
	},
	// Стили для обводки и фона поля
	'& .MuiOutlinedInput-root': {
		borderRadius: '12px',
		backgroundColor: '#F5F5F7',
		'& fieldset': {
			borderColor: '#D1D1D6', // Цвет обводки в неактивном состоянии
		},
		'&:hover fieldset': {
			borderColor: '#0071E3', // Цвет обводки при наведении
		},
		'&.Mui-focused fieldset': {
			borderColor: '#0071E3', // Цвет обводки при фокусе
		},
	},
	// Стили для элементов выпадающего списка (MenuItem)
	'& .MuiMenuItem-root': {
		borderRadius: '8px',
		margin: '4px 8px',
		'&:hover': {
			backgroundColor: '#E5E5EA', // Цвет фона при наведении
		},
		'&.Mui-selected': {
			backgroundColor: '#D1D1D6', // Цвет фона для выбранного элемента
			'&:hover': {
				backgroundColor: '#C7C7CC', // Цвет фона при наведении на выбранный элемент
			},
		},
	},
}));

// Основная тема
const theme = createTheme({
	palette: {
		primary: {
			main: '#0071e3', // Темно-синий Apple
		},
		secondary: {
			main: '#333333', // Темно-серый текст
		},
		background: {
			default: '#ffffff', // Белый фон
			paper: '#f5f5f5', // Светло-серый для карточек
		},
		text: {
			primary: '#000000', // Черный текст
			secondary: '#666666', // Серый для второстепенного текста
		},
		mode: 'light',
	},
	typography: {
		
		h4: {
			
			color: '#000000',
		},
		body1: {
			color: '#666666',
		},
	},
	components: {
		// Переопределяем стили для MuiInputLabel (глобально)
		MuiInputLabel: {
			styleOverrides: {
				root: {
					transform: 'translate(14px, 10px) scale(1)',
					color: '#6E6E73',
					fontSize: '16px',
					'&.MuiInputLabel-shrink': {
						transform: 'translate(14px, -16px) scale(0.75)',
						color: '#0071e3',
					},
				},
			},
		},
		// Переопределяем стили для MuiSelect (глобально)
		MuiSelect: {
			styleOverrides: {
				select: {
					padding: '10px 14px',
					height: '40px',
					boxSizing: 'border-box',
					display: 'flex',
					alignItems: 'center',
				},
			},
		},
		// Переопределяем стили для MuiChip (для крестиков в AppleSelect)
		MuiChip: {
			styleOverrides: {
				root: {
					borderRadius: '8px',
					backgroundColor: '#D1D1D6', // Цвет фона чипа
					color: '#1D1D1F', // Цвет текста
					height: '24px', // Высота чипа
					fontSize: '12px', // Размер шрифта
				},
				deleteIcon: {
					color: '#6E6E73',
					transition: 'color 0.2s ease',
					pointerEvents: 'auto', // Убедимся, что крестик принимает события
					'&:hover': {
						color: '#FF3B30',
					},
				},
			},
		},
	},
});

export default theme;