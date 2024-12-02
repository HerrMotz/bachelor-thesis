// vue.config.js
module.exports = {
    devServer: {
      proxy: {
        '/factgrid-api': {
          target: 'https://database.factgrid.de/api.php',
          changeOrigin: true,
          pathRewrite: { '^/factgrid-api': '' },
          logLevel: 'debug',
        },
      },
    },
  };