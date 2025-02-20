import React from 'react';
import { AppBar, Toolbar, Typography, Button, Container, Box } from '@mui/material';
import { Link } from 'react-router-dom';
import LoginIcon from '@mui/icons-material/Login';
import LogoutIcon from '@mui/icons-material/Logout';
import PersonIcon from '@mui/icons-material/Person';

function Header({ isAuthenticated, onLogout }) {
	return (
		<AppBar position="sticky">
			<Toolbar>
				<Typography
					variant="h4"
					component="div"
					sx={{ flexGrow: 1, color: 'primary.main', cursor: 'pointer', '&:hover': { textDecoration: 'underline' } }}
					onClick={() => window.location.href = '/'} // Кликабельное название для возврата на главную
				>
					Система Публикаций
				</Typography>
				<Container maxWidth="xs" sx={{ display: 'flex', justifyContent: 'flex-end', gap: 2 }}>
					{isAuthenticated ? (
						<>
							<Box sx={{ transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}>
								<Button
									variant="contained"
									color="primary"
									component={Link}
									to="/dashboard"
									startIcon={<PersonIcon />}
									sx={{ borderRadius: 16, px: 3, py: 1.5 }}
								>
									Личный кабинет
								</Button>
							</Box>
							<Box sx={{ transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}>
								<Button
									variant="contained"
									color="secondary"
									onClick={onLogout}
									startIcon={<LogoutIcon />}
									sx={{ borderRadius: 16, px: 3, py: 1.5 }}
								>
									Выйти
								</Button>
							</Box>
						</>
					) : (
						<>
							<Box sx={{ transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}>
								<Button
									variant="contained"
									color="primary"
									component={Link}
									to="/login"
									startIcon={<LoginIcon />}
									sx={{ borderRadius: 16, px: 3, py: 1.5 }}
								>
									Войти
								</Button>
							</Box>
							<Box sx={{ transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}>
								<Button
									variant="outlined"
									color="primary"
									component={Link}
									to="/register"
									sx={{ borderRadius: 16, px: 3, py: 1.5, borderWidth: 2 }}
								>
									Зарегистрироваться
								</Button>
							</Box>
						</>
					)}
				</Container>
			</Toolbar>
		</AppBar>
	);
}

export default Header;