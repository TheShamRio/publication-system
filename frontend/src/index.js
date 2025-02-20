import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { ThemeProvider } from '@mui/material/styles';
import theme from './theme';
import App from './App';
import Login from './components/Login';
import Dashboard from './components/Dashboard';
import Register from './components/Register';
import Layout from './components/Layout';
import { AuthProvider } from './contexts/AuthContext';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
	<React.StrictMode>
		<ThemeProvider theme={theme}>
			<AuthProvider>
				<Router>
					<Routes>
						<Route path="/" element={<Layout isAuthenticated={!!localStorage.getItem('user')} onLogout={() => { localStorage.removeItem('user'); window.location.reload(); }} />}>
							<Route index element={<App />} />
							<Route path="/login" element={<Login />} />
							<Route path="/dashboard" element={<Dashboard />} />
							<Route path="/register" element={<Register />} />
						</Route>
					</Routes>
				</Router>
			</AuthProvider>
		</ThemeProvider>
	</React.StrictMode>
);