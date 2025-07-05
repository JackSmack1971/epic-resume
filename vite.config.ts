import { defineConfig, loadEnv } from 'vite';
import { VitePWA } from 'vite-plugin-pwa';
import { resolve } from 'path';
import type { Plugin } from 'vite';

const createManualChunks = (id: string): string | undefined => {
  if (id.includes('node_modules')) {
    return id.split('node_modules/')[1].split('/')[0];
  }
};

const runtimeCaching = [
  {
    urlPattern: ({ request }) => request.destination === 'image',
    handler: 'CacheFirst',
    options: {
      cacheName: 'images',
      expiration: { maxEntries: 50, maxAgeSeconds: 60 * 60 * 24 * 30 }
    }
  },
  {
    urlPattern: /^https?.*/,
    handler: 'NetworkFirst',
    options: {
      cacheName: 'http-cache',
      networkTimeoutSeconds: 10,
      expiration: { maxEntries: 100, maxAgeSeconds: 60 * 60 * 24 }
    }
  }
];

const createPwaPlugin = (): Plugin =>
  VitePWA({
    registerType: 'autoUpdate',
    injectRegister: 'auto',
    includeAssets: ['favicon.svg', 'robots.txt'],
    manifest: {
      name: 'Elias Vaughn - Epic Interactive Resume',
      short_name: 'Epic Resume',
      start_url: '/',
      display: 'standalone',
      background_color: '#0f172a',
      theme_color: '#667eea'
    },
    workbox: { cleanupOutdatedCaches: true, runtimeCaching }
  });

export default defineConfig(async ({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '');
  const plugins: Plugin[] = [createPwaPlugin()];

  if (env.ANALYZE === 'true') {
    try {
      const { visualizer } = await import('rollup-plugin-visualizer');
      plugins.push(
        visualizer({ open: true, gzipSize: true, brotliSize: true }) as Plugin
      );
    } catch (error) {
      console.warn('Bundle analysis disabled', error);
    }
  }

  const getPostcssPlugins = () => {
    try {
      return [require('autoprefixer'), require('cssnano')];
    } catch {
      return [];
    }
  };

  return {
    build: {
      sourcemap: false,
      cssCodeSplit: true,
      minify: 'terser',
      terserOptions: { compress: { drop_console: true } },
      rollupOptions: {
        input: { main: resolve(__dirname, 'index.html') },
        output: {
          manualChunks: createManualChunks,
          chunkFileNames: 'assets/[name]-[hash].js',
          entryFileNames: 'assets/[name]-[hash].js',
          assetFileNames: 'assets/[name]-[hash][extname]'
        }
      }
    },
    resolve: {
      alias: {
        '/main.js': resolve(__dirname, 'src/main.js'),
        '@': resolve(__dirname, 'src'),
        '@styles': resolve(__dirname, 'src/styles')
      }
    },
    define: {
      __APP_VERSION__: JSON.stringify(env.npm_package_version || '2.0.0')
    },
    css: {
      postcss: { plugins: getPostcssPlugins() }
    },
    plugins,
    server: {
      host: '0.0.0.0',
      port: Number(env.PORT) || 5173,
      open: true,
      strictPort: true
    }
  };
});
