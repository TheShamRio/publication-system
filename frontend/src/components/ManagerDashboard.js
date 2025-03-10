import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import {
	Container,
	Typography,
	Card as AppleCard,
	Tabs,
	Tab,
	Box,
	CircularProgress,
	Table,
	TableBody,
	TableCell,
	TableHead,
	TableRow,
	IconButton,
	Dialog,
	DialogTitle,
	DialogContent,
	DialogActions,
	TextField,
	Collapse,
	Alert,
	Pagination,
	Fade,
	MenuItem,
	Button,
} from '@mui/material';
import { styled } from '@mui/system';
import DeleteIcon from '@mui/icons-material/Delete';
import DownloadIcon from '@mui/icons-material/Download';
import CheckIcon from '@mui/icons-material/Check';
import ReplayIcon from '@mui/icons-material/Replay';
import RefreshIcon from '@mui/icons-material/Refresh';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import Visibility from '@mui/icons-material/Visibility';
import VisibilityOff from '@mui/icons-material/VisibilityOff';
import axios from 'axios';
import { useAuth } from '../contexts/AuthContext';
import StatusChip from './StatusChip';

const AppleTextField = styled(TextField)({
	'& .MuiOutlinedInput-root': {
		borderRadius: '12px',
		backgroundColor: '#F5F5F7',
		'& fieldset': { borderColor: '#D1D1D6' },
		'&:hover fieldset': { borderColor: '#0071E3' },
		'&.Mui-focused fieldset': { borderColor: '#0071E3' },
	},
	'& .MuiInputLabel-root': { color: '#6E6E73' },
	'& .MuiInputLabel-root.Mui-focused': { color: '#0071E3' },
});

const AppleTable = styled(Table)({
	borderCollapse: 'separate',
	borderSpacing: '0 8px',
});

const PlanTable = styled(Table)({
	borderCollapse: 'separate',
	borderSpacing: '0 8px',
	'& td, & th': { border: 'none' },
});

const AppleButton = styled(Button)({
	borderRadius: '12px',
	textTransform: 'none',
	backgroundColor: '#0071E3',
	color: '#FFFFFF',
	padding: '8px 16px',
	fontSize: '14px',
	fontWeight: 600,
	boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
	'&:hover': { backgroundColor: '#0066CC', boxShadow: '0 4px 8px rgba(0, 0, 0, 0.1)' },
});

const GreenButton = styled(Button)({
	borderRadius: '12px',
	textTransform: 'none',
	backgroundColor: 'green',
	color: '#FFFFFF',
	padding: '8px 16px',
	fontSize: '14px',
	fontWeight: 600,
	boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
	'&:hover': { backgroundColor: '#2EBB4A', boxShadow: '0 4px 8px rgba(0, 0, 0, 0.1)' },
});

const CancelButton = styled(Button)({
	borderRadius: '12px',
	textTransform: 'none',
	backgroundColor: '#D1D1D6',
	color: '#1D1D1F',
	padding: '8px 16px',
	fontSize: '14px',
	fontWeight: 600,
	boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
	'&:hover': { backgroundColor: '#C7C7CC', boxShadow: '0 4px 8px rgba(0, 0, 0, 0.1)' },
});

