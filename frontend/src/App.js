import React, { useState } from 'react';
import { Container, Typography } from '@mui/material';
import { useNavigate } from 'react-router-dom';


function App() {
	const [isAuthenticated, setIsAuthenticated] = useState(!!localStorage.getItem('user'));
	const navigate = useNavigate();

	const handleLogout = () => {
		localStorage.removeItem('user');
		setIsAuthenticated(false);
		navigate('/');
	};

	return (
		<div>
			<Container maxWidth="lg" sx={{ mt: 8, textAlign: 'center', minHeight: 'calc(100vh - 200px)' }}>
				<Typography variant="h2" gutterBottom sx={{ color: 'text.primary', fontWeight: 600 }}>
					Добро пожаловать в Систему Публикаций
				</Typography>
				<Typography variant="body1" sx={{ color: 'text.secondary', mb: 4 }}>
					Эффективно управляйте научными публикациями и отслеживайте академическую активность.
				</Typography>
			</Container>
		</div>
	);
}

export default App;