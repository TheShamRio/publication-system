import React, { useState, useEffect } from 'react';
import {
	Container,
	Typography,
	Tabs,
	Tab,
	Box,
	Table,
	TableHead,
	TableRow,
	TableCell,
	TableBody,
	Button,
	Dialog,
	DialogTitle,
	DialogContent,
	DialogActions,
	TextField,
	IconButton,
	CircularProgress,
	Alert,
	Pagination,
	Fade,
} from '@mui/material';
import MenuItem from '@mui/material/MenuItem';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import DownloadIcon from '@mui/icons-material/Download';
import axios from 'axios';
import { styled } from '@mui/system';

// Кастомные стили в стиле Apple
const AppleButton = styled(Button)(({ theme }) => ({
	borderRadius: '12px',
	textTransform: 'none',
	backgroundColor: '#0071E3',
	color: '#FFFFFF',
	padding: '8px 16px',
	fontSize: '14px',
	fontWeight: 600,
	boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
	'&:hover': {
		backgroundColor: '#0066CC',
		boxShadow: '0 4px 8px rgba(0, 0, 0, 0.1)',
	},
	'&:disabled': {
		backgroundColor: '#D1D1D6',
		color: '#FFFFFF',
	},
}));

const AppleTextField = styled(TextField)(({ theme }) => ({
	'& .MuiOutlinedInput-root': {
		borderRadius: '12px',
		backgroundColor: '#F5F5F7',
		'& fieldset': {
			borderColor: '#D1D1D6',
		},
		'&:hover fieldset': {
			borderColor: '#0071E3',
		},
		'&.Mui-focused fieldset': {
			borderColor: '#0071E3',
		},
	},
	'& label': {
		color: '#6E6E73',
	},
	'& input': {
		color: '#1D1D1F',
	},
	'& .MuiSelect-select': {
		backgroundColor: '#F5F5F7',
	},
}));

const AppleTable = styled(Table)(({ theme }) => ({
	borderRadius: '16px',
	overflow: 'hidden',
	backgroundColor: '#FFFFFF',
	boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
}));

const AppleCard = styled(Box)(({ theme }) => ({
	borderRadius: '16px',
	boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
	backgroundColor: '#F5F5F7',
	padding: '16px',
}));

const CancelButton = styled(Button)(({ theme }) => ({
	borderRadius: '12px',
	color: '#0071E3',
	textTransform: 'none',
	backgroundColor: 'transparent',
	'&:hover': {
		color: '#FFFFFF',
		backgroundColor: '#0071E3',
	},
}));

