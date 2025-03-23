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
	Drawer,
	Accordion,
	AccordionSummary,
	AccordionDetails,
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
import HistoryIcon from '@mui/icons-material/History';
import WarningAmberIcon from '@mui/icons-material/WarningAmber';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import axios from 'axios';
import { useAuth } from '../contexts/AuthContext';
import StatusChip from './StatusChip';

// Стили
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
	borderRadius: '16px',
	overflow: 'hidden',
	backgroundColor: '#FFFFFF',
	boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
	marginBottom: '16px',
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

// Регулярные выражения для проверки ФИО
const namePartRegex = /^[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?$/;
const fullNameRegex = /^[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?\s[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?\s[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?$/;

function ManagerDashboard() {
	const { user, csrfToken, isAuthenticated } = useAuth();
	const navigate = useNavigate();
	const [value, setValue] = useState(0);
	const [publications, setPublications] = useState([]);
	const [plans, setPlans] = useState([]);
	const [actionHistory, setActionHistory] = useState([]);
	const [currentPagePublications, setCurrentPagePublications] = useState(1);
	const [currentPagePlans, setCurrentPagePlans] = useState(1);
	const [historyPage, setHistoryPage] = useState(1);
	const [totalPagesPublications, setTotalPagesPublications] = useState(1);
	const [totalPagesPlans, setTotalPagesPlans] = useState(1);
	const [totalHistoryPages, setTotalHistoryPages] = useState(1);
	const [searchQuery, setSearchQuery] = useState('');
	const [statusFilter, setStatusFilter] = useState('needs_review');
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
	const [lastNameError, setLastNameError] = useState('');
	const [firstNameError, setFirstNameError] = useState('');
	const [middleNameError, setMiddleNameError] = useState('');
	const [openHistoryDrawer, setOpenHistoryDrawer] = useState(false);
	const [publicationsTransitionKey, setPublicationsTransitionKey] = useState(0);
	const [plansTransitionKey, setPlansTransitionKey] = useState(0);
	const [historyTransitionKey, setHistoryTransitionKey] = useState(0);

	// Эффект для автоматического закрытия уведомлений
	useEffect(() => {
		let errorTimer, successTimer;
		if (openError) errorTimer = setTimeout(() => setOpenError(false), 3000);
		if (openSuccess) successTimer = setTimeout(() => setOpenSuccess(false), 3000);
		return () => {
			if (errorTimer) clearTimeout(errorTimer);
			if (successTimer) clearTimeout(successTimer);
		};
	}, [openError, openSuccess]);

	// Валидация ФИО
	const validateNamePart = (value, fieldName) => {
		if (!value.trim()) return `${fieldName} обязательно для заполнения.`;
		if (!namePartRegex.test(value))
			return `${fieldName} должно начинаться с заглавной буквы, содержать только кириллицу и быть длиной не менее 2 символов.`;
		return '';
	};

	const validateFullName = (lastName, firstName, middleName) => {
		const fullName = `${lastName} ${firstName} ${middleName}`;
		if (!fullNameRegex.test(fullName))
			return 'ФИО должно быть в формате "Иванов Иван Иванович" (три слова с заглавной буквы, разделённые пробелами).';
		return '';
	};

	// Обработчики изменения полей ФИО
	const handleLastNameChange = (e) => {
		const value = e.target.value;
		setNewLastName(value);
		setLastNameError(validateNamePart(value, 'Фамилия'));
	};

	const handleFirstNameChange = (e) => {
		const value = e.target.value;
		setNewFirstName(value);
		setFirstNameError(validateNamePart(value, 'Имя'));
	};

	const handleMiddleNameChange = (e) => {
		const value = e.target.value;
		setNewMiddleName(value);
		setMiddleNameError(validateNamePart(value, 'Отчество'));
	};

	// Загрузка данных
	const fetchPublications = async (page) => {
		try {
			const response = await axios.get(`http://localhost:5000/admin_api/admin/publications`, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
				params: {
					page,
					per_page: 10,
					search: searchQuery,
					status: ['needs_review', 'returned_for_revision', 'published'].join(','),
					sort_status: statusFilter,
				},
			});
			setPublications(response.data.publications);
			setTotalPagesPublications(response.data.pages);
			setPublicationsTransitionKey((prev) => prev + 1);
		} catch (err) {
			console.error('Ошибка загрузки публикаций:', err);
			setError('Не удалось загрузить публикации. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const fetchPlans = async (page) => {
		try {
			const response = await axios.get(`http://localhost:5000/admin_api/admin/plans/needs-review?page=${page}&per_page=10`, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});
			setPlans(response.data.plans);
			setTotalPagesPlans(response.data.pages);
			setPlansTransitionKey((prev) => prev + 1);
		} catch (err) {
			console.error('Ошибка загрузки планов:', err);
			setError('Не удалось загрузить планы. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const fetchActionHistory = async (page) => {
		try {
			const response = await axios.get(`http://localhost:5000/admin_api/admin/manager-action-history`, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
				params: { page, per_page: 10 },
			});
			setActionHistory(response.data.history);
			setTotalHistoryPages(response.data.pages);
			setHistoryTransitionKey((prev) => prev + 1);
		} catch (err) {
			console.error('Ошибка загрузки истории действий:', err);
			setError('Не удалось загрузить историю действий.');
			setOpenError(true);
		}
	};

	// Инициализация данных только при загрузке компонента
	useEffect(() => {
		if (!isAuthenticated || user.role !== 'manager') navigate('/login');
		setLoadingInitial(true);
		Promise.all([
			fetchPublications(currentPagePublications),
			fetchPlans(currentPagePlans),
			fetchActionHistory(historyPage),
		]).finally(() => setLoadingInitial(false));
	}, [isAuthenticated, user, navigate]);

	// Обновление публикаций при изменении страницы, поиска или фильтра
	useEffect(() => {
		fetchPublications(currentPagePublications);
	}, [currentPagePublications, searchQuery, statusFilter]);

	// Обновление планов при изменении страницы
	useEffect(() => {
		fetchPlans(currentPagePlans);
	}, [currentPagePlans]);

	// Обработчики
	const handleTabChange = (event, newValue) => setValue(newValue);

	const handleSearchChange = (e) => {
		setSearchQuery(e.target.value);
		setCurrentPagePublications(1);
	};

	const handleStatusFilterChange = (e) => {
		setStatusFilter(e.target.value);
		setCurrentPagePublications(1);
	};

	const handlePageChangePublications = (event, value) => setCurrentPagePublications(value);

	const handlePageChangePlans = (event, value) => setCurrentPagePlans(value);

	const handleHistoryPageChange = (event, value) => {
		setHistoryPage(value);
		fetchActionHistory(value);
	};

	const handleDownload = async (fileUrl, fileName) => {
		if (!fileUrl || typeof fileUrl !== 'string' || fileUrl.trim() === '') {
			setError('Некорректный URL файла. Обратитесь к администратору.');
			setOpenError(true);
			return;
		}
		const normalizedFileUrl = fileUrl.startsWith('/') ? fileUrl : `/${fileUrl}`;
		const fullUrl = `http://localhost:5000${normalizedFileUrl}`;
		try {
			const response = await axios.get(fullUrl, {
				responseType: 'blob',
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
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
			setError(err.response ? `Ошибка сервера: ${err.response.status}` : 'Не удалось скачать файл.');
			setOpenError(true);
		}
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
			await axios.put(`http://localhost:5000/admin_api/admin/publications/${editPublication.id}`, formData, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken, 'Content-Type': 'multipart/form-data' },
			});
			setSuccess('Публикация успешно обновлена!');
			setOpenSuccess(true);
			fetchPublications(currentPagePublications);
			fetchActionHistory(historyPage);
			handleEditCancel();
		} catch (err) {
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
				fetchPublications(currentPagePublications);
				fetchActionHistory(historyPage);
				setOpenDeleteDialog(false);
				setPublicationToDelete(null);
			} catch (err) {
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
			setError('Не удалось вернуть план. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const handleOpenHistoryDrawer = () => {
		setOpenHistoryDrawer(true);
		fetchActionHistory(historyPage);
	};

	const handleCloseHistoryDrawer = () => setOpenHistoryDrawer(false);

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
									/>
									<Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mt: 2 }}>
										<AppleTextField
											select
											label="Фильтр по статусу"
											value={statusFilter}
											onChange={handleStatusFilterChange}
											margin="normal"
											variant="outlined"
											sx={{ width: '200px' }}
										>
											<MenuItem value="needs_review">На проверке</MenuItem>
											<MenuItem value="returned_for_revision">Отправлено на доработку</MenuItem>
											<MenuItem value="published">Опубликовано</MenuItem>
										</AppleTextField>
										<AppleButton startIcon={<HistoryIcon />} onClick={handleOpenHistoryDrawer} sx={{ height: 'fit-content' }}>
											Показать историю
										</AppleButton>
									</Box>
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
									<Fade in={true} timeout={500} key={publicationsTransitionKey}>
										<TableBody>
											{publications.length > 0 ? (
												publications.map((pub) => (
													<TableRow
														key={pub.id}
														sx={{ '&:hover': { backgroundColor: '#F5F5F7', transition: 'background-color 0.3s ease' } }}
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
															<StatusChip status={pub.status} role={user.role} />
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
																			'&:hover': { color: '#FFFFFF', backgroundColor: '#0071E3', boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)' },
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
														Нет публикаций с указанными статусами.
													</TableCell>
												</TableRow>
											)}
										</TableBody>
									</Fade>
								</AppleTable>
								<Box sx={{ mt: 2, display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
									<Pagination
										count={totalPagesPublications}
										page={currentPagePublications}
										onChange={handlePageChangePublications}
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
								<Drawer
									anchor="right"
									open={openHistoryDrawer}
									onClose={handleCloseHistoryDrawer}
									sx={{
										'& .MuiDrawer-paper': {
											width: 500,
											backgroundColor: '#FFFFFF',
											boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
											borderRadius: '16px 0 0 16px',
											p: 2,
										},
									}}
								>
									<Box sx={{ p: 2 }}>
										<Typography variant="h6" sx={{ color: '#1D1D1F', fontWeight: 600 }}>
											История действий
										</Typography>
										{actionHistory.length > 0 ? (
											<>
												<AppleTable sx={{ mt: 2 }}>
													<TableHead>
														<TableRow sx={{ backgroundColor: '#0071E3' }}>
															<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Название</TableCell>
															<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Действие</TableCell>
															<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Время</TableCell>
														</TableRow>
													</TableHead>
													<Fade in={true} timeout={500} key={historyTransitionKey}>
														<TableBody>
															{actionHistory.map((action) => (
																<TableRow key={action.id}>
																	<TableCell>
																		<Typography
																			sx={{
																				color: '#0071E3',
																				textDecoration: 'underline',
																				cursor: 'pointer',
																				'&:hover': { textDecoration: 'none' },
																			}}
																			onClick={() => {
																				console.log('Клик по записи истории:', action); // Отладка
																				if (action.id) {
																					console.log('Переход на:', `/publication/${action.id}`); // Отладка
																					handleCloseHistoryDrawer(); // Закрываем Drawer
																					navigate(`/publication/${action.id}`); // Переходим на страницу
																				} else {
																					console.error('ID публикации отсутствует:', action); // Отладка
																					setError('ID публикации отсутствует в записи истории.');
																					setOpenError(true);
																				}
																			}}
																		>
																			{action.title}
																		</Typography>
																	</TableCell>
																	<TableCell>
																		{action.action_type === 'published' ? 'Опубликовано' : 'Возвращено на доработку'}
																	</TableCell>
																	<TableCell>{new Date(action.timestamp).toLocaleString('ru-RU')}</TableCell>
																</TableRow>
															))}
														</TableBody>
													</Fade>
												</AppleTable>
												<Box sx={{ mt: 2, display: 'flex', justifyContent: 'center' }}>
													<Pagination
														count={totalHistoryPages}
														page={historyPage}
														onChange={handleHistoryPageChange}
														color="primary"
														sx={{
															'& .MuiPaginationItem-root': {
																borderRadius: 20,
																'&:hover': { backgroundColor: 'grey.100' },
																'&.Mui-selected': { backgroundColor: '#1976D2', color: 'white' },
															},
														}}
													/>
												</Box>
											</>
										) : (
											<Typography sx={{ mt: 2, color: '#6E6E73' }}>
												Нет записей в истории действий.
											</Typography>
										)}
									</Box>
								</Drawer>
							</>
						)}

						{value === 1 && (
							<Typography variant="h5" gutterBottom sx={{ mt: 4, color: '#1D1D1F', fontWeight: 600, textAlign: 'center' }}>
								Статистика по кафедре
							</Typography>
						)}

						{value === 2 && (
							<>
								<Typography variant="h5" gutterBottom sx={{ mt: 4, color: '#1D1D1F', fontWeight: 600, textAlign: 'center' }}>
									Регистрация нового пользователя
								</Typography>
								<AppleCard sx={{ maxWidth: 'none', mx: 'auto', mt: 2, p: 4 }}>
									<form onSubmit={(e) => e.preventDefault()}>
										<AppleTextField
											fullWidth
											label="Фамилия"
											value={newLastName}
											onChange={handleLastNameChange}
											margin="normal"
											variant="outlined"
											autoComplete="family-name"
											error={!!lastNameError}
											helperText={lastNameError}
										/>
										<AppleTextField
											fullWidth
											label="Имя"
											value={newFirstName}
											onChange={handleFirstNameChange}
											margin="normal"
											variant="outlined"
											autoComplete="given-name"
											error={!!firstNameError}
											helperText={firstNameError}
										/>
										<AppleTextField
											fullWidth
											label="Отчество"
											value={newMiddleName}
											onChange={handleMiddleNameChange}
											margin="normal"
											variant="outlined"
											autoComplete="additional-name"
											error={!!middleNameError}
											helperText={middleNameError}
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
											<AppleButton
												startIcon={<RefreshIcon />}
												onClick={async () => {
													const lastNameErr = validateNamePart(newLastName, 'Фамилия');
													const firstNameErr = validateNamePart(newFirstName, 'Имя');
													const middleNameErr = validateNamePart(newMiddleName, 'Отчество');
													const fullNameErr = validateFullName(newLastName, newFirstName, newMiddleName);

													if (lastNameErr || firstNameErr || middleNameErr || fullNameErr) {
														setLastNameError(lastNameErr);
														setFirstNameError(firstNameErr);
														setMiddleNameError(middleNameErr);
														if (fullNameErr) {
															setError(fullNameErr);
															setOpenError(true);
														}
														return;
													}

													const generateUsername = async () => {
														const transliterate = (text) => {
															const ruToEn = {
																а: 'a', б: 'b', в: 'v', г: 'g', д: 'd',
																е: 'e', ё: 'e', ж: 'zh', з: 'z', и: 'i',
																й: 'y', к: 'k', л: 'l', м: 'm', н: 'n',
																о: 'o', п: 'p', р: 'r', с: 's', т: 't',
																у: 'u', ф: 'f', х: 'kh', ц: 'ts', ч: 'ch',
																ш: 'sh', щ: 'sch', ъ: '', ы: 'y', ь: '',
																э: 'e', ю: 'yu', я: 'ya'
															};
															return text.toLowerCase().split('').map(char => ruToEn[char] || char).join('');
														};
														const capitalizeFirstLetter = (string) =>
															string ? string.charAt(0).toUpperCase() + string.slice(1) : '';
														const baseUsername = `${capitalizeFirstLetter(transliterate(newLastName))}${capitalizeFirstLetter(transliterate(newFirstName[0]))}${capitalizeFirstLetter(transliterate(newMiddleName[0]))}`;
														let generatedUsername = baseUsername;
														let suffix = 1;

														while (true) {
															try {
																const response = await axios.post(
																	'http://localhost:5000/admin_api/admin/check-username',
																	{ username: generatedUsername },
																	{ withCredentials: true, headers: { 'X-CSRFToken': csrfToken } }
																);
																if (!response.data.exists) break;
																generatedUsername = `${baseUsername}${suffix}`;
																suffix++;
															} catch (err) {
																setError('Ошибка проверки логина.');
																setOpenError(true);
																return null;
															}
														}
														return generatedUsername;
													};

													const generatedUsername = await generateUsername();
													if (!generatedUsername) return;

													try {
														const response = await axios.get('http://localhost:5000/admin_api/admin/generate-password', {
															withCredentials: true,
															headers: { 'X-CSRFToken': csrfToken },
														});
														setNewUsername(generatedUsername);
														setNewPassword(response.data.password);
														setSuccess('Логин и пароль успешно сгенерированы.');
														setOpenSuccess(true);
													} catch (err) {
														setError('Ошибка генерации пароля.');
														setOpenError(true);
													}
												}}
											>
												Сгенерировать логин и пароль
											</AppleButton>
											<AppleButton
												startIcon={<ContentCopyIcon />}
												onClick={() => {
													navigator.clipboard.writeText(`Логин: ${newUsername}\nПароль: ${newPassword}`);
													setSuccess('Данные скопированы в буфер обмена!');
													setOpenSuccess(true);
												}}
											>
												Скопировать в буфер обмена
											</AppleButton>
											<AppleButton
												type="submit"
												onClick={async () => {
													const lastNameErr = validateNamePart(newLastName, 'Фамилия');
													const firstNameErr = validateNamePart(newFirstName, 'Имя');
													const middleNameErr = validateNamePart(newMiddleName, 'Отчество');
													const fullNameErr = validateFullName(newLastName, newFirstName, newMiddleName);

													if (lastNameErr || firstNameErr || middleNameErr || fullNameErr) {
														setLastNameError(lastNameErr);
														setFirstNameError(firstNameErr);
														setMiddleNameError(middleNameErr);
														if (fullNameErr) {
															setError(fullNameErr);
															setOpenError(true);
														}
														return;
													}

													if (!newUsername.trim() || !newPassword.trim()) {
														setError('Логин и пароль обязательны.');
														setOpenError(true);
														return;
													}

													try {
														await axios.post(
															'http://localhost:5000/admin_api/admin/register',
															{
																username: newUsername,
																password: newPassword,
																last_name: newLastName,
																first_name: newFirstName,
																middle_name: newMiddleName,
															},
															{ withCredentials: true, headers: { 'X-CSRFToken': csrfToken } }
														);
														setSuccess('Пользователь успешно зарегистрирован!');
														setOpenSuccess(true);
														setNewLastName('');
														setNewFirstName('');
														setNewMiddleName('');
														setNewUsername('');
														setNewPassword('');
														setLastNameError('');
														setFirstNameError('');
														setMiddleNameError('');
													} catch (err) {
														setError(err.response?.data?.error || 'Не удалось зарегистрировать пользователя.');
														setOpenError(true);
													}
												}}
											>
												Создать
											</AppleButton>
										</Box>
										<Collapse in={openError}>
											{error && (
												<Alert
													severity="error"
													sx={{ mt: 2, borderRadius: '12px', backgroundColor: '#FFF1F0', color: '#1D1D1F', boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)' }}
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
													sx={{ mt: 2, borderRadius: '12px', backgroundColor: '#E7F8E7', color: '#1D1D1F', boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)' }}
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
										<Accordion
											key={plan.id}
											sx={{ mb: 2, borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}
										>
											<AccordionSummary expandIcon={<ExpandMoreIcon />}>
												<Box sx={{ display: 'flex', justifyContent: 'space-between', width: '100%', alignItems: 'center' }}>
													<Box>
														<Typography variant="h6" sx={{ color: '#1D1D1F' }}>
															План на {plan.year} год (Ожидаемое количество: {plan.expectedCount} | Текущее количество: {plan.entries.length})
														</Typography>
														<Typography variant="body2" sx={{ color: '#6E6E73', mt: 0.5 }}>
															{plan.user && plan.user.full_name
																? `${plan.user.full_name} (${plan.user.username || 'логин отсутствует'})`
																: 'Пользователь не указан'}
														</Typography>
													</Box>
													<StatusChip status={plan.status} role={user.role} />
												</Box>
											</AccordionSummary>
											<AccordionDetails>
												<PlanTable>
													<TableHead>
														<TableRow>
															<TableCell>Название</TableCell>
															<TableCell>Тип</TableCell>
															<TableCell>Статус</TableCell>
														</TableRow>
													</TableHead>
													<Fade in={true} timeout={500} key={plansTransitionKey}>
														<TableBody>
															{plan.entries.map((entry) => (
																<TableRow key={entry.id}>
																	<TableCell>{entry.title || 'Не указано'}</TableCell>
																	<TableCell>
																		{entry.type === 'article'
																			? 'Статья'
																			: entry.type === 'monograph'
																				? 'Монография'
																				: entry.type === 'conference'
																					? 'Доклад/конференция'
																					: entry.type || 'Не указано'}
																	</TableCell>
																	<TableCell>
																		<StatusChip status={entry.status} role={user.role} />
																	</TableCell>
																</TableRow>
															))}
														</TableBody>
													</Fade>
												</PlanTable>
												{plan.return_comment && (
													<Typography
														sx={{ mt: 2, color: '#000000', fontWeight: 600, display: 'flex', alignItems: 'center', gap: 1 }}
													>
														<WarningAmberIcon sx={{ color: '#FF3B30' }} />
														Комментарий при возврате: {plan.return_comment}
													</Typography>
												)}
												{plan.status === 'needs_review' && (
													<Box sx={{ display: 'flex', gap: 2, mt: 2 }}>
														<GreenButton startIcon={<CheckIcon />} onClick={() => handleApprovePlan(plan)}>
															Утвердить
														</GreenButton>
														<AppleButton startIcon={<ReplayIcon />} onClick={() => handleOpenReturnDialog(plan)}>
															На доработку
														</AppleButton>
													</Box>
												)}
											</AccordionDetails>
										</Accordion>
									))
								) : (
									<Typography sx={{ textAlign: 'center', color: '#6E6E73', mt: 2 }}>
										Нет планов для проверки.
									</Typography>
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
												'&:hover': { backgroundColor: 'grey.100' },
												'&.Mui-selected': { backgroundColor: '#1976D2', color: 'white' },
											},
										}}
									/>
								</Box>
							</Box>
						)}

						<Dialog
							open={openDeleteDialog}
							onClose={() => {
								setOpenDeleteDialog(false);
								setPublicationToDelete(null);
							}}
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
								<CancelButton
									onClick={() => {
										setOpenDeleteDialog(false);
										setPublicationToDelete(null);
									}}
								>
									Отмена
								</CancelButton>
								<AppleButton onClick={handleDeletePlanConfirm}>Удалить</AppleButton>
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
												sx={{ mt: 2, borderRadius: '12px', backgroundColor: '#FFF1F0', color: '#1D1D1F', boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)' }}
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
												sx={{ mt: 2, borderRadius: '12px', backgroundColor: '#E7F8E7', color: '#1D1D1F', boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)' }}
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

						{value !== 2 && (
							<>
								<Collapse in={openError}>
									{error && (
										<Alert
											severity="error"
											sx={{ mt: 2, borderRadius: '12px', backgroundColor: '#FFF1F0', color: '#1D1D1F', boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)' }}
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
											sx={{ mt: 2, borderRadius: '12px', backgroundColor: '#E7F8E7', color: '#1D1D1F', boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)' }}
											onClose={() => setOpenSuccess(false)}
										>
											{success}
										</Alert>
									)}
								</Collapse>
							</>
						)}
					</>
				)}
			</AppleCard>
		</Container>
	);
}

export default ManagerDashboard;