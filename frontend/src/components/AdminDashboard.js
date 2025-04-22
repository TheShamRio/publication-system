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
	Grid,
	Alert,
	Pagination,
	Fade,
} from '@mui/material';
import { Autocomplete } from '@mui/material'; // Добавить если нужно автозаполнение для авторов
import MuiTooltip from '@mui/material/Tooltip'; // Для подсказок у иконок
import MenuItem from '@mui/material/MenuItem';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import EditIcon from '@mui/icons-material/Edit';
import AddIcon from '@mui/icons-material/Add';
import PersonIcon from '@mui/icons-material/Person';
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
	const [filterStatus, setFilterStatus] = useState('all');
	const [error, setError] = useState('');
	const [success, setSuccess] = useState('');
	const [openError, setOpenError] = useState(false);
	const [openSuccess, setOpenSuccess] = useState(false);
	const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
	const [userToDelete, setUserToDelete] = useState(null);
	const [publicationToDelete, setPublicationToDelete] = useState(null);
	const [editUser, setEditUser] = useState(null);
	const [editUsername, setEditUsername] = useState('');
	const [editRole, setEditRole] = useState('');
	const [editLastName, setEditLastName] = useState('');
	const [editFirstName, setEditFirstName] = useState('');
	const [publicationTypes, setPublicationTypes] = useState([]); // Для типов
	const [loadingPublicationTypes, setLoadingPublicationTypes] = useState(true);
	const [checkingUserDependencies, setCheckingUserDependencies] = useState(false); // Новое состояние
	// Состояния для редактирования ПУБЛИКАЦИИ (заменяем старые/добавляем новые)
	const [editPublication, setEditPublication] = useState(null);
	const [editTitle, setEditTitle] = useState('');
	const [editYear, setEditYear] = useState('');
	// const [editType, setEditType] = useState(''); // <-- УБРАТЬ
	const [editStatus, setEditStatus] = useState('');
	const [editFile, setEditFile] = useState(null);
	const [editAuthorsList, setEditAuthorsList] = useState([{ id: Date.now(), name: '', is_employee: false }]); // Для авторов
	const [editSelectedDisplayNameId, setEditSelectedDisplayNameId] = useState(''); // Для типа
	// Новые состояния для доп. полей публикации (скопировать из Dashboard.js)
	const [editJournalConferenceName, setEditJournalConferenceName] = useState('');
	const [editDoi, setEditDoi] = useState('');
	const [editIssn, setEditIssn] = useState('');
	const [editIsbn, setEditIsbn] = useState('');
	const [editQuartile, setEditQuartile] = useState('');
	const [editVolume, setEditVolume] = useState('');
	const [editNumber, setEditNumber] = useState('');
	const [editPages, setEditPages] = useState('');
	const [editDepartment, setEditDepartment] = useState('');
	const [editPublisher, setEditPublisher] = useState('');
	const [editPublisherLocation, setEditPublisherLocation] = useState('');
	const [editPrintedSheetsVolume, setEditPrintedSheetsVolume] = useState('');
	const [editCirculation, setEditCirculation] = useState('');
	const [editClassificationCode, setEditClassificationCode] = useState('');
	const [editNotes, setEditNotes] = useState('');
	const [editMiddleName, setEditMiddleName] = useState('');
	const [editNewPassword, setEditNewPassword] = useState('');
	const [showEditPassword, setShowEditPassword] = useState(false);
	const [editAuthors, setEditAuthors] = useState('');
	const [editType, setEditType] = useState('');
	const [openEditDialog, setOpenEditDialog] = useState(false);
	const navigate = useNavigate();
	const { csrfToken, setCsrfToken } = useAuth(); // Добавляем setCsrfToken сюда
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
	const [filterDisplayNameId, setFilterDisplayNameId] = useState('all');
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
					display_name_id: filterDisplayNameId === 'all' ? undefined : parseInt(filterDisplayNameId, 10),
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

	useEffect(() => {
		const fetchPublicationTypes = async () => {
			setLoadingPublicationTypes(true);
			try {
				const response = await axios.get('http://localhost:5000/admin_api/admin/publication-types', { // <-- Админский эндпоинт
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				});
				setPublicationTypes(response.data || []); // Устанавливаем или пустой массив
			} catch (err) {
				console.error('Ошибка загрузки типов публикаций:', err);
				setError('Не удалось загрузить типы публикаций.');
				setOpenError(true);
			} finally {
				setLoadingPublicationTypes(false);
			}
		};
		fetchPublicationTypes();
	}, [csrfToken]); // Зависимость от csrfToken
	// Обработчики изменения полей}

	// Обновление публикаций при смене страницы или фильтров
	useEffect(() => {
		fetchPublications();
	}, [currentPagePublications, filterDisplayNameId, filterStatus]);

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
				// Поиск по авторам (ИСПРАВЛЕНО)
				(
					Array.isArray(pub.authors) && // Проверяем, что это массив
					pub.authors.some(author => // Проверяем, есть ли ХОТЯ БЫ ОДИН автор...
						author.name && // ... у которого есть имя ...
						typeof author.name === 'string' && // ... и это имя - строка ...
						author.name.toLowerCase().includes(search) // ... которое содержит поисковый запрос
					)
				) ||
				// Поиск по году (остается как есть)
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

	const handleFilterDisplayNameIdChange = (e) => {
		setFilterDisplayNameId(e.target.value);
		setCurrentPagePublications(1); // Сбрасываем страницу при смене фильтра
	};


	const handleFilterStatusChange = (e) => {
		setFilterStatus(e.target.value);
		setCurrentPagePublications(1);
	};

	// Обработчики удаления
	const handleDeleteClick = async (type, item) => { // Делаем функцию async
		if (type === 'user') {
			// --- Начало изменений для пользователя ---
			setCheckingUserDependencies(true); // Показываем загрузку (опционально, можно добавить индикатор у кнопки)
			const targetUser = item; // Сохраняем пользователя локально
			setUserToDelete(null); // Сбрасываем, пока не проверим

			try {
				await refreshCsrfToken(); // Убедимся что токен свежий
				const response = await axios.get(`http://localhost:5000/admin_api/admin/users/${targetUser.id}/check-dependencies`, {
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				});

				const { has_published_publications, has_plans } = response.data;

				let errors = [];
				if (has_published_publications) {
					errors.push("опубликованные публикации");
				}
				if (has_plans) {
					errors.push("планы");
				}

				if (errors.length > 0) {
					// Если есть зависимости, показываем ошибку и НЕ открываем диалог
					setError(`Невозможно удалить пользователя «${targetUser.username}». Найдены связанные: ${errors.join(' и ')}.`);
					setOpenError(true);
					setUserToDelete(null); // Убедимся что он сброшен
					setOpenDeleteDialog(false); // Убедимся что диалог закрыт
				} else {
					// Зависимостей нет, открываем диалог подтверждения
					setUserToDelete(targetUser); // Устанавливаем пользователя для удаления
					setOpenDeleteDialog(true); // Открываем диалог
				}

			} catch (err) {
				console.error("Ошибка проверки зависимостей пользователя:", err);
				setError(err.response?.data?.error || 'Не удалось проверить возможность удаления пользователя.');
				setOpenError(true);
				setUserToDelete(null);
				setOpenDeleteDialog(false);
			} finally {
				setCheckingUserDependencies(false); // Скрываем загрузку
			}
			// --- Конец изменений для пользователя ---

		} else if (type === 'publication') {
			// Логика для удаления публикации остается без изменений
			setPublicationToDelete(item);
			setUserToDelete(null); // Сбрасываем пользователя на всякий случай
			setOpenDeleteDialog(true);
		} else {
			// На всякий случай, если появятся другие типы
			console.warn("Неизвестный тип для handleDeleteClick:", type);
			setOpenDeleteDialog(false);
			setUserToDelete(null);
			setPublicationToDelete(null);
		}
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
			// ... код для пользователя без изменений ...
			setEditUser(item);
			setEditUsername(item.username);
			setEditRole(item.role);
			setEditLastName(item.last_name || ''); // Добавить || '' на всякий случай
			setEditFirstName(item.first_name || '');
			setEditMiddleName(item.middle_name || '');
			setEditNewPassword('');
			setShowEditPassword(false);
		} else { // type === 'publication'
			console.log('Editing publication item:', item); // Для отладки
			setEditPublication(item);
			setEditTitle(item.title || '');
			setEditYear(item.year || '');
			setEditStatus(item.status || 'draft'); // Устанавливаем статус
			setEditFile(null); // Сбрасываем файл

			// Инициализация авторов
			if (item.authors && Array.isArray(item.authors) && item.authors.length > 0) {
				setEditAuthorsList(item.authors.map((author, index) => ({
					...author,
					// Добавляем временный ID, если у автора с бэкенда его нет (маловероятно, но для надежности)
					id: author.id || `temp-${Date.now()}-${index}`
				})));
			} else {
				// Если авторов нет, начинаем с одного пустого поля
				setEditAuthorsList([{ id: Date.now(), name: '', is_employee: false }]);
			}

			// Инициализация типа
			setEditSelectedDisplayNameId(item.display_name_id || ''); // Используем display_name_id

			// Инициализация дополнительных полей
			setEditJournalConferenceName(item.journal_conference_name || '');
			setEditDoi(item.doi || '');
			setEditIssn(item.issn || '');
			setEditIsbn(item.isbn || '');
			setEditQuartile(item.quartile || '');
			setEditVolume(item.volume || '');
			setEditNumber(item.number || '');
			setEditPages(item.pages || '');
			setEditDepartment(item.department || '');
			setEditPublisher(item.publisher || '');
			setEditPublisherLocation(item.publisher_location || '');
			setEditPrintedSheetsVolume(item.printed_sheets_volume != null ? String(item.printed_sheets_volume) : '');
			setEditCirculation(item.circulation != null ? String(item.circulation) : '');
			setEditClassificationCode(item.classification_code || '');
			setEditNotes(item.notes || '');
		}
		setOpenEditDialog(true);
	};


	const handleEditCancel = () => {
		if (document.activeElement instanceof HTMLElement) {
			document.activeElement.blur(); // Убираем фокус с текущего активного элемента
		}
		setOpenEditDialog(false);
		setEditUser(null);
		setEditPublication(null); // <-- Сброс публикации

		// Сброс состояний пользователя
		setEditUsername('');
		setEditRole('');
		setEditLastName('');
		setEditFirstName('');
		setEditMiddleName('');
		setEditNewPassword('');
		setShowEditPassword(false);

		// Сброс состояний публикации (заменяем/добавляем)
		setEditTitle('');
		setEditYear('');
		setEditStatus('');
		setEditFile(null);
		setEditAuthorsList([{ id: Date.now(), name: '', is_employee: false }]); // Сброс списка авторов
		setEditSelectedDisplayNameId(''); // Сброс ID типа

		// Сброс доп. полей публикации
		setEditJournalConferenceName('');
		setEditDoi('');
		setEditIssn('');
		setEditIsbn('');
		setEditQuartile('');
		setEditVolume('');
		setEditNumber('');
		setEditPages('');
		setEditDepartment('');
		setEditPublisher('');
		setEditPublisherLocation('');
		setEditPrintedSheetsVolume('');
		setEditCirculation('');
		setEditClassificationCode('');
		setEditNotes('');


		// Сброс ошибок/успеха

	};

	const refreshCsrfToken = async () => {
		try {
			// Используем эндпоинт для получения токена, убедитесь, что он правильный
			const response = await axios.get('http://localhost:5000/api/csrf-token', {
				withCredentials: true,
			});
			setCsrfToken(response.data.csrf_token); // Обновляем токен из контекста
			console.log('CSRF Token обновлён (AdminDashboard):', response.data.csrf_token);
		} catch (err) {
			console.error('Ошибка обновления CSRF Token (AdminDashboard):', err);
			// Здесь можно добавить обработку ошибки, например, показать уведомление
			setError('Не удалось обновить токен безопасности. Попробуйте повторить операцию.');
			setOpenError(true);
			// Можно выбросить ошибку, чтобы прервать выполнение родительской функции
			// throw new Error("CSRF token refresh failed");
		}
	};

	const handleEditAddAuthor = () => {
		setEditAuthorsList([...editAuthorsList, { id: Date.now(), name: '', is_employee: false }]);
	};

	const handleEditAuthorChange = (index, field, value) => {
		const updatedAuthors = [...editAuthorsList];
		updatedAuthors[index][field] = value;
		setEditAuthorsList(updatedAuthors);
	};

	const handleEditRemoveAuthor = (index) => {
		// Не позволяем удалять последнего автора, если он единственный
		if (editAuthorsList.length <= 1) return;
		const updatedAuthors = editAuthorsList.filter((_, i) => i !== index);
		setEditAuthorsList(updatedAuthors);
	};


	const handleEditSubmit = async (e) => {
		e.preventDefault();
		try {
			await refreshCsrfToken(); // Обновляем токен перед запросом

			if (editUser) {
				// --- ЛОГИКА ОБНОВЛЕНИЯ ПОЛЬЗОВАТЕЛЯ (ОСТАВЛЯЕМ КАК ЕСТЬ) ---
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
					headers: { 'X-CSRFToken': csrfToken, 'Content-Type': 'application/json' }, // Явно указываем JSON
				});
				// Обновляем состояние пользователей и закрываем диалог
				setAllUsers(allUsers.map((user) => (user.id === editUser.id ? response.data.user : user)));
				setSuccess('Пользователь успешно обновлён.');
				setOpenSuccess(true);
				handleEditCancel(); // <--- ИЗМЕНЕНИЕ ЗДЕСЬ
			} else if (editPublication) {
				// --- ОБНОВЛЕННАЯ ЛОГИКА ОБНОВЛЕНИЯ ПУБЛИКАЦИИ ---
				// Валидация
				const validAuthors = editAuthorsList.filter(a => a.name?.trim());
				if (!editTitle.trim() || validAuthors.length === 0 || !editYear || !editSelectedDisplayNameId || !editStatus) {
					setError('Название, год, тип, статус и хотя бы один автор с именем обязательны.');
					setOpenError(true);
					return;
				}
				const selectedTypeObject = publicationTypes.find(t => t.display_name_id === editSelectedDisplayNameId);
				if (!selectedTypeObject) {
					setError('Выбран неверный тип публикации.');
					setOpenError(true);
					return;
				}
				const baseTypeId = selectedTypeObject.id;
				const authorsToSend = validAuthors.map(({ id, publication_id, ...rest }) => rest);

				let dataToSend;
				let requestConfig = { // Используем объект конфигурации для Axios
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken }
				};

				if (editFile) {
					// Если есть файл, используем FormData
					requestConfig.headers['Content-Type'] = 'multipart/form-data'; // Хотя Axios сам определит
					dataToSend = new FormData();
					dataToSend.append('file', editFile);
					// Добавляем остальные поля в FormData
					dataToSend.append('title', editTitle.trim());
					dataToSend.append('year', parseInt(editYear, 10));
					dataToSend.append('type_id', baseTypeId);
					dataToSend.append('display_name_id', editSelectedDisplayNameId);
					dataToSend.append('status', editStatus);
					dataToSend.append('authors_json', JSON.stringify(authorsToSend)); // Авторы JSON-строкой
					// Доп. поля как строки
					dataToSend.append('journal_conference_name', editJournalConferenceName || '');
					dataToSend.append('doi', editDoi || '');
					dataToSend.append('issn', editIssn || '');
					dataToSend.append('isbn', editIsbn || '');
					dataToSend.append('quartile', editQuartile || '');
					dataToSend.append('volume', editVolume || '');
					dataToSend.append('number', editNumber || '');
					dataToSend.append('pages', editPages || '');
					dataToSend.append('department', editDepartment || '');
					dataToSend.append('publisher', editPublisher || '');
					dataToSend.append('publisher_location', editPublisherLocation || '');
					dataToSend.append('printed_sheets_volume', editPrintedSheetsVolume || '');
					dataToSend.append('circulation', editCirculation || '');
					dataToSend.append('classification_code', editClassificationCode || '');
					dataToSend.append('notes', editNotes || '');

				} else {
					// Если файла нет, используем обычный JSON объект
					requestConfig.headers['Content-Type'] = 'application/json';
					dataToSend = {
						title: editTitle.trim(),
						year: parseInt(editYear, 10),
						type_id: baseTypeId,
						display_name_id: editSelectedDisplayNameId,
						status: editStatus,
						authors: authorsToSend, // Авторы как массив объектов
						// Остальные поля
						journal_conference_name: editJournalConferenceName || null,
						doi: editDoi || null,
						issn: editIssn || null,
						isbn: editIsbn || null,
						quartile: editQuartile || null,
						volume: editVolume || null,
						number: editNumber || null,
						pages: editPages || null,
						department: editDepartment || null,
						publisher: editPublisher || null,
						publisher_location: editPublisherLocation || null,
						printed_sheets_volume: editPrintedSheetsVolume ? parseFloat(editPrintedSheetsVolume) : null,
						circulation: editCirculation ? parseInt(editCirculation, 10) : null,
						classification_code: editClassificationCode || null,
						notes: editNotes || null,
					};
				}

				// --- Отправка запроса ---
				console.log("Sending PUT request to:", `http://localhost:5000/admin_api/admin/publications/${editPublication.id}`);
				console.log("Request Config:", requestConfig);
				console.log("Request Data:", editFile ? 'FormData content - see Network tab' : dataToSend);


				const response = await axios.put(
					`http://localhost:5000/admin_api/admin/publications/${editPublication.id}`,
					dataToSend, // Отправляем подготовленные данные
					requestConfig // Передаем конфиг с заголовками
				);

				// Обработка успеха (обновление стейта и закрытие диалога)
				setAllPublications(allPublications.map((pub) => (pub.id === editPublication.id ? response.data.publication : pub)));
				setSuccess('Публикация успешно обновлена.');
				setOpenSuccess(true);
				setOpenEditDialog(false); // Закрываем только диалог
				setEditUser(null);
				setEditPublication(null);; // Даём уведомлению отобразиться // <--- ИЗМЕНЕНИЕ ЗДЕСЬ // Закрываем диалог сразу
			}
		} catch (err) {
			// Обработка ошибок (без изменений, но добавил больше логов)
			console.error("Ошибка при обновлении:", err.response || err.request || err.message || err); // Логируем всю ошибку
			if (err.response) {
				console.error("Response Data:", err.response.data);
				console.error("Response Status:", err.response.status);
				console.error("Response Headers:", err.response.headers);
				setError(err.response.data?.error || `Сервер вернул ошибку ${err.response.status}`);
			} else if (err.request) {
				console.error("No response received:", err.request);
				setError("Нет ответа от сервера. Проверьте соединение и работу сервера.");
			} else {
				console.error('Error message:', err.message);
				setError(`Произошла ошибка при отправке запроса: ${err.message}`);
			}
			setOpenError(true);
			setSuccess(''); // Сбросить сообщение об успехе при ошибке
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
			<Collapse in={openSuccess} sx={{ position: 'fixed', top: 70, left: '50%', transform: 'translateX(-50%)', zIndex: 1500, width: 'fit-content' }}>
				{success && (
					<Alert
						severity="success"
						onClose={() => { setSuccess(''); setOpenSuccess(false); }}
						sx={{
							borderRadius: '12px',
							backgroundColor: '#E7F8E7', // Светло-зеленый
							color: '#1D1D1F',          // Темный текст
							boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)',
						}}
					>
						{success}
					</Alert>
				)}
			</Collapse>
			<Collapse in={openError} sx={{ position: 'fixed', top: openSuccess ? 130 : 70, left: '50%', transform: 'translateX(-50%)', zIndex: 1499, width: 'fit-content' }}>
				{error && (
					<Alert
						severity="error"
						onClose={() => { setError(''); setOpenError(false); }}
						sx={{
							borderRadius: '12px',
							backgroundColor: '#FFF1F0', // Светло-красный
							color: '#1D1D1F',          // Темный текст
							boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)',
						}}
					>
						{error}
					</Alert>
				)}
			</Collapse>
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
											value={filterDisplayNameId} // Используем новый state
											onChange={handleFilterDisplayNameIdChange} // Используем новый обработчик
											margin="normal"
											variant="outlined"
											disabled={loadingPublicationTypes || publicationTypes.length === 0} // Блокируем пока грузится или пусто
											sx={{ minWidth: 200 }} // Можно настроить ширину
										>
											{/* Опция "Все" */}
											<MenuItem value="all">Все</MenuItem>

											{/* Placeholder или динамические опции */}
											{loadingPublicationTypes ? (
												<MenuItem value="all" disabled>Загрузка типов...</MenuItem>
											) : (
												publicationTypes.map((type) => (
													<MenuItem key={type.display_name_id} value={type.display_name_id}>
														{type.display_name}
													</MenuItem>
												))
											)}
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
														<TableCell sx={{ color: '#1D1D1F' }}>
															{/* Проверяем, что pub.authors - это массив и он не пустой */}
															{Array.isArray(pub.authors) && pub.authors.length > 0
																// Если да, берем имя каждого автора и соединяем через запятую
																? pub.authors.map(author => author.name).join(', ')
																// Если нет, или массив пустой, пишем "Нет авторов"
																: 'Нет авторов'
															}
														</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{pub.year}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>
															{/* Пробуем отображаемое имя, потом имя базового типа, потом заглушку */}
															{pub.type?.display_name || pub.type?.name || 'Неизвестный тип'}
														</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>{renderStatus(pub.status)}</TableCell>
														<TableCell sx={{ color: '#1D1D1F' }}>
															{/* Обращение к данным пользователя должно быть таким */}
															{pub.user?.full_name || 'Не указан'}
														</TableCell>
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
												select
												label="Тип публикации"
												// Используем editSelectedDisplayNameId или пустую строку, если оно null/undefined
												value={
													// Если типы еще не загружены ИЛИ (типы загружены НО нужный ID не найден)
													// -> используем '', иначе используем ID
													loadingPublicationTypes || !publicationTypes.find(t => t.display_name_id === editSelectedDisplayNameId)
														? ''
														: editSelectedDisplayNameId
												}
												onChange={(e) => setEditSelectedDisplayNameId(e.target.value === '' ? null : e.target.value)} // Можно сбрасывать в null если пусто
												margin="normal"
												variant="outlined"
												// Блокируем, пока типы не загружены
												disabled={loadingPublicationTypes}
												error={!editSelectedDisplayNameId && !loadingPublicationTypes && publicationTypes.length > 0} // Показываем ошибку, если тип обязателен и не выбран после загрузки
												helperText={!editSelectedDisplayNameId && !loadingPublicationTypes && publicationTypes.length > 0 ? 'Выберите тип' : ''}
											>
												{/* Показываем опцию "Загрузка..." */}
												{loadingPublicationTypes && <MenuItem value="" disabled>Загрузка типов...</MenuItem>}
												{/* Показываем "Не найдены", если массив пуст после загрузки */}
												{!loadingPublicationTypes && publicationTypes.length === 0 && <MenuItem value="" disabled>Типы не найдены</MenuItem>}
												{/* Отображаем опции, только если они есть */}
												{!loadingPublicationTypes && publicationTypes.length > 0 && publicationTypes.map((type) => (
													<MenuItem key={type.display_name_id} value={type.display_name_id}>
														{type.display_name}
													</MenuItem>
												))}
											</AppleTextField>

											{/* === Название === */}
											<AppleTextField
												fullWidth
												label="Название"
												value={editTitle}
												onChange={(e) => setEditTitle(e.target.value)}
												margin="normal"
												variant="outlined"
											/>

											{/* === Динамический список авторов === */}
											<Box sx={{ mt: 2, border: '1px solid #D1D1D6', borderRadius: '12px', p: 2, backgroundColor: '#FFFFFF' }}>
												<Typography variant="subtitle1" sx={{ mb: 1, color: '#1D1D1F' }}>Авторы</Typography>
												{editAuthorsList.map((author, index) => (
													<Grid container spacing={1} key={author.id} sx={{ mb: 1, alignItems: 'center' }}>
														<Grid item xs={true}> {/* Занимает все доступное место */}
															<AppleTextField
																fullWidth
																required
																label={`Автор ${index + 1}`}
																value={author.name}
																onChange={(e) => handleEditAuthorChange(index, 'name', e.target.value)}
																size="small" // Делаем поля компактнее
																variant="outlined"
															/>
														</Grid>
														{/* Иконка "Сотрудник" */}
														<Grid item xs="auto">
															<MuiTooltip title={author.is_employee ? "Автор сотрудник КНИТУ-КАИ" : "Автор не сотрудник КНИТУ-КАИ"} arrow>
																<IconButton
																	onClick={() => handleEditAuthorChange(index, 'is_employee', !author.is_employee)}
																	size="small"
																	sx={{
																		color: author.is_employee ? '#0071E3' : 'grey.500',
																		'&:hover': {
																			backgroundColor: author.is_employee ? 'rgba(0, 113, 227, 0.1)' : 'rgba(0, 0, 0, 0.04)',
																		}
																	}}
																	aria-label={author.is_employee ? "Пометить как не сотрудника" : "Пометить как сотрудника"}
																>
																	<PersonIcon fontSize="small" />
																</IconButton>
															</MuiTooltip>
														</Grid>
														{/* Кнопка удаления */}
														<Grid item xs="auto">
															{editAuthorsList.length > 1 && (
																<IconButton
																	onClick={() => handleEditRemoveAuthor(index)}
																	size="small"
																	sx={{ color: '#FF3B30' }} // Красный цвет для удаления
																	aria-label="Удалить автора"
																>
																	<DeleteIcon fontSize="small" />
																</IconButton>
															)}
														</Grid>
													</Grid>
												))}
												{/* Кнопка добавления автора */}
												<Button
													startIcon={<AddIcon />}
													onClick={handleEditAddAuthor}
													size="small"
													sx={{ mt: 1, textTransform: 'none', color: '#0071E3' }}
												>
													Добавить автора
												</Button>
											</Box>


											{/* === Год === */}
											<AppleTextField
												fullWidth
												label="Год"
												type="number"
												value={editYear}
												onChange={(e) => setEditYear(e.target.value)}
												margin="normal"
												variant="outlined"
											/>

											{/* === Статус (для Админа/Менеджера) === */}
											{/* Оставим пока как есть, админ может менять статус */}
											<AppleTextField
												fullWidth
												select
												label="Статус"
												value={editStatus}
												onChange={(e) => setEditStatus(e.target.value)}
												margin="normal"
												variant="outlined"
											// Может быть логика disabled, если файл не прикреплен и т.д.
											>
												<MenuItem value="draft">Черновик</MenuItem>
												<MenuItem value="needs_review">Нуждается в проверке</MenuItem>
												<MenuItem value="returned_for_revision">Возвращено на доработку</MenuItem> {/* Добавлен статус */}
												<MenuItem value="published">Опубликовано</MenuItem>
											</AppleTextField>


											{/* --- Дополнительные поля (скопировать из Dashboard.js) --- */}
											<AppleTextField
												fullWidth
												label="Наименование журнала/конференции"
												value={editJournalConferenceName}
												onChange={(e) => setEditJournalConferenceName(e.target.value)}
												margin="normal"
												variant="outlined"
											/>
											<Grid container spacing={2}>
												<Grid item xs={12} sm={6}>
													<AppleTextField fullWidth label="DOI" value={editDoi} onChange={(e) => setEditDoi(e.target.value)} margin="normal" variant="outlined" />
												</Grid>
												<Grid item xs={12} sm={6}>
													<AppleTextField fullWidth label="Квартиль (Q)" value={editQuartile} onChange={(e) => setEditQuartile(e.target.value)} margin="normal" variant="outlined" />
												</Grid>
												<Grid item xs={12} sm={6}>
													<AppleTextField fullWidth label="ISSN" value={editIssn} onChange={(e) => setEditIssn(e.target.value)} margin="normal" variant="outlined" />
												</Grid>
												<Grid item xs={12} sm={6}>
													<AppleTextField fullWidth label="ISBN" value={editIsbn} onChange={(e) => setEditIsbn(e.target.value)} margin="normal" variant="outlined" />
												</Grid>
											</Grid>
											<Grid container spacing={2}>
												<Grid item xs={12} sm={4}>
													<AppleTextField fullWidth label="Том" value={editVolume} onChange={(e) => setEditVolume(e.target.value)} margin="normal" variant="outlined" />
												</Grid>
												<Grid item xs={12} sm={4}>
													<AppleTextField fullWidth label="Номер/Выпуск" value={editNumber} onChange={(e) => setEditNumber(e.target.value)} margin="normal" variant="outlined" />
												</Grid>
												<Grid item xs={12} sm={4}>
													<AppleTextField fullWidth label="Страницы" value={editPages} onChange={(e) => setEditPages(e.target.value)} margin="normal" variant="outlined" />
												</Grid>
											</Grid>
											<Grid container spacing={2}>
												<Grid item xs={12} sm={6}>
													<AppleTextField fullWidth label="Издательство" value={editPublisher} onChange={(e) => setEditPublisher(e.target.value)} margin="normal" variant="outlined" />
												</Grid>
												<Grid item xs={12} sm={6}>
													<AppleTextField fullWidth label="Место издательства" value={editPublisherLocation} onChange={(e) => setEditPublisherLocation(e.target.value)} margin="normal" variant="outlined" />
												</Grid>
												<Grid item xs={12} sm={4}>
													<AppleTextField fullWidth label="Объем (п.л.)" type="number" value={editPrintedSheetsVolume} onChange={(e) => setEditPrintedSheetsVolume(e.target.value)} margin="normal" variant="outlined" inputProps={{ step: "0.1" }} />
												</Grid>
												<Grid item xs={12} sm={4}>
													<AppleTextField fullWidth label="Тираж" type="number" value={editCirculation} onChange={(e) => setEditCirculation(e.target.value)} margin="normal" variant="outlined" />
												</Grid>
												<Grid item xs={12} sm={4}>
													<AppleTextField fullWidth label="Кафедра" value={editDepartment} onChange={(e) => setEditDepartment(e.target.value)} margin="normal" variant="outlined" />
												</Grid>
											</Grid>
											<AppleTextField fullWidth label="Код по классификатору" value={editClassificationCode} onChange={(e) => setEditClassificationCode(e.target.value)} margin="normal" variant="outlined" />
											<AppleTextField fullWidth label="Примечание" value={editNotes} onChange={(e) => setEditNotes(e.target.value)} margin="normal" variant="outlined" multiline rows={2} />

											{/* --- Поле для загрузки файла (без изменений) --- */}
											<Box sx={{ mt: 2 }}>
												<Typography variant="body2" sx={{ color: '#6E6E73', mb: 1 }}>
													Текущий файл: {editPublication?.file_url ? editPublication.file_url.split('/').pop() : 'Нет файла'}
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