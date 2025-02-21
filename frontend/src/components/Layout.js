import React, { useState, useEffect } from 'react';
import { Outlet, useNavigate } from 'react-router-dom';
import { Box, CssBaseline } from '@mui/material';
import Header from './Header';
import Footer from './Footer';
import axios from 'axios';

function Layout() {
	const [isAuthenticated, setIsAuthenticated] = useState(false);
	const navigate = useNavigate();

	useEffect(() => {
		const checkAuth = async () => {
			try {
				await axios.get('http://localhost:5000/api/user', {
					withCredentials: true,
				});
				setIsAuthenticated(true);
			} catch (err) {
				setIsAuthenticated(false);
			}
		};
		checkAuth();
	}, []);

	const handleLogout = () => {
		axios
			.get('http://localhost:5000/api/logout', { withCredentials: true })
			.then(() => {
				setIsAuthenticated(false);
				localStorage.removeItem('user');
				navigate('/login');
			})
			.catch((err) => console.error('Ошибка выхода:', err));
	};

	return (
		<Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
			<CssBaseline />
			<Header isAuthenticated={isAuthenticated} onLogout={handleLogout} />
			<Box
				component="main"
				sx={{
					flexGrow: 1,
					p: 3,
					mt: '64px', // Отступ под хедер
				}}
			>
				<Outlet />
			</Box>
			<Footer />
		</Box>
	);
}

export default Layout;