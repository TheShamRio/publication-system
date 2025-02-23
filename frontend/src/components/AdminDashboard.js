import React, { useState, useEffect } from 'react';
import { Container, Typography, Tabs, Tab, Box, Table, TableHead, TableRow, TableCell, TableBody, Button, Dialog, DialogTitle, DialogContent, DialogActions, TextField, IconButton, CircularProgress, Alert } from '@mui/material';
import MenuItem from '@mui/material/MenuItem';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import axios from 'axios';

function AdminDashboard() {
	const [value, setValue] = useState(0);
	const [users, setUsers] = useState([]);
	const [publications, setPublications] = useState([]);
	const [loading, setLoading] = useState(true);
	const [error, setError] = useState(null);
	const [openEditUser, setOpenEditUser] = useState(false);
	const [openEditPublication, setOpenEditPublication] = useState(false);
	const [selectedUser, setSelectedUser] = useState(null);
	const [selectedPublication, setSelectedPublication] = useState(null);
	const [editUserData, setEditUserData] = useState({});
	const [editPublicationData, setEditPublicationData] = useState({});
	const [newFile, setNewFile] = useState(null);
	const navigate = useNavigate();
	const { isAuthenticated, role } = useAuth();

	useEffect(() => {
		if (!isAuthenticated || role !== 'admin') {
			navigate('/login');
			return;
		}

		const fetchData = async () => {
			setLoading(true);
			setError(null);
			try {
				console.log('Fetching users from /admin_api/admin/users...');
				const usersResponse = await axios.get('http://localhost:5000/admin_api/admin/users', { withCredentials: true });
				console.log('Users response data:', usersResponse.data, 'Status:', usersResponse.status);
				setUsers(Array.isArray(usersResponse.data) ? usersResponse.data : []);

				console.log('Fetching publications from /admin_api/admin/publications...');
				const publicationsResponse = await axios.get('http://localhost:5000/admin_api/admin/publications', { withCredentials: true });
				console.log('Publications response data:', publicationsResponse.data, 'Status:', publicationsResponse.status);
				setPublications(Array.isArray(publicationsResponse.data) ? publicationsResponse.data : []);
			} catch (err) {
				console.error('Ошибка загрузки данных:', err.response?.status, err.response?.data || err.message, err.response?.headers);
				setError(err.response?.data?.error || `Ошибка: ${err.response?.status || 'Неизвестная ошибка'}`);
			} finally {
				setLoading(false);
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
		setNewFile(null);
		setOpenEditPublication(true);
	};

	const handleSaveUser = async () => {
		try {
			console.log('Updating user:', editUserData);
			const response = await axios.put(`http://localhost:5000/admin_api/admin/users/${selectedUser.id}`, editUserData, { withCredentials: true });
			console.log('User update response:', response.data, 'Status:', response.status);
			setUsers(users.map(u => u.id === selectedUser.id ? { ...u, ...editUserData } : u));
			setOpenEditUser(false);
		} catch (err) {
			console.error('Ошибка обновления пользователя:', err.response?.status, err.response?.data || err.message, err.response?.headers);
			setError(err.response?.data?.error || 'Ошибка обновления пользователя');
		}
	};

	const handleSavePublication = async () => {
		try {
			console.log('Updating publication:', editPublicationData);
			let data;
			let headers = {};
			if (newFile) {
				data = new FormData();
				data.append('title', editPublicationData.title || '');
				data.append('authors', editPublicationData.authors || '');
				data.append('year', editPublicationData.year || '');
				data.append('type', editPublicationData.type || 'article');
				data.append('status', editPublicationData.status || 'draft');
				data.append('file', newFile);
				headers['Content-Type'] = 'multipart/form-data';
			} else {
				data = {
					title: editPublicationData.title || '',
					authors: editPublicationData.authors || '',
					year: editPublicationData.year || '',
					type: editPublicationData.type || 'article',
					status: editPublicationData.status || 'draft'
				};
				headers['Content-Type'] = 'application/json';
			}

			const response = await axios.put(
				`http://localhost:5000/admin_api/admin/publications/${selectedPublication.id}`,
				data,
				{ withCredentials: true, headers }
			);
			console.log('Publication update response:', response.data, 'Status:', response.status);
			setPublications(publications.map(p => p.id === selectedPublication.id ? { ...p, ...response.data.publication } : p));
			setOpenEditPublication(false);
		} catch (err) {
			console.error('Ошибка обновления публикации:', err.response?.status, err.response?.data || err.message, err.response?.headers);
			setError(err.response?.data?.error || 'Ошибка обновления публикации');
		}
	};

	const handleDeleteUser = async (userId) => {
		try {
			console.log('Deleting user with ID:', userId);
			const response = await axios.delete(`http://localhost:5000/admin_api/admin/users/${userId}`, { withCredentials: true });
			console.log('User deletion response:', response.data, 'Status:', response.status);
			setUsers(users.filter(u => u.id !== userId));
		} catch (err) {
			console.error('Ошибка удаления пользователя:', err.response?.status, err.response?.data || err.message, err.response?.headers);
			setError(err.response?.data?.error || 'Ошибка удаления пользователя');
		}
	};

	const handleDeletePublication = async (publicationId) => {
		try {
			console.log('Deleting publication with ID:', publicationId);
			const response = await axios.delete(`http://localhost:5000/admin_api/admin/publications/${publicationId}`, { withCredentials: true });
			console.log('Publication deletion response:', response.data, 'Status:', response.status);
			setPublications(publications.filter(p => p.id !== publicationId));
		} catch (err) {
			console.error('Ошибка удаления публикации:', err.response?.status, err.response?.data || err.message, err.response?.headers);
			setError(err.response?.data?.error || 'Ошибка удаления публикации');
		}
	};

	if (!isAuthenticated || role !== 'admin') {
		return null;
	}

	return (
		<Container
			maxWidth="lg"
			sx={{
				mt: 4,
				minHeight: 'calc(100vh - 64px)',
				backgroundColor: '#FFFFFF',
				borderRadius: '12px',
				boxShadow: '0 4px 12px 0 rgb(0 0 0 / 15%)',
				fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif"
			}}
		>
			<Box sx={{ p: 4 }}>
				<Typography
					variant="h4"
					gutterBottom
					sx={{
						color: '#1D1D1F',
						fontWeight: 600,
						textAlign: 'center'
					}}
				>
					Панель администратора
				</Typography>

				<Tabs
					value={value}
					onChange={handleTabChange}
					sx={{
						mb: 4,
						'& .MuiTab-root': {
							color: '#6E6E73',
							fontSize: '1.1rem',
							textTransform: 'none',
							'&:hover': { color: '#0071E3' },
							'&.Mui-selected': { color: '#1D1D1F' }
						},
						'& .MuiTabs-indicator': { backgroundColor: '#0071E3' }
					}}
				>
					<Tab label="Пользователи" />
					<Tab label="Публикации" />
				</Tabs>

				{loading ? (
					<Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
						<CircularProgress sx={{ color: '#0071E3' }} />
					</Box>
				) : error ? (
					<Alert
						severity="error"
						sx={{
							mt: 4,
							borderRadius: '12px',
							backgroundColor: '#FFF1F0',
							color: '#1D1D1F'
						}}
					>
						{error}
					</Alert>
				) : (
					<>
						{value === 0 && (
							<>
								{users.length === 0 ? (
									<Typography sx={{ mt: 4, textAlign: 'center', color: '#6E6E73' }}>
										Нет пользователей для отображения.
									</Typography>
								) : (
									<Table
										sx={{
											mt: 2,
											boxShadow: '0 4px 12px 0 rgb(0 0 0 / 15%)',
											borderRadius: '12px',
											overflow: 'hidden',
											backgroundColor: '#FFFFFF'
										}}
									>
										<TableHead>
											<TableRow sx={{ backgroundColor: '#0071E3' }}>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>ID</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Логин</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Роль</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', textAlign: 'center' }}>Действия</TableCell>
											</TableRow>
										</TableHead>
										<TableBody>
											{users.map((user) => (
												<TableRow
													key={user.id}
													sx={{
														'&:hover': { backgroundColor: '#E5E5E5', transition: 'background-color 0.3s ease' }
													}}
												>
													<TableCell sx={{ color: '#1D1D1F' }}>{user.id}</TableCell>
													<TableCell sx={{ color: '#1D1D1F' }}>{user.username}</TableCell>
													<TableCell sx={{ color: '#1D1D1F' }}>{user.role}</TableCell>
													<TableCell sx={{ textAlign: 'center' }}>
														<Box sx={{ display: 'flex', justifyContent: 'center', gap: 1 }}>
															<IconButton
																onClick={() => handleEditUser(user)}
																sx={{
																	color: '#0071E3',
																	'&:hover': {
																		color: '#FFFFFF',
																		backgroundColor: '#0071E3',
																		borderRadius: '12px'
																	}
																}}
															>
																<EditIcon />
															</IconButton>
															<IconButton
																onClick={() => handleDeleteUser(user.id)}
																sx={{
																	color: '#0071E3',
																	'&:hover': {
																		color: '#FFFFFF',
																		backgroundColor: '#0071E3',
																		borderRadius: '12px'
																	}
																}}
															>
																<DeleteIcon />
															</IconButton>
														</Box>
													</TableCell>
												</TableRow>
											))}
										</TableBody>
									</Table>
								)}
							</>
						)}

						{value === 1 && (
							<>
								{publications.length === 0 ? (
									<Typography sx={{ mt: 4, textAlign: 'center', color: '#6E6E73' }}>
										Нет публикаций для отображения.
									</Typography>
								) : (
									<Table
										sx={{
											mt: 2,
											boxShadow: '0 4px 12px 0 rgb(0 0 0 / 15%)',
											borderRadius: '12px',
											overflow: 'hidden',
											backgroundColor: '#FFFFFF'
										}}
									>
										<TableHead>
											<TableRow sx={{ backgroundColor: '#0071E3' }}>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>ID</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Название</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Автор</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Год</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Статус</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', textAlign: 'center' }}>Действия</TableCell>
											</TableRow>
										</TableHead>
										<TableBody>
											{publications.map((pub) => (
												<TableRow
													key={pub.id}
													sx={{
														'&:hover': { backgroundColor: '#E5E5E5', transition: 'background-color 0.3s ease' }
													}}
												>
													<TableCell sx={{ color: '#1D1D1F' }}>{pub.id}</TableCell>
													<TableCell sx={{ color: '#1D1D1F' }}>{pub.title}</TableCell>
													<TableCell sx={{ color: '#1D1D1F' }}>{pub.authors}</TableCell>
													<TableCell sx={{ color: '#1D1D1F' }}>{pub.year}</TableCell>
													<TableCell sx={{ color: '#1D1D1F' }}>{pub.status}</TableCell>
													<TableCell sx={{ textAlign: 'center' }}>
														<Box sx={{ display: 'flex', justifyContent: 'center', gap: 1 }}>
															<IconButton
																onClick={() => handleEditPublication(pub)}
																sx={{
																	color: '#0071E3',
																	'&:hover': {
																		color: '#FFFFFF',
																		backgroundColor: '#0071E3',
																		borderRadius: '12px'
																	}
																}}
															>
																<EditIcon />
															</IconButton>
															<IconButton
																onClick={() => handleDeletePublication(pub.id)}
																sx={{
																	color: '#0071E3',
																	'&:hover': {
																		color: '#FFFFFF',
																		backgroundColor: '#0071E3',
																		borderRadius: '12px'
																	}
																}}
															>
																<DeleteIcon />
															</IconButton>
														</Box>
													</TableCell>
												</TableRow>
											))}
										</TableBody>
									</Table>
								)}
							</>
						)}
					</>
				)}

				<Dialog
					open={openEditUser}
					onClose={() => setOpenEditUser(false)}
					sx={{
						'& .MuiDialog-paper': {
							backgroundColor: '#FFFFFF',
							boxShadow: '0 4px 12px 0 rgb(0 0 0 / 15%)',
							borderRadius: '12px',
							fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif"
						}
					}}
				>
					<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600, borderBottom: '1px solid #E5E5E5' }}>
						Редактировать пользователя
					</DialogTitle>
					<DialogContent sx={{ padding: '24px' }}>
						<TextField
							fullWidth
							label="Логин"
							value={editUserData.username || ''}
							onChange={(e) => setEditUserData({ ...editUserData, username: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{
								'& .MuiOutlinedInput-root': {
									'& fieldset': { borderColor: '#D1D1D6' },
									'&:hover fieldset': { borderColor: '#0071E3' },
									'&.Mui-focused fieldset': { borderColor: '#0071E3' }
								},
								'& label': { color: '#6E6E73' },
								'& input': { color: '#1D1D1F' }
							}}
						/>
						<TextField
							fullWidth
							select
							label="Роль"
							value={editUserData.role || 'user'}
							onChange={(e) => setEditUserData({ ...editUserData, role: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{
								'& .MuiOutlinedInput-root': {
									'& fieldset': { borderColor: '#D1D1D6' },
									'&:hover fieldset': { borderColor: '#0071E3' },
									'&.Mui-focused fieldset': { borderColor: '#0071E3' }
								},
								'& label': { color: '#6E6E73' },
								'& input': { color: '#1D1D1F' }
							}}
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
							sx={{
								'& .MuiOutlinedInput-root': {
									'& fieldset': { borderColor: '#D1D1D6' },
									'&:hover fieldset': { borderColor: '#0071E3' },
									'&.Mui-focused fieldset': { borderColor: '#0071E3' }
								},
								'& label': { color: '#6E6E73' },
								'& input': { color: '#1D1D1F' }
							}}
						/>
						<TextField
							fullWidth
							label="Имя"
							value={editUserData.first_name || ''}
							onChange={(e) => setEditUserData({ ...editUserData, first_name: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{
								'& .MuiOutlinedInput-root': {
									'& fieldset': { borderColor: '#D1D1D6' },
									'&:hover fieldset': { borderColor: '#0071E3' },
									'&.Mui-focused fieldset': { borderColor: '#0071E3' }
								},
								'& label': { color: '#6E6E73' },
								'& input': { color: '#1D1D1F' }
							}}
						/>
						<TextField
							fullWidth
							label="Отчество"
							value={editUserData.middle_name || ''}
							onChange={(e) => setEditUserData({ ...editUserData, middle_name: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{
								'& .MuiOutlinedInput-root': {
									'& fieldset': { borderColor: '#D1D1D6' },
									'&:hover fieldset': { borderColor: '#0071E3' },
									'&.Mui-focused fieldset': { borderColor: '#0071E3' }
								},
								'& label': { color: '#6E6E73' },
								'& input': { color: '#1D1D1F' }
							}}
						/>
					</DialogContent>
					<DialogActions sx={{ padding: '16px 24px', borderTop: '1px solid #E5E5E5' }}>
						<Button
							onClick={() => setOpenEditUser(false)}
							sx={{
								color: '#0071E3',
								textTransform: 'none',
								'&:hover': { color: '#FFFFFF', backgroundColor: '#0071E3' }
							}}
						>
							Отмена
						</Button>
						<Button
							onClick={handleSaveUser}
							variant="contained"
							sx={{
								backgroundColor: '#0071E3',
								color: '#FFFFFF',
								borderRadius: '12px',
								textTransform: 'none',
								'&:hover': { backgroundColor: '#005BB5' }
							}}
						>
							Сохранить
						</Button>
					</DialogActions>
				</Dialog>

				<Dialog
					open={openEditPublication}
					onClose={() => setOpenEditPublication(false)}
					sx={{
						'& .MuiDialog-paper': {
							backgroundColor: '#FFFFFF',
							boxShadow: '0 4px 12px 0 rgb(0 0 0 / 15%)',
							borderRadius: '12px',
							fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif"
						}
					}}
				>
					<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600, borderBottom: '1px solid #E5E5E5' }}>
						Редактировать публикацию
					</DialogTitle>
					<DialogContent sx={{ padding: '24px' }}>
						<TextField
							fullWidth
							label="Название"
							value={editPublicationData.title || ''}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, title: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{
								'& .MuiOutlinedInput-root': {
									'& fieldset': { borderColor: '#D1D1D6' },
									'&:hover fieldset': { borderColor: '#0071E3' },
									'&.Mui-focused fieldset': { borderColor: '#0071E3' }
								},
								'& label': { color: '#6E6E73' },
								'& input': { color: '#1D1D1F' }
							}}
						/>
						<TextField
							fullWidth
							label="Авторы"
							value={editPublicationData.authors || ''}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, authors: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{
								'& .MuiOutlinedInput-root': {
									'& fieldset': { borderColor: '#D1D1D6' },
									'&:hover fieldset': { borderColor: '#0071E3' },
									'&.Mui-focused fieldset': { borderColor: '#0071E3' }
								},
								'& label': { color: '#6E6E73' },
								'& input': { color: '#1D1D1F' }
							}}
						/>
						<TextField
							fullWidth
							label="Год"
							type="number"
							value={editPublicationData.year || ''}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, year: parseInt(e.target.value) || '' })}
							margin="normal"
							variant="outlined"
							sx={{
								'& .MuiOutlinedInput-root': {
									'& fieldset': { borderColor: '#D1D1D6' },
									'&:hover fieldset': { borderColor: '#0071E3' },
									'&.Mui-focused fieldset': { borderColor: '#0071E3' }
								},
								'& label': { color: '#6E6E73' },
								'& input': { color: '#1D1D1F' }
							}}
						/>
						<TextField
							fullWidth
							select
							label="Тип"
							value={editPublicationData.type || 'article'}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, type: e.target.value })}
							margin="normal"
							variant="outlined"
							sx={{
								'& .MuiOutlinedInput-root': {
									'& fieldset': { borderColor: '#D1D1D6' },
									'&:hover fieldset': { borderColor: '#0071E3' },
									'&.Mui-focused fieldset': { borderColor: '#0071E3' }
								},
								'& label': { color: '#6E6E73' },
								'& input': { color: '#1D1D1F' }
							}}
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
							sx={{
								'& .MuiOutlinedInput-root': {
									'& fieldset': { borderColor: '#D1D1D6' },
									'&:hover fieldset': { borderColor: '#0071E3' },
									'&.Mui-focused fieldset': { borderColor: '#0071E3' }
								},
								'& label': { color: '#6E6E73' },
								'& input': { color: '#1D1D1F' }
							}}
						>
							<MenuItem value="draft">Черновик</MenuItem>
							<MenuItem value="review">На проверке</MenuItem>
							<MenuItem value="published">Опубликовано</MenuItem>
						</TextField>
						<Box sx={{ mt: 2 }}>
							<Typography variant="body2" sx={{ color: '#6E6E73', mb: 1 }}>
								Текущий файл: {editPublicationData.file_url || 'Нет файла'}
							</Typography>
							<input
								type="file"
								accept=".pdf,.doc,.docx"
								onChange={(e) => setNewFile(e.target.files[0])}
								style={{ display: 'none' }}
								id="upload-file"
							/>
							<label htmlFor="upload-file">
								<Button
									variant="outlined"
									component="span"
									sx={{
										borderRadius: '12px',
										borderColor: '#D1D1D6',
										color: '#1D1D1F',
										textTransform: 'none',
										backgroundColor: '#FFFFFF',
										'&:hover': {
											borderColor: '#0071E3',
											backgroundColor: '#0071E3',
											color: '#FFFFFF'
										}
									}}
								>
									Выбрать файл
								</Button>
							</label>
							{newFile && <Typography sx={{ mt: 1, color: '#6E6E73' }}>{newFile.name}</Typography>}
						</Box>
					</DialogContent>
					<DialogActions sx={{ padding: '16px 24px', borderTop: '1px solid #E5E5E5' }}>
						<Button
							onClick={() => setOpenEditPublication(false)}
							sx={{
								color: '#0071E3',
								textTransform: 'none',
								'&:hover': { color: '#FFFFFF', backgroundColor: '#0071E3' }
							}}
						>
							Отмена
						</Button>
						<Button
							onClick={handleSavePublication}
							variant="contained"
							sx={{
								backgroundColor: '#0071E3',
								color: '#FFFFFF',
								borderRadius: '12px',
								textTransform: 'none',
								'&:hover': { backgroundColor: '#005BB5' }
							}}
						>
							Сохранить
						</Button>
					</DialogActions>
				</Dialog>
			</Box>
		</Container>
	);
}

export default AdminDashboard;
