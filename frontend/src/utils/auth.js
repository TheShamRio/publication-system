import axios from 'axios';

const API_BASE = 'http://localhost:5000';

export const makeAuthenticatedRequest = async (url, method = 'POST', data = {}, options = {}) => {
    try {
        const fullUrl = url.startsWith('http') ? url : `${API_BASE}${url}`;

        console.log('Отправка запроса:', {
            url: fullUrl,
            method,
            headers: {
                'Content-Type': options.headers?.['Content-Type'] || 'application/json',
                ...options.headers
            }
        });

        const response = await axios({
            method,
            url: fullUrl,
            data,
            withCredentials: true,
            headers: {
                'Content-Type': options.headers?.['Content-Type'] || 'application/json',
                ...options.headers
            }
        });

        console.log('Response from server:', response.data, response.status, response.headers);
        return response;
    } catch (err) {
        console.error('Ошибка в makeAuthenticatedRequest:', err.response?.data || err, err.response?.status, err.response?.headers);
        throw err;
    }
};

export const login = async (username, password) => {
    try {
        const response = await makeAuthenticatedRequest('/api/login', 'POST', { username, password });
        return response.data;
    } catch (err) {
        console.error('Ошибка авторизации:', err.response?.data || err);
        throw err;
    }
};

export const logout = async () => {
    try {
        const response = await makeAuthenticatedRequest('/api/logout', 'POST');
        return response.data;
    } catch (err) {
        console.error('Ошибка выхода:', err.response?.data || err);
        throw err;
    }
};

export const isAuthenticated = () => {
    const token = localStorage.getItem('token');
    return !!token;
};