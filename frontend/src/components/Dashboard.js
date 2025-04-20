import React, { useState, useEffect, useMemo, useRef } from 'react';
import { Line } from 'react-chartjs-2';
import { Snackbar, Slide, Tooltip as MuiTooltip } from '@mui/material';
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, BarElement, Title, Tooltip, Legend, Filler } from 'chart.js';
import {
	Container,
	Typography,
	Table,
	TableHead,
	TableRow,
	TableCell,
	TableBody,
	Grid,
	Card,
	CardContent,
	Button,
	TextField,
	Box,
	MenuItem,
	Alert,
	Collapse,
	Dialog,
	DialogTitle,
	DialogContent,
	DialogActions,
	IconButton,
	LinearProgress, // Добавляем шкалу прогресса
	Tabs,
	Tab,
	Accordion,
	Checkbox,
	FormControlLabel,
	AccordionSummary,
	AccordionDetails,
	Pagination,
	Fade,
	CircularProgress,
	Autocomplete,
	FormControl, // Добавляем для выпадающего списка
	InputLabel,  // Добавляем для выпадающего списка
	Select,
	Chip,     // Добавляем для выпадающего списка
} from '@mui/material';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import AddIcon from '@mui/icons-material/Add';
import { useNavigate } from 'react-router-dom';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import SaveIcon from '@mui/icons-material/Save';
import PublishIcon from '@mui/icons-material/Publish';
import LinkIcon from '@mui/icons-material/Link'; // Добавляем иконку для привязки
import UnlinkIcon from '@mui/icons-material/LinkOff';
import AttachFileIcon from '@mui/icons-material/AttachFile';
import DownloadIcon from '@mui/icons-material/Download';
import PersonIcon from '@mui/icons-material/Person';
import Visibility from '@mui/icons-material/Visibility';
import VisibilityOff from '@mui/icons-material/VisibilityOff';
import LightbulbOutlinedIcon from '@mui/icons-material/LightbulbOutlined';
import WarningAmberIcon from '@mui/icons-material/WarningAmber';
import { minWidth, styled } from '@mui/system';
import axios from 'axios';
import { useAuth } from '../contexts/AuthContext';
import StatusChip from './StatusChip'; // Заменяем PlanStatusChip на StatusChip

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, BarElement, Title, Tooltip, Legend, Filler);

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

