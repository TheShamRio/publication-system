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
	Tabs,
	Tab,
	Accordion,
	AccordionSummary,
	AccordionDetails,
	Pagination,
} from '@mui/material';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import { useNavigate } from 'react-router-dom';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import AttachFileIcon from '@mui/icons-material/AttachFile';
import DownloadIcon from '@mui/icons-material/Download';
import { styled } from '@mui/system';
import axios from 'axios';
import { useAuth } from '../contexts/AuthContext';

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, BarElement, Title, Tooltip, Legend, Filler);

// Кастомные стили в стиле Apple
const AppleButton = styled(Button)(({ theme }) => ({
	borderRadius: '12px',
	textTransform: 'none',
	backgroundColor: '#0071E3', // Акцентный синий цвет Apple
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
	const { csrfToken } = useAuth(); // Получаем CSRF-токен из контекста
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
	const [openEditDialog, setOpenEditDialog] = useState(false);
	const [editPublication, setEditPublication] = useState(null);
	const [editTitle, setEditTitle] = useState('');
	const [editAuthors, setEditAuthors] = useState('');
	const [editYear, setEditYear] = useState('');
	const [editType, setEditType] = useState('article');
	const [editStatus, setEditStatus] = useState('draft');
	const [editFile, setEditFile] = useState(null);
	const [openEditUserDialog, setOpenEditUserDialog] = useState(false);
	const [editLastName, setEditLastName] = useState('');
	const [editFirstName, setEditFirstName] = useState('');
	const [editMiddleName, setEditMiddleName] = useState('');
	const [user, setUser] = useState(null);
	const [loadingUser, setLoadingUser] = useState(true);
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
	const [pubStatuses, setPubStatuses] = useState({ draft: 0, review: 0, published: 0 });
	const [totalCitations, setTotalCitations] = useState(0);
	const [searchQuery, setSearchQuery] = useState(''); // Для поиска
	const [filterType, setFilterType] = useState('all'); // Фильтр по типу
	const [filterStatus, setFilterStatus] = useState('all'); // Фильтр по статусу
	const [currentPage, setCurrentPage] = useState(1); // Текущая страница
	const [totalPages, setTotalPages] = useState(1); // Общее количество страниц (новое состояние)
	const publicationsPerPage = 10; // Публикаций на страницу
	const navigate = useNavigate();
	const chartRef = useRef(null);

	const validPublicationTypes = ['article', 'monograph', 'conference']; // Допустимые типы публикаций

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
					per_page: 9999, // Запрашиваем все публикации за один запрос
					search: '',
					type: 'all',
					status: 'all'
				}
			});
			return pubResponse.data.publications; // Возвращаем все публикации текущего пользователя
		} catch (err) {
			console.error('Ошибка загрузки всех публикаций:', err);
			if (err.response?.status === 401) {
				setError('Необходимо войти в систему. Перенаправление...');
				setTimeout(() => navigate('/login'), 2000);
			} else if (err.response?.status === 403 || err.response?.status === 500) {
				setError('Произошла ошибка сервера. Попробуйте позже.');
			}
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
					status
				}
			});
			setPublications(pubResponse.data.publications); // Сохраняем только текущие публикации для этой страницы
			setFilteredPublications(pubResponse.data.publications); // Устанавливаем текущие данные для отображения
			setCurrentPage(page); // Устанавливаем текущую страницу

			// Используем total из серверного ответа для вычисления totalPages
			const total = pubResponse.data.total || 0;
			const calculatedTotalPages = Math.ceil(total / publicationsPerPage);
			setTotalPages(calculatedTotalPages); // Устанавливаем totalPages на основе серверного total

			// Проверяем, чтобы currentPage не превышал totalPages
			if (page > calculatedTotalPages && calculatedTotalPages > 0) {
				setCurrentPage(1);
				fetchData(1, search, pubType, status);
				return;
			}

			// Обновляем аналитику на основе всех публикаций текущего пользователя
			const allPublications = await fetchAllPublications();
			updateAnalytics(allPublications);

			console.log('Server response for page', page, ':', pubResponse.data); // Отладочная информация
		} catch (err) {
			console.error('Ошибка загрузки данных:', err);
			if (err.response?.status === 401) {
				setError('Необходимо войти в систему. Перенаправление...');
				setTimeout(() => navigate('/login'), 2000);
			} else if (err.response?.status === 403 || err.response?.status === 500) {
				setError('Произошла ошибка сервера. Попробуйте позже.');
			}
			setOpenError(true);
		}
	};

	const fetchUserData = async () => {
		setLoadingUser(true);
		try {
			const response = await axios.get('http://localhost:5000/api/user', { withCredentials: true });
			setUser(response.data);
		} catch (err) {
			console.error('Ошибка загрузки данных пользователя:', err);
			if (err.response?.status === 401) {
				setError('Необходимо войти в систему. Перенаправление...');
				setTimeout(() => navigate('/login'), 2000);
			}
		} finally {
			setLoadingUser(false);
		}
	};

	const updateAnalytics = (allPublications) => {
		const types = { article: 0, monograph: 0, conference: 0 };
		const statuses = { draft: 0, review: 0, published: 0 };
		let citations = 0;

		allPublications.forEach((pub) => {
			const pubType = validPublicationTypes.includes(pub.type) ? pub.type : 'article'; // Если тип неизвестен, используем 'article'
			types[pubType] = (types[pubType] || 0) + 1;
			statuses[pub.status] = (statuses[pub.status] || 0) + 1;
			if (pub.citations) citations += pub.citations;
		});

		setPubTypes(types);
		setPubStatuses(statuses);
		setTotalCitations(citations);

		// Группируем публикации по годам для графика
		const yearlyAnalytics = allPublications.reduce((acc, pub) => {
			acc[pub.year] = (acc[pub.year] || 0) + 1;
			return acc;
		}, {});
		const analyticsData = Object.entries(yearlyAnalytics).map(([year, count]) => ({ year: parseInt(year), count }));
		analyticsData.sort((a, b) => a.year - b.year); // Сортируем по годам
		setAnalytics(analyticsData);
	};

	useEffect(() => {
		fetchData(1, searchQuery, filterType, filterStatus); // Загружаем первую страницу с текущими фильтрами
		fetchUserData();
	}, [navigate, searchQuery, filterType, filterStatus]);

	// Пагинация: теперь просто используем filteredPublications напрямую, так как сервер уже выполняет пагинацию
	const currentPublications = filteredPublications; // Убираем slice, полагаясь на серверную пагинацию

	const handlePageChange = (event, newPage) => {
		fetchData(newPage, searchQuery, filterType, filterStatus);
	};

	const handleChangePasswordClick = () => {
		setOpenChangePasswordDialog(true);
		setCurrentPassword('');
		setNewPassword('');
		setPasswordError('');
		setPasswordSuccess('');
	};

	const handleChangePasswordSubmit = async (e) => {
		e.preventDefault();
		try {
			console.log('Changing password for user:', user?.username);
			const response = await axios.put('http://localhost:5000/api/user/password', {
				current_password: currentPassword,
				new_password: newPassword,
			}, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken }, // Добавляем CSRF-токен
			});

			setPasswordSuccess('Пароль успешно обновлен!');
			setPasswordError('');
			setOpenChangePasswordDialog(false);
			setCurrentPassword('');
			setNewPassword('');
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
			setError(
				'Год должен быть числом и находиться в разумных пределах (например, 1900–' + new Date().getFullYear() + ').'
			);
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
			console.log('Uploading file with data:', { title, authors, year, type });
			const response = await axios.post('http://localhost:5000/api/publications/upload-file', formData, {
				withCredentials: true,
				headers: {
					'Content-Type': 'multipart/form-data',
					'X-CSRFToken': csrfToken, // Добавляем CSRF-токен
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
				setError(
					`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте введенные поля и файл.'}`
				);
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
			console.log('Uploading BibTeX file');
			const response = await axios.post('http://localhost:5000/api/publications/upload-bibtex', formData, {
				withCredentials: true,
				headers: {
					'Content-Type': 'multipart/form-data',
					'X-CSRFToken': csrfToken, // Добавляем CSRF-токен
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
		setEditPublication(publication || {}); // Устанавливаем пустой объект, если publication null
		setEditTitle(publication?.title || '');
		setEditAuthors(publication?.authors || '');
		setEditYear(publication?.year || '');
		setEditType(validPublicationTypes.includes(publication?.type) ? publication.type : 'article'); // Исправляем тип
		setEditStatus(publication?.status || 'draft');
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
			data.append('status', editStatus || 'draft');
			headers['Content-Type'] = 'multipart/form-data';
			headers['X-CSRFToken'] = csrfToken; // Добавляем CSRF-токен
		} else {
			data = {
				title: editTitle.trim() || '',
				authors: editAuthors.trim() || '',
				year: editYear ? parseInt(editYear, 10) : '',
				type: editType || 'article',
				status: editStatus || 'draft'
			};
			headers['Content-Type'] = 'application/json';
			headers['X-CSRFToken'] = csrfToken; // Добавляем CSRF-токен
		}

		// Проверка: нельзя установить статус "published", если файл не прикреплён
		if (editStatus === 'published' && !editPublication.file_url && !editFile) {
			setError('Нельзя опубликовать работу без прикреплённого файла.');
			setOpenError(true);
			return;
		}

		try {
			console.log('Updating publication with:', {
				title: editTitle,
				authors: editAuthors,
				year: editYear,
				type: editType,
				status: editStatus,
				file: editFile ? editFile.name : 'No new file'
			});
			const response = await axios.put(
				`http://localhost:5000/api/publications/${editPublication.id || ''}`,
				data,
				{ withCredentials: true, headers }
			);
			setSuccess('Публикация успешно отредактирована!');
			setOpenSuccess(true);
			setError('');
			await fetchData();
			setOpenEditDialog(false);
		} catch (err) {
			console.error('Ошибка редактирования публикации:', err.response?.data || err);
			if (err.response) {
				setError(
					`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте введенные поля.'}`
				);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			if (err.response?.status === 401) {
				navigate('/login');
			} else if (err.response?.status === 403) {
				setError('У вас нет прав на редактирование этой публикации.');
			}
			setOpenError(true);
			setSuccess('');
		}
	};

	const handleEditCancel = () => {
		setOpenEditDialog(false);
		setEditPublication(null);
		setEditTitle('');
		setEditAuthors('');
		setEditYear('');
		setEditType('article');
		setEditStatus('draft');
		setEditFile(null);
	};

	const handleDeleteClick = (publication) => {
		console.log('Deleting publication:', publication.id);
		setPublicationToDelete(publication);
		setOpenDeleteDialog(true);
	};

	const handleDeleteConfirm = async () => {
		if (!publicationToDelete) return;

		try {
			console.log('Confirming deletion of publication:', publicationToDelete.id);
			const response = await axios.delete(`http://localhost:5000/api/publications/${publicationToDelete.id}`, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken }, // Добавляем CSRF-токен
			});
			setSuccess('Публикация успешно удалена!');
			setOpenSuccess(true);
			setError('');
			await fetchData();
		} catch (err) {
			console.error('Ошибка удаления публикации:', err.response?.data || err);
			if (err.response) {
				setError(
					`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте права доступа.'}`
				);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			if (err.response?.status === 401) {
				navigate('/login');
			} else if (err.response?.status === 403) {
				setError('У вас нет прав на удаление этой публикации.');
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
	};

	const handleEditUserClick = () => {
		setEditLastName(user?.last_name || '');
		setEditFirstName(user?.first_name || '');
		setEditMiddleName(user?.middle_name || '');
		setOpenEditUserDialog(true);
	};

	const handleEditUserSubmit = async (e) => {
		e.preventDefault();
		try {
			console.log('Updating user data:', { last_name: editLastName, first_name: editFirstName, middle_name: editMiddleName });
			const response = await axios.put('http://localhost:5000/api/user', {
				last_name: editLastName.trim() || null,
				first_name: editFirstName.trim() || null,
				middle_name: editMiddleName.trim() || null,
			}, {
				withCredentials: true,
				headers: { 'X-CSRFToken': csrfToken }, // Добавляем CSRF-токен
			});
			setSuccess('Личные данные успешно обновлены!');
			setOpenSuccess(true);
			setError('');
			setUser(response.data.user);
			setOpenEditUserDialog(false);
		} catch (err) {
			console.error('Ошибка редактирования данных:', err.response?.data || err);
			if (err.response) {
				setError(
					`Ошибка: ${err.response.status} - ${err.response.data?.error || 'Проверьте введенные поля.'}`
				);
			} else {
				setError('Ошибка сети. Проверьте подключение и сервер.');
			}
			if (err.response?.status === 400) {
				setError('Некорректные данные. Проверьте введенные поля.');
			} else if (err.response?.status === 401) {
				navigate('/login');
			} else if (err.response?.status === 500) {
				setError('Произошла ошибка сервера. Попробуйте позже.');
			}
			setOpenError(true);
			setSuccess('');
		}
	};

	const handleEditUserCancel = () => {
		setOpenEditUserDialog(false);
		setEditLastName('');
		setEditFirstName('');
		setEditMiddleName('');
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
			console.log('Sending attach file request for publication:', publicationToAttach.id);
			const response = await axios.post(`http://localhost:5000/api/publications/${publicationToAttach.id}/attach-file`, formData, {
				withCredentials: true,
				headers: {
					'Content-Type': 'multipart/form-data',
					'X-CSRFToken': csrfToken, // Добавляем CSRF-токен
				},
			});
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
			if (err.response?.status === 400) {
				setAttachError('Некорректный файл. Проверьте формат (PDF/DOCX).');
			} else if (err.response?.status === 401) {
				navigate('/login');
			} else if (err.response?.status === 403) {
				setAttachError('У вас нет прав на изменение этой публикации.');
			} else if (err.response?.status === 500) {
				setAttachError('Произошла ошибка сервера. Попробуйте позже.');
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

	return (
		<Container
			maxWidth="lg"
			sx={{
				mt: 4,
				minHeight: 'calc(100vh - 64px)',
				backgroundColor: '#FFFFFF',
				borderRadius: '16px',
				boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
				fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif"
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
							textAlign: 'center'
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
								'&.Mui-selected': { color: '#1D1D1F', backgroundColor: '#F5F5F7' }
							},
							'& .MuiTabs-indicator': { backgroundColor: '#0071E3' }
						}}
					>
						<Tab label="Личные данные" />
						<Tab label="Публикации" />
						<Tab label="Аналитика" />
						<Tab label="Экспорт" />
					</Tabs>

					{value === 0 && (
						<Accordion
							defaultExpanded
							sx={{
								boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
								borderRadius: '16px',
								backgroundColor: '#FFFFFF'
							}}
						>
							<AccordionSummary
								expandIcon={<ExpandMoreIcon sx={{ color: '#FFFFFF' }} />}
								sx={{ backgroundColor: '#0071E3', borderRadius: '16px' }}
							>
								<Typography variant="h5" sx={{ color: '#FFFFFF' }}>
									Личные данные
								</Typography>
							</AccordionSummary>
							<AccordionDetails sx={{ p: 3 }}>
								{loadingUser ? (
									<Typography sx={{ color: '#6E6E73' }}>Загрузка данных...</Typography>
								) : user ? (
									<Box>
										<Typography variant="body1" sx={{ color: '#1D1D1F', mb: 2 }}>
											ФИО: {user.last_name} {user.first_name} {user.middle_name || ''}
										</Typography>
										<Typography variant="body1" sx={{ color: '#1D1D1F', mb: 2 }}>
											Логин: {user.username}
										</Typography>
										<Box sx={{ display: 'flex', gap: 2 }}>
											<AppleButton
												onClick={handleEditUserClick}
											>
												Редактировать данные
											</AppleButton>
											<AppleButton
												onClick={handleChangePasswordClick}
											>
												Изменить пароль
											</AppleButton>
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
									textAlign: 'center'
								}}
							>
								Загрузка публикаций
							</Typography>
							<AppleCard
								sx={{
									mb: 4,
									p: 3,
									backgroundColor: '#F5F5F7',
									borderRadius: '16px',
									boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)'
								}}
							>
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
												<AppleButton
													component="span"
													sx={{
														border: '1px solid #D1D1D6',
														backgroundColor: '#F5F5F7',
														color: '#1D1D1F',
													}}
												>
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
										<AppleButton
											type="submit"
											sx={{ mt: 2 }}
										>
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
												<AppleButton
													component="span"
													sx={{
														border: '1px solid #D1D1D6',
														backgroundColor: '#F5F5F7',
														color: '#1D1D1F',
													}}
												>
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
										<AppleButton
											type="submit"
											sx={{ mt: 2 }}
										>
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
									textAlign: 'center'
								}}
							>
								Ваши публикации
							</Typography>
							{/* Панель поиска и фильтрации в стиле Apple */}
							<AppleCard sx={{ mt: 2, mb: 2, p: 2, backgroundColor: '#F5F5F7', borderRadius: '16px', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
								<AppleTextField
									fullWidth
									label="Поиск по названию, авторам или году"
									value={searchQuery}
									onChange={(e) => setSearchQuery(e.target.value)}
									margin="normal"
									variant="outlined"
									InputProps={{
										endAdornment: (
											<IconButton sx={{ color: '#0071E3' }}>
												{/* Можно добавить иконку поиска, например, SearchIcon из @mui/icons-material */}
											</IconButton>
										),
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
										<MenuItem value="review">На проверке</MenuItem>
										<MenuItem value="published">Опубликованные</MenuItem>
									</AppleTextField>
								</Box>
							</AppleCard>
							<AppleTable
								sx={{
									mt: 2,
									boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
								}}
							>
								<TableHead>
									<TableRow sx={{ backgroundColor: '#0071E3' }}>
										<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', borderRadius: '12px 0 0 0' }}>ID</TableCell>
										<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Название</TableCell>
										<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Авторы</TableCell>
										<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Год</TableCell>
										<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Тип</TableCell>
										<TableCell sx={{ fontWeight: 600, color: '#FFFFFF' }}>Статус</TableCell>
										<TableCell sx={{ fontWeight: 600, color: '#FFFFFF', textAlign: 'center', borderRadius: '0 12px 0 0' }}>Действия</TableCell>
									</TableRow>
								</TableHead>
								<TableBody>
									{currentPublications.length > 0 ? (
										currentPublications.map((pub) => (
											<TableRow
												key={pub.id}
												sx={{
													'&:hover': { backgroundColor: '#F5F5F7', transition: 'background-color 0.3s ease' }
												}}
											>
												<TableCell sx={{ color: '#1D1D1F' }}>{pub.id}</TableCell>
												<TableCell sx={{ color: '#1D1D1F' }}>{pub.title}</TableCell>
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
													{pub.status === 'draft'
														? 'Черновик'
														: pub.status === 'review'
															? 'На проверке'
															: pub.status === 'published'
																? 'Опубликованные'
																: pub.status}
												</TableCell>
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
																}
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
																}
															}}
														>
															<DeleteIcon />
														</IconButton>
														{!pub.file_url ? (
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
																	}
																}}
															>
																<AttachFileIcon />
															</IconButton>
														) : (
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
																	}
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
											<TableCell colSpan={7} sx={{ textAlign: 'center', color: '#6E6E73' }}>
												Нет доступных публикаций на этой странице.
											</TableCell>
										</TableRow>
									)}
								</TableBody>
							</AppleTable>
							{/* Пагинация в стиле Apple с отладочной информацией */}
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
									textAlign: 'center'
								}}
							>
								Аналитика публикаций
							</Typography>
							{analytics.length === 0 ? (
								<AppleCard
									elevation={2}
									sx={{
										p: 4,
										mt: 2,
										borderRadius: '16px',
										backgroundColor: '#FFFFFF',
										boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)'
									}}
								>
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
												'&:hover': { color: '#0066CC', backgroundColor: 'transparent' }
											}}
										>
											Загрузите публикации
										</AppleButton>
										, чтобы вести аналитику по своим работам.
									</Typography>
								</AppleCard>
							) : (
								<AppleCard
									elevation={2}
									sx={{
										p: 4,
										mt: 2,
										borderRadius: '16px',
										backgroundColor: '#FFFFFF',
										boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)'
									}}
								>
									<CardContent>
										<Typography variant="h6" sx={{ color: '#1D1D1F', mb: 2 }}>
											Динамика публикаций
										</Typography>
										<Box sx={{ mb: 4, height: '300px' }}>
											<Line
												data={chartData}
												options={chartOptions}
												ref={chartRef}
												key={analytics.map((item) => item.year).join('-')}
											/>
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
															<AppleCard
																elevation={1}
																sx={{
																	p: 2,
																	borderRadius: '12px',
																	backgroundColor: '#FFFFFF',
																	boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)'
																}}
															>
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
															<AppleCard
																elevation={1}
																sx={{
																	p: 2,
																	borderRadius: '12px',
																	backgroundColor: '#FFFFFF',
																	boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)'
																}}
															>
																<CardContent>
																	<Typography variant="body1" sx={{ color: '#1D1D1F' }}>
																		{status === 'draft' ? 'Черновики' : status === 'review' ? 'На проверке' : 'Опубликованные'}: {count}
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
						<Box sx={{ mt: 4 }}>
							<Typography
								variant="h5"
								gutterBottom
								sx={{
									mt: 4,
									color: '#1D1D1F',
									fontWeight: 600,
									textAlign: 'center'
								}}
							>
								Экспорт публикаций
							</Typography>
							<AppleButton
								onClick={handleExportBibTeX}
								sx={{ mt: 2 }}
							>
								Выгрузить публикации в BibTeX
							</AppleButton>
						</Box>
					)}

					<Dialog
						open={openDeleteDialog}
						onClose={handleDeleteCancel}
						sx={{
							'& .MuiDialog-paper': {
								backgroundColor: '#FFFFFF',
								boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
								borderRadius: '16px',
								fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif"
							}
						}}
					>
						<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600, borderBottom: '1px solid #E5E5EA' }}>
							Подтвердите удаление
						</DialogTitle>
						<DialogContent sx={{ padding: '24px' }}>
							<Typography sx={{ color: '#6E6E73' }}>
								Вы уверены, что хотите удалить публикацию «{publicationToDelete?.title}»?
							</Typography>
						</DialogContent>
						<DialogActions sx={{ padding: '16px 24px', borderTop: '1px solid #E5E5EA' }}>
							<CancelButton onClick={handleDeleteCancel}>
								Отмена
							</CancelButton>
							<AppleButton
								onClick={handleDeleteConfirm}
							>
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
								fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif"
							}
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
									disabled={!editPublication?.file_url && !editFile} // Проверяем editPublication?.file_url
								>
									<MenuItem value="draft">Черновик</MenuItem>
									<MenuItem value="review">На проверке</MenuItem>
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
										<AppleButton
											component="span"
											sx={{
												border: '1px solid #D1D1D6',
												backgroundColor: '#F5F5F7',
												color: '#1D1D1F',
											}}
										>
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
									<CancelButton onClick={handleEditCancel}>
										Отмена
									</CancelButton>
									<AppleButton
										type="submit"
									>
										Сохранить
									</AppleButton>
								</DialogActions>
							</form>
						</DialogContent>
					</Dialog>

					<Dialog
						open={openEditUserDialog}
						onClose={handleEditUserCancel}
						sx={{
							'& .MuiDialog-paper': {
								backgroundColor: '#FFFFFF',
								boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
								borderRadius: '16px',
								fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif"
							}
						}}
					>
						<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600, borderBottom: '1px solid #E5E5EA' }}>
							Редактировать личные данные
						</DialogTitle>
						<DialogContent sx={{ padding: '24px' }}>
							<form onSubmit={handleEditUserSubmit}>
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
									<CancelButton onClick={handleEditUserCancel}>
										Отмена
									</CancelButton>
									<AppleButton
										type="submit"
									>
										Сохранить
									</AppleButton>
								</DialogActions>
							</form>
						</DialogContent>
					</Dialog>

					<Dialog
						open={openAttachFileDialog}
						onClose={handleAttachFileCancel}
						sx={{
							'& .MuiDialog-paper': {
								backgroundColor: '#FFFFFF',
								boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
								borderRadius: '16px',
								fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif"
							}
						}}
					>
						<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600, borderBottom: '1px solid #E5E5EA' }}>
							Прикрепить файл к публикации
						</DialogTitle>
						<DialogContent sx={{ padding: '24px' }}>
							<Box sx={{ mt: 2, mb: 2 }}>
								<input
									type="file"
									accept=".pdf,.docx"
									onChange={(e) => setAttachFile(e.target.files[0])}
									style={{ display: 'none' }}
									id="attach-file"
								/>
								<label htmlFor="attach-file">
									<AppleButton
										component="span"
										sx={{
											border: '1px solid #D1D1D6',
											backgroundColor: '#F5F5F7',
											color: '#1D1D1F',
										}}
									>
										Выбрать файл
									</AppleButton>
								</label>
								{attachFile && <Typography sx={{ mt: 1, color: '#6E6E73' }}>{attachFile.name}</Typography>}
							</Box>
							<Collapse in={!!attachError}>
								{attachError && (
									<Alert
										severity="error"
										sx={{
											mb: 2,
											borderRadius: '12px',
											backgroundColor: '#FFF1F0',
											color: '#1D1D1F',
											boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
										}}
										onClose={() => setAttachError('')}
									>
										{attachError}
									</Alert>
								)}
							</Collapse>
							<Collapse in={!!attachSuccess}>
								{attachSuccess && (
									<Alert
										severity="success"
										sx={{
											mb: 2,
											borderRadius: '12px',
											backgroundColor: '#E7F8E7',
											color: '#1D1D1F',
											boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
										}}
										onClose={() => setAttachSuccess('')}
									>
										{attachSuccess}
									</Alert>
								)}
							</Collapse>
							<DialogActions sx={{ padding: '16px 24px', borderTop: '1px solid #E5E5EA' }}>
								<CancelButton onClick={handleAttachFileCancel}>
									Отмена
								</CancelButton>
								<AppleButton
									onClick={handleAttachFileSubmit}
								>
									Прикрепить
								</AppleButton>
							</DialogActions>
						</DialogContent>
					</Dialog>

					<Dialog
						open={openChangePasswordDialog}
						onClose={handleChangePasswordCancel}
						sx={{
							'& .MuiDialog-paper': {
								backgroundColor: '#FFFFFF',
								boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
								borderRadius: '16px',
								fontFamily: "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif"
							}
						}}
					>
						<DialogTitle sx={{ color: '#1D1D1F', fontWeight: 600, borderBottom: '1px solid #E5E5EA' }}>
							Изменить пароль
						</DialogTitle>
						<DialogContent sx={{ padding: '24px' }}>
							<form onSubmit={handleChangePasswordSubmit}>
								<AppleTextField
									fullWidth
									label="Текущий пароль"
									type="password"
									value={currentPassword}
									onChange={(e) => setCurrentPassword(e.target.value)}
									margin="normal"
									variant="outlined"
									autoComplete="current-password"
								/>
								<AppleTextField
									fullWidth
									label="Новый пароль"
									type="password"
									value={newPassword}
									onChange={(e) => setNewPassword(e.target.value)}
									margin="normal"
									variant="outlined"
									autoComplete="new-password"
								/>
								<Collapse in={!!passwordError}>
									{passwordError && (
										<Alert
											severity="error"
											sx={{
												mb: 2,
												borderRadius: '12px',
												backgroundColor: '#FFF1F0',
												color: '#1D1D1F',
												boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
											}}
											onClose={() => setPasswordError('')}
										>
											{passwordError}
										</Alert>
									)}
								</Collapse>
								<Collapse in={!!passwordSuccess}>
									{passwordSuccess && (
										<Alert
											severity="success"
											sx={{
												mb: 2,
												borderRadius: '12px',
												backgroundColor: '#E7F8E7',
												color: '#1D1D1F',
												boxShadow: '0 2px 4px rgba(0, 0, 0, 0.05)',
											}}
											onClose={() => setPasswordSuccess('')}
										>
											{passwordSuccess}
										</Alert>
									)}
								</Collapse>
								<DialogActions sx={{ padding: '16px 0', borderTop: '1px solid #E5E5EA' }}>
									<CancelButton onClick={handleChangePasswordCancel}>
										Отмена
									</CancelButton>
									<AppleButton
										type="submit"
									>
										Сохранить
									</AppleButton>
								</DialogActions>
							</form>
						</DialogContent>
					</Dialog>
				</CardContent>
			</AppleCard>
		</Container>
	);
}

export default Dashboard;