import React, { useState, useEffect, useMemo, useRef, useCallback } from 'react';
import { Line } from 'react-chartjs-2';
import { Snackbar, Slide, Tooltip as MuiTooltip } from '@mui/material';
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, BarElement, Title, Tooltip, Legend, Filler } from 'chart.js';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns'; // Или AdapterDayjs
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { format } from 'date-fns'; // Или из dayjs
import ClearIcon from '@mui/icons-material/Clear'; // Для кнопки очистки дат
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
	const [newIsVak, setNewIsVak] = useState(false);
	const [newIsWoS, setNewIsWoS] = useState(false);
	const [newIsScopus, setNewIsScopus] = useState(false);
	// Добавляем новые состояния для булевых флагов VAK/WoS/Scopus (редактирование)
	const [editIsVak, setEditIsVak] = useState(false);
	const [editIsWoS, setEditIsWoS] = useState(false);
	const [editIsScopus, setEditIsScopus] = useState(false);

	// Добавляем состояния для управления блокировкой флагов в UI (создание)
	const [disableNewVak, setDisableNewVak] = useState(false);
	const [disableNewWoS, setDisableNewWoS] = useState(false);
	const [disableNewScopus, setDisableNewScopus] = useState(false);
	// Добавляем состояния для управления блокировкой флагов в UI (редактирование)
	const [disableEditVak, setDisableEditVak] = useState(false);
	const [disableEditWoS, setDisableEditWoS] = useState(false);
	const [disableEditScopus, setDisableEditScopus] = useState(false);
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
	const [submitAttempted, setSubmitAttempted] = useState(false); // Флаг попытки отправки
	const [titleMandatoryError, setTitleMandatoryError] = useState(false);
	const [yearMandatoryError, setYearMandatoryError] = useState(false);
	const [authorMandatoryError, setAuthorMandatoryError] = useState(false); // Ошибка для *блока* авторов
	const [typeMandatoryError, setTypeMandatoryError] = useState(false);
	const [fileMandatoryError, setFileMandatoryError] = useState(false)
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
	const [exportStartDate, setExportStartDate] = useState(null); // Дата начала экспорта
	const [exportEndDate, setExportEndDate] = useState(null); // Дата конца экспорта
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
	const [titleError, setTitleError] = useState('');
	const [yearError, setYearError] = useState('');
	const [journalConferenceNameError, setJournalConferenceNameError] = useState('');
	const [doiError, setDoiError] = useState('');
	const [issnError, setIssnError] = useState('');
	const [isbnError, setIsbnError] = useState('');
	const [volumeError, setVolumeError] = useState('');
	const [numberError, setNumberError] = useState('');
	const [pagesError, setPagesError] = useState('');
	const [publisherError, setPublisherError] = useState('');
	const [publisherLocationError, setPublisherLocationError] = useState('');
	const [printedSheetsVolumeError, setPrintedSheetsVolumeError] = useState('');
	const [circulationError, setCirculationError] = useState('');
	const [departmentError, setDepartmentError] = useState('');
	const [classificationCodeError, setClassificationCodeError] = useState('');
	const [quartileError, setQuartileError] = useState('');
	// Состояние ошибки файла (для проверки типа при выборе)
	const [fileError, setFileError] = useState('');
	// Ошибки формы редактирования
	const [editTitleError, setEditTitleError] = useState('');
	const [editYearError, setEditYearError] = useState('');
	const [editJournalConferenceNameError, setEditJournalConferenceNameError] = useState('');
	const [editDoiError, setEditDoiError] = useState('');
	const [editIssnError, setEditIssnError] = useState('');
	const [editIsbnError, setEditIsbnError] = useState('');
	const [editVolumeError, setEditVolumeError] = useState('');
	const [editNumberError, setEditNumberError] = useState('');
	const [editPagesError, setEditPagesError] = useState('');
	const [editPublisherError, setEditPublisherError] = useState('');
	const [editPublisherLocationError, setEditPublisherLocationError] = useState('');
	const [editPrintedSheetsVolumeError, setEditPrintedSheetsVolumeError] = useState('');
	const [editCirculationError, setEditCirculationError] = useState('');
	const [editDepartmentError, setEditDepartmentError] = useState('');
	const [editClassificationCodeError, setEditClassificationCodeError] = useState('');
	const [editQuartileError, setEditQuartileError] = useState('');
	const [editFileError, setEditFileError] = useState('');


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

	const resetFlagsAndDisables = useCallback(() => {
		console.log('Calling resetFlagsAndDisables');
		setEditIsVak(false);
		setEditIsWoS(false);
		setEditIsScopus(false);
		setDisableEditVak(false);
		setDisableEditWoS(false);
		setDisableEditScopus(false);
	}, []);
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

	const handleExportExcel = async () => {
		// --- НОВОЕ: Формирование параметров ---
		const params = {};
		if (exportStartDate) {
			try {
				params.start_date = format(exportStartDate, 'yyyy-MM-dd');
			} catch (e) { console.error("Invalid start date format", exportStartDate) }
		}
		if (exportEndDate) {
			try {
				// Добавляем день, чтобы включить весь конечный день, т.к. бэкэнд использует '<'
				// Не нужно, бэкэнд теперь сам добавляет день
				params.end_date = format(exportEndDate, 'yyyy-MM-dd');
			} catch (e) { console.error("Invalid end date format", exportEndDate) }
		}
		console.log("Exporting Excel with params:", params); // Отладка
		// --- КОНЕЦ НОВОГО ---

		try {
			const response = await axios.get('http://localhost:5000/api/publications/export-excel', {
				withCredentials: true,
				responseType: 'blob',
				params: params, // <--- ПЕРЕДАЕМ ПАРАМЕТРЫ
			});

			const contentDisposition = response.headers['content-disposition'];
			let filename = 'publications_report.xlsx';
			if (contentDisposition) {
				const filenameMatch = contentDisposition.match(/filename="?(.+)"?/i);
				if (filenameMatch && filenameMatch.length === 2) {
					filename = filenameMatch[1];
				}
			}

			const url = window.URL.createObjectURL(new Blob([response.data]));
			const link = document.createElement('a');
			link.href = url;
			link.setAttribute('download', filename);
			document.body.appendChild(link);
			link.click();

			link.parentNode.removeChild(link);
			window.URL.revokeObjectURL(url);

			setSuccess('Отчет Excel успешно скачан!');
			setOpenSuccess(true);

		} catch (err) {
			console.error('Ошибка скачивания Excel отчета:', err.response?.data || err.message);
			let errorMsg = 'Не удалось скачать отчет Excel.';
			if (err.response && err.response.data instanceof Blob && err.response.data.type === "application/json") {
				try {
					const errorJson = JSON.parse(await err.response.data.text());
					errorMsg = errorJson.error || errorMsg;
				} catch (parseError) { /*...*/ }
			} else if (err.response?.data?.error) {
				errorMsg = err.response.data.error;
			}
			setError(errorMsg);
			setOpenError(true);
		}
	};

	const handleExportDocx = async () => {
		// Формирование параметров (такое же, как для Excel)
		const params = {};
		if (exportStartDate) {
			try {
				params.start_date = format(exportStartDate, 'yyyy-MM-dd');
			} catch (e) { console.error("Invalid start date format for DOCX", exportStartDate) }
		}
		if (exportEndDate) {
			try {
				params.end_date = format(exportEndDate, 'yyyy-MM-dd');
			} catch (e) { console.error("Invalid end date format for DOCX", exportEndDate) }
		}
		console.log("Exporting DOCX with params:", params);

		try {
			// Обновляем CSRF на всякий случай
			// await refreshCsrfToken(); // Если GET требует CSRF

			// Вызов НОВОГО эндпоинта
			const response = await axios.get('http://localhost:5000/api/publications/export-docx', {
				withCredentials: true,
				responseType: 'blob', // Ожидаем файл
				params: params,       // Передаем даты
				// headers: { 'X-CSRFToken': csrfToken } // Если нужен CSRF
			});

			// Обработка ответа и скачивание файла (аналогично Excel)
			const contentDisposition = response.headers['content-disposition'];
			let filename = 'publications_report.docx'; // Имя по умолчанию
			if (contentDisposition) {
				const filenameMatch = contentDisposition.match(/filename="?(.+)"?/i);
				if (filenameMatch && filenameMatch.length === 2) {
					filename = filenameMatch[1];
				}
			}

			const url = window.URL.createObjectURL(new Blob([response.data]));
			const link = document.createElement('a');
			link.href = url;
			link.setAttribute('download', filename);
			document.body.appendChild(link);
			link.click();

			link.parentNode.removeChild(link);
			window.URL.revokeObjectURL(url);

			setSuccess('Отчет DOCX успешно скачан!');
			setOpenSuccess(true);

		} catch (err) {
			console.error('Ошибка скачивания DOCX отчета:', err.response?.data || err.message);
			let errorMsg = 'Не удалось скачать отчет DOCX.';
			// Обработка ошибок (аналогично Excel)
			if (err.response && err.response.data instanceof Blob && err.response.data.type === "application/json") {
				try {
					const errorJson = JSON.parse(await err.response.data.text());
					errorMsg = errorJson.error || errorMsg;
				} catch (parseError) { /*...*/ }
			} else if (err.response?.data?.error) {
				errorMsg = err.response.data.error;
			} else if (err.response?.data && typeof err.response.data === 'string') { // Строка ошибки
				errorMsg = err.response.data;
			}
			setError(errorMsg);
			setOpenError(true);
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
		const updatedAuthors = newAuthors.map((author, i) => {
			if (i === index) {
				const newAuthorData = { ...author, [field]: value };
				// Валидируем имя автора при изменении поля 'name'
				if (field === 'name') {
					newAuthorData.error = validateField('authorName', value); // Обновляем ошибку в объекте
				}
				return newAuthorData;
			}
			return author;
		});
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


	const resetCreateForm = () => {
		setTitle(''); setYear(''); setSelectedDisplayNameId(''); setFile(null);
		setNewAuthors([{ id: Date.now(), name: '', is_employee: false, error: '' }]);
		// ... сброс всех остальных полей ...
		setJournalConferenceName(''); setDoi(''); setIssn(''); setIsbn(''); setQuartile('');
		setVolume(''); setNumber(''); setPages(''); setDepartment(''); setPublisher('');
		setPublisherLocation(''); setPrintedSheetsVolume(''); setCirculation('');
		setClassificationCode(''); setNotes('');
		setNewIsVak(false); setNewIsWoS(false); setNewIsScopus(false);
		setDisableNewVak(false); setDisableNewWoS(false); setDisableNewScopus(false);
		// Сброс ВСЕХ ошибок
		setTitleError(''); setYearError(''); setJournalConferenceNameError('');
		setDoiError(''); setIssnError(''); setIsbnError(''); setVolumeError('');
		setNumberError(''); setPagesError(''); setPublisherError('');
		setPublisherLocationError(''); setPrintedSheetsVolumeError(''); setCirculationError('');
		setDepartmentError(''); setClassificationCodeError(''); setFileError('');
		setQuartileError('');
		setTitleMandatoryError(false); setYearMandatoryError(false);
		setAuthorMandatoryError(false); setTypeMandatoryError(false); setFileMandatoryError(false);
		setSubmitAttempted(false); // <--- Важно
	};



	const handleFileUpload = async (e) => {
		e.preventDefault();
		setSubmitAttempted(true); // <--- УСТАНАВЛИВАЕМ ФЛАГ ПРИ ПОПЫТКЕ ОТПРАВКИ

		// ---> НАЧАЛО ЗАМЕНЫ/ДОБАВЛЕНИЯ: Новая проверка перед отправкой <---
		let hasFormatErrors = false; // Отдельно для ошибок формата
		let hasMandatoryErrors = false; // Отдельно для ошибок обязательности

		// Сбрасываем предыдущие ошибки обязательности перед новой проверкой
		setTitleMandatoryError(false);
		setYearMandatoryError(false);
		setAuthorMandatoryError(false);
		setTypeMandatoryError(false);
		setFileMandatoryError(false);


		const fieldsToValidate = [ // Список полей для проверки ФОРМАТА
			// --- Исключаем базовые обязательные поля отсюда, проверим их ниже ---
			// { name: 'title', value: title, setError: setTitleError },
			// { name: 'year', value: year, setError: setYearError },
			// { name: 'file', value: file, setError: setFileError } // Файл тоже проверим ниже
			// --- Поля для проверки формата ---
			{ name: 'journalConferenceName', value: journalConferenceName, setError: setJournalConferenceNameError },
			{ name: 'doi', value: doi, setError: setDoiError },
			{ name: 'issn', value: issn, setError: setIssnError },
			{ name: 'isbn', value: isbn, setError: setIsbnError },
			{ name: 'volume', value: volume, setError: setVolumeError },
			{ name: 'number', value: number, setError: setNumberError },
			{ name: 'pages', value: pages, setError: setPagesError },
			{ name: 'publisher', value: publisher, setError: setPublisherError },
			{ name: 'publisherLocation', value: publisherLocation, setError: setPublisherLocationError },
			{ name: 'printedSheetsVolume', value: printedSheetsVolume, setError: setPrintedSheetsVolumeError },
			{ name: 'circulation', value: circulation, setError: setCirculationError },
			{ name: 'quartile', value: quartile, setError: setQuartileError }, // <--- ДОБАВЬТЕ ЭТО
			{ name: 'department', value: department, setError: setDepartmentError }, // <-- УЖЕ ДОЛЖНО БЫТЬ
			{ name: 'classificationCode', value: classificationCode, setError: setClassificationCodeError },
		];

		// 1. Прогоняем валидацию ФОРМАТА
		fieldsToValidate.forEach(field => {
			const currentError = validateField(field.name, field.value); // Только проверка формата
			field.setError(currentError); // Устанавливаем или сбрасываем ошибку формата
			if (currentError) {
				hasFormatErrors = true; // Фиксируем наличие хотя бы одной ошибки формата
			}
		});

		// 2. Проверяем формат авторов (если они есть)
		const validAuthors = newAuthors.filter(a => a.name.trim()); // Авторы с именем
		newAuthors.forEach((author, index) => {
			const authorFormatError = validateField('authorName', author.name);
			if (authorFormatError) {
				handleAuthorChange(index, 'error', authorFormatError); // Устанавливаем ошибку формата
				hasFormatErrors = true;
			} else if (author.error) {
				handleAuthorChange(index, 'error', ''); // Сбрасываем старую ошибку формата
			}
		});

		// 3. Проверяем ОБЯЗАТЕЛЬНЫЕ поля и устанавливаем ошибки обязательности
		if (!title.trim()) { setTitleMandatoryError(true); hasMandatoryErrors = true; }
		if (!year.trim()) { setYearMandatoryError(true); hasMandatoryErrors = true; }
		if (!selectedDisplayNameId) { setTypeMandatoryError(true); hasMandatoryErrors = true; }
		if (!file) { setFileMandatoryError(true); hasMandatoryErrors = true; }
		if (validAuthors.length === 0) { // Проверяем, что есть хотя бы один автор с именем
			setAuthorMandatoryError(true);
			hasMandatoryErrors = true;
		} else {
			setAuthorMandatoryError(false); // Сбрасываем, если хотя бы один автор есть
		}

		if (hasMandatoryErrors || hasFormatErrors) {
			const errorMessages = [];
			if (hasMandatoryErrors) {
				errorMessages.push(<div>Не заполнены все обязательные поля (выделены красным).</div>);
			}
			if (hasFormatErrors) {
				errorMessages.push(<div>Проверьте правильность заполнения полей (появятся красные подсказки).</div>);
			}
			setError(<div>{errorMessages}</div>);
			setOpenError(true);
			return; // Прерываем отправку
		}
		// ---> КОНЕЦ ЗАМЕНЫ/ДОБАВЛЕНИЯ: Новая проверка перед отправкой <---

		const selectedType = publicationTypes.find(t => t.display_name_id === selectedDisplayNameId);
		// Эта проверка почти избыточна, но оставим для надежности


		// Готовим данные для отправки (берем только авторов с именем)
		const authorsToSend = validAuthors.map(({ id, error, ...rest }) => rest); // Убираем id и error перед отправкой

		const formData = new FormData();
		// ... остальная часть handleFileUpload (добавление в formData, try/catch) ...
		formData.append('file', file);
		formData.append('title', title.trim());
		formData.append('authors_json', JSON.stringify(authorsToSend));
		formData.append('year', parseInt(year, 10));
		formData.append('type_id', selectedType.id); // Передаём type_id
		formData.append('display_name_id', selectedDisplayNameId); // Передаём display_name_id
		formData.append('is_vak', newIsVak ? 'true' : 'false');
		formData.append('is_wos', newIsWoS ? 'true' : 'false');
		formData.append('is_scopus', newIsScopus ? 'true' : 'false');
		formData.append('journal_conference_name', journalConferenceName.trim() || ''); // Отправляем пустую строку
		formData.append('doi', doi.trim() || '');
		formData.append('issn', issn.trim() || '');
		formData.append('isbn', isbn.trim() || '');
		formData.append('quartile', quartile.trim() || '');
		formData.append('volume', volume.trim() || '');
		formData.append('number', number.trim() || '');
		formData.append('pages', pages.trim() || '');
		formData.append('department', department.trim() || '');
		formData.append('publisher', publisher.trim() || '');
		formData.append('publisher_location', publisherLocation.trim() || '');
		formData.append('printed_sheets_volume', printedSheetsVolume.trim().replace(',', '.') || ''); // Замена запятой и пустая строка
		formData.append('circulation', circulation.trim() || '');
		formData.append('classification_code', classificationCode.trim() || '');
		formData.append('notes', notes.trim() || '');

		// Очистка состояний ошибок ПОСЛЕ успешной валидации и ПЕРЕД отправкой
		setTitleError(''); setYearError(''); setJournalConferenceNameError('');
		setDoiError(''); setIssnError(''); setIsbnError(''); setVolumeError('');
		setNumberError(''); setPagesError(''); setPublisherError('');
		setPublisherLocationError(''); setPrintedSheetsVolumeError(''); setCirculationError('');
		setDepartmentError(''); setClassificationCodeError(''); setFileError('');
		setNewAuthors(prev => prev.map(a => ({ ...a, error: '' }))); // Очистка ошибок авторов

		try {
			await refreshCsrfToken();
			console.log('Uploading file with data (create):', Object.fromEntries(formData));
			const response = await axios.post('http://localhost:5000/api/publications/upload-file', formData, {
				withCredentials: true,
				headers: {
					'Content-Type': 'multipart/form-data',
					'X-CSRFToken': csrfToken,
				},
			});
			// ... остальная часть try блока ...
			setSuccess('Публикация успешно загружена!');
			setOpenSuccess(true);
			setError('');
			// ... сброс состояний значений полей ...
			setTitle('');
			setNewAuthors([{ id: Date.now(), name: '', is_employee: false, error: '' }]); // Сбрасываем с пустым error
			setYear('');
			setSelectedDisplayNameId('');
			setFile(null);
			setJournalConferenceName('');
			setDoi('');
			setIssn('');
			setIsbn('');
			setQuartile('');
			setVolume('');
			setNumber('');
			setPages('');
			setDepartment('');
			setPublisher('');
			setPublisherLocation('');
			setPrintedSheetsVolume('');
			setCirculation('');
			setClassificationCode('');
			setNotes('');
			setNewIsVak(false); setNewIsWoS(false); setNewIsScopus(false);
			setDisableNewVak(false); setDisableNewWoS(false); setDisableNewScopus(false);
			setSubmitAttempted(false);
			await fetchData(1, searchQuery, filterDisplayNameId, filterStatus); // Обновляем таблицу
		} catch (err) {
			console.error('Ошибка загрузки файла:', err.response?.data || err);
			// Отображение ошибки бэкенда, если есть
			let errorMsg = err.response?.data?.error || 'Произошла ошибка при загрузке.';
			if (typeof errorMsg !== 'string') { // На случай если бэк вернул не строку
				errorMsg = 'Произошла непредвиденная ошибка.';
			}
			setError(errorMsg.split('\n').map((item, key) => <div key={key}>{item}</div>)); // Отображаем ошибки с бэкенда если они есть
			setOpenError(true);
			setSuccess('');
		}
	};

	useEffect(() => {
		// Этот эффект должен реагировать на изменение selectedDisplayNameId (для создания)
		const handleTypeChange = (displayNameId, setStatus, setDisable) => {
			const selectedType = publicationTypes.find(t => t.display_name_id === displayNameId);

			// Сброс всех флагов и блокировок по умолчанию
			setStatus({ vak: false, wos: false, scopus: false });
			setDisable({ vak: false, wos: false, scopus: false });

			if (selectedType && (selectedType.name.toLowerCase() === 'article' || selectedType.name.toLowerCase() === 'conference')) {
				const displayName = selectedType.display_name.toLowerCase();
				const newStatuses = { vak: false, wos: false, scopus: false };
				const newDisables = { vak: false, wos: false, scopus: false };

				// Логика определения ВАК/WoS/Scopus по тексту display_name
				if ((displayName.includes('вак') || displayName.includes('ринц')) && displayName !== 'конференция ринц') {
					newStatuses.vak = true;
					newDisables.vak = true; // Блокируем отмену ВАК, если он "встроен" в тип
				}
				if (displayName.includes('wos') || displayName.includes('web of science')) {
					newStatuses.wos = true;
					newDisables.wos = true; // Блокируем отмену WoS
				}
				if (displayName.includes('scopus')) {
					newStatuses.scopus = true;
					newDisables.scopus = true; // Блокируем отмену Scopus
				}

				// Применяем вычисленные статусы и блокировки
				setStatus({ vak: newStatuses.vak, wos: newStatuses.wos, scopus: newStatuses.scopus });
				setDisable({ vak: newDisables.vak, wos: newDisables.wos, scopus: newDisables.scopus });

				// Если тип из article/conference, но его display_name не содержит ВАК/WoS/Scopus,
				// оставляем флаги false и НЕ блокируем возможность их включить вручную (блокировка false)
			}
			// Для других типов (monograph, book и т.д.) флаги остаются false и блокировки false (так как не отображаются)
		};

		if (selectedDisplayNameId) {
			handleTypeChange(
				selectedDisplayNameId,
				(statuses) => { setNewIsVak(statuses.vak); setNewIsWoS(statuses.wos); setNewIsScopus(statuses.scopus); },
				(disables) => { setDisableNewVak(disables.vak); setDisableNewWoS(disables.wos); setDisableNewScopus(disables.scopus); }
			);
		} else {
			// Сбрасываем все, если тип не выбран (например, при очистке формы)
			setNewIsVak(false);
			setNewIsWoS(false);
			setNewIsScopus(false);
			setDisableNewVak(false);
			setDisableNewWoS(false);
			setDisableNewScopus(false);
		}

	}, [selectedDisplayNameId, publicationTypes]);

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
		// Добавляем проверку и на publicationTypes
		if (!publication || !publicationTypes || publicationTypes.length === 0) {
			console.error("Cannot edit publication, data or types missing:", { publication, publicationTypes });
			setError("Не удалось загрузить данные для редактирования. Типы публикаций отсутствуют.");
			setOpenError(true);
			return;
		}

		setEditPublication(publication); // Сохраняем оригинальный объект
		setEditTitle(publication.title || '');
		setEditYear(publication.year || '');

		// Authors
		if (publication.authors && publication.authors.length > 0) {
			setEditAuthorsList(publication.authors.map((author, index) => ({
				...author,
				// Генерируем стабильный временный ID на основе данных или индекса
				id: author.id || `temp-edit-${publication.id}-${index}`
			})));
		} else {
			setEditAuthorsList([{ id: `temp-edit-${Date.now()}-0`, name: '', is_employee: false }]);
		}

		// Other fields
		setEditJournalConferenceName(publication?.journal_conference_name || '');
		setEditDoi(publication?.doi || '');
		setEditIssn(publication?.issn || '');
		setEditIsbn(publication?.isbn || '');
		setEditQuartile(publication?.quartile || '');
		setEditVolume(publication?.volume || '');
		setEditNumber(publication?.number || '');
		setEditPages(publication?.pages || '');
		setEditDepartment(publication?.department || '');
		setEditPublisher(publication?.publisher || '');
		setEditPublisherLocation(publication?.publisher_location || '');
		setEditPrintedSheetsVolume(publication?.printed_sheets_volume != null ? String(publication.printed_sheets_volume) : '');
		setEditCirculation(publication?.circulation != null ? String(publication.circulation) : '');
		setEditClassificationCode(publication?.classification_code || '');
		setEditNotes(publication?.notes || '');
		setEditFile(null);

		// --- Инициализация флагов и блокировок ---
		const currentType = publicationTypes.find(t => t.display_name_id === publication.display_name_id);

		// 1. НАЧАЛЬНОЕ состояние checked берем из ДАННЫХ публикации
		const initialIsVak = publication.is_vak || false;
		const initialIsWoS = publication.is_wos || false; // Убедитесь что поле в БД is_wos
		const initialIsScopus = publication.is_scopus || false;

		setEditIsVak(initialIsVak);
		setEditIsWoS(initialIsWoS);
		setEditIsScopus(initialIsScopus);

		// 2. НАЧАЛЬНОЕ состояние disabled определяем по ИСХОДНОМУ типу публикации
		let initialDisableVak = false;
		let initialDisableWoS = false;
		let initialDisableScopus = false;

		if (currentType && (currentType.name.toLowerCase() === 'article' || currentType.name.toLowerCase() === 'conference')) {
			const displayName = currentType.display_name.toLowerCase();
			initialDisableVak = displayName.includes('вак') || displayName.includes('ринц');
			initialDisableWoS = displayName.includes('wos') || displayName.includes('web of science');
			initialDisableScopus = displayName.includes('scopus');
		}

		setDisableEditVak(initialDisableVak);
		setDisableEditWoS(initialDisableWoS);
		setDisableEditScopus(initialDisableScopus);

		// Устанавливаем ID типа ПОСЛЕ установки флагов/блокировок
		setEditSelectedDisplayNameId(publication.display_name_id);

		console.log('Initial edit state set:', {
			id: publication.id,
			typeId: publication.display_name_id,
			vak: initialIsVak, wos: initialIsWoS, sco: initialIsScopus,
			disVak: initialDisableVak, disWos: initialDisableWoS, disSco: initialDisableScopus
		});


		setOpenEditDialog(true);
	};
	const handleEditSubmit = async (e) => {
		e.preventDefault();

		// ---> НАЧАЛО ЗАМЕНЫ/ДОБАВЛЕНИЯ: Новая проверка перед отправкой <---
		if (!editPublication) {
			setError('Публикация для редактирования не выбрана.');
			setOpenError(true);
			return;
		}

		let hasErrors = false;
		const fieldsToValidate = [ // Поля формы редактирования
			{ name: 'title', value: editTitle, setError: setEditTitleError },
			{ name: 'year', value: editYear, setError: setEditYearError },
			{ name: 'journalConferenceName', value: editJournalConferenceName, setError: setEditJournalConferenceNameError },
			{ name: 'doi', value: editDoi, setError: setEditDoiError },
			{ name: 'issn', value: editIssn, setError: setEditIssnError },
			{ name: 'isbn', value: editIsbn, setError: setEditIsbnError },
			{ name: 'volume', value: editVolume, setError: setEditVolumeError },
			{ name: 'number', value: editNumber, setError: setEditNumberError },
			{ name: 'pages', value: editPages, setError: setEditPagesError },
			{ name: 'publisher', value: editPublisher, setError: setEditPublisherError },
			{ name: 'publisherLocation', value: editPublisherLocation, setError: setEditPublisherLocationError },
			{ name: 'printedSheetsVolume', value: editPrintedSheetsVolume, setError: setEditPrintedSheetsVolumeError },
			{ name: 'circulation', value: editCirculation, setError: setEditCirculationError },
			{ name: 'quartile', value: editQuartile, setError: setEditQuartileError },         // <--- ДОБАВЬТЕ ЭТО
			{ name: 'department', value: editDepartment, setError: setEditDepartmentError },
			{ name: 'classificationCode', value: editClassificationCode, setError: setEditClassificationCodeError },
			// Валидация *нового* выбранного файла
			{ name: 'file', value: editFile, setError: setEditFileError }
		];

		// 1. Прогоняем валидацию для всех полей еще раз
		fieldsToValidate.forEach(field => {
			let currentError = '';
			if (field.name === 'file') {
				// Ошибка только если файл ВЫБРАН и он НЕВЕРНОГО типа
				if (field.value && !['pdf', 'docx'].includes(field.value.name.split('.').pop().toLowerCase())) {
					currentError = 'Подсказка: Недопустимый тип файла (только PDF, DOCX)';
				}
			} else {
				currentError = validateField(field.name, field.value);
			}
			field.setError(currentError); // Обновляем состояние ошибки
			if (currentError) {
				hasErrors = true; // Фиксируем наличие ошибки
			}
		});

		// 2. Проверяем ошибки у авторов в форме редактирования
		const authorErrors = editAuthorsList.map((author, index) => {
			const error = validateField('authorName', author.name);
			if (error) {
				handleEditAuthorChange(index, 'error', error); // Обновляем ошибку в состоянии
				hasErrors = true;
			} else if (author.error) {
				handleEditAuthorChange(index, 'error', ''); // Убираем старую ошибку
			}
			return error;
		}).filter(Boolean);

		// 3. Проверяем ОБЯЗАТЕЛЬНЫЕ поля для редактирования
		const baseFieldsMissing = [];
		if (!editTitle.trim()) baseFieldsMissing.push('Название');
		if (!editYear.toString().trim()) baseFieldsMissing.push('Год'); // Год может быть числом
		if (!editSelectedDisplayNameId) baseFieldsMissing.push('Тип');
		// Авторы и файл не обязательны при редактировании (можно редактировать только текст)

		if (baseFieldsMissing.length > 0 || hasErrors) {
			const errorMessages = [];
			if (baseFieldsMissing.length > 0) {
				errorMessages.push(<div>Не заполнены обязательные поля: {baseFieldsMissing.join(', ')}.</div>);
			}
			if (hasErrors) {
				errorMessages.push(<div>Проверьте правильность заполнения полей (появятся красные подсказки).</div>);
			}
			setError(<div>{errorMessages}</div>);
			setOpenError(true);
			return; // Прерываем отправку
		}
		// ---> КОНЕЦ ЗАМЕНЫ/ДОБАВЛЕНИЯ: Новая проверка перед отправкой <---

		const selectedType = publicationTypes.find(t => t.display_name_id === editSelectedDisplayNameId);
		if (!selectedType) { // Дополнительная проверка
			setError('Пожалуйста, выберите корректный тип публикации.');
			setOpenError(true);
			return;
		}

		// Готовим данные для отправки (берем только авторов с именем)
		const validAuthors = editAuthorsList.filter(a => a.name.trim());
		const authorsToSend = validAuthors.map(({ id, error, ...rest }) => rest); // Убираем id и error

		// --- Дальнейшая логика подготовки formData или data ---
		let data;
		let headers = { 'X-CSRFToken': csrfToken };
		const apiUrl = `http://localhost:5000/api/publications/${editPublication.id}`;

		if (editFile) { // Если ПРИКРЕПЛЕН НОВЫЙ ФАЙЛ
			data = new FormData();
			data.append('file', editFile);
			// ... Добавляем остальные поля в formData (как в handleFileUpload) ...
			data.append('title', editTitle.trim());
			data.append('authors_json', JSON.stringify(authorsToSend));
			data.append('year', parseInt(editYear, 10));
			data.append('type_id', selectedType.id);
			data.append('display_name_id', editSelectedDisplayNameId);
			data.append('is_vak', editIsVak ? 'true' : 'false');
			data.append('is_wos', editIsWoS ? 'true' : 'false');
			data.append('is_scopus', editIsScopus ? 'true' : 'false');
			data.append('journal_conference_name', editJournalConferenceName.trim() || '');
			data.append('doi', editDoi.trim() || '');
			data.append('issn', editIssn.trim() || '');
			data.append('isbn', editIsbn.trim() || '');
			data.append('quartile', editQuartile.trim() || '');
			data.append('volume', editVolume.trim() || '');
			data.append('number', editNumber.trim() || '');
			data.append('pages', editPages.trim() || '');
			data.append('department', editDepartment.trim() || '');
			data.append('publisher', editPublisher.trim() || '');
			data.append('publisher_location', editPublisherLocation.trim() || '');
			data.append('printed_sheets_volume', editPrintedSheetsVolume.trim().replace(',', '.') || '');
			data.append('circulation', editCirculation.trim() || '');
			data.append('classification_code', editClassificationCode.trim() || '');
			data.append('notes', editNotes.trim() || '');
			// headers['Content-Type'] НЕ устанавливаем для FormData
		} else { // Если НОВЫЙ ФАЙЛ НЕ ПРИКРЕПЛЕН (обычное обновление данных)
			data = {
				title: editTitle.trim(),
				authors: authorsToSend, // Передаем массив объектов авторов
				year: parseInt(editYear, 10),
				type_id: selectedType.id, // ID базового типа
				display_name_id: editSelectedDisplayNameId, // ID конкретного русского названия
				is_vak: editIsVak,
				is_wos: editIsWoS,
				is_scopus: editIsScopus,
				// Строковые поля (null если пусто)
				journal_conference_name: editJournalConferenceName.trim() || null,
				doi: editDoi.trim() || null,
				issn: editIssn.trim() || null,
				isbn: editIsbn.trim() || null,
				quartile: editQuartile.trim() || null,
				volume: editVolume.trim() || null,
				number: editNumber.trim() || null,
				pages: editPages.trim() || null,
				department: editDepartment.trim() || null,
				publisher: editPublisher.trim() || null,
				publisher_location: editPublisherLocation.trim() || null,
				classification_code: editClassificationCode.trim() || null,
				notes: editNotes.trim() || null,
				// Числовые поля (null если пусто или не число)
				printed_sheets_volume: editPrintedSheetsVolume.trim() && !isNaN(parseFloat(editPrintedSheetsVolume.replace(',', '.'))) ? parseFloat(editPrintedSheetsVolume.replace(',', '.')) : null,
				circulation: editCirculation.trim() && !isNaN(parseInt(editCirculation, 10)) ? parseInt(editCirculation, 10) : null,
			};
			headers['Content-Type'] = 'application/json'; // Указываем тип контента
		}

		// Очистка состояний ошибок редактирования ПЕРЕД отправкой
		setEditTitleError(''); setEditYearError(''); setEditJournalConferenceNameError('');
		setEditDoiError(''); setEditIssnError(''); setEditIsbnError(''); setEditVolumeError('');
		setEditNumberError(''); setEditPagesError(''); setEditPublisherError('');
		setEditPublisherLocationError(''); setEditPrintedSheetsVolumeError(''); setEditCirculationError('');
		setEditDepartmentError(''); setEditClassificationCodeError(''); setEditFileError('');
		setEditAuthorsList(prev => prev.map(a => ({ ...a, error: '' }))); // Очистка ошибок авторов

		try {
			await refreshCsrfToken();
			console.log('Updating publication with data:', data instanceof FormData ? Object.fromEntries(data.entries()) : data);
			const response = await axios.put(apiUrl, data, { withCredentials: true, headers });
			// ... остальная часть try блока ...
			setSuccess('Публикация успешно отредактирована!');
			setOpenSuccess(true);
			setOpenEditDialog(false);
			setError('');
			await fetchData(currentPage, searchQuery, filterDisplayNameId, filterStatus);
		} catch (err) {
			// ... остальная часть catch блока ...
			console.error('Ошибка редактирования публикации:', err.response?.data || err);
			let errorMsg = err.response?.data?.error || 'Произошла ошибка при сохранении изменений.';
			if (typeof errorMsg !== 'string') { // На случай если бэк вернул не строку
				errorMsg = 'Произошла непредвиденная ошибка.';
			}
			setError(errorMsg.split('\n').map((item, key) => <div key={key}>{item}</div>));
			setOpenError(true);
			setSuccess('');
		}
	};

	const validateField = (name, value) => {
		// Убираем пробелы по краям для большинства проверок
		const trimmedValue = typeof value === 'string' ? value.trim() : value;

		switch (name) {
			case 'title':
				if (trimmedValue && trimmedValue[0] !== trimmedValue[0].toUpperCase()) return 'Подсказка: Название должно начинаться с заглавной буквы. Пример: Новая публикация';
				return ''; // Обязательность проверим перед отправкой
			case 'year':
				if (!trimmedValue) return ''; // Обязательность проверим перед отправкой
				if (!/^\d{4}$/.test(trimmedValue)) return 'Подсказка: Год должен состоять ровно из 4 цифр. Пример: 2023';
				const yearNum = parseInt(trimmedValue, 10);
				if (yearNum < 1900 || yearNum > new Date().getFullYear() + 5) return `Подсказка: Укажите реальный год (между 1900 и ${new Date().getFullYear() + 5}).`;
				return '';
			case 'authorName': // Для валидации имени *каждого* автора
				if (trimmedValue && trimmedValue[0] !== trimmedValue[0].toUpperCase()) return 'Подсказка: ФИО автора должно начинаться с заглавной буквы. Пример: Иванов И.И.';
				return '';
			case 'journalConferenceName':
				if (trimmedValue && trimmedValue[0] !== trimmedValue[0].toUpperCase()) return 'Подсказка: Наименование должно начинаться с заглавной буквы. Пример: Вестник технологического университета';
				return ''; // Обязательность зависит от типа, проверим перед отправкой
			case 'doi':
				// Проверка только на разрешенные символы. DOI может быть сложным.
				if (trimmedValue && !/^[a-zA-Z0-9./_();:-]+$/.test(trimmedValue)) return 'Подсказка: DOI содержит недопустимые символы. Разрешены буквы, цифры и символы: ./_();:-';
				return '';
			case 'quartile':
				// Разрешаем Q1, Q2, Q3 или пустое значение
				if (trimmedValue && !['Q1', 'Q2', 'Q3'].includes(trimmedValue)) {
					return 'Подсказка: Квартиль должен быть Q1, Q2 или Q3.';
				}
				return ''; // Ошибки нет
			case 'issn':
				// Проверка только на разрешенные символы. Формат не строгий.
				if (trimmedValue && !/^[0-9X-]+$/.test(trimmedValue)) return 'Подсказка: ISSN может содержать только цифры, дефис и букву X. Пример: 1234-567X';
				return '';
			case 'isbn':
				// Проверка только на разрешенные символы. Формат не строгий.
				if (trimmedValue && !/^[0-9-]+$/.test(trimmedValue)) return 'Подсказка: ISBN может содержать только цифры и дефис. Пример: 978-5-123456-78-9';
				return '';
			case 'volume':
				if (trimmedValue && !/^\d+$/.test(trimmedValue)) return 'Подсказка: Том должен содержать только цифры. Пример: 5';
				return '';
			case 'number':
				if (trimmedValue && !/^\d+$/.test(trimmedValue)) return 'Подсказка: Номер/выпуск должен содержать только цифры. Пример: 12';
				return '';
			case 'pages':
				if (trimmedValue && !/^\d+(-\d+)?$/.test(trimmedValue)) return 'Подсказка: Неверный формат страниц. Пример: 123 или 123-145';
				const parts = trimmedValue.split('-');
				if (parts.length === 2) {
					const start = parseInt(parts[0]);
					const end = parseInt(parts[1]);
					if (!isNaN(start) && !isNaN(end) && start >= end) {
						return 'Подсказка: Начальная страница не может быть больше или равна конечной.';
					}
				}
				return '';
			case 'publisher':
				if (trimmedValue && trimmedValue[0] !== trimmedValue[0].toUpperCase()) return 'Подсказка: Название издательства должно начинаться с заглавной буквы. Пример: КНИТУ-КАИ';
				return ''; // Обязательность зависит от типа
			case 'publisherLocation':
				if (trimmedValue && trimmedValue[0] !== trimmedValue[0].toUpperCase()) return 'Подсказка: Место издательства должно начинаться с заглавной буквы. Пример: Казань';
				return ''; // Обязательность зависит от типа
			case 'printedSheetsVolume':
				if (trimmedValue && !/^[0-9]+([.,][0-9]+)?$/.test(trimmedValue)) return 'Подсказка: Объем должен быть положительным числом (целым или дробным через точку/запятую). Пример: 5.5';
				if (trimmedValue && parseFloat(trimmedValue.replace(',', '.')) <= 0) return 'Подсказка: Объем должен быть больше нуля.';
				return '';
			case 'circulation':
				if (trimmedValue && !/^\d+$/.test(trimmedValue)) return 'Подсказка: Тираж должен содержать только целые положительные цифры. Пример: 100';
				if (trimmedValue && parseInt(trimmedValue, 10) <= 0) return 'Подсказка: Тираж должен быть больше нуля.';
				return '';
			case 'department':
				// Допускаем только заглавные буквы (рус/лат) или пустое значение
				if (trimmedValue && !/^[A-ZА-ЯЁ]+$/.test(trimmedValue)) {
					return 'Подсказка: Кафедра должна состоять только из заглавных букв (аббревиатура). Пример: ПМИ';
				}
				return '';
			case 'classificationCode':
				if (trimmedValue && !/^[0-9.]+$/.test(trimmedValue)) return 'Подсказка: Код по классификатору может содержать только цифры и точки. Пример: 01.02.03';
				return '';
			case 'notes':
				// Для примечания обычно нет ограничений
				return '';
			default:
				return ''; // Нет валидации для неизвестных полей
		}
	};
	// <--- КОНЕЦ ВСТАВКИ: Новая функция валидации отдельного поля --->

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




	useEffect(() => {
		// Срабатывает при смене типа (editSelectedDisplayNameId) или открытии/закрытии диалога
		console.log(`Edit flags useEffect Triggered. Dialog Open: ${openEditDialog}, Pub ID: ${editPublication?.id}, Selected Type ID: ${editSelectedDisplayNameId}`);

		if (openEditDialog && editPublication && publicationTypes.length > 0 && editSelectedDisplayNameId) {
			const selectedType = publicationTypes.find(t => t.display_name_id === editSelectedDisplayNameId);

			if (!selectedType) {
				console.warn("Selected type not found for ID:", editSelectedDisplayNameId);
				return;
			}

			let isArticleOrConference = false;
			let isVakImplied = false;
			let isWoSImplied = false;
			let isScopusImplied = false;

			if (selectedType.name.toLowerCase() === 'article' || selectedType.name.toLowerCase() === 'conference') {
				isArticleOrConference = true;
				const displayNameLower = selectedType.display_name.toLowerCase();
				isVakImplied = (displayNameLower.includes('вак') || displayNameLower.includes('ринц')) && displayNameLower !== 'конференция ринц';
				isWoSImplied = displayNameLower.includes('wos') || displayNameLower.includes('web of science');
				isScopusImplied = displayNameLower.includes('scopus');
			}

			// --- 1. Установить блокировку (disabled) на основе НОВОГО типа ---
			console.log(`Setting disabled based on type (${selectedType.display_name}):`, { isVakImplied, isWoSImplied, isScopusImplied });
			setDisableEditVak(isVakImplied);
			setDisableEditWoS(isWoSImplied);
			setDisableEditScopus(isScopusImplied);

			// --- 2. Установить состояние checked на основе НОВОГО типа и ДАННЫХ ИСХОДНОЙ ПУБЛИКАЦИИ ---
			if (isArticleOrConference) {
				console.log('Setting checked state based on new type and original publication data:', {
					newVak: isVakImplied ? true : (editPublication.is_vak || false),
					newWos: isWoSImplied ? true : (editPublication.is_wos || false),
					newSco: isScopusImplied ? true : (editPublication.is_scopus || false),
					origVak: editPublication.is_vak, origWos: editPublication.is_wos, origSco: editPublication.is_scopus
				});
				// Эта логика ПЕРЕЗАПИСЫВАЕТ ручные клики при смене типа, обеспечивая "сброс"
				setEditIsVak(isVakImplied ? true : (editPublication.is_vak || false));
				setEditIsWoS(isWoSImplied ? true : (editPublication.is_wos || false)); // Проверьте имя is_wos
				setEditIsScopus(isScopusImplied ? true : (editPublication.is_scopus || false));
			} else {
				// Если тип НЕ статья/конференция, ВСЕ флаги должны быть false.
				console.log('Type is not Article/Conf, ensuring all flags are false');
				setEditIsVak(false);
				setEditIsWoS(false);
				setEditIsScopus(false);
			}

		} else if (!openEditDialog) {
			// При закрытии диалога - полный сброс через стабильную callback-функцию
			console.log('Dialog closed, calling resetFlagsAndDisables');
			resetFlagsAndDisables();
		}

		// Массив зависимостей: НЕ ВКЛЮЧАЕМ editIsVak, editIsWoS, editIsScopus
	}, [
		editSelectedDisplayNameId, // Главный триггер - смена типа
		openEditDialog,            // Контекст (открыт/закрыт)
		publicationTypes,          // Нужны для поиска типа
		editPublication,           // Нужен для доступа к is_vak/wos/scopus исходной публикации
		resetFlagsAndDisables      // Стабильная ссылка благодаря useCallback
	]);

	// Важно убедиться, что в handleEditClick происходит правильная начальная инициализация
	// И также убедимся, что в handleEditCancel используется resetFlagsAndDisables


	const handleEditAddAuthor = () => {
		setEditAuthorsList([...editAuthorsList, { id: Date.now(), name: '', is_employee: false }]);
	};



	const handleEditAuthorChange = (index, field, value) => {
		const updatedAuthors = editAuthorsList.map((author, i) => {
			if (i === index) {
				const newAuthorData = { ...author, [field]: value };
				// Валидируем имя автора при изменении поля 'name'
				if (field === 'name') {
					newAuthorData.error = validateField('authorName', value); // Обновляем ошибку в объекте
				}
				return newAuthorData;
			}
			return author;
		});
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
			data.append('is_vak', editIsVak ? 'true' : 'false');
			data.append('is_wos', editIsWoS ? 'true' : 'false');
			data.append('is_scopus', editIsScopus ? 'true' : 'false');
			data.append('journal_conference_name', editJournalConferenceName || '');
			data.append('doi', editDoi || '');
			data.append('issn', editIssn || '');
			data.append('isbn', editIsbn || '');
			data.append('quartile', editQuartile || '');
			data.append('volume', editVolume || '');
			data.append('number', editNumber || '');
			data.append('pages', editPages || '');
			data.append('department', editDepartment || '');
			data.append('publisher', editPublisher || '');
			data.append('publisher_location', editPublisherLocation || '');
			data.append('printed_sheets_volume', editPrintedSheetsVolume || '');
			data.append('circulation', editCirculation || '');
			data.append('classification_code', editClassificationCode || '');
			data.append('notes', editNotes || '');
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
		setEditIsVak(false);
		setEditIsWoS(false);
		setEditIsScopus(false);
		setDisableEditVak(false);
		setDisableEditWoS(false);
		setDisableEditScopus(false);
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
		// --- НОВЫЙ БЛОК: Формирование параметров ---
		const params = {};
		if (exportStartDate) {
			try {
				params.start_date = format(exportStartDate, 'yyyy-MM-dd');
			} catch (e) { console.error("Invalid start date format for BibTeX export", exportStartDate) }
		}
		if (exportEndDate) {
			try {
				// Как и для Excel, передаем просто выбранную дату. Бэкэнд обработает диапазон.
				params.end_date = format(exportEndDate, 'yyyy-MM-dd');
			} catch (e) { console.error("Invalid end date format for BibTeX export", exportEndDate) }
		}
		console.log("Exporting BibTeX with params:", params); // Отладка
		// --- КОНЕЦ НОВОГО БЛОКА ---

		try {
			// Обновляем CSRF токен, на всякий случай
			// await refreshCsrfToken(); // Если GET-запросы требуют CSRF (обычно нет)

			const response = await axios.get('http://localhost:5000/api/publications/export-bibtex', {
				withCredentials: true,
				params: params, // <--- ПЕРЕДАЕМ ПАРАМЕТРЫ
				// responseType 'blob' или 'text' может сработать, зависит от сервера
				responseType: 'blob', // или 'text', BibTeX обычно текстовый
				// headers: { 'X-CSRFToken': csrfToken } // Добавьте, если CSRF нужен для GET
			});

			// Определяем тип данных для Blob
			const blobType = response.headers['content-type'] || 'application/x-bibtex; charset=utf-8';
			// Создаем Blob из данных ответа
			// Если responseType='blob', response.data уже Blob
			// Если responseType='text', то нужно new Blob([response.data], ...)
			const blob = response.data instanceof Blob ? response.data : new Blob([response.data], { type: blobType });
			const url = window.URL.createObjectURL(blob);
			const link = document.createElement('a');
			link.href = url;

			// Получаем имя файла из заголовка
			const contentDisposition = response.headers['content-disposition'];
			let filename = 'publications.bib'; // Имя по умолчанию
			if (contentDisposition) {
				const filenameMatch = contentDisposition.match(/filename="?(.+)"?/i);
				if (filenameMatch && filenameMatch.length === 2) {
					filename = filenameMatch[1];
				}
			}
			link.download = filename; // Используем имя из заголовка
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
			window.URL.revokeObjectURL(url);

			// Сообщение об успехе
			setSuccess('BibTeX файл успешно скачан!');
			setOpenSuccess(true);

		} catch (err) {
			console.error('Ошибка выгрузки в BibTeX:', err.response?.data || err.message);
			// Попытка извлечь текст ошибки, если это blob/json
			let errorMsg = 'Не удалось экспортировать публикации в BibTeX.';
			if (err.response && err.response.data instanceof Blob && (err.response.data.type === "application/json" || err.response.data.type.includes("text"))) {
				try {
					const errorText = await err.response.data.text();
					// Если это JSON ошибка
					if (err.response.data.type === "application/json") {
						const errorJson = JSON.parse(errorText);
						errorMsg = errorJson.error || errorMsg;
					} else { // Если это просто текст ошибки (например, из make_response)
						errorMsg = errorText || errorMsg;
					}
				} catch (parseError) {
					console.error("Ошибка парсинга JSON/Text из Blob ошибки:", parseError);
				}
			} else if (err.response?.data?.error) { // Обычная JSON ошибка
				errorMsg = err.response.data.error;
			} else if (err.response?.data && typeof err.response.data === 'string') { // Строка ошибки
				errorMsg = err.response.data;
			}
			setError(errorMsg); // Используем глобальный обработчик ошибок
			setOpenError(true);
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
						centered
						sx={{
							mb: 4,
							borderBottom: 1,        // Опционально: линия под вкладками
							borderColor: 'divider', // Опционально: линия под вкладками

							'& .MuiTab-root': {
								color: '#6E6E73',
								fontWeight: 600, // Можно чуть уменьшить жирность, если нужно
								fontSize: '1rem', // <-- УМЕНЬШАЕМ РАЗМЕР ШРИФТА (подберите значение)
								textTransform: 'none', // Если еще не было - убирает КАПС
								minWidth: 'auto',     // <-- ПОЗВОЛЯЕМ СЖИМАТЬСЯ СИЛЬНЕЕ
								paddingLeft: 1.5,       // <-- УМЕНЬШАЕМ ОТСТУП СЛЕВА (подберите значение, 1.5 = 12px)
								paddingRight: 1.5,      // <-- УМЕНЬШАЕМ ОТСТУП СПРАВА (подберите значение, 1.5 = 12px)
								// Можно еще немного уменьшить вертикальные отступы, если высота мешает
								// paddingTop: '6px',
								// paddingBottom: '6px',
							},
							'& .MuiTab-root.Mui-selected': {
								color: '#0071E3',
								fontWeight: 600, // Можно вернуть жирность для активной вкладки
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
											<AppleButton onClick={() => { setUploadType('file'); resetCreateForm(); }}
												sx={{
													backgroundColor: uploadType === 'file' ? '#0071E3' : '#F5F5F7',
													color: uploadType === 'file' ? '#FFFFFF' : '#1D1D1F',
													border: '1px solid #D1D1D6',
												}}
											>
												Загрузить файл (PDF/DOCX)
											</AppleButton>
											<AppleButton onClick={() => { setUploadType('bibtex'); resetCreateForm(); }}
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
													onChange={(e) => {
														setSelectedDisplayNameId(e.target.value);
														if (e.target.value) setTypeMandatoryError(false); // Сбрасываем ошибку при выборе
													}}
													margin="normal"
													variant="outlined"
													disabled={publicationTypes.length === 0}
													error={submitAttempted && typeMandatoryError} // Ошибка только обязательности
												// helperText={submitAttempted && typeMandatoryError ? 'Выберите тип' : ''} // Можно убрать, использовать Typography
												>
													{/* ... MenuItem ... */}
													{publicationTypes.length === 0 ? (<MenuItem value="" disabled>Типы не доступны</MenuItem>)
														: (publicationTypes.map((type) => (<MenuItem key={type.display_name_id} value={type.display_name_id}>{type.display_name}</MenuItem>))
														)}
												</AppleTextField>
												{submitAttempted && typeMandatoryError && (
													<Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '8px' }}>
														Тип публикации обязателен
													</Typography>
												)}

												{/* Блоки VAK/WoS/Scopus - уже были */}
												{selectedDisplayNameId && publicationTypes.find(t => t.display_name_id === selectedDisplayNameId)?.name?.toLowerCase() === 'article' ||
													selectedDisplayNameId && publicationTypes.find(t => t.display_name_id === selectedDisplayNameId)?.name?.toLowerCase() === 'conference' ? (
													<Box sx={{ mt: 2, display: 'flex', alignItems: 'center', gap: 2 }}>
														<Typography variant="body2" sx={{ color: '#6E6E73', fontWeight: 500 }}>Индексирование:</Typography>
														<MuiTooltip title={disableNewVak ? "Статус 'ВАК' установлен типом публикации" : (newIsVak ? "Снять статус ВАК" : "Установить статус ВАК")} arrow>
															<IconButton onClick={() => !disableNewVak && setNewIsVak(!newIsVak)} disabled={disableNewVak} sx={{ backgroundColor: newIsVak ? 'rgba(52, 199, 89, 0.15)' : 'transparent', border: newIsVak ? '1px solid #34C759' : '1px solid #D1D1D6', p: 1, transition: 'all 0.2s ease-in-out', ...(disableNewVak && { cursor: 'not-allowed', pointerEvents: 'none', }), ...(!disableNewVak && { '&:hover': { backgroundColor: newIsVak ? 'rgba(52, 199, 89, 0.25)' : 'rgba(0, 0, 0, 0.04)', transform: 'scale(1.05)' }, }), }} aria-label={newIsVak ? "Снять статус ВАК" : "Установить статус ВАК"}><Typography variant="caption" sx={{ fontWeight: 600, fontSize: '0.8rem', color: newIsVak ? '#34C759' : '#6E6E73' }}>ВАК</Typography></IconButton>
														</MuiTooltip>
														<MuiTooltip title={disableNewWoS ? "Статус 'WoS' установлен типом публикации" : (newIsWoS ? "Снять статус WoS" : "Установить статус WoS")} arrow>
															<IconButton onClick={() => !disableNewWoS && setNewIsWoS(!newIsWoS)} disabled={disableNewWoS} sx={{ backgroundColor: newIsWoS ? 'rgba(0, 113, 227, 0.15)' : 'transparent', border: newIsWoS ? '1px solid #0071E3' : '1px solid #D1D1D6', p: 1, transition: 'all 0.2s ease-in-out', ...(disableNewWoS && { cursor: 'not-allowed', pointerEvents: 'none', }), ...(!disableNewWoS && { '&:hover': { backgroundColor: newIsWoS ? 'rgba(0, 113, 227, 0.25)' : 'rgba(0, 0, 0, 0.04)', transform: 'scale(1.05)' }, }), }} aria-label={newIsWoS ? "Снять статус WoS" : "Установить статус WoS"}><Typography variant="caption" sx={{ fontWeight: 600, fontSize: '0.8rem', color: newIsWoS ? '#0071E3' : '#6E6E73' }}>WoS</Typography></IconButton>
														</MuiTooltip>
														<MuiTooltip title={disableNewScopus ? "Статус 'Scopus' установлен типом публикации" : (newIsScopus ? "Снять статус Scopus" : "Установить статус Scopus")} arrow>
															<IconButton onClick={() => !disableNewScopus && setNewIsScopus(!newIsScopus)} disabled={disableNewScopus} sx={{ backgroundColor: newIsScopus ? 'rgba(175, 82, 222, 0.15)' : 'transparent', border: newIsScopus ? '1px solid #AF52DE' : '1px solid #D1D1D6', p: 1, transition: 'all 0.2s ease-in-out', ...(disableNewScopus && { cursor: 'not-allowed', pointerEvents: 'none', }), ...(!disableNewScopus && { '&:hover': { backgroundColor: newIsScopus ? 'rgba(175, 82, 222, 0.25)' : 'rgba(0, 0, 0, 0.04)', transform: 'scale(1.05)' }, }), }} aria-label={newIsScopus ? "Снять статус Scopus" : "Установить статус Scopus"}><Typography variant="caption" sx={{ fontWeight: 600, fontSize: '0.8rem', color: newIsScopus ? '#AF52DE' : '#6E6E73' }}>Scopus</Typography></IconButton>
														</MuiTooltip>
													</Box>
												) : null}

												{/* Название */}
												<AppleTextField
													fullWidth
													label="Название"
													value={title}
													onChange={(e) => {
														const newValue = e.target.value;
														setTitle(newValue);
														setTitleError(validateField('title', newValue)); // Проверка формата
														if (newValue.trim()) setTitleMandatoryError(false); // Сброс ошибки обязательности при вводе
													}}
													margin="normal"
													variant="outlined"
													// Ошибка = ошибка формата ИЛИ (попытка отправки И ошибка обязательности)
													error={!!titleError || (submitAttempted && titleMandatoryError)}
												/>
												{/* Подсказка = ошибка формата ИЛИ (попытка отправки И ошибка обязательности)? 'Обязательно' : '' */}
												{(titleError || (submitAttempted && titleMandatoryError)) && (
													<Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '8px' }}>
														{titleError ? titleError : (submitAttempted && titleMandatoryError ? 'Название обязательно' : '')}
													</Typography>
												)}
												{/* Авторы - ВАЖНО: required УДАЛЕН */}
												<Box sx={{
													mt: 2,
													borderColor: (submitAttempted && authorMandatoryError) ? 'error.main' : '#D1D1D6',
													borderWidth: '1px',
													borderStyle: 'solid',
													borderRadius: '12px',
													p: 2,
													backgroundColor: '#FFFFFF'
												}}>
													<Typography variant="subtitle1" sx={{ mb: 2, color: '#1D1D1F' }}>Авторы</Typography>
													{submitAttempted && authorMandatoryError && (
														<Typography color="error" variant="caption" sx={{ display: 'block', mb: 1 }}>
															Укажите хотя бы одного автора.
														</Typography>
													)}
													{newAuthors.map((author, index) => (
														<Grid container spacing={1} key={author.id} sx={{ mb: 2, alignItems: 'flex-start' /* Выравнивание */ }}>
															{/* Grid item для поля ввода */}
															<Grid item xs={true}>
																<AppleTextField
																	fullWidth
																	label={`Автор ${index + 1} (ФИО)`}
																	value={author.name}
																	onChange={(e) => {
																		if (submitAttempted && authorMandatoryError) setAuthorMandatoryError(false);
																		handleAuthorChange(index, 'name', e.target.value); // Используем handleAuthorChange
																	}}
																	size="small"
																	variant="outlined"
																	error={!!author.error}
																	sx={{ mb: author.error ? 0.5 : 0 }}
																/>
																{author.error && (
																	<Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px' }}>
																		{author.error}
																	</Typography>
																)}
															</Grid>
															{/* === НАЧАЛО ВОССТАНОВЛЕННОГО БЛОКА === */}
															<Grid item xs="auto" sx={{ pt: 0.5 /* Отступ для иконки */ }}>
																<MuiTooltip title={author.is_employee ? "Автор сотрудник КНИТУ-КАИ" : "Автор не сотрудник КНИТУ-КАИ"} arrow>
																	<IconButton
																		// ВАЖНО: Используем handleAuthorChange, а не handleEditAuthorChange
																		onClick={() => handleAuthorChange(index, 'is_employee', !author.is_employee)}
																		size="small"
																		sx={{
																			color: author.is_employee ? '#0071E3' : 'grey.500', // Цвет иконки
																			'&:hover': {
																				backgroundColor: author.is_employee ? 'rgba(0, 113, 227, 0.1)' : 'rgba(0, 0, 0, 0.04)', // Фон при наведении
																			}
																		}}
																		aria-label={author.is_employee ? "Пометить как не сотрудника" : "Пометить как сотрудника"}
																	>
																		<PersonIcon fontSize="small" />
																	</IconButton>
																</MuiTooltip>
															</Grid>
															{/* === КОНЕЦ ВОССТАНОВЛЕННОГО БЛОКА === */}
															{/* Grid item для иконки удаления */}
															<Grid item xs="auto" sx={{ pt: 0.5 /* Отступ для иконки */ }}>
																{newAuthors.length > 1 && ( // Показываем кнопку только если авторов больше одного
																	<IconButton onClick={() => handleRemoveAuthor(index)} size="small" sx={{ color: '#FF3B30' }} aria-label="Удалить автора">
																		<DeleteIcon fontSize="small" />
																	</IconButton>
																)}
															</Grid>
														</Grid>
													))}
													<Button startIcon={<AddIcon />} onClick={handleAddAuthor} size="small" sx={{ mt: 1, textTransform: 'none', color: '#0071E3' }}>Добавить автора</Button>
												</Box>

												{/* Год */}
												<AppleTextField
													fullWidth
													label="Год"
													type="number"
													value={year}
													onChange={(e) => {
														const newValue = e.target.value;
														setYear(newValue);
														setYearError(validateField('year', newValue)); // Формат
														if (newValue.trim()) setYearMandatoryError(false); // Обязательность
													}}
													margin="normal"
													variant="outlined"
													error={!!yearError || (submitAttempted && yearMandatoryError)}
												/>
												{(yearError || (submitAttempted && yearMandatoryError)) && (
													<Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '8px' }}>
														{yearError ? yearError : (submitAttempted && yearMandatoryError ? 'Год обязателен' : '')}
													</Typography>
												)}
												{/* Наименование журнала/конференции */}
												<AppleTextField
													fullWidth
													label="Наименование журнала/конференции"
													value={journalConferenceName}
													onChange={(e) => {
														const newValue = e.target.value;
														setJournalConferenceName(newValue);
														setJournalConferenceNameError(validateField('journalConferenceName', newValue));
													}}
													margin="normal"
													variant="outlined"
													error={!!journalConferenceNameError}
												/>
												{journalConferenceNameError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '8px' }}>{journalConferenceNameError}</Typography>}

												<Grid container spacing={2}>
													{/* DOI */}
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="DOI"
															value={doi}
															onChange={(e) => {
																const newValue = e.target.value;
																setDoi(newValue);
																setDoiError(validateField('doi', newValue));
															}}
															margin="normal"
															variant="outlined"
															error={!!doiError}
														/>
														{doiError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{doiError}</Typography>}
													</Grid>
													{/* Квартиль */}
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="Квартиль (Q)"
															value={quartile}
															// ИЗМЕНЕНИЕ onChange: добавляем валидацию
															onChange={(e) => {
																const newValue = e.target.value.toUpperCase(); // Можно сразу переводить в верхний регистр при вводе
																setQuartile(newValue);
																setQuartileError(validateField('quartile', newValue)); // Вызываем валидацию
															}}
															margin="normal"
															variant="outlined"
															error={!!quartileError} // ДОБАВЛЕНО
														/>
														{/* ДОБАВЛЕНО: Отображение ошибки квартиля */}
														{quartileError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{quartileError}</Typography>}
													</Grid>
													{/* ISSN */}
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="ISSN"
															value={issn}
															onChange={(e) => {
																const newValue = e.target.value;
																setIssn(newValue);
																setIssnError(validateField('issn', newValue));
															}}
															margin="normal"
															variant="outlined"
															error={!!issnError}
														/>
														{issnError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{issnError}</Typography>}
													</Grid>
													{/* ISBN */}
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="ISBN"
															value={isbn}
															onChange={(e) => {
																const newValue = e.target.value;
																setIsbn(newValue);
																setIsbnError(validateField('isbn', newValue));
															}}
															margin="normal"
															variant="outlined"
															error={!!isbnError}
														/>
														{isbnError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{isbnError}</Typography>}
													</Grid>
												</Grid>

												<Grid container spacing={2}>
													{/* Том */}
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Том"
															value={volume}
															onChange={(e) => {
																const newValue = e.target.value;
																setVolume(newValue);
																setVolumeError(validateField('volume', newValue));
															}}
															margin="normal"
															variant="outlined"
															error={!!volumeError}
														/>
														{volumeError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{volumeError}</Typography>}
													</Grid>
													{/* Номер/Выпуск */}
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Номер/Выпуск"
															value={number}
															onChange={(e) => {
																const newValue = e.target.value;
																setNumber(newValue);
																setNumberError(validateField('number', newValue));
															}}
															margin="normal"
															variant="outlined"
															error={!!numberError}
														/>
														{numberError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{numberError}</Typography>}
													</Grid>
													{/* Страницы */}
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Страницы"
															value={pages}
															onChange={(e) => {
																const newValue = e.target.value;
																setPages(newValue);
																setPagesError(validateField('pages', newValue));
															}}
															margin="normal"
															variant="outlined"
															error={!!pagesError}
														/>
														{pagesError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{pagesError}</Typography>}
													</Grid>
												</Grid>

												<Grid container spacing={2}>
													{/* Издательство */}
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="Издательство"
															value={publisher}
															onChange={(e) => {
																const newValue = e.target.value;
																setPublisher(newValue);
																setPublisherError(validateField('publisher', newValue));
															}}
															margin="normal"
															variant="outlined"
															error={!!publisherError}
														/>
														{publisherError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{publisherError}</Typography>}
													</Grid>
													{/* Место издательства */}
													<Grid item xs={12} sm={6}>
														<AppleTextField
															fullWidth
															label="Место издательства"
															value={publisherLocation}
															onChange={(e) => {
																const newValue = e.target.value;
																setPublisherLocation(newValue);
																setPublisherLocationError(validateField('publisherLocation', newValue));
															}}
															margin="normal"
															variant="outlined"
															error={!!publisherLocationError}
														/>
														{publisherLocationError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{publisherLocationError}</Typography>}
													</Grid>
													{/* Объем (п.л.) */}
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Объем (п.л.)"
															value={printedSheetsVolume} // Убираем type="number" для ручной валидации с запятой
															onChange={(e) => {
																const newValue = e.target.value;
																setPrintedSheetsVolume(newValue);
																setPrintedSheetsVolumeError(validateField('printedSheetsVolume', newValue));
															}}
															margin="normal"
															variant="outlined"
															error={!!printedSheetsVolumeError}
														// inputProps={{ step: "0.1" }} // Не нужен без type=number
														/>
														{printedSheetsVolumeError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{printedSheetsVolumeError}</Typography>}
													</Grid>
													{/* Тираж */}
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Тираж"
															// type="number" // Убираем для consistency с объемом
															value={circulation}
															onChange={(e) => {
																const newValue = e.target.value;
																setCirculation(newValue);
																setCirculationError(validateField('circulation', newValue));
															}}
															margin="normal"
															variant="outlined"
															error={!!circulationError}
														/>
														{circulationError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{circulationError}</Typography>}
													</Grid>
													{/* Кафедра */}
													<Grid item xs={12} sm={4}>
														<AppleTextField
															fullWidth
															label="Кафедра"
															value={department}
															onChange={(e) => {
																const newValue = e.target.value;
																setDepartment(newValue);
																// Убедитесь, что здесь 'department'
																setDepartmentError(validateField('department', newValue));
															}}
															margin="normal"
															variant="outlined"
															error={!!departmentError} // Должно уже быть
														/>
														{/* Это Typography должно уже быть */}
														{departmentError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{departmentError}</Typography>}
													</Grid>
												</Grid>

												{/* Код по классификатору */}
												<AppleTextField
													fullWidth
													label="Код по классификатору"
													value={classificationCode}
													onChange={(e) => {
														const newValue = e.target.value;
														setClassificationCode(newValue);
														setClassificationCodeError(validateField('classificationCode', newValue));
													}}
													margin="normal"
													variant="outlined"
													error={!!classificationCodeError}
												/>
												{classificationCodeError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '8px' }}>{classificationCodeError}</Typography>}

												{/* Примечание */}
												<AppleTextField
													fullWidth
													label="Примечание"
													value={notes}
													onChange={(e) => setNotes(e.target.value)} // Простая установка значения
													margin="normal"
													variant="outlined"
													multiline
													rows={2}
												// Нет ошибки для примечания
												/>
												{/* --- КОНЕЦ НОВЫХ ПОЛЕЙ --- */}

												<Box sx={{ mt: 2 }}>
													<input
														type="file"
														accept=".pdf,.docx"
														onChange={(e) => {
															const selectedFile = e.target.files[0];
															setFile(selectedFile);
															// Сброс ошибки обязательности при выборе файла
															if (selectedFile) setFileMandatoryError(false);
															// Валидация типа
															if (selectedFile && !['pdf', 'docx'].includes(selectedFile.name.split('.').pop().toLowerCase())) {
																setFileError('Подсказка: Недопустимый тип файла (только PDF, DOCX)');
															} else {
																setFileError('');
															}
														}}
														style={{ display: 'none' }}
														id="upload-file"
													/>
													<label htmlFor="upload-file">
														<AppleButton
															sx={(theme) => ({ // <--- Оборачиваем в функцию для доступа к theme
																// --- Используем стандартные имена или theme ---
																borderColor: (submitAttempted && fileMandatoryError) || !!fileError ? theme.palette.error.main : '#D1D1D6',
																borderWidth: '1px',
																borderStyle: 'solid',
																backgroundColor: '#F5F5F7', // Фон не меняем
																color: (submitAttempted && fileMandatoryError) || !!fileError ? theme.palette.error.main : '#1D1D1F',
																'&:hover': {
																	backgroundColor: (submitAttempted && fileMandatoryError) || !!fileError ? 'rgba(211, 47, 47, 0.08)' : '#E5E5EA' // Hover оставляем как есть
																}
																// --- Конец исправления ---
															})}
															component="span"
														>
															Выбрать файл
														</AppleButton>
													</label>
													{/* Показ ошибки обязательности ИЛИ ошибки формата ИЛИ имени файла */}
													{(submitAttempted && fileMandatoryError) ? (
														<Typography color="error" variant="caption" sx={{ mt: 1, display: 'block' }}>Файл обязателен</Typography>
													) : fileError ? (
														<Typography color="error" variant="caption" sx={{ mt: 1, display: 'block' }}>{fileError}</Typography>
													) : (
														file && <Typography sx={{ mt: 1, color: '#6E6E73' }}>{file.name}</Typography>
													)}
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

									{plans.length === 0 ? (
										// Если планов нет, показать сообщение
										<Typography sx={{ textAlign: 'center', mt: 4, color: '#6E6E73', fontStyle: 'italic' }}>
											У вас еще нет планов.
										</Typography>
									) : (
										// Если планы есть, показать их список и пагинацию
										<>
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
														{/* AccordionSummary остается как был */}
														<AccordionSummary
															expandIcon={<ExpandMoreIcon />}
															component="div"
															sx={{ cursor: 'pointer' }}
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
																				onClick={(e) => { e.stopPropagation(); handleEditPlanClick(plan.id); }}
																				sx={{ color: '#0071E3' }}
																				disabled={plan.status !== 'draft' && plan.status !== 'returned'}
																				title="Редактировать план"
																			>
																				<EditIcon />
																			</IconButton>
																			<IconButton
																				onClick={(e) => { e.stopPropagation(); handleDeletePlanClick(plan); }}
																				sx={{ color: '#FF3B30' }}
																				disabled={plan.status !== 'draft' && plan.status !== 'returned'}
																				title="Удалить план"
																			>
																				<DeleteIcon />
																			</IconButton>
																			<IconButton
																				onClick={(e) => { e.stopPropagation(); handleSubmitPlanForReview(plan); }}
																				sx={{ color: '#0071E3' }}
																				disabled={
																					!plan.entries ||
																					plan.entries.length === 0 ||
																					!areAllTitlesFilled(plan) ||
																					(plan.status !== 'draft' && plan.status !== 'returned')
																				}
																				title={
																					(plan.status !== 'draft' && plan.status !== 'returned') ? `Нельзя отправить план в статусе '${plan.status}'`
																						: (!plan.entries || plan.entries.length === 0) ? 'Нельзя отправить пустой план'
																							: !areAllTitlesFilled(plan) ? 'Заполните все заголовки перед отправкой'
																								: 'Отправить на проверку'
																				}
																			>
																				<PublishIcon />
																			</IconButton>
																		</>
																	)}
																</Box>
															</Box>
														</AccordionSummary>
														{/* AccordionDetails остается как был */}
														<AccordionDetails>
															{editingPlanId === plan.id ? (
																<>
																	{/* ... содержимое редактирования ... */}
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
																	{/* ... содержимое просмотра ... */}
																	<Typography sx={{ mb: 1 }}>Прогресс выполнения:</Typography>
																	<Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2 }}>
																		<LinearProgress
																			variant="determinate"
																			value={Math.min(calculateProgress(plan), 100)}
																			sx={{ height: 8, borderRadius: 4, flexGrow: 1, backgroundColor: '#E5E5EA', '& .MuiLinearProgress-bar': { backgroundColor: '#34C759' } }}
																		/>
																		<Typography variant="body2" sx={{ minWidth: '50px', textAlign: 'right', color: calculateProgress(plan) > 100 ? '#FF9500' : '#1D1D1F' }}>
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
																						<TableCell>{group.display_name || (publicationTypes.find(t => t.name === group.type)?.display_name) || group.type}</TableCell>
																						<TableCell>
																							<IconButton onClick={() => handleOpenLinkDialog(plan.id, group)} sx={{ color: '#0071E3' }} title="Привязать публикацию" disabled={plan.status !== 'approved' || group.factCount >= group.planCount}><LinkIcon /></IconButton>
																							<IconButton onClick={() => handleOpenUnlinkDialog(plan.id, group)} sx={{ color: group.factCount > 0 ? '#FF3B30' : '#D1D1D6' }} title="Отвязать публикацию" disabled={plan.status !== 'approved' || group.factCount === 0}><UnlinkIcon /></IconButton>
																						</TableCell>
																					</TableRow>
																				))}
																			</TableBody>
																		</PlanTable>
																	)}
																	{plan.return_comment && plan.status !== 'approved' && (
																		<Typography sx={{ mt: 2, color: '#000000', fontWeight: 600, display: 'flex', alignItems: 'center', gap: 1 }}>
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
										</> // Закрываем фрагмент для списка планов
									)}
								</> // Закрываем основной фрагмент для value === 3
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
									<AppleCard sx={{ p: 4, /* ... стили ... */ }}>
										<CardContent>
											<Typography variant="body1" sx={{ color: '#6E6E73', mb: 2 }}>
												Вы можете экспортировать свои публикации в формате BibTeX или Excel.
											</Typography>
											{/* --- НОВЫЙ БЛОК С ВЫБОРОМ ДАТ --- */}
											<Typography variant="body2" sx={{ color: '#1D1D1F', fontWeight: 500, mb: 1 }}>
												Диапазон дат для Excel отчета и экспорта в BibTeX (по дате публикации):
											</Typography>
											<LocalizationProvider dateAdapter={AdapterDateFns}> {/* Обертка для DatePicker */}
												<Box sx={{ display: 'flex', gap: 2, mb: 3, alignItems: 'center' }}>
													<DatePicker
														label="Дата начала"
														value={exportStartDate}
														onChange={(newValue) => setExportStartDate(newValue)}
														slots={{ textField: AppleTextField }} // Используем кастомный TextField
														slotProps={{
															textField: { // Пропсы для TextField внутри DatePicker
																variant: 'outlined',
																size: 'small'
															}
														}}
														maxDate={exportEndDate || undefined} // Нельзя выбрать позже конечной
														format="dd.MM.yyyy" // Формат отображения
													/>
													<DatePicker
														label="Дата конца"
														value={exportEndDate}
														onChange={(newValue) => setExportEndDate(newValue)}
														slots={{ textField: AppleTextField }}
														slotProps={{ textField: { variant: 'outlined', size: 'small' } }}
														minDate={exportStartDate || undefined} // Нельзя выбрать раньше начальной
														format="dd.MM.yyyy"
													/>
													<IconButton
														onClick={() => { setExportStartDate(null); setExportEndDate(null); }}
														size="small"
														title="Очистить даты"
														disabled={!exportStartDate && !exportEndDate}
														sx={{ color: '#0071E3' }}
													>
														<ClearIcon />
													</IconButton>
												</Box>
											</LocalizationProvider>
											{/* --- КОНЕЦ НОВОГО БЛОКА С ВЫБОРОМ ДАТ --- */}
											<Box sx={{ display: 'flex', gap: 2 }}> {/* Оборачиваем кнопки */}
												<AppleButton onClick={handleExportBibTeX}>
													Экспортировать в BibTeX
												</AppleButton>
												{/* --- НОВАЯ КНОПКА --- */}
												<AppleButton
													onClick={handleExportDocx}
													startIcon={<DownloadIcon />} // Используем ту же иконку
												>
													Экспортировать в Word
												</AppleButton>
												{/* --- КОНЕЦ НОВОЙ КНОПКИ --- */}
												{/* Новая кнопка */}
												<AppleButton
													onClick={handleExportExcel}
													startIcon={<DownloadIcon />} // Добавляем иконку
												>
													Экспортировать в Excel
												</AppleButton>
											</Box>
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
							value={editSelectedDisplayNameId || ''}
							onChange={(e) => setEditSelectedDisplayNameId(e.target.value)}
							margin="normal"
							variant="outlined"
							disabled={publicationTypes.length === 0}
						// Ошибка обязательности при отправке будет показана в общем блоке, здесь только форматная
						>
							{publicationTypes.length === 0 ? (<MenuItem value="" disabled> Типы не доступны </MenuItem>)
								: (publicationTypes.map((type) => (<MenuItem key={type.display_name_id} value={type.display_name_id}> {type.display_name} </MenuItem>))
								)}
						</AppleTextField>

						{/* Блоки VAK/WoS/Scopus (Редактирование) */}
						{editSelectedDisplayNameId && publicationTypes.find(t => t.display_name_id === editSelectedDisplayNameId)?.name?.toLowerCase() === 'article' ||
							editSelectedDisplayNameId && publicationTypes.find(t => t.display_name_id === editSelectedDisplayNameId)?.name?.toLowerCase() === 'conference' ? (
							<Box sx={{ mt: 2, display: 'flex', alignItems: 'center', gap: 2 }}>
								<Typography variant="body2" sx={{ color: '#6E6E73', fontWeight: 500 }}>Индексирование:</Typography>
								{/* ВАК */}
								<MuiTooltip title={disableEditVak ? "Статус 'ВАК' установлен типом публикации" : (editIsVak ? "Снять статус ВАК" : "Установить статус ВАК")} arrow>
									<span> {/* Обертка для disabled */}
										<IconButton
											// Используем edit состояния и сеттеры
											onClick={() => !disableEditVak && setEditIsVak(!editIsVak)}
											disabled={disableEditVak}
											sx={{ backgroundColor: editIsVak ? 'rgba(52, 199, 89, 0.15)' : 'transparent', border: editIsVak ? '1px solid #34C759' : '1px solid #D1D1D6', p: 1, transition: 'all 0.2s ease-in-out', ...(disableEditVak && { cursor: 'not-allowed', }), ...(!disableEditVak && { '&:hover': { backgroundColor: editIsVak ? 'rgba(52, 199, 89, 0.25)' : 'rgba(0, 0, 0, 0.04)', transform: 'scale(1.05)' }, }), }}
											aria-label={editIsVak ? "Снять статус ВАК" : "Установить статус ВАК"}
										>
											<Typography variant="caption" sx={{ fontWeight: 600, fontSize: '0.8rem', color: editIsVak ? '#34C759' : '#6E6E73' }}>ВАК</Typography>
										</IconButton>
									</span>
								</MuiTooltip>
								{/* WoS */}
								<MuiTooltip title={disableEditWoS ? "Статус 'WoS' установлен типом публикации" : (editIsWoS ? "Снять статус WoS" : "Установить статус WoS")} arrow>
									<span> {/* Обертка для disabled */}
										<IconButton
											// Используем edit состояния и сеттеры
											onClick={() => !disableEditWoS && setEditIsWoS(!editIsWoS)}
											disabled={disableEditWoS}
											sx={{ backgroundColor: editIsWoS ? 'rgba(0, 113, 227, 0.15)' : 'transparent', border: editIsWoS ? '1px solid #0071E3' : '1px solid #D1D1D6', p: 1, transition: 'all 0.2s ease-in-out', ...(disableEditWoS && { cursor: 'not-allowed', }), ...(!disableEditWoS && { '&:hover': { backgroundColor: editIsWoS ? 'rgba(0, 113, 227, 0.25)' : 'rgba(0, 0, 0, 0.04)', transform: 'scale(1.05)' }, }), }}
											aria-label={editIsWoS ? "Снять статус WoS" : "Установить статус WoS"}
										>
											<Typography variant="caption" sx={{ fontWeight: 600, fontSize: '0.8rem', color: editIsWoS ? '#0071E3' : '#6E6E73' }}>WoS</Typography>
										</IconButton>
									</span>
								</MuiTooltip>
								{/* Scopus */}
								<MuiTooltip title={disableEditScopus ? "Статус 'Scopus' установлен типом публикации" : (editIsScopus ? "Снять статус Scopus" : "Установить статус Scopus")} arrow>
									<span> {/* Обертка для disabled */}
										<IconButton
											// Используем edit состояния и сеттеры
											onClick={() => !disableEditScopus && setEditIsScopus(!editIsScopus)}
											disabled={disableEditScopus}
											sx={{ backgroundColor: editIsScopus ? 'rgba(175, 82, 222, 0.15)' : 'transparent', border: editIsScopus ? '1px solid #AF52DE' : '1px solid #D1D1D6', p: 1, transition: 'all 0.2s ease-in-out', ...(disableEditScopus && { cursor: 'not-allowed', }), ...(!disableEditScopus && { '&:hover': { backgroundColor: editIsScopus ? 'rgba(175, 82, 222, 0.25)' : 'rgba(0, 0, 0, 0.04)', transform: 'scale(1.05)' }, }), }}
											aria-label={editIsScopus ? "Снять статус Scopus" : "Установить статус Scopus"}
										>
											<Typography variant="caption" sx={{ fontWeight: 600, fontSize: '0.8rem', color: editIsScopus ? '#AF52DE' : '#6E6E73' }}>Scopus</Typography>
										</IconButton>
									</span>
								</MuiTooltip>
							</Box>
						) : null}
						{/* ... (без изменений) ... */}

						{/* Название */}
						<AppleTextField
							fullWidth
							label="Название"
							value={editTitle}
							onChange={(e) => {
								const newValue = e.target.value;
								setEditTitle(newValue);
								setEditTitleError(validateField('title', newValue)); // Валидируем как 'title'
							}}
							margin="normal"
							variant="outlined"
							error={!!editTitleError}
						/>
						{editTitleError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '8px' }}>{editTitleError}</Typography>}

						{/* Авторы - ВАЖНО: required УДАЛЕН */}
						<Box sx={{ mt: 2, border: '1px solid #D1D1D6', borderRadius: '12px', p: 2, backgroundColor: '#FFFFFF' }}>
							<Typography variant="subtitle1" sx={{ mb: 2, color: '#1D1D1F' }}>Авторы</Typography>
							{editAuthorsList.map((author, index) => (
								<Grid container spacing={1} key={author.id} sx={{ mb: 2, alignItems: 'flex-start' /* Изменили выравнивание */ }}>
									{/* --- Grid item для поля ввода и ошибки --- */}
									<Grid item xs={true}>
										<AppleTextField
											fullWidth
											// required // УДАЛЕНО
											label={`Автор ${index + 1} (ФИО)`}
											value={author.name}
											onChange={(e) => handleEditAuthorChange(index, 'name', e.target.value)} // Правильный обработчик
											size="small"
											variant="outlined"
											error={!!author.error}
											// Добавляем нижний отступ только если ЕСТЬ ошибка, чтобы не было лишнего места
											sx={{ mb: author.error ? 0.5 : 0 }}
										/>
										{/* --- Ошибка теперь ВНУТРИ того же Grid item --- */}
										{author.error && (
											<Typography
												color="error"
												variant="caption"
												sx={{
													display: 'block',
													pl: '14px',
													// mt: 0.5 // Можно оставить 0
												}}
											>
												{author.error}
											</Typography>
										)}
									</Grid>
									{/* --- Grid item для иконки сотрудника --- */}
									<Grid item xs="auto" sx={{ pt: 0.5 /* Отступ для иконки */ }}>
										<MuiTooltip title={author.is_employee ? "Автор сотрудник КНИТУ-КАИ" : "Автор не сотрудник КНИТУ-КАИ"} arrow>
											<IconButton onClick={() => handleEditAuthorChange(index, 'is_employee', !author.is_employee)} size="small" sx={{ color: author.is_employee ? '#0071E3' : 'grey.500', '&:hover': { backgroundColor: author.is_employee ? 'rgba(0, 113, 227, 0.1)' : 'rgba(0, 0, 0, 0.04)', } }} aria-label={author.is_employee ? "Пометить как не сотрудника" : "Пометить как сотрудника"}><PersonIcon fontSize="small" /></IconButton>
										</MuiTooltip>
									</Grid>
									{/* --- Grid item для иконки удаления --- */}
									<Grid item xs="auto" sx={{ pt: 0.5 /* Отступ для иконки */ }}>
										{editAuthorsList.length > 1 && (<IconButton onClick={() => handleEditRemoveAuthor(index)} size="small" sx={{ color: '#FF3B30' }} aria-label="Удалить автора"><DeleteIcon fontSize="small" /></IconButton>)}
									</Grid>
								</Grid>
							))}
							<Button startIcon={<AddIcon />} onClick={handleEditAddAuthor} size="small" sx={{ mt: 1, textTransform: 'none', color: '#0071E3' }}>Добавить автора</Button>
						</Box>

						{/* Год */}
						<AppleTextField
							fullWidth
							label="Год"
							type="number"
							value={editYear}
							onChange={(e) => {
								const newValue = e.target.value;
								setEditYear(newValue);
								setEditYearError(validateField('year', newValue));
							}}
							margin="normal"
							variant="outlined"
							error={!!editYearError}
						/>
						{editYearError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '8px' }}>{editYearError}</Typography>}

						{/* --- Добавьте аналогичные блоки для ВСЕХ полей ниже --- */}

						{/* Наименование журнала/конференции */}
						<AppleTextField
							fullWidth
							label="Наименование журнала/конференции"
							value={editJournalConferenceName}
							onChange={(e) => {
								const newValue = e.target.value;
								setEditJournalConferenceName(newValue);
								setEditJournalConferenceNameError(validateField('journalConferenceName', newValue));
							}}
							margin="normal"
							variant="outlined"
							error={!!editJournalConferenceNameError}
						/>
						{editJournalConferenceNameError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '8px' }}>{editJournalConferenceNameError}</Typography>}

						<Grid container spacing={2}>
							{/* DOI */}
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="DOI"
									value={editDoi}
									onChange={(e) => {
										const newValue = e.target.value;
										setEditDoi(newValue);
										setEditDoiError(validateField('doi', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editDoiError}
								/>
								{editDoiError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editDoiError}</Typography>}
							</Grid>
							{/* Квартиль */}
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="Квартиль (Q)"
									value={editQuartile}
									// ИЗМЕНЕНИЕ onChange: добавляем валидацию
									onChange={(e) => {
										const newValue = e.target.value.toUpperCase(); // Можно сразу переводить в верхний регистр при вводе
										setEditQuartile(newValue);
										// Валидируем как 'quartile'
										setEditQuartileError(validateField('quartile', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editQuartileError} // ДОБАВЛЕНО
								/>
								{/* ДОБАВЛЕНО: Отображение ошибки квартиля (редактирование) */}
								{editQuartileError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editQuartileError}</Typography>}
							</Grid>
							{/* ISSN */}
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="ISSN"
									value={editIssn}
									onChange={(e) => {
										const newValue = e.target.value;
										setEditIssn(newValue);
										setEditIssnError(validateField('issn', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editIssnError}
								/>
								{editIssnError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editIssnError}</Typography>}
							</Grid>
							{/* ISBN */}
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="ISBN"
									value={editIsbn}
									onChange={(e) => {
										const newValue = e.target.value;
										setEditIsbn(newValue);
										setEditIsbnError(validateField('isbn', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editIsbnError}
								/>
								{editIsbnError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editIsbnError}</Typography>}
							</Grid>
						</Grid>

						<Grid container spacing={2}>
							{/* Том */}
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Том"
									value={editVolume}
									onChange={(e) => {
										const newValue = e.target.value;
										setEditVolume(newValue);
										setEditVolumeError(validateField('volume', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editVolumeError}
								/>
								{editVolumeError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editVolumeError}</Typography>}
							</Grid>
							{/* Номер/Выпуск */}
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Номер/Выпуск"
									value={editNumber}
									onChange={(e) => {
										const newValue = e.target.value;
										setEditNumber(newValue);
										setEditNumberError(validateField('number', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editNumberError}
								/>
								{editNumberError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editNumberError}</Typography>}
							</Grid>
							{/* Страницы */}
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Страницы"
									value={editPages}
									onChange={(e) => {
										const newValue = e.target.value;
										setEditPages(newValue);
										setEditPagesError(validateField('pages', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editPagesError}
								/>
								{editPagesError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editPagesError}</Typography>}
							</Grid>
						</Grid>

						<Grid container spacing={2}>
							{/* Издательство */}
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="Издательство"
									value={editPublisher}
									onChange={(e) => {
										const newValue = e.target.value;
										setEditPublisher(newValue);
										setEditPublisherError(validateField('publisher', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editPublisherError}
								/>
								{editPublisherError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editPublisherError}</Typography>}
							</Grid>
							{/* Место издательства */}
							<Grid item xs={12} sm={6}>
								<AppleTextField
									fullWidth
									label="Место издательства"
									value={editPublisherLocation}
									onChange={(e) => {
										const newValue = e.target.value;
										setEditPublisherLocation(newValue);
										setEditPublisherLocationError(validateField('publisherLocation', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editPublisherLocationError}
								/>
								{editPublisherLocationError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editPublisherLocationError}</Typography>}
							</Grid>
							{/* Объем (п.л.) */}
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Объем (п.л.)"
									value={editPrintedSheetsVolume}
									onChange={(e) => {
										const newValue = e.target.value;
										setEditPrintedSheetsVolume(newValue);
										setEditPrintedSheetsVolumeError(validateField('printedSheetsVolume', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editPrintedSheetsVolumeError}
								//inputProps={{ step: "0.1" }} // Убрали, т.к. валидация ручная
								/>
								{editPrintedSheetsVolumeError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editPrintedSheetsVolumeError}</Typography>}
							</Grid>
							{/* Тираж */}
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Тираж"
									// type="number" // Убираем
									value={editCirculation}
									onChange={(e) => {
										const newValue = e.target.value;
										setEditCirculation(newValue);
										setEditCirculationError(validateField('circulation', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editCirculationError}
								/>
								{editCirculationError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editCirculationError}</Typography>}
							</Grid>
							{/* Кафедра */}
							<Grid item xs={12} sm={4}>
								<AppleTextField
									fullWidth
									label="Кафедра"
									value={editDepartment}
									onChange={(e) => {
										const newValue = e.target.value;
										setEditDepartment(newValue);
										// Убедитесь, что здесь 'department'
										setEditDepartmentError(validateField('department', newValue));
									}}
									margin="normal"
									variant="outlined"
									error={!!editDepartmentError} // ДОБАВЛЕНО
								/>
								{/* Это Typography должно уже быть */}
								{editDepartmentError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '0px' }}>{editDepartmentError}</Typography>}
							</Grid>
						</Grid>

						{/* Код по классификатору */}
						<AppleTextField
							fullWidth
							label="Код по классификатору"
							value={editClassificationCode}
							onChange={(e) => {
								const newValue = e.target.value;
								setEditClassificationCode(newValue);
								setEditClassificationCodeError(validateField('classificationCode', newValue));
							}}
							margin="normal"
							variant="outlined"
							error={!!editClassificationCodeError}
						/>
						{editClassificationCodeError && <Typography color="error" variant="caption" sx={{ display: 'block', pl: '14px', mt: '-8px', mb: '8px' }}>{editClassificationCodeError}</Typography>}

						{/* Примечание */}
						<AppleTextField
							fullWidth
							label="Примечание"
							value={editNotes}
							onChange={(e) => setEditNotes(e.target.value)} // Без валидации
							margin="normal"
							variant="outlined"
							multiline
							rows={2}
						// Нет ошибки
						/>

						{/* Блок выбора файла (редактирование) */}
						<Box sx={{ mt: 2 }}>
							<input
								type="file"
								accept=".pdf,.docx"
								onChange={(e) => { // <--- ИЗМЕНЕНИЕ ЗДЕСЬ (для editFile)
									const selectedFile = e.target.files[0];
									setEditFile(selectedFile); // Устанавливаем состояние нового файла
									if (selectedFile && !['pdf', 'docx'].includes(selectedFile.name.split('.').pop().toLowerCase())) {
										setEditFileError('Подсказка: Недопустимый тип файла (только PDF, DOCX)');
									} else {
										setEditFileError('');
									}
								}}
								style={{ display: 'none' }}
								id="edit-file"
							/>

							{/* Отображение имени файла ИЛИ ошибки типа файла */}
							{editFileError ? (
								<Typography color="error" variant="caption" sx={{ mt: 1, display: 'block' }}>{editFileError}</Typography>
							) : (
								editFile && <Typography sx={{ mt: 1, color: '#6E6E73' }}>Новый файл: {editFile.name}</Typography>
							)}
							{/* Показываем старый файл, если новый не выбран */}
							{!editFile && editPublication?.file_url && (
								<Typography sx={{ mt: 1, color: '#6E6E73' }}>Текущий файл: {editPublication.file_url.split('/').pop()}</Typography>
							)}
						</Box>

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
				{success && ( // Добавлена проверка, что success не пустая строка
					<Alert
						severity="success"
						sx={{ /* ваши стили для success Alert */
							position: 'fixed',
							top: 16,
							left: '50%',
							transform: 'translateX(-50%)',
							width: 'fit-content',
							maxWidth: '90%',
							borderRadius: '12px',
							backgroundColor: '#E7F8E7', // Светло-зеленый фон
							color: '#1D1D1F', // Темный текст
							boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)',
							zIndex: 1500,
						}}
						onClose={() => { setOpenSuccess(false); setSuccess(''); }} // Сбрасываем и success текст
					>
						{success /* success обычно простая строка */}
					</Alert>
				)}
			</Collapse>

			<Collapse in={openError}>
				{error && ( // Добавляем проверку на наличие текста/JSX ошибки
					<Alert
						severity="error"
						sx={{ /* ваши стили для error Alert */
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
							zIndex: 1499, // Убедимся, что поверх всего остального
							// Стили для контейнера сообщения Alert, чтобы JSX рендерился корректно
							'& .MuiAlert-message': {
								display: 'flex',
								flexDirection: 'column', // Ошибки друг под другом
								alignItems: 'flex-start', // Выравнивание текста влево
								gap: '4px' // Небольшой отступ между строками ошибки
							}
						}}
						onClose={() => { setOpenError(false); setError(''); }} // Сбрасываем и error текст/JSX при закрытии
					>
						{error /* error теперь может содержать JSX */}
					</Alert>
				)}
			</Collapse>
			{/* ---- КОНЕЦ ЗАМЕНЕННОГО БЛОКА ---- */}

		</Container >
	);
}

export default Dashboard;