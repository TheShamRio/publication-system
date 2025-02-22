import React, { useState } from 'react';
import { TextField, Button, Container, Typography, Box, Card, CardContent, Alert } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext'; // Импортируем useAuth
import { makeAuthenticatedRequest } from '../utils/auth'; // Импортируем новую утилиту

function Login() {
	const [username, setUsername] = useState('');
	const [password, setPassword] = useState('');
	const [error, setError] = useState('');
	const navigate = useNavigate();
	const { login, updateAuthState } = useAuth(); // Используем updateAuthState

	const handleSubmit = async (e) => {
		e.preventDefault();
		try {
			const response = await makeAuthenticatedRequest('/login', 'POST', {
				username,
				password,
			});

			if (response.data.message === 'Вход выполнен') {
				const userData = {
					username,
					role: response.data.role || 'user',
				};
				localStorage.setItem('user', JSON.stringify(userData));
				login(userData); // Обновляем состояние авторизации
				updateAuthState({ isAuthenticated: true, role: userData.role, username }); // Синхронизируем состояние
				console.log('User logged in, role:', userData.role);
				// Перенаправляем на соответствующий маршрут в зависимости от роли
				navigate(userData.role === 'admin' ? '/admin' : '/dashboard');
			}
		} catch (err) {
			if (err.response && err.response.data.error === 'Неверные учетные данные') {
				setError('Неверные учетные данные. Проверьте имя пользователя и пароль.');
			} else {
				setError('Произошла ошибка при входе. Попробуйте позже.');
			}
			console.error('Login error:', err);
		}
	};

	return (
		<Container maxWidth="sm" sx={{ mt: 8 }}>
			<Card elevation={4} sx={{ p: 4, borderRadius: 16, backgroundColor: 'white', boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)' }}>
				<CardContent>
					<Typography variant="h4" gutterBottom align="center" sx={{ mb: 3, color: '#1976D2' }}>
						Вход в Систему Публикаций
					</Typography>
					{error && (
						<Alert severity="error" sx={{ mb: 2, borderRadius: 8 }} onClose={() => setError('')}>
							{error}
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
						/>
						<TextField
							fullWidth
							label="Пароль"
							type="password"
							value={password}
							onChange={(e) => setPassword(e.target.value)}
							margin="normal"
							variant="outlined"
							sx={{ borderRadius: 8 }}
							autoComplete="current-password"
						/>
						<Button
							type="submit"
							variant="contained"
							fullWidth
							sx={{ mt: 3, py: 1.5, borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
						>
							Войти
						</Button>
					</form>
				</CardContent>
			</Card>
		</Container>
	);
}

export default Login;