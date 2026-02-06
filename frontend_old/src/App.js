import React from 'react';
import { Route, Routes, Navigate } from 'react-router-dom';
import Home from './components/Home';
import Login from './components/Login';
import Dashboard from './components/Dashboard';
import Publication from './components/Publication';
import Layout from './components/Layout';
import AdminDashboard from './components/AdminDashboard';
import ManagerDashboard from './components/ManagerDashboard'; // Импортируем новый компонент
import { useAuth } from './contexts/AuthContext';

function App() {
	const { isAuthenticated, user, isLoading } = useAuth();

	// Используем role из user, если он доступен, иначе из localStorage
	const storedUser = localStorage.getItem('user');
	const parsedUser = storedUser ? JSON.parse(storedUser) : null;
	const role = user?.role || parsedUser?.role || 'user';

	console.log('App.js: isAuthenticated:', isAuthenticated, 'Role:', role);

	if (isLoading) {
		console.log('App.js: Загрузка состояния аутентификации...');
		return <div>Загрузка...</div>;
	}

	const handleDashboardRedirect = () => {
		if (!isAuthenticated) {
			console.log('App.js: Перенаправление на /login: isAuthenticated is false');
			return <Navigate to="/login" replace />;
		} else if (role === 'admin') {
			console.log('App.js: Перенаправление на /admin: role is admin');
			return <Navigate to="/admin" replace />;
		} else if (role === 'manager') {
			console.log('App.js: Перенаправление на /manager: role is manager');
			return <Navigate to="/manager" replace />;
		} else if (role !== 'user') {
			console.log('App.js: Перенаправление на /login: role is not user, role:', role);
			return <Navigate to="/login" replace />;
		}
		return <Navigate to="/login" replace />;
	};

	const handleAdminRedirect = () => {
		if (!isAuthenticated) {
			console.log('App.js: Перенаправление на /login: isAuthenticated is false');
			return <Navigate to="/login" replace />;
		} else if (role === 'user') {
			console.log('App.js: Перенаправление на /dashboard: role is user');
			return <Navigate to="/dashboard" replace />;
		} else if (role === 'manager') {
			console.log('App.js: Перенаправление на /manager: role is manager');
			return <Navigate to="/manager" replace />;
		} else if (role !== 'admin') {
			console.log('App.js: Перенаправление на /login: role is not admin, role:', role);
			return <Navigate to="/login" replace />;
		}
		return <Navigate to="/login" replace />;
	};

	const handleManagerRedirect = () => {
		if (!isAuthenticated) {
			console.log('App.js: Перенаправление на /login: isAuthenticated is false');
			return <Navigate to="/login" replace />;
		} else if (role === 'user') {
			console.log('App.js: Перенаправление на /dashboard: role is user');
			return <Navigate to="/dashboard" replace />;
		} else if (role === 'admin') {
			console.log('App.js: Перенаправление на /admin: role is admin');
			return <Navigate to="/admin" replace />;
		} else if (role !== 'manager') {
			console.log('App.js: Перенаправление на /login: role is not manager, role:', role);
			return <Navigate to="/login" replace />;
		}
		return <Navigate to="/login" replace />;
	};

	const handlePublicationRedirect = () => {
		if (!isAuthenticated) {
			console.log('App.js: Перенаправление на /login: isAuthenticated is false');
			return <Navigate to="/login" replace />;
		}
		return null;
	};

	return (
		<Routes>
			<Route path="/" element={<Layout />}>
				<Route index element={<Home />} />
				<Route path="/login" element={<Login />} />
				<Route
					path="/dashboard"
					element={
						isAuthenticated && role === 'user' ? (
							<Dashboard />
						) : (
							handleDashboardRedirect()
						)
					}
				/>
				<Route
					path="/publication/:id"
					element={
						isAuthenticated ? (
							<Publication />
						) : (
							handlePublicationRedirect()
						)
					}
				/>
				<Route
					path="/admin"
					element={
						isAuthenticated && role === 'admin' ? (
							<AdminDashboard />
						) : (
							handleAdminRedirect()
						)
					}
				/>
				<Route
					path="/manager"
					element={
						isAuthenticated && role === 'manager' ? (
							<ManagerDashboard />
						) : (
							handleManagerRedirect()
						)
					}
				/>
				<Route path="*" element={<Navigate to="/" replace />} />
			</Route>
		</Routes>
	);
}

export default App;