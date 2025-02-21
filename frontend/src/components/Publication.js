import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { Container, Typography, Card, CardContent, Button } from '@mui/material';
import axios from 'axios';

function Publication() {
	const { id } = useParams();
	const [publication, setPublication] = useState(null);
	const [error, setError] = useState('');

	useEffect(() => {
		const fetchPublication = async () => {
			try {
				const response = await axios.get(`http://localhost:5000/api/publications/${id}`, {
					withCredentials: true,
				});
				setPublication(response.data);
			} catch (err) {
				console.error('Ошибка загрузки публикации:', err);
				setError('Не удалось загрузить публикацию. Попробуйте позже.');
			}
		};
		fetchPublication();
	}, [id]);

	if (error) return <Typography color="error">{error}</Typography>;
	if (!publication) return <Typography sx={{ color: '#212121' }}>Загрузка...</Typography>;

	return (
		<Container maxWidth="lg" sx={{ mt: 4 }}>
			<Card elevation={4} sx={{ p: 4, borderRadius: 16, backgroundColor: 'white', boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)' }}>
				<CardContent>
					<Typography variant="h4" sx={{ color: '#212121', mb: 2 }}>
						{publication.title}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
						Автор: {publication.authors}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
						Год: {publication.year}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
						Тип: {publication.type}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
						Статус: {publication.status}
					</Typography>
					{publication.file_url && (
						<Button
							variant="contained"
							color="primary"
							href={`http://localhost:5000/${publication.file_url.replace(/^.*uploads/, 'uploads')}`}
							target="_blank"
							sx={{ mt: 2, borderRadius: 16, transition: 'all 0.3s ease', '&:hover': { transform: 'scale(1.05)' } }}
						>
							Скачать файл
						</Button>
					)}
				</CardContent>
			</Card>
		</Container>
	);
}

export default Publication;