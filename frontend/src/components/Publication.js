// --- START OF FILE Publication.js ---

import React, { useEffect, useState, useCallback } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
	Container,
	Typography,
	Card,
	Button,
	CardContent,
	Box,
	Pagination,
	CircularProgress // Добавим индикатор загрузки
} from '@mui/material';
import { styled } from '@mui/system';
import { Document, Page, pdfjs } from 'react-pdf';
import 'react-pdf/dist/Page/AnnotationLayer.css';
import 'react-pdf/dist/Page/TextLayer.css';
import axios from 'axios';
import DownloadIcon from '@mui/icons-material/Download';
import { useAuth } from '../contexts/AuthContext';
import CommentSection from './CommentSection'; // Предполагаем, что компонент CommentSection существует

// Настройка worker для react-pdf
pdfjs.GlobalWorkerOptions.workerSrc = `/pdf.worker.min.js`;

// Стилизованная кнопка в стиле Apple
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

// Стилизованная зеленая кнопка
const GreenButton = styled(Button)({
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
});

// Стилизованная красная кнопка
const RedButton = styled(Button)({
	borderRadius: '12px',
	textTransform: 'none',
	backgroundColor: '#FF3B30',
	color: '#FFFFFF',
	padding: '8px 16px',
	fontSize: '14px',
	fontWeight: 600,
	boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
	'&:hover': {
		backgroundColor: '#E63935',
		boxShadow: '0 4px 8px rgba(0, 0, 0, 0.1)',
	},
	'&:disabled': {
		backgroundColor: '#D1D1D6',
		color: '#FFFFFF',
	},
});

// Стилизованная карточка
const AppleCard = styled(Card)({
	borderRadius: '16px',
	boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
	backgroundColor: '#FFFFFF',
});

// Контейнер для предпросмотра документов
const DocumentViewer = styled(Box)({
	marginBottom: 4, // Можно оставить или перенести ниже
	border: '1px solid #E5E5EA',
	borderRadius: '12px',
	// overflow: 'hidden',        // УБРАТЬ или заменить на overflowX: 'hidden', если горизонтальный скролл не нужен
	// overflowY: 'auto',       // УБРАТЬ
	backgroundColor: '#FFFFFF',
	boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
	width: '100%',
	// Убираем фиксированную высоту, чтобы она адаптировалась под контент
	// height: '850px',         // ЗАКОММЕНТИРОВАНО - ОСТАВИТЬ ТАК
	// maxHeight: '850px',      // УБРАТЬ или ЗАКОММЕНТИРОВАТЬ
	display: 'flex',
	flexDirection: 'column',
	justifyContent: 'flex-start', // Начинаем сверху
	alignItems: 'center',
	position: 'relative',
	padding: '16px 0', // ОПЦИОНАЛЬНО: добавить вертикальный паддинг
});


const PdfPageWrapper = styled(Box)({
	width: '100%',
	display: 'flex',
	justifyContent: 'center', // Центрируем страницу
	alignItems: 'center',
	padding: '10px 0', // Добавим отступы сверху/снизу
});

