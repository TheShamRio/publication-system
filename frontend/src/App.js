import React from 'react';
import { Route, Routes, Navigate } from 'react-router-dom';
import Home from './components/Home';
import Login from './components/Login';
import Dashboard from './components/Dashboard';
import Publication from './components/Publication';
import Register from './components/Register';
import Layout from './components/Layout';
import AdminDashboard from './components/AdminDashboard'; // Новый компонент
import { useAuth } from './contexts/AuthContext'; // Импортируем useAuth

function App() {
	const { isAuthenticated, role } = useAuth(); // Получаем role из контекста

	return (
		<Routes>
			<Route path="/" element={<Layout />}>
				{/* Публичные маршруты — доступны всем */}
				<Route index element={<Home />} />
				<Route path="/login" element={<Login />} />
				<Route path="/register" element={<Register />} />

				{/* Защищённые маршруты — только для авторизованных пользователей */}
				<Route
					path="/dashboard"
					element={isAuthenticated && role === 'user' ? <Dashboard /> : <Navigate to="/login" />}
				/>
				<Route
					path="/publication/:id"
					element={isAuthenticated ? <Publication /> : <Navigate to="/login" />}
				/>
				<Route
					path="/admin"
					element={isAuthenticated && role === 'admin' ? <AdminDashboard /> : <Navigate to="/login" />}
				/>
			</Route>
		</Routes>
	);
}

export default App;