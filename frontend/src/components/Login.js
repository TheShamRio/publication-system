import React, { useState } from 'react';
import { TextField, Button, Container, Typography, Box, Card, CardContent, Alert } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import axios from 'axios';

function Login() {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [isLoading, setIsLoading] = useState(false); // Состояние загрузки
    const navigate = useNavigate();
    const { login, updateAuthState, setCsrfToken } = useAuth();

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (isLoading) return; // Предотвращаем повторные отправки
        setIsLoading(true);
        setError('');

        try {
            const response = await axios.post('http://localhost:5000/api/login', {
                username,
                password,
            }, { withCredentials: true });

            if (response.data.message === 'Успешная авторизация') {
                const userData = {
                    id: response.data.user.id,
                    username: response.data.user.username,
                    role: response.data.user.role || 'user',
                    last_name: response.data.user.last_name || '',
                    first_name: response.data.user.first_name || '',
                    middle_name: response.data.user.middle_name || '',
                };
                localStorage.setItem('user', JSON.stringify(userData));
                login(userData); // Передаём полный объект userData
                updateAuthState({
                    isAuthenticated: true,
                    role: userData.role,
                    username: userData.username,
                    user: userData, // Сохраняем полный объект пользователя
                });
                console.log('User logged in, role:', userData.role);

                // Получаем CSRF-токен после логина
                try {
                    const tokenResponse = await axios.get('http://localhost:5000/api/csrf-token', {
                        withCredentials: true,
                    });
                    setCsrfToken(tokenResponse.data.csrf_token);
                    console.log('CSRF Token сохранён после логина:', tokenResponse.data.csrf_token);
                } catch (err) {
                    console.error('Ошибка получения CSRF-токена после логина:', err);
                }

                navigate(userData.role === 'admin' ? '/admin' : '/dashboard', { replace: true });
            }
        } catch (err) {
            if (err.response && err.response.data.error === 'Неверное имя пользователя или пароль') {
                setError('Неверные учетные данные. Проверьте имя пользователя и пароль.');
            } else {
                setError('Произошла ошибка при входе. Попробуйте позже.');
            }
            console.error('Login error:', err);
        } finally {
            setIsLoading(false); // Сбрасываем состояние загрузки
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
                            disabled={isLoading}
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
                            disabled={isLoading}
                        />
                        <Button
                            type="submit"
                            variant="contained"
                            fullWidth
                            sx={{ mt: 3, py: 1.5, borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
                            disabled={isLoading}
                        >
                            {isLoading ? 'Вход...' : 'Войти'}
                        </Button>
                    </form>
                </CardContent>
            </Card>
        </Container>
    );
}

export default Login;