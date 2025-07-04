# Epic Resume

This project showcases an interactive resume for Elias Vaughn using modern web design techniques. It is built as a static website, optimized for SEO and social sharing.

## Running Locally

You can view the resume locally by serving the directory with any static file server. If you have Node.js installed, you can use `vite` or `serve`:

```bash
# Install a static server (if you don't have one)
npm install -g serve

# Start the server on http://localhost:3000
serve .
```

Then open [http://localhost:3000](http://localhost:3000) in your browser.

Alternatively, open `index.html` directly in a browser.

## Development dependencies

All optional tooling and utilities are listed in `dev-packages.txt`. This file
collects Node and system packages used during local development. It is excluded
from automated Python package installs on Netlify.

## Deployment

This site can be hosted on services like Netlify or any static file host. The `netlify.toml` configuration is provided for Netlify deploys.

