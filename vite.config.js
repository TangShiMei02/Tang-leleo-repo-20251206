import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  build: {
    assetsInlineLimit: 0,          // 禁止内联任何资源
    chunkSizeWarningLimit: 2000,   // 把警告阈值调到 2 MB，避免误报
    rollupOptions: {
      external: [                  // 让 rollup 完全不理这些大文件
        /wallpaper\/dynamic/,
        /wallpaper\/static/
      ]
    }
  }
})