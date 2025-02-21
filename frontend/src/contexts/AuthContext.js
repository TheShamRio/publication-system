// src/contexts/AuthContext.js
import React, { createContext, useState, useContext } from 'react';

const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [authState, setAuthState] = useState({
    isAuthenticated: !!localStorage.getItem('user'),
    role: localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')).role : 'user',
  });

  const login = (userData) => {
    setAuthState({
      isAuthenticated: true,
      role: userData.role || 'user',
    });
    localStorage.setItem('user', JSON.stringify({ ...userData, role: userData.role }));
  };

  const logout = () => {
    setAuthState({
      isAuthenticated: false,
      role: 'user',
    });
    localStorage.removeItem('user');
  };

  // Функция для ручного обновления состояния (для синхронизации с Layout)
  const updateAuthState = (newState) => {
    setAuthState(newState);
    if (newState.isAuthenticated) {
      localStorage.setItem('user', JSON.stringify({ username: newState.username || '', role: newState.role }));
    } else {
      localStorage.removeItem('user');
    }
  };

  return (
    <AuthContext.Provider value={{ ...authState, login, logout, updateAuthState }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);