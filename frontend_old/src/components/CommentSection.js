import React, { useState } from 'react';
import {
	Box,
	Typography,
	TextField,
	IconButton,
	List,
	ListItem,
	Divider,
} from '@mui/material';
import { styled } from '@mui/system';
import SendIcon from '@mui/icons-material/Send';
// import ReplyIcon from '@mui/icons-material/Reply'; // УДАЛЕНО
import axios from 'axios';
import { useAuth } from '../contexts/AuthContext';

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

const AppleButton = styled(IconButton)({
	color: '#0071E3',
	'&:hover': {
		color: '#FFFFFF',
		backgroundColor: '#0071E3',
	},
});

const translateRole = (role) => {
	switch (role) {
		case 'manager':
			return 'Управляющий';
		case 'user':
			return 'Пользователь';
		case 'admin':
			return 'Администратор';
		default:
			return role; // Если роль неизвестна, отображаем как есть
	}
};

const CommentSection = ({ comments, publicationId, onCommentAdded }) => {
	const [newComment, setNewComment] = useState('');
	// const [replyComment, setReplyComment] = useState(''); // УДАЛЕНО
	// const [replyingTo, setReplyingTo] = useState(null); // УДАЛЕНО
	const { csrfToken } = useAuth();

	const handleAddComment = async () => { // Убран parentId, так как отвечаем только на верхний уровень
		const content = newComment; // Всегда используется newComment
		if (!content.trim()) return;

		try {
			const response = await axios.post(
				`http://localhost:5000/api/publications/${publicationId}/comments`,
				{ content, parent_id: null }, // parent_id всегда null
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);
			if (onCommentAdded) {
				onCommentAdded(response.data.comment);
			}
			setNewComment('');
			// setReplyComment(''); // УДАЛЕНО
			// setReplyingTo(null); // УДАЛЕНО
		} catch (err) {
			console.error('Error adding comment:', err);
		}
	};

	// Функция renderComment теперь не будет отображать кнопку "Ответить" и поле для ответа
	const renderComment = (comment, depth = 0) => (
		<React.Fragment key={comment.id}>
			<ListItem sx={{ pl: depth * 4 }}>
				<Box sx={{ width: '100%' }}>
					<Typography variant="body2" sx={{ color: '#6E6E73' }}>
						{comment.user.full_name} ({comment.user && comment.user.role ? translateRole(comment.user.role) : 'Неизвестная роль'}) • {new Date(comment.created_at).toLocaleString()}
					</Typography>
					<Typography variant="body1" sx={{ color: '#1D1D1F', mt: 1, mb: 1 }}> {/* Добавлен mb для небольшого отступа снизу */}
						{comment.content}
					</Typography>
					{/* Блок кнопки "Ответить" и поля для ответа полностью УДАЛЕН */}
				</Box>
			</ListItem>
			{comment.replies && comment.replies.length > 0 && ( // Проверяем наличие replies перед маппингом
				<List sx={{ pl: 4, pt: 0, pb: 0 /* убрали лишние паддинги у вложенного списка */ }}> {/* Добавлено pt, pb = 0 */}
					{comment.replies.map((reply) => renderComment(reply, depth + 1))}
				</List>
			)}
			{depth === 0 && <Divider sx={{ my: 1 }} />} {/* Разделитель только для комментариев верхнего уровня, если есть ответы */}
		</React.Fragment>
	);

	return (
		<Box>
			<List>
				{/* Убедимся, что comments это массив перед map */}
				{Array.isArray(comments) && comments.map((comment) => renderComment(comment))}
			</List>
			<AppleTextField
				fullWidth
				value={newComment}
				onChange={(e) => setNewComment(e.target.value)}
				placeholder="Добавьте комментарий..."
				variant="outlined"
				multiline
				rows={3}
				sx={{ mb: 2 }}
			/>
			<AppleButton onClick={() => handleAddComment()} disabled={!newComment.trim()}>
				<SendIcon />
			</AppleButton>
		</Box>
	);
};

export default CommentSection;