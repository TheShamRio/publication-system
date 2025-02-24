import React, { createContext, useContext, useState } from 'react';

const AuthContext = createContext();

export function AuthProvider({ children }) {
    const [authState, setAuthState] = useState(() => {
        const storedUser = localStorage.getItem('user');
        return {
            isAuthenticated: !!storedUser,
            role: storedUser ? JSON.parse(storedUser).role || 'user' : 'user',
            username: storedUser ? JSON.parse(storedUser).username || '' : '',
            csrfToken: null,
        };
    });

    const login = (userData) => {
        setAuthState({
            ...authState,
            isAuthenticated: true,
            role: userData.role,
            username: userData.username,
        });
    };

    const logout = () => {
        setAuthState({
            isAuthenticated: false,
            role: 'user',
            username: '',
            csrfToken: null,
        });
        localStorage.removeItem('user');
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