function ManagerDashboard() {
	const { user, csrfToken, isAuthenticated } = useAuth();
	const navigate = useNavigate();
	const [value, setValue] = useState(0);
	const [needsReviewPublications, setNeedsReviewPublications] = useState([]);
	const [plans, setPlans] = useState([]);
	const [currentPageNeedsReview, setCurrentPageNeedsReview] = useState(1);
	const [currentPagePlans, setCurrentPagePlans] = useState(1);
	const [totalPagesNeedsReview, setTotalPagesNeedsReview] = useState(1);
	const [totalPagesPlans, setTotalPagesPlans] = useState(1);
	const [searchQuery, setSearchQuery] = useState('');
	const [loadingInitial, setLoadingInitial] = useState(true);
	const [openEditDialog, setOpenEditDialog] = useState(false);
	const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
	const [publicationToDelete, setPublicationToDelete] = useState(null);
	const [editPublication, setEditPublication] = useState(null);
	const [editTitle, setEditTitle] = useState('');
	const [editAuthors, setEditAuthors] = useState('');
	const [editYear, setEditYear] = useState('');
	const [editType, setEditType] = useState('article');
	const [editStatus, setEditStatus] = useState('needs_review');
	const [editFile, setEditFile] = useState(null);
	const [error, setError] = useState('');
	const [success, setSuccess] = useState('');
	const [openError, setOpenError] = useState(false);
	const [openSuccess, setOpenSuccess] = useState(false);
	const [newLastName, setNewLastName] = useState('');
	const [newFirstName, setNewFirstName] = useState('');
	const [newMiddleName, setNewMiddleName] = useState('');
	const [newUsername, setNewUsername] = useState('');
	const [newPassword, setNewPassword] = useState('');
	const [showPassword, setShowPassword] = useState(false);
	const [openReturnDialog, setOpenReturnDialog] = useState(false);
	const [selectedPlan, setSelectedPlan] = useState(null);
	const [returnComment, setReturnComment] = useState('');

	const handleDownload = async (fileUrl, fileName) => {
		// Проверяем, что fileUrl существует и является строкой
		if (!fileUrl || typeof fileUrl !== 'string' || fileUrl.trim() === '') {
			console.error('Некорректный fileUrl:', fileUrl);
			setError('Некорректный URL файла. Обратитесь к администратору.');
			setOpenError(true);
			return;
		}

		// Убеждаемся, что fileUrl начинается с '/', если это относительный путь
		const normalizedFileUrl = fileUrl.startsWith('/') ? fileUrl : `/${fileUrl}`;
		const fullUrl = `http://localhost:5000${normalizedFileUrl}`;
		console.log('Попытка скачать файл с URL:', fullUrl);

		try {
			const response = await axios.get(fullUrl, {
				responseType: 'blob',
				withCredentials: true,
				headers: {
					'X-CSRFToken': csrfToken,
				},
			});

			const blob = new Blob([response.data]);
			const url = window.URL.createObjectURL(blob);
			const link = document.createElement('a');
			link.href = url;
			link.download = fileName || normalizedFileUrl.split('/').pop();
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
			window.URL.revokeObjectURL(url);
		} catch (err) {
			console.error('Ошибка при скачивании файла:', err);
			if (err.response) {
				setError(`Ошибка сервера: ${err.response.status}. Не удалось скачать файл.`);
			} else {
				setError('Не удалось скачать файл. Проверьте подключение или URL.');
			}
			setOpenError(true);
		}
	};

	useEffect(() => {
		if (!isAuthenticated || user.role !== 'manager') navigate('/login');
		fetchNeedsReviewPublications(currentPageNeedsReview);
		fetchPlans(currentPagePlans);
		setLoadingInitial(false);
	}, [isAuthenticated, user, navigate, currentPageNeedsReview, currentPagePlans]);

	const fetchNeedsReviewPublications = async (page) => {
		try {
			const response = await axios.get(`http://localhost:5000/admin_api/admin/publications/needs-review?page=${page}&per_page=10&search=${searchQuery}`, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});
			setNeedsReviewPublications(response.data.publications);
			setTotalPagesNeedsReview(response.data.pages);
		} catch (err) {
			console.error('Ошибка загрузки публикаций:', err);
			setError('Не удалось загрузить публикации. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const fetchPlans = async (page) => {
		try {
			const response = await axios.get(`http://localhost:5000/admin_api/admin/plans?page=${page}&per_page=10`, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});
			setPlans(response.data.plans);
			setTotalPagesPlans(response.data.pages);
		} catch (err) {
			console.error('Ошибка загрузки планов:', err);
			setError('Не удалось загрузить планы. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const handleTabChange = (event, newValue) => {
		setValue(newValue);
	};

	const handleSearchChange = (event) => {
		setSearchQuery(event.target.value);
		fetchNeedsReviewPublications(1);
	};

	const handlePageChangeNeedsReview = (event, value) => {
		setCurrentPageNeedsReview(value);
		fetchNeedsReviewPublications(value);
	};

	const handlePageChangePlans = (event, value) => {
		setCurrentPagePlans(value);
		fetchPlans(value);
	};

	const handleEditClick = (publication) => {
		setEditPublication(publication);
		setEditTitle(publication.title);
		setEditAuthors(publication.authors);
		setEditYear(publication.year);
		setEditType(publication.type);
		setEditStatus(publication.status);
		setEditFile(null);
		setOpenEditDialog(true);
	};

	const handleEditCancel = () => {
		setOpenEditDialog(false);
		setEditPublication(null);
		setEditTitle('');
		setEditAuthors('');
		setEditYear('');
		setEditType('article');
		setEditStatus('needs_review');
		setEditFile(null);
		setError('');
		setSuccess('');
	};

	const handleEditSubmit = async (event) => {
		event.preventDefault();
		if (!editTitle.trim() || !editAuthors.trim() || !editYear || editYear < 1900 || editYear > new Date().getFullYear()) {
			setError('Проверьте поля: название, авторы и год должны быть заполнены корректно.');
			setOpenError(true);
			return;
		}

		const formData = new FormData();
		formData.append('title', editTitle);
		formData.append('authors', editAuthors);
		formData.append('year', editYear);
		formData.append('type', editType);
		formData.append('status', editStatus);
		if (editFile) formData.append('file', editFile);

		try {
			const response = await axios.put(`http://localhost:5000/admin_api/admin/publications/${editPublication.id}`, formData, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken, 'Content-Type': 'multipart/form-data' },
			});
			setSuccess('Публикация успешно обновлена!');
			setOpenSuccess(true);
			fetchNeedsReviewPublications(currentPageNeedsReview);
			handleEditCancel();
		} catch (err) {
			console.error('Ошибка обновления публикации:', err);
			setError('Не удалось обновить публикацию. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const handleDeletePlanClick = (publication) => {
		setPublicationToDelete(publication);
		setOpenDeleteDialog(true);
	};

	const handleDeletePlanConfirm = async () => {
		if (publicationToDelete) {
			try {
				await axios.delete(`http://localhost:5000/admin_api/admin/publications/${publicationToDelete.id}`, {
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				});
				setSuccess('Публикация успешно удалена!');
				setOpenSuccess(true);
				fetchNeedsReviewPublications(currentPageNeedsReview);
				setOpenDeleteDialog(false);
				setPublicationToDelete(null);
			} catch (err) {
				console.error('Ошибка удаления публикации:', err);
				setError('Не удалось удалить публикацию. Попробуйте позже.');
				setOpenError(true);
			}
		}
	};

	const handleApprovePlan = async (plan) => {
		try {
			await axios.post(`http://localhost:5000/admin_api/admin/plans/${plan.id}/approve`, {}, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});
			setSuccess('План утверждён!');
			setOpenSuccess(true);
			fetchPlans(currentPagePlans);
		} catch (err) {
			console.error('Ошибка утверждения плана:', err);
			setError('Не удалось утвердить план. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const handleOpenReturnDialog = (plan) => {
		setSelectedPlan(plan);
		setReturnComment('');
		setOpenReturnDialog(true);
	};

	const handleReturnForRevision = async () => {
		if (!returnComment.trim()) {
			setError('Комментарий обязателен.');
			setOpenError(true);
			return;
		}
		try {
			await axios.post(
				`http://localhost:5000/admin_api/admin/plans/${selectedPlan.id}/return-for-revision`,
				{ comment: returnComment },
				{ withCredentials: true, headers: { 'X-CSRFToken': csrfToken } }
			);
			setSuccess('План возвращён на доработку!');
			setOpenSuccess(true);
			fetchPlans(currentPagePlans);
			setOpenReturnDialog(false);
		} catch (err) {
			console.error('Ошибка возврата плана:', err);
			setError('Не удалось вернуть план. Попробуйте позже.');
			setOpenError(true);
		}
	};

	return (
		<Container maxWidth="lg" sx={{ mt: 8, mb: 4 }}>
			<AppleCard elevation={4} sx={{ p: 4, borderRadius: '16px', backgroundColor: '#FFFFFF' }}>
				<Typography variant="h4" sx={{ color: '#1D1D1F', fontWeight: 600, textAlign: 'center' }}>
					Панель управляющего
				</Typography>
				<Tabs
					value={value}
					onChange={handleTabChange}
					centered
					sx={{
						mb: 4,
						'& .MuiTab-root': { color: '#6E6E73', fontWeight: 600 },
						'& .MuiTab-root.Mui-selected': { color: '#0071E3' },
						'& .MuiTabs-indicator': { backgroundColor: '#0071E3' },
					}}
				>
					<Tab label="Работы на проверке" />
					<Tab label="Статистика по кафедре" />
					<Tab label="Регистрация пользователей" />
					<Tab label="Работа с планами" />
				</Tabs>

				{loadingInitial ? (
					<Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
						<CircularProgress sx={{ color: '#0071E3' }} />
					</Box>
				) : (
					<>
						{value === 0 && (
							<>
								<Typography variant="h5" gutterBottom sx={{ mt: 4, color: '#1D1D1F', fontWeight: 600, textAlign: 'center' }}>
									Работы на проверке
								</Typography>
								<AppleCard sx={{ mt: 2, mb: 2, p: 2, backgroundColor: '#F5F5F7', borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
									<AppleTextField
										fullWidth
										label="Поиск по названию, авторам или году"
										value={searchQuery}
										onChange={handleSearchChange}
										margin="normal"
										variant="outlined"
										InputProps={{
											endAdornment: <IconButton sx={{ color: '#0071E3' }}></IconButton>,
										}}
									/>
								</AppleCard>
								<AppleTable sx={{ mt: 2, boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
									<TableHead>
										<TableRow sx={{ backgroundColor: '#0071E3' }}>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', borderRadius: '12px 0 0 0' }}>ID</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Название</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Авторы</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Год</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Тип</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Статус</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Пользователь</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', textAlign: 'center', borderRadius: '0 12px 0 0' }}>
												Действия
											</TableCell>
										</TableRow>
									</TableHead>
									<Fade in={true} timeout={500}>
										<TableBody>
											{needsReviewPublications.length > 0 ? (
												needsReviewPublications.map((pub) => (
													<TableRow
														key={pub.id}
														sx={{
															'&:hover': { backgroundColor: '#F5F5F7', transition: 'background-color 0.3s ease' },
														}}
													>
														<TableCell sx={{ color: '#1D1D1F' }}>{pub.id}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>
															<Typography
																sx={{
																	color: '#0071E3',
																	textDecoration: 'underline',
																	cursor: 'pointer',
																	'&:hover': { textDecoration: 'none' },
																}}
																onClick={() => navigate(`/publication/${pub.id}`)}
															>
																{pub.title}
															</Typography>
														</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{pub.authors}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{pub.year}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>
															{pub.type === 'article'
																? 'Статья'
																: pub.type === 'monograph'
																	? 'Монография'
																	: pub.type === 'conference'
																		? 'Доклад/конференция'
																		: 'Неизвестный тип'}
														</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>
															<StatusChip status={pub.status} />
														</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{pub.user?.full_name || 'Не указан'}</TableCell>
														<TableCell sx={{ textAlign: 'center' }}>
															<Box sx={{ display: 'flex', justifyContent: 'center', gap: 1 }}>
																{pub.file_url && pub.file_url.trim() !== '' && (
																	<IconButton
																		aria-label="download"
																		onClick={() => handleDownload(pub.file_url, pub.file_url.split('/').pop())}
																		sx={{
																			color: '#0071E3',
																			borderRadius: '8px',
																			'&:hover': {
																				color: '#FFFFFF',
																				backgroundColor: '#0071E3',
																				boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
																			},
																		}}
																	>
																		<DownloadIcon />
																	</IconButton>
																)}
															</Box>
														</TableCell>
													</TableRow>
												))
											) : (
												<TableRow>
													<TableCell colSpan={8} sx={{ textAlign: 'center', color: '#6E6E73' }}>
														Нет публикаций, ожидающих проверки.
													</TableCell>
												</TableRow>
											)}
										</TableBody>
									</Fade>
								</AppleTable>
								<Box sx={{ mt: 2, display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
									<Pagination
										count={totalPagesNeedsReview}
										page={currentPageNeedsReview}
										onChange={handlePageChangeNeedsReview}
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

						{value === 1 && (
							<Typography
								variant="h5"
								gutterBottom
								sx={{
									mt: 4,
									color: '#1D1D1F',
									fontWeight: 600,
									textAlign: 'center',
								}}
							>
								Статистика по кафедре
							</Typography>
						)}

						{value === 2 && (
							<>
								<Typography
									variant="h5"
									gutterBottom
									sx={{
										mt: 4,
										color: '#1D1D1F',
										fontWeight: 600,
										textAlign: 'center',
									}}
								>
									Создание нового пользователя
								</Typography>
								<AppleCard sx={{ mb: 4, p: 3, backgroundColor: '#F5F5F7', borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
									<form onSubmit={(e) => { e.preventDefault(); }}>
										<AppleTextField
											fullWidth
											label="Фамилия"
											value={newLastName}
											onChange={(e) => setNewLastName(e.target.value)}
											margin="normal"
											variant="outlined"
											autoComplete="family-name"
										/>
										<AppleTextField
											fullWidth
											label="Имя"
											value={newFirstName}
											onChange={(e) => setNewFirstName(e.target.value)}
											margin="normal"
											variant="outlined"
											autoComplete="given-name"
										/>
										<AppleTextField
											fullWidth
											label="Отчество"
											value={newMiddleName}
											onChange={(e) => setNewMiddleName(e.target.value)}
											margin="normal"
											variant="outlined"
											autoComplete="additional-name"
										/>
										<AppleTextField
											fullWidth
											label="Логин"
											value={newUsername}
											onChange={(e) => setNewUsername(e.target.value)}
											margin="normal"
											variant="outlined"
											autoComplete="username"
										/>
										<AppleTextField
											fullWidth
											label="Пароль"
											type={showPassword ? 'text' : 'password'}
											value={newPassword}
											onChange={(e) => setNewPassword(e.target.value)}
											margin="normal"
											variant="outlined"
											autoComplete="new-password"
											InputProps={{
												endAdornment: (
													<IconButton onClick={() => setShowPassword(!showPassword)}>
														{showPassword ? <VisibilityOff /> : <Visibility />}
													</IconButton>
												),
											}}
										/>
										<Box sx={{ display: 'flex', gap: 2, mt: 2 }}>
											<AppleButton startIcon={<RefreshIcon />} onClick={async () => {
												const response = await axios.get('http://localhost:5000/admin_api/admin/generate-password', {
													withCredentials: true,
													headers: { 'X-CSRFToken': csrfToken },
												});
												setNewUsername(`user${Date.now()}`);
												setNewPassword(response.data.password);
											}}>
												Сгенерировать логин и пароль
											</AppleButton>
											<AppleButton startIcon={<ContentCopyIcon />} onClick={() => {
												navigator.clipboard.writeText(`Логин: ${newUsername}\nПароль: ${newPassword}`);
												setSuccess('Данные скопированы в буфер обмена!');
												setOpenSuccess(true);
											}}>
												Скопировать в буфер обмена
											</AppleButton>
											<AppleButton type="submit" onClick={async () => {
												if (!newUsername.trim() || !newPassword.trim() || !newLastName.trim() || !newFirstName.trim() || !newMiddleName.trim()) {
													setError('Все поля обязательны.');
													setOpenError(true);
													return;
												}
												try {
													await axios.post('http://localhost:5000/admin_api/admin/register', {
														username: newUsername,
														password: newPassword,
														last_name: newLastName,
														first_name: newFirstName,
														middle_name: newMiddleName,
													}, {
														withCredentials: true,
														headers: { 'X-CSRFToken': csrfToken },
													});
													setSuccess('Пользователь успешно зарегистрирован!');
													setOpenSuccess(true);
													setNewLastName('');
													setNewFirstName('');
													setNewMiddleName('');
													setNewUsername('');
													setNewPassword('');
												} catch (err) {
													console.error('Ошибка регистрации:', err);
													setError(err.response?.data?.error || 'Не удалось зарегистрировать пользователя.');
													setOpenError(true);
												}
											}}>
												Создать
											</AppleButton>
										</Box>
										<Collapse in={openError}>
											{error && (
												<Alert
													severity="error"
													sx={{
														mt: 2,
														borderRadius: '12px',
														backgroundColor: '#FFF1F0',
														color: '#1D1D1F',
														boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
													}}
													onClose={() => setOpenError(false)}
												>
													{error}
												</Alert>
											)}
										</Collapse>
										<Collapse in={openSuccess}>
											{success && (
												<Alert
													severity="success"
													sx={{
														mt: 2,
														borderRadius: '12px',
														backgroundColor: '#E7F8E7',
														color: '#1D1D1F',
														boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
													}}
													onClose={() => setOpenSuccess(false)}
												>
													{success}
												</Alert>
											)}
										</Collapse>
									</form>
								</AppleCard>
							</>
						)}

						{value === 3 && (
							<Box sx={{ mt: 4 }}>
								<Typography variant="h5" gutterBottom sx={{ mt: 4, color: '#1D1D1F', fontWeight: 600, textAlign: 'center' }}>
									Работа с планами
								</Typography>
								{plans.length > 0 ? (
									plans.map((plan) => (
										<PlanTable key={plan.id} sx={{ mb: 4 }}>
											<TableHead>
												<TableRow sx={{ backgroundColor: '#0071E3' }}>
													<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', borderRadius: '12px 0 0 0' }}>ID</TableCell>
													<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Год</TableCell>
													<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Ожидаемые публикации</TableCell>
													<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Пользователь</TableCell>
													<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Статус</TableCell>
													<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', textAlign: 'center', borderRadius: '0 12px 0 0' }}>
														Действия
													</TableCell>
												</TableRow>
											</TableHead>
											<TableBody>
												<TableRow
													sx={{
														'&:hover': { backgroundColor: '#F5F5F7', transition: 'background-color 0.3s ease' },
														borderBottom: '2px solid #E5E5EA',
													}}
												>
													<TableCell sx={{ color: '#1D1D1F' }}>{plan.id}</TableCell>
													<TableCell sx={{ color: '#1D1D1F' }}>{plan.year}</TableCell>
													<TableCell sx={{ color: '#1D1D1F' }}>{plan.expectedCount}</TableCell>
													<TableCell sx={{ color: '#1D1D1F' }}>{plan.user?.full_name || 'Не указан'}</TableCell>
													<TableCell sx={{ color: '#1D1D1F' }}>
														<StatusChip status={plan.status} />
													</TableCell>
													<TableCell sx={{ textAlign: 'center' }}>
														<Box sx={{ display: 'flex', justifyContent: 'center', gap: 1 }}>
															{plan.status === 'needs_review' && (
																<>
																	<GreenButton
																		startIcon={<CheckIcon />}
																		onClick={() => handleApprovePlan(plan)}
																	>
																		Утвердить
																	</GreenButton>
																	<AppleButton
																		startIcon={<ReplayIcon />}
																		onClick={() => handleOpenReturnDialog(plan)}
																	>
																		На доработку
																	</AppleButton>
																</>
															)}
														</Box>
													</TableCell>
												</TableRow>
											</TableBody>
										</PlanTable>
									))
								) : (
									<AppleTable sx={{ mt: 2, boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
										<TableHead>
											<TableRow sx={{ backgroundColor: '#0071E3' }}>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', borderRadius: '12px 0 0 0' }}>ID</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Год</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Ожидаемые публикации</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Пользователь</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Статус</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', textAlign: 'center', borderRadius: '0 12px 0 0' }}>
													Действия
												</TableCell>
											</TableRow>
										</TableHead>
										<TableBody>
											<TableRow>
												<TableCell colSpan={6} sx={{ textAlign: 'center', color: '#6E6E73' }}>
													Нет планов для проверки.
												</TableCell>
											</TableRow>
										</TableBody>
									</AppleTable>
								)}
								<Box sx={{ mt: 2, display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
									<Pagination
										count={totalPagesPlans}
										page={currentPagePlans}
										onChange={handlePageChangePlans}
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
							</Box>
						)}

						<Dialog
							open={openDeleteDialog}
							onClose={() => { setOpenDeleteDialog(false); setPublicationToDelete(null); }}
							sx={{
								'& .MuiDialog-paper': {
									backgroundColor: '#FFFFFF',
									boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
									borderRadius: '16px',
									fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif",
								},
							}}
						>
							<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600, borderBottom: '1px solid #E5E5EA' }}>
								Подтвердите удаление
							</DialogTitle>
							<DialogContent sx={{ padding: '24px' }}>
								<Typography sx={{ color: '#6E6E73' }}>
									Вы уверены, что хотите удалить публикацию "{publicationToDelete?.title}"?
								</Typography>
							</DialogContent>
							<DialogActions sx={{ padding: '16px 24px', borderTop: '1px solid #E5E5EA' }}>
								<CancelButton onClick={() => { setOpenDeleteDialog(false); setPublicationToDelete(null); }}>Отмена</CancelButton>
								<AppleButton onClick={handleDeletePlanConfirm}>
									Удалить
								</AppleButton>
							</DialogActions>
						</Dialog>

						<Dialog
							open={openEditDialog}
							onClose={handleEditCancel}
							sx={{
								'& .MuiDialog-paper': {
									backgroundColor: '#FFFFFF',
									boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
									borderRadius: '16px',
									fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif",
								},
							}}
						>
							<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600, borderBottom: '1px solid #E5E5EA' }}>
								Редактировать публикацию
							</DialogTitle>
							<DialogContent sx={{ padding: '24px' }}>
								<form onSubmit={handleEditSubmit}>
									<AppleTextField
										fullWidth
										label="Название"
										value={editTitle}
										onChange={(e) => setEditTitle(e.target.value)}
										margin="normal"
										variant="outlined"
									/>
									<AppleTextField
										fullWidth
										label="Авторы"
										value={editAuthors}
										onChange={(e) => setEditAuthors(e.target.value)}
										margin="normal"
										variant="outlined"
									/>
									<AppleTextField
										fullWidth
										label="Год"
										type="number"
										value={editYear}
										onChange={(e) => setEditYear(e.target.value)}
										margin="normal"
										variant="outlined"
									/>
									<AppleTextField
										fullWidth
										select
										label="Тип публикации"
										value={editType}
										onChange={(e) => setEditType(e.target.value)}
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
										value={editStatus}
										onChange={(e) => setEditStatus(e.target.value)}
										margin="normal"
										variant="outlined"
										disabled={!editPublication?.file_url && !editFile}
									>
										<MenuItem value="draft">Черновик</MenuItem>
										<MenuItem value="needs_review">Нуждается в проверке</MenuItem>
										<MenuItem value="published" disabled={!editPublication?.file_url && !editFile}>
											Опубликовано
										</MenuItem>
									</AppleTextField>
									<Box sx={{ mt: 2 }}>
										<Typography variant="body2" sx={{ color: '#6E6E73', mb: 1 }}>
											Текущий файл: {editPublication?.file_url || 'Нет файла'}
										</Typography>
										<input
											type="file"
											accept=".pdf,.docx"
											onChange={(e) => setEditFile(e.target.files[0])}
											style={{ display: 'none' }}
											id="edit-upload-file"
										/>
										<label htmlFor="edit-upload-file">
											<AppleButton sx={{ border: '1px solid #D1D1D6', backgroundColor: '#F5F5F7', color: '#1D1D1F' }} component="span">
												Выбрать файл
											</AppleButton>
										</label>
										{editFile && <Typography sx={{ mt: 1, color: '#6E6E73' }}>{editFile.name}</Typography>}
									</Box>
									<Collapse in={openError}>
										{error && (
											<Alert
												severity="error"
												sx={{
													mt: 2,
													borderRadius: '12px',
													backgroundColor: '#FFF1F0',
													color: '#1D1D1F',
													boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
												}}
												onClose={() => setOpenError(false)}
											>
												{error}
											</Alert>
										)}
									</Collapse>
									<Collapse in={openSuccess}>
										{success && (
											<Alert
												severity="success"
												sx={{
													mt: 2,
													borderRadius: '12px',
													backgroundColor: '#E7F8E7',
													color: '#1D1D1F',
													boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
												}}
												onClose={() => setOpenSuccess(false)}
											>
												{success}
											</Alert>
										)}
									</Collapse>
									<DialogActions sx={{ padding: '16px 0', borderTop: '1px solid #E5E5EA' }}>
										<CancelButton onClick={handleEditCancel}>Отмена</CancelButton>
										<AppleButton type="submit">Сохранить</AppleButton>
									</DialogActions>
								</form>
							</DialogContent>
						</Dialog>

						<Dialog
							open={openReturnDialog}
							onClose={() => setOpenReturnDialog(false)}
							sx={{
								'& .MuiDialog-paper': {
									backgroundColor: '#FFFFFF',
									boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
									borderRadius: '16px',
									fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif",
									maxWidth: '400px',
								},
							}}
						>
							<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600, borderBottom: '1px solid #E5E5EA' }}>
								Вернуть план на доработку
							</DialogTitle>
							<DialogContent sx={{ padding: '24px' }}>
								<Typography sx={{ color: '#6E6E73', mb: 2 }}>
									Пожалуйста, укажите комментарий для пользователя:
								</Typography>
								<TextField
									autoFocus
									margin="dense"
									label="Комментарий"
									type="text"
									fullWidth
									multiline
									rows={3}
									value={returnComment}
									onChange={(e) => setReturnComment(e.target.value)}
									variant="outlined"
								/>
							</DialogContent>
							<DialogActions sx={{ padding: '16px 24px', borderTop: '1px solid #E5E5EA' }}>
								<CancelButton onClick={() => setOpenReturnDialog(false)}>Отмена</CancelButton>
								<AppleButton onClick={handleReturnForRevision}>Отправить</AppleButton>
							</DialogActions>
						</Dialog>

						<Collapse in={openError}>
							{error && (
								<Alert
									severity="error"
									sx={{
										mt: 2,
										borderRadius: '12px',
										backgroundColor: '#FFF1F0',
										color: '#1D1D1F',
										boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
									}}
									onClose={() => setOpenError(false)}
								>
									{error}
								</Alert>
							)}
						</Collapse>
						<Collapse in={openSuccess}>
							{success && (
								<Alert
									severity="success"
									sx={{
										mt: 2,
										borderRadius: '12px',
										backgroundColor: '#E7F8E7',
										color: '#1D1D1F',
										boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
									}}
									onClose={() => setOpenSuccess(false)}
								>
									{success}
								</Alert>
							)}
						</Collapse>
					</>
				)}
			</AppleCard>
		</Container>
	);
}

export default ManagerDashboard;