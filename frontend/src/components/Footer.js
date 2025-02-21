import React from 'react';
import { Container, Typography, Link, Grid, Box } from '@mui/material';
import FacebookIcon from '@mui/icons-material/Facebook';
import TwitterIcon from '@mui/icons-material/Twitter';
import InstagramIcon from '@mui/icons-material/Instagram';

function Footer() {
	console.log('Footer rendered');
	return (
		<Box sx={{ backgroundColor: '#f5f5f5', py: 4, mt: 8 }}>
			<Container maxWidth="lg">
				<Grid container spacing={4}>
					<Grid item xs={12} sm={4}>
						<Typography variant="h6" gutterBottom sx={{ color: '#1976D2' }}>
							Система Публикаций
						</Typography>
						<Typography variant="body2" sx={{ color: '#757575' }}>
							Эффективно управляйте научными публикациями.
						</Typography>
					</Grid>
					<Grid item xs={12} sm={4}>
						<Typography variant="h6" gutterBottom sx={{ color: '#1976D2' }}>
							Ссылки
						</Typography>
						<Link href="#" color="#757575" sx={{ display: 'block', mb: 1 }}>
							О нас
						</Link>
						<Link href="#" color="#757575" sx={{ display: 'block', mb: 1 }}>
							Поддержка
						</Link>
						<Link href="#" color="#757575" sx={{ display: 'block', mb: 1 }}>
							Конфиденциальность
						</Link>
					</Grid>
					<Grid item xs={12} sm={4}>
						<Typography variant="h6" gutterBottom sx={{ color: '#1976D2' }}>
							Следите за нами
						</Typography>
						<Box sx={{ display: 'flex', gap: 2 }}>
							<Link href="#" color="#757575">
								<FacebookIcon />
							</Link>
							<Link href="#" color="#757575">
								<TwitterIcon />
							</Link>
							<Link href="#" color="#757575">
								<InstagramIcon />
							</Link>
						</Box>
					</Grid>
				</Grid>
				<Typography variant="body2" align="center" sx={{ mt: 4, color: '#757575' }}>
					© 2025 Система Публикаций. Все права защищены.
				</Typography>
			</Container>
		</Box>
	);
}

export default Footer;