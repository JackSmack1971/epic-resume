import { defineConfig } from 'vite';
import { VitePWA } from 'vite-plugin-pwa';
import { resolve } from 'path';

export default defineConfig({
  // Define the entry point explicitly to resolve path issues
  build: {
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html')
      },
      // Handle the main.js path resolution automatically
      external: [],
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
  
  // Resolve configuration to handle path aliases
  resolve: {
    alias: {
      // Map /main.js to the actual file location
      '/main.js': resolve(__dirname, 'src/main.js'),
      '@': resolve(__dirname, 'src'),
      '@styles': resolve(__dirname, 'src/styles')
    }
  },
  
  // Define environment variables
  define: {
    __APP_VERSION__: JSON.stringify('2.0.0')
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
