import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import {
	Container,
	Typography,
	LinearProgress,
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
import { styled, GlobalStyles } from '@mui/system';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import DownloadIcon from '@mui/icons-material/Download';
import CheckIcon from '@mui/icons-material/Check';
import ReplayIcon from '@mui/icons-material/Replay';
import RefreshIcon from '@mui/icons-material/Refresh';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import Visibility from '@mui/icons-material/Visibility';
import VisibilityOff from '@mui/icons-material/VisibilityOff';
import LightbulbOutlinedIcon from '@mui/icons-material/LightbulbOutlined';
import HistoryIcon from '@mui/icons-material/History';
import WarningAmberIcon from '@mui/icons-material/WarningAmber';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import { TransitionGroup, CSSTransition } from 'react-transition-group';
import axios from 'axios';
import { useAuth } from '../contexts/AuthContext';
import StatusChip from './StatusChip';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

// Стили компонентов
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

// Глобальные стили для анимации аккордеонов
const animationStyles = (
	<GlobalStyles
		styles={{
			'.accordion-enter': {
				opacity: 0,
				transform: 'translateY(20px)',
			},
			'.accordion-enter-active': {
				opacity: 1,
				transform: 'translateY(0)',
				transition: 'opacity 300ms ease, transform 300ms ease',
			},
			'.accordion-exit': {
				opacity: 1,
				transform: 'translateY(0)',
			},
			'.accordion-exit-active': {
				opacity: 0,
				transform: 'translateY(20px)',
				transition: 'opacity 300ms ease, transform 300ms ease',
			},
		}}
	/>
);

// Регулярные выражения для проверки ФИО
const namePartRegex = /^[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?$/;
const fullNameRegex = /^[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?\s[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?\s[А-ЯЁ][а-яё]+(?:-[А-ЯЁ][а-яё]+)?$/;

function ManagerDashboard() {
	const { user, csrfToken, isAuthenticated } = useAuth();
	const navigate = useNavigate();
	const [value, setValue] = useState(0);
	const [publications, setPublications] = useState([]);
	const [plans, setPlans] = useState([]);
	const [statistics, setStatistics] = useState([]);
	const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());
	const [currentPagePublications, setCurrentPagePublications] = useState(1);
	const [currentPagePlans, setCurrentPagePlans] = useState(1);
	const [dateFilterRange, setDateFilterRange] = useState({ start: '', end: '' });
	const [totalPagesPublications, setTotalPagesPublications] = useState(1);
	const [totalPagesPlans, setTotalPagesPlans] = useState(1);
	const [searchQuery, setSearchQuery] = useState('');
	const [statusFilter, setStatusFilter] = useState('needs_review');
	const [loadingInitial, setLoadingInitial] = useState(true);
	const [loadingStatistics, setLoadingStatistics] = useState(false);
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
	const [selectedPublication, setSelectedPublication] = useState(null);
	const [returnComment, setReturnComment] = useState('');
	const [lastNameError, setLastNameError] = useState('');
	const [firstNameError, setFirstNameError] = useState('');
	const [middleNameError, setMiddleNameError] = useState('');
	const [openHistoryDrawer, setOpenHistoryDrawer] = useState(false);
	const [openPlanHistoryDrawer, setOpenPlanHistoryDrawer] = useState(false);
	const [publicationsTransitionKey, setPublicationsTransitionKey] = useState(0);
	const [plansTransitionKey, setPlansTransitionKey] = useState(0);
	const [pubActionHistory, setPubActionHistory] = useState([]);
	const [pubHistoryPage, setPubHistoryPage] = useState(1);
	const [totalPubHistoryPages, setTotalPubHistoryPages] = useState(1);
	const [pubHistoryTransitionKey, setPubHistoryTransitionKey] = useState(0);
	const [planActionHistory, setPlanActionHistory] = useState([]);
	const [planHistoryPage, setPlanHistoryPage] = useState(1);
	const [totalPlanHistoryPages, setTotalPlanHistoryPages] = useState(1);
	const [planHistoryTransitionKey, setPlanHistoryTransitionKey] = useState(0);
	// Новое состояние для поиска по ФИО
	const [nameSearchQuery, setNameSearchQuery] = useState('');
	const [publicationTypes, setPublicationTypes] = useState([]);
	const [newTypeName, setNewTypeName] = useState('');
	const [newTypeDisplayName, setNewTypeDisplayName] = useState('');
	const [editingType, setEditingType] = useState(null);
	const [editTypeName, setEditTypeName] = useState('');
	const [editTypeDisplayName, setEditTypeDisplayName] = useState('');
	const [openEditTypeDialog, setOpenEditTypeDialog] = useState(false);
	const [newTypeDisplayNames, setNewTypeDisplayNames] = useState(['']);
	const [editTypeDisplayNames, setEditTypeDisplayNames] = useState(['']);
	const [openDeleteTypeConfirmDialog, setOpenDeleteTypeConfirmDialog] = useState(false);
	const [typeToDelete, setTypeToDelete] = useState(null); // Храним весь объект типа для сообщения
	const [publicationHints, setPublicationHints] = useState({});
	const [openHintsDialog, setOpenHintsDialog] = useState(false);
	const [editedHints, setEditedHints] = useState({});
	const [loadingHints, setLoadingHints] = useState(false);

	// Функция сортировки и фильтрации статистики
	const sortAndFilterStatistics = (stats, query) => {
		if (!query.trim()) return stats;

		const normalizedQuery = query.trim().toLowerCase();

		return [...stats]
			.filter((user) =>
				user.full_name.toLowerCase().includes(normalizedQuery)
			)
			.sort((a, b) => {
				const aName = a.full_name.toLowerCase();
				const bName = b.full_name.toLowerCase();

				const aStartsWith = aName.startsWith(normalizedQuery);
				const bStartsWith = bName.startsWith(normalizedQuery);
				if (aStartsWith && !bStartsWith) return -1;
				if (!aStartsWith && bStartsWith) return 1;

				const aIndex = aName.indexOf(normalizedQuery);
				const bIndex = bName.indexOf(normalizedQuery);
				if (aIndex !== bIndex) return aIndex - bIndex;

				return aName.localeCompare(bName);
			});
	};

	const hintableFields = [
		{ field: 'display_name_id', label: 'Тип' },
		{ field: 'title', label: 'Название' },
		{ field: 'authors_json', label: 'Авторы' },
		{ field: 'year', label: 'Год' },
		{ field: 'journal_conference_name', label: 'Наименование журнала/конференции' },
		{ field: 'doi', label: 'DOI' },
		{ field: 'issn', label: 'ISSN' },
		{ field: 'isbn', label: 'ISBN' },
		{ field: 'quartile', label: 'Квартиль (Q)' },
		{ field: 'volume', label: 'Том' },
		{ field: 'number', label: 'Номер/Выпуск' },
		{ field: 'pages', label: 'Страницы' },
		{ field: 'department', label: 'Кафедра' },
		{ field: 'publisher', label: 'Издательство' },
		{ field: 'publisher_location', label: 'Место издательства' },
		{ field: 'printed_sheets_volume', label: 'Объем (п.л.)' },
		{ field: 'circulation', label: 'Тираж' },
		{ field: 'classification_code', label: 'Код по классификатору' },
		{ field: 'notes', label: 'Примечание' },
		{ field: 'file', label: 'Файл публикации' },
	];

	const fetchPublicationHints = async () => {
		setLoadingHints(true);
		try {
			const response = await axios.get('http://localhost:5000/admin_api/admin/publication-hints', {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});
			setPublicationHints(response.data);
			setEditedHints(response.data); // Инициализируем редактируемые подсказки
			setError('');
		} catch (err) {
			console.error("Ошибка загрузки подсказок:", err);
			setError("Не удалось загрузить подсказки.");
			setOpenError(true);
		} finally {
			setLoadingHints(false);
		}
	};

	useEffect(() => {
		if (!isAuthenticated || user.role !== 'manager') navigate('/login');
		setLoadingInitial(true);
		Promise.all([
			fetchPublications(currentPagePublications),
			fetchPlans(currentPagePlans),
			fetchPubActionHistory(pubHistoryPage, dateFilterRange.start, dateFilterRange.end),
			fetchPlanActionHistory(planHistoryPage, dateFilterRange.start, dateFilterRange.end),
			fetchPublicationHints(), // <--- Вызов здесь
		]).finally(() => setLoadingInitial(false));
	}, [isAuthenticated, user, navigate]); // Добавьте csrfToken если нужно обновлять токен чаще

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

	const fetchStatistics = async (year) => {
		setLoadingStatistics(true);
		try {
			const response = await axios.get('http://localhost:5000/admin_api/admin/statistics', {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
				params: { year },
			});
			setStatistics(response.data);
		} catch (err) {
			console.error('Ошибка загрузки статистики:', err);
			setError('Не удалось загрузить статистику. Попробуйте позже.');
			setOpenError(true);
		} finally {
			setLoadingStatistics(false);
		}
	};

	const renderDisplayNames = (displayNames) => {
		// Проверяем, является ли displayNames массивом и содержит ли элементы
		if (Array.isArray(displayNames) && displayNames.length > 0) {
			// Фильтруем пустые строки и объединяем с запятой
			const validNames = displayNames.filter((name) => name && name.trim());
			return validNames.length > 0 ? validNames.join(', ') : 'Не указано';
		}
		// Возвращаем запасной текст для некорректных данных
		return 'Не указано';
	};

	const fetchPlanActionHistory = async (page, startDate = '', endDate = '') => {
		try {
			const response = await axios.get(`http://localhost:5000/admin_api/admin/plan-action-history`, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
				params: {
					page,
					per_page: 10,
					start_date: startDate || undefined,
					end_date: endDate || undefined,
				},
			});
			setPlanActionHistory(response.data.history);
			setTotalPlanHistoryPages(response.data.pages);
			setPlanHistoryTransitionKey((prev) => prev + 1);
		} catch (err) {
			console.error('Ошибка загрузки истории действий с планами:', err);
			setError('Не удалось загрузить историю действий с планами.');
			setOpenError(true);
		}
	};

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

	const handleSaveHints = async () => {
		setLoadingHints(true); // Можно использовать тот же лоадер
		try {
			const response = await axios.put('http://localhost:5000/admin_api/admin/publication-hints', editedHints, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});
			setPublicationHints(response.data); // Обновляем основные подсказки
			setEditedHints(response.data);     // Обновляем и редактируемые
			setOpenHintsDialog(false);
			setSuccess("Подсказки успешно сохранены!");
			setOpenSuccess(true);
			setError('');
		} catch (err) {
			console.error("Ошибка сохранения подсказок:", err);
			setError(err.response?.data?.error || "Не удалось сохранить подсказки.");
			setOpenError(true);
		} finally {
			setLoadingHints(false);
		}
	};

	const fetchPublicationTypes = async () => {
		try {
			// Выполняем GET-запрос к API
			const response = await axios.get('http://localhost:5000/admin_api/admin/publication-types', {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});

			// Проверяем, что данные — массив
			if (!Array.isArray(response.data)) {
				throw new Error('Данные API должны быть массивом');
			}

			// Группируем записи по id, собирая display_name в массив
			const typeMap = new Map();
			response.data.forEach((item) => {
				// Пропускаем некорректные записи
				if (!item || !item.id || !item.name) return;

				if (!typeMap.has(item.id)) {
					typeMap.set(item.id, {
						id: item.id,
						name: item.name,
						display_names: [],
					});
				}

				// Добавляем display_name, если оно существует и не пустое
				if (item.display_name && item.display_name.trim()) {
					typeMap.get(item.id).display_names.push(item.display_name);
				}
			});

			// Преобразуем Map в массив
			const normalizedTypes = Array.from(typeMap.values()).map((type) => ({
				...type,
				// Убеждаемся, что display_names всегда массив
				display_names: Array.isArray(type.display_names) ? type.display_names : [],
			}));

			// Сохраняем нормализованные данные в состояние
			setPublicationTypes(normalizedTypes);
		} catch (err) {
			// Логируем ошибку и показываем уведомление
			console.error('Ошибка загрузки типов публикаций:', err);
			setError('Не удалось загрузить типы публикаций.');
			setOpenError(true);
			setPublicationTypes([]);
		}
	};

	const handleAddType = async () => {
		// Проверяем, что название и хотя бы одно отображаемое название заполнены
		if (!newTypeName.trim() || newTypeDisplayNames.every(name => !name.trim())) {
			setError('Название (англ.) и хотя бы одно отображаемое название обязательны.');
			setOpenError(true);
			return;
		}
		try {
			// Фильтруем пустые строки из отображаемых названий
			const validDisplayNames = newTypeDisplayNames.filter(name => name.trim());
			const response = await axios.post(
				'http://localhost:5000/admin_api/admin/publication-types',
				{
					name: newTypeName,
					display_names: validDisplayNames,
				},
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);
			// Обновляем список типов, добавляя новый тип
			setPublicationTypes([...publicationTypes, response.data.type]);
			// Сбрасываем форму
			setNewTypeName('');
			setNewTypeDisplayNames(['']);
			setSuccess('Тип успешно добавлен!');
			setOpenSuccess(true);
		} catch (err) {
			setError(err.response?.data?.error || 'Не удалось добавить тип.');
			setOpenError(true);
		}
	};

	const handleEditType = (type) => {
		setEditingType(type);
		setEditTypeName(type.name || '');
		// Устанавливаем display_names как массив, с пустой строкой по умолчанию
		setEditTypeDisplayNames(Array.isArray(type.display_names) && type.display_names.length > 0 ? type.display_names : ['']);
		setOpenEditTypeDialog(true);
	};

	const handleUpdateType = async () => {
		// Проверяем, что поля заполнены
		if (!editTypeName.trim() || editTypeDisplayNames.every(name => !name.trim())) {
			setError('Название (англ.) и хотя бы одно отображаемое название обязательны.');
			setOpenError(true);
			return;
		}
		try {
			// Фильтруем пустые строки
			const validDisplayNames = editTypeDisplayNames.filter(name => name.trim());
			const response = await axios.put(
				`http://localhost:5000/admin_api/admin/publication-types/${editingType.id}`,
				{
					name: editTypeName,
					display_names: validDisplayNames,
				},
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);
			// Обновляем список типов
			setPublicationTypes(publicationTypes.map(t => t.id === editingType.id ? response.data.type : t));
			// Закрываем диалог и показываем уведомление
			setOpenEditTypeDialog(false);
			setSuccess('Тип успешно обновлён!');
			setOpenSuccess(true);
		} catch (err) {
			setError(err.response?.data?.error || 'Не удалось обновить тип.');
			setOpenError(true);
		}
	};


	const handleConfirmDeleteType = async () => {
		// Проверка, что есть тип для удаления
		if (!typeToDelete) {
			// Можно добавить логирование или сообщение об ошибке, если это происходит
			console.error("Attempted to confirm delete without a type selected.");
			return;
		}

		const typeIdToDelete = typeToDelete.id; // Получаем ID из сохраненного объекта типа
		const typeNameToDelete = typeToDelete.name || 'выбранный тип'; // Получаем имя для сообщения

		// Закрываем диалог подтверждения перед началом операции
		setOpenDeleteTypeConfirmDialog(false);
		// Очищаем состояние typeToDelete сразу после закрытия диалога
		setTypeToDelete(null);

		try {
			// Выполняем DELETE запрос к API
			const response = await axios.delete(`http://localhost:5000/admin_api/admin/publication-types/${typeIdToDelete}`, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});

			// Если запрос успешен (статус 200 OK)
			// Обновляем список типов, удаляя из него успешно удаленный тип
			setPublicationTypes(publicationTypes.filter(t => t.id !== typeIdToDelete));
			// Устанавливаем сообщение об успехе и делаем success alert видимым
			setSuccess(response.data.message || `Тип "${typeNameToDelete}" успешно удалён!`);
			setOpenSuccess(true);

		} catch (err) {
			// Если произошла ошибка при выполнении запроса
			let errorMessage = `Не удалось удалить тип "${typeNameToDelete}".`;

			if (err.response) {
				// Если ошибка пришла от сервера с конкретным статусом
				if (err.response.status === 400) {
					// Если бэкенд вернул специфичную ошибку (например, тип используется)
					errorMessage = err.response.data?.error || errorMessage + ' Тип используется в публикациях или планах.';
				} else if (err.response.status === 404) {
					// Если тип не найден (например, уже был удален)
					errorMessage = `Тип "${typeNameToDelete}" не найден.`;
				} else {
					// Для других ошибок сервера
					errorMessage = `${errorMessage} Ошибка сервера: ${err.response.status}`;
				}
			} else {
				// Если произошла ошибка сети или сервер недоступен
				errorMessage = `${errorMessage} Ошибка сети или сервер недоступен.`;
			}

			// Устанавливаем сообщение об ошибке и делаем error alert видимым
			// Это произойдет уже после того, как диалог закрылся,
			// что должно обеспечить правильное отображение Alert'а.
			setError(errorMessage);
			setOpenError(true);
			console.error("Ошибка при удалении типа:", err); // Логируем ошибку для отладки
		}
	};
	const handleDeleteType = (type) => { // *** Принимает ВЕСЬ ОБЪЕКТ типа ***
		console.log("Attempting to delete type:", type); // Добавим лог для отладки
		setTypeToDelete(type); // *** Сохраняем ВЕСЬ ОБЪЕКТ типа ***
		setOpenDeleteTypeConfirmDialog(true); // Открываем диалог подтверждения
		// !!! УДАЛИТЕ ОТСЮДА try...catch БЛОК С axios.delete !!!
	};
	// Загрузка типов при монтировании
	useEffect(() => {
		fetchPublicationTypes();
	}, []);

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

	const fetchPubActionHistory = async (page, startDate = '', endDate = '') => {
		try {
			const response = await axios.get('http://localhost:5000/admin_api/admin/publication-action-history', {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
				params: {
					page,
					per_page: 10,
					start_date: startDate || undefined,
					end_date: endDate || undefined,
				},
			});
			setPubActionHistory(response.data.history);
			setTotalPubHistoryPages(response.data.pages);
			setPubHistoryTransitionKey((prev) => prev + 1);
		} catch (err) {
			console.error('Ошибка загрузки истории действий с публикациями:', err);
			setError('Не удалось загрузить историю действий с публикациями.');
			setOpenError(true);
		}
	};

	// Инициализация данных
	useEffect(() => {
		if (!isAuthenticated || user.role !== 'manager') navigate('/login');
		setLoadingInitial(true);
		Promise.all([
			fetchPublications(currentPagePublications),
			fetchPlans(currentPagePlans),
			fetchPubActionHistory(pubHistoryPage, dateFilterRange.start, dateFilterRange.end),
			fetchPlanActionHistory(planHistoryPage, dateFilterRange.start, dateFilterRange.end),
		]).finally(() => setLoadingInitial(false));
	}, [isAuthenticated, user, navigate]);

	// Обновление истории публикаций
	useEffect(() => {
		fetchPubActionHistory(pubHistoryPage, dateFilterRange.start, dateFilterRange.end);
	}, [pubHistoryPage, dateFilterRange.start, dateFilterRange.end]);

	// Обновление публикаций
	useEffect(() => {
		fetchPublications(currentPagePublications);
	}, [currentPagePublications, searchQuery, statusFilter]);

	// Обновление планов
	useEffect(() => {
		fetchPlans(currentPagePlans);
	}, [currentPagePlans]);

	// Загрузка статистики
	useEffect(() => {
		if (value === 1) {
			fetchStatistics(selectedYear);
		}
	}, [value, selectedYear]);

	// Обработчики
	const handleTabChange = (event, newValue) => setValue(newValue);

	const handleSearchChange = (e) => {
		setSearchQuery(e.target.value);
		setCurrentPagePublications(1);
	};

	const handleOpenPlanHistoryDrawer = () => {
		setOpenPlanHistoryDrawer(true);
		fetchPlanActionHistory(planHistoryPage);
	};

	const handleClosePlanHistoryDrawer = () => setOpenPlanHistoryDrawer(false);

	const handlePlanHistoryPageChange = (event, value) => {
		setPlanHistoryPage(value);
		fetchPlanActionHistory(value, dateFilterRange.start, dateFilterRange.end);
	};

	const handleStatusFilterChange = (e) => {
		setStatusFilter(e.target.value);
		setCurrentPagePublications(1);
	};

	const handlePageChangePublications = (event, value) => setCurrentPagePublications(value);

	const handlePageChangePlans = (event, value) => setCurrentPagePlans(value);

	const handleHistoryPageChange = (event, value) => {
		setPubHistoryPage(value);
		fetchPubActionHistory(value, dateFilterRange.start, dateFilterRange.end);
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
			fetchPubActionHistory(pubHistoryPage);
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
				fetchPubActionHistory(pubHistoryPage);
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
			fetchPlanActionHistory(planHistoryPage);
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
			fetchPlanActionHistory(planHistoryPage);
			setOpenReturnDialog(false);
		} catch (err) {
			setError('Не удалось вернуть план. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const handleApprovePublication = async (pub) => {
		try {
			await axios.put(
				`http://localhost:5000/admin_api/admin/publications/${pub.id}`,
				{ status: 'published' },
				{ withCredentials: true, headers: { 'X-CSRFToken': csrfToken } }
			);
			setSuccess('Публикация утверждена!');
			setOpenSuccess(true);
			fetchPublications(currentPagePublications);
			fetchPubActionHistory(pubHistoryPage);
		} catch (err) {
			setError('Не удалось утвердить публикацию. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const handleReturnPublicationForRevision = async (pubId, comment) => {
		try {
			await axios.put(
				`http://localhost:5000/admin_api/admin/publications/${pubId}`,
				{ status: 'returned_for_revision', return_comment: comment },
				{ withCredentials: true, headers: { 'X-CSRFToken': csrfToken } }
			);
			setSuccess('Публикация возвращена на доработку!');
			setOpenSuccess(true);
			fetchPublications(currentPagePublications);
			fetchPubActionHistory(pubHistoryPage);
			setOpenReturnDialog(false);
		} catch (err) {
			setError('Не удалось вернуть публикацию. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const handleOpenHistoryDrawer = () => {
		setOpenHistoryDrawer(true);
		fetchPubActionHistory(pubHistoryPage);
	};

	const handleCloseHistoryDrawer = () => setOpenHistoryDrawer(false);

	const UserStatisticsChart = ({ user }) => {
		// Защита от пустых данных
		const safeUser = user || { plan: {}, actual: {}, username: '' };
		const plan = safeUser.plan || {};
		const actual = safeUser.actual || {};

		// Проверяем, есть ли план
		const hasPlan = Object.values(plan).some((value) => value > 0);
		if (!hasPlan) {
			return (
				<Box sx={{ mt: 2, textAlign: 'center' }}>
					<Typography sx={{ color: '#6E6E73' }}>
						У пользователя не создан или не утверждён план на этот год.
					</Typography>
				</Box>
			);
		}

		// Подсчитываем общие итоги
		const totalPlan = Object.values(plan).reduce((sum, value) => sum + value, 0);
		const totalActual = Object.values(actual).reduce((sum, value) => sum + value, 0);
		const progress = totalPlan > 0 ? (totalActual / totalPlan) * 100 : 0;

		// Данные для графика
		const data = [{
			name: 'Итог',
			План: totalPlan,
			Факт: totalActual
		}];

		return (
			<Box sx={{ mt: 2, display: 'flex', gap: 2 }}>
				{/* График */}
				<Box sx={{ width: '40%', minWidth: 200, display: 'flex', alignItems: 'center' }}>
					<Box sx={{ width: '100%', height: 200 }}>
						<ResponsiveContainer width="100%" height="100%">
							<BarChart data={data} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
								<CartesianGrid strokeDasharray="3 3" />
								<XAxis dataKey="name" />
								<YAxis allowDecimals={false} />
								<Legend />
								<Bar dataKey="План" fill="#0071E3" barSize={20} />
								<Bar dataKey="Факт" fill="#00A94F" barSize={20} />
							</BarChart>
						</ResponsiveContainer>
					</Box>
				</Box>

				{/* Детали */}
				<Box sx={{ width: '60%' }}>
					<Typography sx={{ mb: 1, color: '#1D1D1F' }}>Прогресс выполнения:</Typography>
					<Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2 }}>
						<LinearProgress
							variant="determinate"
							value={Math.min(progress, 100)}
							sx={{
								height: 8,
								borderRadius: 4,
								flexGrow: 1,
								backgroundColor: '#E5E5EA',
								'& .MuiLinearProgress-bar': {
									backgroundColor: progress > 100 ? '#FF9500' : '#34C759',
								},
							}}
						/>
						<Typography variant="body2" sx={{ minWidth: '50px', textAlign: 'right', color: progress > 100 ? '#FF9500' : '#1D1D1F' }}>
							{Math.round(progress)}%
						</Typography>
					</Box>
					<Box sx={{ display: 'flex', gap: 4, backgroundColor: '#FFFFFF', border: '1px solid #D1D1D6', borderRadius: '8px', p: 2 }}>
						<Box sx={{ flex: 1 }}>
							<Typography sx={{ fontWeight: 600, color: '#0071E3', mb: 1 }}>План</Typography>
							{Object.entries(plan).map(([key, value]) => (
								<Typography key={key} sx={{ color: '#1D1D1F' }}>
									{key}: {value}
								</Typography>
							))}
						</Box>
						<Box sx={{ flex: 1 }}>
							<Typography sx={{ fontWeight: 600, color: '#00A94F', mb: 1 }}>Факт</Typography>
							{Object.entries(actual).map(([key, value]) => (
								<Typography key={key} sx={{ color: '#1D1D1F' }}>
									{key}: {value}
								</Typography>
							))}
						</Box>
					</Box>
				</Box>
			</Box>
		);
	};



	return (
		<>
			{animationStyles}
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
						<Tab label="Управление типами" />
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
									<AppleCard sx={{
										mt: 2, mb: 2, p: 2, backgroundColor: '#F5F5F7',
										borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
										position: 'relative' // <--- Необходимо для позиционирования иконки
									}}>
										{/* --- ИКОНКА ПОДСКАЗКИ --- */}
										<IconButton
											aria-label="edit-hints"
											onClick={() => {
												setEditedHints(publicationHints); // Сбрасываем изменения при открытии
												setOpenHintsDialog(true);
											}}
											sx={{
												position: 'absolute',
												top: 125, // Отступ сверху
												right: 16, // Отступ справа
												color: '#FFA500', // Оранжевый цвет для заметности
												backgroundColor: 'rgba(255, 165, 0, 0.1)',
												'&:hover': {
													backgroundColor: 'rgba(255, 165, 0, 0.2)',
												},
											}}
											title="Редактировать подсказки для формы публикации"
										>
											<LightbulbOutlinedIcon />
										</IconButton>
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
											<AppleButton startIcon={<HistoryIcon />} onClick={handleOpenHistoryDrawer} sx={{ height: 'fit-content', marginTop: '6px' }}>
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
															<TableCell sx={{ color: '#1D1D1F' }}>{Array.isArray(pub.authors) && pub.authors.length > 0
																? pub.authors.map(author => author.name).join(', ') // Извлекаем имена и соединяем через запятую
																: 'Авторы не указаны' // Запасной текст, если авторов нет
															}</TableCell>
															<TableCell sx={{ color: '#1D1D1F' }}>{pub.year}</TableCell>
															<TableCell sx={{ color: '#1D1D1F' }}>
																{pub.type?.display_name || pub.type?.display_names?.[0] || 'Неизвестный тип'}
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
												width: 600,
												backgroundColor: '#FFFFFF',
												boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
												borderRadius: '16px 0 0 16px',
											},
										}}
									>
										<Box sx={{ p: 2, pr: 4 }}>
											<Typography variant="h6" sx={{ color: '#1D1D1F', fontWeight: 600, mb: 5 }}>
												История действий с публикациями
											</Typography>
											<Box sx={{ display: 'flex', gap: 2, mt: 2, mb: 2 }}>
												<AppleTextField
													label="Дата начала"
													type="date"
													value={dateFilterRange.start}
													onChange={(e) => {
														setDateFilterRange((prev) => ({ ...prev, start: e.target.value }));
														setPubHistoryPage(1);
													}}
													InputLabelProps={{ shrink: true }}
													sx={{ width: '200px' }}
												/>
												<AppleTextField
													label="Дата окончания"
													type="date"
													value={dateFilterRange.end}
													onChange={(e) => {
														setDateFilterRange((prev) => ({ ...prev, end: e.target.value }));
														setPubHistoryPage(1);
													}}
													InputLabelProps={{ shrink: true }}
													sx={{ width: '200px' }}
												/>
											</Box>
											{pubActionHistory.length > 0 ? (
												<>
													<AppleTable
														sx={{
															mt: 2,
															overflowX: 'auto',
															minWidth: '100%',
															backgroundColor: '#F5F5F7',
															boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
															borderRadius: '8px',
														}}
													>
														<TableHead>
															<TableRow sx={{ backgroundColor: '#0071E3', borderRadius: '8px 8px 0 0' }}>
																<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', minWidth: '200px', borderTopLeftRadius: '8px' }}>
																	Название
																</TableCell>
																<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', minWidth: '120px' }}>
																	Действие
																</TableCell>
																<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', minWidth: '140px', borderTopRightRadius: '8px' }}>
																	Время
																</TableCell>
															</TableRow>
														</TableHead>
														<Fade in={true} timeout={500} key={pubHistoryTransitionKey}>
															<TableBody>
																{pubActionHistory.map((action) => (
																	<TableRow key={`${action.history_id}-${action.timestamp}`}>
																		<TableCell sx={{ minWidth: '200px', whiteSpace: 'normal', wordWrap: 'break-word' }}>
																			<Typography
																				sx={{
																					color: '#0071E3',
																					textDecoration: 'underline',
																					cursor: 'pointer',
																					'&:hover': { textDecoration: 'none' },
																				}}
																				onClick={() => {
																					handleCloseHistoryDrawer();
																					navigate(`/publication/${action.publication_id}`);
																				}}
																			>
																				{action.title}
																			</Typography>
																		</TableCell>
																		<TableCell sx={{ minWidth: '120px' }}>
																			{action.action_type === 'approved' ? 'Утверждено' : 'Возвращено на доработку'}
																		</TableCell>
																		<TableCell sx={{ minWidth: '140px' }}>
																			{new Date(action.timestamp).toLocaleString('ru-RU')}
																		</TableCell>
																	</TableRow>
																))}
															</TableBody>
														</Fade>
													</AppleTable>
													<Box sx={{ mt: 2, display: 'flex', justifyContent: 'center' }}>
														<Pagination
															count={totalPubHistoryPages}
															page={pubHistoryPage}
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
													Нет записей в истории действий с публикациями.
												</Typography>
											)}
										</Box>
									</Drawer>
								</>
							)}

							{value === 1 && (
								<Box>
									<Typography
										variant="h5"
										gutterBottom
										sx={{ mt: 4, color: '#1D1D1F', fontWeight: 600, textAlign: 'center' }}
									>
										Статистика по кафедре
									</Typography>
									<Box sx={{ display: 'flex', justifyContent: 'center', gap: 2, mb: 4 }}>
										<AppleTextField
											label="Год"
											type="number"
											value={selectedYear}
											onChange={(e) => {
												const value = e.target.value;
												// Ограничиваем ввод до 4 символов
												if (value.length > 4) return;

												if (value === '') {
													setSelectedYear('');
													return;
												}

												const numValue = parseInt(value, 10);
												if (!isNaN(numValue)) {
													setSelectedYear(numValue);
												}
											}}
											onBlur={() => {
												// Восстанавливаем текущий год, если пусто или меньше 1900
												if (!selectedYear || selectedYear < 1900) {
													setSelectedYear(new Date().getFullYear());
												}
											}}
											InputProps={{
												inputProps: {
													min: 1900,
													maxLength: 4 // <-- не работает в type="number", но оставим для совместимости
												},
											}}
											sx={{
												width: 200,
												'& .MuiOutlinedInput-root': {
													height: '40px',
													padding: '0 14px',
													'& input': {
														padding: '12px 0',
														// Ограничим визуально 4 цифрами (на случай type="text")
														MozAppearance: 'textfield',
													},
												},
											}}
										/>
										<AppleTextField
											label="Поиск по ФИО"
											value={nameSearchQuery}
											onChange={(e) => setNameSearchQuery(e.target.value)}
											sx={{
												width: 300,
												'& .MuiOutlinedInput-root': {
													height: '40px',
													padding: '0 14px',
													'& input': { padding: '12px 0' },
												},
												'& .MuiInputLabel-outlined': {
													transform: 'translate(14px, 9px) scale(1)',
												},
												'& .MuiInputLabel-outlined.Mui-focused': {
													transform: 'translate(14px, -6px) scale(0.75)',
												},
												'& .MuiInputLabel-outlined.MuiFormLabel-filled': {
													transform: 'translate(14px, -6px) scale(0.75)',
												},
											}}
											variant="outlined"
											placeholder="Введите ФИО"
										/>
									</Box>
									{loadingStatistics ? (
										<Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
											<CircularProgress sx={{ color: '#0071E3' }} />
										</Box>
									) : statistics.length > 0 ? (
										<TransitionGroup>
											{sortAndFilterStatistics(statistics, nameSearchQuery).map((user) => (
												<CSSTransition key={user.user_id} timeout={300} classNames="accordion">
													<Accordion
														defaultExpanded={false}
														sx={{
															mb: 2,
															borderRadius: '16px',
															boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
															'&:before': { display: 'none' },
														}}
													>
														<AccordionSummary
															expandIcon={<ExpandMoreIcon sx={{ color: '#0071E3' }} />}
															sx={{
																backgroundColor: '#F5F5F7',
																borderRadius: '16px',
																'& .MuiAccordionSummary-content': { alignItems: 'center' },
															}}
														>
															<Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
																<Typography variant="h6" sx={{ color: '#1D1D1F', fontWeight: 600 }}>
																	{user.full_name || 'Пользователь не указан'}
																</Typography>
																<Typography variant="h6" sx={{ color: '#6E6E73', fontWeight: 400 }}>
																	({user.username || 'логин отсутствует'})
																</Typography>
															</Box>
														</AccordionSummary>
														<AccordionDetails sx={{ backgroundColor: '#FFFFFF', borderRadius: '0 0 16px 16px' }}>
															<UserStatisticsChart user={user} publicationTypes={publicationTypes} />
														</AccordionDetails>
													</Accordion>
												</CSSTransition>
											))}
										</TransitionGroup>
									) : (
										<Typography sx={{ textAlign: 'center', color: '#6E6E73', mt: 2 }}>
											Нет данных для выбранного года.
										</Typography>
									)}
								</Box>
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

										</form>
									</AppleCard>
								</>
							)}

							{value === 3 && (
								<Box sx={{ mt: 4 }}>
									<Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', mb: 2, position: 'relative' }}>
										<Typography variant="h5" sx={{ color: '#1D1D1F', fontWeight: 600, textAlign: 'center' }}>
											Работа с планами
										</Typography>
										<AppleButton
											startIcon={<HistoryIcon />}
											onClick={handleOpenPlanHistoryDrawer}
											sx={{ position: 'absolute', right: 16 }}
										>
											Показать историю
										</AppleButton>
									</Box>
									{plans.length > 0 ? (
										plans.map((plan) => {
											const entriesByType = plan.entries.reduce((acc, entry) => {
												const displayName = entry.display_name || 'Не указано';
												if (!acc[displayName]) {
													acc[displayName] = { count: 0, display_name: displayName };
												}
												acc[displayName].count += 1;
												return acc;
											}, {});
											const groupedEntries = Object.values(entriesByType);

											return (
												<Accordion
													key={plan.id}
													sx={{ mb: 2, borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}
												>
													<AccordionSummary expandIcon={<ExpandMoreIcon />}>
														<Box sx={{ display: 'flex', justifyContent: 'space-between', width: '100%', alignItems: 'center' }}>
															<Box>
																<Typography variant="h6" sx={{ color: '#1D1D1F', whiteSpace: 'nowrap' }}>
																	План на {plan.year} год
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
																	<TableCell>Планируемое количество</TableCell>
																	<TableCell>Тип</TableCell>
																</TableRow>
															</TableHead>
															<Fade in={true} timeout={500} key={plansTransitionKey}>
																<TableBody>
																	{groupedEntries.length > 0 ? (
																		groupedEntries.map((group, index) => (
																			<TableRow key={index}>
																				<TableCell sx={{ padding: '16px' }}>{group.count}</TableCell>
																				<TableCell sx={{ color: '#1D1D1F' }}>
																					{group.display_name}
																				</TableCell>
																			</TableRow>
																		))
																	) : (
																		<TableRow>
																			<TableCell colSpan={2} sx={{ textAlign: 'center', color: '#6E6E73' }}>
																				Нет записей в плане.
																			</TableCell>
																		</TableRow>
																	)}
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
											);
										})
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
									<Drawer
										anchor="right"
										open={openPlanHistoryDrawer}
										onClose={handleClosePlanHistoryDrawer}
										sx={{
											'& .MuiDrawer-paper': {
												width: 600,
												backgroundColor: '#FFFFFF',
												boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
												borderRadius: '16px 0 0 16px',
											},
										}}
									>
										<Box sx={{ p: 2, pr: 4 }}>
											<Typography variant="h6" sx={{ color: '#1D1D1F', fontWeight: 600, mb: 5 }}>
												История действий с планами
											</Typography>
											<Box sx={{ display: 'flex', gap: 2, mt: 2, mb: 2 }}>
												<AppleTextField
													label="Дата начала"
													type="date"
													value={dateFilterRange.start}
													onChange={(e) => {
														setDateFilterRange((prev) => ({ ...prev, start: e.target.value }));
														setPlanHistoryPage(1);
													}}
													InputLabelProps={{ shrink: true }}
													sx={{ width: '200px' }}
												/>
												<AppleTextField
													label="Дата окончания"
													type="date"
													value={dateFilterRange.end}
													onChange={(e) => {
														setDateFilterRange((prev) => ({ ...prev, end: e.target.value }));
														setPlanHistoryPage(1);
													}}
													InputLabelProps={{ shrink: true }}
													sx={{ width: '200px' }}
												/>
											</Box>
											{planActionHistory.length > 0 ? (
												<>
													<AppleTable
														sx={{
															mt: 2,
															backgroundColor: '#F5F5F7',
															boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
															borderRadius: '8px',
														}}
													>
														<TableHead>
															<TableRow sx={{ backgroundColor: '#0071E3', borderRadius: '8px 8px 0 0' }}>
																<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', minWidth: '150px', borderTopLeftRadius: '8px' }}>
																	План
																</TableCell>
																<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', minWidth: '150px' }}>
																	Пользователь
																</TableCell>
																<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', minWidth: '120px' }}>
																	Действие
																</TableCell>
																<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', minWidth: '140px', borderTopRightRadius: '8px' }}>
																	Время
																</TableCell>
															</TableRow>
														</TableHead>
														<Fade in={true} timeout={500} key={planHistoryTransitionKey}>
															<TableBody>
																{planActionHistory.map((action) => (
																	<TableRow key={action.history_id}>
																		<TableCell sx={{ minWidth: '150px', whiteSpace: 'nowrap' }}>
																			<Typography
																				sx={{
																					color: '#0071E3',
																					textDecoration: 'underline',
																					cursor: 'pointer',
																					'&:hover': { textDecoration: 'none' },
																				}}
																				onClick={() => {
																					if (action.plan_id) {
																						handleClosePlanHistoryDrawer();
																						// navigate(`/plan/${action.id}`); // Раскомментируйте, если есть страница плана
																					} else {
																						setError('ID плана отсутствует в записи истории.');
																						setOpenError(true);
																					}
																				}}
																			>
																				План на {action.year} год
																			</Typography>
																		</TableCell>
																		<TableCell sx={{ minWidth: '150px', whiteSpace: 'normal', wordWrap: 'break-word' }}>
																			{action.user_full_name}
																		</TableCell>
																		<TableCell sx={{ minWidth: '120px' }}>
																			{action.action_type === 'approved' ? 'Утверждён' : 'Возвращён на доработку'}
																		</TableCell>
																		<TableCell sx={{ minWidth: '140px' }}>
																			{new Date(action.timestamp).toLocaleString('ru-RU')}
																		</TableCell>
																	</TableRow>
																))}
															</TableBody>
														</Fade>
													</AppleTable>
													<Box sx={{ mt: 2, display: 'flex', justifyContent: 'center' }}>
														<Pagination
															count={totalPlanHistoryPages}
															page={planHistoryPage}
															onChange={handlePlanHistoryPageChange}
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
													Нет записей в истории действий с планами.
												</Typography>
											)}
										</Box>
									</Drawer>
								</Box>
							)}
							{value === 4 && (
								<Box sx={{ mt: 4 }}>
									<Typography variant="h5" gutterBottom sx={{ color: '#1D1D1F', fontWeight: 600, textAlign: 'center' }}>
										Управление типами публикаций
									</Typography>
									<Box sx={{ display: 'flex', flexDirection: 'column', gap: 2, mb: 4 }}>
										<AppleTextField
											label="Название (англ.)"
											value={newTypeName}
											onChange={(e) => setNewTypeName(e.target.value)}
											sx={{ flex: 1 }}
										/>
										<Typography variant="subtitle1" sx={{ color: '#1D1D1F', fontWeight: 600 }}>
											Отображаемые названия
										</Typography>
										{newTypeDisplayNames.map((displayName, index) => (
											<Box key={index} sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
												<AppleTextField
													label={`Отображаемое название ${index + 1}`}
													value={displayName}
													onChange={(e) => {
														const updatedNames = [...newTypeDisplayNames];
														updatedNames[index] = e.target.value;
														setNewTypeDisplayNames(updatedNames);
													}}
													sx={{ flex: 1 }}
												/>
												{newTypeDisplayNames.length > 1 && (
													<IconButton
														onClick={() => {
															const updatedNames = newTypeDisplayNames.filter((_, i) => i !== index);
															setNewTypeDisplayNames(updatedNames);
														}}
													>
														<DeleteIcon />
													</IconButton>
												)}
											</Box>
										))}
										<AppleButton
											onClick={() => setNewTypeDisplayNames([...newTypeDisplayNames, ''])}
											sx={{ alignSelf: 'flex-start' }}
										>
											Добавить ещё название
										</AppleButton>
										<AppleButton onClick={handleAddType}>Добавить тип</AppleButton>
									</Box>
									<AppleTable>
										<TableHead>
											<TableRow>
												<TableCell sx={{ fontWeight: 600 }}>Название (англ.)</TableCell>
												<TableCell sx={{ fontWeight: 600 }}>Отображаемые названия</TableCell>
												<TableCell sx={{ fontWeight: 600 }}>Действия</TableCell>
											</TableRow>
										</TableHead>
										<TableBody>
											{publicationTypes.length > 0 ? (
												publicationTypes.map((type) => (
													<TableRow key={`type-${type.id}`}>
														<TableCell>{type.name || 'Не указано'}</TableCell>
														<TableCell>{renderDisplayNames(type.display_names)}</TableCell>
														<TableCell>
															<IconButton onClick={() => handleEditType(type)}>
																<EditIcon />
															</IconButton>
															<IconButton onClick={() => handleDeleteType(type)}> {/* ПЕРЕДАЕМ ВЕСЬ ОБЪЕКТ type */}
																<DeleteIcon />
															</IconButton>
														</TableCell>
													</TableRow>
												))
											) : (
												<TableRow>
													<TableCell colSpan={3} sx={{ textAlign: 'center', color: '#6E6E73' }}>
														Нет типов публикаций.
													</TableCell>
												</TableRow>
											)}
										</TableBody>
									</AppleTable>
									<Dialog
										open={openEditTypeDialog}
										onClose={() => setOpenEditTypeDialog(false)}
										PaperProps={{
											sx: { borderRadius: '16px', p: 2, backgroundColor: '#FFFFFF' },
										}}
									>
										<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>
											Редактировать тип публикации
										</DialogTitle>
										<DialogContent>
											<AppleTextField
												label="Название (англ.)"
												value={editTypeName}
												onChange={(e) => setEditTypeName(e.target.value)}
												fullWidth
												margin="normal"
											/>
											<Typography variant="subtitle1" sx={{ color: '#1D1D1F', fontWeight: 600, mt: 2 }}>
												Отображаемые названия
											</Typography>
											{editTypeDisplayNames.map((displayName, index) => (
												<Box key={index} sx={{ display: 'flex', alignItems: 'center', gap: 1, mt: 1 }}>
													<AppleTextField
														label={`Отображаемое название ${index + 1}`}
														value={displayName}
														onChange={(e) => {
															const updatedNames = [...editTypeDisplayNames];
															updatedNames[index] = e.target.value;
															setEditTypeDisplayNames(updatedNames);
														}}
														fullWidth
													/>
													{editTypeDisplayNames.length > 1 && (
														<IconButton
															onClick={() => {
																const updatedNames = editTypeDisplayNames.filter((_, i) => i !== index);
																setEditTypeDisplayNames(updatedNames);
															}}
														>
															<DeleteIcon />
														</IconButton>
													)}
												</Box>
											))}
											<AppleButton
												onClick={() => setEditTypeDisplayNames([...editTypeDisplayNames, ''])}
												sx={{ mt: 2 }}
											>
												Добавить ещё название
											</AppleButton>
										</DialogContent>
										<DialogActions sx={{ p: 2 }}>
											<CancelButton onClick={() => setOpenEditTypeDialog(false)}>Отмена</CancelButton>
											<AppleButton onClick={handleUpdateType}>Сохранить</AppleButton>
										</DialogActions>
									</Dialog>
								</Box>
							)}
						</>
					)}
				</AppleCard>

				{/* Диалог редактирования публикации */}
				<Dialog
					open={openEditDialog}
					onClose={handleEditCancel}
					PaperProps={{
						sx: { borderRadius: '16px', p: 2, backgroundColor: '#FFFFFF', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' },
					}}
				>
					<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>Редактировать публикацию</DialogTitle>
					<DialogContent>
						<form onSubmit={handleEditSubmit}>
							<AppleTextField
								fullWidth
								label="Название"
								value={editTitle}
								onChange={(e) => setEditTitle(e.target.value)}
								margin="normal"
								variant="outlined"
								autoComplete="off"
							/>
							<AppleTextField
								fullWidth
								label="Авторы"
								value={editAuthors}
								onChange={(e) => setEditAuthors(e.target.value)}
								margin="normal"
								variant="outlined"
								autoComplete="off"
							/>
							<AppleTextField
								fullWidth
								label="Год"
								type="number"
								value={editYear}
								onChange={(e) => setEditYear(e.target.value)}
								margin="normal"
								variant="outlined"
								inputProps={{ min: 1900, max: new Date().getFullYear() }}
							/>
							<AppleTextField
								select
								fullWidth
								label="Тип"
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
								select
								fullWidth
								label="Статус"
								value={editStatus}
								onChange={(e) => setEditStatus(e.target.value)}
								margin="normal"
								variant="outlined"
							>
								<MenuItem value="draft">Черновик</MenuItem>
								<MenuItem value="needs_review">На проверке</MenuItem>
								<MenuItem value="returned_for_revision">Возвращено на доработку</MenuItem>
								<MenuItem value="published">Опубликовано</MenuItem>
							</AppleTextField>
							<Button
								component="label"
								sx={{
									mt: 2,
									borderRadius: '12px',
									backgroundColor: '#F5F5F7',
									color: '#0071E3',
									textTransform: 'none',
									padding: '8px 16px',
									boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
									'&:hover': { backgroundColor: '#E8ECEF' },
								}}
							>
								Загрузить новый файл
								<input
									type="file"
									hidden
									onChange={(e) => setEditFile(e.target.files[0])}
								/>
							</Button>
							{editFile && (
								<Typography sx={{ mt: 1, color: '#6E6E73' }}>
									Выбран файл: {editFile.name}
								</Typography>
							)}
							<Collapse in={openError}>
								{error && (
									<Alert
										severity="error"
										sx={{ mt: 2, borderRadius: '12px', backgroundColor: '#FFF1F0', color: '#1D1D1F' }}
										onClose={() => setOpenError(false)}
									>
										{error}
									</Alert>
								)}
							</Collapse>
						</form>
					</DialogContent>
					<DialogActions sx={{ p: 2 }}>
						<CancelButton onClick={handleEditCancel}>Отмена</CancelButton>
						<AppleButton type="submit" onClick={handleEditSubmit}>
							Сохранить
						</AppleButton>
					</DialogActions>
				</Dialog>

				{/* Диалог удаления публикации */}
				<Dialog
					open={openDeleteDialog}
					onClose={() => setOpenDeleteDialog(false)}
					PaperProps={{
						sx: { borderRadius: '16px', p: 2, backgroundColor: '#FFFFFF', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' },
					}}
				>
					<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>Удалить публикацию</DialogTitle>
					<DialogContent>
						<Typography sx={{ color: '#1D1D1F' }}>
							Вы уверены, что хотите удалить публикацию "{publicationToDelete?.title || 'Не указано'}"? Это действие нельзя отменить.
						</Typography>
					</DialogContent>
					<DialogActions sx={{ p: 2 }}>
						<CancelButton onClick={() => setOpenDeleteDialog(false)}>Отмена</CancelButton>
						<AppleButton
							sx={{ backgroundColor: '#FF3B30', '&:hover': { backgroundColor: '#E6392E' } }}
							onClick={handleDeletePlanConfirm}
						>
							Удалить
						</AppleButton>
					</DialogActions>
				</Dialog>



				{/* Диалог подтверждения удаления типа */}
				<Dialog
					open={openDeleteTypeConfirmDialog}
					onClose={() => {
						setOpenDeleteTypeConfirmDialog(false);
						setTypeToDelete(null);
					}}
					PaperProps={{
						sx: { borderRadius: '16px', p: 2, backgroundColor: '#FFFFFF', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' },
					}}
				>
					<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>
						Подтвердите удаление типа
					</DialogTitle>
					<DialogContent>
						<Typography sx={{ color: '#1D1D1F' }}>
							Вы уверены, что хотите удалить тип "{typeToDelete?.name || 'выбранный тип'}"? Это действие нельзя отменить.
							<br />
							Удаление возможно только если тип не используется ни в одной публикации и ни в одной записи плана.
						</Typography>
					</DialogContent>
					<DialogActions sx={{ p: 2 }}>
						<CancelButton onClick={() => {
							setOpenDeleteTypeConfirmDialog(false);
							setTypeToDelete(null);
						}}>
							Отмена
						</CancelButton>
						<AppleButton
							sx={{ backgroundColor: '#FF3B30', '&:hover': { backgroundColor: '#E6392E' } }}
							onClick={handleConfirmDeleteType} // Вызываем новую функцию подтверждения
						>
							Удалить
						</AppleButton>
					</DialogActions>
				</Dialog>

				<Dialog
					open={openHintsDialog}
					onClose={() => setOpenHintsDialog(false)}
					fullWidth
					maxWidth="md" // Сделаем пошире для удобства
					PaperProps={{ sx: { borderRadius: '16px', p: 2 } }}
				>
					<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>
						Редактирование подсказок для полей публикации
					</DialogTitle>
					<DialogContent>
						{loadingHints ? (
							<Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><CircularProgress /></Box>
						) : (
							<Box sx={{ display: 'flex', flexDirection: 'column', gap: 2, mt: 1 }}>
								{hintableFields.map(({ field, label }) => (
									<div key={field}>
										<Typography variant="subtitle1" sx={{ fontWeight: 500, color: '#6E6E73', mb: 0.5 }}>
											{label}:
										</Typography>
										<AppleTextField
											fullWidth
											multiline
											minRows={2} // Минимум 2 строки для удобства
											variant="outlined"
											value={editedHints[field] || ''}
											onChange={(e) => setEditedHints({ ...editedHints, [field]: e.target.value })}
											placeholder={`Введите текст подсказки для поля "${label}"...`}
										/>
									</div>
								))}
							</Box>
						)}
					</DialogContent>
					<DialogActions sx={{ p: 2 }}>
						<CancelButton onClick={() => setOpenHintsDialog(false)}>
							Отмена
						</CancelButton>
						<AppleButton onClick={handleSaveHints} disabled={loadingHints}>
							Сохранить подсказки
						</AppleButton>
					</DialogActions>
				</Dialog>



				{/* Диалог возврата плана на доработку */}
				<Dialog
					open={openReturnDialog}
					onClose={() => setOpenReturnDialog(false)}
					PaperProps={{
						sx: { borderRadius: '16px', p: 2, backgroundColor: '#FFFFFF', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' },
					}}
				>
					<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>
						Возврат плана на доработку
					</DialogTitle>
					<DialogContent>
						<Typography sx={{ color: '#1D1D1F', mb: 2 }}>
							Укажите причину возврата плана на доработку.
						</Typography>
						<AppleTextField
							fullWidth
							label="Комментарий"
							value={returnComment}
							onChange={(e) => setReturnComment(e.target.value)}
							margin="normal"
							variant="outlined"
							multiline
							rows={4}
						/>
						<Collapse in={openError}>
							{error && (
								<Alert
									severity="error"
									sx={{ mt: 2, borderRadius: '12px', backgroundColor: '#FFF1F0', color: '#1D1D1F' }}
									onClose={() => setOpenError(false)}
								>
									{error}
								</Alert>
							)}
						</Collapse>
					</DialogContent>
					<DialogActions sx={{ p: 2 }}>
						<CancelButton onClick={() => setOpenReturnDialog(false)}>Отмена</CancelButton>
						<AppleButton onClick={handleReturnForRevision}>Отправить</AppleButton>
					</DialogActions>
				</Dialog>

				{/* Уведомления */}
				<Collapse in={openSuccess}>
					{success && (
						<Alert
							severity="success"
							sx={{
								position: 'fixed',
								top: 16,
								left: '50%',
								transform: 'translateX(-50%)',
								width: 'fit-content',
								maxWidth: '90%',
								borderRadius: '12px',
								backgroundColor: '#E7F8E7',
								color: '#1D1D1F',
								boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)',
								zIndex: 1500,
							}}
							onClose={() => setOpenSuccess(false)}
						>
							{success}
						</Alert>
					)}
				</Collapse>
				<Collapse in={openError}>
					{error && ( // Добавляем проверку на наличие текста ошибки
						<Alert
							severity="error"
							sx={{
								position: 'fixed',
								// Можно задать фиксированное расстояние или рассчитывать от верхнего уведомления
								top: openSuccess ? 76 : 16, // Например, на 60px ниже, если успех виден, иначе 16px
								left: '50%',
								transform: 'translateX(-50%)',
								width: 'fit-content',
								maxWidth: '90%',
								borderRadius: '12px',
								backgroundColor: '#FFF1F0', // Цвет фона для ошибки
								color: '#1D1D1F',          // Цвет текста
								boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)',
								zIndex: 1500,              // Убедимся, что поверх всего остального
							}}
							onClose={() => setOpenError(false)}
						>
							{error}
						</Alert>
					)}
				</Collapse>
			</Container>
		</>
	);
}

export default ManagerDashboard;




