import React, { useState } from 'react';
import { BrowserRouter as Router, Route, Routes, Navigate } from 'react-router-dom';
import { Container, Typography, Button } from '@mui/material';
import Home from './components/Home'; // Импортируем обновленный Home
import Login from './components/Login'; // Предполагаем, что есть компонент Login
import Dashboard from './components/Dashboard'; // Предполагаем, что есть компонент Dashboard
import Publication from './components/Publication'; // Компонент для страницы публикации

function App() {
	const [isAuthenticated, setIsAuthenticated] = useState(!!localStorage.getItem('user'));

	const handleLogout = () => {
		localStorage.removeItem('user');
		setIsAuthenticated(false);
	};

	return (
			<Routes>
				<Route path="/" element={<Home />} />
				<Route path="/login" element={<Login />} />
				<Route
					path="/dashboard"
					element={isAuthenticated ? <Dashboard /> : <Navigate to="/login" />}
				/>
				<Route
					path="/publication/:id"
					element={isAuthenticated ? <Publication /> : <Navigate to="/login" />}
				/>
			</Routes>
	);
}

export default App;