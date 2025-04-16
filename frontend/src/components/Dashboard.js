import React, { useState, useEffect, useMemo, useRef } from 'react';
import { Line } from 'react-chartjs-2';
import { Snackbar, Slide } from '@mui/material';
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
import Visibility from '@mui/icons-material/Visibility';
import VisibilityOff from '@mui/icons-material/VisibilityOff';
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
	const [planToDelete, setPlanToDelete] = useState(null); // Новое состояние для плана
	const [openEditDialog, setOpenEditDialog] = useState(false);
	const [editPublication, setEditPublication] = useState(null);
	const [editTitle, setEditTitle] = useState('');
	const [editAuthors, setEditAuthors] = useState('');
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
	const [attachError, setAttachError] = useState('');
	const [attachSuccess, setAttachSuccess] = useState('');
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
	const [createPlanError, setCreatePlanError] = useState('');
	const [createPlanSuccess, setCreatePlanSuccess] = useState('');
	const [planDialogError, setPlanDialogError] = useState('');
	const [planDialogSuccess, setPlanDialogSuccess] = useState('');
	const [openPlanSnackbar, setOpenPlanSnackbar] = useState(false); // Управление видимостью Snackbar
	const [loadingPublicationTypes, setLoadingPublicationTypes] = useState(true); // Новое состояние для типов
	const [initializing, setInitializing] = useState(true);
	const validStatuses = ['all', 'draft', 'needs_review', 'published'];
	const [isTableLoading, setIsTableLoading] = useState(false);
	// Добавляем состояния для управления диалогом удаления типа
	const [openDeleteTypeDialog, setOpenDeleteTypeDialog] = useState(false);
	const [typeToDelete, setTypeToDelete] = useState(null);
	const [planIdForTypeDelete, setPlanIdForTypeDelete] = useState(null);

	const [selectedDisplayNameId, setSelectedDisplayNameId] = useState('');
	const [editSelectedDisplayNameId, setEditSelectedDisplayNameId] = useState('');

	// Временное состояние для редактируемого плана
	const [tempPlan, setTempPlan] = useState(null);

	// Состояние для управления раскрытием аккордеонов
	const [expandedPlanId, setExpandedPlanId] = useState(null);
	const [publicationTypes, setPublicationTypes] = useState([]);
	const validPublicationTypes = ['article', 'monograph', 'conference'];
	const validPlanStatuses = ['planned', 'in_progress', 'completed'];

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

	const handleClosePlanSnackbar = () => {
		setOpenPlanSnackbar(false);
		setPlanDialogError('');
		setPlanDialogSuccess('');
		if (planDialogSuccess) {
			setOpenCreatePlanDialog(false); // Закрываем диалог только после успеха
		}
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
		setIsTableLoading(true);
		try {
			const pubResponse = await axios.get('http://localhost:5000/api/publications', {
				withCredentials: true,
				params: {
					page,
					per_page: publicationsPerPage,
					search: search || undefined,
					display_name_id: displayNameId || undefined,
					status: validStatuses.includes(status) ? status : 'all',
				},
			});

			setPublications(pubResponse.data.publications || []);
			setFilteredPublications(pubResponse.data.publications || []);
			setCurrentPage(page);
			const total = pubResponse.data.total || 0;
			const calculatedTotalPages = Math.ceil(total / publicationsPerPage);
			setTotalPages(calculatedTotalPages);

			if (page > calculatedTotalPages && calculatedTotalPages > 0) {
				setCurrentPage(1);
				fetchData(1, search, displayNameId, status);
				return;
			}

			// Загружаем оба набора публикаций
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
			setIsTableLoading(false);
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
			const response = await axios.get('http://localhost:5000/api/plans', {
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
	const handlePlanEntryCountChange = (planId, type, count) => {
		setTempPlan((prevTempPlan) => {
			if (prevTempPlan.id !== planId) return prevTempPlan;
			const updatedGroupedEntries = prevTempPlan.groupedEntries.map((group) => {
				if (group.type === type) {
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
	const handleDeletePlanEntryByType = (planId, type) => {
		setPlanIdForTypeDelete(planId);
		setTypeToDelete(type);
		setOpenDeleteTypeDialog(true);
	};

	const handleDeleteTypeConfirm = () => {
		if (!planIdForTypeDelete || !typeToDelete) return;

		setTempPlan((prevTempPlan) => {
			if (prevTempPlan.id !== planIdForTypeDelete) return prevTempPlan;
			const updatedGroupedEntries = prevTempPlan.groupedEntries.map((group) => {
				if (group.type === typeToDelete) {
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

	const handleRestoreType = (planId, type) => {
		setTempPlan((prevTempPlan) => {
			if (prevTempPlan.id !== planId) return prevTempPlan;
			const updatedGroupedEntries = prevTempPlan.groupedEntries.map((group) => {
				if (group.type === type) {
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
		if (!title.trim() || !authors.trim() || !year || !selectedDisplayNameId) {
			setError('Пожалуйста, заполните все обязательные поля (название, авторы, год, тип).');
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
		formData.append('authors', authors.trim());
		formData.append('year', parseInt(year, 10));
		formData.append('type_id', selectedType.id); // Передаём type_id
		formData.append('display_name_id', selectedDisplayNameId); // Передаём display_name_id

		try {
			await refreshCsrfToken();
			console.log('Uploading file with data:', {
				title,
				authors,
				year,
				type_id: selectedType.id,
				display_name_id: selectedDisplayNameId
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
			setAuthors('');
			setYear('');
			setSelectedDisplayNameId(''); // Сбрасываем выбор
			setFile(null);
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
		setEditPublication(publication || {});
		setEditTitle(publication?.title || '');
		setEditAuthors(publication?.authors || '');
		setEditYear(publication?.year || '');
		setEditSelectedDisplayNameId(publication?.type?.display_name_id || '');
		setEditFile(null);
		setOpenEditDialog(true);
	};
	const handleEditSubmit = async (e) => {
		e.preventDefault();
		if (!editPublication) {
			setError('Публикация для редактирования не выбрана.');
			setOpenError(true);
			return;
		}
		if (!editTitle.trim() || !editAuthors.trim() || !editYear || !editSelectedDisplayNameId) {
			setError('Название, авторы, год и тип обязательны для заполнения.');
			setOpenError(true);
			return;
		}

		const selectedType = publicationTypes.find(t => t.display_name_id === editSelectedDisplayNameId);
		if (!selectedType) {
			setError('Пожалуйста, выберите корректный тип публикации.');
			setOpenError(true);
			return;
		}

		let data;
		let headers = { 'X-CSRFToken': csrfToken };

		if (editFile) {
			data = new FormData();
			data.append('file', editFile);
			data.append('title', editTitle.trim());
			data.append('authors', editAuthors.trim());
			data.append('year', parseInt(editYear, 10));
			data.append('type_id', selectedType.id);
			data.append('display_name_id', editSelectedDisplayNameId);
			data.append('status', 'draft');
		} else {
			data = {
				title: editTitle.trim(),
				authors: editAuthors.trim(),
				year: parseInt(editYear, 10),
				type_id: selectedType.id,
				display_name_id: editSelectedDisplayNameId,
				status: 'draft',
			};
			headers['Content-Type'] = 'application/json';
		}

		try {
			await refreshCsrfToken();
			console.log('Updating publication with:', {
				title: editTitle,
				authors: editAuthors,
				year: editYear,
				type_id: selectedType.id,
				display_name_id: editSelectedDisplayNameId,
				status: 'draft',
				file: editFile ? editFile.name : 'No new file',
			});
			const response = await axios.put(
				`http://localhost:5000/api/publications/${editPublication.id}`,
				data,
				{
					withCredentials: true,
					headers,
				}
			);
			setSuccess('Публикация успешно отредактирована!');
			setOpenSuccess(true);
			setError('');
			await fetchData();
			setOpenEditDialog(false);
		} catch (err) {
			console.error('Ошибка редактирования публикации:', err.response?.data || err);
			if (err.response) {
				setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте введенные поля.'}`);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			setOpenError(true);
			setSuccess('');
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

	const handleSaveAndSubmitForReview = async (e) => {
		e.preventDefault();
		await handleEditSubmit(e);
		if (!error) {
			await handleSubmitForReview(editPublication.id);
			setOpenEditDialog(false);
		}
	};

	const handleEditCancel = () => {
		setOpenEditDialog(false);
		setEditPublication(null);
		setEditTitle('');
		setEditAuthors('');
		setEditYear('');
		setEditType(publicationTypes.length > 0 ? publicationTypes[0].name : '');
		setEditFile(null);
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
			setSuccess('Публикация успешно удалена!');
			setOpenSuccess(true);
			setError('');
			await fetchData();
		} catch (err) {
			console.error('Ошибка удаления публикации:', err.response?.data || err);
			if (err.response) {
				setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте права доступа.'}`);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
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
		setAttachError('');
		setAttachSuccess('');
	};

	const handleAttachFileSubmit = async (e) => {
		e.preventDefault();
		if (!attachFile) {
			setAttachError('Пожалуйста, выберите файл для прикрепления.');
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
					withCredentials: true,
					headers: {
						'Content-Type': 'multipart/form-data',
						'X-CSRFToken': csrfToken,
					},
				}
			);
			setAttachSuccess('Файл успешно прикреплен!');
			setAttachError('');
			await fetchData();
			setOpenAttachFileDialog(false);
		} catch (err) {
			console.error('Ошибка прикрепления файла:', err.response?.data || err);
			if (err.response) {
				setAttachError(
					`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте файл и права доступа.'}`
				);
			} else {
				setAttachError('Ошибка сети. Проверьте подключение и сервер.');
			}
			setAttachSuccess('');
		}
	};

	const handleAttachFileCancel = () => {
		setOpenAttachFileDialog(false);
		setPublicationToAttach(null);
		setAttachFile(null);
		setAttachError('');
		setAttachSuccess('');
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

	useEffect(() => {
		if (attachError || attachSuccess) {
			const timer = setTimeout(() => {
				setAttachError('');
				setAttachSuccess('');
			}, 5000);
			return () => clearTimeout(timer);
		}
	}, [attachError, attachSuccess]);

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
			setPlanDialogError('Пожалуйста, укажите корректный год (1900–2100).');
			setOpenPlanSnackbar(true);
			return;
		}

		try {
			await refreshCsrfToken();
		} catch (err) {
			console.error('Ошибка при обновлении CSRF-токена:', err);
			setPlanDialogError('Не удалось обновить CSRF-токен. Попробуйте снова.');
			setOpenPlanSnackbar(true);
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
			setPlanDialogSuccess('План успешно создан!');
			setOpenPlanSnackbar(true);
			// Диалог не закрываем сразу, ждём закрытия Snackbar
		} catch (err) {
			console.error('Ошибка при создании плана:', err);
			const errorMessage = err.response?.data?.error || 'Произошла ошибка при создании плана.';
			setPlanDialogError(errorMessage);
			setOpenPlanSnackbar(true);
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
	const handleSavePlan = async () => {
		if (!tempPlan || !tempPlan.id) {
			console.error('tempPlan отсутствует или не имеет id');
			alert('Ошибка: План не выбран или недействителен.');
			return;
		}

		try {
			const entriesToSave = tempPlan.groupedEntries
				.filter(group => !group.isDeleted)
				.flatMap(group => {
					if (!group || !group.entries) {
						console.warn('Группа или её entries отсутствуют:', group);
						return [];
					}

					return group.entries
						.filter(entry => !entry.isDeleted)
						.map(entry => {
							if (!entry) {
								console.warn('Запись отсутствует:', entry);
								return null;
							}

							return {
								id: entry.id || null,
								title: entry.title || '',
								type_id: entry.type?.id || entry.type_id || null,
								display_name_id: entry.display_name_id || null,
								status: entry.status || 'planned',
								publication_id: entry.publication_id || null,
								isPostApproval: entry.isPostApproval || false,
							};
						})
						.filter(entry => entry !== null);
				});

			if (entriesToSave.length === 0) {
				console.warn('Нет записей для сохранения');
				alert('Ошибка: Нет активных записей для сохранения. Добавьте типы в план.');
				return;
			}

			console.log('Entries to save:', entriesToSave);

			const response = await axios.put(`/api/plans/${tempPlan.id}/entries`, {
				entries: entriesToSave,
			});

			setPlans(prevPlans =>
				prevPlans.map(plan =>
					plan.id === tempPlan.id
						? { ...plan, groupedEntries: groupEntriesByType(response.data.entries) }
						: plan
				)
			);

			setTempPlan(null);
		} catch (error) {
			console.error('Ошибка при сохранении плана:', error);
			if (error.response?.status === 404) {
				alert('Ошибка: План не найден на сервере или эндпоинт недоступен.');
			} else {
				alert('Ошибка при сохранении плана. Пожалуйста, попробуйте снова.');
			}
		}
	};
	const handleSubmitPlanForReview = async (plan) => {
		try {
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
		// Собираем все publication_id из записей всех планов, чтобы исключить уже привязанные публикации
		const linkedPublicationIds = new Set(
			plans.flatMap(plan =>
				plan.entries
					.filter(entry => entry.publication_id) // Фильтруем записи с publication_id
					.map(entry => entry.publication_id)
			)
		);

		// Фильтруем публикации:
		// 1. Оставляем только те, которые соответствуют типу записи плана (entry.type)
		// 2. Исключаем уже привязанные публикации
		const availablePublications = publishedPublications.filter(
			pub =>
				pub.type === entry.type && // Фильтрация по типу записи плана
				!linkedPublicationIds.has(pub.id) // Исключаем уже привязанные
		);

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
					pub.type === entryGroup.type &&
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
												{/* Добавляем уведомление об успехе или ошибке внизу карточки */}
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
									<AppleCard sx={{ mb: 4, p: 3, backgroundColor: '#F5F5F7', borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
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
													label="Название"
													value={title}
													onChange={(e) => setTitle(e.target.value)}
													margin="normal"
													variant="outlined"
												/>
												<AppleTextField
													fullWidth
													label="Авторы"
													value={authors}
													onChange={(e) => setAuthors(e.target.value)}
													margin="normal"
													variant="outlined"
												/>
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
												<Collapse in={openError}>
													{error && (
														<Alert
															severity="error"
															sx={{
																mb: 2,
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
																mb: 2,
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
										<TableBody>
											{isTableLoading ? (
												<TableRow>
													<TableCell colSpan={7} sx={{ textAlign: 'center', color: '#6E6E73' }}>
														Загрузка...
													</TableCell>
												</TableRow>
											) : currentPublications.length > 0 ? (
												currentPublications.map((pub) => (
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
															<Box sx={{ display: 'flex', justifyContent: 'center', gap: 1 }}>
																{(pub.status === 'draft' || pub.status === 'returned_for_revision') && (
																	<>
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
																		<IconButton
																			aria-label="delete"
																			onClick={() => handleDeleteClick(pub)}
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
																				aria-label="submit-for-review"
																				onClick={() => handleSubmitForReview(pub.id)}
																				sx={{
																					color: 'green',
																					borderRadius: '8px',
																					'&:hover': {
																						color: '#FFFFFF',
																						backgroundColor: 'green',
																						boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
																					},
																				}}
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
																{!pub.file_url && (pub.status === 'draft' || pub.status === 'returned_for_revision') && (
																	<IconButton
																		aria-label="attach"
																		onClick={() => handleAttachFileClick(pub)}
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
																		<AttachFileIcon />
																	</IconButton>
																)}
															</Box>
														</TableCell>
													</TableRow>
												))
											) : (
												<TableRow>
													<TableCell colSpan={7} sx={{ textAlign: 'center', color: '#6E6E73' }}>
														Нет доступных публикаций на этой странице.
													</TableCell>
												</TableRow>
											)}
										</TableBody>
									</AppleTable>
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
																	<IconButton
																		onClick={(e) => {
																			e.stopPropagation();
																			handleEditPlanClick(plan.id);
																		}}
																		sx={{ color: '#0071E3' }}
																	>
																		<EditIcon />
																	</IconButton>
																	<IconButton
																		onClick={(e) => {
																			e.stopPropagation();
																			handleDeletePlanClick(plan);
																		}}
																		sx={{ color: '#FF3B30' }}
																	>
																		<DeleteIcon />
																	</IconButton>
																	<IconButton
																		onClick={(e) => {
																			e.stopPropagation();
																			handleSubmitPlanForReview(plan);
																		}}
																		sx={{ color: '#0071E3' }}
																		disabled={!areAllTitlesFilled(plan)}
																		title={areAllTitlesFilled(plan) ? 'Отправить на проверку' : 'Заполните все заголовки'}
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
																							onChange={(e) => handlePlanEntryCountChange(plan.id, group.type, parseInt(e.target.value) || 1)}
																							fullWidth
																							variant="outlined"
																							disabled={group.isDeleted}
																						/>
																					</TableCell>
																					<TableCell>
																						{group.isDeleted ? (
																							<IconButton
																								onClick={() => handleRestoreType(plan.id, group.type)}
																								sx={{ color: '#34C759' }}
																								title="Восстановить тип"
																								disabled={plan.status === 'pending'}
																							>
																								<AddIcon />
																							</IconButton>
																						) : (
																							<IconButton
																								onClick={() => handleDeletePlanEntryByType(plan.id, group.type)}
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
															{plan.status === 'approved' && groupedEntries.length !== 0 && (
																<AppleButton
																	startIcon={<AddIcon />}
																	onClick={() => handleEditPlanClick(plan.id)}
																	sx={{ mt: 2 }}
																>
																	Добавить тип
																</AppleButton>
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

			<Snackbar
				open={openPlanSnackbar}
				autoHideDuration={2500}
				onClose={handleClosePlanSnackbar}
				anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
				TransitionComponent={TransitionDown}
			>
				<Alert
					severity={planDialogError ? 'error' : 'success'}
					sx={{
						borderRadius: '12px',
						backgroundColor: planDialogError ? '#FFF1F0' : '#E7F8E7',
						color: '#1D1D1F',
						boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
						minWidth: '300px',
					}}
					onClose={handleClosePlanSnackbar}
				>
					{planDialogError || planDialogSuccess}
				</Alert>
			</Snackbar>
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
						<Collapse in={attachError !== ''}>
							<Alert
								severity="error"
								sx={{
									mt: 2,
									borderRadius: '12px',
									backgroundColor: '#FFF1F0',
									color: '#1D1D1F',
									boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
								}}
							>
								{attachError}
							</Alert>
						</Collapse>
						<Collapse in={attachSuccess !== ''}>
							<Alert
								severity="success"
								sx={{
									mt: 2,
									borderRadius: '12px',
									backgroundColor: '#E7F8E7',
									color: '#1D1D1F',
									boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
								}}
							>
								{attachSuccess}
							</Alert>
						</Collapse>
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
												<TableCell>{publication.authors}</TableCell>
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
				</DialogContent>
				<DialogActions>
					<CancelButton onClick={() => setUnlinkDialogOpen(false)}>Закрыть</CancelButton>
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
					<Collapse in={!!createPlanSuccess}>
						{createPlanSuccess && (
							<Alert
								severity="success"
								sx={{
									mt: 2,
									borderRadius: '12px',
									backgroundColor: '#E7F8E7',
									color: '#1D1D1F',
									boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
								}}
							>
								{createPlanSuccess}
							</Alert>
						)}
					</Collapse>
					<Collapse in={!!createPlanError}>
						{createPlanError && (
							<Alert
								severity="error"
								sx={{
									mt: 2,
									borderRadius: '12px',
									backgroundColor: '#FFF1F0',
									color: '#1D1D1F',
									boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
								}}
								onClose={() => setCreatePlanError('')} // Позволяет закрыть ошибку вручную
							>
								{createPlanError}
							</Alert>
						)}
					</Collapse>
				</DialogContent>
				<DialogActions>
					<CancelButton onClick={() => setOpenCreatePlanDialog(false)}>Отмена</CancelButton>
					<AppleButton onClick={handleCreatePlan} disabled={!!createPlanSuccess}>
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
										<TableCell>{pub.authors}</TableCell>
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
				</DialogContent>
				<DialogActions>
					<CancelButton onClick={() => setLinkDialogOpen(false)}>Закрыть</CancelButton>
				</DialogActions>
			</Dialog>
		</Container>
	);
}

export default Dashboard;