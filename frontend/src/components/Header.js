import React from 'react';
import { AppBar, Toolbar, Typography, Button, Box } from '@mui/material';
import { Link, useNavigate } from 'react-router-dom';
import { styled } from '@mui/system';
import { useAuth } from '../contexts/AuthContext';
import logoPng from '../assets/logo_kai.png';

const StyledAppBar = styled(AppBar)({
	backgroundColor: 'white',
	boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)',
	transition: 'all 0.3s ease',
	'&:hover': {
		boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)',
	},
});

const Logo = styled('img')({
	height: '60px',
	marginLeft: '16px',
	transition: 'all 0.3s ease',
	'&:hover': {
		transform: 'scale(1.05)',
	},
});

function Header() {
	const { isAuthenticated, role, isLoading, logout } = useAuth();
	const navigate = useNavigate();

	// Используем role из localStorage как запасное значение, пока состояние не загрузится
	const storedUser = localStorage.getItem('user');
	const parsedUser = storedUser ? JSON.parse(storedUser) : null;
	const effectiveRole = role || parsedUser?.role || 'user';

	console.log('Header.js: isAuthenticated:', isAuthenticated, 'Role:', role, 'Effective Role:', effectiveRole, 'isLoading:', isLoading);

	const handleLogout = async () => {
		try {
			await logout();
			navigate('/login', { replace: true });
		} catch (err) {
			console.error('Header.js: Ошибка при выходе:', err);
		}
	};

	if (isLoading) {
		return null;
	}

	// Определяем маршрут и текст кнопки в зависимости от роли
	let dashboardPath = '/dashboard';
	let dashboardLabel = 'Личный кабинет';
	if (effectiveRole === 'admin') {
		dashboardPath = '/admin';
		dashboardLabel = 'Панель администратора';
	} else if (effectiveRole === 'manager') {
		dashboardPath = '/manager';
		dashboardLabel = 'Панель управляющего';
	}

	return (
		<StyledAppBar position="fixed">
			<Toolbar sx={{ justifyContent: 'space-between', alignItems: 'center' }}>
				<Box sx={{ display: 'flex', alignItems: 'center' }}>
					<Typography
						variant="h6"
						component={Link}
						to="/"
						sx={{
							color: '#115293',
							textDecoration: 'none',
							'&:hover': { textDecoration: 'underline' },
							mr: 2,
							transition: 'all 0.3s ease',
							fontWeight: '700',
							fontSize: '1.5rem',
						}}
					>
						Система Публикаций
					</Typography>
					<Logo src={logoPng} alt="КАИ Logo" />
				</Box>
				<Box sx={{ display: 'flex', gap: 2 }}>
					{!isAuthenticated ? (
						<Button
							component={Link}
							to="/login"
							variant="contained"
							color="primary"
							sx={{
								borderRadius: 16,
								transition: 'all 0.3s ease',
								'&:hover': { transform: 'scale(1.05)', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)' },
							}}
						>
							Войти
						</Button>
					) : (
						<>
							<Button
								component={Link}
								to={dashboardPath}
								variant="contained"
								color="primary"
								sx={{
									borderRadius: 16,
									transition: 'all 0.3s ease',
									'&:hover': { transform: 'scale(1.05)', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)' },
								}}
							>
								{dashboardLabel}
							</Button>
							<Button
								onClick={handleLogout}
								variant="contained"
								color="primary"
								sx={{
									borderRadius: 16,
									transition: 'all 0.3s ease',
									'&:hover': { transform: 'scale(1.05)', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)' },
								}}
							>
								Выйти
							</Button>
						</>
					)}
				</Box>
			</Toolbar>
		</StyledAppBar>
	);
}

export default Header;