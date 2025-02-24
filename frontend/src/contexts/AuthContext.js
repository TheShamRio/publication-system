import React, { createContext, useContext, useState } from 'react';

const AuthContext = createContext();

export function AuthProvider({ children }) {
    const [authState, setAuthState] = useState(() => {
        const storedUser = localStorage.getItem('user');
        const storedCsrfToken = localStorage.getItem('csrfToken');
        return {
            isAuthenticated: !!storedUser,
            role: storedUser ? JSON.parse(storedUser).role || 'user' : 'user',
            username: storedUser ? JSON.parse(storedUser).username || '' : '',
            csrfToken: storedCsrfToken || null,
        };
    });

    const login = (userData) => {
        setAuthState({
            ...authState,
            isAuthenticated: true,
            role: userData.role,
            username: userData.username,
        });
        localStorage.setItem('user', JSON.stringify({ username: userData.username, role: userData.role }));
    };

    const logout = () => {
        setAuthState({
            isAuthenticated: false,
            role: 'user',
            username: '',
            csrfToken: null,
        });
        localStorage.removeItem('user');
        localStorage.removeItem('csrfToken');
    };

    const updateAuthState = (newState) => {
        setAuthState((prevState) => ({
            ...prevState,
            ...newState,
        }));
    };

    const setCsrfToken = (token) => {
        setAuthState((prevState) => ({
            ...prevState,
            csrfToken: token,
        }));
        localStorage.setItem('csrfToken', token); // Сохраняем токен в localStorage
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