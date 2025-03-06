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
	MenuItem,
	Collapse,
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
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import DownloadIcon from '@mui/icons-material/Download';
import VisibilityOff from '@mui/icons-material/VisibilityOff';
import Visibility from '@mui/icons-material/Visibility';
import RefreshIcon from '@mui/icons-material/Refresh';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import AddIcon from '@mui/icons-material/Add';
import PublishIcon from '@mui/icons-material/Publish';
import axios from 'axios';
import { styled } from '@mui/system';

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

const GreenButton = styled(Button)(({ theme }) => ({
	borderRadius: '12px',
	textTransform: 'none',
	backgroundColor: 'green',
	color: '#FFFFFF',
	padding: '8px 16px',
	fontSize: '14px',
	fontWeight: 600,
	boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
	'&:hover': {
		backgroundColor: '#2EBB4A',
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

const PlanTable = styled(Table)(({ theme }) => ({
	borderRadius: '16px',
	overflow: 'hidden',
	backgroundColor: '#FFFFFF',
	boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
	marginBottom: '16px',
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

function ManagerDashboard() {
	const [value, setValue] = useState(0);
	const [needsReviewPublications, setNeedsReviewPublications] = useState([]);
	const [currentPageNeedsReview, setCurrentPageNeedsReview] = useState(1);
	const [totalPagesNeedsReview, setTotalPagesNeedsReview] = useState(1);
	const [loadingInitial, setLoadingInitial] = useState(true);
	const [searchQuery, setSearchQuery] = useState('');
	const [error, setError] = useState('');
	const [success, setSuccess] = useState('');
	const [openError, setOpenError] = useState(false);
	const [openSuccess, setOpenSuccess] = useState(false);
	const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
	const [publicationToDelete, setPublicationToDelete] = useState(null);
	const [editPublication, setEditPublication] = useState(null);
	const [editTitle, setEditTitle] = useState('');
	const [editAuthors, setEditAuthors] = useState('');
	const [editYear, setEditYear] = useState('');
	const [editType, setEditType] = useState('');
	const [editStatus, setEditStatus] = useState('');
	const [editFile, setEditFile] = useState(null);
	const [openEditDialog, setOpenEditDialog] = useState(false);

	// Состояния для регистрации пользователей
	const [newUsername, setNewUsername] = useState('');
	const [newPassword, setNewPassword] = useState('');
	const [newLastName, setNewLastName] = useState('');
	const [newFirstName, setNewFirstName] = useState('');
	const [newMiddleName, setNewMiddleName] = useState('');
	const [showPassword, setShowPassword] = useState(false);

	// Состояния для работы с планами
	const [plans, setPlans] = useState([]);
	const [currentPagePlans, setCurrentPagePlans] = useState(1);
	const [totalPagesPlans, setTotalPagesPlans] = useState(1);
	const [editingPlanId, setEditingPlanId] = useState(null);
	const [users, setUsers] = useState([]);

	const navigate = useNavigate();
	const { csrfToken } = useAuth();

	useEffect(() => {
		const fetchInitialData = async () => {
			setLoadingInitial(true);
			try {
				if (value === 0) {
					const needsReviewResponse = await axios.get('http://localhost:5000/admin_api/admin/publications/needs-review', {
						withCredentials: true,
						params: { page: currentPageNeedsReview, per_page: 10, search: searchQuery },
					});
					setNeedsReviewPublications(needsReviewResponse.data.publications || []);
					setTotalPagesNeedsReview(needsReviewResponse.data.pages || 1);
				} else if (value === 3) {
					const plansResponse = await axios.get('http://localhost:5000/admin_api/admin/plans', {
						withCredentials: true,
						params: { page: currentPagePlans, per_page: 10 },
					});
					setPlans(plansResponse.data.plans || []);
					setTotalPagesPlans(plansResponse.data.pages || 1);

					const usersResponse = await axios.get('http://localhost:5000/admin_api/admin/users', {
						withCredentials: true,
					});
					setUsers(usersResponse.data.users || []);
				}
			} catch (err) {
				setError('Ошибка загрузки данных. Попробуйте позже.');
				setOpenError(true);
			} finally {
				setLoadingInitial(false);
			}
		};

		fetchInitialData();
	}, [currentPageNeedsReview, searchQuery, value, currentPagePlans]);

	const handleTabChange = (event, newValue) => {
		setValue(newValue);
		setSearchQuery('');
		setCurrentPageNeedsReview(1);
		setCurrentPagePlans(1);
	};

	const handlePageChangeNeedsReview = (event, newPage) => {
		setCurrentPageNeedsReview(newPage);
	};

	const handlePageChangePlans = (event, newPage) => {
		setCurrentPagePlans(newPage);
	};

	const handleSearchChange = async (e) => {
		setSearchQuery(e.target.value);
		setCurrentPageNeedsReview(1);
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
		setEditType('');
		setEditStatus('');
		setEditFile(null);
		setError('');
		setSuccess('');
		setOpenError(false);
		setOpenSuccess(false);
	};

	const handleEditSubmit = async (e) => {
		e.preventDefault();
		try {
			if (editPublication) {
				const formData = new FormData();
				formData.append('title', editTitle);
				formData.append('authors', editAuthors);
				formData.append('year', editYear);
				formData.append('type', editType);
				formData.append('status', editStatus);
				if (editFile) {
					formData.append('file', editFile);
				}

				const response = await axios.put(`http://localhost:5000/admin_api/admin/publications/${editPublication.id}`, formData, {
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken, 'Content-Type': 'multipart/form-data' },
				});
				setNeedsReviewPublications(needsReviewPublications.map((pub) => (pub.id === editPublication.id ? response.data.publication : pub)));
				setSuccess('Публикация успешно обновлена.');
				setOpenSuccess(true);
				setTimeout(() => handleEditCancel(), 2000);
			}
		} catch (err) {
			setError(err.response?.data?.error || 'Ошибка при обновлении. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const renderNeedsReviewStatus = (status) => {
		let statusText = '';
		let statusColor = '#1D1D1F';

		switch (status) {
			case 'needs_review':
				statusText = 'Нуждается в проверке';
				statusColor = '#FF3B30';
				break;
			default:
				statusText = status === 'draft' ? 'Черновик' : status === 'published' ? 'Опубликованные' : status;
				statusColor = '#1D1D1F';
		}

		return <Typography variant="body2" sx={{ color: statusColor }}>{statusText}</Typography>;
	};

	const generateUsername = async () => {
		if (!newLastName || !newFirstName || !newMiddleName) {
			setError('Для генерации логина необходимо заполнить ФИО.');
			setOpenError(true);
			return null;
		}

		const transliterate = (text) => {
			const ruToEn = {
				'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd',
				'е': 'e', 'ё': 'e', 'ж': 'zh', 'з': 'z', 'и': 'i',
				'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n',
				'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't',
				'у': 'u', 'ф': 'f', 'х': 'kh', 'ц': 'ts', 'ч': 'ch',
				'ш': 'sh', 'щ': 'sch', 'ъ': '', 'ы': 'y', 'ь': '',
				'э': 'e', 'ю': 'yu', 'я': 'ya'
			};
			return text.toLowerCase().split('').map(char => ruToEn[char] || char).join('');
		};

		const capitalizeFirstLetter = (string) => {
			if (!string) return '';
			return string.charAt(0).toUpperCase() + string.slice(1);
		};

		const baseUsername = `${capitalizeFirstLetter(transliterate(newLastName))}${capitalizeFirstLetter(transliterate(newFirstName[0]))}${capitalizeFirstLetter(transliterate(newMiddleName[0]))}`;
		let generatedUsername = baseUsername;
		let suffix = 1;

		while (true) {
			try {
				const response = await axios.post('http://localhost:5000/admin_api/admin/check-username', { username: generatedUsername }, {
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				});
				if (!response.data.exists) {
					break;
				}
				generatedUsername = `${baseUsername}${suffix}`;
				suffix++;
			} catch (err) {
				setError('Ошибка проверки логина. Попробуйте снова.');
				setOpenError(true);
				return null;
			}
		}

		return generatedUsername;
	};

	const generateCredentials = async () => {
		const generatedUsername = await generateUsername();
		if (!generatedUsername) return;

		try {
			const response = await axios.get('http://localhost:5000/admin_api/admin/generate-password', {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});
			const generatedPassword = response.data.password;

			setNewUsername(generatedUsername);
			setNewPassword(generatedPassword);
			setSuccess('Логин и пароль успешно сгенерированы.');
			setOpenSuccess(true);
		} catch (err) {
			setError('Ошибка генерации пароля. Попробуйте снова.');
			setOpenError(true);
		}
	};

	const handleCreateUser = async (e) => {
		e.preventDefault();
		if (!newUsername || !newPassword || !newLastName || !newFirstName || !newMiddleName) {
			setError('Все поля обязательны для заполнения.');
			setOpenError(true);
			return;
		}

		try {
			const response = await axios.post('http://localhost:5000/admin_api/admin/register', {
				username: newUsername,
				password: newPassword,
				last_name: newLastName,
				first_name: newFirstName,
				middle_name: newMiddleName,
			}, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});

			if (response.status === 201 && response.data.message && response.data.message.includes('успешно зарегистрирован')) {
				setSuccess('Пользователь успешно создан.');
				setOpenSuccess(true);
				setNewUsername('');
				setNewPassword('');
				setNewLastName('');
				setNewFirstName('');
				setNewMiddleName('');
			}
		} catch (err) {
			setError(err.response?.data?.error || 'Ошибка при создании пользователя. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const handleTogglePasswordVisibility = () => {
		setShowPassword(!showPassword);
	};

	const handleCopyToClipboard = () => {
		const dataToCopy = `Фамилия: ${newLastName}, Имя: ${newFirstName}, Отчество: ${newMiddleName}, Логин: ${newUsername}, Пароль: ${newPassword}`;
		navigator.clipboard.writeText(dataToCopy)
			.then(() => {
				setSuccess('Данные скопированы в буфер обмена.');
				setOpenSuccess(true);
			})
			.catch(() => {
				setError('Ошибка при копировании данных.');
				setOpenError(true);
			});
	};

	const handleEditPlanClick = (planId) => {
		setEditingPlanId(planId);
		setPlans(prevPlans =>
			prevPlans.map(plan =>
				plan.id === planId ? { ...plan, isSaved: false } : plan
			)
		);
	};

	const handleAddPlanEntry = (planId) => {
		setPlans(prevPlans =>
			prevPlans.map(plan =>
				plan.id === planId
					? {
						...plan,
						expectedCount: plan.expectedCount + 1,
						entries: [...plan.entries, { title: '', type: 'article', status: 'planned' }],
					}
					: plan
			)
		);
	};

	const handleDeletePlanEntry = (planId, index) => {
		setPlans(prevPlans =>
			prevPlans.map(plan =>
				plan.id === planId
					? {
						...plan,
						expectedCount: plan.expectedCount - 1,
						entries: plan.entries.filter((_, i) => i !== index),
						isSaved: false,
					}
					: plan
			)
		);
	};

	const handleSavePlan = async (plan) => {
		try {
			const planData = {
				year: plan.year,
				expectedCount: plan.entries.length,
				fillType: 'manual',
				user_id: plan.user_id,
				entries: plan.entries.map(entry => ({
					title: entry.title || '',
					type: entry.type || 'article',
					status: 'planned',
				})),
			};
			const response = await axios.put(`http://localhost:5000/admin_api/admin/plans/${plan.id}`, planData, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken, 'Content-Type': 'application/json' },
			});
			setSuccess('План успешно сохранён!');
			setOpenSuccess(true);
			setEditingPlanId(null);
			setPlans(prevPlans =>
				prevPlans.map(p =>
					p.id === plan.id ? { ...p, entries: planData.entries, isSaved: true } : p
				)
			);
			const plansResponse = await axios.get('http://localhost:5000/admin_api/admin/plans', {
				withCredentials: true,
				params: { page: currentPagePlans, per_page: 10 },
			});
			setPlans(plansResponse.data.plans || []);
		} catch (err) {
			setError(err.response?.data?.error || 'Ошибка при сохранении плана.');
			setOpenError(true);
		}
	};

	const handleDeletePlanClick = (plan) => {
		setPublicationToDelete(plan);
		setOpenDeleteDialog(true);
	};

	const handleDeletePlanConfirm = async () => {
		if (!publicationToDelete) return;

		try {
			await axios.delete(`http://localhost:5000/admin_api/admin/plans/${publicationToDelete.id}`, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});
			setSuccess('План успешно удалён!');
			setOpenSuccess(true);
			const plansResponse = await axios.get('http://localhost:5000/admin_api/admin/plans', {
				withCredentials: true,
				params: { page: currentPagePlans, per_page: 10 },
			});
			setPlans(plansResponse.data.plans || []);
		} catch (err) {
			setError(err.response?.data?.error || 'Ошибка при удалении плана.');
			setOpenError(true);
		} finally {
			setOpenDeleteDialog(false);
			setPublicationToDelete(null);
		}
	};

	const handleApprovePlan = async (plan) => {
		try {
			const response = await axios.post(
				`http://localhost:5000/admin_api/admin/plans/${plan.id}/approve`,
				{},
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);
			setSuccess('План утверждён!');
			setOpenSuccess(true);
			const plansResponse = await axios.get('http://localhost:5000/admin_api/admin/plans', {
				withCredentials: true,
				params: { page: currentPagePlans, per_page: 10 },
			});
			setPlans(plansResponse.data.plans || []);
		} catch (err) {
			setError(err.response?.data?.error || 'Ошибка при утверждении плана.');
			setOpenError(true);
		}
	};

	const handleReturnPlan = async (plan) => {
		try {
			const response = await axios.post(
				`http://localhost:5000/admin_api/admin/plans/${plan.id}/return-for-revision`,
				{},
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);
			setSuccess('План отправлен на доработку!');
			setOpenSuccess(true);
			const plansResponse = await axios.get('http://localhost:5000/admin_api/admin/plans', {
				withCredentials: true,
				params: { page: currentPagePlans, per_page: 10 },
			});
			setPlans(plansResponse.data.plans || []);
		} catch (err) {
			setError(err.response?.data?.error || 'Ошибка при возврате плана.');
			setOpenError(true);
		}
	};

	const handlePlanEntryChange = (planId, index, field, value) => {
		setPlans(prevPlans =>
			prevPlans.map(plan =>
				plan.id === planId
					? {
						...plan,
						entries: plan.entries.map((entry, i) =>
							i === index ? { ...entry, [field]: value } : entry
						),
					}
					: plan
			)
		);
	};

	const areAllTitlesFilled = (plan) => {
		return plan.entries.every(entry => entry.title && entry.title.trim() !== '');
	};

	return (
		<Container maxWidth="lg" sx={{ mt: 8, mb: 4 }}>
			<AppleCard sx={{ p: 4, backgroundColor: '#FFFFFF', borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
				<Typography variant="h4" gutterBottom sx={{ color: '#1D1D1F', fontWeight: 600, textAlign: 'center' }}>
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
											endAdornment: <IconButton sx={{ color: '#0071E3' }}>{/* Можно добавить иконку поиска */}</IconButton>,
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
														<TableCell sx={{ color: '#1D1D1F' }}>{renderNeedsReviewStatus(pub.status)}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{pub.user?.full_name || 'Не указан'}</TableCell>
														<TableCell sx={{ textAlign: 'center' }}>
															<Box sx={{ display: 'flex', justifyContent: 'center', gap: 1 }}>
																<IconButton
																	aria-label="edit"
																	onClick={() => handleEditClick(pub)}
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
																	<EditIcon />
																</IconButton>
																{pub.file_url && (
																	<IconButton
																		aria-label="download"
																		onClick={() => {
																			const link = document.createElement('a');
																			link.href = `http://localhost:5000${pub.file_url}`;
																			link.download = pub.file_url.split('/').pop();
																			document.body.appendChild(link);
																			link.click();
																			document.body.removeChild(link);
																		}}
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
							// Здесь будет содержимое вкладки "Статистика по кафедре"
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
									<form onSubmit={handleCreateUser}>
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
													<IconButton onClick={handleTogglePasswordVisibility}>
														{showPassword ? <VisibilityOff /> : <Visibility />}
													</IconButton>
												),
											}}
										/>
										<Box sx={{ display: 'flex', gap: 2, mt: 2 }}>
											<AppleButton startIcon={<RefreshIcon />} onClick={generateCredentials}>
												Сгенерировать логин и пароль
											</AppleButton>
											<AppleButton startIcon={<ContentCopyIcon />} onClick={handleCopyToClipboard}>
												Скопировать в буфер обмена
											</AppleButton>
											<AppleButton type="submit">Создать</AppleButton>
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
														{plan.status === 'draft' ? 'Черновик' :
															plan.status === 'needs_review' ? 'На проверке' :
																plan.status === 'approved' ? 'Утверждён' :
																	plan.status === 'returned' ? 'Возвращён' : plan.status}
													</TableCell>
													<TableCell sx={{ textAlign: 'center' }}>
														<Box sx={{ display: 'flex', justifyContent: 'center', gap: 1 }}>
															{(plan.status === 'draft' || plan.status === 'returned') && (
																<IconButton
																	aria-label="edit"
																	onClick={() => handleEditPlanClick(plan.id)}
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
																	<EditIcon />
																</IconButton>
															)}
															{plan.status === 'needs_review' && (
																<>
																	<GreenButton onClick={() => handleApprovePlan(plan)}>
																		Утвердить
																	</GreenButton>
																	<AppleButton onClick={() => handleReturnPlan(plan)}>
																		На доработку
																	</AppleButton>
																</>
															)}
															{(plan.status === 'draft' || plan.status === 'returned') && (
																<IconButton
																	aria-label="delete"
																	onClick={() => handleDeletePlanClick(plan)}
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
																	<DeleteIcon />
																</IconButton>
															)}
														</Box>
													</TableCell>
												</TableRow>
												{plan.entries.map((entry, index) => (
													<TableRow key={`${plan.id}-${index}`}>
														<TableCell sx={{ color: '#1D1D1F', pl: 4 }}>{index + 1}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>
															<AppleTextField
																fullWidth
																value={entry.title}
																onChange={(e) => handlePlanEntryChange(plan.id, index, 'title', e.target.value)}
																disabled={editingPlanId !== plan.id || (plan.status !== 'draft' && plan.status !== 'returned')}
																variant="outlined"
																sx={{ backgroundColor: editingPlanId === plan.id && (plan.status === 'draft' || plan.status === 'returned') ? '#FFFFFF' : '#F5F5F7' }}
															/>
														</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>
															<AppleTextField
																fullWidth
																select
																value={entry.type}
																onChange={(e) => handlePlanEntryChange(plan.id, index, 'type', e.target.value)}
																disabled={editingPlanId !== plan.id || (plan.status !== 'draft' && plan.status !== 'returned')}
																variant="outlined"
																sx={{ backgroundColor: editingPlanId === plan.id && (plan.status === 'draft' || plan.status === 'returned') ? '#FFFFFF' : '#F5F5F7' }}
															>
																<MenuItem value="article">Статья</MenuItem>
																<MenuItem value="monograph">Монография</MenuItem>
																<MenuItem value="conference">Доклад/конференция</MenuItem>
															</AppleTextField>
														</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{entry.status}</TableCell>
														<TableCell sx={{ textAlign: 'center' }}>
															{editingPlanId === plan.id && (plan.status === 'draft' || plan.status === 'returned') && (
																<IconButton
																	aria-label="delete-entry"
																	onClick={() => handleDeletePlanEntry(plan.id, index)}
																	sx={{
																		color: '#FF3B30',
																		borderRadius: '8px',
																		'&:hover': {
																			color: '#FFFFFF',
																			backgroundColor: '#FF3B30',
																			boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
																		},
																	}}
																>
																	<DeleteIcon />
																</IconButton>
															)}
														</TableCell>
													</TableRow>
												))}
												{editingPlanId === plan.id && (plan.status === 'draft' || plan.status === 'returned') && (
													<>
														<TableRow>
															<TableCell colSpan={5} sx={{ textAlign: 'center', py: 1 }}>
																<AppleButton onClick={() => handleAddPlanEntry(plan.id)} sx={{ mt: 1 }}>
																	<AddIcon sx={{ mr: 1 }} /> Добавить запись
																</AppleButton>
															</TableCell>
														</TableRow>
														<TableRow>
															<TableCell colSpan={5} sx={{ textAlign: 'right', py: 1 }}>
																<AppleButton onClick={() => handleSavePlan(plan)} sx={{ mt: 1, mr: 2 }}>
																	Сохранить
																</AppleButton>
															</TableCell>
														</TableRow>
													</>
												)}
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
									Вы уверены, что хотите удалить план на {publicationToDelete?.year} год?
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
					</>
				)}
			</AppleCard>
		</Container>
	);
}

export default ManagerDashboard;