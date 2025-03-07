import React, { useState, useEffect, useRef } from 'react';
import { Line } from 'react-chartjs-2';
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
import { styled } from '@mui/system';
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

function Dashboard() {
	const { user, csrfToken, setCsrfToken } = useAuth();
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
	const [passwordError, setPasswordError] = useState('');
	const [passwordSuccess, setPasswordSuccess] = useState('');
	const [pubTypes, setPubTypes] = useState({ article: 0, monograph: 0, conference: 0 });
	const [pubStatuses, setPubStatuses] = useState({ draft: 0, needs_review: 0, published: 0 });
	const [totalCitations, setTotalCitations] = useState(0);
	const [searchQuery, setSearchQuery] = useState('');
	const [filterType, setFilterType] = useState('all');
	const [filterStatus, setFilterStatus] = useState('all');
	const [linkDialogOpen, setLinkDialogOpen] = useState(false);
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

	const fetchData = async (page = 1, search = '', pubType = 'all', status = 'all') => {
		try {
			const pubResponse = await axios.get('http://localhost:5000/api/publications', {
				withCredentials: true,
				params: {
					page,
					per_page: publicationsPerPage,
					search,
					type: pubType,
					status,
				},
			});
			setPublications(pubResponse.data.publications);
			setFilteredPublications(pubResponse.data.publications);
			setCurrentPage(page);
			const total = pubResponse.data.total || 0;
			const calculatedTotalPages = Math.ceil(total / publicationsPerPage);
			setTotalPages(calculatedTotalPages);
			setPublicationsTransitionKey((prev) => prev + 1);

			if (page > calculatedTotalPages && calculatedTotalPages > 0) {
				setCurrentPage(1);
				fetchData(1, search, pubType, status);
				return;
			}

			const allPublications = await fetchAllPublications();
			updateAnalytics(allPublications);

			console.log('Server response for page', page, ':', pubResponse.data);
			setError('');
		} catch (err) {
			console.error('Ошибка загрузки данных:', err);
			setError('Произошла ошибка сервера. Попробуйте позже.');
			setOpenError(true);
		} finally {
			setLoadingInitial(false);
		}
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
					publication_id: entry.publication_id || null, // Убеждаемся, что publication_id присутствует
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
	const updateAnalytics = (allPublications) => {
		const types = { article: 0, monograph: 0, conference: 0 };
		const statuses = { draft: 0, needs_review: 0, published: 0 };
		let citations = 0;

		allPublications.forEach((pub) => {
			const pubType = validPublicationTypes.includes(pub.type) ? pub.type : 'article';
			types[pubType] = (types[pubType] || 0) + 1;
			statuses[pub.status] = (statuses[pub.status] || 0) + 1;
			if (pub.citations) citations += pub.citations;
		});

		setPubTypes(types);
		setPubStatuses(statuses);
		setTotalCitations(citations);

		const yearlyAnalytics = allPublications.reduce((acc, pub) => {
			acc[pub.year] = (acc[pub.year] || 0) + 1;
			return acc;
		}, {});
		const analyticsData = Object.entries(yearlyAnalytics).map(([year, count]) => ({ year: parseInt(year), count }));
		analyticsData.sort((a, b) => a.year - b.year);
		setAnalytics(analyticsData);
	};

	useEffect(() => {
		fetchData(1, searchQuery, filterType, filterStatus);
		fetchPlans(1);
		fetchAllPublications(); // Добавляем вызов 
	}, [navigate, searchQuery, filterType, filterStatus]);

	const currentPublications = filteredPublications;

	const handlePageChange = (event, newPage) => {
		fetchData(newPage, searchQuery, filterType, filterStatus);
	};

	const handlePlanPageChange = (event, newPage) => {
		fetchPlans(newPage);
	};

	const handleChangePasswordClick = () => {
		setOpenChangePasswordDialog(true);
		setCurrentPassword('');
		setNewPassword('');
		setPasswordError('');
		setPasswordSuccess('');
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

			setPasswordSuccess('Пароль успешно обновлен!');
			setPasswordError('');
			setOpenChangePasswordDialog(false);
			setCurrentPassword('');
			setNewPassword('');
			setShowCurrentPassword(false);
			setShowNewPassword(false);
		} catch (err) {
			console.error('Ошибка изменения пароля:', err);
			if (err.response) {
				setPasswordError(
					`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте введенные данные.'}`
				);
			} else {
				setPasswordError('Ошибка сети. Проверьте подключение и сервер.');
			}
			setPasswordSuccess('');
		}
	};

	const handleChangePasswordCancel = () => {
		setOpenChangePasswordDialog(false);
		setCurrentPassword('');
		setNewPassword('');
		setPasswordError('');
		setPasswordSuccess('');
		setShowCurrentPassword(false);
		setShowNewPassword(false);
	};

	const handleToggleCurrentPasswordVisibility = () => {
		setShowCurrentPassword(!showCurrentPassword);
	};

	const handleToggleNewPasswordVisibility = () => {
		setShowNewPassword(!showNewPassword);
	};

	useEffect(() => {
		if (passwordError || passwordSuccess) {
			const timer = setTimeout(() => {
				setPasswordError('');
				setPasswordSuccess('');
			}, 5000);
			return () => clearTimeout(timer);
		}
	}, [passwordError, passwordSuccess]);

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
			await refreshCsrfToken();
			console.log('Uploading file with data:', { title, authors, year, type });
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
			setType('article');
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
		console.log('Editing publication:', publication.id);
		setEditPublication(publication || {});
		setEditTitle(publication?.title || '');
		setEditAuthors(publication?.authors || '');
		setEditYear(publication?.year || '');
		setEditType(validPublicationTypes.includes(publication?.type) ? publication.type : 'article');
		setEditFile(null);
		setOpenEditDialog(true);
	};

	const handleEditSubmit = async (e) => {
		e.preventDefault();
		if (!editPublication) return;

		let data;
		let headers = {};
		if (editFile) {
			data = new FormData();
			data.append('file', editFile);
			data.append('title', editTitle.trim() || '');
			data.append('authors', editAuthors.trim() || '');
			data.append('year', editYear ? parseInt(editYear, 10) : '');
			data.append('type', editType || 'article');
			data.append('status', 'draft');
			headers['Content-Type'] = 'multipart/form-data';
			headers['X-CSRFToken'] = csrfToken;
		} else {
			data = {
				title: editTitle.trim() || '',
				authors: editAuthors.trim() || '',
				year: editYear ? parseInt(editYear, 10) : '',
				type: editType || 'article',
				status: 'draft',
			};
			headers['Content-Type'] = 'application/json';
			headers['X-CSRFToken'] = csrfToken;
		}

		try {
			await refreshCsrfToken();
			console.log('Updating publication with:', {
				title: editTitle,
				authors: editAuthors,
				year: editYear,
				type: editType,
				status: 'draft',
				file: editFile ? editFile.name : 'No new file',
			});
			const response = await axios.put(`http://localhost:5000/api/publications/${editPublication.id || ''}`, data, {
				withCredentials: true,
				headers,
			});
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
		setEditType('article');
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
			setSuccess('Личные данные успешно обновлены!');
			setOpenSuccess(true);
			setError('');
			setEditLastName(response.data.user.last_name);
			setEditFirstName(response.data.user.first_name);
			setEditMiddleName(response.data.user.middle_name);
			setOpenEditUserDialog(false);
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
		if (!newPlan.year || !newPlan.expectedCount || newPlan.expectedCount < 1) {
			setError('Пожалуйста, укажите год и количество ожидаемых публикаций (минимум 1).');
			setOpenError(true);
			return;
		}

		try {
			await refreshCsrfToken();
			const planData = {
				year: newPlan.year,
				expectedCount: newPlan.expectedCount,
				fillType: 'manual',
				entries: Array.from({ length: newPlan.expectedCount }, () => ({
					title: '',
					type: 'article',
					status: 'planned',
				})),
			};
			console.log('Creating plan with:', planData);
			const response = await axios.post('http://localhost:5000/api/plans', planData, {
				withCredentials: true,
				headers: {
					'X-CSRFToken': csrfToken,
					'Content-Type': 'application/json',
				},
			});
			setSuccess('План успешно создан!');
			setOpenSuccess(true);
			setError('');
			setOpenCreatePlanDialog(false);
			setNewPlan({ year: new Date().getFullYear() + 1, expectedCount: 1 });
			await fetchPlans(planPage);
		} catch (err) {
			console.error('Ошибка создания плана:', err.response?.data || err);
			if (err.response) {
				setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте введенные поля.'}`);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			setOpenError(true);
			setSuccess('');
		}
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
			await refreshCsrfToken();
			const newEntries = plan.entries.filter(entry => !entry.id); // Фильтруем только новые записи
			const planData = {
				year: plan.year,
				expectedCount: plan.entries.length,
				fillType: 'manual',
				entries: newEntries.map(entry => ({
					title: entry.title || '',
					type: entry.type || 'article',
					status: entry.status || 'planned',
					publication_id: entry.publication_id || null,
				})),
			};
			console.log('Saving plan with:', planData);
			const response = await axios.put(`http://localhost:5000/api/plans/${plan.id}`, planData, {
				withCredentials: true,
				headers: {
					'X-CSRFToken': csrfToken,
					'Content-Type': 'application/json',
				},
			});
			setSuccess('План успешно сохранён!');
			setOpenSuccess(true);
			setError('');
			setEditingPlanId(null);
			setPlans(prevPlans =>
				prevPlans.map(p =>
					p.id === plan.id ? { ...p, entries: response.data.plan.entries, isSaved: true } : p
				)
			);
			await fetchPlans(planPage);
		} catch (err) {
			console.error('Ошибка сохранения плана:', err.response?.data || err);
			if (err.response) {
				setError(`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте введенные поля.'}`);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			setOpenError(true);
			setSuccess('');
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

	// Функция для фильтрации публикаций в диалоге привязки
	const handleLinkSearch = (query) => {
		setLinkSearchQuery(query);
		const filtered = publishedPublications.filter(
			(pub) =>
				pub.title.toLowerCase().includes(query.toLowerCase()) ||
				pub.authors.toLowerCase().includes(query.toLowerCase())
		);
		setFilteredPublishedPublications(filtered);
	};

	// Функция открытия диалога привязки
	const handleOpenLinkDialog = (planId, entry) => {
		setSelectedPlanEntry({ planId, ...entry });
		setLinkDialogOpen(true);
		setLinkSearchQuery('');
		setFilteredPublishedPublications(publishedPublications);
	};

	// Функция привязки публикации
	const handleLinkPublication = async (planId, entryId, publicationId) => {
		try {
			await refreshCsrfToken();
			console.log('Отправка запроса привязки:', { planId, entryId, publicationId });
			const response = await axios.post(
				`http://localhost:5000/api/plans/${planId}/entries/${entryId}/link`,
				{ publication_id: publicationId },
				{
					withCredentials: true,
					headers: {
						'X-CSRFToken': csrfToken,
						'Content-Type': 'application/json',
					},
				}
			);
			console.log('Ответ сервера:', response.data);
			setSuccess('Публикация успешно привязана!');
			setOpenSuccess(true);
			await Promise.all([fetchPlans(planPage), fetchAllPublications()]); // Обновляем и планы, и публикации
			setLinkDialogOpen(false);
		} catch (err) {
			console.error('Ошибка привязки:', err.response?.data || err.message);
			setError(err.response?.data?.error || 'Не удалось привязать публикацию.');
			setOpenError(true);
		}
	};


	// Функция отвязки публикации
	const handleUnlinkPublication = async (planId, entryId) => {
		try {
			await refreshCsrfToken();
			await axios.post(
				`http://localhost:5000/api/plans/${planId}/entries/${entryId}/unlink`,
				{},
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);
			setSuccess('Публикация успешно отвязана!');
			setOpenSuccess(true);
			fetchPlans(planPage);
		} catch (err) {
			setError(err.response?.data?.error || 'Не удалось отвязать публикацию.');
			setOpenError(true);
		}
	};

	// Функция вычисления прогресса выполнения плана
	const calculateProgress = (plan) => {
		const completed = plan.entries.filter((entry) => entry.publication_id).length;
		const total = plan.expectedCount;
		return total > 0 ? (completed / total) * 100 : 0;
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

					{loadingInitial ? (
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
												<Box sx={{ display: 'flex', gap: 2 }}>
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
													value={type}
													onChange={(e) => setType(e.target.value)}
													margin="normal"
													variant="outlined"
												>
													<MenuItem value="article">Статья</MenuItem>
													<MenuItem value="monograph">Монография</MenuItem>
													<MenuItem value="conference">Доклад/конференция</MenuItem>
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
									<AppleCard sx={{ mt: 2, mb: 2, p: 2, backgroundColor: '#F5F5F7', borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
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
												value={filterType}
												onChange={(e) => setFilterType(e.target.value)}
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
												onChange={(e) => setFilterStatus(e.target.value)}
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
												<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', textAlign: 'center', borderRadius: '0 12px 0 0' }}>
													Действия
												</TableCell>
											</TableRow>
										</TableHead>
										<Fade in={true} timeout={500} key={publicationsTransitionKey}>
											<TableBody>
												{currentPublications.length > 0 ? (
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
																{pub.type === 'article'
																	? 'Статья'
																	: pub.type === 'monograph'
																		? 'Монография'
																		: pub.type === 'conference'
																			? 'Доклад/конференция'
																			: 'Неизвестный тип'}
															</TableCell>
															<TableCell sx={{ color: '#1D1D1F' }}>
																<StatusChip
																	status={
																		pub.status === 'draft' && pub.returned_for_revision
																			? 'returned'
																			: pub.status
																	}
																/>
															</TableCell>
															<TableCell sx={{ textAlign: 'center' }}>
																<Box sx={{ display: 'flex', justifyContent: 'center', gap: 1 }}>
																	{pub.status === 'draft' && (
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
																	{pub.file_url && pub.status !== 'draft' && (
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
																	{!pub.file_url && pub.status === 'draft' && (
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
										</Fade>
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
													'&.Mui-selected': { backgroundColor: '#1976D2', color: 'white', boxShadow: '0 6px 16px rgba(0, 0, 0, 0.2)' },
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
															{Object.entries(pubTypes).map(([type, count]) => (
																<Grid item xs={12} sm={4} key={type}>
																	<AppleCard elevation={1} sx={{ p: 2, borderRadius: '12px', backgroundColor: '#FFFFFF', boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)' }}>
																		<CardContent>
																			<Typography variant="body1" sx={{ color: '#1D1D1F' }}>
																				{type === 'article' ? 'Статьи' : type === 'monograph' ? 'Монографии' : 'Доклады'}: {count}
																			</Typography>
																		</CardContent>
																	</AppleCard>
																</Grid>
															))}
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
															Всего публикаций: {analytics.reduce((sum, item) => sum + item.count, 0)}
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
										<AppleButton
											startIcon={<AddIcon />}
											onClick={() => setOpenCreatePlanDialog(true)}
										>
											Создать план
										</AppleButton>
									</Box>

									{plans.map((plan) => (
										<Accordion
											key={plan.id}
											sx={{
												mb: 2,
												borderRadius: '16px',
												boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
											}}
										>
											<AccordionSummary expandIcon={<ExpandMoreIcon />}>
												<Box sx={{ display: 'flex', justifyContent: 'space-between', width: '100%', alignItems: 'center' }}>
													<Typography variant="h6" sx={{ color: '#1D1D1F' }}>
														План на {plan.year} год (Ожидаемое количество: {plan.expectedCount})
													</Typography>
													<Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
														<StatusChip status={plan.status} />
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
														<PlanTable>
															<TableHead>
																<TableRow>
																	<TableCell>Название</TableCell>
																	<TableCell>Тип</TableCell>
																	<TableCell>Статус</TableCell>
																	<TableCell>Действия</TableCell>
																</TableRow>
															</TableHead>
															<TableBody>
																{plan.entries.map((entry, index) => (
																	<TableRow key={index}>
																		<TableCell>
																			<AppleTextField
																				value={entry.title}
																				onChange={(e) => handlePlanEntryChange(plan.id, index, 'title', e.target.value)}
																				fullWidth
																				variant="outlined"
																			/>
																		</TableCell>
																		<TableCell>
																			<AppleTextField
																				select
																				value={entry.type}
																				onChange={(e) => handlePlanEntryChange(plan.id, index, 'type', e.target.value)}
																				fullWidth
																				variant="outlined"
																			>
																				<MenuItem value="article">Статья</MenuItem>
																				<MenuItem value="monograph">Монография</MenuItem>
																				<MenuItem value="conference">Доклад/конференция</MenuItem>
																			</AppleTextField>
																		</TableCell>
																		<TableCell>
																			<StatusChip status={entry.status} />
																		</TableCell>
																		<TableCell>
																			<IconButton
																				onClick={() => handleDeletePlanEntry(plan.id, index)}
																				sx={{ color: '#FF3B30' }}
																			>
																				<DeleteIcon />
																			</IconButton>
																		</TableCell>
																	</TableRow>
																))}
															</TableBody>
														</PlanTable>
														<Box sx={{ display: 'flex', gap: 2, mt: 2 }}>
															<AppleButton
																startIcon={<AddIcon />}
																onClick={() => handleAddPlanEntry(plan.id)}
															>
																Добавить запись
															</AppleButton>
															<GreenButton
																startIcon={<SaveIcon />}
																onClick={() => handleSavePlan(plan)}
																disabled={!areAllTitlesFilled(plan)}
															>
																Сохранить
															</GreenButton>
														</Box>
													</>
												) : (
													<>
														<LinearProgress
															variant="determinate"
															value={calculateProgress(plan)}
															sx={{ mb: 2, height: 8, borderRadius: 4 }}
														/>
														<PlanTable>
															<TableHead>
																<TableRow>
																	<TableCell>Название</TableCell>
																	<TableCell>Тип</TableCell>
																	<TableCell>Статус</TableCell>
																	<TableCell>Привязанная публикация</TableCell>
																	{plan.status === 'approved' && <TableCell>Действия</TableCell>}
																</TableRow>
															</TableHead>
															<TableBody>
																{plan.entries.map((entry) => (
																	<TableRow key={entry.id}>
																		<TableCell>{entry.title}</TableCell>
																		<TableCell>{entry.type}</TableCell>
																		<TableCell><StatusChip status={entry.status} /></TableCell>
																		<TableCell>
																			{entry.publication_id ? (
																				<Typography
																					sx={{
																						color: '#0071E3',
																						textDecoration: 'underline',
																						cursor: 'pointer',
																						'&:hover': { textDecoration: 'none' },
																					}}
																					onClick={() => navigate(`/publication/${entry.publication_id}`)}
																				>
																					{publishedPublications.find(pub => pub.id === entry.publication_id)?.title || 'Неизвестно'}
																				</Typography>
																			) : (
																				'Не привязана'
																			)}
																		</TableCell>
																		{plan.status === 'approved' && (
																			<TableCell>
																				{entry.publication_id ? (
																					<IconButton
																						onClick={() => handleUnlinkPublication(plan.id, entry.id)}
																						sx={{ color: '#FF3B30' }}
																						title="Отвязать публикацию"
																					>
																						<UnlinkIcon />
																					</IconButton>
																				) : (
																					<IconButton
																						onClick={() => handleOpenLinkDialog(plan.id, entry)}
																						sx={{ color: '#0071E3' }}
																						title="Привязать публикацию"
																					>
																						<LinkIcon />
																					</IconButton>
																				)}
																			</TableCell>
																		)}
																	</TableRow>
																))}
															</TableBody>
														</PlanTable>
														{plan.status === 'approved' && (
															<AppleButton
																startIcon={<AddIcon />}
																onClick={() => handleEditPlanClick(plan.id)}
																sx={{ mt: 2 }}
															>
																Добавить запись
															</AppleButton>
														)}
													</>
												)}
												{plan.return_comment && (
													<Typography sx={{ mt: 2, color: '#FF3B30' }}>
														Комментарий при возврате: {plan.return_comment}
													</Typography>
												)}
											</AccordionDetails>
										</Accordion>
									))}

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
						<Collapse in={passwordError !== ''}>
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
								{passwordError}
							</Alert>
						</Collapse>
						<Collapse in={passwordSuccess !== ''}>
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
								{passwordSuccess}
							</Alert>
						</Collapse>
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
							value={editType}
							onChange={(e) => setEditType(e.target.value)}
							margin="normal"
							variant="outlined"
						>
							<MenuItem value="article">Статья</MenuItem>
							<MenuItem value="monograph">Монография</MenuItem>
							<MenuItem value="conference">Доклад/конференция</MenuItem>
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

			{/* Диалог создания плана */}
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
					<AppleTextField
						label="Ожидаемое количество публикаций"
						type="number"
						value={newPlan.expectedCount}
						onChange={(e) => setNewPlan({ ...newPlan, expectedCount: parseInt(e.target.value) || 1 })}
						fullWidth
						margin="normal"
						variant="outlined"
					/>
				</DialogContent>
				<DialogActions>
					<CancelButton onClick={() => setOpenCreatePlanDialog(false)}>Отмена</CancelButton>
					<AppleButton onClick={handleCreatePlan}>Создать</AppleButton>
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
							{filteredPublishedPublications.map((pub) => (
								<TableRow key={pub.id}>
									<TableCell>{pub.title}</TableCell>
									<TableCell>{pub.authors}</TableCell>
									<TableCell>
										<AppleButton
											onClick={() => handleLinkPublication(selectedPlanEntry.planId, selectedPlanEntry.id, pub.id)}
										>
											Привязать
										</AppleButton>
									</TableCell>
								</TableRow>
							))}
						</TableBody>
					</Table>
				</DialogContent>
				<DialogActions>
					<CancelButton onClick={() => setLinkDialogOpen(false)}>Отмена</CancelButton>
				</DialogActions>
			</Dialog>
		</Container>
	);
}

export default Dashboard;