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
import MenuItem from '@mui/material/MenuItem';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import DownloadIcon from '@mui/icons-material/Download';
import Visibility from '@mui/icons-material/Visibility';
import VisibilityOff from '@mui/icons-material/VisibilityOff';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import axios from 'axios';
import { styled } from '@mui/system';

// Стили компонентов (без изменений)
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

const namePartRegex = /^[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?$/;
const fullNameRegex = /^[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?\s[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?\s[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?$/;

function AdminDashboard() {
	const [value, setValue] = useState(0);
	const [users, setUsers] = useState([]);
	const [allUsers, setAllUsers] = useState([]);
	const [publications, setPublications] = useState([]);
	const [allPublications, setAllPublications] = useState([]);
	const [currentPageUsers, setCurrentPageUsers] = useState(1);
	const [totalPagesUsers, setTotalPagesUsers] = useState(1);
	const [currentPagePublications, setCurrentPagePublications] = useState(1);
	const [totalPagesPublications, setTotalPagesPublications] = useState(1);
	const [loadingInitial, setLoadingInitial] = useState(true);
	const [searchQueryUsers, setSearchQueryUsers] = useState('');
	const [searchQueryPublications, setSearchQueryPublications] = useState('');
	const [filterType, setFilterType] = useState('all');
	const [filterStatus, setFilterStatus] = useState('all');
	const [error, setError] = useState('');
	const [success, setSuccess] = useState('');
	const [openError, setOpenError] = useState(false);
	const [openSuccess, setOpenSuccess] = useState(false);
	const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
	const [userToDelete, setUserToDelete] = useState(null);
	const [publicationToDelete, setPublicationToDelete] = useState(null);
	const [editUser, setEditUser] = useState(null);
	const [editPublication, setEditPublication] = useState(null);
	const [editUsername, setEditUsername] = useState('');
	const [editRole, setEditRole] = useState('');
	const [editLastName, setEditLastName] = useState('');
	const [editFirstName, setEditFirstName] = useState('');
	const [editMiddleName, setEditMiddleName] = useState('');
	const [editNewPassword, setEditNewPassword] = useState('');
	const [showEditPassword, setShowEditPassword] = useState(false);
	const [editTitle, setEditTitle] = useState('');
	const [editAuthors, setEditAuthors] = useState('');
	const [editYear, setEditYear] = useState('');
	const [editType, setEditType] = useState('');
	const [editStatus, setEditStatus] = useState('');
	const [editFile, setEditFile] = useState(null);
	const [openEditDialog, setOpenEditDialog] = useState(false);
	const navigate = useNavigate();
	const { csrfToken } = useAuth();
	const [newLastName, setNewLastName] = useState('');
	const [newFirstName, setNewFirstName] = useState('');
	const [newMiddleName, setNewMiddleName] = useState('');
	const [newUsername, setNewUsername] = useState('');
	const [newPassword, setNewPassword] = useState('');
	const [showPassword, setShowPassword] = useState(false);
	const [lastNameError, setLastNameError] = useState('');
	const [firstNameError, setFirstNameError] = useState('');
	const [middleNameError, setMiddleNameError] = useState('');
	const [usersTransitionKey, setUsersTransitionKey] = useState(0);
	const [publicationsTransitionKey, setPublicationsTransitionKey] = useState(0);

	const ITEMS_PER_PAGE = 10;

	// Таймеры для автозакрытия уведомлений
	useEffect(() => {
		let errorTimer, successTimer;
		if (openError) errorTimer = setTimeout(() => setOpenError(false), 3000);
		if (openSuccess) successTimer = setTimeout(() => setOpenSuccess(false), 3000);
		return () => {
			if (errorTimer) clearTimeout(errorTimer);
			if (successTimer) clearTimeout(successTimer);
		};
	}, [openError, openSuccess]);

	// Функция загрузки пользователей
	const fetchUsers = async () => {
		try {
			const response = await axios.get('http://localhost:5000/admin_api/admin/users', {
				withCredentials: true,
				params: { page: currentPageUsers, per_page: ITEMS_PER_PAGE },
				headers: { 'X-CSRFToken': csrfToken },
			});
			setAllUsers(response.data.users || []);
			setTotalPagesUsers(response.data.pages || 1);
			setUsersTransitionKey((prev) => prev + 1);
		} catch (err) {
			setError('Ошибка загрузки пользователей. Попробуйте позже.');
			setOpenError(true);
		}
	};

	// Функция загрузки публикаций
	const fetchPublications = async () => {
		try {
			const response = await axios.get('http://localhost:5000/admin_api/admin/publications', {
				withCredentials: true,
				params: {
					page: currentPagePublications,
					per_page: ITEMS_PER_PAGE,
					type: filterType === 'all' ? undefined : filterType,
					status: filterStatus === 'all' ? undefined : filterStatus,
				},
				headers: { 'X-CSRFToken': csrfToken },
			});
			setAllPublications(response.data.publications || []);
			setTotalPagesPublications(response.data.pages || 1);
			setPublicationsTransitionKey((prev) => prev + 1);
		} catch (err) {
			setError('Ошибка загрузки публикаций. Попробуйте позже.');
			setOpenError(true);
		}
	};

	// Инициализация данных при монтировании
	useEffect(() => {
		setLoadingInitial(true);
		Promise.all([fetchUsers(), fetchPublications()]).finally(() => setLoadingInitial(false));
	}, []);

	// Обновление пользователей при смене страницы
	useEffect(() => {
		fetchUsers();
	}, [currentPageUsers]);

	// Обновление публикаций при смене страницы или фильтров
	useEffect(() => {
		fetchPublications();
	}, [currentPagePublications, filterType, filterStatus]);

	// Локальная фильтрация пользователей
	useEffect(() => {
		const filtered = allUsers.filter((user) => {
			const search = searchQueryUsers.toLowerCase();
			return (
				(user.username?.toLowerCase() ?? '').includes(search) ||
				(user.last_name?.toLowerCase() ?? '').includes(search) ||
				(user.first_name?.toLowerCase() ?? '').includes(search) ||
				(user.middle_name?.toLowerCase() ?? '').includes(search)
			);
		});
		setUsers(filtered);
	}, [allUsers, searchQueryUsers]);

	// Локальная фильтрация публикаций
	useEffect(() => {
		const filtered = allPublications.filter((pub) => {
			const search = searchQueryPublications.toLowerCase();
			return (
				(pub.title?.toLowerCase() ?? '').includes(search) ||
				(pub.authors?.toLowerCase() ?? '').includes(search) ||
				(pub.year?.toString() ?? '').includes(search)
			);
		});
		setPublications(filtered);
	}, [allPublications, searchQueryPublications]);

	// Обработчик смены вкладок
	const handleTabChange = (event, newValue) => {
		setValue(newValue);
		setSearchQueryUsers('');
		setSearchQueryPublications('');
		setFilterType('all');
		setFilterStatus('all');
		setCurrentPageUsers(1);
		setCurrentPagePublications(1);
	};

	// Обработчики пагинации
	const handlePageChangeUsers = (event, newPage) => {
		setCurrentPageUsers(newPage);
	};

	const handlePageChangePublications = (event, newPage) => {
		setCurrentPagePublications(newPage);
	};

	// Обработчики поиска
	const handleSearchUsersChange = (e) => {
		setSearchQueryUsers(e.target.value);
	};

	const handleSearchPublicationsChange = (e) => {
		setSearchQueryPublications(e.target.value);
	};

	// Обработчики фильтров
	const handleFilterTypeChange = (e) => {
		setFilterType(e.target.value);
		setCurrentPagePublications(1);
	};

	const handleFilterStatusChange = (e) => {
		setFilterStatus(e.target.value);
		setCurrentPagePublications(1);
	};

	// Обработчики удаления
	const handleDeleteClick = (type, item) => {
		if (type === 'user') {
			setUserToDelete(item);
		} else {
			setPublicationToDelete(item);
		}
		setOpenDeleteDialog(true);
	};

	const handleDeleteCancel = () => {
		setOpenDeleteDialog(false);
		setUserToDelete(null);
		setPublicationToDelete(null);
	};

	const handleDeleteConfirm = async () => {
		try {
			if (userToDelete) {
				await axios.delete(`http://localhost:5000/admin_api/admin/users/${userToDelete.id}`, {
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				});
				setAllUsers(allUsers.filter((user) => user.id !== userToDelete.id));
				setSuccess('Пользователь успешно удалён.');
				setOpenSuccess(true);
			} else if (publicationToDelete) {
				await axios.delete(`http://localhost:5000/admin_api/admin/publications/${publicationToDelete.id}`, {
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				});
				setAllPublications(allPublications.filter((pub) => pub.id !== publicationToDelete.id));
				setSuccess('Публикация успешно удалена.');
				setOpenSuccess(true);
			}
		} catch (err) {
			setError('Ошибка при удалении. Попробуйте позже.');
			setOpenError(true);
		} finally {
			setOpenDeleteDialog(false);
			setUserToDelete(null);
			setPublicationToDelete(null);
		}
	};

	// Обработчики редактирования
	const handleEditClick = (type, item) => {
		if (type === 'user') {
			setEditUser(item);
			setEditUsername(item.username);
			setEditRole(item.role);
			setEditLastName(item.last_name);
			setEditFirstName(item.first_name);
			setEditMiddleName(item.middle_name || '');
			setEditNewPassword('');
			setShowEditPassword(false);
		} else {
			setEditPublication(item);
			setEditTitle(item.title);
			setEditAuthors(item.authors);
			setEditYear(item.year);
			setEditType(item.type);
			setEditStatus(item.status);
			setEditFile(null);
		}
		setOpenEditDialog(true);
	};

	const handleEditCancel = () => {
		setOpenEditDialog(false);
		setEditUser(null);
		setEditPublication(null);
		setEditUsername('');
		setEditRole('');
		setEditLastName('');
		setEditFirstName('');
		setEditMiddleName('');
		setEditNewPassword('');
		setShowEditPassword(false);
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
			if (editUser) {
				const updatedUser = {
					username: editUsername,
					role: editRole,
					last_name: editLastName,
					first_name: editFirstName,
					middle_name: editMiddleName,
				};
				if (editNewPassword) {
					updatedUser.new_password = editNewPassword;
				}
				const response = await axios.put(`http://localhost:5000/admin_api/admin/users/${editUser.id}`, updatedUser, {
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				});
				setAllUsers(allUsers.map((user) => (user.id === editUser.id ? response.data.user : user)));
				setSuccess('Пользователь успешно обновлён.');
				setOpenSuccess(true);
				setTimeout(() => handleEditCancel(), 2000);
			} else if (editPublication) {
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
				setAllPublications(allPublications.map((pub) => (pub.id === editPublication.id ? response.data.publication : pub)));
				setSuccess('Публикация успешно обновлена.');
				setOpenSuccess(true);
				setTimeout(() => handleEditCancel(), 2000);
			}
		} catch (err) {
			setError(err.response?.data?.error || 'Ошибка при обновлении. Попробуйте позже.');
			setOpenError(true);
		}
	};

	// Валидация имени
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

	// Обработчики изменения полей создания пользователя
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

	// Генерация логина и пароля
	const handleGenerateCredentials = async () => {
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
				return;
			}
		}

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
			setError('Ошибка генерации пароля. Попробуйте снова.');
			setOpenError(true);
		}
	};

	// Создание пользователя
	const handleCreateUser = async () => {
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
				setNewLastName('');
				setNewFirstName('');
				setNewMiddleName('');
				setNewUsername('');
				setNewPassword('');
				setLastNameError('');
				setFirstNameError('');
				setMiddleNameError('');
				await fetchUsers();
			}
		} catch (err) {
			setError(err.response?.data?.error || 'Ошибка при создании пользователя. Попробуйте позже.');
			setOpenError(true);
		}
	};

	// Переключение видимости пароля
	const handleTogglePasswordVisibility = () => {
		setShowPassword(!showPassword);
	};

	const handleToggleEditPasswordVisibility = () => {
		setShowEditPassword(!showEditPassword);
	};

	// Копирование в буфер обмена
	const handleCopyToClipboard = () => {
		const dataToCopy = `Логин: ${newUsername}\nПароль: ${newPassword}`;
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

	// Отображение статуса публикации
	const renderStatus = (status) => {
		let statusText = '';
		switch (status) {
			case 'draft':
				statusText = 'Черновик';
				break;
			case 'needs_review':
				statusText = 'Нуждается в проверке';
				break;
			case 'published':
				statusText = 'Опубликованные';
				break;
			default:
				statusText = status;
		}
		return <Typography variant="body2" sx={{ color: '#1D1D1F' }}>{statusText}</Typography>;
	};

	return (
		<Container maxWidth="lg" sx={{ mt: 8, mb: 4 }}>
			<AppleCard sx={{ p: 4, backgroundColor: '#FFFFFF', borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
				<Typography variant="h4" gutterBottom sx={{ color: '#1D1D1F', fontWeight: 600, textAlign: 'center' }}>
					Панель администратора
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
					<Tab label="Пользователи" />
					<Tab label="Все публикации" />
				</Tabs>

				{loadingInitial ? (
					<Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
						<CircularProgress sx={{ color: '#0071E3' }} />
					</Box>
				) : (
					<>
						{value === 0 && (
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
													<IconButton onClick={handleTogglePasswordVisibility}>
														{showPassword ? <VisibilityOff /> : <Visibility />}
													</IconButton>
												),
											}}
										/>
										<Box sx={{ display: 'flex', gap: 2, mt: 2 }}>
											<AppleButton onClick={handleGenerateCredentials}>
												Сгенерировать логин и пароль
											</AppleButton>
											<AppleButton startIcon={<ContentCopyIcon />} onClick={handleCopyToClipboard}>
												Скопировать в буфер обмена
											</AppleButton>
											<AppleButton onClick={handleCreateUser}>Создать</AppleButton>
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
									Управление пользователями
								</Typography>
								<AppleCard sx={{ mt: 2, mb: 2, p: 2, backgroundColor: '#F5F5F7', borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
									<AppleTextField
										fullWidth
										label="Поиск по логину или ФИО"
										value={searchQueryUsers}
										onChange={handleSearchUsersChange}
										margin="normal"
										variant="outlined"
									/>
								</AppleCard>
								<AppleTable sx={{ mt: 2, boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
									<TableHead>
										<TableRow sx={{ backgroundColor: '#0071E3' }}>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', borderRadius: '12px 0 0 0' }}>ID</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Логин</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Роль</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Фамилия</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Имя</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Отчество</TableCell>
											<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', textAlign: 'center', borderRadius: '0 12px 0 0' }}>
												Действия
											</TableCell>
										</TableRow>
									</TableHead>
									<Fade in={true} timeout={500} key={usersTransitionKey}>
										<TableBody>
											{users.length > 0 ? (
												users.map((user) => (
													<TableRow
														key={user.id}
														sx={{
															'&:hover': { backgroundColor: '#F5F5F7', transition: 'background-color 0.3s ease' },
														}}
													>
														<TableCell sx={{ color: '#1D1D1F' }}>{user.id}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{user.username}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{user.role}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{user.last_name}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{user.first_name}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{user.middle_name || '-'}</TableCell>
														<TableCell sx={{ textAlign: 'center' }}>
															<Box sx={{ display: 'flex', justifyContent: 'center', gap: 1 }}>
																<IconButton
																	aria-label="edit"
																	onClick={() => handleEditClick('user', user)}
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
																<IconButton
																	aria-label="delete"
																	onClick={() => handleDeleteClick('user', user)}
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
															</Box>
														</TableCell>
													</TableRow>
												))
											) : (
												<TableRow>
													<TableCell colSpan={7} sx={{ textAlign: 'center', color: '#6E6E73' }}>
														Нет пользователей.
													</TableCell>
												</TableRow>
											)}
										</TableBody>
									</Fade>
								</AppleTable>
								<Box sx={{ mt: 2, display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
									<Pagination
										count={totalPagesUsers}
										page={currentPageUsers}
										onChange={handlePageChangeUsers}
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
									Управление всеми публикациями
								</Typography>
								<AppleCard sx={{ mt: 2, mb: 2, p: 2, backgroundColor: '#F5F5F7', borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
									<AppleTextField
										fullWidth
										label="Поиск по названию, авторам или году"
										value={searchQueryPublications}
										onChange={handleSearchPublicationsChange}
										margin="normal"
										variant="outlined"
									/>
									<Box sx={{ mt: 2, display: 'flex', gap: 2 }}>
										<AppleTextField
											select
											label="Тип публикации"
											value={filterType}
											onChange={handleFilterTypeChange}
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
											value={filterStatus}
											onChange={handleFilterStatusChange}
											margin="normal"
											variant="outlined"
										>
											<MenuItem value="all">Все</MenuItem>
											<MenuItem value="draft">Черновик</MenuItem>
											<MenuItem value="needs_review">Нуждается в проверке</MenuItem>
											<MenuItem value="published">Опубликованные</MenuItem>
										</AppleTextField>
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
														<TableCell sx={{ color: '#1D1D1F' }}>{renderStatus(pub.status)}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{pub.user?.full_name || 'Не указан'}</TableCell>
														<TableCell sx={{ textAlign: 'center' }}>
															<Box sx={{ display: 'flex', justifyContent: 'center', gap: 1 }}>
																<IconButton
																	aria-label="edit"
																	onClick={() => handleEditClick('publication', pub)}
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
																<IconButton
																	aria-label="delete"
																	onClick={() => handleDeleteClick('publication', pub)}
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
														Нет публикаций.
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
							</>
						)}

						<Dialog
							open={openDeleteDialog}
							onClose={handleDeleteCancel}
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
									Вы уверены, что хотите удалить{' '}
									{userToDelete ? `пользователя «${userToDelete.username}»` : `публикацию «${publicationToDelete?.title}»`}?
								</Typography>
							</DialogContent>
							<DialogActions sx={{ padding: '16px 24px', borderTop: '1px solid #E5E5EA' }}>
								<CancelButton onClick={handleDeleteCancel}>Отмена</CancelButton>
								<AppleButton onClick={handleDeleteConfirm}>Удалить</AppleButton>
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
								{editUser ? 'Редактировать пользователя' : 'Редактировать публикацию'}
							</DialogTitle>
							<DialogContent sx={{ padding: '24px' }}>
								<form onSubmit={handleEditSubmit}>
									{editUser ? (
										<>
											<AppleTextField
												fullWidth
												label="Логин"
												value={editUsername}
												onChange={(e) => setEditUsername(e.target.value)}
												margin="normal"
												variant="outlined"
												autoComplete="username"
											/>
											<AppleTextField
												fullWidth
												select
												label="Роль"
												value={editRole}
												onChange={(e) => setEditRole(e.target.value)}
												margin="normal"
												variant="outlined"
											>
												<MenuItem value="user">Пользователь</MenuItem>
												<MenuItem value="admin">Администратор</MenuItem>
												<MenuItem value="manager">Управляющий</MenuItem>
											</AppleTextField>
											<AppleTextField
												fullWidth
												label="Фамилия"
												value={editLastName}
												onChange={(e) => setEditLastName(e.target.value)}
												margin="normal"
												variant="outlined"
												autoComplete="family-name"
											/>
											<AppleTextField
												fullWidth
												label="Имя"
												value={editFirstName}
												onChange={(e) => setEditFirstName(e.target.value)}
												margin="normal"
												variant="outlined"
												autoComplete="given-name"
											/>
											<AppleTextField
												fullWidth
												label="Отчество"
												value={editMiddleName}
												onChange={(e) => setEditMiddleName(e.target.value)}
												margin="normal"
												variant="outlined"
												autoComplete="additional-name"
											/>
											<AppleTextField
												fullWidth
												label="Новый пароль (если нужно изменить)"
												type={showEditPassword ? 'text' : 'password'}
												value={editNewPassword}
												onChange={(e) => setEditNewPassword(e.target.value)}
												margin="normal"
												variant="outlined"
												autoComplete="new-password"
												InputProps={{
													endAdornment: (
														<IconButton onClick={handleToggleEditPasswordVisibility}>
															{showEditPassword ? <VisibilityOff /> : <Visibility />}
														</IconButton>
													),
												}}
											/>
										</>
									) : (
										<>
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
										</>
									)}
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

export default AdminDashboard;