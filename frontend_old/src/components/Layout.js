import React from 'react';
import { Outlet, useNavigate } from 'react-router-dom';
import { Box, CssBaseline } from '@mui/material';
import Header from './Header';
import Footer from './Footer';
import axios from 'axios';
import { useAuth } from '../contexts/AuthContext';

function Layout() {
	const navigate = useNavigate();
	const { isAuthenticated, isLoading, logout, csrfToken, setCsrfToken } = useAuth();

	console.log('Layout.js: Рендеринг, isAuthenticated:', isAuthenticated, 'isLoading:', isLoading);

	const handleLogout = async () => {
		try {
			let token = csrfToken;
			if (!token) {
				const tokenResponse = await axios.get('http://localhost:5000/api/csrf-token', {
					withCredentials: true,
				});
				token = tokenResponse.data.csrf_token;
				setCsrfToken(token);
				console.log('Layout.js: CSRF Token получен перед выходом:', token);
			}

			await axios.post('http://localhost:5000/api/logout', {}, {
				withCredentials: true,
				headers: {
					'X-CSRFToken': token,
				},
			});

			console.log('Layout.js: Успешный выход, вызываем logout...');
			logout();
			navigate('/login', { replace: true });
		} catch (err) {
			console.error('Layout.js: Ошибка выхода:', err);
			logout();
			navigate('/login', { replace: true });
		}
	};

	if (isLoading) {
		console.log('Layout.js: Ожидание проверки аутентификации...');
		return <div>Загрузка...</div>;
	}

	return (
		<Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
			<CssBaseline />
			<Header /> {/* Убираем передачу isAuthenticated и onLogout */}
			<Box component="main" sx={{ flexGrow: 1, p: 3, mt: '64px' }}>
				<Outlet />
			</Box>
			<Footer />
		</Box>
	);
}

export default Layout;