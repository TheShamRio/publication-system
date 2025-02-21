import React, { useState } from 'react';
import { TextField, Button, Container, Typography, Box, Card, CardContent, Alert } from '@mui/material';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

function Register() {
	const [username, setUsername] = useState('');
	const [password, setPassword] = useState('');
	const [lastName, setLastName] = useState('');
	const [firstName, setFirstName] = useState('');
	const [middleName, setMiddleName] = useState('');
	const [error, setError] = useState('');
	const [success, setSuccess] = useState('');
	const navigate = useNavigate();

	const handleSubmit = async (e) => {
		e.preventDefault();
		try {
			const response = await axios.post('http://localhost:5000/api/register', {
				username,
				password,
				last_name: lastName,
				first_name: firstName,
				middle_name: middleName,
			});
			if (response.data.message === 'Пользователь зарегистрирован') {
				setSuccess('Регистрация успешна! Теперь вы можете войти.');
				setError('');
				setTimeout(() => navigate('/login'), 2000);
			}
		} catch (err) {
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