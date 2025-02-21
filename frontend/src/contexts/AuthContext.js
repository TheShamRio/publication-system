// src/contexts/AuthContext.js
import React, { createContext, useState, useContext } from 'react';

const AuthContext = createContext();

export function AuthProvider({ children }) {
	const [isAuthenticated, setIsAuthenticated] = useState(!!localStorage.getItem('user'));

	const login = () => {
		setIsAuthenticated(true);
	};

	const logout = () => {
		setIsAuthenticated(false);
		localStorage.removeItem('user');
	};

	return (
		<AuthContext.Provider value={{ isAuthenticated, login, logout, setIsAuthenticated }}>
			{children}
		</AuthContext.Provider>
	);
}

export const useAuth = () => useContext(AuthContext);