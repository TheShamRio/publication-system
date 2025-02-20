import React from 'react';
import { Outlet } from 'react-router-dom';
import Header from './Header';
import Footer from './Footer';
import { Box } from '@mui/material';
import { useAuth } from '../contexts/AuthContext';

function Layout() {
	const { isAuthenticated, setIsAuthenticated } = useAuth();

	const handleLogout = () => {
		localStorage.removeItem('user');
		setIsAuthenticated(false);
		window.location.href = '/'; // Перенаправляем на главную без полной перезагрузки
	};

	return (
		<Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
			<Header isAuthenticated={isAuthenticated} onLogout={handleLogout} />
			<Box sx={{ flex: 1 }}>
				<Outlet />
			</Box>
			<Footer />
		</Box>
	);
}

export default Layout;