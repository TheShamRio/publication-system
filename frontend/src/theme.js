import { createTheme } from '@mui/material/styles';

const theme = createTheme({
	palette: {
		primary: {
			main: '#0071e3', // Темно-синий Apple
		},
		secondary: {
			main: '#333333', // Темно-серый текст
		},
		background: {
			default: '#ffffff', // Белый фон, как у Apple
			paper: '#f5f5f5', // Светло-серый для карточек/контейнеров
		},
		text: {
			primary: '#000000', // Черный текст
			secondary: '#666666', // Серый для второстепенного текста
		},
		mode: 'light', // Светлая тема, как на сайте Apple
	},
	typography: {
		fontFamily: '"Roboto", "San Francisco", "Helvetica", "Arial", sans-serif', // Похожий на шрифт Apple
		h4: {
			fontWeight: 600,
			color: '#000000',
		},
		body1: {
			color: '#666666',
		},
	},
	components: {
		MuiButton: {
			styleOverrides: {
				root: {
					borderRadius: 16, // Более скругленные углы, как у Apple
					textTransform: 'none', // Без верхнего регистра
					boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)', // Легкая тень
					'&:hover': {
						boxShadow: '0 4px 12px rgba(0, 0, 0, 0.2)', // Усиленная тень при наведении
						backgroundColor: '#0066cc', // Темнее при наведении
					},
				},
			},
		},
		MuiAppBar: {
			styleOverrides: {
				root: {
					backgroundColor: '#ffffff', // Белая шапка
					boxShadow: '0 1px 4px rgba(0, 0, 0, 0.1)',
				},
			},
		},
		MuiToolbar: {
			styleOverrides: {
				root: {
					minHeight: 64, // Высота хедера, как у Apple
				},
			},
		},
	},
});

export default theme;