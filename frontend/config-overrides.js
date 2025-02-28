const webpack = require('webpack');

module.exports = function override(config) {
	// Добавляем fallback для модулей Node.js
	config.resolve.fallback = {
		...config.resolve.fallback,
		buffer: require.resolve('buffer/'), // Полифилл для buffer
		fs: false, // Отключаем fs, так как он не нужен в браузере
	};

	// Добавляем плагин ProvidePlugin для автоматического предоставления Buffer
	config.plugins = [
		...config.plugins,
		new webpack.ProvidePlugin({
			Buffer: ['buffer', 'Buffer'],
		}),
	];

	return config;
};