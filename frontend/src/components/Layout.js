import React, { useEffect, useState, useCallback, useMemo } from 'react';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import { Box, CssBaseline } from '@mui/material';
import Header from './Header';
import Footer from './Footer';
import axios from 'axios';
import { useAuth } from '../contexts/AuthContext';

function Layout() {
    const [isAuthenticated, setIsAuthenticated] = useState(!!localStorage.getItem('user'));
    const navigate = useNavigate();
    const location = useLocation();
    const { logout, updateAuthState, setCsrfToken, csrfToken } = useAuth();

    const authState = useMemo(() => ({
        isAuthenticated,
        setIsAuthenticated,
    }), [isAuthenticated]);

    // Объявляем publicRoutes как константу внутри компонента
    const publicRoutes = ['/', '/login', '/register']; // Добавьте сюда все публичные маршруты

    const checkAuth = useCallback(async () => {
        const storedUser = localStorage.getItem('user');
        try {
            if (storedUser) {
                const userData = JSON.parse(storedUser);
                const currentIsAuthenticated = !!userData;
                if (currentIsAuthenticated !== isAuthenticated) {
                    setIsAuthenticated(currentIsAuthenticated);
                    updateAuthState({
                        isAuthenticated: currentIsAuthenticated,
                        role: userData.role || 'user',
                        username: userData.username,
                    });
                }
                if (!csrfToken) {
                    const tokenResponse = await axios.get('http://localhost:5000/api/csrf-token', {
                        withCredentials: true,
                    });
                    setCsrfToken(tokenResponse.data.csrf_token);
                    console.log('CSRF Token сохранён:', tokenResponse.data.csrf_token);
                }
                return;
            }

            // Проверяем авторизацию только для защищённых маршрутов
            if (!publicRoutes.includes(location.pathname)) {
                const response = await axios.get('http://localhost:5000/api/user', {
                    withCredentials: true,
                });
                const userData = response.data;
                const newIsAuthenticated = true;
                if (newIsAuthenticated !== isAuthenticated) {
                    setIsAuthenticated(newIsAuthenticated);
                    updateAuthState({
                        isAuthenticated: newIsAuthenticated,
                        role: userData.role || 'user',
                        username: userData.username,
                    });
                    localStorage.setItem('user', JSON.stringify({ username: userData.username, role: userData.role }));
                }
                if (!csrfToken) {
                    const tokenResponse = await axios.get('http://localhost:5000/api/csrf-token', {
                        withCredentials: true,
                    });
                    setCsrfToken(tokenResponse.data.csrf_token);
                    console.log('CSRF Token сохранён:', tokenResponse.data.csrf_token);
                }
            }
        } catch (err) {
            console.error('Auth error:', err.response?.status, err.response?.data?.error || err.message);
            const newIsAuthenticated = false;
            if (newIsAuthenticated !== isAuthenticated) {
                setIsAuthenticated(newIsAuthenticated);
                updateAuthState({
                    isAuthenticated: newIsAuthenticated,
                    role: 'user',
                    username: '',
                });
                localStorage.removeItem('user');
                setCsrfToken(null);
            }
            if (!publicRoutes.includes(location.pathname)) {
                navigate('/login', { replace: true });
            }
        }
    }, [navigate, updateAuthState, isAuthenticated, csrfToken, setCsrfToken, publicRoutes, location.pathname]); // Добавляем publicRoutes в зависимости, если она нужна

    useEffect(() => {
        let mounted = true;

        const performCheckAuth = async () => {
            if (mounted) {
                await checkAuth();
            }
        };

        performCheckAuth();

        return () => {
            mounted = false;
        };
    }, [checkAuth]);

    const handleLogout = async () => {
        try {
            if (!csrfToken) {
                const tokenResponse = await axios.get('http://localhost:5000/api/csrf-token', {
                    withCredentials: true,
                });
                setCsrfToken(tokenResponse.data.csrf_token);
                console.log('CSRF Token получен перед выходом:', tokenResponse.data.csrf_token);
            }

            await axios.post('http://localhost:5000/api/logout', {}, {
                withCredentials: true,
                headers: {
                    'X-CSRFToken': csrfToken,
                },
            });

            setIsAuthenticated(false);
            setCsrfToken(null);
            logout();
            localStorage.removeItem('user');
            navigate('/login', { replace: true });
        } catch (err) {
            console.error('Ошибка выхода:', err);
            setIsAuthenticated(false);
            setCsrfToken(null);
            logout();
            localStorage.removeItem('user');
            navigate('/login', { replace: true });
        }
    };

    return (
        <Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
            <CssBaseline />
            <Header isAuthenticated={authState.isAuthenticated} onLogout={handleLogout} />
            <Box component="main" sx={{ flexGrow: 1, p: 3, mt: '64px' }}>
                <Outlet />
            </Box>
            <Footer />
        </Box>
    );
}

export default Layout;