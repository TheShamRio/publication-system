import React, { useState, useEffect } from 'react';
import { Container, Typography, Table, TableHead, TableRow, TableCell, TableBody, Paper, Grid, Card, CardContent, Button, TextField, Box, MenuItem, Alert, Collapse, Dialog, DialogTitle, DialogContent, DialogActions, IconButton } from '@mui/material';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import DeleteIcon from '@mui/icons-material/Delete';
import EditIcon from '@mui/icons-material/Edit';

function Dashboard() {
	const [publications, setPublications] = useState([]);
	const [analytics, setAnalytics] = useState([]);
	const [uploadType, setUploadType] = useState('file');
	const [title, setTitle] = useState('');
	const [authors, setAuthors] = useState('');
	const [year, setYear] = useState('');
	const [type, setType] = useState('article');
	const [file, setFile] = useState(null);
	const [error, setError] = useState('');
	const [success, setSuccess] = useState('');
	const [openError, setOpenError] = useState(false);
	const [openSuccess, setOpenSuccess] = useState(false);
	const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
	const [publicationToDelete, setPublicationToDelete] = useState(null);
	const [user, setUser] = useState(null); // Добавляем состояние для данных пользователя
	const navigate = useNavigate();
	const [openEditDialog, setOpenEditDialog] = useState(false);
	const [publicationToEdit, setPublicationToEdit] = useState(null);
	const [editTitle, setEditTitle] = useState('');
	const [editAuthors, setEditAuthors] = useState('');
	const [editYear, setEditYear] = useState('');
	const [editType, setEditType] = useState('article');
	const [editStatus, setEditStatus] = useState('draft');
	const typeMap = {
		article: 'Статья',
		monograph: 'Монография',
		conference: 'Доклад/конференция',
	};
	const statusMap = {
		draft: 'Черновик',
		review: 'На проверке',
		published: 'Опубликовано',
	};
	const handleEditClick = (publication) => {
		setPublicationToEdit(publication);
		setEditTitle(publication.title);
		setEditAuthors(publication.authors);
		setEditYear(publication.year);
		setEditType(publication.type);
		setEditStatus(publication.status);
		setOpenEditDialog(true);
	};

	const handleEditSubmit = async (e) => {
		e.preventDefault();
		if (!publicationToEdit) return;

		try {
			const response = await axios.put(`http://localhost:5000/api/publications/${publicationToEdit.id}`, {
				title: editTitle.trim(),
				authors: editAuthors.trim(),
				year: parseInt(editYear, 10),
				type: editType,
				status: editStatus,
			}, {
				withCredentials: true,
			});
			setSuccess('Публикация успешно отредактирована!');
			setOpenSuccess(true);
			setError('');
			setOpenEditDialog(false);
			const pubResponse = await axios.get('http://localhost:5000/api/publications', {
				withCredentials: true,
			});
			setPublications(pubResponse.data);
		} catch (err) {
			console.error('Ошибка редактирования публикации:', err);
			if (err.response?.status === 401) {
				navigate('/login');
			} else if (err.response?.status === 403) {
				setError('У вас нет прав на редактирование этой публикации.');
			} else if (err.response?.status === 400) {
				setError('Ошибка: ' + (err.response?.data?.error || 'Некорректные данные. Проверьте введенные поля.'));
			} else if (err.response?.status === 500) {
				setError('Произошла ошибка сервера. Попробуйте позже.');
			} else {
				setError('Ошибка редактирования публикации. Попробуйте позже.');
			}
			setOpenError(true);
			setSuccess('');
		}
	};

	const handleEditCancel = () => {
		setOpenEditDialog(false);
		setPublicationToEdit(null);
		setEditTitle('');
		setEditAuthors('');
		setEditYear('');
		setEditType('article');
		setEditStatus('draft');
	};

	useEffect(() => {
		const fetchData = async () => {
			try {
				const pubResponse = await axios.get('http://localhost:5000/api/publications', {
					withCredentials: true,
				});
				const analyticsResponse = await axios.get('http://localhost:5000/api/analytics/yearly', {
					withCredentials: true,
				});
				setPublications(pubResponse.data);
				setAnalytics(analyticsResponse.data);
			} catch (err) {
				console.error('Ошибка загрузки данных:', err);
				if (err.response?.status === 401) {
					setError('Необходимо войти в систему. Перенаправление...');
					setTimeout(() => navigate('/login'), 2000);
				} else if (err.response?.status === 403 || err.response?.status === 500) {
					setError('Произошла ошибка сервера. Попробуйте позже.');
				}
			}
		};

		const fetchUserData = async () => {
			try {
				const response = await axios.get('http://localhost:5000/api/user', {
					withCredentials: true,
				});
				setUser(response.data);
			} catch (err) {
				console.error('Ошибка загрузки данных пользователя:', err);
				if (err.response?.status === 401) {
					setError('Необходимо войти в систему. Перенаправление...');
					setTimeout(() => navigate('/login'), 2000);
				}
			}
		};

		fetchData();
		fetchUserData();
	}, [navigate]);

	const handleFileUpload = async (e) => {
		e.preventDefault();
		if (!file) {
			setError('Пожалуйста, выберите файл для загрузки.');
			setOpenError(true);
			return;
		}
		if (!title.trim() || !authors.trim() || !year) {
			setError('Пожалуйста, заполните все обязательные поля (название, авторы, год).');
			setOpenError(true);
			return;
		}

		const fileExtension = file.name.split('.').pop().toLowerCase();
		if (!['pdf', 'docx'].includes(fileExtension)) {
			setError('Разрешены только файлы в форматах PDF или DOCX.');
			setOpenError(true);
			return;
		}

		if (isNaN(year) || year < 1900 || year > new Date().getFullYear()) {
			setError('Год должен быть числом и находиться в разумных пределах (например, 1900–' + new Date().getFullYear() + ').');
			setOpenError(true);
			return;
		}

		const formData = new FormData();
		formData.append('file', file);
		formData.append('title', title.trim());
		formData.append('authors', authors.trim());
		formData.append('year', parseInt(year, 10));
		formData.append('type', type);

		try {
			const response = await axios.post('http://localhost:5000/api/publications/upload-file', formData, {
				headers: {
					'Content-Type': 'multipart/form-data',
				},
				withCredentials: true,
			});
			setSuccess('Публикация успешно загружена!');
			setOpenSuccess(true);
			setError('');
			setTitle('');
			setAuthors('');
			setYear('');
			setType('article');
			setFile(null);
			const pubResponse = await axios.get('http://localhost:5000/api/publications', {
				withCredentials: true,
			});
			setPublications(pubResponse.data);
		} catch (err) {
			console.error('Ошибка загрузки файла:', err);
			if (err.response?.status === 400) {
				setError('Ошибка: ' + (err.response?.data?.error || 'Некорректные данные. Проверьте введенные поля и файл.'));
			} else if (err.response?.status === 401) {
				navigate('/login');
			} else if (err.response?.status === 403 || err.response?.status === 500) {
				setError('Произошла ошибка сервера. Попробуйте позже.');
			} else {
				setError('Ошибка загрузки публикации. Попробуйте позже.');
			}
			setOpenError(true);
			setSuccess('');
		}
	};

	const handleBibtexUpload = async (e) => {
		e.preventDefault();
		if (!file) {
			setError('Пожалуйста, выберите BibTeX-файл для загрузки.');
			setOpenError(true);
			return;
		}

		const fileExtension = file.name.split('.').pop().toLowerCase();
		if (fileExtension !== 'bib') {
			setError('Разрешены только файлы в формате .bib.');
			setOpenError(true);
			return;
		}

		const formData = new FormData();
		formData.append('file', file);

		try {
			const response = await axios.post('http://localhost:5000/api/publications/upload-bibtex', formData, {
				headers: {
					'Content-Type': 'multipart/form-data',
				},
				withCredentials: true,
			});
			setSuccess(`Загружено ${response.data.message.split(' ')[1]} публикаций!`);
			setOpenSuccess(true);
			setError('');
			setFile(null);
			const pubResponse = await axios.get('http://localhost:5000/api/publications', {
				withCredentials: true,
			});
			setPublications(pubResponse.data);
		} catch (err) {
			console.error('Ошибка загрузки BibTeX:', err);
			if (err.response?.status === 400) {
				setError('Ошибка: ' + (err.response?.data?.error || 'Некорректный формат BibTeX. Проверьте файл.'));
			} else if (err.response?.status === 401) {
				navigate('/login');
			} else if (err.response?.status === 403 || err.response?.status === 500) {
				setError('Произошла ошибка сервера. Попробуйте позже.');
			} else {
				setError('Ошибка загрузки BibTeX. Попробуйте позже.');
			}
			setOpenError(true);
			setSuccess('');
		}
	};

	const handleDeleteClick = (publication) => {
		setPublicationToDelete(publication);
		setOpenDeleteDialog(true);
	};

	const handleDeleteConfirm = async () => {
		if (!publicationToDelete) return;

		try {
			await axios.delete(`http://localhost:5000/api/publications/${publicationToDelete.id}`, {
				withCredentials: true,
			});
			setSuccess('Публикация успешно удалена!');
			setOpenSuccess(true);
			setError('');
			const pubResponse = await axios.get('http://localhost:5000/api/publications', {
				withCredentials: true,
			});
			setPublications(pubResponse.data);
		} catch (err) {
			console.error('Ошибка удаления публикации:', err);
			if (err.response?.status === 401) {
				navigate('/login');
			} else if (err.response?.status === 403) {
				setError('У вас нет прав на удаление этой публикации.');
			} else if (err.response?.status === 500) {
				setError('Произошла ошибка сервера. Попробуйте позже.');
			} else {
				setError('Ошибка удаления публикации. Попробуйте позже.');
			}
			setOpenError(true);
			setSuccess('');
		}
		setOpenDeleteDialog(false);
		setPublicationToDelete(null);
	};

	const handleDeleteCancel = () => {
		setOpenDeleteDialog(false);
		setPublicationToDelete(null);
	};

	// Таймеры для автоматического исчезновения уведомлений
	useEffect(() => {
		if (openError || openSuccess) {
			const timer = setTimeout(() => {
				setOpenError(false);
				setOpenSuccess(false);
				setError('');
				setSuccess('');
			}, 5000);
			return () => clearTimeout(timer);
		}
	}, [openError, openSuccess]);

	return (
		<Container maxWidth="lg" sx={{ mt: 4, minHeight: 'calc(100vh - 64px - 120px)' }}>
			<Card elevation={4} sx={{ p: 4, borderRadius: 16, backgroundColor: 'white', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)' }}>
				<CardContent>
					<Typography variant="h4" gutterBottom sx={{ color: 'text.primary', fontWeight: 600 }}>
						Личный кабинет
					</Typography>

					{/* Отображение личных данных пользователя */}
					{user && (
						<Typography variant="h6" sx={{ mt: 2, color: 'text.primary' }}>
							Личные данные: {user.last_name} {user.first_name} {user.middle_name || ''}
						</Typography>
					)}

					{/* Форма загрузки публикаций */}
					<Typography variant="h5" gutterBottom sx={{ mt: 4, color: 'text.primary' }}>
						Загрузка публикаций
					</Typography>
					<Box sx={{ mb: 4 }}>
						<Box sx={{ mb: 2 }}>
							<Button
								variant="contained"
								color="primary"
								onClick={() => setUploadType('file')}
								sx={{ mr: 2, borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
							>
								Загрузить файл (PDF/DOCX)
							</Button>
							<Button
								variant="contained"
								color="primary"
								onClick={() => setUploadType('bibtex')}
								sx={{ borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
							>
								Загрузить BibTeX
							</Button>
						</Box>

						{uploadType === 'file' ? (
							<form onSubmit={handleFileUpload}>
								<TextField
									fullWidth
									label="Название"
									value={title}
									onChange={(e) => setTitle(e.target.value)}
									margin="normal"
									variant="outlined"
									sx={{ mb: 2, borderRadius: 8 }}
								/>
								<TextField
									fullWidth
									label="Авторы"
									value={authors}
									onChange={(e) => setAuthors(e.target.value)}
									margin="normal"
									variant="outlined"
									sx={{ mb: 2, borderRadius: 8 }}
								/>
								<TextField
									fullWidth
									label="Год"
									type="number"
									value={year}
									onChange={(e) => setYear(e.target.value)}
									margin="normal"
									variant="outlined"
									sx={{ mb: 2, borderRadius: 8 }}
								/>
								<TextField
									fullWidth
									select
									label="Тип публикации"
									value={type}
									onChange={(e) => setType(e.target.value)}
									margin="normal"
									variant="outlined"
									sx={{ mb: 2, borderRadius: 8 }}
								>
									<MenuItem value="article">Статья</MenuItem>
									<MenuItem value="monograph">Монография</MenuItem>
									<MenuItem value="conference">Доклад/конференция</MenuItem>
								</TextField>
								<Box sx={{ mb: 2 }}>
									<input
										type="file"
										accept=".pdf,.docx"
										onChange={(e) => setFile(e.target.files[0])}
										style={{ display: 'none' }}
										id="upload-file"
									/>
									<label htmlFor="upload-file">
										<Button
											variant="contained"
											component="span"
											color="primary"
											sx={{ borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
										>
											Выбрать файл
										</Button>
									</label>
									{file && <Typography sx={{ mt: 1, color: 'text.secondary' }}>{file.name}</Typography>}
								</Box>
								<Collapse in={openError}>
									{error && <Alert severity="error" sx={{ mb: 2, borderRadius: 8 }} onClose={() => setOpenError(false)}>{error}</Alert>}
								</Collapse>
								<Collapse in={openSuccess}>
									{success && <Alert severity="success" sx={{ mb: 2, borderRadius: 8 }} onClose={() => setOpenSuccess(false)}>{success}</Alert>}
								</Collapse>
								<Button
									type="submit"
									variant="contained"
									color="primary"
									sx={{ mt: 2, borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
								>
									Загрузить
								</Button>
							</form>
						) : (
							<form onSubmit={handleBibtexUpload}>
								<Box sx={{ mb: 2 }}>
									<input
										type="file"
										accept=".bib"
										onChange={(e) => setFile(e.target.files[0])}
										style={{ display: 'none' }}
										id="upload-bibtex"
									/>
									<label htmlFor="upload-bibtex">
										<Button
											variant="contained"
											component="span"
											color="primary"
											sx={{ borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
										>
											Выбрать BibTeX-файл
										</Button>
									</label>
									{file && <Typography sx={{ mt: 1, color: 'text.secondary' }}>{file.name}</Typography>}
								</Box>
								<Collapse in={openError}>
									{error && <Alert severity="error" sx={{ mb: 2, borderRadius: 8 }} onClose={() => setOpenError(false)}>{error}</Alert>}
								</Collapse>
								<Collapse in={openSuccess}>
									{success && <Alert severity="success" sx={{ mb: 2, borderRadius: 8 }} onClose={() => setOpenSuccess(false)}>{success}</Alert>}
								</Collapse>
								<Button
									type="submit"
									variant="contained"
									color="primary"
									sx={{ mt: 2, borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
								>
									Загрузить
								</Button>
							</form>
						)}
					</Box>

					{/* Список публикаций */}
					<Typography variant="h5" gutterBottom sx={{ mt: 4, color: 'text.primary' }}>
						Ваши публикации
					</Typography>
					<Table sx={{ mt: 2, boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)' }}>
						<TableHead>
							<TableRow sx={{ backgroundColor: 'primary.light' }}>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>ID</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Название</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Авторы</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Год</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Тип</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Статус</TableCell>
								<TableCell sx={{ fontWeight: 'bold', color: 'white' }}>Действия</TableCell>
							</TableRow>
						</TableHead>
						<TableBody>
							{publications.map((pub) => (
								<TableRow key={pub.id} sx={{ '&:hover': { backgroundColor: 'grey.100' } }}>
									<TableCell>{pub.id}</TableCell>
									<TableCell>{pub.title}</TableCell>
									<TableCell>{pub.authors}</TableCell>
									<TableCell>{pub.year}</TableCell>
									<TableCell>{typeMap[pub.type] || pub.type}</TableCell>
									<TableCell>{statusMap[pub.status] || pub.status}</TableCell>
									<TableCell>
										<IconButton
											aria-label="edit"
											onClick={() => handleEditClick(pub)}
											sx={{ color: 'primary.main', mr: 1, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.1)' } }}
										>
											<EditIcon />
										</IconButton>
										<IconButton
											aria-label="delete"
											onClick={() => handleDeleteClick(pub)}
											sx={{ color: 'primary.main', transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.1)' } }}
										>
											<DeleteIcon />
										</IconButton>
									</TableCell>
								</TableRow>
							))}
						</TableBody>
					</Table>
					<Dialog open={openEditDialog} onClose={handleEditCancel}>
						<DialogTitle sx={{ color: 'text.primary' }}>Редактировать публикацию</DialogTitle>
						<DialogContent>
							<form onSubmit={handleEditSubmit}>
								<TextField
									fullWidth
									label="Название"
									value={editTitle}
									onChange={(e) => setEditTitle(e.target.value)}
									margin="normal"
									variant="outlined"
									sx={{ mb: 2, borderRadius: 8 }}
								/>
								<TextField
									fullWidth
									label="Авторы"
									value={editAuthors}
									onChange={(e) => setEditAuthors(e.target.value)}
									margin="normal"
									variant="outlined"
									sx={{ mb: 2, borderRadius: 8 }}
								/>
								<TextField
									fullWidth
									label="Год"
									type="number"
									value={editYear}
									onChange={(e) => setEditYear(e.target.value)}
									margin="normal"
									variant="outlined"
									sx={{ mb: 2, borderRadius: 8 }}
								/>
								<TextField
									fullWidth
									select
									label="Тип публикации"
									value={editType}
									onChange={(e) => setEditType(e.target.value)}
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
									label="Статус публикации"
									value={editStatus}
									onChange={(e) => setEditStatus(e.target.value)}
									margin="normal"
									variant="outlined"
									sx={{ mb: 2, borderRadius: 8 }}
								>
									<MenuItem value="draft">Черновик</MenuItem>
									<MenuItem value="review">На проверке</MenuItem>
									<MenuItem value="published">Опубликовано</MenuItem>
								</TextField>
							</form>
						</DialogContent>
						<DialogActions>
							<Button
								onClick={handleEditCancel}
								sx={{ color: 'text.secondary', transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
							>
								Отмена
							</Button>
							<Button
								onClick={handleEditSubmit}
								variant="contained"
								color="primary"
								sx={{ borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
							>
								Сохранить
							</Button>
						</DialogActions>
					</Dialog>


					{/* Аналитика */}
					<Typography variant="h5" gutterBottom sx={{ mt: 4, color: 'text.primary' }}>
						Аналитика публикаций
					</Typography>
					{analytics.length === 0 ? (
						<Card elevation={2} sx={{ p: 4, mt: 2, borderRadius: 16, backgroundColor: 'background.paper', boxShadow: '0 2px 6px rgba(0, 0, 0, 0.1)' }}>
							<Typography variant="body1" sx={{ color: 'text.secondary', textAlign: 'center' }}>
								У вас ещё нет ни одной публикации.{' '}
								<Button
									variant="text"
									color="primary"
									onClick={() => setUploadType('file')}
									sx={{
										p: 0,
										textTransform: 'none',
										'&:hover': {
											textDecoration: 'underline',
											backgroundColor: 'transparent',
											color: 'primary.dark',
										},
									}}
								>
									Загрузите публикации
								</Button>
								, чтобы вести аналитику по своим работам.
							</Typography>
						</Card>
					) : (
						<Grid container spacing={2} sx={{ mt: 2 }}>
							{analytics.map((item) => (
								<Grid item xs={12} sm={6} key={item.year}>
									<Card elevation={2} sx={{ p: 2, borderRadius: 16, backgroundColor: 'background.paper', boxShadow: '0 2px 6px rgba(0, 0, 0, 0.1)' }}>
										<CardContent>
											<Typography variant="body1" sx={{ color: 'text.primary' }}>
												Год {item.year}: {item.count} публикаций
											</Typography>
										</CardContent>
									</Card>
								</Grid>
							))}
						</Grid>
					)}

					{/* Модальное окно подтверждения удаления */}
					<Dialog open={openDeleteDialog} onClose={handleDeleteCancel}>
						<DialogTitle sx={{ color: 'text.primary' }}>Подтвердите удаление</DialogTitle>
						<DialogContent>
							<Typography sx={{ color: 'text.secondary' }}>
								Вы уверены, что хотите удалить публикацию «{publicationToDelete?.title}»?
							</Typography>
						</DialogContent>
						<DialogActions>
							<Button
								onClick={handleDeleteCancel}
								sx={{ color: 'text.secondary', transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
							>
								Отмена
							</Button>
							<Button
								onClick={handleDeleteConfirm}
								variant="contained"
								color="primary"
								sx={{ borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
							>
								Удалить
							</Button>
						</DialogActions>
					</Dialog>
				</CardContent>
			</Card>
		</Container>
	);
}

export default Dashboard;