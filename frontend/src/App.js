import React from 'react';
import { Route, Routes, Navigate } from 'react-router-dom';
import Home from './components/Home';
import Login from './components/Login';
import Dashboard from './components/Dashboard';
import Publication from './components/Publication';
import Layout from './components/Layout';
import AdminDashboard from './components/AdminDashboard';
import { useAuth } from './contexts/AuthContext';

function App() {
	const { isAuthenticated, role } = useAuth();

	return (
		<Routes>
			<Route path="/" element={<Layout />}>
				<Route index element={<Home />} />
				<Route path="/login" element={<Login />} />
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