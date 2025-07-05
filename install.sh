#!/bin/bash

# Codex-Optimized Setup Script for Epic Resume
# Designed specifically for OpenAI Codex workflow
# Focuses on dependency installation and environment preparation only

set -e

echo "🎭 Epic Resume - Codex Setup Starting..."

# Update package list
apt-get update -y

# Install essential system dependencies
apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    software-properties-common \
    ca-certificates \
    gnupg \
    unzip

# Install Node.js LTS (required for Vite)
echo "📦 Installing Node.js LTS..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Verify Node.js installation
NODE_VERSION=$(node --version)
NPM_VERSION=$(npm --version)
echo "✅ Node.js $NODE_VERSION and npm $NPM_VERSION installed"

# Configure npm for optimal performance
npm config set audit-level high
npm config set fund false
npm config set update-notifier false

# Install global development tools (essential only)
echo "🔧 Installing essential global tools..."
npm install -g vite@latest --silent || echo "⚠️ Vite global install failed, will use local"
npm install -g serve@latest --silent || echo "⚠️ Serve global install failed, will use local"

# Set up environment variables for Codex
echo "🌍 Configuring environment..."
cat >> ~/.bashrc << 'EOF'

# Epic Resume Development Environment
export NODE_ENV=development
export VITE_APP_TITLE="Epic Resume"
export VITE_APP_DESCRIPTION="Interactive Resume for Elias Vaughn"

# Helpful aliases for Codex
alias dev="npm run dev"
alias build="npm run build"
alias preview="npm run preview"
alias install-deps="npm install"
EOF

# Create optimized package.json for Codex workflow
echo "📝 Creating package.json..."
cat > package.json << 'EOF'
{
  "name": "epic-resume",
  "version": "1.0.0",
  "description": "Epic Interactive Resume for Elias Vaughn - Neurostrategy Executive",
  "type": "module",
  "main": "src/main.js",
  "scripts": {
    "dev": "vite --host 0.0.0.0 --port 5173",
    "build": "vite build",
    "preview": "vite preview --host 0.0.0.0 --port 4173",
    "install": "npm install",
    "clean": "rm -rf node_modules dist && npm install"
  },
  "keywords": [
    "resume",
    "interactive",
    "glassmorphism",
    "vite",
    "pwa",
    "neurostrategy"
  ],
  "author": "Elias Vaughn <contact@eliusvaughn.com>",
  "license": "MIT",
  "dependencies": {
    "vite": "^4.5.0",
    "vite-plugin-pwa": "^0.20.5"
  },
  "devDependencies": {
    "@babel/core": "^7.22.10",
    "@babel/preset-env": "^7.22.10",
    "babel-jest": "^29.6.4",
    "jest": "^29.6.4",
    "jest-environment-jsdom": "^29.6.4"
  },
  "browserslist": [
    "> 1%",
    "last 2 versions",
    "not dead"
  ],
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/JackSmack1971/epic-resume.git"
  },
  "homepage": "https://phenomenal-halva-379d04.netlify.app"
}
EOF

# Install project dependencies
echo "📦 Installing project dependencies..."
npm install

# Optimize for container performance
echo "⚡ Optimizing for Codex performance..."
# Increase file watchers limit for better development experience
echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf 2>/dev/null || true

# Create basic .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
cat > .gitignore << 'EOF'
node_modules/
dist/
.env
.env.*
.DS_Store
npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOF
fi

# Cleanup
apt-get autoremove -y
apt-get autoclean
rm -rf /var/lib/apt/lists/*

# Verify setup
echo "🔍 Setup verification:"
echo "✅ Node.js: $(node --version)"
echo "✅ npm: $(npm --version)"
echo "✅ Project dependencies: $([ -d node_modules ] && echo 'Installed' || echo 'Missing')"
echo "✅ Package.json: $([ -f package.json ] && echo 'Created' || echo 'Missing')"

echo "🎯 Codex setup completed successfully!"
echo "📝 The agent can now run commands like:"
echo "   • npm run dev (start development server)"
echo "   • npm run build (create production build)"
echo "   • npm run preview (preview production build)"

# Ensure clean exit for Codex
exit 0
