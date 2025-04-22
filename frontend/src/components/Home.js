import React, { useState, useEffect } from 'react';
import {
	Container,
	Typography,
	TextField,
	Box,
	Grid,
	Card,
	Button,
	Select,
	MenuItem,
	FormControl,
	InputLabel,
	IconButton,
	Alert,
	Collapse,
	List,
	ListItem,
	ListItemText,
	Pagination,
} from '@mui/material';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import SearchIcon from '@mui/icons-material/Search';
import { styled } from '@mui/system';

// Стили для поля поиска
const SearchInput = styled(TextField)({
	'& .MuiInputBase-root': {
		borderRadius: 16,
		height: '48px',
		width: '100%',
		boxShadow: '0 2px 8px rgba(0, 0, 0, 0.05)',
	},
	'& .MuiInputBase-input': {
		padding: '8px 16px',
		fontSize: '16px',
	},
	'&:hover': {
		boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)',
		transition: 'all 0.3s ease',
	},
});

function Home() {
	const [searchTerm, setSearchTerm] = useState('');
	const [filterDisplayNameId, setFilterDisplayNameId] = useState(''); // Используем ID русского названия
	const [filterYear, setFilterYear] = useState('');
	const [publications, setPublications] = useState([]);
	const [publicationTypes, setPublicationTypes] = useState([]);
	const [error, setError] = useState('');
	const [success, setSuccess] = useState('');
	const [openError, setOpenError] = useState(false);
	const [openSuccess, setOpenSuccess] = useState(false);
	const [currentPage, setCurrentPage] = useState(1);
	const [totalPages, setTotalPages] = useState(1);
	const publicationsPerPage = 10;
	const navigate = useNavigate();

	// Функция форматирования времени
	const formatTimeAgo = (dateStr) => {
		// ... (rest of the function remains the same)
		if (!dateStr) return 'Неизвестное время';

		const date = new Date(dateStr);
		const now = new Date();
		const diffMs = now - date;
		const diffMinutes = Math.floor(diffMs / 60000);
		const diffHours = Math.floor(diffMs / 3600000);
		const diffDays = Math.floor(diffMs / 86400000);

		if (diffMinutes < 60) {
			if (diffMinutes === 1) return '1 минуту назад';
			if (diffMinutes >= 2 && diffMinutes <= 4) return `${diffMinutes} минуты назад`;
			return `${diffMinutes} минут назад`;
		}

		if (diffHours < 24) {
			if (diffHours === 1) return '1 час назад';
			if (diffHours >= 2 && diffHours <= 4) return `${diffHours} часа назад`;
			return `${diffHours} часов назад`;
		}

		if (diffDays === 1) return '1 день назад';
		return `${diffDays} дней назад`;
	};

	// Загрузка типов публикаций
	useEffect(() => {
		const fetchPublicationTypes = async () => {
			try {
				const response = await axios.get('http://localhost:5000/api/publication-types', {
					withCredentials: true,
				});
				setPublicationTypes(response.data);
			} catch (err) {
				console.error('Ошибка загрузки типов публикаций:', err);
				setError('Не удалось загрузить типы публикаций.');
				setOpenError(true);
			}
		};

		fetchPublicationTypes();
	}, []);

	// Загрузка публикаций
	useEffect(() => {
		const fetchPublishedPublications = async () => {
			try {
				const params = {
					page: currentPage,
					per_page: publicationsPerPage,
					search: searchTerm || undefined,
					year: filterYear || undefined,
					display_name_id: filterDisplayNameId || undefined, // <--- Отправляем ID русского названия
				};
				console.log("Sending params to backend:", params); // Для отладки

				const response = await axios.get('http://localhost:5000/api/public/publications', {
					withCredentials: true,
					params: params,
				});
				console.log('Server response for publications:', response.data);
				setPublications(response.data.publications || []);
				setTotalPages(response.data.pages || 1);
				setCurrentPage(response.data.current_page || 1);
			} catch (err) {
				console.error('Ошибка загрузки публикаций:', err);
				setError('Произошла ошибка при загрузке данных. Попробуйте позже.');
				setOpenError(true);
			}
		};

		fetchPublishedPublications();
	}, [searchTerm, filterDisplayNameId, filterYear, currentPage]); // <--- Зависимость от filterDisplayNameId

	// Обработчик смены страницы
	const handlePageChange = (event, newPage) => {
		setCurrentPage(newPage);
	};

	// Обработчик применения фильтров
	const handleFilterChange = () => {
		setCurrentPage(1); // Reset to first page when filters change
	};

	return (
		<Container maxWidth="lg" sx={{ mt: 4, minHeight: 'calc(100vh - 64px)', backgroundColor: 'white', borderRadius: 20, boxShadow: '0 12px 32px rgba(0, 0, 0, 0.15)' }}>
			<Box sx={{ p: 4 }}>
				{/* ... Title and Description ... */}
				<Typography variant="h2" gutterBottom sx={{ color: '#212121', fontWeight: 700, textAlign: 'center', mb: 2 }}>
					Добро пожаловать в Систему Публикаций
				</Typography>
				<Typography variant="body1" sx={{ color: '#757575', textAlign: 'center', mb: 4 }}>
					Эффективно управляйте научными публикациями и отслеживайте академическую активность.
				</Typography>

				<Box sx={{ mb: 4, p: 3, backgroundColor: 'grey.50', borderRadius: 16, boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)' }}>
					<SearchInput
						fullWidth
						label="Поиск научных работ"
						value={searchTerm}
						onChange={(e) => setSearchTerm(e.target.value)}
						variant="outlined"
						InputProps={{
							endAdornment: (
								<IconButton sx={{ color: '#1976D2', transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.1)', boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)' } }}>
									<SearchIcon />
								</IconButton>
							),
						}}
						sx={{ mb: 2 }}
					/>

					<Grid container spacing={2} sx={{ mb: 2 }}>
						<Grid item xs={12} sm={4}>
							<FormControl fullWidth variant="outlined" sx={{ borderRadius: 16, boxShadow: '0 2px 8px rgba(0, 0, 0, 0.05)' }}>
								<InputLabel>Тип</InputLabel>
								<Select
									value={filterDisplayNameId} // <--- Используем filterDisplayNameId
									onChange={(e) => setFilterDisplayNameId(e.target.value)} // <--- Используем setFilterDisplayNameId
									label="Тип"
									sx={{ borderRadius: 16, '&:hover': { boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)' } }}
								>
									<MenuItem value="">Все</MenuItem>
									{/* Используем display_name_id как ключ и значение */}
									{publicationTypes.map((type) => (
										<MenuItem key={type.display_name_id} value={type.display_name_id}>
											{type.display_name} {/* Отображаем русское название */}
										</MenuItem>
									))}
								</Select>
							</FormControl>
						</Grid>
						<Grid item xs={12} sm={4}>
							{/* Status field remains the same */}
							<FormControl fullWidth variant="outlined" sx={{ borderRadius: 16, bgcolor: 'grey.100', boxShadow: '0 2px 8px rgba(0, 0, 0, 0.05)' }}>
								<InputLabel>Статус</InputLabel>
								<Select
									value="published"
									disabled
									label="Статус"
									sx={{ borderRadius: 16, '& .MuiSelect-select': { color: '#212121' }, '&:hover': { boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)' } }}
								>
									<MenuItem value="published">Опубликовано</MenuItem>
								</Select>
							</FormControl>
						</Grid>
						<Grid item xs={12} sm={4}>
							<TextField
								fullWidth
								label="Год"
								type="number"
								value={filterYear}
								onChange={(e) => setFilterYear(e.target.value)}
								variant="outlined"
								// Apply styles similar to FormControl/Select using the sx prop
								sx={{
									'& .MuiOutlinedInput-root': { // Target the root of the outlined input
										borderRadius: 16,
										boxShadow: '0 2px 8px rgba(0, 0, 0, 0.05)',
										backgroundColor: 'white', // Explicitly set background to match if needed
										transition: 'box-shadow 0.3s ease',
										height: '42px',
										'&:hover': {
											boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)',
										},
										// Optional: Style the border on hover to prevent default changes if desired
										'&:hover .MuiOutlinedInput-notchedOutline': {
											// borderColor: 'rgba(0, 0, 0, 0.23)', // Keep default hover border or customize
										},
										// Optional: Style the border on focus
										'&.Mui-focused .MuiOutlinedInput-notchedOutline': {
											// borderColor: '#1976D2', // Keep default focus border or customize
											// borderWidth: '1px', // Ensure consistent border width
										}
									},
									'& .MuiInputLabel-root': { // Style label if needed
										// color: '#757575',
									},
									'& .MuiInputLabel-root.Mui-focused': { // Style focused label if needed
										// color: '#1976D2',
									}
								}}
							/>
						</Grid>
						<Grid item xs={12}>
							<Button
								variant="contained"
								color="primary"
								onClick={handleFilterChange} // Use handleFilterChange here to reset page
								sx={{ mt: 2, borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)', boxShadow: '0 6px 16px rgba(0, 0, 0, 0.2)' } }}
							>
								Применить фильтры
							</Button>
						</Grid>
					</Grid>
				</Box>

				{/* ... Rest of the component ... */}
				<Typography variant="h5" gutterBottom sx={{ mt: 4, color: '#212121', fontWeight: 600, textAlign: 'center' }}>
					Последние опубликованные работы
				</Typography>
				<Card sx={{ mt: 2, mb: 4, borderRadius: 20, boxShadow: '0 12px 32px rgba(0, 0, 0, 0.15)', backgroundColor: 'white' }}>
					{publications.length === 0 ? (
						<Box sx={{ p: 3, textAlign: 'center', color: '#757575' }}>
							<Typography variant="h6" sx={{ fontWeight: 500 }}>
								Увы, ничего не нашлось
							</Typography>
						</Box>
					) : (
						<List sx={{ width: '100%', backgroundColor: 'white', p: 3 }}>
							{publications.map((pub) => (
								<ListItem
									key={pub.id}
									sx={{
										borderRadius: 5,
										padding: 3,
										borderBottom: '1px solid',
										borderColor: '#e0e0e0',
										'&:hover': { backgroundColor: 'grey.50', transition: 'all 0.3s ease', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)' },
									}}
								>
									<ListItemText
										primary={
											<Typography variant="h6" sx={{ color: '#1976D2', fontWeight: 500 }}>
												{pub.title}
											</Typography>
										}
										secondary={
											<React.Fragment>
												<Typography variant="body2" component="span" sx={{ color: '#757575', display: 'block', mt: 0.5 }}>
													Год: {pub.year}
												</Typography>
												<Typography variant="body2" component="span" sx={{ color: '#757575', display: 'block', mt: 0.5 }}>
													Авторы: {Array.isArray(pub.authors) && pub.authors.length > 0
														? pub.authors.map(author => author.name).join(', ') // Извлекаем имена и соединяем через запятую
														: 'Авторы не указаны' // Запасной текст, если авторов нет
													}
												</Typography>
												<Typography variant="body2" component="span" sx={{ color: '#757575', display: 'block', mt: 0.5 }}>
													Тип: {pub.type.display_name}
												</Typography>
												<Typography variant="body2" component="span" sx={{ color: '#757575', display: 'block', mt: 0.5 }}>
													Опубликовал: {pub.user?.full_name || 'Не указан'}
												</Typography>
												<Typography variant="body2" component="span" sx={{ color: '#757575', display: 'block', mt: 0.5 }}>
													Опубликовано: {formatTimeAgo(pub.published_at || pub.updated_at)}
												</Typography>
											</React.Fragment>
										}
									/>
								</ListItem>
							))}
						</List>
					)}
				</Card>

				{publications.length > 0 && (
					<Box sx={{ display: 'flex', justifyContent: 'center', mt: 4, mb: 4 }}>
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
				)}

				<Collapse in={openError}>
					{error && (
						<Alert severity="error" sx={{ mt: 2, borderRadius: 20, boxShadow: '0 6px 16px rgba(0, 0, 0, 0.15)' }} onClose={() => setOpenError(false)}>
							{error}
						</Alert>
					)}
				</Collapse>
				<Collapse in={openSuccess}>
					{success && (
						<Alert severity="success" sx={{ mt: 2, borderRadius: 20, boxShadow: '0 6px 16px rgba(0, 0, 0, 0.15)' }} onClose={() => setOpenSuccess(false)}>
							{success}
						</Alert>
					)}
				</Collapse>
			</Box>
		</Container>
	);
}

export default Home;