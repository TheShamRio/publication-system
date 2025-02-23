import React, { useState, useEffect, useMemo } from 'react';
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
	const [filterType, setFilterType] = useState('');
	const [filterYear, setFilterYear] = useState('');
	const [allPublications, setAllPublications] = useState([]);
	const [error, setError] = useState('');
	const [success, setSuccess] = useState('');
	const [openError, setOpenError] = useState(false);
	const [openSuccess, setOpenSuccess] = useState(false);
	const [currentPage, setCurrentPage] = useState(1);
	const publicationsPerPage = 10;
	const navigate = useNavigate();

	useEffect(() => {
		const fetchPublishedPublications = async () => {
			try {
				const response = await axios.get('http://localhost:5000/api/public/publications', {
					withCredentials: true,
				});
				const sortedPubs = response.data
					.sort((a, b) => new Date(b.updated_at || b.created_at) - new Date(a.updated_at || a.created_at));
				setAllPublications(sortedPubs);
			} catch (err) {
				console.error('Ошибка загрузки публикаций:', err);
				setError('Произошла ошибка при загрузке данных. Попробуйте позже.');
				setOpenError(true);
			}
		};

		fetchPublishedPublications();
	}, []);

	const filteredPublications = useMemo(() => {
		return allPublications
			.filter(
				(pub) =>
					(pub.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
						pub.authors.toLowerCase().includes(searchTerm.toLowerCase())) &&
					(!filterType || pub.type === filterType) &&
					(!filterYear || pub.year.toString() === filterYear)
			)
			.sort((a, b) => {
				const aMatch =
					a.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
					a.authors.toLowerCase().includes(searchTerm.toLowerCase())
						? 1
						: 0;
				const bMatch =
					b.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
					b.authors.toLowerCase().includes(searchTerm.toLowerCase())
						? 1
						: 0;
				return bMatch - aMatch || new Date(b.updated_at || b.created_at) - new Date(a.updated_at || a.created_at);
			});
	}, [searchTerm, filterType, filterYear, allPublications]);

	const indexOfLastPublication = currentPage * publicationsPerPage;
	const indexOfFirstPublication = indexOfLastPublication - publicationsPerPage;
	const currentPublications = filteredPublications.slice(indexOfFirstPublication, indexOfLastPublication);
	const totalPages = Math.ceil(filteredPublications.length / publicationsPerPage);

	const handlePageChange = (event, newPage) => {
		setCurrentPage(newPage);
	};

	const handleFilterChange = () => {
		setCurrentPage(1);
	};

	return (
		<Container maxWidth="lg" sx={{ mt: 4, minHeight: 'calc(100vh - 64px)', backgroundColor: 'white', borderRadius: 20, boxShadow: '0 12px 32px rgba(0, 0, 0, 0.15)' }}>
			<Box sx={{ p: 4 }}>
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
									value={filterType}
									onChange={(e) => setFilterType(e.target.value)}
									label="Тип"
									sx={{ borderRadius: 16, '&:hover': { boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)' } }}
								>
									<MenuItem value="">Все</MenuItem>
									<MenuItem value="article">Статья</MenuItem>
									<MenuItem value="monograph">Монография</MenuItem>
									<MenuItem value="conference">Доклад/конференция</MenuItem>
								</Select>
							</FormControl>
						</Grid>
						<Grid item xs={12} sm={4}>
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
								sx={{ borderRadius: 16, boxShadow: '0 2px 8px rgba(0, 0, 0, 0.05)', '&:hover': { boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)' } }}
							/>
						</Grid>
						<Grid item xs={12}>
							<Button
								variant="contained"
								color="primary"
								onClick={handleFilterChange}
								sx={{ mt: 2, borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)', boxShadow: '0 6px 16px rgba(0, 0, 0, 0.2)' } }}
							>
								Применить фильтры
							</Button>
						</Grid>
					</Grid>
				</Box>

				<Typography variant="h5" gutterBottom sx={{ mt: 4, color: '#212121', fontWeight: 600, textAlign: 'center' }}>
					Последние опубликованные работы
				</Typography>
				<Card sx={{ mt: 2, mb: 4, borderRadius: 20, boxShadow: '0 12px 32px rgba(0, 0, 0, 0.15)', backgroundColor: 'white' }}>
					{filteredPublications.length === 0 ? (
						<Box sx={{ p: 3, textAlign: 'center', color: '#757575' }}>
							<Typography variant="h6" sx={{ fontWeight: 500 }}>
								Увы, ничего не нашлось
							</Typography>
						</Box>
					) : (
						<List sx={{ width: '100%', backgroundColor: 'white', p: 3 }}>
							{currentPublications.map((pub) => (
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
											<Typography
												variant="h6"
												component="a"
												href={`/publication/${pub.id}`}
												sx={{ color: '#1976D2', textDecoration: 'none', '&:hover': { textDecoration: 'underline', color: '#1565C0' }, fontWeight: 500 }}
											>
												{pub.title}
											</Typography>
										}
										secondary={
											<React.Fragment>
												<Typography
													variant="body2"
													component="span"
													sx={{ color: '#757575', display: 'block', mt: 0.5 }}
												>
													Год: {pub.year}
												</Typography>
												<Typography
													variant="body2"
													component="span"
													sx={{ color: '#757575', display: 'block', mt: 0.5 }}
												>
													Автор: {pub.authors}
												</Typography>
												<Typography
													variant="body2"
													component="span"
													sx={{ color: '#757575', display: 'block', mt: 0.5 }}
												>
													Опубликовал: {pub.user?.full_name || 'Не указан'}
												</Typography>
											</React.Fragment>
										}
									/>
								</ListItem>
							))}
						</List>
					)}
				</Card>

				{filteredPublications.length > 0 && (
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