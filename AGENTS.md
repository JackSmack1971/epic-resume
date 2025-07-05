# Epic Resume - Codex Agent Instructions

## Project Overview
This is an interactive resume project built with Vite, featuring glassmorphism design and modern animations.

## Development Commands
- `npm run dev` - Start development server on port 5173
- `npm run build` - Create production build in `dist/` directory  
- `npm run preview` - Preview production build on port 4173
- `npm install` - Install dependencies

## Project Structure
```
/
├── src/
│   ├── main.js          # Entry point
│   ├── theme.js         # Theme toggling
│   ├── particles.js     # Particle effects
│   ├── navigation.js    # Navigation logic
│   ├── animation.js     # Scroll animations
│   └── styles/
│       └── style.css    # Main stylesheet
├── index.html           # Main HTML file
├── package.json         # Dependencies and scripts
├── vite.config.js       # Vite configuration
└── manifest.json        # PWA manifest
```

## Development Guidelines
- The project uses ES6 modules (`type: "module"` in package.json)
- Main script is loaded via `<script type="module" src="/src/main.js">`
- Vite handles hot module replacement automatically
- All styles are in CSS custom properties for theming support

## Testing the Project
1. Run `npm run dev` to start development server
2. Visit http://localhost:5173 to view the site
3. Test theme toggle, navigation, and responsive design
4. Run `npm run build` to verify production build works
5. Run `npm run preview` to test the production build

## Common Tasks
- **Add new sections**: Update index.html and corresponding JavaScript modules
- **Modify styling**: Edit `src/styles/style.css` using CSS custom properties
- **Update content**: Modify the HTML content in index.html
- **Add functionality**: Create new modules in `src/` and import in `main.js`

## Performance Notes
- Project uses modern CSS features (custom properties, glassmorphism effects)
- Particle effects are optimized for performance
- Images should be optimized for web (WebP format recommended)
- Build process automatically optimizes assets via Vite
