import { defineConfig } from 'vite';
import { VitePWA } from 'vite-plugin-pwa';
import { resolve } from 'path';

export default defineConfig({
  // Ensure proper base path for deployment
  base: '/',
  
  // Define the root directory
  root: '.',
  
  // Public directory for static assets
  publicDir: 'public',
  
  // Build configuration
  build: {
    // Output directory
    outDir: 'dist',
    
    // Clean output directory before build
    emptyOutDir: true,
    
    // Generate source maps for debugging
    sourcemap: false, // Set to true for debugging, false for production
    
    // Minification
    minify: 'esbuild',
    
    // Target modern browsers
    target: ['es2020', 'edge88', 'firefox78', 'chrome87', 'safari13.1'],
    
    // Rollup options
    rollupOptions: {
      // Define entry points explicitly
      input: {
        main: resolve(__dirname, 'index.html')
      },
      
      // Output configuration
      output: {
        // Manual chunk splitting for better caching
        manualChunks: {
          // Vendor chunk for third-party dependencies
          vendor: ['vite'],
          
          // Utils chunk for utility functions
          utils: [
            './src/theme.js',
            './src/particles.js',
            './src/navigation.js',
            './src/animation.js'
          ]
        },
        
        // Asset file naming
        assetFileNames: (assetInfo) => {
          const info = assetInfo.name.split('.');
          let extType = info[info.length - 1];
          
          if (/\.(mp4|webm|ogg|mp3|wav|flac|aac)(\?.*)?$/i.test(assetInfo.name)) {
            extType = 'media';
          } else if (/\.(png|jpe?g|gif|svg|webp|avif)(\?.*)?$/i.test(assetInfo.name)) {
            extType = 'images';
          } else if (/\.(woff2?|eot|ttf|otf)(\?.*)?$/i.test(assetInfo.name)) {
            extType = 'fonts';
          }
          
          return `assets/${extType}/[name]-[hash][extname]`;
        },
        
        // Chunk file naming
        chunkFileNames: 'assets/js/[name]-[hash].js',
        entryFileNames: 'assets/js/[name]-[hash].js'
      },
      
      // External dependencies (none for this project)
      external: []
    },
    
    // CSS code splitting
    cssCodeSplit: true,
    
    // CSS minification
    cssMinify: true,
    
    // Reporting options
    reportCompressedSize: true,
    chunkSizeWarningLimit: 1000
  },
  
  // Development server configuration
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: false,
    open: false,
    cors: true,
    
    // Hot Module Replacement
    hmr: {
      port: 24678
    }
  },
  
  // Preview server configuration
  preview: {
    host: '0.0.0.0',
    port: 4173,
    strictPort: false,
    open: false,
    cors: true
  },
  
  // CSS configuration
  css: {
    // PostCSS configuration
    postcss: {},
    
    // CSS modules configuration
    modules: {
      localsConvention: 'camelCase'
    },
    
    // CSS preprocessor options
    preprocessorOptions: {
      scss: {
        // Add any SCSS global variables here if needed
      }
    }
  },
  
  // Resolve configuration
  resolve: {
    // Path aliases
    alias: {
      '@': resolve(__dirname, 'src'),
      '@assets': resolve(__dirname, 'src/assets'),
      '@styles': resolve(__dirname, 'src/styles'),
      '@components': resolve(__dirname, 'src/components'),
      '@utils': resolve(__dirname, 'src/utils')
    },
    
    // File extensions to resolve
    extensions: ['.js', '.jsx', '.ts', '.tsx', '.json', '.css', '.scss']
  },
  
  // Plugin configuration
  plugins: [
    // PWA Plugin with enhanced configuration
    VitePWA({
      registerType: 'autoUpdate',
      workbox: {
        globPatterns: ['**/*.{js,css,html,ico,png,svg,webp,jpg,jpeg}'],
        runtimeCaching: [
          {
            urlPattern: /^https:\/\/fonts\.googleapis\.com\/.*/i,
            handler: 'CacheFirst',
            options: {
              cacheName: 'google-fonts-cache',
              expiration: {
                maxEntries: 10,
                maxAgeSeconds: 60 * 60 * 24 * 365 // 1 year
              },
              cacheKeyWillBeUsed: async ({ request }) => {
                return `${request.url}`;
              }
            }
          },
          {
            urlPattern: /^https:\/\/fonts\.gstatic\.com\/.*/i,
            handler: 'CacheFirst',
            options: {
              cacheName: 'gstatic-fonts-cache',
              expiration: {
                maxEntries: 10,
                maxAgeSeconds: 60 * 60 * 24 * 365 // 1 year
              }
            }
          }
        ]
      },
      
      // PWA Manifest configuration
      manifest: {
        name: 'Elias Vaughn - Epic Interactive Resume',
        short_name: 'Epic Resume',
        description: 'Neurostrategy Executive with cutting-edge interactive resume featuring glassmorphism, animations, and modern UX',
        start_url: '/',
        display: 'standalone',
        background_color: '#0f172a',
        theme_color: '#667eea',
        orientation: 'portrait-primary',
        scope: '/',
        lang: 'en',
        categories: ['business', 'productivity', 'professional'],
        
        icons: [
          {
            src: '/favicon-192x192.png',
            sizes: '192x192',
            type: 'image/png',
            purpose: 'any maskable'
          },
          {
            src: '/favicon-512x512.png',
            sizes: '512x512',
            type: 'image/png',
            purpose: 'any maskable'
          }
        ],
        
        shortcuts: [
          {
            name: 'View Experience',
            short_name: 'Experience',
            description: 'Jump to professional experience section',
            url: '/#experience',
            icons: [{ src: '/favicon-192x192.png', sizes: '192x192' }]
          },
          {
            name: 'View Skills',
            short_name: 'Skills',
            description: 'Jump to core competencies section',
            url: '/#skills',
            icons: [{ src: '/favicon-192x192.png', sizes: '192x192' }]
          }
        ]
      },
      
      // Development configuration
      devOptions: {
        enabled: false // Set to true if you want PWA in development
      }
    })
  ],
  
  // Optimization configuration
  optimizeDeps: {
    // Include dependencies that should be pre-bundled
    include: [
      'vite-plugin-pwa'
    ],
    
    // Exclude dependencies from pre-bundling
    exclude: [],
    
    // Force optimization of certain dependencies
    force: false
  },
  
  // Environment variables
  define: {
    __APP_VERSION__: JSON.stringify(process.env.npm_package_version || '2.0.0'),
    __BUILD_TIME__: JSON.stringify(new Date().toISOString()),
    __PROD__: JSON.stringify(process.env.NODE_ENV === 'production')
  },
  
  // ESBuild configuration
  esbuild: {
    // Target ES2020 for modern browsers
    target: 'es2020',
    
    // Drop console and debugger in production
    drop: process.env.NODE_ENV === 'production' ? ['console', 'debugger'] : [],
    
    // JSX configuration (if needed in future)
    jsxFactory: 'h',
    jsxFragment: 'Fragment'
  },
  
  // Worker configuration
  worker: {
    format: 'es',
    plugins: []
  },
  
  // JSON configuration
  json: {
    namedExports: true,
    stringify: false
  },
  
  // Environment handling
  envPrefix: ['VITE_', 'EPIC_RESUME_'],
  
  // Logging configuration
  logLevel: 'info',
  clearScreen: true,
  
  // Experimental features
  experimental: {
    renderBuiltUrl: (filename, { hostType }) => {
      if (hostType === 'js') {
        return { js: `/${filename}` };
      } else {
        return { relative: true };
      }
    }
  }
});