function Publication() {
	const { id } = useParams();
	const [publication, setPublication] = useState(null);
	const [error, setError] = useState('');
	const [numPages, setNumPages] = useState(null);
	const [pageNumber, setPageNumber] = useState(1);
	const { user, isAuthenticated, csrfToken } = useAuth(); // Убираем hasReviewerComment отсюда
	const [loadingUser, setLoadingUser] = useState(true);
	// PublicationTypes не нужен здесь, так как мы отображаем имя типа из данных публикации
	const [isLoadingPublication, setIsLoadingPublication] = useState(true); // Состояние загрузки публикации
	const [hasReviewerComment, setHasReviewerComment] = useState(false); // Возвращаем сюда


	// Функция загрузки данных публикации
	const fetchPublication = useCallback(async () => {
		setIsLoadingPublication(true);
		try {
			const response = await axios.get(`http://localhost:5000/api/publications/${id}`, {
				withCredentials: true,
			});
			console.log('Publication loaded:', response.data);
			const fetchedPublication = response.data;
			// Убедимся, что comments всегда массив
			fetchedPublication.comments = fetchedPublication.comments || [];
			setPublication(fetchedPublication);

			const reviewerCommentExists = (fetchedPublication.comments || []).some(
				(comment) =>
					['admin', 'manager'].includes(comment.user.role) ||
					(comment.replies && comment.replies.some((reply) => ['admin', 'manager'].includes(reply.user.role)))
			);
			setHasReviewerComment(reviewerCommentExists);
			setError('');
		} catch (err) {
			console.error('Ошибка загрузки публикации:', err);
			if (err.response && err.response.status === 404) {
				setError('Публикация не найдена.');
			} else if (err.response && err.response.status === 403) {
				setError('У вас нет прав для просмотра этой публикации.');
			} else {
				setError('Не удалось загрузить публикацию. Попробуйте позже.');
			}
		} finally {
			setIsLoadingPublication(false);
		}
	}, [id]); // Зависимость только от ID


	// Выполняем запрос при монтировании компонента
	useEffect(() => {
		fetchPublication();
		// fetchPublicationTypes больше не нужен здесь
	}, [fetchPublication]); // Зависимость от fetchPublication

	// Проверяем загрузку пользователя
	useEffect(() => {
		if (user !== null || !isAuthenticated) { // Проверяем и неаутентифицированных
			setLoadingUser(false);
		}
	}, [user, isAuthenticated]);

	// Обработчик успешной загрузки PDF
	const onDocumentLoadSuccess = useCallback(({ numPages: nextNumPages }) => {
		setNumPages(nextNumPages);
		setPageNumber(1); // Сбросить на первую страницу при загрузке нового документа
	}, []);

	// Функция для изменения страницы
	const handlePageChange = useCallback((event, value) => {
		setPageNumber(value);
	}, []);


	// Обработчик скачивания файла
	const handleDownload = () => {
		if (publication && publication.file_url) {
			// Убедимся, что URL начинается с http://localhost:5000 или /, если он относительный
			const fileUrl = publication.file_url.startsWith('/')
				? `http://localhost:5000${publication.file_url}`
				: publication.file_url; // Предполагаем, что это уже полный URL, если не начинается с /

			const link = document.createElement('a');
			link.href = fileUrl;
			// Получаем имя файла из URL
			const filename = publication.file_url.substring(publication.file_url.lastIndexOf('/') + 1);
			link.download = filename || 'publication_file'; // Имя по умолчанию
			document.body.appendChild(link);
			link.click();
			document.body.removeChild(link);
			console.log(`Attempting to download: ${fileUrl} as ${link.download}`);
		} else {
			console.error("Download failed: No publication or file_url");
			setError("Невозможно скачать файл: URL отсутствует.");
		}
	};

	// Обработчик публикации
	const handlePublish = async () => {
		setError(''); // Сбрасываем ошибку перед действием
		try {
			const response = await axios.post(
				`http://localhost:5000/api/publications/${id}/publish`,
				{},
				{ withCredentials: true, headers: { 'X-CSRFToken': csrfToken } }
			);
			console.log('Publication response:', response.data);
			await fetchPublication(); // Перезагружаем данные после действия
		} catch (err) {
			console.error('Ошибка при публикации:', err.response?.data?.error || err.message);
			setError(`Не удалось опубликовать публикацию: ${err.response?.data?.error || 'Серверная ошибка'}`);
		}
	};

	// Обработчик отправки на доработку
	const handleReject = async () => {
		setError('');
		const reviewerComments = publication.comments.filter(
			(comment) => ['admin', 'manager'].includes(comment.user.role)
		);
		// Найдем самый последний комментарий ревьюера
		const lastReviewerComment = reviewerComments.sort(
			(a, b) => new Date(b.created_at) - new Date(a.created_at)
		)[0]?.content;

		// Убрали проверку на пустой коммент здесь, бэкенд сам проверит

		try {
			const response = await axios.post(
				`http://localhost:5000/api/publications/${id}/return-for-revision`,
				// Бэкенд теперь ожидает comment в теле запроса
				{ comment: lastReviewerComment || "Требуется доработка (комментарий добавлен в обсуждении)" }, // Отправляем последний или заглушку
				{ withCredentials: true, headers: { 'X-CSRFToken': csrfToken } }
			);
			console.log('Return for revision response:', response.data);
			await fetchPublication(); // Перезагружаем данные
		} catch (err) {
			console.error('Ошибка при отправке на доработку:', err.response?.data?.error || err.message);
			setError(`Не удалось отправить на доработку: ${err.response?.data?.error || 'Серверная ошибка'}`);
		}
	};


	// Обработчик добавления комментария
	const handleCommentAdded = useCallback((newCommentFromServerRaw) => {
		// Убедимся, что у нового комментария есть массив replies
		// и объект user, даже если API их не всегда возвращает идеально.
		const newCommentFromServer = {
			...newCommentFromServerRaw,
			replies: newCommentFromServerRaw.replies || [],
			// Если ваш API не возвращает user в ответе на создание коммента,
			// вам может понадобиться запросить его отдельно или использовать данные текущего user.
			// Здесь мы предполагаем, что API возвращает user или newCommentFromServerRaw.user уже есть.
			user: newCommentFromServerRaw.user || (user ? { full_name: user.full_name, role: user.role, id: user.id } : { full_name: "Аноним", role: "user" })
		};

		setPublication(prevPublication => {
			if (!prevPublication) return null;

			// Функция для рекурсивного добавления ответа в нужное место
			const findAndAddReply = (commentsArray, replyToAdd) => {
				return commentsArray.map(comment => {
					if (comment.id === replyToAdd.parent_id) {
						return {
							...comment,
							replies: [...(comment.replies || []), replyToAdd] // Добавляем в конец существующих replies
						};
					}
					if (comment.replies && comment.replies.length > 0) {
						return {
							...comment,
							replies: findAndAddReply(comment.replies, replyToAdd)
						};
					}
					return comment;
				});
			};

			let updatedComments;
			if (newCommentFromServer.parent_id) {
				// Это ответ на существующий комментарий
				updatedComments = findAndAddReply(prevPublication.comments || [], newCommentFromServer);
			} else {
				// Это новый комментарий верхнего уровня
				updatedComments = [...(prevPublication.comments || []), newCommentFromServer];
			}

			// Пересчитываем hasReviewerComment на основе обновленного списка комментариев
			const newHasReviewerComment = updatedComments.some(
				(comment) =>
					['admin', 'manager'].includes(comment.user.role) ||
					(comment.replies && comment.replies.some((reply) => ['admin', 'manager'].includes(reply.user.role)))
			);
			setHasReviewerComment(newHasReviewerComment); // Обновляем состояние

			return {
				...prevPublication,
				comments: updatedComments
			};
		});
	}, [user, setHasReviewerComment]); // Добавили user в зависимости, если используем его для заглушки



	const renderStatus = (status, returnedForRevision) => {
		let statusText = '';
		let textColor = '#6E6E73'; // Default grey

		if (status === 'returned_for_revision') {
			statusText = 'Возвращена на доработку';
			textColor = '#FF3B30'; // Red
		} else if (status === 'draft') {
			statusText = returnedForRevision ? 'Возвращена на доработку (черновик)' : 'Черновик';
			textColor = returnedForRevision ? '#FF3B30' : '#6E6E73';
		} else if (status === 'needs_review') {
			statusText = 'На проверке';
			textColor = '#FF9500'; // Orange
		} else if (status === 'published') {
			statusText = 'Опубликована';
			textColor = '#34C759'; // Green
		} else {
			statusText = status || 'Неизвестно';
		}

		return (
			<Typography variant="body1" sx={{ color: textColor, mb: 1, fontWeight: 500 }}>
				Статус: {statusText}
			</Typography>
		);
	};
	// Проверяем, является ли пользователь рецензентом (менеджер или админ)
	const isReviewer = user?.role && ['admin', 'manager'].includes(user.role);

	// Отображаем ошибку
	if (error) {
		return (
			<Container maxWidth="lg" sx={{ mt: 8, mb: 4 }}>
				<Typography color="error" align="center">{error}</Typography>
			</Container>
		);
	}

	// Отображаем индикатор загрузки, пока ждем данные
	if (isLoadingPublication || loadingUser) {
		return (
			<Container maxWidth="lg" sx={{ mt: 8, mb: 4, display: 'flex', justifyContent: 'center' }}>
				<CircularProgress sx={{ color: '#0071E3' }} />
			</Container>
		);
	}

	// Если публикация не загружена после завершения загрузки
	if (!publication) {
		return (
			<Container maxWidth="lg" sx={{ mt: 8, mb: 4 }}>
				<Typography align="center">Не удалось загрузить данные публикации.</Typography>
			</Container>
		);
	}

	// Формируем URL файла
	const fileUrl = publication.file_url
		? publication.file_url.startsWith('http')
			? publication.file_url // Уже полный URL
			: `http://localhost:5000${publication.file_url.startsWith('/') ? '' : '/'}${publication.file_url}` // Делаем URL абсолютным
		: null;


	return (
		<Container maxWidth="lg" sx={{ mt: 8, mb: 4 }}>
			<AppleCard elevation={4}>
				<CardContent sx={{ p: 3 }}> {/* Уменьшили padding для компактности */}
					{/* --- Основные поля --- */}
					<Typography variant="h4" sx={{ color: '#1D1D1F', mb: 2, fontWeight: 600 }}>
						{publication.title}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
						Авторы: {publication.authors && publication.authors.length > 0
							? publication.authors.map(author => author.name).join(', ')
							: 'Нет авторов'}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
						Год: {publication.year}
					</Typography>
					<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
						Тип: {publication.type?.display_name || 'Неизвестный тип'}
					</Typography>
					{/* --- Рендеринг статуса --- */}
					{renderStatus(publication.status, publication.returned_for_revision)}

					{/* --- ОТОБРАЖЕНИЕ НОВЫХ ПОЛЕЙ (с проверкой на наличие) --- */}
					{publication.journal_conference_name && (
						<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
							Издание: {publication.journal_conference_name}
						</Typography>
					)}
					{publication.volume && (
						<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
							Том: {publication.volume}
						</Typography>
					)}
					{publication.number && (
						<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
							Номер/Выпуск: {publication.number}
						</Typography>
					)}
					{publication.pages && (
						<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
							Страницы: {publication.pages}
						</Typography>
					)}
					{publication.publisher && (
						<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
							Издательство: {publication.publisher}
						</Typography>
					)}
					{publication.publisher_location && (
						<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
							Место издательства: {publication.publisher_location}
						</Typography>
					)}
					<Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2, mb: 1 }}> {/* Группируем ID */}
						{publication.doi && (
							<Typography variant="body1" sx={{ color: '#757575' }}>DOI: {publication.doi}</Typography>
						)}
						{publication.issn && (
							<Typography variant="body1" sx={{ color: '#757575' }}>ISSN: {publication.issn}</Typography>
						)}
						{publication.isbn && (
							<Typography variant="body1" sx={{ color: '#757575' }}>ISBN: {publication.isbn}</Typography>
						)}
						{publication.quartile && (
							<Typography variant="body1" sx={{ color: '#757575' }}>Q: {publication.quartile}</Typography>
						)}
					</Box>
					<Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2, mb: 1 }}> {/* Группируем объем и тираж */}
						{publication.printed_sheets_volume != null && ( // Проверка на null
							<Typography variant="body1" sx={{ color: '#757575' }}>
								Объем (п.л.): {publication.printed_sheets_volume}
							</Typography>
						)}
						{publication.circulation != null && ( // Проверка на null
							<Typography variant="body1" sx={{ color: '#757575' }}>
								Тираж: {publication.circulation}
							</Typography>
						)}
					</Box>
					{publication.department && (
						<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
							Кафедра: {publication.department}
						</Typography>
					)}
					{publication.classification_code && (
						<Typography variant="body1" sx={{ color: '#757575', mb: 1 }}>
							Код классификатора: {publication.classification_code}
						</Typography>
					)}
					{publication.notes && (
						<Typography variant="body1" sx={{ color: '#757575', mb: 2 }}> {/* Увеличил отступ */}
							Примечание: {publication.notes}
						</Typography>
					)}
					{/* --- КОНЕЦ ОТОБРАЖЕНИЯ НОВЫХ ПОЛЕЙ --- */}

					<Typography variant="h6" sx={{ color: '#1D1D1F', mt: 2, mb: 1, fontWeight: 500 }}> {/* Добавил отступы */}
						Документ:
					</Typography>
					{/* --- Блок файла и кнопок --- */}
					<Box sx={{ mb: 3 }}> {/* Отступ для блока файла и кнопок */}
						{fileUrl ? (
							fileUrl.toLowerCase().endsWith('.pdf') ? (
								<>
									<DocumentViewer>
										<Document
											file={fileUrl}
											onLoadSuccess={onDocumentLoadSuccess}
											onLoadError={(err) => {
												console.error("PDF Load Error:", err);
												setError(`Ошибка загрузки PDF: ${err.message}. Попробуйте скачать файл.`);
											}}
											loading={<CircularProgress sx={{ color: '#0071E3', my: 2 }} />} // Индикатор загрузки PDF
											error={<Typography color="error" sx={{ p: 2 }}>Не удалось загрузить PDF.</Typography>}
										>
											<PdfPageWrapper>
												<Page
													key={`page_${pageNumber}`}
													pageNumber={pageNumber}
													renderTextLayer={false}
													// renderAnnotationLayer={true} // Можно включить, если нужны аннотации PDF
													width={ // Адаптивная ширина страницы PDF
														Math.min(window.innerWidth * 0.8, 800) // Например, 80% ширины окна, но не более 800px
													}
												/>
											</PdfPageWrapper>
										</Document>
									</DocumentViewer>
									{numPages && numPages > 1 && (
										<Box sx={{ display: 'flex', justifyContent: 'center', mt: 1 }}>
											<Pagination
												count={numPages}
												page={pageNumber}
												onChange={handlePageChange}
												color="primary"
												size="small" // Уменьшим пагинацию
												sx={{
													'& .MuiPaginationItem-root': { borderRadius: '50%' }, // Круглые кнопки
													'& .Mui-selected': { backgroundColor: '#0071E3', color: '#fff' }
												}}
											/>
										</Box>
									)}
								</>
							) : fileUrl.toLowerCase().endsWith('.docx') ? (
								<Typography sx={{ color: '#6E6E73', my: 2 }}>
									Файл загружен в формате DOCX, предпросмотр недоступен. Вы можете скачать файл.
								</Typography>
							) : (
								<Typography sx={{ color: '#6E6E73', my: 2 }}>
									Формат файла не поддерживается для предпросмотра. Вы можете скачать файл.
								</Typography>
							)
						) : (
							<Typography sx={{ color: '#6E6E73', my: 2 }}>
								Файл не прикреплен к этой публикации.
							</Typography>
						)}
						{/* Кнопки действий */}
						<Box sx={{ mt: 2, display: 'flex', gap: 2, flexWrap: 'wrap' }}>
							{fileUrl && (
								<AppleButton startIcon={<DownloadIcon />} onClick={handleDownload}>
									Скачать файл
								</AppleButton>
							)}
							{/* Кнопки для рецензента */}
							{isReviewer && publication.status === 'needs_review' && (
								<>
									<GreenButton onClick={handlePublish} disabled={isLoadingPublication}>
										Опубликовать
									</GreenButton>
									<RedButton onClick={handleReject} disabled={!hasReviewerComment || isLoadingPublication}>
										Вернуть на доработку
										{!hasReviewerComment && " (нужен комментарий)"}
									</RedButton>
								</>
							)}
						</Box>
					</Box>


					{/* --- Секция комментариев --- */}
					<Typography variant="h5" sx={{ color: '#1D1D1F', mb: 2, fontWeight: 600 }}>
						Обсуждение
					</Typography>
					{/* Передаем publication.comments убедившись, что это массив */}
					<CommentSection
						comments={publication.comments || []}
						publicationId={publication.id}
						onCommentAdded={handleCommentAdded} // Передаем callback для обновления UI или перезагрузки
					/>

				</CardContent>
			</AppleCard>
		</Container>
	);
}

export default Publication;

// --- END OF FILE Publication.js ---