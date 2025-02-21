import React from 'react';
import { Route, Routes, Navigate } from 'react-router-dom';
import Home from './components/Home';
import Login from './components/Login';
import Dashboard from './components/Dashboard';
import Publication from './components/Publication';
import Register from './components/Register';
import Layout from './components/Layout';
import { useAuth } from './contexts/AuthContext'; // Импортируем useAuth

function App() {
  const { isAuthenticated } = useAuth(); // Получаем isAuthenticated из контекста

  return (
    <Routes>
      <Route path="/" element={<Layout />}>
        <Route index element={<Home />} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route
          path="/dashboard"
          element={isAuthenticated ? <Dashboard /> : <Navigate to="/login" />}
        />
        <Route
          path="/publication/:id"
          element={isAuthenticated ? <Publication /> : <Navigate to="/login" />}
        />
      </Route>
    </Routes>
  );
}

export default App;