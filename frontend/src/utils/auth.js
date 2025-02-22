import axios from 'axios';

const AUTH_API_BASE = 'http://localhost:5000/api';

export const getCsrfToken = async () => {
	try {
		const response = await axios.get(`${AUTH_API_BASE}/csrf-token`, { withCredentials: true });
		console.log('Получен CSRF-токен:', response.data.csrf_token); // Логирование для отладки
		return response.data.csrf_token;
	} catch (err) {
		console.error('Ошибка получения CSRF-токена:', err);
		throw new Error('Не удалось получить токен безопасности');
	}
};

export const makeAuthenticatedRequest = async (url, method = 'POST', data = {}, options = {}) => {
	try {
		const csrf_token = await getCsrfToken(); // Получаем CSRF-токен
		if (!csrf_token) {
			throw new Error('CSRF-токен не получен');
		}

		console.log('Отправка запроса:', {
			url: `${AUTH_API_BASE}${url}`,
			method,
			headers: { 'X-CSRFToken': csrf_token, ...options.headers },
		}); // Логирование для отладки

		// Если data — это FormData, добавляем csrf_token в данные формы
		if (data instanceof FormData) {
			data.append('csrf_token', csrf_token); // Добавляем токен в FormData
		}

		const response = await axios({
			url: `${AUTH_API_BASE}${url}`,
			method,
			data,
			withCredentials: true, // Убедитесь, что куки передаются
			headers: {
				'X-CSRFToken': csrf_token, // Добавляем CSRF-токен в заголовки
				...options.headers, // Дополнительные заголовки из опций
			},
			...options, // Дополнительные настройки (например, responseType)
		});

		return response;
	} catch (err) {
		console.error('Ошибка в makeAuthenticatedRequest:', err.response?.data || err);
		throw err; // Перебрасываем ошибку для обработки в компоненте
	}
};