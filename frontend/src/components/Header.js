import React from 'react';
import { AppBar, Toolbar, Typography, Button, Box } from '@mui/material';
import { Link, useNavigate } from 'react-router-dom';
import { styled } from '@mui/system';
import logoPng from './assets/logo_kai.png'; // Используем PNG логотип

const StyledAppBar = styled(AppBar)({
	backgroundColor: 'white',
	boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)',
	transition: 'all 0.3s ease',
	'&:hover': {
		boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)',
	},
});

const Logo = styled('img')({
	height: '40px',
	marginLeft: '16px',
	transition: 'all 0.3s ease',
	'&:hover': {
		transform: 'scale(1.05)',
	},
	// Адаптируем синий фон для белого хедера (опционально)
	backgroundColor: 'transparent', // Убираем синий фон
	// Фильтр для инверсии цвета (если нужно):
	// filter: 'invert(100%) sepia(0%) saturate(0%) hue-rotate(0deg) brightness(100%) contrast(100%)',
});

function Header({ isAuthenticated, onLogout }) {
	const navigate = useNavigate();

	return (
		<StyledAppBar position="fixed">
			<Toolbar sx={{ justifyContent: 'space-between', alignItems: 'center' }}>
				<Box sx={{ display: 'flex', alignItems: 'center' }}>
					<Typography
						variant="h6"
						component={Link}
						to="/"
						sx={{
							color: 'primary.main',
							textDecoration: 'none',
							'&:hover': { textDecoration: 'underline' },
							mr: 2,
							transition: 'all 0.3s ease',
						}}
					>
						Система Публикаций
					</Typography>
					<Logo src={logoPng} alt="КАИ Logo" />
				</Box>
				{isAuthenticated ? (
					<Button
						onClick={onLogout}
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
				) : (
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
				)}
			</Toolbar>
		</StyledAppBar>
	);
}

export default Header;