const RedCancelButton = styled(Button)(({ theme }) => ({
	borderRadius: '12px',
	textTransform: 'none',
	backgroundColor: '#FF3B30', // Красный фон
	color: '#FFFFFF', // Белый текст
	padding: '8px 16px',
	fontSize: '14px',
	fontWeight: 600,
	boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
	'&:hover': {
		backgroundColor: '#990F0A', // Более тёмный красный при наведении
		boxShadow: '0 4px 8px rgba(0, 0, 0, 0.15)', // Увеличенная тень при наведении
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

const AppleCard = styled(Card)(({ theme }) => ({
	borderRadius: '16px',
	boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
	backgroundColor: '#FFFFFF',
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

const TransitionDown = (props) => {
	return <Slide {...props} direction="down" />;
};


const DetailsButton = styled(Button)(({ theme }) => ({
	borderRadius: '12px',
	border: '1px solid #D1D1D6',
	color: '#1D1D1F',
	textTransform: 'none',
	backgroundColor: 'transparent',
	transition: 'all 0.3s ease',
	'&:hover': {
		borderColor: '#0071E3',
		color: '#0071E3',
		backgroundColor: 'transparent',
	},
}));

const AppleSelect = styled(Select)(({ theme }) => ({
	// Увеличиваем специфичность, добавляя селектор
	'& .MuiInputLabel-root.MuiInputLabel-root': {
		color: '#6E6E73 !important', // Серый цвет метки
		fontSize: '16px !important',
		// Позиционирование в нераскрытом состоянии
		transform: 'translate(14px, 12px) scale(1) !important', // Поднимаем метку к середине поля
		'&.MuiInputLabel-shrink': {
			// Позиционирование в раскрытом состоянии
			transform: 'translate(14px, -12px) scale(0.75) !important', // Поднимаем метку выше поля
			color: '#0071E3 !important', // Синий цвет при фокусе
		},
	},
	'& .MuiSelect-select': {
		padding: '10px 14px', // Уменьшенные отступы для компактности
		color: '#1D1D1F', // Тёмный текст
		fontSize: '14px', // Соответствует шрифту кнопок
		fontWeight: 400,
		display: 'flex',
		alignItems: 'center', // Центрирование содержимого по вертикали
		height: '40px !important', // Фиксируем высоту поля
		boxSizing: 'border-box', // Учитываем padding в высоте
	},
	'& .MuiOutlinedInput-root': {
		borderRadius: '12px',
		backgroundColor: '#F5F5F7', // Светло-серый фон
		'& fieldset': {
			borderColor: '#D1D1D6', // Серая рамка в покое
		},
		'&:hover fieldset': {
			borderColor: '#0071E3', // Синяя рамка при наведении
		},
		'&.Mui-focused fieldset': {
			borderColor: '#0071E3', // Синяя рамка при фокусе
		},
	},
	'& .MuiMenuItem-root': {
		borderRadius: '8px', // Закругленные углы для элементов списка
		margin: '4px 8px', // Отступы внутри выпадающего списка
		'&:hover': {
			backgroundColor: '#E5E5EA', // Светло-серая подсветка при наведении
		},
		'&.Mui-selected': {
			backgroundColor: '#D1D1D6', // Более тёмный серый для выбранного элемента
			'&:hover': {
				backgroundColor: '#C7C7CC', // Чуть темнее при наведении на выбранный
			},
		},
	},
}));

function Dashboard() {
	const { user, csrfToken, setCsrfToken, setUser } = useAuth();
	const [loadingUser, setLoadingUser] = useState(true);
	const [showCurrentPassword, setShowCurrentPassword] = useState(false);
	const [showNewPassword, setShowNewPassword] = useState(false);
	const [showDetailedAnalytics, setShowDetailedAnalytics] = useState(false);
	const [value, setValue] = useState(0);
	const [publications, setPublications] = useState([]);
	const [filteredPublications, setFilteredPublications] = useState([]);
	const [analytics, setAnalytics] = useState([]);
	const [uploadType, setUploadType] = useState('file');
	const [title, setTitle] = useState('');
	const [year, setYear] = useState('');
	const [type, setType] = useState('article');
	const [file, setFile] = useState(null);
	const [error, setError] = useState('');
	const [success, setSuccess] = useState('');
	const [openError, setOpenError] = useState(false);
	const [openSuccess, setOpenSuccess] = useState(false);
	const [openDeleteDialog, setOpenDeleteDialog] = useState(false);
	const [publicationToDelete, setPublicationToDelete] = useState(null);
	const [planToDelete, setPlanToDelete] = useState(null); // Новое состояние для плана
	const [openEditDialog, setOpenEditDialog] = useState(false);
	const [editPublication, setEditPublication] = useState(null);
	const [editTitle, setEditTitle] = useState('');
	const [editYear, setEditYear] = useState('');
	const [editType, setEditType] = useState('article');
	const [editFile, setEditFile] = useState(null);
	const [openEditUserDialog, setOpenEditUserDialog] = useState(false);
	const [editLastName, setEditLastName] = useState('');
	const [editFirstName, setEditFirstName] = useState('');
	const [editMiddleName, setEditMiddleName] = useState('');
	const [loadingInitial, setLoadingInitial] = useState(true);
	const [openAttachFileDialog, setOpenAttachFileDialog] = useState(false);
	const [publicationToAttach, setPublicationToAttach] = useState(null);
	const [attachFile, setAttachFile] = useState(null);
	const [openChangePasswordDialog, setOpenChangePasswordDialog] = useState(false);
	const [currentPassword, setCurrentPassword] = useState('');
	const [newPassword, setNewPassword] = useState('');
	const [pubTypes, setPubTypes] = useState({ article: 0, monograph: 0, conference: 0 });
	const [pubStatuses, setPubStatuses] = useState({ draft: 0, needs_review: 0, published: 0 });
	const [totalCitations, setTotalCitations] = useState(0);
	const [searchQuery, setSearchQuery] = useState('');
	const [filterDisplayNameId, setFilterDisplayNameId] = useState('all');
	const [filterStatus, setFilterStatus] = useState('all');
	const [linkDialogOpen, setLinkDialogOpen] = useState(false);
	const [selectedNewEntryType, setSelectedNewEntryType] = useState([]);
	const [selectedPlanEntry, setSelectedPlanEntry] = useState(null);
	const [filteredPublishedPublications, setFilteredPublishedPublications] = useState([]);
	const [linkSearchQuery, setLinkSearchQuery] = useState('');
	const [currentPage, setCurrentPage] = useState(1);
	const [totalPages, setTotalPages] = useState(1);
	const [publicationsTransitionKey, setPublicationsTransitionKey] = useState(0);
	const [plans, setPlans] = useState([]);
	const [openCreatePlanDialog, setOpenCreatePlanDialog] = useState(false);
	const [newPlan, setNewPlan] = useState({ year: new Date().getFullYear() + 1, expectedCount: 1 });
	const [editingPlanId, setEditingPlanId] = useState(null);
	const [planPage, setPlanPage] = useState(1);
	const [planTotalPages, setPlanTotalPages] = useState(1);
	const [publishedPublications, setPublishedPublications] = useState([]);
	const publicationsPerPage = 10;
	const plansPerPage = 10;
	const navigate = useNavigate();
	const chartRef = useRef(null);
	const [unlinkDialogOpen, setUnlinkDialogOpen] = useState(false);
	const [selectedGroup, setSelectedGroup] = useState(null);
	const [newAuthors, setNewAuthors] = useState([{ id: Date.now(), name: '', is_employee: false }]);
	const [editAuthorsList, setEditAuthorsList] = useState([{ id: Date.now(), name: '', is_employee: false }]);

	const [loadingPublicationTypes, setLoadingPublicationTypes] = useState(true); // Новое состояние для типов
	const [initializing, setInitializing] = useState(true);
	const validStatuses = ['all', 'draft', 'needs_review', 'published'];
	const [isTableLoading, setIsTableLoading] = useState(false);
	// Добавляем состояния для управления диалогом удаления типа
	const [openDeleteTypeDialog, setOpenDeleteTypeDialog] = useState(false);
	const [typeToDelete, setTypeToDelete] = useState(null);
	const [planIdForTypeDelete, setPlanIdForTypeDelete] = useState(null);
	const [displayNameIdToDelete, setDisplayNameIdToDelete] = useState(null);
	const [selectedDisplayNameId, setSelectedDisplayNameId] = useState('');
	const [editSelectedDisplayNameId, setEditSelectedDisplayNameId] = useState('');

	// Временное состояние для редактируемого плана
	const [tempPlan, setTempPlan] = useState(null);

	// Состояние для управления раскрытием аккордеонов
	const [expandedPlanId, setExpandedPlanId] = useState(null);
	const [publicationTypes, setPublicationTypes] = useState([]);
	const validPublicationTypes = ['article', 'monograph', 'conference'];
	const validPlanStatuses = ['planned', 'in_progress', 'completed'];

	const [publicationHints, setPublicationHints] = useState({});
	const [openHintsDialog, setOpenHintsDialog] = useState(false);
	const [loadingHints, setLoadingHints] = useState(false);
	// --- НОВЫЕ состояния для формы СОЗДАНИЯ ---
	const [journalConferenceName, setJournalConferenceName] = useState('');
	const [doi, setDoi] = useState('');
	const [issn, setIssn] = useState('');
	const [isbn, setIsbn] = useState('');
	const [quartile, setQuartile] = useState('');
	const [volume, setVolume] = useState('');
	const [number, setNumber] = useState('');
	const [pages, setPages] = useState('');
	const [department, setDepartment] = useState('');
	const [publisher, setPublisher] = useState('');
	const [publisherLocation, setPublisherLocation] = useState('');
	const [printedSheetsVolume, setPrintedSheetsVolume] = useState('');
	const [circulation, setCirculation] = useState('');
	const [classificationCode, setClassificationCode] = useState('');
	const [notes, setNotes] = useState('');
	// --- КОНЕЦ НОВЫХ состояний для формы СОЗДАНИЯ ---

	// --- НОВЫЕ состояния для формы РЕДАКТИРОВАНИЯ ---
	const [editJournalConferenceName, setEditJournalConferenceName] = useState('');
	const [editDoi, setEditDoi] = useState('');
	const [editIssn, setEditIssn] = useState('');
	const [editIsbn, setEditIsbn] = useState('');
	const [editQuartile, setEditQuartile] = useState('');
	const [editVolume, setEditVolume] = useState('');                           // <- ДОБАВИТЬ
	const [editNumber, setEditNumber] = useState('');                           // <- ДОБАВИТЬ
	const [editPages, setEditPages] = useState('');
	const [editDepartment, setEditDepartment] = useState('');
	const [editPublisher, setEditPublisher] = useState('');
	const [editPublisherLocation, setEditPublisherLocation] = useState('');
	const [editPrintedSheetsVolume, setEditPrintedSheetsVolume] = useState('');
	const [editCirculation, setEditCirculation] = useState('');
	const [editClassificationCode, setEditClassificationCode] = useState('');
	const [editNotes, setEditNotes] = useState('');
	// --- КОНЕЦ НОВЫХ состояний для формы РЕДАКТИРОВАНИЯ ---


	const hintableFieldsForDisplay = [
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
			// Используем публичный эндпоинт /api/publication-hints
			const response = await axios.get('http://localhost:5000/api/publication-hints', {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken }, // Токен все равно может быть нужен
			});
			setPublicationHints(response.data);
			setError('');
		} catch (err) {
			console.error("Ошибка загрузки подсказок:", err);
			// Не показываем ошибку пользователю, просто не будет подсказок
		} finally {
			setLoadingHints(false);
		}
	};

	useEffect(() => {
		const loadInitialData = async () => {
			setInitializing(true);
			try {
				await fetchPublicationHints(); // <--- Вызов здесь
				// ... остальная параллельная загрузка ...
				// const [publishedPubs, allPubs, plansResponse] = await Promise.all([ ... ]);
				// ...
			} catch (err) {
				// ... обработка других ошибок ...
			} finally {
				setInitializing(false);
			}
		};
		loadInitialData();
	}, []); // Пустой массив зависимостей, если подсказки грузятся один раз

	useEffect(() => {
		if (user !== null) {
			setLoadingUser(false);
			setEditLastName(user.last_name || '');
			setEditFirstName(user.first_name || '');
			setEditMiddleName(user.middle_name || '');
		}
	}, [user]);


	const fetchPublishedPublications = async () => {
		try {
			// Запрос к API с параметром status='published'
			const pubResponse = await axios.get('http://localhost:5000/api/publications', {
				withCredentials: true,
				params: {
					page: 1,
					per_page: 9999, // Загружаем все публикации
					search: '',
					type: 'all',
					status: 'published',
				},
			});
			// Извлекаем публикации из ответа или возвращаем пустой массив
			const publishedPubs = pubResponse.data.publications || [];
			// Сохраняем в состояние
			setPublishedPublications(publishedPubs);
			return publishedPubs;
		} catch (err) {
			// Обработка ошибок
			console.error('Ошибка загрузки опубликованных публикаций:', err);
			setError('Произошла ошибка сервера. Попробуйте позже.');
			setOpenError(true);
			return [];
		}
	};


	const fetchAllStatusesPublications = async () => {
		try {
			// Запрос к API с параметром status='all'
			const pubResponse = await axios.get('http://localhost:5000/api/publications', {
				withCredentials: true,
				params: {
					page: 1,
					per_page: 9999,
					search: '',
					type: 'all',
					status: 'all',
				},
			});
			// Извлекаем публикации
			const allPubs = pubResponse.data.publications || [];
			return allPubs;
		} catch (err) {
			// Обработка ошибок
			console.error('Ошибка загрузки всех публикаций:', err);
			setError('Произошла ошибка сервера. Попробуйте позже.');
			setOpenError(true);
			return [];
		}
	};

	useEffect(() => {
		const fetchPublicationTypes = async () => {
			setLoadingPublicationTypes(true);
			try {
				const response = await axios.get('http://localhost:5000/api/publication-types', {
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				});
				console.log('Загруженные типы публикаций:', response.data);
				setPublicationTypes(response.data);
			} catch (err) {
				console.error('Ошибка загрузки типов публикаций:', err);
				setError('Не удалось загрузить типы публикаций.');
				setOpenError(true);
			} finally {
				setLoadingPublicationTypes(false);
			}
		};
		fetchPublicationTypes();
	}, [csrfToken]);

	const handleTabChange = (event, newValue) => {
		setValue(newValue);
		if (newValue !== 2) setShowDetailedAnalytics(false);
	};


	const fetchAllPublications = async () => {
		try {
			const pubResponse = await axios.get('http://localhost:5000/api/publications', {
				withCredentials: true,
				params: {
					page: 1,
					per_page: 9999,
					search: '',
					type: 'all',
					status: 'published', // Фильтруем только опубликованные
				},
			});
			const allPubs = pubResponse.data.publications || [];
			setPublishedPublications(allPubs);
			setFilteredPublishedPublications(allPubs);
			return allPubs;
		} catch (err) {
			console.error('Ошибка загрузки всех публикаций:', err);
			setError('Произошла ошибка сервера. Попробуйте позже.');
			setOpenError(true);
			return [];
		}
	};

	const fetchData = async (page = 1, search = '', displayNameId = '', status = 'all') => {
		try {
			const pubResponse = await axios.get('http://localhost:5000/api/publications', {
				withCredentials: true,
				params: { /* ... ваши параметры ... */
					page,
					per_page: publicationsPerPage,
					search: search || undefined,
					display_name_id:
						displayNameId && displayNameId !== 'all'
							? parseInt(displayNameId, 10)
							: undefined,
					status: validStatuses.includes(status) ? status : 'all',
				},
			});

			setPublications(pubResponse.data.publications || []);
			setFilteredPublications(pubResponse.data.publications || []);
			setCurrentPage(page);
			const total = pubResponse.data.total || 0;
			const calculatedTotalPages = Math.ceil(total / publicationsPerPage);
			setTotalPages(calculatedTotalPages);

			// --- ИНКРЕМЕНТИРУЕМ КЛЮЧ ПЕРЕХОДА ПОСЛЕ УСПЕШНОЙ УСТАНОВКИ ДАННЫХ ---
			// Это вызовет анимацию Fade на TableBody
			setPublicationsTransitionKey(prev => prev + 1);
			// --- КОНЕЦ ИЗМЕНЕНИЯ ---


			// ... остальная логика fetchData (проверка страниц, обновление аналитики) ...
			if (page > calculatedTotalPages && calculatedTotalPages > 0) {
				console.warn(`Запрошенная страница ${page} больше максимальной ${calculatedTotalPages}. Отображается последняя доступная страница.`);
				if (page > 1) {
					await fetchData(calculatedTotalPages, search, displayNameId, status);
					return;
				}
			}

			const publishedPubs = await fetchAllPublications();
			const allPubs = await fetchAllStatusesPublications();
			updateAnalytics(publishedPubs, allPubs);

			console.log('Server response for page', page, ':', pubResponse.data);
			setError('');
		} catch (err) {
			console.error('Ошибка загрузки данных:', err);
			setError('Произошла ошибка сервера. Попробуйте позже.');
			setOpenError(true);
		} finally {
			setIsTableLoading(false); // Выключаем индикатор загрузки
		}
	};




	const groupEntriesByType = (entries) => {
		const grouped = {};
		entries.forEach((entry, index) => {
			const displayNameId = entry.display_name_id || entry.type?.id || `unknown-${index}`;
			const typeName = entry.type?.name || entry.type || 'unknown';
			const displayName = entry.display_name ||
				publicationTypes.find(t => t.display_name_id === displayNameId)?.display_name ||
				'Неизвестный тип';
			const key = displayNameId;
			if (!grouped[key]) {
				grouped[key] = {
					display_name_id: displayNameId,
					type: typeName,
					display_name: displayName,
					planCount: 0,
					factCount: 0,
					entries: [],
				};
			}

			// Обновляем счётчики
			grouped[key].planCount += 1;
			if (entry.publication_id) {
				grouped[key].factCount += 1;
			}

			// Добавляем запись в группу
			grouped[key].entries.push(entry);
		});

		// Преобразуем объект в массив
		const result = Object.values(grouped);

		// Логируем результат для отладки
		console.log('Сгруппированные записи:', result);

		return result;
	};

	const fetchPlans = async (page = 1) => {
		try {
			const response = await axios.get(`http://localhost:5000/api/plans`, {
				withCredentials: true,
				params: {
					page,
					per_page: plansPerPage,
				},
			});
			const sortedPlans = (response.data.plans || []).map(plan => ({
				...plan,
				isSaved: true,
				entries: plan.entries.map(entry => ({
					...entry,
					publication_id: entry.publication_id || null,
					isPostApproval: entry.isPostApproval || false, // Устанавливаем false для старых записей, если не указано
				})),
			})).sort((a, b) => b.year - a.year);
			console.log('Обновлённые планы:', sortedPlans); // Логируем для проверки
			setPlans(sortedPlans);
			setPlanPage(page);
			const total = response.data.total || 0;
			setPlanTotalPages(Math.ceil(total / plansPerPage));
			setError('');
		} catch (err) {
			console.error('Ошибка загрузки планов:', err);
			setError('Произошла ошибка сервера. Попробуйте позже.');
			setOpenError(true);
		}
	};

	const handlePlanEntryTypeChange = (planId, oldType, newType) => {
		setTempPlan((prevTempPlan) => {
			if (prevTempPlan.id !== planId) return prevTempPlan;
			const updatedGroupedEntries = prevTempPlan.groupedEntries.map((group) => {
				if (group.type === oldType) {
					const updatedEntries = group.entries.map((entry) => ({
						...entry,
						type: newType,
					}));
					return { ...group, type: newType, entries: updatedEntries };
				}
				return group;
			});
			return { ...prevTempPlan, groupedEntries: updatedGroupedEntries };
		});
	};

	// Изменение количества записей для типа
	const handlePlanEntryCountChange = (planId, type, display_name_id, count) => {
		setTempPlan((prevTempPlan) => {
			if (prevTempPlan.id !== planId) return prevTempPlan;
			const updatedGroupedEntries = prevTempPlan.groupedEntries.map((group) => {
				if (group.type === type && group.display_name_id === display_name_id) {
					const currentEntries = group.entries;
					const currentCount = currentEntries.length;
					let updatedEntries = [...currentEntries];

					if (count > currentCount) {
						for (let i = currentCount; i < count; i++) {
							updatedEntries.push({
								id: `temp-${type}-${i}`,
								title: `${type} ${i + 1}`,
								type,
								status: 'planned',
								publication_id: null,
								isPostApproval: false,
							});
						}
					} else if (count < currentCount) {
						updatedEntries = updatedEntries.slice(0, count);
					}

					return { ...group, entries: updatedEntries, planCount: count };
				}
				return group;
			});
			return { ...prevTempPlan, groupedEntries: updatedGroupedEntries };
		});
	};

	// Удаление всех записей определённого типа
	const handleDeletePlanEntryByType = (planId, type, display_name_id) => {
		setPlanIdForTypeDelete(planId);
		setTypeToDelete(type);
		setDisplayNameIdToDelete(display_name_id);
		setOpenDeleteTypeDialog(true);
	};

	const handleDeleteTypeConfirm = () => {
		if (!planIdForTypeDelete || !typeToDelete) return;

		setTempPlan((prevTempPlan) => {
			if (prevTempPlan.id !== planIdForTypeDelete) return prevTempPlan;
			const updatedGroupedEntries = prevTempPlan.groupedEntries.map((group) => {
				if (group.type === typeToDelete && group.display_name_id === displayNameIdToDelete) {
					return { ...group, isDeleted: true };
				}
				return group;
			});
			return { ...prevTempPlan, groupedEntries: updatedGroupedEntries };
		});

		setOpenDeleteTypeDialog(false);
		setPlanIdForTypeDelete(null);
		setTypeToDelete(null);
	};

	const handleRestoreType = (planId, type, display_name_id) => {
		setTempPlan((prevTempPlan) => {
			if (prevTempPlan.id !== planId) return prevTempPlan;
			const updatedGroupedEntries = prevTempPlan.groupedEntries.map((group) => {
				if (group.type === type && group.display_name_id === display_name_id) {
					return { ...group, isDeleted: false };
				}
				return group;
			});
			return { ...prevTempPlan, groupedEntries: updatedGroupedEntries };
		});
	};

	// Функция отмены удаления типа
	const handleDeleteTypeCancel = () => {
		setOpenDeleteTypeDialog(false);
		setPlanIdForTypeDelete(null);
		setTypeToDelete(null);
	};


	const updateAnalytics = (publishedPublications, allPublications) => {
		// Объект для типов публикаций
		const types = {};
		// Объект для статусов публикаций
		const statuses = { draft: 0, needs_review: 0, published: 0 };

		// Подсчёт типов для опубликованных публикаций
		publishedPublications.forEach((pub) => {
			// Используем display_name для группировки
			const pubDisplayName = pub.type?.display_name || 'Неизвестный тип';
			types[pubDisplayName] = (types[pubDisplayName] || 0) + 1;
		});

		// Подсчёт статусов для всех публикаций
		allPublications.forEach((pub) => {
			// Увеличиваем счётчик для соответствующего статуса
			statuses[pub.status] = (statuses[pub.status] || 0) + 1;
		});

		// Сохраняем результаты в состояния
		setPubTypes(types);
		setPubStatuses(statuses);

		// Подсчёт динамики публикаций по годам (только опубликованные)
		const yearlyAnalytics = publishedPublications.reduce((acc, pub) => {
			acc[pub.year] = (acc[pub.year] || 0) + 1;
			return acc;
		}, {});
		// Преобразуем в массив для сортировки
		const analyticsData = Object.entries(yearlyAnalytics).map(([year, count]) => ({
			year: parseInt(year),
			count,
		}));
		// Сортируем по году
		analyticsData.sort((a, b) => a.year - b.year);
		setAnalytics(analyticsData);
	};

	useEffect(() => {
		const loadInitialData = async () => {
			setInitializing(true);
			try {
				// Параллельная загрузка всех данных
				const [publishedPubs, allPubs, plansResponse] = await Promise.all([
					fetchPublishedPublications(),
					fetchAllStatusesPublications(),
					axios.get('http://localhost:5000/api/plans', {
						withCredentials: true,
						params: {
							page: 1,
							per_page: plansPerPage,
						},
					}),
				]);

				// Обновление аналитики
				updateAnalytics(publishedPubs, allPubs);

				// Обработка планов
				const sortedPlans = (plansResponse.data.plans || []).map(plan => ({
					...plan,
					isSaved: true,
					entries: plan.entries.map(entry => ({
						...entry,
						publication_id: entry.publication_id || null,
						isPostApproval: entry.isPostApproval || false,
					})),
				})).sort((a, b) => b.year - a.year);
				setPlans(sortedPlans);
				setPlanPage(1);
				const total = plansResponse.data.total || 0;
				setPlanTotalPages(Math.ceil(total / plansPerPage));
			} catch (err) {
				console.error('Ошибка начальной загрузки данных:', err);
				setError('Произошла ошибка сервера. Попробуйте позже.');
				setOpenError(true);
			} finally {
				setInitializing(false);
			}
		};
		loadInitialData();
	}, []);

	useEffect(() => {
		fetchData(1, searchQuery, filterDisplayNameId, filterStatus);
		setPublicationsTransitionKey(prev => prev + 1);
	}, [searchQuery, filterDisplayNameId, filterStatus]);

	const currentPublications = useMemo(() => {
		return filteredPublications;
	}, [filteredPublications]);

	const handlePageChange = (event, newPage) => {
		fetchData(newPage, searchQuery, filterDisplayNameId, filterStatus);
	};

	const handlePlanPageChange = (event, newPage) => {
		fetchPlans(newPage);
	};

	const handleChangePasswordClick = () => {
		setOpenChangePasswordDialog(true);
		setCurrentPassword('');
		setNewPassword('');
		setShowCurrentPassword(false);
		setShowNewPassword(false);
	};

	const handleChangePasswordSubmit = async (e) => {
		e.preventDefault();
		try {
			await refreshCsrfToken();
			console.log('Changing password for user:', user?.username);
			const response = await axios.put(
				'http://localhost:5000/api/user/password',
				{
					current_password: currentPassword,
					new_password: newPassword,
				},
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);

			setSuccess('Пароль успешно обновлен!'); // Устанавливаем глобальное состояние успеха
			setOpenSuccess(true); // Показываем уведомление
			setError(''); // Сбрасываем ошибку
			setOpenChangePasswordDialog(false); // Закрываем диалог
			setCurrentPassword('');
			setNewPassword('');
			setShowCurrentPassword(false);
			setShowNewPassword(false);
		} catch (err) {
			console.error('Ошибка изменения пароля:', err);
			if (err.response) {
				setError(
					`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте введенные данные.'}`
				); // Устанавливаем глобальное состояние ошибки
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			setOpenError(true); // Показываем уведомление об ошибке
			setSuccess(''); // Сбрасываем успех
		}
	};

	const handleAddAuthor = () => {
		setNewAuthors([...newAuthors, { id: Date.now(), name: '', is_employee: false }]);
	};

	const handleAuthorChange = (index, field, value) => {
		const updatedAuthors = [...newAuthors];
		updatedAuthors[index][field] = value;
		setNewAuthors(updatedAuthors);
	};

	const handleRemoveAuthor = (index) => {
		if (newAuthors.length <= 1) return; // Не позволяем удалить последнего автора
		const updatedAuthors = newAuthors.filter((_, i) => i !== index);
		setNewAuthors(updatedAuthors);
	};



	const handleChangePasswordCancel = () => {
		setOpenChangePasswordDialog(false);
		setCurrentPassword('');
		setNewPassword('');

		setShowCurrentPassword(false);
		setShowNewPassword(false);
	};

	const handleToggleCurrentPasswordVisibility = () => {
		setShowCurrentPassword(!showCurrentPassword);
	};

	const handleToggleNewPasswordVisibility = () => {
		setShowNewPassword(!showNewPassword);
	};



	const handleFileUpload = async (e) => {
		e.preventDefault();
		if (!file) {
			setError('Пожалуйста, выберите файл для загрузки.');
			setOpenError(true);
			return;



		}
		const validAuthors = newAuthors.filter(a => a.name.trim());
		if (!title.trim() || validAuthors.length === 0 || !year || !selectedDisplayNameId) {
			setError('Пожалуйста, заполните название, год, тип и добавьте хотя бы одного автора.');
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

		const selectedType = publicationTypes.find(t => t.display_name_id === selectedDisplayNameId);
		if (!selectedType) {
			setError('Пожалуйста, выберите корректный тип публикации.');
			setOpenError(true);
			return;
		}

		const formData = new FormData();
		formData.append('file', file);
		formData.append('title', title.trim());
		const authorsToSend = validAuthors.map(({ id, ...rest }) => rest);
		formData.append('authors_json', JSON.stringify(authorsToSend));
		formData.append('year', parseInt(year, 10));
		formData.append('type_id', selectedType.id); // Передаём type_id
		formData.append('display_name_id', selectedDisplayNameId); // Передаём display_name_id
		formData.append('journal_conference_name', journalConferenceName);
		formData.append('doi', doi);
		formData.append('issn', issn);
		formData.append('isbn', isbn);
		formData.append('quartile', quartile);
		formData.append('volume', volume);                           // <- ДОБАВИТЬ
		formData.append('number', number);                           // <- ДОБАВИТЬ
		formData.append('pages', pages);
		formData.append('department', department);
		formData.append('publisher', publisher);
		formData.append('publisher_location', publisherLocation);
		// Отправляем как строки, бэкэнд разберется (или пустые строки)
		formData.append('printed_sheets_volume', printedSheetsVolume || '');
		formData.append('circulation', circulation || '');
		formData.append('classification_code', classificationCode);
		formData.append('notes', notes);


		try {
			await refreshCsrfToken();
			console.log('Uploading file with data:', {
				title: title.trim(),
				authors: authorsToSend,
				year: parseInt(year, 10),
				type_id: selectedType.id,
				display_name_id: selectedDisplayNameId,
				journal_conference_name: journalConferenceName,
				doi: doi,
				issn: issn,
				isbn: isbn,
				quartile: quartile,
				department: department,
				publisher: publisher,
				publisher_location: publisherLocation,
				printed_sheets_volume: printedSheetsVolume,
				circulation: circulation,
				classification_code: classificationCode,
				notes: notes,
			});
			const response = await axios.post('http://localhost:5000/api/publications/upload-file', formData, {
				withCredentials: true,
				headers: {
					'Content-Type': 'multipart/form-data',
					'X-CSRFToken': csrfToken,
				},
			});
			setSuccess('Публикация успешно загружена!');
			setOpenSuccess(true);
			setError('');
			setTitle('');
			setNewAuthors([{ id: Date.now(), name: '', is_employee: false }]);
			setYear('');
			setSelectedDisplayNameId(''); // Сбрасываем выбор
			setFile(null);
			setJournalConferenceName('');
			setDoi('');
			setIssn('');
			setIsbn('');
			setQuartile('');
			setVolume('');              // <- ДОБАВИТЬ
			setNumber('');              // <- ДОБАВИТЬ
			setPages('');
			setDepartment('');
			setPublisher('');
			setPublisherLocation('');
			setPrintedSheetsVolume('');
			setCirculation('');
			setClassificationCode('');
			setNotes('');
			await fetchData();
		} catch (err) {
			console.error('Ошибка загрузки файла:', err.response?.data || err);
			if (err.response) {
				setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте введенные поля и файл.'}`);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
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
			await refreshCsrfToken();
			console.log('Uploading BibTeX file');
			const response = await axios.post('http://localhost:5000/api/publications/upload-bibtex', formData, {
				withCredentials: true,
				headers: {
					'Content-Type': 'multipart/form-data',
					'X-CSRFToken': csrfToken,
				},
			});
			setSuccess(`Загружено ${response.data.message.split(' ')[1]} публикаций!`);
			setOpenSuccess(true);
			setError('');
			setFile(null);
			await fetchData();
		} catch (err) {
			console.error('Ошибка загрузки BibTeX:', err.response?.data || err);
			if (err.response) {
				setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте формат BibTeX.'}`);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			setOpenError(true);
			setSuccess('');
		}
	};

	const handleEditClick = (publication) => {
		console.log('Editing publication:', publication?.id || 'unknown');
		if (!publication) return; // Добавим проверку

		setEditPublication(publication);
		setEditTitle(publication.title || '');

		// --- Обновление инициализации авторов ---
		if (publication.authors && publication.authors.length > 0) {
			// Добавляем временный ID для каждого автора
			setEditAuthorsList(publication.authors.map((author, index) => ({
				...author,
				id: author.id || `temp-${Date.now()}-${index}` // Используем существующий ID или генерируем временный
			})));
		} else {
			// Если авторов нет, начинаем с одного пустого поля
			setEditAuthorsList([{ id: Date.now(), name: '', is_employee: false }]);
		}

		setEditYear(publication?.year || '');
		setEditSelectedDisplayNameId(publication?.display_name_id); // Пусть будет null или undefined
		setEditFile(null);
		setEditJournalConferenceName(publication?.journal_conference_name || '');
		setEditDoi(publication?.doi || '');
		setEditIssn(publication?.issn || '');
		setEditIsbn(publication?.isbn || '');
		setEditQuartile(publication?.quartile || '');
		setEditVolume(publication?.volume || '');                           // <- ДОБАВИТЬ
		setEditNumber(publication?.number || '');                           // <- ДОБАВИТЬ
		setEditPages(publication?.pages || '');
		setEditDepartment(publication?.department || '');
		setEditPublisher(publication?.publisher || '');
		setEditPublisherLocation(publication?.publisher_location || '');
		// Для числовых полей: конвертируем null/undefined в пустую строку для TextField
		setEditPrintedSheetsVolume(publication?.printed_sheets_volume != null ? String(publication.printed_sheets_volume) : '');
		setEditCirculation(publication?.circulation != null ? String(publication.circulation) : '');
		setEditClassificationCode(publication?.classification_code || '');
		setEditNotes(publication?.notes || '');
		setOpenEditDialog(true);
	};
	const handleEditSubmit = async (e) => {
		e.preventDefault();
		if (!editPublication) {
			setError('Публикация для редактирования не выбрана.');
			setOpenError(true);
			return;
		}
		const validAuthors = editAuthorsList.filter(a => a.name && a.name.trim()); // Проверяем непустое имя
		if (!editTitle.trim() || validAuthors.length === 0 || !editYear || !editSelectedDisplayNameId) {
			setError('Название, год, тип и хотя бы один автор с именем обязательны.');
			setOpenError(true);
			return;
		}

		const selectedType = publicationTypes.find(t => t.display_name_id === editSelectedDisplayNameId);
		if (!selectedType) {
			setError('Пожалуйста, выберите корректный тип публикации.');
			setOpenError(true);
			return;
		}

		const authorsToSend = validAuthors.map(({ id, ...rest }) => rest);

		let data;
		let headers = { 'X-CSRFToken': csrfToken };
		const apiUrl = `http://localhost:5000/api/publications/${editPublication.id}`;

		if (editFile) {
			data = new FormData();
			data.append('file', editFile);
			data.append('title', editTitle.trim());
			data.append('authors_json', JSON.stringify(authorsToSend));
			data.append('year', parseInt(editYear, 10));
			data.append('type_id', selectedType.id);
			data.append('display_name_id', editSelectedDisplayNameId);
			data.append('journal_conference_name', editJournalConferenceName);
			data.append('doi', editDoi);
			data.append('issn', editIssn);
			data.append('isbn', editIsbn);
			data.append('quartile', editQuartile);
			data.append('volume', editVolume);                         // <- ДОБАВИТЬ
			data.append('number', editNumber);                         // <- ДОБАВИТЬ
			data.append('pages', editPages);
			data.append('department', editDepartment);
			data.append('publisher', editPublisher);
			data.append('publisher_location', editPublisherLocation);
			data.append('printed_sheets_volume', editPrintedSheetsVolume || ''); // Отправляем пустую строку, если null/undefined
			data.append('circulation', editCirculation || ''); // Отправляем пустую строку, если null/undefined
			data.append('classification_code', editClassificationCode);
			data.append('notes', editNotes);
		} else {
			data = {
				title: editTitle.trim(),
				authors: authorsToSend,
				year: parseInt(editYear, 10),
				type_id: selectedType.id,
				display_name_id: editSelectedDisplayNameId,
				journal_conference_name: editJournalConferenceName || null, // Отправляем null для пустых необязательных полей
				doi: editDoi || null,
				issn: editIssn || null,
				isbn: editIsbn || null,
				quartile: editQuartile || null,
				volume: editVolume || null,                         // <- ДОБАВИТЬ
				number: editNumber || null,                         // <- ДОБАВИТЬ
				pages: editPages || null,
				department: editDepartment || null,
				publisher: editPublisher || null,
				publisher_location: editPublisherLocation || null,
				// Числовые поля - парсим или отправляем null
				printed_sheets_volume: editPrintedSheetsVolume ? parseFloat(editPrintedSheetsVolume) : null,
				circulation: editCirculation ? parseInt(editCirculation, 10) : null,
				classification_code: editClassificationCode || null,
				notes: editNotes || null,
			};
			headers['Content-Type'] = 'application/json';
		}

		try {
			await refreshCsrfToken();
			console.log('Обновление публикации данными:', data instanceof FormData ? Object.fromEntries(data.entries()) : data);

			// 1. Дожидаемся завершения PUT запроса
			const response = await axios.put(apiUrl, data, { withCredentials: true, headers });

			// 2. СРАЗУ после успешного запроса:
			setSuccess('Публикация успешно отредактирована!');
			setOpenSuccess(true);
			setOpenEditDialog(false); // <-- Закрываем диалог НЕМЕДЛЕННО
			setError(''); // Сброс ошибки на всякий случай

			// 3. ПОСЛЕ закрытия диалога, обновляем данные таблицы в фоне
			await fetchData(currentPage, searchQuery, filterDisplayNameId, filterStatus);

		} catch (err) {
			// Обработка ошибки - диалог НЕ закрываем, чтобы пользователь видел ошибку и мог исправить
			console.error('Ошибка редактирования публикации:', err.response?.data || err);
			if (err.response) { setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте введенные поля.'}`); }
			else { setError('Ошибка сети.'); }
			setOpenError(true);
			setSuccess('');
			// setOpenEditDialog(false); // <-- НЕ закрываем диалог при ошибке
		}
	};

	const handleSubmitForReview = async (publicationId) => {
		try {
			await refreshCsrfToken();
			const response = await axios.post(
				`http://localhost:5000/api/publications/${publicationId}/submit-for-review`,
				{},
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);
			setSuccess('Публикация отправлена на проверку!');
			setOpenSuccess(true);
			await fetchData();
		} catch (err) {
			console.error('Ошибка отправки на проверку:', err.response?.data || err);
			if (err.response) {
				setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте файл и права доступа.'}`);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			setOpenError(true);
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
		if (editAuthorsList.length <= 1) return;
		const updatedAuthors = editAuthorsList.filter((_, i) => i !== index);
		setEditAuthorsList(updatedAuthors);
	};

	const handleSaveAndSubmitForReview = async (e) => {
		e.preventDefault();
		let savedSuccessfully = false; // Флаг для отслеживания успеха сохранения

		// --- Блок сохранения (аналогично handleEditSubmit, но без fetchData в конце) ---
		if (!editPublication || !editAuthorsList.filter(a => a.name?.trim()).length || /* ...другие проверки... */ !editSelectedDisplayNameId || !editTitle.trim() || !editYear) {
			setError('Проверьте все поля перед сохранением и отправкой.');
			setOpenError(true);
			return;
		}
		// ... подготовка данных (formData или data) ...
		const authorsToSend = editAuthorsList.filter(a => a.name?.trim()).map(({ id, ...rest }) => rest);
		let data;
		let headers = { 'X-CSRFToken': csrfToken };
		const apiUrl = `http://localhost:5000/api/publications/${editPublication.id}`;
		if (editFile) {
			data = new FormData();
			data.append('file', editFile);
			data.append('title', editTitle.trim());
			data.append('authors_json', JSON.stringify(authorsToSend));
			data.append('year', parseInt(editYear, 10));
			data.append('type_id', publicationTypes.find(t => t.display_name_id === editSelectedDisplayNameId)?.id);
			data.append('display_name_id', editSelectedDisplayNameId);
			data.append('journal_conference_name', editJournalConferenceName);
			data.append('doi', editDoi);
			data.append('issn', editIssn);
			data.append('isbn', editIsbn);
			data.append('quartile', editQuartile);
			data.append('volume', editVolume);                         // <- ДОБАВИТЬ
			data.append('number', editNumber);                         // <- ДОБАВИТЬ
			data.append('pages', editPages);
			data.append('department', editDepartment);
			data.append('publisher', editPublisher);
			data.append('publisher_location', editPublisherLocation);
			data.append('printed_sheets_volume', editPrintedSheetsVolume || '');
			data.append('circulation', editCirculation || '');
			data.append('classification_code', editClassificationCode);
			data.append('notes', editNotes);
		} else {
			data = {
				title: editTitle.trim(),
				authors: authorsToSend,
				year: parseInt(editYear, 10),
				type_id: publicationTypes.find(t => t.display_name_id === editSelectedDisplayNameId)?.id,
				display_name_id: editSelectedDisplayNameId,
				journal_conference_name: editJournalConferenceName || null,
				doi: editDoi || null,
				issn: editIssn || null,
				isbn: editIsbn || null,
				quartile: editQuartile || null,
				department: editDepartment || null,
				publisher: editPublisher || null,
				publisher_location: editPublisherLocation || null,
				printed_sheets_volume: editPrintedSheetsVolume ? parseFloat(editPrintedSheetsVolume) : null,
				circulation: editCirculation ? parseInt(editCirculation, 10) : null,
				classification_code: editClassificationCode || null,
				notes: editNotes || null,
			};
			headers['Content-Type'] = 'application/json';
		}


		try {
			await refreshCsrfToken();
			await axios.put(apiUrl, data, { withCredentials: true, headers });
			savedSuccessfully = true; // Сохранение успешно
		} catch (err) {
			console.error('Ошибка при сохранении перед отправкой:', err.response?.data || err);
			if (err.response) { setError(`Ошибка сохранения: ${err.response.status} - ${err.response.data?.error || 'Проверьте поля.'}`); }
			else { setError('Ошибка сети при сохранении.'); }
			setOpenError(true);
			return; // Прерываем, если сохранить не удалось
		}

		// --- Блок отправки на проверку (только если сохранение было успешным) ---
		if (savedSuccessfully && editPublication?.id) { // Убедимся что есть ID
			try {
				await refreshCsrfToken();
				await axios.post(
					`http://localhost:5000/api/publications/${editPublication.id}/submit-for-review`,
					{},
					{ withCredentials: true, headers: { 'X-CSRFToken': csrfToken } }
				);

				// Успех отправки на проверку
				setSuccess('Публикация сохранена и отправлена на проверку!');
				setOpenSuccess(true);
				setOpenEditDialog(false); // <-- Закрываем диалог ПОСЛЕ УСПЕХА ОБЕИХ операций
				setError('');

				// Обновляем данные ПОСЛЕ закрытия
				await fetchData(currentPage, searchQuery, filterDisplayNameId, filterStatus);

			} catch (submitErr) {
				// Ошибка отправки на проверку (сохранение УЖЕ прошло)
				console.error('Ошибка отправки на проверку:', submitErr.response?.data || submitErr);
				let submitErrMsg = 'Публикация сохранена, но не удалось отправить на проверку.';
				if (submitErr.response) { submitErrMsg += ` Ошибка: ${submitErr.response.status} - ${submitErr.response.data?.error || ''}`; }
				else { submitErrMsg += ' Ошибка сети.'; }
				setError(submitErrMsg.trim());
				setOpenError(true);
				setSuccess(''); // Убираем сообщение об успешном сохранении, т.к. вся операция не завершилась как надо
				// Диалог НЕ закрываем при ошибке отправки, но УЖЕ СОХРАНЕНО
			}
		}
	};

	const handleEditCancel = () => {
		setOpenEditDialog(false);
		setEditPublication(null);
		setEditTitle('');
		setEditAuthorsList([{ id: Date.now(), name: '', is_employee: false }]);
		setEditYear('');
		setEditFile(null);
		setEditJournalConferenceName('');
		setEditDoi('');
		setEditIssn('');
		setEditIsbn('');
		setEditQuartile('');
		setEditVolume('');      // <-- ДОБАВИТЬ
		setEditNumber('');      // <-- ДОБАВИТЬ
		setEditPages('');
		setEditDepartment('');
		setEditPublisher('');
		setEditPublisherLocation('');
		setEditPrintedSheetsVolume('');
		setEditCirculation('');
		setEditClassificationCode('');
		setEditNotes('');
	};

	const handleDeleteClick = (publication) => {
		console.log('Deleting publication:', publication.id);
		setPublicationToDelete(publication);
		setPlanToDelete(null); // Сбрасываем planToDelete
		setOpenDeleteDialog(true);
	};

	const handleDeleteConfirm = async () => {
		if (!publicationToDelete) return;

		try {
			await refreshCsrfToken();
			console.log('Confirming deletion of publication:', publicationToDelete.id);
			const response = await axios.delete(`http://localhost:5000/api/publications/${publicationToDelete.id}`, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});

			// 2. СРАЗУ после успеха:
			setSuccess('Публикация успешно удалена!');
			setOpenSuccess(true);
			setOpenDeleteDialog(false); // <-- Закрываем диалог НЕМЕДЛЕННО
			setError('');
			setPublicationToDelete(null); // Сброс удаляемого объекта

			// 3. ПОСЛЕ закрытия диалога обновляем данные (чтобы удалить строку из таблицы)
			// Если удаляется последняя запись на странице > 1, нужно перейти на пред. страницу
			const pageToFetch = (publications.length === 1 && currentPage > 1) ? currentPage - 1 : currentPage;
			await fetchData(pageToFetch, searchQuery, filterDisplayNameId, filterStatus);

		} catch (err) {
			// Ошибка - диалог НЕ закрываем, показываем ошибку
			console.error('Ошибка удаления публикации:', err.response?.data || err);
			if (err.response) { setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте права доступа.'}`); }
			else { setError('Ошибка сети. Проверьте подключение и сервер.'); }
			setOpenError(true);
			setSuccess('');
			// setOpenDeleteDialog(false); // <-- НЕ закрываем диалог при ошибке
		}
	};

	const handleDeleteCancel = () => {
		setOpenDeleteDialog(false);
		setPublicationToDelete(null);
		setPlanToDelete(null);
	};

	const handleEditUserClick = () => {
		setOpenEditUserDialog(true);
	};

	const handleEditUserSubmit = async (e) => {
		e.preventDefault();
		try {
			await refreshCsrfToken();
			console.log('Updating user data:', { last_name: editLastName, first_name: editFirstName, middle_name: editMiddleName });
			const response = await axios.put(
				'http://localhost:5000/api/user',
				{
					last_name: editLastName.trim() || null,
					first_name: editFirstName.trim() || null,
					middle_name: editMiddleName.trim() || null,
				},
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);
			// Обновляем данные пользователя в контексте
			setUser({
				...user,
				last_name: response.data.user.last_name,
				first_name: response.data.user.first_name,
				middle_name: response.data.user.middle_name,
			});
			// Устанавливаем сообщение об успехе для отображения в карточке
			setSuccess('Личные данные успешно обновлены!');
			setOpenSuccess(true);
			setError('');
			setOpenEditUserDialog(false); // Закрываем диалог сразу после успешного сохранения
		} catch (err) {
			console.error('Ошибка редактирования данных:', err.response?.data || err);
			if (err.response) {
				setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте введенные поля.'}`);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			setOpenError(true);
			setSuccess('');
		}
	};

	const handleEditUserCancel = () => {
		setOpenEditUserDialog(false);
	};

	const handleAttachFileClick = (publication) => {
		console.log('Attaching file to publication:', publication.id);
		setPublicationToAttach(publication);
		setOpenAttachFileDialog(true);
		setAttachFile(null);
		setError(''); // Сброс общей ошибки
		setOpenError(false);
		setSuccess(''); // Сброс общего успеха
		setOpenSuccess(false);
	};

	const handleAttachFileSubmit = async (e) => {
		e.preventDefault();
		if (!attachFile) {
			setError('Пожалуйста, выберите файл для прикрепления.'); // <- setError
			setOpenError(true); // <- setOpenError
			return;
		}

		const formData = new FormData();
		formData.append('file', attachFile);

		try {
			await refreshCsrfToken();
			console.log('Sending attach file request for publication:', publicationToAttach.id);
			const response = await axios.post(
				`http://localhost:5000/api/publications/${publicationToAttach.id}/attach-file`,
				formData,
				{
					withCredentials: true, // Важно для cookies/сессии
					headers: {
						// Content-Type устанавливается Axios автоматически для FormData
						'X-CSRFToken': csrfToken, // Отправляем CSRF токен
					},
				}
			);

			// 2. СРАЗУ после успеха:
			setSuccess('Файл успешно прикреплен!');
			setOpenSuccess(true);
			setOpenAttachFileDialog(false); // <-- Закрываем диалог НЕМЕДЛЕННО
			setError('');
			setAttachFile(null); // Сброс состояния файла

			// 3. ПОСЛЕ закрытия диалога обновляем данные
			await fetchData(currentPage, searchQuery, filterDisplayNameId, filterStatus);

		} catch (err) {
			// Обработка ошибки - диалог НЕ закрываем
			console.error('Ошибка прикрепления файла:', err.response?.data || err);
			let errorMessage = 'Произошла ошибка при прикреплении файла.';
			if (err.response) { /* ... */ } else { /* ... */ }
			setError(errorMessage);
			setOpenError(true);
			setSuccess('');
			// setOpenAttachFileDialog(false); // <-- НЕ закрываем диалог при ошибке
		}
	};

	const handleAttachFileCancel = () => {
		setOpenAttachFileDialog(false);
		setPublicationToAttach(null);
		setAttachFile(null);
		// Можно добавить сброс общих уведомлений, если это нужно при отмене
		setError('');
		setOpenError(false);
		setSuccess('');
		setOpenSuccess(false);
	};

	const handleDownloadClick = (publication) => {
		console.log('Downloading file for publication:', publication.id);
		if (!publication.file_url) {
			setError('Файл не прикреплен к этой публикации.');
			setOpenError(true);
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



	const handleExportBibTeX = async () => {
		try {
			await refreshCsrfToken();
			const response = await axios.get('http://localhost:5000/api/publications/export-bibtex', {
				withCredentials: true,
			});
			const blob = new Blob([response.data], { type: 'application/x-bibtex' });
			const url = window.URL.createObjectURL(blob);
			const link = document.createElement('a');
			link.href = url;
			link.download = 'publications.bib';
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
			window.URL.revokeObjectURL(url);
		} catch (err) {
			console.error('Ошибка выгрузки в BibTeX:', err.response?.data || err.message);
			alert(`Не удалось экспортировать публикации в BibTeX: ${err.response?.data?.error || 'Внутренняя ошибка сервера'}`);
		}
	};

	const chartData = {
		labels: analytics.map((item) => item.year),
		datasets: [
			{
				label: 'Количество публикаций',
				data: analytics.map((item) => item.count),
				backgroundColor: 'rgba(0, 120, 255, 0.5)',
				borderColor: 'rgba(0, 120, 255, 1)',
				borderWidth: 1,
				fill: true,
				tension: 0.4,
			},
		],
	};

	const chartOptions = {
		responsive: true,
		maintainAspectRatio: false,
		plugins: {
			legend: { position: 'top', labels: { color: '#1D1D1F' } },
			title: { display: false },
			tooltip: { backgroundColor: 'rgba(0, 0, 0, 0.8)', titleColor: '#FFFFFF', bodyColor: '#FFFFFF' },
		},
		scales: {
			x: { title: { display: false }, ticks: { color: '#1D1D1F' } },
			y: { title: { display: false }, beginAtZero: true, ticks: { color: '#1D1D1F' } },
		},
		animation: { duration: 1000 },
	};

	const handleCreatePlan = async () => {
		if (!newPlan.year || newPlan.year < 1900 || newPlan.year > 2100) {
			setError('Пожалуйста, укажите корректный год (1900–2100).');
			setOpenError(true);
			return;
		}

		try {
			await refreshCsrfToken();
		} catch (err) {
			console.error('Ошибка при обновлении CSRF-токена:', err);
			setError('Не удалось обновить CSRF-токен. Попробуйте снова.');
			setOpenError(true);
			return;
		}

		const planData = {
			year: newPlan.year,
			fillType: 'manual',
			entries: [],
		};

		try {
			const response = await axios.post(
				'http://localhost:5000/api/plans',
				planData,
				{
					withCredentials: true,
					headers: {
						'Content-Type': 'application/json',
						'X-CSRFToken': csrfToken,
					},
				}
			);

			setPlans([...plans, response.data.plan]);
			setNewPlan({ year: new Date().getFullYear() + 1, expectedCount: 1 });
			setSuccess('План успешно создан!');
			setOpenSuccess(true);
			// Диалог не закрываем сразу, ждём закрытия Snackbar
		} catch (err) {
			console.error('Ошибка при создании плана:', err);
			const errorMessage = err.response?.data?.error || 'Произошла ошибка при создании плана.';
			setError(errorMessage);
			setOpenError(true);
		}
	};
	const handleEditPlanClick = (planId) => {
		setEditingPlanId(planId);
		setExpandedPlanId(planId);
		const planToEdit = plans.find((plan) => plan.id === planId);
		const tempEntries = groupEntriesByType(planToEdit.entries).map((group) => ({
			...group,
			isDeleted: false,
		}));
		setTempPlan({ ...planToEdit, groupedEntries: tempEntries });
		setPlans((prevPlans) =>
			prevPlans.map((plan) =>
				plan.id === planId ? { ...plan, isSaved: false } : plan
			)
		);
	};


	const handleAddPlanEntry = (planId) => {
		if (!publicationTypes.length) {
			console.warn('Типы публикаций ещё не загружены');
			return;
		}
		setTempPlan((prevTempPlan) => {
			if (prevTempPlan.id !== planId) return prevTempPlan;

			const newGroupedEntries = [...prevTempPlan.groupedEntries];
			selectedNewEntryType.forEach((displayNameId) => {
				const typeItem = publicationTypes.find(t => t.display_name_id === displayNameId);
				if (!typeItem) {
					console.warn(`Тип с display_name_id: ${displayNameId} не найден`);
					return;
				}
				const typeId = typeItem.id;
				const typeName = typeItem.name;

				const existingGroup = newGroupedEntries.find(g => g.display_name_id === displayNameId && !g.isDeleted);
				if (existingGroup) {
					const i = existingGroup.entries.length;
					existingGroup.entries.push({
						id: `temp-${displayNameId}-${i}`,
						title: `${typeItem.display_name} ${i + 1}`,
						type: typeName,
						type_id: typeId,
						display_name_id: displayNameId,
						status: 'planned',
						publication_id: null,
						isPostApproval: false,
					});
					existingGroup.planCount += 1;
				} else {
					newGroupedEntries.push({
						display_name_id: displayNameId,
						type: typeName,
						type_id: typeId,
						display_name: typeItem.display_name,
						planCount: 1,
						factCount: 0,
						entries: [{
							id: `temp-${displayNameId}-0`,
							title: `${typeItem.display_name} 1`,
							type: typeName,
							type_id: typeId,
							display_name_id: displayNameId,
							status: 'planned',
							publication_id: null,
							isPostApproval: false,
						}],
						isDeleted: false,
					});
				}
			});
			return { ...prevTempPlan, groupedEntries: newGroupedEntries };
		});
		setSelectedNewEntryType([]);
	};
	const handleDeletePlanEntry = (planId, index) => {
		setPlans(prevPlans =>
			prevPlans.map(plan =>
				plan.id === planId
					? {
						...plan,
						entries: plan.entries.filter((_, i) => i !== index),
						isSaved: false,
					}
					: plan
			)
		);
	};
	const handleSavePlan = async (plan) => {
		try {
			await refreshCsrfToken();
			const updatedPlan = {
				year: tempPlan.year,
				fillType: tempPlan.fillType,
				entries: tempPlan.groupedEntries
					.filter(group => !group.isDeleted)
					.flatMap(group =>
						group.entries.map(entry => ({
							id: typeof entry.id === 'string' && entry.id.startsWith('temp') ? null : entry.id,
							title: entry.title,
							type_id: entry.type_id,
							display_name_id: group.display_name_id,
							status: entry.status,
							publication_id: entry.publication_id,
							isPostApproval: entry.isPostApproval || false,
						}))
					),
			};
			const response = await axios.put(`http://localhost:5000/api/plans/${plan.id}`, updatedPlan, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken },
			});
			setPlans(plans.map(p => (p.id === plan.id ? { ...response.data.plan, isSaved: true } : p)));
			setEditingPlanId(null);
			setTempPlan(null);
			setSuccess('План успешно сохранен!');
			setOpenSuccess(true);
		} catch (err) {
			console.error('Ошибка при сохранении плана:', err);
			setError('Произошла ошибка при сохранении плана. Попробуйте позже.');
			setOpenError(true);
		}
	};
	const handleSubmitPlanForReview = async (plan) => {

		try {
			// ---> НАЧАЛО ИЗМЕНЕНИЙ
			// Проверяем, есть ли записи в плане
			if (!plan || !plan.entries || plan.entries.length === 0) {
				setError('Нельзя отправить пустой план на проверку.');
				setOpenError(true);
				return; // Прерываем выполнение функции
			}
			// Проверяем, что все заголовки заполнены (оставляем эту проверку)
			if (!areAllTitlesFilled(plan)) {
				setError('Все записи плана должны иметь заполненные заголовки перед отправкой.');
				setOpenError(true);
				return; // Прерываем выполнение функции
			}
			// <--- КОНЕЦ ИЗМЕНЕНИЙ
			await refreshCsrfToken();
			const response = await axios.post(
				`http://localhost:5000/api/plans/${plan.id}/submit-for-review`,
				{},
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);
			setSuccess('План отправлен на проверку!');
			setOpenSuccess(true);
			setError('');
			setEditingPlanId(null);
			await fetchPlans(planPage);
		} catch (err) {
			console.error('Ошибка отправки плана на проверку:', err.response?.data || err);
			if (err.response) {
				setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте права доступа.'}`);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			setOpenError(true);
			setSuccess('');
		}
	};

	const handleDeletePlanClick = (plan) => {
		console.log('Deleting plan:', plan.id);
		setPlanToDelete(plan);
		setPublicationToDelete(null); // Сбрасываем publicationToDelete
		setOpenDeleteDialog(true);
	};

	const handleDeletePlanConfirm = async () => {
		if (!planToDelete) return;

		try {
			await refreshCsrfToken();
			console.log('Confirming deletion of plan:', planToDelete.id);
			const response = await axios.delete(`http://localhost:5000/api/plans/${planToDelete.id}`, {
				withCredentials: true,
				headers: {
					'X-CSRFToken': csrfToken,
				},
			});
			setSuccess('План успешно удалён!');
			setOpenSuccess(true);
			setError('');
			await fetchPlans(planPage);
		} catch (err) {
			console.error('Ошибка удаления плана:', err.response?.data || err);
			if (err.response) {
				setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте права доступа.'}`);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			setOpenError(true);
			setSuccess('');
		}
		setOpenDeleteDialog(false);
		setPlanToDelete(null);
	};

	const handleLinkSearch = (query) => {
		setLinkSearchQuery(query);

		// Собираем все publication_id из записей всех планов
		const linkedPublicationIds = new Set(
			plans.flatMap(plan =>
				plan.entries
					.filter(entry => entry.publication_id)
					.map(entry => entry.publication_id)
			)
		);

		// Фильтруем публикации:
		// 1. Оставляем только те, которые соответствуют типу записи плана
		// 2. Исключаем уже привязанные
		// 3. Применяем поиск по названию или авторам
		const filtered = publishedPublications.filter(
			pub =>
				pub.type === selectedPlanEntry.type && // Фильтрация по типу записи плана
				!linkedPublicationIds.has(pub.id) && // Исключаем уже привязанные
				(pub.title.toLowerCase().includes(query.toLowerCase()) || // Поиск по названию
					pub.authors.toLowerCase().includes(query.toLowerCase())) // Поиск по авторам
		);

		setFilteredPublishedPublications(filtered);
	};

	// Функция для открытия диалога привязки публикации
	const handleOpenLinkDialog = (planId, entry) => {
		console.log("Выбранная запись плана:", entry);
		console.log("display_name_id записи:", entry.display_name_id);
		// Собираем все publication_id из записей всех планов, чтобы исключить уже привязанные публикации
		const linkedPublicationIds = new Set(
			plans.flatMap(plan =>
				plan.entries
					.filter(entry => entry.publication_id) // Фильтруем записи с publication_id
					.map(entry => entry.publication_id)

			)
		);

		console.log("Всего опубликованных публикаций:", publishedPublications.length);
		console.log("Пример публикации:", publishedPublications[0]);

		// Фильтруем публикации:
		// 1. Оставляем только те, которые соответствуют типу записи плана (entry.type)
		// 2. Исключаем уже привязанные публикации
		const availablePublications = publishedPublications.filter(
			pub =>
				Number(pub.display_name_id) === Number(entry.display_name_id) &&
				!linkedPublicationIds.has(pub.id)

		);
		console.log("Все опубликованные display_name_id:", publishedPublications.map(p => p.display_name_id));
		console.log("Подходящие публикации:", availablePublications);

		// Устанавливаем выбранную запись плана и открываем диалог
		setSelectedPlanEntry({ planId, ...entry });
		setLinkDialogOpen(true);
		setLinkSearchQuery(''); // Сбрасываем поиск
		setFilteredPublishedPublications(availablePublications); // Устанавливаем отфильтрованные публикации
	};

	const handleOpenUnlinkDialog = (planId, group) => {
		setSelectedGroup({ ...group, planId });
		setUnlinkDialogOpen(true);
	};

	// Функция привязки публикации
	const handleLinkPublication = async (planId, entryGroup, publicationId) => {
		try {
			// Находим первую запись без publication_id
			const entryToLink = entryGroup.entries.find((entry) => !entry.publication_id);
			if (!entryToLink) {
				setError('Вы уже привязали планируемое количество работ этого типа');
				setOpenError(true);
				return;
			}

			// Обновляем CSRF-токен перед запросом
			await refreshCsrfToken();

			// Отправляем запрос на привязку
			const response = await axios.post(
				`http://localhost:5000/api/plans/${planId}/entries/${entryToLink.id}/link`,
				{ publication_id: publicationId },
				{
					withCredentials: true,
					headers: {
						'Content-Type': 'application/json',
						'X-CSRFToken': csrfToken,
					},
				}
			);

			// Обновляем состояние plans локально
			setPlans((prevPlans) =>
				prevPlans.map((plan) => {
					if (plan.id === planId) {
						const updatedEntries = plan.entries.map((entry) =>
							entry.id === entryToLink.id
								? { ...entry, publication_id: publicationId }
								: entry
						);
						return { ...plan, entries: updatedEntries, fact_count: plan.fact_count + 1 };
					}
					return plan;
				})
			);

			// Если план редактируется, обновляем tempPlan
			if (tempPlan && tempPlan.id === planId) {
				setTempPlan((prevTempPlan) => ({
					...prevTempPlan,
					groupedEntries: prevTempPlan.groupedEntries.map((group) =>
						group.type === entryGroup.type
							? {
								...group,
								entries: group.entries.map((entry) =>
									entry.id === entryToLink.id
										? { ...entry, publication_id: publicationId }
										: entry
								),
								factCount: group.factCount + 1,
							}
							: group
					),
				}));
			}

			// Обновляем список доступных публикаций для привязки
			const linkedPublicationIds = new Set([
				...plans.flatMap((plan) =>
					plan.entries
						.filter((entry) => entry.publication_id)
						.map((entry) => entry.publication_id)
				),
				publicationId, // добавляем только что привязанный ID
			]);

			const updatedFilteredPublications = publishedPublications.filter(
				(pub) =>
					Number(pub.display_name_id) === Number(entryGroup.display_name_id) &&
					!linkedPublicationIds.has(pub.id) &&
					(pub.title.toLowerCase().includes(linkSearchQuery.toLowerCase()) ||
						pub.authors.toLowerCase().includes(linkSearchQuery.toLowerCase()))
			);
			setFilteredPublishedPublications(updatedFilteredPublications);

			// Обновляем selectedPlanEntry
			setSelectedPlanEntry({
				...entryGroup,
				planId,
				entries: entryGroup.entries.map((entry) =>
					entry.id === entryToLink.id
						? { ...entry, publication_id: publicationId }
						: entry
				),
				factCount: entryGroup.factCount + 1,
			});

			setSuccess('Публикация успешно привязана!');
			setOpenSuccess(true);
		} catch (err) {
			console.error('Ошибка привязки публикации:', err);
			setError(
				err.response?.data?.error || 'Произошла ошибка при привязке публикации.'
			);
			setOpenError(true);
		}
	};

	const handleUnlinkPublication = async (planId, entryId) => {
		try {
			// Обновляем CSRF-токен
			await refreshCsrfToken();

			// Отправляем запрос на отвязку
			const response = await axios.post(
				`http://localhost:5000/api/plans/${planId}/entries/${entryId}/unlink`,
				{},
				{
					withCredentials: true,
					headers: {
						'Content-Type': 'application/json',
						'X-CSRFToken': csrfToken,
					},
				}
			);

			// Обновляем состояние plans локально
			setPlans((prevPlans) =>
				prevPlans.map((plan) => {
					if (plan.id === planId) {
						const updatedEntries = plan.entries.map((entry) =>
							entry.id === entryId ? { ...entry, publication_id: null } : entry
						);
						const updatedFactCount = updatedEntries.filter(
							(entry) => entry.publication_id
						).length;
						return { ...plan, entries: updatedEntries, fact_count: updatedFactCount };
					}
					return plan;
				})
			);

			// Если план редактируется, обновляем tempPlan
			if (tempPlan && tempPlan.id === planId) {
				setTempPlan((prevTempPlan) => ({
					...prevTempPlan,
					groupedEntries: prevTempPlan.groupedEntries.map((group) =>
						group.type === selectedGroup.type
							? {
								...group,
								entries: group.entries.map((entry) =>
									entry.id === entryId ? { ...entry, publication_id: null } : entry
								),
								factCount: group.entries.filter(
									(entry) => entry.publication_id && entry.id !== entryId
								).length,
							}
							: group
					),
				}));
			}

			// Обновляем selectedGroup
			setSelectedGroup({
				...selectedGroup,
				entries: selectedGroup.entries.map((entry) =>
					entry.id === entryId ? { ...entry, publication_id: null } : entry
				),
				factCount: selectedGroup.entries.filter(
					(entry) => entry.publication_id && entry.id !== entryId
				).length,
			});

			// Обновляем filteredPublishedPublications
			const linkedPublicationIds = new Set(
				plans.flatMap((plan) =>
					plan.entries
						.filter((entry) => entry.publication_id)
						.map((entry) => entry.publication_id)
				)
			);

			const updatedFilteredPublications = publishedPublications.filter(
				(pub) =>
					pub.type === selectedPlanEntry?.type &&
					!linkedPublicationIds.has(pub.id) &&
					(pub.title.toLowerCase().includes(linkSearchQuery.toLowerCase()) ||
						pub.authors.toLowerCase().includes(linkSearchQuery.toLowerCase()))
			);
			setFilteredPublishedPublications(updatedFilteredPublications);

			setSuccess('Публикация успешно отвязана!');
			setOpenSuccess(true);
		} catch (err) {
			console.error('Ошибка отвязки публикации:', err);
			setError(
				err.response?.data?.error || 'Произошла ошибка при отвязке публикации.'
			);
			setOpenError(true);
		}
	};

	// Функция вычисления прогресса выполнения плана
	const calculateProgress = (plan) => {
		const completed = plan.fact_count || 0; // Используем fact_count
		const total = plan.plan_count || 0; // Используем plan_count
		return total > 0 ? (completed / total) * 100 : 0; // Защищаемся от NaN
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

	const refreshCsrfToken = async () => {
		try {
			const response = await axios.get('http://localhost:5000/api/csrf-token', {
				withCredentials: true,
			});
			setCsrfToken(response.data.csrf_token);
			console.log('CSRF Token обновлён:', response.data.csrf_token);
		} catch (err) {
			console.error('Ошибка обновления CSRF Token:', err);
		}
	};

	if (loadingUser) {
		return (
			<Container maxWidth="lg" sx={{ mt: 4, display: 'flex', justifyContent: 'center' }}>
				<CircularProgress sx={{ color: '#0071E3' }} />
			</Container>
		);
	}

	return (
		<Container
			maxWidth="lg"
			sx={{
				mt: 4,
				backgroundColor: '#FFFFFF',
				borderRadius: '16px',
				boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
				fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif",
			}}
		>
			<AppleCard sx={{ p: 4, borderRadius: '16px', backgroundColor: '#FFFFFF', boxShadow: 'none' }}>
				<CardContent>
					<Typography
						variant="h4"
						gutterBottom
						sx={{
							color: '#1D1D1F',
							fontWeight: 600,
							textAlign: 'center',
						}}
					>
						Личный кабинет
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
								borderRadius: '12px',
								'&:hover': { color: '#0071E3', backgroundColor: '#F5F5F7' },
								'&.Mui-selected': { color: '#1D1D1F', backgroundColor: '#F5F5F7' },
							},
							'& .MuiTabs-indicator': { backgroundColor: '#0071E3' },
						}}
					>
						<Tab label="Личные данные" />
						<Tab label="Публикации" />
						<Tab label="Аналитика" />
						<Tab label="План" />
						<Tab label="Экспорт" />
					</Tabs>

					{initializing ? (
						<Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
							<CircularProgress sx={{ color: '#0071E3' }} />
						</Box>
					) : (
						<>
							{value === 0 && (
								<Accordion
									defaultExpanded
									sx={{
										boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
										borderRadius: '16px',
										backgroundColor: '#FFFFFF',
									}}
								>
									<AccordionSummary expandIcon={<ExpandMoreIcon sx={{ color: '#FFFFFF' }} />} sx={{ backgroundColor: '#0071E3', borderRadius: '16px' }}>
										<Typography variant="h5" sx={{ color: '#FFFFFF' }}>
											Личные данные
										</Typography>
									</AccordionSummary>
									<AccordionDetails sx={{ p: 3 }}>
										{user ? (
											<Box>
												<Typography variant="body1" sx={{ color: '#1D1D1F', mb: 2 }}>
													ФИО: {user.last_name} {user.first_name} {user.middle_name || ''}
												</Typography>
												<Typography variant="body1" sx={{ color: '#1D1D1F', mb: 2 }}>
													Логин: {user.username}
												</Typography>
												<Box sx={{ display: 'flex', gap: 2, mb: 2 }}>
													<AppleButton onClick={handleEditUserClick}>Редактировать данные</AppleButton>
													<AppleButton onClick={handleChangePasswordClick}>Изменить пароль</AppleButton>
												</Box>
											</Box>
										) : (
											<Typography sx={{ color: '#6E6E73' }}>Данные пользователя не найдены.</Typography>
										)}
									</AccordionDetails>
								</Accordion>
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
										Загрузка публикаций
									</Typography>
									<AppleCard sx={{
										mb: 4, p: 3, backgroundColor: '#F5F5F7', borderRadius: '16px',
										boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
										position: 'relative' // <--- Для позиционирования иконки
									}}>
										{/* --- ИКОНКА ПОДСКАЗКИ --- */}
										<IconButton
											aria-label="show-hints"
											onClick={() => setOpenHintsDialog(true)}
											sx={{
												position: 'absolute',
												top: 16, // Отступ сверху
												right: 16, // Отступ справа
												color: '#0071E3', // Синий цвет как у кнопок
												backgroundColor: 'rgba(0, 113, 227, 0.1)',
												'&:hover': {
													backgroundColor: 'rgba(0, 113, 227, 0.2)',
												},
											}}
											title="Показать подсказки по заполнению"
											disabled={loadingHints || Object.keys(publicationHints).length === 0} // Неактивна, если подсказки грузятся или пусты
										>
											<LightbulbOutlinedIcon />
										</IconButton>
										<Box sx={{ mb: 2, display: 'flex', gap: 2 }}>
											<AppleButton
												onClick={() => setUploadType('file')}
												sx={{
													backgroundColor: uploadType === 'file' ? '#0071E3' : '#F5F5F7',
													color: uploadType === 'file' ? '#FFFFFF' : '#1D1D1F',
													border: '1px solid #D1D1D6',
												}}
											>
												Загрузить файл (PDF/DOCX)
											</AppleButton>
											<AppleButton
												onClick={() => setUploadType('bibtex')}
												sx={{
													backgroundColor: uploadType === 'bibtex' ? '#0071E3' : '#F5F5F7',
													color: uploadType === 'bibtex' ? '#FFFFFF' : '#1D1D1F',
													border: '1px solid #D1D1D6',
												}}
											>
												Загрузить BibTeX
											</AppleButton>
										</Box>

										{uploadType === 'file' ? (
											<form onSubmit={handleFileUpload}>
												<AppleTextField
													fullWidth
													select
													label="Тип публикации"
													value={selectedDisplayNameId}
													onChange={(e) => setSelectedDisplayNameId(e.target.value)}
													margin="normal"
													variant="outlined"
													disabled={publicationTypes.length === 0}
												>
													{publicationTypes.length === 0 ? (
														<MenuItem value="" disabled>
															Типы не доступны
														</MenuItem>
													) : (
														publicationTypes.map((type) => (
															<MenuItem key={type.display_name_id} value={type.display_name_id}>
																{type.display_name}
															</MenuItem>
														))
													)}
												</AppleTextField>
												<AppleTextField
													fullWidth
													label="Название"
													value={title}
													onChange={(e) => setTitle(e.target.value)}
													margin="normal"
													variant="outlined"
												/>
												<Box sx={{ mt: 2, border: '1px solid #D1D1D6', borderRadius: '12px', p: 2, backgroundColor: '#FFFFFF' }}>
													<Typography variant="subtitle1" sx={{ mb: 1, color: '#1D1D1F' }}>Авторы</Typography>
													{newAuthors.map((author, index) => (
														<Grid container spacing={1} key={author.id} sx={{ mb: 1, alignItems: 'center' }}>
															<Grid item xs={true}>
																<AppleTextField
																	fullWidth
																	required
																	label={`Автор ${index + 1}`}
																	value={author.name}
																	onChange={(e) => handleAuthorChange(index, 'name', e.target.value)}
																	size="small"
																	variant="outlined"
																/>
															</Grid>
															<Grid item xs="auto"> {/* Изменено с xs={1} */}
																<MuiTooltip title={author.is_employee ? "Автор сотрудник КНИТУ-КАИ" : "Автор не сотрудник КНИТУ-КАИ"} arrow>
																	<IconButton
																		onClick={() => handleAuthorChange(index, 'is_employee', !author.is_employee)}
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
															<Grid item xs="auto"> {/* Изменено с xs={1} */}
																{newAuthors.length > 1 && (
																	<IconButton
																		onClick={() => handleRemoveAuthor(index)}
																		size="small"
																		sx={{ color: '#FF3B30' }}
																		aria-label="Удалить автора"
																	>
																		<DeleteIcon fontSize="small" />
																	</IconButton>
																)}
															</Grid>
														</Grid>
													))}
													<Button
														startIcon={<AddIcon />}
														onClick={handleAddAuthor}
														size="small"
														sx={{ mt: 1, textTransform: 'none', color: '#0071E3' }}
													>
														Добавить автора
													</Button>
												</Box>
												<AppleTextField
													fullWidth
													label="Год"
													type="number"
													value={year}
													onChange={(e) => setYear(e.target.value)}
													margin="normal"
													variant="outlined"
												/>
												<AppleTextField
													fullWidth
													label="Наименование журнала/конференции"
													value={journalConferenceName}
													onChange={(e) => setJournalConferenceName(e.target.value)}
													margin="normal"
													variant="outlined"
												/>
												<Grid container spacing={2}> {/* Используем Grid для группировки */}
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="DOI"
															value={doi}
															onChange={(e) => setDoi(e.target.value)}
															margin="normal"
															variant="outlined"
														/>
													</Grid>
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="Квартиль (Q)"
															value={quartile}
															onChange={(e) => setQuartile(e.target.value)}
															margin="normal"
															variant="outlined"
														/>
													</Grid>
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="ISSN"
															value={issn}
															onChange={(e) => setIssn(e.target.value)}
															margin="normal"
															variant="outlined"
														/>
													</Grid>
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="ISBN"
															value={isbn}
															onChange={(e) => setIsbn(e.target.value)}
															margin="normal"
															variant="outlined"
														/>
													</Grid>
												</Grid>
												<Grid container spacing={2}>
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Том"
															value={volume}
															onChange={(e) => setVolume(e.target.value)}
															margin="normal"
															variant="outlined"
														/>
													</Grid>
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Номер/Выпуск"
															value={number}
															onChange={(e) => setNumber(e.target.value)}
															margin="normal"
															variant="outlined"
														/>
													</Grid>
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Страницы"
															value={pages}
															onChange={(e) => setPages(e.target.value)}
															margin="normal"
															variant="outlined"
														/>
													</Grid>
												</Grid>
												<Grid container spacing={2}>
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="Издательство"
															value={publisher}
															onChange={(e) => setPublisher(e.target.value)}
															margin="normal"
															variant="outlined"
														/>
													</Grid>
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="Место издательства"
															value={publisherLocation}
															onChange={(e) => setPublisherLocation(e.target.value)}
															margin="normal"
															variant="outlined"
														/>
													</Grid>
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Объем (п.л.)"
															type="number" // Для валидации браузера, но отправляем строку
															value={printedSheetsVolume}
															onChange={(e) => setPrintedSheetsVolume(e.target.value)}
															margin="normal"
															variant="outlined"
															inputProps={{ step: "0.1" }} // Для дробных чисел
														/>
													</Grid>
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Тираж"
															type="number"
															value={circulation}
															onChange={(e) => setCirculation(e.target.value)}
															margin="normal"
															variant="outlined"
														/>
													</Grid>
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Кафедра"
															value={department}
															onChange={(e) => setDepartment(e.target.value)}
															margin="normal"
															variant="outlined"
														/>
													</Grid>
												</Grid>
												<AppleTextField
													fullWidth
													label="Код по классификатору"
													value={classificationCode}
													onChange={(e) => setClassificationCode(e.target.value)}
													margin="normal"
													variant="outlined"
												/>
												<AppleTextField
													fullWidth
													label="Примечание"
													value={notes}
													onChange={(e) => setNotes(e.target.value)}
													margin="normal"
													variant="outlined"
													multiline
													rows={2}
												/>
												{/* --- КОНЕЦ НОВЫХ ПОЛЕЙ --- */}

												<Box sx={{ mt: 2 }}>
													<input
														type="file"
														accept=".pdf,.docx"
														onChange={(e) => setFile(e.target.files[0])}
														style={{ display: 'none' }}
														id="upload-file"
													/>
													<label htmlFor="upload-file">
														<AppleButton sx={{ border: '1px solid #D1D1D6', backgroundColor: '#F5F5F7', color: '#1D1D1F' }} component="span">
															Выбрать файл
														</AppleButton>
													</label>
													{file && <Typography sx={{ mt: 1, color: '#6E6E73' }}>{file.name}</Typography>}
												</Box>

												<AppleButton type="submit" sx={{ mt: 2 }}>
													Загрузить
												</AppleButton>
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
														<AppleButton sx={{ border: '1px solid #D1D1D6', backgroundColor: '#F5F5F7', color: '#1D1D1F' }} component="span">
															Выбрать BibTeX-файл
														</AppleButton>
													</label>
													{file && <Typography sx={{ mt: 1, color: '#6E6E73' }}>{file.name}</Typography>}
												</Box>

												<AppleButton type="submit" sx={{ mt: 2 }}>
													Загрузить
												</AppleButton>
											</form>
										)}
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
										Ваши публикации
									</Typography>
									<AppleCard
										sx={{
											mt: 2,
											mb: 2,
											p: 2,
											backgroundColor: '#F5F5F7',
											borderRadius: '16px',
											boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
										}}
									>
										<AppleTextField
											fullWidth
											label="Поиск по названию, авторам или году"
											value={searchQuery}
											onChange={(e) => setSearchQuery(e.target.value)}
											margin="normal"
											variant="outlined"
											InputProps={{
												endAdornment: <IconButton sx={{ color: '#0071E3' }}>{/* Можно добавить иконку поиска */}</IconButton>,
											}}
										/>
										<Box sx={{ mt: 2, display: 'flex', gap: 2 }}>
											<AppleTextField
												select
												label="Тип публикации"
												value={filterDisplayNameId}
												onChange={(e) => setFilterDisplayNameId(e.target.value)}
												margin="normal"
												variant="outlined"
												sx={{ minWidth: "120px" }}>
												<MenuItem value="all">Все</MenuItem>
												{publicationTypes.map((type) => (
													<MenuItem key={type.display_name_id} value={type.display_name_id}>
														{type.display_name}
													</MenuItem>
												))}
											</AppleTextField>
											<AppleTextField
												select
												label="Статус"
												value={filterStatus}
												onChange={(e) => setFilterStatus(e.target.value)}
												margin="normal"
												variant="outlined"
												sx={{ minWidth: "70px" }}>
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
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', borderRadius: '12px 0 0 0' }}>
													ID
												</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Название</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Авторы</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Год</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Тип</TableCell>
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Статус</TableCell>
												<TableCell
													sx={{
														fontWeight: 600,
														color: '#FFFFFF',
														textAlign: 'center',
														borderRadius: '0 12px 0 0',
													}}
												>
													Действия
												</TableCell>
											</TableRow>
										</TableHead>
										{/* Fade оборачивает TableBody, ключ управляет анимацией */}
										<Fade in={true} timeout={300} key={publicationsTransitionKey}>
											{/* Убираем isTableLoading ИЗНУТРИ TableBody */}
											<TableBody>
												{/* Всегда рендерим строки на основе currentPublications */}
												{currentPublications.length > 0 ? (
													currentPublications.map((pub) => (
														<TableRow
															key={pub.id} // React ключ
															sx={{
																'&:hover': { backgroundColor: '#F5F5F7', transition: 'background-color 0.3s ease' },
															}}
														>
															{/* ... ваши TableCell с данными публикации ... */}
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
															<TableCell sx={{ color: '#1D1D1F' }}> {pub.authors && pub.authors.length > 0
																? pub.authors.map(author => author.name).join(', ')
																: 'Нет авторов'}</TableCell>
															<TableCell sx={{ color: '#1D1D1F' }}>{pub.year}</TableCell>
															<TableCell sx={{ color: '#1D1D1F' }}>
																{pub.type?.display_name || 'Неизвестный тип'}
															</TableCell>
															<TableCell sx={{ color: '#1D1D1F' }}>
																<StatusChip
																	status={
																		pub.status === 'returned_for_revision' && pub.returned_for_revision
																			? 'returned_for_revision'
																			: pub.status
																	}
																	role={user.role}
																/>
															</TableCell>
															<TableCell sx={{ textAlign: 'center' }}>
																{/* ... ваши IconButton ... */}
																<Box sx={{ display: 'flex', justifyContent: 'center', gap: 1 }}>
																	{(pub.status === 'draft' || pub.status === 'returned_for_revision') && (
																		<>
																			<IconButton
																				aria-label="edit"
																				onClick={() => handleEditClick(pub)}
																				sx={{ /* styles */ color: '#0071E3', '&:hover': { color: '#FFFFFF', backgroundColor: '#0071E3' } }}
																			>
																				<EditIcon />
																			</IconButton>
																			<IconButton
																				aria-label="delete"
																				onClick={() => handleDeleteClick(pub)}
																				sx={{ /* styles */ color: '#0071E3', '&:hover': { color: '#FFFFFF', backgroundColor: '#0071E3' } }}
																			>
																				<DeleteIcon />
																			</IconButton>
																			{pub.file_url && (
																				<IconButton
																					aria-label="submit-for-review"
																					onClick={() => handleSubmitForReview(pub.id)}
																					sx={{ /* styles */ color: 'green', '&:hover': { color: '#FFFFFF', backgroundColor: 'green' } }}
																				>
																					<PublishIcon />
																				</IconButton>
																			)}
																		</>
																	)}
																	{pub.file_url && pub.status !== 'draft' && pub.status !== 'returned_for_revision' && (
																		<IconButton
																			aria-label="download"
																			onClick={() => handleDownloadClick(pub)}
																			sx={{ /* styles */ color: '#0071E3', '&:hover': { color: '#FFFFFF', backgroundColor: '#0071E3' } }}
																		>
																			<DownloadIcon />
																		</IconButton>
																	)}
																	{!pub.file_url && (pub.status === 'draft' || pub.status === 'returned_for_revision') && (
																		<IconButton
																			aria-label="attach"
																			onClick={() => handleAttachFileClick(pub)}
																			sx={{ /* styles */ color: '#0071E3', '&:hover': { color: '#FFFFFF', backgroundColor: '#0071E3' } }}
																		>
																			<AttachFileIcon />
																		</IconButton>
																	)}
																</Box>
															</TableCell>
														</TableRow>
													))
												) : (
													// Показываем "Нет публикаций" только если НЕ идет загрузка
													!isTableLoading && (
														<TableRow>
															<TableCell colSpan={7} sx={{ textAlign: 'center', color: '#6E6E73' }}>
																Нет доступных публикаций {searchQuery || filterDisplayNameId !== 'all' || filterStatus !== 'all' ? ' по заданным фильтрам' : ''}.
															</TableCell>
														</TableRow>
													)
												)}
											</TableBody>
										</Fade>
									</AppleTable>

									{/* ВНЕШНИЙ ИНДИКАТОР ЗАГРУЗКИ (под таблицей) */}


									<Box sx={{ mt: 2, display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
										<Pagination
											count={totalPages}
											page={currentPage}
											onChange={handlePageChange}
											color="primary"
											sx={{
												'& .MuiPaginationItem-root': {
													borderRadius: 20,
													transition: 'all 0.3s ease',
													'&:hover': { backgroundColor: 'grey.100', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)' },
													'&.Mui-selected': {
														backgroundColor: '#1976D2',
														color: 'white',
														boxShadow: '0 6px 16px rgba(0, 0, 0, 0.2)',
													},
												},
											}}
										/>
									</Box>
								</>
							)}

							{value === 2 && (
								<Box sx={{ mt: 4 }}>
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
										Аналитика публикаций
									</Typography>
									{analytics.length === 0 ? (
										<AppleCard elevation={2} sx={{ p: 4, mt: 2, borderRadius: '16px', backgroundColor: '#FFFFFF', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
											<Typography variant="body1" sx={{ color: '#6E6E73', textAlign: 'center' }}>
												У вас ещё нет ни одной публикации.{' '}
												<AppleButton
													variant="text"
													onClick={() => setUploadType('file')}
													sx={{
														p: 0.5,
														textTransform: 'none',
														color: '#0071E3',
														backgroundColor: 'transparent',
														'&:hover': { color: '#0066CC', backgroundColor: 'transparent' },
													}}
												>
													Загрузите публикации
												</AppleButton>
												, чтобы вести аналитику по своим работам.
											</Typography>
										</AppleCard>
									) : (
										<AppleCard elevation={2} sx={{ p: 4, mt: 2, borderRadius: '16px', backgroundColor: '#FFFFFF', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
											<CardContent>
												<Typography variant="h6" sx={{ color: '#1D1D1F', mb: 2 }}>
													Динамика публикаций
												</Typography>
												<Box sx={{ mb: 4, height: '300px' }}>
													<Line data={chartData} options={chartOptions} ref={chartRef} key={analytics.map((item) => item.year).join('-')} />
												</Box>

												<DetailsButton onClick={() => setShowDetailedAnalytics(!showDetailedAnalytics)} sx={{ mb: 2 }}>
													{showDetailedAnalytics ? 'Свернуть' : 'Подробнее'}
												</DetailsButton>

												<Collapse in={showDetailedAnalytics}>
													<>
														<Typography variant="h6" sx={{ color: '#1D1D1F', mb: 2 }}>
															Типы публикаций
														</Typography>
														<Grid container spacing={2} sx={{ mb: 4 }}>
															{Object.entries(pubTypes).map(([typeName, count]) => {
																const type = publicationTypes.find(t => t.name === typeName);
																return (
																	<Grid item xs={12} sm={4} key={typeName}>
																		<AppleCard elevation={1} sx={{ p: 2, borderRadius: '12px', backgroundColor: '#FFFFFF', boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)' }}>
																			<CardContent>
																				<Typography variant="body1" sx={{ color: '#1D1D1F' }}>
																					{type ? type.display_name : typeName}: {count}
																				</Typography>
																			</CardContent>
																		</AppleCard>
																	</Grid>
																);
															})}
														</Grid>

														<Typography variant="h6" sx={{ color: '#1D1D1F', mb: 2 }}>
															Статусы публикаций
														</Typography>
														<Grid container spacing={2} sx={{ mb: 4 }}>
															{Object.entries(pubStatuses).map(([status, count]) => (
																<Grid item xs={12} sm={4} key={status}>
																	<AppleCard elevation={1} sx={{ p: 2, borderRadius: '12px', backgroundColor: '#FFFFFF', boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)' }}>
																		<CardContent>
																			<Typography variant="body1" sx={{ color: '#1D1D1F' }}>
																				{status === 'draft' ? 'Черновики' : status === 'needs_review' ? 'Нуждается в проверке' : 'Опубликованные'}: {count}
																			</Typography>
																		</CardContent>
																	</AppleCard>
																</Grid>
															))}
														</Grid>

														<Typography variant="h6" sx={{ color: '#1D1D1F', mb: 2 }}>
															Общая статистика
														</Typography>
														<Typography variant="body1" sx={{ color: '#6E6E73' }}>
															Всего опубликованных публикаций: {analytics.reduce((sum, item) => sum + item.count, 0)}
															{totalCitations > 0 && ` | Общее количество цитирований: ${totalCitations}`}
														</Typography>
													</>
												</Collapse>
											</CardContent>
										</AppleCard>
									)}
								</Box>
							)}

							{value === 3 && (
								<>
									<Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
										<Typography
											variant="h5"
											sx={{
												color: '#1D1D1F',
												fontWeight: 600,
											}}
										>
											Ваши планы
										</Typography>
										<AppleButton startIcon={<AddIcon />} onClick={() => setOpenCreatePlanDialog(true)}>
											Создать план
										</AppleButton>
									</Box>

									{plans.map((plan) => {
										const groupedEntries = tempPlan && tempPlan.id === plan.id ? tempPlan.groupedEntries.filter(g => !g.isDeleted) : groupEntriesByType(plan.entries);

										return (
											<Accordion
												key={plan.id}
												expanded={expandedPlanId === plan.id}
												onChange={(event, isExpanded) => {
													setExpandedPlanId(isExpanded ? plan.id : null);
												}}
												sx={{
													mb: 2,
													borderRadius: '16px',
													boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
												}}
											>
												<AccordionSummary
													expandIcon={<ExpandMoreIcon />}
													component="div" // Заменяем <button> на <div>
													sx={{ cursor: 'pointer' }} // Добавляем курсор для сохранения интерактивности
												>
													<Box sx={{ display: 'flex', justifyContent: 'space-between', width: '100%', alignItems: 'center' }}>
														<Typography variant="h6" sx={{ color: '#1D1D1F' }}>
															План на {plan.year} год (План: {plan.plan_count} | Факт: {plan.fact_count})
														</Typography>
														<Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
															<StatusChip status={plan.status} role={user.role} />
															{(plan.status === 'draft' || plan.status === 'returned') && (
																<>
																	{/* --- КНОПКА РЕДАКТИРОВАТЬ --- */}
																	<IconButton
																		onClick={(e) => {
																			e.stopPropagation();
																			handleEditPlanClick(plan.id);
																		}}
																		sx={{ color: '#0071E3' }}
																		// ИСПРАВЛЕННОЕ условие disabled: Проверяем только статус
																		disabled={plan.status !== 'draft' && plan.status !== 'returned'}
																		// ИСПРАВЛЕННЫЙ title
																		title="Редактировать план"
																	>
																		<EditIcon />
																	</IconButton>

																	{/* --- КНОПКА УДАЛИТЬ (Оставить как есть или скорректировать) --- */}
																	<IconButton
																		onClick={(e) => {
																			e.stopPropagation();
																			handleDeletePlanClick(plan);
																		}}
																		sx={{ color: '#FF3B30' }}
																		// Оставляем проверку по статусу, если нужно, или убираем, если удаление всегда разрешено для draft/returned
																		disabled={plan.status !== 'draft' && plan.status !== 'returned'} // Или скорректируйте по необходимости
																		title="Удалить план" // Добавляем подсказку
																	>
																		<DeleteIcon />
																	</IconButton>

																	{/* --- КНОПКА ОТПРАВИТЬ (Проверяем её условия) --- */}
																	<IconButton
																		onClick={(e) => {
																			e.stopPropagation();
																			handleSubmitPlanForReview(plan);
																		}}
																		sx={{ color: '#0071E3' }}
																		// ПРОВЕРЕННОЕ/КОРРЕКТНОЕ условие disabled для ОТПРАВКИ
																		disabled={
																			!plan.entries || // Проверка 1: Существует ли 'entries'?
																			plan.entries.length === 0 || // Проверка 2: Пуст ли 'entries'?
																			!areAllTitlesFilled(plan) || // Проверка 3: Заполнены ли все заголовки?
																			(plan.status !== 'draft' && plan.status !== 'returned') // Проверка 4: Корректный ли статус?
																		}
																		// ПРОВЕРЕННЫЙ/КОРРЕКТНЫЙ title для ОТПРАВКИ
																		title={
																			(plan.status !== 'draft' && plan.status !== 'returned')
																				? `Нельзя отправить план в статусе '${plan.status}'` // Причина: статус
																				: (!plan.entries || plan.entries.length === 0)
																					? 'Нельзя отправить пустой план' // Причина: пустой план
																					: !areAllTitlesFilled(plan)
																						? 'Заполните все заголовки перед отправкой' // Причина: заголовки
																						: 'Отправить на проверку' // По умолчанию, если активна
																		}
																	>
																		<PublishIcon />
																	</IconButton>
																</>
															)}
														</Box>
													</Box>
												</AccordionSummary>
												<AccordionDetails>
													{editingPlanId === plan.id ? (
														<>
															{tempPlan?.groupedEntries?.length === 0 ? (
																<Typography sx={{ color: '#1D1D1F', mt: 2, fontStyle: 'italic' }}>
																	Ваш план пуст, выберите планируемые типы публикаций.
																</Typography>
															) : (
																<PlanTable>
																	<TableHead>
																		<TableRow>
																			<TableCell>Тип</TableCell>
																			<TableCell>Количество</TableCell>
																			<TableCell>Действия</TableCell>
																		</TableRow>
																	</TableHead>
																	<TableBody>
																		{tempPlan?.groupedEntries?.map((group, index) => {
																			const typeData = publicationTypes.find(t => t.name === group.type);
																			return (
																				<TableRow key={index} sx={{ backgroundColor: group.isDeleted ? '#E5E5EA' : 'inherit' }}>
																					<TableCell>
																						{group.display_name || (publicationTypes.find(t => t.name === group.type)?.display_name) || group.type}
																					</TableCell>
																					<TableCell>
																						<AppleTextField
																							sx={{ width: '70px' }}
																							type="number"
																							value={group.planCount}
																							onChange={(e) => handlePlanEntryCountChange(plan.id, group.type, group.display_name_id, parseInt(e.target.value) || 1)}
																							fullWidth
																							variant="outlined"
																							disabled={group.isDeleted}
																						/>
																					</TableCell>
																					<TableCell>
																						{group.isDeleted ? (
																							<IconButton
																								onClick={() => handleRestoreType(plan.id, group.type, group.display_name_id)}
																								sx={{ color: '#34C759' }}
																								title="Восстановить тип"
																								disabled={plan.status === 'pending'}
																							>
																								<AddIcon />
																							</IconButton>
																						) : (
																							<IconButton
																								onClick={() => handleDeletePlanEntryByType(plan.id, group.type, group.display_name_id)}
																								sx={{ color: '#FF3B30' }}
																								title="Удалить тип"
																								disabled={plan.status === 'pending'}
																							>
																								<DeleteIcon />
																							</IconButton>
																						)}
																					</TableCell>
																				</TableRow>
																			);
																		})}
																	</TableBody>
																</PlanTable>
															)}
															<Box sx={{ display: 'flex', gap: 2, mt: 2 }}>
																<FormControl sx={{ minWidth: 200 }}>
																	<InputLabel>Типы публикаций</InputLabel>
																	<AppleSelect
																		multiple
																		value={selectedNewEntryType}
																		onChange={(e) => setSelectedNewEntryType(e.target.value)}
																		renderValue={(selected) =>
																			selected.length === 0 ? (
																				<Typography sx={{ color: '#6E6E73' }}>Выберите типы</Typography>
																			) : (
																				<Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
																					{selected.map((value) => (
																						<Chip
																							key={value}
																							label={publicationTypes.find(t => t.display_name_id === value)?.display_name || value}
																							onMouseDown={(event) => event.stopPropagation()}
																							onDelete={(event) => {
																								event.stopPropagation();
																								setSelectedNewEntryType(selectedNewEntryType.filter((item) => item !== value));
																							}}
																						/>
																					))}
																				</Box>
																			)
																		}
																	>
																		{publicationTypes.map(type => (
																			<MenuItem key={type.display_name_id} value={type.display_name_id}>
																				{type.display_name}
																			</MenuItem>
																		))}
																	</AppleSelect>
																</FormControl>
																<AppleButton
																	startIcon={<AddIcon />}
																	onClick={() => handleAddPlanEntry(plan.id)}
																	disabled={selectedNewEntryType.length === 0}
																>
																	Добавить тип
																</AppleButton>
																<RedCancelButton
																	onClick={() => {
																		setEditingPlanId(null);
																		setTempPlan(null);
																		setExpandedPlanId(null);
																	}}
																>
																	Отмена
																</RedCancelButton>
																<GreenButton
																	startIcon={<SaveIcon />}
																	onClick={() => handleSavePlan(plan)}
																	disabled={
																		!areAllTitlesFilled({
																			...plan,
																			entries: tempPlan.groupedEntries.flatMap((group) => (group.isDeleted ? [] : group.entries)),
																		})
																	}
																>
																	Сохранить
																</GreenButton>
															</Box>
														</>
													) : (
														<>
															<Typography sx={{ mb: 1 }}>Прогресс выполнения:</Typography>
															<Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2 }}>
																<LinearProgress
																	variant="determinate"
																	value={Math.min(calculateProgress(plan), 100)}
																	sx={{
																		height: 8,
																		borderRadius: 4,
																		flexGrow: 1,
																		backgroundColor: '#E5E5EA',
																		'& .MuiLinearProgress-bar': { backgroundColor: '#34C759' },
																	}}
																/>
																<Typography
																	variant="body2"
																	sx={{
																		minWidth: '50px',
																		textAlign: 'right',
																		color: calculateProgress(plan) > 100 ? '#FF9500' : '#1D1D1F',
																	}}
																>
																	{Math.round(calculateProgress(plan))}%
																</Typography>
															</Box>
															{groupedEntries.length === 0 ? (
																<Typography sx={{ color: '#1D1D1F', mt: 2, fontStyle: 'italic' }}>
																	Ваш план пуст, выберите планируемые типы публикаций.
																</Typography>
															) : (
																<PlanTable>
																	<TableHead>
																		<TableRow>
																			<TableCell>План/Факт</TableCell>
																			<TableCell>Тип</TableCell>
																			<TableCell>Действия</TableCell>
																		</TableRow>
																	</TableHead>
																	<TableBody>
																		{groupedEntries.map((group) => (
																			<TableRow key={group.display_name_id}>
																				<TableCell>{`${group.planCount}/${group.factCount}`}</TableCell>
																				<TableCell>
																					{group.display_name || (publicationTypes.find(t => t.name === group.type)?.display_name) || group.type}
																				</TableCell>
																				<TableCell>
																					<IconButton
																						onClick={() => handleOpenLinkDialog(plan.id, group)}
																						sx={{ color: '#0071E3' }}
																						title="Привязать публикацию"
																						disabled={plan.status !== 'approved' || group.factCount >= group.planCount}
																					>
																						<LinkIcon />
																					</IconButton>
																					<IconButton
																						onClick={() => handleOpenUnlinkDialog(plan.id, group)}
																						sx={{ color: group.factCount > 0 ? '#FF3B30' : '#D1D1D6' }}
																						title="Отвязать публикацию"
																						disabled={plan.status !== 'approved' || group.factCount === 0}
																					>
																						<UnlinkIcon />
																					</IconButton>
																				</TableCell>
																			</TableRow>
																		))}
																	</TableBody>
																</PlanTable>
															)}

															{plan.return_comment && plan.status !== 'approved' && (
																<Typography
																	sx={{
																		mt: 2,
																		color: '#000000',
																		fontWeight: 600,
																		display: 'flex',
																		alignItems: 'center',
																		gap: 1,
																	}}
																>
																	<WarningAmberIcon sx={{ color: '#FF3B30' }} />
																	Комментарий при возврате: {plan.return_comment}
																</Typography>
															)}
														</>
													)}
												</AccordionDetails>
											</Accordion>
										);
									})}

									<Pagination
										count={planTotalPages}
										page={planPage}
										onChange={handlePlanPageChange}
										sx={{ mt: 2, display: 'flex', justifyContent: 'center' }}
									/>
								</>
							)}

							{value === 4 && (
								<Box sx={{ mt: 4 }}>
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
										Экспорт публикаций
									</Typography>
									<AppleCard sx={{ p: 4, borderRadius: '16px', backgroundColor: '#FFFFFF', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
										<CardContent>
											<Typography variant="body1" sx={{ color: '#6E6E73', mb: 2 }}>
												Вы можете экспортировать свои публикации в формате BibTeX.
											</Typography>
											<AppleButton onClick={handleExportBibTeX}>Экспортировать в BibTeX</AppleButton>
										</CardContent>
									</AppleCard>
								</Box>
							)}
						</>
					)}
				</CardContent>
			</AppleCard>


			{/* Диалог редактирования пользователя */}
			<Dialog
				open={openEditUserDialog}
				onClose={handleEditUserCancel}
				maxWidth="sm"
				fullWidth
				PaperProps={{
					sx: {
						borderRadius: '16px',
						boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
						backgroundColor: '#FFFFFF',
					},
				}}
			>
				<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>Редактировать личные данные</DialogTitle>
				<DialogContent>
					<form onSubmit={handleEditUserSubmit}>
						<AppleTextField
							fullWidth
							label="Фамилия"
							value={editLastName}
							onChange={(e) => setEditLastName(e.target.value)}
							margin="normal"
							variant="outlined"
						/>
						<AppleTextField
							fullWidth
							label="Имя"
							value={editFirstName}
							onChange={(e) => setEditFirstName(e.target.value)}
							margin="normal"
							variant="outlined"
						/>
						<AppleTextField
							fullWidth
							label="Отчество"
							value={editMiddleName}
							onChange={(e) => setEditMiddleName(e.target.value)}
							margin="normal"
							variant="outlined"
						/>
					</form>
				</DialogContent>
				<DialogActions sx={{ p: 2 }}>
					<CancelButton onClick={handleEditUserCancel}>Отмена</CancelButton>
					<AppleButton onClick={handleEditUserSubmit}>Сохранить</AppleButton>
				</DialogActions>
			</Dialog>

			{/* Диалог изменения пароля */}
			<Dialog
				open={openChangePasswordDialog}
				onClose={handleChangePasswordCancel}
				maxWidth="sm"
				fullWidth
				PaperProps={{
					sx: {
						borderRadius: '16px',
						boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
						backgroundColor: '#FFFFFF',
					},
				}}
			>
				<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>Изменить пароль</DialogTitle>
				<DialogContent>
					<form onSubmit={handleChangePasswordSubmit}>
						<AppleTextField
							fullWidth
							label="Текущий пароль"
							type={showCurrentPassword ? 'text' : 'password'}
							value={currentPassword}
							onChange={(e) => setCurrentPassword(e.target.value)}
							margin="normal"
							variant="outlined"
							InputProps={{
								endAdornment: (
									<IconButton onClick={handleToggleCurrentPasswordVisibility} sx={{ color: '#0071E3' }}>
										{showCurrentPassword ? <VisibilityOff /> : <Visibility />}
									</IconButton>
								),
							}}
						/>
						<AppleTextField
							fullWidth
							label="Новый пароль"
							type={showNewPassword ? 'text' : 'password'}
							value={newPassword}
							onChange={(e) => setNewPassword(e.target.value)}
							margin="normal"
							variant="outlined"
							InputProps={{
								endAdornment: (
									<IconButton onClick={handleToggleNewPasswordVisibility} sx={{ color: '#0071E3' }}>
										{showNewPassword ? <VisibilityOff /> : <Visibility />}
									</IconButton>
								),
							}}
						/>
					</form>
				</DialogContent>
				<DialogActions sx={{ p: 2 }}>
					<CancelButton onClick={handleChangePasswordCancel}>Отмена</CancelButton>
					<AppleButton onClick={handleChangePasswordSubmit}>Сохранить</AppleButton>
				</DialogActions>
			</Dialog>

			{/* Диалог редактирования публикации */}
			<Dialog
				open={openEditDialog}
				onClose={handleEditCancel}
				maxWidth="sm"
				fullWidth
				PaperProps={{
					sx: {
						borderRadius: '16px',
						boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
						backgroundColor: '#FFFFFF',
					},
				}}
			>
				<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>Редактировать публикацию</DialogTitle>
				<DialogContent>
					<form onSubmit={handleEditSubmit}>
						<AppleTextField
							fullWidth
							select
							label="Тип публикации"
							value={editSelectedDisplayNameId}
							onChange={(e) => setEditSelectedDisplayNameId(e.target.value)}
							margin="normal"
							variant="outlined"
							disabled={publicationTypes.length === 0}
						>
							{publicationTypes.length === 0 ? (
								<MenuItem value="" disabled>
									Типы не доступны
								</MenuItem>
							) : (
								publicationTypes.map((type) => (
									<MenuItem key={type.display_name_id} value={type.display_name_id}>
										{type.display_name}
									</MenuItem>
								))
							)}
						</AppleTextField>
						<AppleTextField
							fullWidth
							label="Название"
							value={editTitle}
							onChange={(e) => setEditTitle(e.target.value)}
							margin="normal"
							variant="outlined"
						/>
						<Box sx={{ mt: 2, border: '1px solid #D1D1D6', borderRadius: '12px', p: 2, backgroundColor: '#FFFFFF' }}>
							<Typography variant="subtitle1" sx={{ mb: 1, color: '#1D1D1F' }}>Авторы</Typography>
							{editAuthorsList.map((author, index) => (
								<Grid container spacing={1} key={author.id} sx={{ mb: 1, alignItems: 'center' }}>
									{/* --- ИМЯ АВТОРА (ЗАНИМАЕТ ОСТАВШЕЕСЯ МЕСТО) --- */}
									<Grid item xs={true}> {/* Изменено с xs={8} */}
										<AppleTextField
											fullWidth
											required
											label={`Автор ${index + 1}`}
											value={author.name}
											onChange={(e) => handleEditAuthorChange(index, 'name', e.target.value)}
											size="small"
											variant="outlined"
										/>
									</Grid>
									<Grid item xs="auto"> {/* Изменено с xs={1} */}
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
									<Grid item xs="auto"> {/* Изменено с xs={1} */}
										{editAuthorsList.length > 1 && (
											<IconButton
												onClick={() => handleEditRemoveAuthor(index)}
												size="small"
												sx={{ color: '#FF3B30' }}
												aria-label="Удалить автора"
											>
												<DeleteIcon fontSize="small" />
											</IconButton>
										)}
									</Grid>
								</Grid>
							))}
							<Button
								startIcon={<AddIcon />}
								onClick={handleEditAddAuthor}
								size="small"
								sx={{ mt: 1, textTransform: 'none', color: '#0071E3' }}
							>
								Добавить автора
							</Button>
						</Box>
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
							label="Наименование журнала/конференции"
							value={editJournalConferenceName}
							onChange={(e) => setEditJournalConferenceName(e.target.value)}
							margin="normal"
							variant="outlined"
						/>
						<Grid container spacing={2}>
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="DOI"
									value={editDoi}
									onChange={(e) => setEditDoi(e.target.value)}
									margin="normal"
									variant="outlined"
								/>
							</Grid>
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="Квартиль (Q)"
									value={editQuartile}
									onChange={(e) => setEditQuartile(e.target.value)}
									margin="normal"
									variant="outlined"
								/>
							</Grid>
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="ISSN"
									value={editIssn}
									onChange={(e) => setEditIssn(e.target.value)}
									margin="normal"
									variant="outlined"
								/>
							</Grid>
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="ISBN"
									value={editIsbn}
									onChange={(e) => setEditIsbn(e.target.value)}
									margin="normal"
									variant="outlined"
								/>
							</Grid>
						</Grid>
						<Grid container spacing={2}>
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Том"
									value={editVolume}
									onChange={(e) => setEditVolume(e.target.value)}
									margin="normal"
									variant="outlined"
								/>
							</Grid>
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Номер/Выпуск"
									value={editNumber}
									onChange={(e) => setEditNumber(e.target.value)}
									margin="normal"
									variant="outlined"
								/>
							</Grid>
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Страницы"
									value={editPages}
									onChange={(e) => setEditPages(e.target.value)}
									margin="normal"
									variant="outlined"
								/>
							</Grid>
						</Grid>
						<Grid container spacing={2}>
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="Издательство"
									value={editPublisher}
									onChange={(e) => setEditPublisher(e.target.value)}
									margin="normal"
									variant="outlined"
								/>
							</Grid>
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="Место издательства"
									value={editPublisherLocation}
									onChange={(e) => setEditPublisherLocation(e.target.value)}
									margin="normal"
									variant="outlined"
								/>
							</Grid>
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Объем (п.л.)"
									type="number"
									value={editPrintedSheetsVolume}
									onChange={(e) => setEditPrintedSheetsVolume(e.target.value)}
									margin="normal"
									variant="outlined"
									inputProps={{ step: "0.1" }}
								/>
							</Grid>
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Тираж"
									type="number"
									value={editCirculation}
									onChange={(e) => setEditCirculation(e.target.value)}
									margin="normal"
									variant="outlined"
								/>
							</Grid>
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Кафедра"
									value={editDepartment}
									onChange={(e) => setEditDepartment(e.target.value)}
									margin="normal"
									variant="outlined"
								/>
							</Grid>
						</Grid>
						<AppleTextField
							fullWidth
							label="Код по классификатору"
							value={editClassificationCode}
							onChange={(e) => setEditClassificationCode(e.target.value)}
							margin="normal"
							variant="outlined"
						/>
						<AppleTextField
							fullWidth
							label="Примечание"
							value={editNotes}
							onChange={(e) => setEditNotes(e.target.value)}
							margin="normal"
							variant="outlined"
							multiline
							rows={2}
						/>

						<Box sx={{ mt: 2 }}>
							<input
								type="file"
								accept=".pdf,.docx"
								onChange={(e) => setEditFile(e.target.files[0])}
								style={{ display: 'none' }}
								id="edit-file"
							/>
							<label htmlFor="edit-file">
								<AppleButton sx={{ border: '1px solid #D1D1D6', backgroundColor: '#F5F5F7', color: '#1D1D1F' }} component="span">
									Выбрать файл
								</AppleButton>
							</label>
							{editFile && <Typography sx={{ mt: 1, color: '#6E6E73' }}>{editFile.name}</Typography>}
						</Box>
					</form>
				</DialogContent>
				<DialogActions sx={{ p: 2 }}>
					<CancelButton onClick={handleEditCancel}>Отмена</CancelButton>
					<AppleButton onClick={handleEditSubmit}>Сохранить</AppleButton>
					{editPublication?.file_url && (
						<GreenButton onClick={handleSaveAndSubmitForReview}>Сохранить и отправить на проверку</GreenButton>
					)}
				</DialogActions>
			</Dialog>

			{/* Диалог прикрепления файла */}
			<Dialog
				open={openAttachFileDialog}
				onClose={handleAttachFileCancel}
				maxWidth="sm"
				fullWidth
				PaperProps={{
					sx: {
						borderRadius: '16px',
						boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
						backgroundColor: '#FFFFFF',
					},
				}}
			>
				<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>Прикрепить файл</DialogTitle>
				<DialogContent>
					<form onSubmit={handleAttachFileSubmit}>
						<Box sx={{ mt: 2 }}>
							<input
								type="file"
								accept=".pdf,.docx"
								onChange={(e) => setAttachFile(e.target.files[0])}
								style={{ display: 'none' }}
								id="attach-file"
							/>
							<label htmlFor="attach-file">
								<AppleButton sx={{ border: '1px solid #D1D1D6', backgroundColor: '#F5F5F7', color: '#1D1D1F' }} component="span">
									Выбрать файл
								</AppleButton>
							</label>
							{attachFile && <Typography sx={{ mt: 1, color: '#6E6E73' }}>{attachFile.name}</Typography>}
						</Box>

					</form>
				</DialogContent>
				<DialogActions sx={{ p: 2 }}>
					<CancelButton onClick={handleAttachFileCancel}>Отмена</CancelButton>
					<AppleButton onClick={handleAttachFileSubmit}>Прикрепить</AppleButton>
				</DialogActions>
			</Dialog>

			{/* Диалог удаления публикации или плана */}
			<Dialog
				open={openDeleteDialog}
				onClose={handleDeleteCancel}
				maxWidth="sm"
				fullWidth
				PaperProps={{
					sx: {
						borderRadius: '16px',
						boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
						backgroundColor: '#FFFFFF',
					},
				}}
			>
				<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>Подтверждение удаления</DialogTitle>
				<DialogContent>
					<Typography sx={{ color: '#1D1D1F' }}>
						Вы уверены, что хотите удалить {publicationToDelete?.title || planToDelete?.title || 'этот объект'}?
					</Typography>
				</DialogContent>
				<DialogActions sx={{ p: 2 }}>
					<CancelButton onClick={handleDeleteCancel}>Отмена</CancelButton>
					<AppleButton
						onClick={publicationToDelete ? handleDeleteConfirm : planToDelete ? handleDeletePlanConfirm : () => { }}
						sx={{ backgroundColor: '#FF3B30', '&:hover': { backgroundColor: '#FF2D1A' } }}
						disabled={!publicationToDelete && !planToDelete}
					>
						Удалить
					</AppleButton>
				</DialogActions>
			</Dialog>


			<Dialog
				open={openDeleteTypeDialog}
				onClose={handleDeleteTypeCancel}
				maxWidth="sm"
				fullWidth
				PaperProps={{
					sx: {
						borderRadius: '16px',
						boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
						backgroundColor: '#FFFFFF',
					},
				}}
			>
				<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>
					Подтверждение удаления типа
				</DialogTitle>
				<DialogContent>
					<Typography sx={{ color: '#1D1D1F' }}>
						Вы уверены, что хотите удалить все записи типа "
						{typeToDelete === 'article'
							? 'Статья'
							: typeToDelete === 'monograph'
								? 'Монография'
								: typeToDelete === 'conference'
									? 'Доклад/конференция'
									: 'Неизвестный тип'}
						" из плана?
					</Typography>
				</DialogContent>
				<DialogActions sx={{ p: 2 }}>
					<CancelButton onClick={handleDeleteTypeCancel}>Отмена</CancelButton>
					<AppleButton
						onClick={handleDeleteTypeConfirm}
						sx={{ backgroundColor: '#FF3B30', '&:hover': { backgroundColor: '#FF2D1A' } }}
					>
						Удалить
					</AppleButton>
				</DialogActions>
			</Dialog>

			<Dialog
				open={unlinkDialogOpen}
				onClose={() => setUnlinkDialogOpen(false)}
				sx={{ '& .MuiDialog-paper': { borderRadius: '16px', p: 2, minWidth: '500px' } }}
			>
				<DialogTitle>Отвязать публикацию</DialogTitle>
				<DialogContent>
					<Table>
						<TableHead>
							<TableRow>
								<TableCell>Название</TableCell>
								<TableCell>Авторы</TableCell>
								<TableCell>Действия</TableCell>
							</TableRow>
						</TableHead>
						<TableBody>
							{selectedGroup?.entries.filter((entry) => entry.publication_id).length > 0 ? (
								selectedGroup.entries
									.filter((entry) => entry.publication_id)
									.map((entry) => {
										const publication = publishedPublications.find((pub) => pub.id === entry.publication_id);
										return publication ? (
											<TableRow key={entry.id}>
												<TableCell>{publication.title}</TableCell>
												<TableCell>{publication && publication.authors && publication.authors.length > 0
													? publication.authors.map(author => author.name).join(', ')
													: 'Нет авторов'}</TableCell>
												<TableCell>
													<RedCancelButton
														onClick={() => handleUnlinkPublication(selectedGroup.planId, entry.id)}
													>
														Отвязать
													</RedCancelButton>
												</TableCell>
											</TableRow>
										) : null;
									})
							) : (
								<TableRow>
									<TableCell colSpan={3} sx={{ textAlign: 'center', color: '#6E6E73' }}>
										Нет привязанных публикаций для отвязки.
									</TableCell>
								</TableRow>
							)}
						</TableBody>
					</Table>

				</DialogContent>
				<DialogActions>
					<CancelButton onClick={() => setUnlinkDialogOpen(false)}>Закрыть</CancelButton>
				</DialogActions>
			</Dialog>


			<Dialog
				open={openHintsDialog}
				onClose={() => setOpenHintsDialog(false)}
				fullWidth
				maxWidth="md" // Можно сделать sm или md
				PaperProps={{ sx: { borderRadius: '16px', p: 2 } }}
			>
				<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600 }}>
					Подсказки по заполнению полей
				</DialogTitle>
				<DialogContent dividers> {/* dividers добавляет линии */}
					{loadingHints ? (
						<Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><CircularProgress /></Box>
					) : Object.keys(publicationHints).length > 0 ? (
						<Box sx={{ display: 'flex', flexDirection: 'column', gap: 2.5 }}>
							{hintableFieldsForDisplay.map(({ field, label }) => {
								const hintText = publicationHints[field];
								// Показываем поле, только если для него есть подсказка
								return hintText ? (
									<div key={field}>
										<Typography variant="h6" sx={{ fontWeight: 500, color: '#1D1D1F', mb: 0.5 }}>
											{label}
										</Typography>
										<Typography variant="body2" sx={{ color: '#6E6E73', whiteSpace: 'pre-wrap' }}> {/* whiteSpace для сохранения переносов строк */}
											{hintText}
										</Typography>
									</div>
								) : null; // Не рендерим, если подсказки нет
							})}
						</Box>
					) : (
						<Typography sx={{ color: '#6E6E73', textAlign: 'center', p: 3 }}>
							Подсказки для полей не найдены.
						</Typography>
					)}
				</DialogContent>
				<DialogActions sx={{ p: 2 }}>
					<AppleButton onClick={() => setOpenHintsDialog(false)}>
						Закрыть
					</AppleButton>
				</DialogActions>
			</Dialog>

			<Dialog
				open={openCreatePlanDialog}
				onClose={() => setOpenCreatePlanDialog(false)}
				sx={{ '& .MuiDialog-paper': { borderRadius: '16px', p: 2 } }}
			>
				<DialogTitle>Создать новый план</DialogTitle>
				<DialogContent>
					<AppleTextField
						label="Год"
						type="number"
						value={newPlan.year}
						onChange={(e) => setNewPlan({ ...newPlan, year: parseInt(e.target.value) || '' })}
						fullWidth
						margin="normal"
						variant="outlined"
					/>
					{/* Уведомления внутри диалога */}

				</DialogContent>
				<DialogActions>
					<CancelButton onClick={() => setOpenCreatePlanDialog(false)}>Отмена</CancelButton>
					<AppleButton onClick={handleCreatePlan}>
						Создать
					</AppleButton>
				</DialogActions>
			</Dialog>
			<Dialog
				open={linkDialogOpen}
				onClose={() => setLinkDialogOpen(false)}
				sx={{ '& .MuiDialog-paper': { borderRadius: '16px', p: 2, minWidth: '500px' } }}
			>
				<DialogTitle>Привязать публикацию</DialogTitle>
				<DialogContent>
					<AppleTextField
						fullWidth
						label="Поиск публикации"
						value={linkSearchQuery}
						onChange={(e) => handleLinkSearch(e.target.value)}
						margin="normal"
						variant="outlined"
					/>
					<Table>
						<TableHead>
							<TableRow>
								<TableCell>Название</TableCell>
								<TableCell>Авторы</TableCell>
								<TableCell>Действия</TableCell>
							</TableRow>
						</TableHead>
						<TableBody>
							{filteredPublishedPublications.length > 0 ? (
								filteredPublishedPublications.map((pub) => (
									<TableRow key={pub.id}>
										<TableCell>{pub.title}</TableCell>
										<TableCell>{pub.authors && pub.authors.length > 0
											? pub.authors.map(author => author.name).join(', ')
											: 'Нет авторов'}</TableCell>
										<TableCell>
											<AppleButton
												onClick={() => handleLinkPublication(selectedPlanEntry.planId, selectedPlanEntry, pub.id)}
											>
												Привязать
											</AppleButton>
										</TableCell>
									</TableRow>
								))
							) : (
								<TableRow>
									<TableCell colSpan={3} sx={{ textAlign: 'center', color: '#6E6E73' }}>
										Нет доступных публикаций для привязки.
									</TableCell>
								</TableRow>
							)}
						</TableBody>
					</Table>

				</DialogContent>
				<DialogActions>
					<CancelButton onClick={() => setLinkDialogOpen(false)}>Закрыть</CancelButton>
				</DialogActions>
			</Dialog>
			{/* Глобальные Уведомления (как в ManagerDashboard) */}
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
							// Позиционирование относительно верхнего края или другого уведомления
							top: openSuccess ? 76 : 16, // Если есть success-уведомление, сдвигаем ниже
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
		</Container >
	);
}

export default Dashboard;