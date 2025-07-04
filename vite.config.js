import { defineConfig } from 'vite';
import { VitePWA } from 'vite-plugin-pwa';

export default defineConfig({
  build: {
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes('node_modules')) {
            return id
              .toString()
              .split('node_modules/')[1]
              .split('/')[0]
              .toString();
          }
        }
      }
    }
  },
  plugins: [
    VitePWA({
      registerType: 'autoUpdate',
      manifest: {
        name: 'Elias Vaughn - Epic Interactive Resume',
        short_name: 'Epic Resume',
        start_url: '/',
        display: 'standalone',
        background_color: '#0f172a',
        theme_color: '#667eea'
      }
    })
  ]
});
