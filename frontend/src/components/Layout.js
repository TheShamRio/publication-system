import React, { useEffect, useState, useCallback, useMemo } from 'react';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import { Box, CssBaseline } from '@mui/material';
import Header from './Header';
import Footer from './Footer';
import axios from 'axios';
import { useAuth } from '../contexts/AuthContext';

function Layout() {
	const [isAuthenticated, setIsAuthenticated] = useState(!!localStorage.getItem('user'));
	const [csrfToken, setCsrfToken] = useState(null);
	const navigate = useNavigate();
	const location = useLocation();
	const { logout, updateAuthState } = useAuth();

	const authState = useMemo(() => ({
		isAuthenticated,
		setIsAuthenticated,
	}), [isAuthenticated]);

	const checkAuth = useCallback(async () => {
		const storedUser = localStorage.getItem('user');
		if (storedUser) {
			const userData = JSON.parse(storedUser);
			if (!isAuthenticated) {
				setIsAuthenticated(true);
				updateAuthState({
					isAuthenticated: true,
					role: userData.role || 'user',
					username: userData.username,
				});
			}
			try {
				const tokenResponse = await axios.get('http://localhost:5000/api/csrf-token', {
					withCredentials: true,
				});
				setCsrfToken(tokenResponse.data.csrf_token);
				console.log('CSRF Token сохранён:', tokenResponse.data.csrf_token);
			} catch (err) {
				console.error('Ошибка получения CSRF-токена:', err);
			}
			return;
		}

		if (!location.pathname.startsWith('/dashboard') && !location.pathname.startsWith('/publication') && !location.pathname.startsWith('/admin')) {
			return;
		}

		try {
			console.log('Checking authentication...');
			const response = await axios.get('http://localhost:5000/api/user', {
				withCredentials: true,
			});
			console.log('Auth response:', response.data);
			const userData = response.data;
			if (!isAuthenticated) {
				setIsAuthenticated(true);
				updateAuthState({
					isAuthenticated: true,
					role: userData.role || 'user',
					username: userData.username,
				});
			}
			localStorage.setItem('user', JSON.stringify({ username: userData.username, role: userData.role }));
			const tokenResponse = await axios.get('http://localhost:5000/api/csrf-token', {
				withCredentials: true,
			});
			setCsrfToken(tokenResponse.data.csrf_token);
			console.log('CSRF Token сохранён:', tokenResponse.data.csrf_token);
		} catch (err) {
			console.error('Auth error:', err.response?.status, err.response?.data?.error || err.message);
			if (isAuthenticated) {
				setIsAuthenticated(false);
				updateAuthState({
					isAuthenticated: false,
					role: 'user',
					username: '',
				});
			}
			localStorage.removeItem('user');
			setCsrfToken(null);
			if (location.pathname.startsWith('/dashboard') || location.pathname.startsWith('/publication') || location.pathname.startsWith('/admin')) {
				navigate('/login');
			}
		}
	}, [navigate, updateAuthState, location.pathname, isAuthenticated]);

	useEffect(() => {
		let mounted = true;

		const performCheckAuth = async () => {
			await checkAuth();
		};

		performCheckAuth();

		return () => {
			mounted = false;
		};
	}, [checkAuth]);

	const handleLogout = async () => {
		try {
			if (!csrfToken) {
				const tokenResponse = await axios.get('http://localhost:5000/api/csrf-token', {
					withCredentials: true,
				});
				setCsrfToken(tokenResponse.data.csrf_token);
				console.log('CSRF Token получен перед выходом:', tokenResponse.data.csrf_token);
			}

			await axios.post('http://localhost:5000/api/logout', {}, {
				withCredentials: true,
				headers: {
					'X-CSRFToken': csrfToken,
				},
			});

			setIsAuthenticated(false);
			setCsrfToken(null);
			logout();
			localStorage.removeItem('user');
			navigate('/login');
		} catch (err) {
			console.error('Ошибка выхода:', err);
			if (err.response?.status === 401 || err.response?.status === 400) {
				console.error('Сессия истекла или CSRF-токен недействителен. Очищаем состояние клиента.');
				setIsAuthenticated(false);
				setCsrfToken(null);
				logout();
				localStorage.removeItem('user');
				navigate('/login');
			}
		}
	};

	return (
		<Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
			<CssBaseline />
			<Header isAuthenticated={authState.isAuthenticated} onLogout={handleLogout} />
			<Box
				component="main"
				sx={{
					flexGrow: 1,
					p: 3,
					mt: '64px',
				}}
			>
				<Outlet />
			</Box>
			<Footer />
		</Box>
	);
}

export default Layout;