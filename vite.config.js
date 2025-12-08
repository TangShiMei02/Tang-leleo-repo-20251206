import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  define: {
    // 注入构建时间，作为本地开发时的 fallback
    __BUILD_TIME__: JSON.stringify(new Date().toISOString())
  },
  build: {
    assetsInlineLimit: 0,
    chunkSizeWarningLimit: 2000,
    rollupOptions: {
      external: [
        /wallpaper\/dynamic/,
        /wallpaper\/static/
      ]
    }
  }
})