import React, { useState, useEffect, useCallback, useMemo } from 'react';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import { Box, CssBaseline } from '@mui/material';
import Header from './Header';
import Footer from './Footer';
import axios from 'axios';
import { useAuth } from '../contexts/AuthContext'; // Импортируем useAuth

function Layout() {
  const [isAuthenticated, setIsAuthenticated] = useState(!!localStorage.getItem('user')); // Инициализируем из localStorage
  const navigate = useNavigate();
  const location = useLocation();
  const { logout, updateAuthState } = useAuth(); // Убрали login, если он не используется

  // Мемоизация состояния авторизации для предотвращения лишних рендеров
  const authState = useMemo(() => ({
    isAuthenticated,
    setIsAuthenticated,
  }), [isAuthenticated]);

  // Debounce для проверки авторизации, чтобы избежать бесконечных запросов
  const checkAuth = useCallback(async () => {
    // Проверяем, есть ли данные в localStorage, и не делаем запрос для публичных страниц
    const storedUser = localStorage.getItem('user');
    if (storedUser) {
      const userData = JSON.parse(storedUser);
      // Устанавливаем состояние только если оно отличается
      if (!isAuthenticated) {
        setIsAuthenticated(true);
        updateAuthState({
          isAuthenticated: true,
          role: userData.role || 'user',
          username: userData.username,
        });
      }
      return; // Не делаем запрос, если данные в localStorage
    }

    // Проверяем только для защищённых маршрутов
    if (!location.pathname.startsWith('/dashboard') && !location.pathname.startsWith('/publication') && !location.pathname.startsWith('/admin')) {
      return; // Не делаем запрос для публичных страниц
    }

    try {
      console.log('Checking authentication...');
      const response = await axios.get('http://localhost:5000/api/user', {
        withCredentials: true,
      });
      console.log('Auth response:', response.data);
      const userData = response.data;
      // Устанавливаем состояние только если оно отличается
      if (!isAuthenticated) {
        setIsAuthenticated(true);
        updateAuthState({
          isAuthenticated: true,
          role: userData.role || 'user',
          username: userData.username,
        });
      }
      localStorage.setItem('user', JSON.stringify({ username: userData.username, role: userData.role }));
    } catch (err) {
      console.error('Auth error:', err.response?.status, err.response?.data?.error || err.message);
      // Устанавливаем состояние только если оно отличается
      if (isAuthenticated) {
        setIsAuthenticated(false);
        updateAuthState({
          isAuthenticated: false,
          role: 'user',
          username: '',
        });
      }
      localStorage.removeItem('user');
      // Перенаправляем только если на защищённых маршрутах
      if (location.pathname.startsWith('/dashboard') || location.pathname.startsWith('/publication') || location.pathname.startsWith('/admin')) {
        navigate('/login');
      }
    }
  }, [navigate, updateAuthState, location.pathname, isAuthenticated]); // Добавляем isAuthenticated для контроля изменений

  // Выполняем проверку авторизации только один раз при монтировании или при изменении пути
  useEffect(() => {
    let mounted = true;

    const performCheckAuth = async () => {
      await checkAuth();
    };

    performCheckAuth();

    return () => {
      mounted = false;
    };
  }, [checkAuth]); // Используем checkAuth как зависимость

  const handleLogout = () => {
    axios
      .get('http://localhost:5000/api/logout', { withCredentials: true })
      .then(() => {
        setIsAuthenticated(false);
        logout();
        localStorage.removeItem('user');
        navigate('/login');
      })
      .catch((err) => console.error('Ошибка выхода:', err));
  };

  return (
    <Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
      <CssBaseline />
      <Header isAuthenticated={authState.isAuthenticated} onLogout={handleLogout} />
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          p: 3,
          mt: '64px', // Отступ под хедер
        }}
      >
        <Outlet />
      </Box>
      <Footer />
    </Box>
  );
}

export default Layout;