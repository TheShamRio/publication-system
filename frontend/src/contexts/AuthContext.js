import React, { createContext, useContext, useState, useEffect } from 'react';
import axios from 'axios';

const AuthContext = createContext();

export function AuthProvider({ children }) {
	const [authState, setAuthState] = useState(() => {
		const storedUser = localStorage.getItem('user');
		const storedCsrfToken = localStorage.getItem('csrfToken');
		const parsedUser = storedUser ? JSON.parse(storedUser) : null;
		console.log('AuthContext: Инициализация состояния:', {
			isAuthenticated: !!storedUser,
			user: parsedUser,
			role: parsedUser?.role || null,
			csrfToken: storedCsrfToken,
		});
		return {
			isAuthenticated: !!storedUser,
			user: parsedUser || null, // Полный объект пользователя
			role: parsedUser?.role || null,
			csrfToken: storedCsrfToken || null,
			isLoading: true,
		};
	});

	useEffect(() => {
		const checkAuthStatus = async () => {
			try {
				console.log('AuthContext: Проверка аутентификации на сервере...');
				const response = await axios.get('http://localhost:5000/api/user', {
					withCredentials: true,
				});
				console.log('AuthContext: Ответ от /api/user:', response.data);
				const userData = {
					id: response.data.id,
					username: response.data.username,
					role: response.data.role || 'user',
					first_name: response.data.first_name || '',
					last_name: response.data.last_name || '',
					middle_name: response.data.middle_name || '',
				};
				setAuthState({
					isAuthenticated: true,
					user: userData, // Полный объект пользователя
					role: userData.role,
					csrfToken: authState.csrfToken,
					isLoading: false,
				});
				localStorage.setItem('user', JSON.stringify(userData));

				// Обновляем CSRF-токен после успешной проверки
				const tokenResponse = await axios.get('http://localhost:5000/api/csrf-token', {
					withCredentials: true,
				});
				setCsrfToken(tokenResponse.data.csrf_token);
				console.log('AuthContext: CSRF Token обновлён:', tokenResponse.data.csrf_token);
			} catch (err) {
				console.error('AuthContext: Ошибка проверки состояния аутентификации:', err.response?.status, err.response?.data?.error || err.message);
				if (err.response && err.response.status === 401) {
					console.log('AuthContext: Пользователь не аутентифицирован (401), вызываем logout...');
					logout();
				} else {
					console.error('AuthContext: Другая ошибка при проверке аутентификации:', err);
				}
				setAuthState((prevState) => ({
					...prevState,
					isLoading: false,
				}));
			}
		};

		if (authState.isAuthenticated) {
			checkAuthStatus();
		} else {
			console.log('AuthContext: Пользователь не аутентифицирован в localStorage, пропускаем проверку.');
			setAuthState((prevState) => ({
				...prevState,
				isLoading: false,
			}));
		}
	}, [authState.isAuthenticated]);

	const login = (userData) => {
		const user = {
			id: userData.id,
			username: userData.username,
			role: userData.role,
			first_name: userData.first_name || '',
			last_name: userData.last_name || '',
			middle_name: userData.middle_name || '',
		};
		console.log('AuthContext: Пользователь вошёл:', user);
		setAuthState({
			isAuthenticated: true,
			user: user, // Сохраняем полный объект пользователя
			role: user.role,
			csrfToken: authState.csrfToken,
			isLoading: false,
		});
		localStorage.setItem('user', JSON.stringify(user));
	};

	const logout = () => {
		console.log('AuthContext: Пользователь выходит...');
		setAuthState({
			isAuthenticated: false,
			user: null,
			role: null,
			csrfToken: null,
			isLoading: false,
		});
		localStorage.removeItem('user');
		localStorage.removeItem('csrfToken');
	};

	const updateAuthState = (newState) => {
		console.log('AuthContext: Обновление состояния:', newState);
		setAuthState((prevState) => ({
			...prevState,
			...newState,
		}));
	};

	const setCsrfToken = (token) => {
		console.log('AuthContext: Установка CSRF Token:', token);
		setAuthState((prevState) => ({
			...prevState,
			csrfToken: token,
		}));
		localStorage.setItem('csrfToken', token);
	};

	return (
		<AuthContext.Provider value={{ ...authState, login, logout, updateAuthState, setCsrfToken }}>
			{children}
		</AuthContext.Provider>
	);
}

export function useAuth() {
	return useContext(AuthContext);
}