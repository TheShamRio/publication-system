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
import ReplyIcon from '@mui/icons-material/Reply';
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

const CommentSection = ({ comments, publicationId, onCommentAdded }) => {
	const [newComment, setNewComment] = useState('');
	const [replyComment, setReplyComment] = useState('');
	const [replyingTo, setReplyingTo] = useState(null);
	const { csrfToken } = useAuth();

	const handleAddComment = async (parentId = null) => {
		const content = parentId ? replyComment : newComment;
		if (!content.trim()) return;

		try {
			const response = await axios.post(
				`http://localhost:5000/api/publications/${publicationId}/comments`,
				{ content, parent_id: parentId },
				{
					withCredentials: true,
					headers: { 'X-CSRFToken': csrfToken },
				}
			);
			if (onCommentAdded) {
				onCommentAdded(response.data.comment);
			}
			setNewComment('');
			setReplyComment('');
			setReplyingTo(null);
		} catch (err) {
			console.error('Error adding comment:', err);
		}
	};

	const renderComment = (comment, depth = 0) => (
		<React.Fragment key={comment.id}>
			<ListItem sx={{ pl: depth * 4 }}>
				<Box sx={{ width: '100%' }}>
					<Typography variant="body2" sx={{ color: '#6E6E73' }}>
						{comment.user.full_name} ({comment.user.role}) • {new Date(comment.created_at).toLocaleString()}
					</Typography>
					<Typography variant="body1" sx={{ color: '#1D1D1F', mt: 1 }}>
						{comment.content}
					</Typography>
					<Box sx={{ mt: 1 }}>
						<AppleButton
							onClick={() => setReplyingTo(comment.id)}
							sx={{ fontSize: '0.875rem' }}
						>
							<ReplyIcon fontSize="small" />
							<Typography variant="body2" sx={{ ml: 0.5 }}>
								Ответить
							</Typography>
						</AppleButton>
					</Box>
					{replyingTo === comment.id && (
						<Box sx={{ mt: 2, mb: 2 }}>
							<AppleTextField
								fullWidth
								value={replyComment}
								onChange={(e) => setReplyComment(e.target.value)}
								placeholder="Введите ваш ответ..."
								variant="outlined"
								multiline
								rows={2}
								sx={{ mb: 1 }}
							/>
							<AppleButton onClick={() => handleAddComment(comment.id)}>
								<SendIcon />
							</AppleButton>
							<AppleButton
								onClick={() => {
									setReplyingTo(null);
									setReplyComment('');
								}}
							>
								<Typography variant="body2">Отмена</Typography>
							</AppleButton>
						</Box>
					)}
				</Box>
			</ListItem>
			{comment.replies.length > 0 && (
				<List sx={{ pl: 4 }}>
					{comment.replies.map((reply) => renderComment(reply, depth + 1))}
				</List>
			)}
			<Divider sx={{ my: 1 }} />
		</React.Fragment>
	);

	return (
		<Box>
			<List>{comments.map((comment) => renderComment(comment))}</List>
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