import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { Container, Typography, Card, CardContent, Box, TextField, List, ListItem, ListItemText, Button } from '@mui/material';
import { styled } from '@mui/system';
import axios from 'axios';
import ReplyIcon from '@mui/icons-material/Reply';
import { useAuth } from '../contexts/AuthContext';

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

const AppleTextField = styled(TextField)({
	'& .MuiOutlinedInput-root': {
		borderRadius: '12px',
		backgroundColor: '#F5F5F7',
		'& fieldset': { borderColor: '#D1D1D6' },
		'&:hover fieldset': { borderColor: '#0071E3' },
		'&.Mui-focused fieldset': { borderColor: '#0071E3' },
	},
	'& label': { color: '#6E6E73' },
	'& input': { color: '#1D1D1F' },
});

const AppleCard = styled(Card)({
	borderRadius: '16px',
	boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
	backgroundColor: '#FFFFFF',
});

function Publication() {
	const { id } = useParams();
	const [publication, setPublication] = useState(null);
	const [error, setError] = useState('');
	const [comment, setComment] = useState('');
	const [replyTo, setReplyTo] = useState(null);
	const { isAuthenticated, csrfToken } = useAuth();

	useEffect(() => {
		const fetchPublication = async () => {
			try {
				const response = await axios.get(`http://localhost:5000/api/publications/${id}`, { withCredentials: true });
				console.log('Данные публикации:', response.data);
				setPublication(response.data);
			} catch (err) {
				console.error('Ошибка загрузки публикации:', err);
				setError('Не удалось загрузить публикацию. Попробуйте позже.');
			}
		};
		fetchPublication();
	}, [id]);

	const handleCommentSubmit = async (e) => {
		e.preventDefault();
		if (!comment.trim()) return;

		try {
			const response = await axios.post(
				`http://localhost:5000/api/publications/${id}/comments`,
				{ content: comment, parent_id: replyTo },
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);
			setPublication((prev) => ({
				...prev,
				comments: replyTo
					? prev.comments.map((c) => (c.id === replyTo ? { ...c, replies: [...c.replies, response.data.comment] } : c))
					: [...prev.comments, response.data.comment],
			}));
			setComment('');
			setReplyTo(null);
		} catch (err) {
			console.error('Ошибка добавления комментария:', err);
			setError('Не удалось добавить комментарий.');
		}
	};

	const renderComments = (comments, level = 0) => (
		<List sx={{ pl: level * 4 }}>
			{comments.map((comment) => (
				<React.Fragment key={comment.id}>
					<ListItem sx={{ borderBottom: '1px solid #E5E5EA', py: 2 }}>
						<ListItemText
							primary={<Typography sx={{ color: '#1D1D1F', fontWeight: 500 }}>{comment.user.full_name}:</Typography>}
							secondary={
								<>
									<Typography sx={{ color: '#6E6E73' }}>{comment.content}</Typography>
									<Typography sx={{ color: '#757575', fontSize: '0.8rem', mt: 1 }}>
										{new Date(comment.created_at).toLocaleString()}
									</Typography>
									{isAuthenticated && (
										<AppleButton
											size="small"
											onClick={() => setReplyTo(comment.id)}
											sx={{ mt: 1 }}
											startIcon={<ReplyIcon />}
										>
											Ответить
										</AppleButton>
									)}
								</>
							}
						/>
					</ListItem>
					{comment.replies.length > 0 && renderComments(comment.replies, level + 1)}
				</React.Fragment>
			))}
		</List>
	);

	if (error) return <Typography color="error">{error}</Typography>;
	if (!publication) return <Typography sx={{ color: '#212121' }}>Загрузка...</Typography>;

	// Определяем fileUrl здесь
	const fileUrl = `http://localhost:5000${publication.file_url}`;

	return (
		<Container maxWidth="lg" sx={{ mt: 4 }}>
			<AppleCard elevation={4}>
				<CardContent>
					<Typography variant="h4" sx={{ color: '#1D1D1F', mb: 2, fontWeight: 600 }}>
						{publication.title}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
						Авторы: {publication.authors}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
						Год: {publication.year}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
						Тип: {publication.type_ru || publication.type}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
						Статус: {publication.status_ru || publication.status}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 2 }}>
						Опубликовал: {publication.user.full_name}
					</Typography>

					{publication.file_url && (
						<Box sx={{ mb: 4, height: '500px', border: '1px solid #E5E5EA', borderRadius: '12px', overflow: 'hidden' }}>
							<embed src={fileUrl} type="application/pdf" width="100%" height="100%" />
						</Box>
					)}

					<Typography variant="h5" sx={{ color: '#1D1D1F', mb: 2, fontWeight: 600 }}>
						Комментарии
					</Typography>
					{isAuthenticated && (
						<Box component="form" onSubmit={handleCommentSubmit} sx={{ mb: 3 }}>
							<AppleTextField
								fullWidth
								label={replyTo ? 'Ответить на комментарий' : 'Добавить комментарий'}
								value={comment}
								onChange={(e) => setComment(e.target.value)}
								multiline
								rows={3}
								sx={{ mb: 2 }}
							/>
							<AppleButton type="submit">Отправить</AppleButton>
							{replyTo && (
								<AppleButton onClick={() => setReplyTo(null)} sx={{ ml: 2 }}>
									Отменить ответ
								</AppleButton>
							)}
						</Box>
					)}
					{publication.comments && publication.comments.length > 0 ? (
						renderComments(publication.comments)
					) : (
						<Typography sx={{ color: '#6E6E73' }}>Комментариев пока нет.</Typography>
					)}
				</CardContent>
			</AppleCard>
		</Container>
	);
}

export default Publication;