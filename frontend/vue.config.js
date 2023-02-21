const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true
})
module.exports = {
  devServer: {
    proxy: {
      '^/calculate_isbn13_check_digit': {
        target: 'http://127.0.0.1:4567',
        ws: true,
        changeOrigin: true
      }
    }
  }
};
