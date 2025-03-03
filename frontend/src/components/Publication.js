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
} from '@mui/material';
import { styled } from '@mui/system';
import { Document, Page, pdfjs } from 'react-pdf';
import 'react-pdf/dist/Page/AnnotationLayer.css';
import 'react-pdf/dist/Page/TextLayer.css';
import axios from 'axios';
import DownloadIcon from '@mui/icons-material/Download';
import { useAuth } from '../contexts/AuthContext';
import CommentSection from './CommentSection';

pdfjs.GlobalWorkerOptions.workerSrc = `//cdnjs.cloudflare.com/ajax/libs/pdf.js/${pdfjs.version}/pdf.worker.min.js`;

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

const AppleCard = styled(Card)({
    borderRadius: '16px',
    boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
    backgroundColor: '#FFFFFF',
});

const DocumentViewer = styled(Box)({
    mb: 4,
    border: '1px solid #E5E5EA',
    borderRadius: '12px',
    overflow: 'hidden',
    backgroundColor: '#FFFFFF',
    boxShadow: '0 4px 12px rgba(0, 0, 0, 0.05)',
    width: '100%',
    height: '850px',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'flex-start',
    '&::-webkit-scrollbar': { display: 'none' },
    '-ms-overflow-style': 'none',
    'scrollbar-width': 'none',
});

