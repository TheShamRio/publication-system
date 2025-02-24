import React, { useState, useEffect } from 'react';
import { TextField, Button, Container, Typography, Box, Card, CardContent, Alert } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import axios from 'axios';

function Register() {
	const [username, setUsername] = useState('');
	const [password, setPassword] = useState('');
	const [lastName, setLastName] = useState('');
	const [firstName, setFirstName] = useState('');
	const [middleName, setMiddleName] = useState('');
	const [error, setError] = useState('');
	const [success, setSuccess] = useState('');
	const navigate = useNavigate();
	const { login, setCsrfToken } = useAuth(); // Добавляем setCsrfToken

	useEffect(() => {
		// Получаем CSRF-токен один раз при монтировании компонента
		let mounted = true; // Флаг для предотвращения обновлений после размонтирования

		const fetchCsrfToken = async () => {
			try {
				console.log('Fetching CSRF token from /api/csrf-token');
				const response = await axios.get('http://localhost:5000/api/csrf-token', { withCredentials: true });
				if (mounted) { // Проверяем, что компонент всё ещё смонтирован
					setCsrfToken(response.data.csrf_token);
					console.log('CSRF token received:', response.data.csrf_token);
				}
			} catch (err) {
				console.error('Ошибка получения CSRF-токена:', err);
				if (mounted) {
					setError('Не удалось получить CSRF-токен. Попробуйте позже.');
				}
			}
		};

		fetchCsrfToken();

		// Очистка при размонтировании
		return () => {
			mounted = false;
		};
	}, []); // Пустой массив зависимостей — запрос выполняется только один раз при монтировании

	const handleSubmit = async (e) => {
		e.preventDefault();
		// Проверка на пустые поля
		if (!username.trim() || !password.trim() || !lastName.trim() || !firstName.trim() || !middleName.trim()) {
			setError('Все поля обязательны для заполнения.');
			return;
		}

		try {
			console.log('Sending registration request with data:', {
				username,
				password,
				last_name: lastName,
				first_name: firstName,
				middle_name: middleName,
			});
			const response = await axios.post('http://localhost:5000/api/register', {
				username,
				password,
				last_name: lastName,
				first_name: firstName,
				middle_name: middleName,
			}, {
				withCredentials: true,
				headers: {
					'Content-Type': 'application/json',
					'X-CSRFToken': localStorage.getItem('csrfToken') || '', // Отправляем CSRF-токен
				}
			});

			if (response.data.message === 'Пользователь зарегистрирован') {
				setSuccess('Регистрация успешна! Теперь вы можете войти.');
				setError('');
				setTimeout(() => navigate('/login'), 2000);
				login({ username, role: response.data.user.role });
			}
		} catch (err) {
			console.error('Registration error:', err.response?.data || err.message, err.response?.status);
			setError(err.response?.data?.error || 'Произошла ошибка при регистрации. Попробуйте позже.');
			setSuccess('');
		}
	};

	return (
		<Container maxWidth="sm" sx={{ mt: 8 }}>
			<Card elevation={4} sx={{ p: 4, borderRadius: 16, backgroundColor: 'white', boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)' }}>
				<CardContent>
					<Typography variant="h4" gutterBottom align="center" sx={{ mb: 3, color: '#1976D2' }}>
						Регистрация в Системе Публикаций
					</Typography>
					{error && (
						<Alert severity="error" sx={{ mb: 2, borderRadius: 8 }} onClose={() => setError('')}>
							{error}
						</Alert>
					)}
					{success && (
						<Alert severity="success" sx={{ mb: 2, borderRadius: 8 }} onClose={() => setSuccess('')}>
							{success}
						</Alert>
					)}
					<form onSubmit={handleSubmit}>
						<TextField
							fullWidth
							label="Логин"
							value={username}
							onChange={(e) => setUsername(e.target.value)}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
							autoComplete="username"
							required
						/>
						<TextField
							fullWidth
							label="Пароль"
							type="password"
							value={password}
							onChange={(e) => setPassword(e.target.value)}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
							autoComplete="new-password"
							required
						/>
						<TextField
							fullWidth
							label="Фамилия"
							value={lastName}
							onChange={(e) => setLastName(e.target.value)}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
							autoComplete="family-name"
							required
						/>
						<TextField
							fullWidth
							label="Имя"
							value={firstName}
							onChange={(e) => setFirstName(e.target.value)}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
							autoComplete="given-name"
							required
						/>
						<TextField
							fullWidth
							label="Отчество"
							value={middleName}
							onChange={(e) => setMiddleName(e.target.value)}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
							autoComplete="additional-name"
							required
						/>
						<Button
							type="submit"
							variant="contained"
							fullWidth
							sx={{ mt: 3, py: 1.5, borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
						>
							Зарегистрироваться
						</Button>
					</form>
				</CardContent>
			</Card>
		</Container>
	);
}

export default Register;