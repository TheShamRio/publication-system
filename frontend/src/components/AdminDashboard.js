// src/components/AdminDashboard.js
import React, { useState, useEffect } from 'react';
import { Container, Typography, Tabs, Tab, Box, Table, TableHead, TableRow, TableCell, TableBody, Button, Dialog, DialogTitle, DialogContent, DialogActions, TextField, IconButton } from '@mui/material';
import MenuItem from '@mui/material/MenuItem'; // Добавляем импорт MenuItem
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';

function AdminDashboard() {
	const [value, setValue] = useState(0);
	const [users, setUsers] = useState([]);
	const [publications, setPublications] = useState([]);
	const [openEditUser, setOpenEditUser] = useState(false);
	const [openEditPublication, setOpenEditPublication] = useState(false);
	const [selectedUser, setSelectedUser] = useState(null);
	const [selectedPublication, setSelectedPublication] = useState(null);
	const [editUserData, setEditUserData] = useState({});
	const [editPublicationData, setEditPublicationData] = useState({});
	const navigate = useNavigate();
	const { isAuthenticated, role } = useAuth();

	useEffect(() => {
		if (!isAuthenticated || role !== 'admin') {
			navigate('/login');
			return;
		}

		const fetchData = async () => {
			try {
				const usersResponse = await axios.get('http://localhost:5000/api/admin/users', { withCredentials: true });
				const publicationsResponse = await axios.get('http://localhost:5000/api/admin/publications', { withCredentials: true });
				setUsers(usersResponse.data);
				setPublications(publicationsResponse.data);
			} catch (err) {
				console.error('Ошибка загрузки данных:', err);
			}
		};

		fetchData();
	}, [isAuthenticated, role, navigate]);

	const handleTabChange = (event, newValue) => {
		setValue(newValue);
	};

	const handleEditUser = (user) => {
		setSelectedUser(user);
		setEditUserData({ ...user });
		setOpenEditUser(true);
	};

	const handleEditPublication = (publication) => {
		setSelectedPublication(publication);
		setEditPublicationData({ ...publication });
		setOpenEditPublication(true);
	};

	const handleSaveUser = async () => {
		try {
			await axios.put(`http://localhost:5000/api/admin/users/${selectedUser.id}`, editUserData, { withCredentials: true });
			setUsers(users.map(u => u.id === selectedUser.id ? { ...u, ...editUserData } : u));
			setOpenEditUser(false);
		} catch (err) {
			console.error('Ошибка обновления пользователя:', err);
		}
	};

	const handleSavePublication = async () => {
		try {
			await axios.put(`http://localhost:5000/api/admin/publications/${selectedPublication.id}`, editPublicationData, { withCredentials: true });
			setPublications(publications.map(p => p.id === selectedPublication.id ? { ...p, ...editPublicationData } : p));
			setOpenEditPublication(false);
		} catch (err) {
			console.error('Ошибка обновления публикации:', err);
		}
	};

	const handleDeleteUser = async (userId) => {
		try {
			await axios.delete(`http://localhost:5000/api/admin/users/${userId}`, { withCredentials: true });
			setUsers(users.filter(u => u.id !== userId));
		} catch (err) {
			console.error('Ошибка удаления пользователя:', err);
		}
	};

	const handleDeletePublication = async (publicationId) => {
		try {
			await axios.delete(`http://localhost:5000/api/admin/publications/${publicationId}`, { withCredentials: true });
			setPublications(publications.filter(p => p.id !== publicationId));
		} catch (err) {
			console.error('Ошибка удаления публикации:', err);
		}
	};

	if (!isAuthenticated || role !== 'admin') {
		return null; // Или перенаправление на /login
	}

	return (
		<Container maxWidth="lg" sx={{ mt: 4, minHeight: 'calc(100vh - 64px)', backgroundColor: 'white', borderRadius: 20, boxShadow: '0 12px 32px rgba(0, 0, 0, 0.15)' }}>
			<Box sx={{ p: 4 }}>
				<Typography variant="h4" gutterBottom sx={{ color: '#212121', fontWeight: 700, textAlign: 'center' }}>
					Панель администратора
				</Typography>

				<Tabs value={value} onChange={handleTabChange} sx={{ mb: 4, borderBottom: 1, borderColor: 'divider' }}>
					<Tab label="Пользователи" />
					<Tab label="Публикации" />
				</Tabs>

				{value === 0 && (
					<Table sx={{ mt: 2, boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)', borderRadius: 5, overflow: 'hidden' }}>
						<TableHead>
							<TableRow sx={{ backgroundColor: '#1976D2' }}>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>ID</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Логин</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Роль</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Действия</TableCell>
							</TableRow>
						</TableHead>
						<TableBody>
							{users.map((user) => (
								<TableRow key={user.id} sx={{ '&:hover': { backgroundColor: 'grey.50' } }}>
									<TableCell>{user.id}</TableCell>
									<TableCell>{user.username}</TableCell>
									<TableCell>{user.role}</TableCell>
									<TableCell>
										<IconButton onClick={() => handleEditUser(user)} sx={{ color: '#1976D2', mr: 1, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.1)' } }}>
											<EditIcon />
										</IconButton>
										<IconButton onClick={() => handleDeleteUser(user.id)} sx={{ color: '#1976D2', transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.1)' } }}>
											<DeleteIcon />
										</IconButton>
									</TableCell>
								</TableRow>
							))}
						</TableBody>
					</Table>
				)}

				{value === 1 && (
					<Table sx={{ mt: 2, boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)', borderRadius: 5, overflow: 'hidden' }}>
						<TableHead>
							<TableRow sx={{ backgroundColor: '#1976D2' }}>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>ID</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Название</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Автор</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Год</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Статус</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Действия</TableCell>
							</TableRow>
						</TableHead>
						<TableBody>
							{publications.map((pub) => (
								<TableRow key={pub.id} sx={{ '&:hover': { backgroundColor: 'grey.50' } }}>
									<TableCell>{pub.id}</TableCell>
									<TableCell>{pub.title}</TableCell>
									<TableCell>{pub.authors}</TableCell>
									<TableCell>{pub.year}</TableCell>
									<TableCell>{pub.status}</TableCell>
									<TableCell>
										<IconButton onClick={() => handleEditPublication(pub)} sx={{ color: '#1976D2', mr: 1, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.1)' } }}>
											<EditIcon />
										</IconButton>
										<IconButton onClick={() => handleDeletePublication(pub.id)} sx={{ color: '#1976D2', transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.1)' } }}>
											<DeleteIcon />
										</IconButton>
									</TableCell>
								</TableRow>
							))}
						</TableBody>
					</Table>
				)}

				<Dialog open={openEditUser} onClose={() => setOpenEditUser(false)}>
					<DialogTitle>Редактировать пользователя</DialogTitle>
					<DialogContent>
						<TextField
							fullWidth
							label="Логин"
							value={editUserData.username || ''}
							onChange={(e) => setEditUserData({ ...editUserData, username: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
						/>
						<TextField
							fullWidth
							select
							label="Роль"
							value={editUserData.role || 'user'}
							onChange={(e) => setEditUserData({ ...editUserData, role: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
						>
							<MenuItem value="user">Пользователь</MenuItem>
							<MenuItem value="admin">Администратор</MenuItem>
						</TextField>
						<TextField
							fullWidth
							label="Фамилия"
							value={editUserData.last_name || ''}
							onChange={(e) => setEditUserData({ ...editUserData, last_name: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
						/>
						<TextField
							fullWidth
							label="Имя"
							value={editUserData.first_name || ''}
							onChange={(e) => setEditUserData({ ...editUserData, first_name: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
						/>
						<TextField
							fullWidth
							label="Отчество"
							value={editUserData.middle_name || ''}
							onChange={(e) => setEditUserData({ ...editUserData, middle_name: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
						/>
					</DialogContent>
					<DialogActions>
						<Button onClick={() => setOpenEditUser(false)} sx={{ color: '#1976D2' }}>
							Отмена
						</Button>
						<Button onClick={handleSaveUser} variant="contained" sx={{ borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}>
							Сохранить
						</Button>
					</DialogActions>
				</Dialog>

				<Dialog open={openEditPublication} onClose={() => setOpenEditPublication(false)}>
					<DialogTitle>Редактировать публикацию</DialogTitle>
					<DialogContent>
						<TextField
							fullWidth
							label="Название"
							value={editPublicationData.title || ''}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, title: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
						/>
						<TextField
							fullWidth
							label="Авторы"
							value={editPublicationData.authors || ''}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, authors: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
						/>
						<TextField
							fullWidth
							label="Год"
							type="number"
							value={editPublicationData.year || ''}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, year: parseInt(e.target.value) })}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
						/>
						<TextField
							fullWidth
							select
							label="Тип"
							value={editPublicationData.type || 'article'}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, type: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
						>
							<MenuItem value="article">Статья</MenuItem>
							<MenuItem value="monograph">Монография</MenuItem>
							<MenuItem value="conference">Доклад/конференция</MenuItem>
						</TextField>
						<TextField
							fullWidth
							select
							label="Статус"
							value={editPublicationData.status || 'draft'}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, status: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
						>
							<MenuItem value="draft">Черновик</MenuItem>
							<MenuItem value="review">На проверке</MenuItem>
							<MenuItem value="published">Опубликовано</MenuItem>
						</TextField>
						<TextField
							fullWidth
							label="URL файла"
							value={editPublicationData.file_url || ''}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, file_url: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{ mb: 2, borderRadius: 8 }}
						/>
					</DialogContent>
					<DialogActions>
						<Button onClick={() => setOpenEditPublication(false)} sx={{ color: '#1976D2' }}>
							Отмена
						</Button>
						<Button onClick={handleSavePublication} variant="contained" sx={{ borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}>
							Сохранить
						</Button>
					</DialogActions>
				</Dialog>
			</Box>
		</Container>
	);
}

export default AdminDashboard;