function Publication() {
    const { id } = useParams();
    const [publication, setPublication] = useState(null);
    const [error, setError] = useState('');
    const [numPages, setNumPages] = useState(null);
    const [pageNumber, setPageNumber] = useState(1);
    const { user, isAuthenticated, csrfToken } = useAuth();
    const [hasReviewerComment, setHasReviewerComment] = useState(false);
    const [loadingUser, setLoadingUser] = useState(true);

    const fetchPublication = useCallback(async () => {
        try {
            const response = await axios.get(`http://localhost:5000/api/publications/${id}`, { withCredentials: true });
            setPublication(response.data);
            const reviewerComment = response.data.comments.some(
                (comment) =>
                    ['admin', 'manager'].includes(comment.user.role) ||
                    comment.replies.some((reply) => ['admin', 'manager'].includes(reply.user.role))
            );
            setHasReviewerComment(reviewerComment);
        } catch (err) {
            console.error('Ошибка загрузки публикации:', err);
            setError('Не удалось загрузить публикацию. Попробуйте позже.');
        }
    }, [id]);

    useEffect(() => {
        fetchPublication();
    }, [fetchPublication]);

    useEffect(() => {
        if (user !== null) {
            setLoadingUser(false);
        }
    }, [user]);

    const onDocumentLoadSuccess = ({ numPages }) => {
        setNumPages(numPages);
    };

    const handleDownload = () => {
        if (publication && publication.file_url) {
            const fileUrl = `http://localhost:5000${publication.file_url}`;
            const link = document.createElement('a');
            link.href = fileUrl;
            link.download = publication.file_url.split('/').pop();
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    };

    const handlePublish = async () => {
        try {
            const response = await axios.post(
                `http://localhost:5000/api/publications/${id}/publish`, // Исправляем URL
                {},
                { withCredentials: true, headers: { 'X-CSRFToken': csrfToken } }
            );
            console.log('Publication response:', response.data);
            fetchPublication();
        } catch (err) {
            console.error('Ошибка при публикации:', err);
            setError('Не удалось опубликовать публикацию.');
        }
    };

    const handleReject = async () => {
        try {
            const response = await axios.post(
                `http://localhost:5000/api/publications/${id}/return-for-revision`, // Исправляем URL
                {},
                { withCredentials: true, headers: { 'X-CSRFToken': csrfToken } }
            );
            console.log('Return for revision response:', response.data);
            fetchPublication();
        } catch (err) {
            console.error('Ошибка при отправке на доработку:', err);
            setError('Не удалось отправить на доработку. Убедитесь, что был добавлен комментарий.');
        }
    };

    const handleCommentAdded = (newComment) => {
        setPublication((prev) => {
            if (newComment.parent_id) {
                const updatedComments = prev.comments.map((comment) =>
                    comment.id === newComment.parent_id
                        ? { ...comment, replies: [...comment.replies, newComment] }
                        : comment
                );
                return { ...prev, comments: updatedComments };
            }
            return { ...prev, comments: [...prev.comments, newComment] };
        });
        if (['admin', 'manager'].includes(newComment.user.role)) {
            setHasReviewerComment(true);
        }
    };

    if (error) return <Typography color="error">{error}</Typography>;
    if (!publication || loadingUser) return <Typography sx={{ color: '#212121' }}>Загрузка...</Typography>;

    const fileUrl = publication.file_url ? `http://localhost:5000${publication.file_url}` : null;

    // Функция для отображения статуса с учётом локализации и цвета
    const renderStatus = (status, returnedForRevision, isReviewer) => {
        let statusText = '';
        let statusColor = '#757575'; // Цвет по умолчанию (серый)

        if (isReviewer) {
            // Для admin или manager
            switch (status) {
                case 'draft':
                    statusText = 'Черновик';
                    break;
                case 'needs_review':
                    statusText = 'Нуждается в проверке';
                    statusColor = '#FF3B30'; // Красный
                    break;
                case 'published':
                    statusText = 'Опубликованные';
                    break;
                default:
                    statusText = status;
            }
        } else {
            // Для пользователя
            if (status === 'needs_review' && !returnedForRevision) {
                statusText = 'На проверке';
            } else if (status === 'draft' && returnedForRevision) {
                statusText = 'Требуется доработка';
                statusColor = '#FF3B30'; // Красный
            } else if (status === 'draft') {
                statusText = 'Черновик';
            } else if (status === 'published') {
                statusText = 'Опубликованные';
            } else {
                statusText = status;
            }
        }

        return <Typography variant="body1" sx={{ color: statusColor, mb: 1 }}>{`Статус: ${statusText}`}</Typography>;
    };

    const isReviewer = ['admin', 'manager'].includes(user?.role);

    console.log('User:', user);
    console.log('User role:', user?.role);
    console.log('Publication status:', publication.status);
    console.log('Is reviewer and needs_review:', isReviewer && publication.status === 'needs_review');

    return (
        <Container maxWidth="lg" sx={{ mt: 8, mb: 4 }}>
            <AppleCard elevation={4}>
                <CardContent sx={{ pt: 4, pb: 4 }}>
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
                        Тип: {publication.type === 'article' ? 'Статья' : publication.type === 'monograph' ? 'Монография' : publication.type === 'conference' ? 'Доклад/конференция' : publication.type}
                    </Typography>
                    {renderStatus(publication.status, publication.returned_for_revision, isReviewer)}
                    <Typography variant="body1" sx={{ color: '#757575', mb: 2 }}>
                        Опубликовал: {publication.user.full_name}
                    </Typography>

                    <Typography variant="h6" sx={{ color: '#1D1D1F', mb: 2, fontWeight: 500 }}>
                        Предпросмотр:
                    </Typography>
                    {fileUrl ? (
                        fileUrl.endsWith('.pdf') ? (
                            <>
                                <DocumentViewer>
                                    <Document
                                        file={fileUrl}
                                        onLoadSuccess={onDocumentLoadSuccess}
                                        onLoadError={(err) => setError(`Ошибка загрузки PDF: ${err.message}`)}
                                    >
                                        <Page
                                            pageNumber={pageNumber}
                                            scale={1}
                                            renderTextLayer={false}
                                            renderAnnotationLayer={false}
                                        />
                                    </Document>
                                </DocumentViewer>
                                {numPages > 1 && (
                                    <Box sx={{ display: 'flex', justifyContent: 'center', mt: 2, mb: 4 }}>
                                        <Pagination
                                            count={numPages}
                                            page={pageNumber}
                                            onChange={(event, newPage) => setPageNumber(newPage)}
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
                            </>
                        ) : fileUrl.endsWith('.docx') ? (
                            <Typography sx={{ color: '#6E6E73', mb: 2 }}>
                                Файл загружен в формате DOCX, предпросмотр недоступен.
                            </Typography>
                        ) : (
                            <Typography sx={{ color: '#6E6E73', mb: 2 }}>
                                Формат файла не поддерживается для отображения (только PDF и DOCX).
                            </Typography>
                        )
                    ) : (
                        <Typography sx={{ color: '#6E6E73', mb: 2 }}>
                            Файл не прикреплен к этой публикации.
                        </Typography>
                    )}
                    {fileUrl && (
                        <Box sx={{ mb: 2 }}>
                            <AppleButton startIcon={<DownloadIcon />} onClick={handleDownload}>
                                Скачать
                            </AppleButton>
                        </Box>
                    )}

                    {isReviewer && publication.status === 'needs_review' && (
                        <Box sx={{ mb: 2, display: 'flex', gap: 2 }}>
                            <GreenButton onClick={handlePublish}>Опубликовать</GreenButton>
                            <RedButton onClick={handleReject} disabled={!hasReviewerComment}>
                                Отправить на доработку
                            </RedButton>
                        </Box>
                    )}

                    <Typography variant="h5" sx={{ color: '#1D1D1F', mb: 2, fontWeight: 600 }}>
                        Комментарии
                    </Typography>
                    {publication.comments && (
                        <CommentSection
                            comments={publication.comments}
                            publicationId={publication.id}
                            onCommentAdded={handleCommentAdded}
                        />
                    )}
                </CardContent>
            </AppleCard>
        </Container>
    );
}

export default Publication;