function AdminDashboard() {
	const [value, setValue] = useState(0);
	const [users, setUsers] = useState([]);
	const [publications, setPublications] = useState([]);
	const [loadingInitial, setLoadingInitial] = useState(true);
	const [error, setError] = useState(null);
	const [openEditUser, setOpenEditUser] = useState(false);
	const [openEditPublication, setOpenEditPublication] = useState(false);
	const [selectedUser, setSelectedUser] = useState(null);
	const [selectedPublication, setSelectedPublication] = useState(null);
	const [editUserData, setEditUserData] = useState({});
	const [editPublicationData, setEditPublicationData] = useState({});
	const [newFile, setNewFile] = useState(null);
	const [usersCurrentPage, setUsersCurrentPage] = useState(1);
	const [usersTotalPages, setUsersTotalPages] = useState(1);
	const [publicationsCurrentPage, setPublicationsCurrentPage] = useState(1);
	const [publicationsTotalPages, setPublicationsTotalPages] = useState(1);
	const [usersTransitionKey, setUsersTransitionKey] = useState(0);
	const [publicationsTransitionKey, setPublicationsTransitionKey] = useState(0);
	const itemsPerPage = 10;
	const navigate = useNavigate();
	const { isAuthenticated, role, csrfToken } = useAuth();

	// Состояния для поиска и фильтров
	const [usersSearchQuery, setUsersSearchQuery] = useState('');
	const [publicationsSearchQuery, setPublicationsSearchQuery] = useState('');
	const [publicationsFilterType, setPublicationsFilterType] = useState('all');
	const [publicationsFilterStatus, setPublicationsFilterStatus] = useState('all');

	const fetchUsers = async (page = 1, search = '') => {
		try {
			console.log(`Fetching users from http://localhost:5000/admin_api/admin/users?page=${page}&per_page=${itemsPerPage}&search=${search}...`);
			const response = await axios.get('http://localhost:5000/admin_api/admin/users', {
				withCredentials: true,
				params: {
					page,
					per_page: itemsPerPage,
					search,
				},
			});
			console.log('Users response data:', response.data);
			const usersData = Array.isArray(response.data.users) ? response.data.users : response.data;
			setUsers(usersData);
			setUsersTotalPages(Math.ceil(response.data.total / itemsPerPage) || 1);
			setUsersTransitionKey((prev) => prev + 1);
			setError(null);
		} catch (err) {
			console.error('Ошибка загрузки пользователей:', err.response?.status, err.response?.data || err.message);
			setError(err.response?.data?.error || `Ошибка: ${err.response?.status || 'Неизвестная ошибка'}`);
		} finally {
			setLoadingInitial(false);
		}
	};

	const fetchPublications = async (page = 1, search = '', pubType = 'all', status = 'all') => {
		try {
			console.log(`Fetching publications from http://localhost:5000/admin_api/admin/publications?page=${page}&per_page=${itemsPerPage}&search=${search}&type=${pubType}&status=${status}...`);
			const response = await axios.get('http://localhost:5000/admin_api/admin/publications', {
				withCredentials: true,
				params: {
					page,
					per_page: itemsPerPage,
					search,
					type: pubType,
					status,
				},
			});
			console.log('Publications response data:', response.data);
			const publicationsData = Array.isArray(response.data.publications) ? response.data.publications : response.data;
			setPublications(publicationsData);
			setPublicationsTotalPages(Math.ceil(response.data.total / itemsPerPage) || 1);
			setPublicationsTransitionKey((prev) => prev + 1);
			setError(null);
		} catch (err) {
			console.error('Ошибка загрузки публикаций:', err.response?.status, err.response?.data || err.message);
			setError(err.response?.data?.error || `Ошибка: ${err.response?.status || 'Неизвестная ошибка'}`);
		} finally {
			setLoadingInitial(false);
		}
	};

	useEffect(() => {
		if (!isAuthenticated || role !== 'admin') {
			navigate('/login');
			return;
		}
		fetchUsers(usersCurrentPage, usersSearchQuery);
		fetchPublications(publicationsCurrentPage, publicationsSearchQuery, publicationsFilterType, publicationsFilterStatus);
	}, [isAuthenticated, role, navigate]);

	useEffect(() => {
		fetchUsers(usersCurrentPage, usersSearchQuery);
	}, [usersCurrentPage, usersSearchQuery]);

	useEffect(() => {
		fetchPublications(publicationsCurrentPage, publicationsSearchQuery, publicationsFilterType, publicationsFilterStatus);
	}, [publicationsCurrentPage, publicationsSearchQuery, publicationsFilterType, publicationsFilterStatus]);

	const handleTabChange = (event, newValue) => {
		setValue(newValue);
	};

	const handleUsersPageChange = (event, newPage) => {
		setUsersCurrentPage(newPage);
	};

	const handlePublicationsPageChange = (event, newPage) => {
		setPublicationsCurrentPage(newPage);
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
			const response = await axios.put(
				`http://localhost:5000/admin_api/admin/users/${selectedUser.id}`,
				editUserData,
				{
					withCredentials: true,
					headers: {
						'X-CSRFToken': csrfToken,
					},
				}
			);
			console.log('User update response:', response.data);
			setUsers(users.map((u) => (u.id === selectedUser.id ? { ...u, ...editUserData } : u)));
			setOpenEditUser(false);
			fetchUsers(usersCurrentPage, usersSearchQuery);
		} catch (err) {
			console.error('Ошибка обновления пользователя:', err.response?.status, err.response?.data || err.message);
			setError(err.response?.data?.error || `Ошибка: ${err.response?.status || 'Неизвестная ошибка'}`);
		}
	};

	const handleSavePublication = async () => {
		try {
			console.log('Updating publication:', editPublicationData);
			let data;
			let headers = {
				'X-CSRFToken': csrfToken,
			};
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
					status: editPublicationData.status || 'draft',
				};
				headers['Content-Type'] = 'application/json';
			}

			const response = await axios.put(
				`http://localhost:5000/admin_api/admin/publications/${selectedPublication.id}`,
				data,
				{
					withCredentials: true,
					headers,
				}
			);
			console.log('Publication update response:', response.data);
			setPublications(publications.map((p) => (p.id === selectedPublication.id ? { ...p, ...response.data.publication } : p)));
			setOpenEditPublication(false);
			fetchPublications(publicationsCurrentPage, publicationsSearchQuery, publicationsFilterType, publicationsFilterStatus);
		} catch (err) {
			console.error('Ошибка обновления публикации:', err.response?.status, err.response?.data || err.message);
			setError(err.response?.data?.error || `Ошибка: ${err.response?.status || 'Неизвестная ошибка'}`);
		}
	};

	const handleDeleteUser = async (userId) => {
		try {
			console.log('Deleting user with ID:', userId);
			const response = await axios.delete(
				`http://localhost:5000/admin_api/admin/users/${userId}`,
				{
					withCredentials: true,
					headers: {
						'X-CSRFToken': csrfToken,
					},
				}
			);
			console.log('User deletion response:', response.data);
			fetchUsers(usersCurrentPage, usersSearchQuery);
		} catch (err) {
			console.error('Ошибка удаления пользователя:', err.response?.status, err.response?.data || err.message);
			setError(err.response?.data?.error || `Ошибка: ${err.response?.status || 'Неизвестная ошибка'}`);
		}
	};

	const handleDeletePublication = async (publicationId) => {
		try {
			console.log('Deleting publication with ID:', publicationId);
			const response = await axios.delete(
				`http://localhost:5000/admin_api/admin/publications/${publicationId}`,
				{
					withCredentials: true,
					headers: {
						'X-CSRFToken': csrfToken,
					},
				}
			);
			console.log('Publication deletion response:', response.data);
			fetchPublications(publicationsCurrentPage, publicationsSearchQuery, publicationsFilterType, publicationsFilterStatus);
		} catch (err) {
			console.error('Ошибка удаления публикации:', err.response?.status, err.response?.data || err.message);
			setError(err.response?.data?.error || `Ошибка: ${err.response?.status || 'Неизвестная ошибка'}`);
		}
	};

	const handleDownloadClick = (publication) => {
		console.log('Downloading file for publication:', publication.id);
		if (!publication.file_url) {
			setError('Файл не прикреплен к этой публикации.');
			return;
		}
		const normalizedUrl = publication.file_url.replace(/^.*uploads/, 'uploads');
		const link = document.createElement('a');
		link.href = `http://localhost:5000/${normalizedUrl}`;
		link.download = normalizedUrl.split('/').pop();
		document.body.appendChild(link);
		link.click();
		document.body.removeChild(link);
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
				fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif",
			}}
		>
			<Box sx={{ p: 4 }}>
				<Typography variant="h4" gutterBottom sx={{ color: '#1D1D1F', fontWeight: 600, textAlign: 'center' }}>
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
							'&.Mui-selected': { color: '#1D1D1F' },
						},
						'& .MuiTabs-indicator': { backgroundColor: '#0071E3' },
					}}
				>
					<Tab label="Пользователи" />
					<Tab label="Публикации" />
				</Tabs>

				{loadingInitial ? (
					<Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
						<CircularProgress sx={{ color: '#0071E3' }} />
					</Box>
				) : (
					<>
						{error && (
							<Alert
								severity="error"
								sx={{ mt: 4, borderRadius: '12px', backgroundColor: '#FFF1F0', color: '#1D1D1F' }}
							>
								{error}
							</Alert>
						)}

						{value === 0 && (
							<>
								<AppleCard sx={{ mb: 2 }}>
									<AppleTextField
										fullWidth
										label="Поиск по логину, ФИО"
										value={usersSearchQuery}
										onChange={(e) => setUsersSearchQuery(e.target.value)}
										margin="normal"
										variant="outlined"
									/>
								</AppleCard>
								{users.length === 0 ? (
									<Typography sx={{ mt: 4, textAlign: 'center', color: '#6E6E73' }}>
										Нет пользователей для отображения.
									</Typography>
								) : (
									<>
										<AppleTable>
											<TableHead>
												<TableRow sx={{ backgroundColor: '#0071E3' }}>
													<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>ID</TableCell>
													<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Логин</TableCell>
													<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Роль</TableCell>
													<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', textAlign: 'center' }}>Действия</TableCell>
												</TableRow>
											</TableHead>
											<Fade in={true} timeout={500} key={usersTransitionKey}>
												<TableBody>
													{users.map((user) => (
														<TableRow
															key={user.id}
															sx={{ '&:hover': { backgroundColor: '#E5E5E5', transition: 'background-color 0.3s ease' } }}
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
																			'&:hover': { color: '#FFFFFF', backgroundColor: '#0071E3', borderRadius: '12px' },
																		}}
																	>
																		<EditIcon />
																	</IconButton>
																	<IconButton
																		onClick={() => handleDeleteUser(user.id)}
																		sx={{
																			color: '#0071E3',
																			'&:hover': { color: '#FFFFFF', backgroundColor: '#0071E3', borderRadius: '12px' },
																		}}
																	>
																		<DeleteIcon />
																	</IconButton>
																</Box>
															</TableCell>
														</TableRow>
													))}
												</TableBody>
											</Fade>
										</AppleTable>
										<Box sx={{ mt: 2, display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
											<Pagination
												count={usersTotalPages}
												page={usersCurrentPage}
												onChange={handleUsersPageChange}
												color="primary"
												sx={{
													'& .MuiPaginationItem-root': {
														borderRadius: 20,
														transition: 'all 0.3s ease',
														'&:hover': { backgroundColor: 'grey.100', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)' },
														'&.Mui-selected': { backgroundColor: '#1976D2', color: 'white', boxShadow: '0 6px 16px rgba(0, 0, 0, 0.2)' },
													},
												}}
											/>
										</Box>
									</>
								)}
							</>
						)}

						{value === 1 && (
							<>
								<AppleCard sx={{ mb: 2 }}>
									<AppleTextField
										fullWidth
										label="Поиск по названию, авторам или году"
										value={publicationsSearchQuery}
										onChange={(e) => setPublicationsSearchQuery(e.target.value)}
										margin="normal"
										variant="outlined"
									/>
									<Box sx={{ mt: 2, display: 'flex', gap: 2 }}>
										<AppleTextField
											select
											label="Тип публикации"
											value={publicationsFilterType}
											onChange={(e) => setPublicationsFilterType(e.target.value)}
											margin="normal"
											variant="outlined"
										>
											<MenuItem value="all">Все</MenuItem>
											<MenuItem value="article">Статья</MenuItem>
											<MenuItem value="monograph">Монография</MenuItem>
											<MenuItem value="conference">Доклад/конференция</MenuItem>
										</AppleTextField>
										<AppleTextField
											select
											label="Статус"
											value={publicationsFilterStatus}
											onChange={(e) => setPublicationsFilterStatus(e.target.value)}
											margin="normal"
											variant="outlined"
										>
											<MenuItem value="all">Все</MenuItem>
											<MenuItem value="draft">Черновик</MenuItem>
											<MenuItem value="review">На проверке</MenuItem>
											<MenuItem value="published">Опубликованные</MenuItem>
										</AppleTextField>
									</Box>
								</AppleCard>
								{publications.length === 0 ? (
									<Typography sx={{ mt: 4, textAlign: 'center', color: '#6E6E73' }}>
										Нет публикаций для отображения.
									</Typography>
								) : (
									<>
										<AppleTable>
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
											<Fade in={true} timeout={500} key={publicationsTransitionKey}>
												<TableBody>
													{publications.map((pub) => (
														<TableRow
															key={pub.id}
															sx={{ '&:hover': { backgroundColor: '#E5E5E5', transition: 'background-color 0.3s ease' } }}
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
																			'&:hover': { color: '#FFFFFF', backgroundColor: '#0071E3', borderRadius: '12px' },
																		}}
																	>
																		<EditIcon />
																	</IconButton>
																	<IconButton
																		onClick={() => handleDeletePublication(pub.id)}
																		sx={{
																			color: '#0071E3',
																			'&:hover': { color: '#FFFFFF', backgroundColor: '#0071E3', borderRadius: '12px' },
																		}}
																	>
																		<DeleteIcon />
																	</IconButton>
																	<IconButton
																		onClick={() => handleDownloadClick(pub)}
																		disabled={!pub.file_url}
																		sx={{
																			color: pub.file_url ? '#0071E3' : '#D1D1D6',
																			'&:hover': pub.file_url
																				? { color: '#FFFFFF', backgroundColor: '#0071E3', borderRadius: '12px' }
																				: {},
																		}}
																	>
																		<DownloadIcon />
																	</IconButton>
																</Box>
															</TableCell>
														</TableRow>
													))}
												</TableBody>
											</Fade>
										</AppleTable>
										<Box sx={{ mt: 2, display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
											<Pagination
												count={publicationsTotalPages}
												page={publicationsCurrentPage}
												onChange={handlePublicationsPageChange}
												color="primary"
												sx={{
													'& .MuiPaginationItem-root': {
														borderRadius: 20,
														transition: 'all 0.3s ease',
														'&:hover': { backgroundColor: 'grey.100', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)' },
														'&.Mui-selected': { backgroundColor: '#1976D2', color: 'white', boxShadow: '0 6px 16px rgba(0, 0, 0, 0.2)' },
													},
												}}
											/>
										</Box>
									</>
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
							fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif",
						},
					}}
				>
					<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600, borderBottom: '1px solid #E5E5E5' }}>
						Редактировать пользователя
					</DialogTitle>
					<DialogContent sx={{ padding: '24px' }}>
						<AppleTextField
							fullWidth
							label="Логин"
							value={editUserData.username || ''}
							onChange={(e) => setEditUserData({ ...editUserData, username: e.target.value })}
							margin="normal"
							variant="outlined"
						/>
						<AppleTextField
							fullWidth
							select
							label="Роль"
							value={editUserData.role || 'user'}
							onChange={(e) => setEditUserData({ ...editUserData, role: e.target.value })}
							margin="normal"
							variant="outlined"
						>
							<MenuItem value="user">Пользователь</MenuItem>
							<MenuItem value="admin">Администратор</MenuItem>
						</AppleTextField>
						<AppleTextField
							fullWidth
							label="Фамилия"
							value={editUserData.last_name || ''}
							onChange={(e) => setEditUserData({ ...editUserData, last_name: e.target.value })}
							margin="normal"
							variant="outlined"
						/>
						<AppleTextField
							fullWidth
							label="Имя"
							value={editUserData.first_name || ''}
							onChange={(e) => setEditUserData({ ...editUserData, first_name: e.target.value })}
							margin="normal"
							variant="outlined"
						/>
						<AppleTextField
							fullWidth
							label="Отчество"
							value={editUserData.middle_name || ''}
							onChange={(e) => setEditUserData({ ...editUserData, middle_name: e.target.value })}
							margin="normal"
							variant="outlined"
						/>
					</DialogContent>
					<DialogActions sx={{ padding: '16px 24px', borderTop: '1px solid #E5E5E5' }}>
						<CancelButton onClick={() => setOpenEditUser(false)}>Отмена</CancelButton>
						<AppleButton onClick={handleSaveUser}>Сохранить</AppleButton>
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
							fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif",
						},
					}}
				>
					<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600, borderBottom: '1px solid #E5E5E5' }}>
						Редактировать публикацию
					</DialogTitle>
					<DialogContent sx={{ padding: '24px' }}>
						<AppleTextField
							fullWidth
							label="Название"
							value={editPublicationData.title || ''}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, title: e.target.value })}
							margin="normal"
							variant="outlined"
						/>
						<AppleTextField
							fullWidth
							label="Авторы"
							value={editPublicationData.authors || ''}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, authors: e.target.value })}
							margin="normal"
							variant="outlined"
						/>
						<AppleTextField
							fullWidth
							label="Год"
							type="number"
							value={editPublicationData.year || ''}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, year: parseInt(e.target.value) || '' })}
							margin="normal"
							variant="outlined"
						/>
						<AppleTextField
							fullWidth
							select
							label="Тип"
							value={editPublicationData.type || 'article'}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, type: e.target.value })}
							margin="normal"
							variant="outlined"
						>
							<MenuItem value="article">Статья</MenuItem>
							<MenuItem value="monograph">Монография</MenuItem>
							<MenuItem value="conference">Доклад/конференция</MenuItem>
						</AppleTextField>
						<AppleTextField
							fullWidth
							select
							label="Статус"
							value={editPublicationData.status || 'draft'}
							onChange={(e) => setEditPublicationData({ ...editPublicationData, status: e.target.value })}
							margin="normal"
							variant="outlined"
						>
							<MenuItem value="draft">Черновик</MenuItem>
							<MenuItem value="review">На проверке</MenuItem>
							<MenuItem value="published">Опубликовано</MenuItem>
						</AppleTextField>
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
								<AppleButton sx={{ border: '1px solid #D1D1D6', backgroundColor: '#F5F5F7', color: '#1D1D1F' }} component="span">
									Выбрать файл
								</AppleButton>
							</label>
							{newFile && <Typography sx={{ mt: 1, color: '#6E6E73' }}>{newFile.name}</Typography>}
						</Box>
					</DialogContent>
					<DialogActions sx={{ padding: '16px 24px', borderTop: '1px solid #E5E5E5' }}>
						<CancelButton onClick={() => setOpenEditPublication(false)}>Отмена</CancelButton>
						<AppleButton onClick={handleSavePublication}>Сохранить</AppleButton>
					</DialogActions>
				</Dialog>
			</Box>
		</Container>
	);
}

export default AdminDashboard;