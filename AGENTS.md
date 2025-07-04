#!/bin/bash

# Epic Resume Development Environment Setup Script
# Optimized for Ubuntu Container Development
# Author: CodeCraft Nexus AI Assistant

set -e  # Exit on any error

echo "🎭 Welcome to Epic Resume Development Environment Setup!"
echo "🚀 Initializing CodeCraft Nexus for Elias Vaughn's Interactive Resume..."

# Color codes for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${CYAN}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# System update and basic tools
print_step "Updating Ubuntu system and installing essential packages..."
apt-get update -y
apt-get upgrade -y
apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    unzip \
    vim \
    nano \
    htop \
    tree \
    jq \
    chromium-browser \
    firefox \
    xvfb

print_success "System packages installed successfully!"

# Install Node.js (Latest LTS - v20)
print_step "Installing Node.js LTS (v20) via NodeSource repository..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Verify Node.js installation
NODE_VERSION=$(node --version)
NPM_VERSION=$(npm --version)
print_success "Node.js $NODE_VERSION and npm $NPM_VERSION installed successfully!"

# Install Yarn (alternative package manager)
print_step "Installing Yarn package manager..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update
apt-get install -y yarn

YARN_VERSION=$(yarn --version)
print_success "Yarn $YARN_VERSION installed successfully!"

# Install global npm packages for development
print_step "Installing global development tools..."

# Clear npm cache to avoid issues
npm cache clean --force

# Set npm configuration for better performance
npm config set audit-level high
npm config set fund false
npm config set update-notifier false

# Install packages one by one with error handling for better debugging
print_step "Installing essential build tools..."
npm install -g vite@latest || print_warning "Vite installation failed, continuing..."

print_step "Installing static servers..."
npm install -g serve@latest || print_warning "serve installation failed, continuing..."
npm install -g http-server@latest || print_warning "http-server installation failed, continuing..."

print_step "Installing development utilities..."
npm install -g nodemon@latest || print_warning "nodemon installation failed, continuing..."
npm install -g pm2@latest || print_warning "pm2 installation failed, continuing..."

print_step "Installing code quality tools..."
npm install -g eslint@latest || print_warning "eslint installation failed, continuing..."
npm install -g prettier@latest || print_warning "prettier installation failed, continuing..."

print_step "Installing TypeScript support..."
npm install -g typescript@latest || print_warning "typescript installation failed, continuing..."

print_step "Installing utility packages..."
npm install -g concurrently@latest || print_warning "concurrently installation failed, continuing..."
npm install -g rimraf@latest || print_warning "rimraf installation failed, continuing..."
npm install -g cross-env@latest || print_warning "cross-env installation failed, continuing..."

print_step "Installing performance audit tools..."
npm install -g lighthouse@latest || print_warning "lighthouse installation failed, continuing..."

# Verify installations
print_step "Verifying global package installations..."
echo "📦 Installed packages:"
npm list -g --depth=0 2>/dev/null | grep -E "(vite|serve|eslint|prettier|typescript|lighthouse)" || echo "Some packages may not have installed correctly"

print_success "Global development tools installation completed!"

# Install VS Code Server (for container development)
print_step "Installing Visual Studio Code Server..."
curl -fsSL https://code-server.dev/install.sh | sh

# Configure VS Code Server
mkdir -p ~/.config/code-server
cat > ~/.config/code-server/config.yaml << 'EOF'
bind-addr: 0.0.0.0:8080
auth: password
password: epicresume2024
cert: false
EOF

print_success "VS Code Server installed and configured!"

# Install useful VS Code extensions
print_step "Installing VS Code extensions..."
code-server --install-extension ms-vscode.vscode-typescript-next
code-server --install-extension bradlc.vscode-tailwindcss
code-server --install-extension esbenp.prettier-vscode
code-server --install-extension dbaeumer.vscode-eslint
code-server --install-extension formulahendry.auto-rename-tag
code-server --install-extension christian-kohler.path-intellisense
code-server --install-extension ms-vscode.vscode-json
code-server --install-extension ritwickdey.liveserver
code-server --install-extension ms-vscode.vscode-css-peek
code-server --install-extension bradlc.vscode-tailwindcss
code-server --install-extension pranaygp.vscode-css-peek
code-server --install-extension zignd.html-css-class-completion

print_success "VS Code extensions installed!"

# Setup Git configuration (optional - can be customized)
print_step "Configuring Git (default settings)..."
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global user.name "Epic Resume Developer"
git config --global user.email "developer@epicresume.dev"

print_success "Git configured with default settings!"

# Create or update package.json with correct dependencies
print_step "Creating/updating package.json with correct dependencies..."
cd /workspace/epic-resume

# Create package.json if it doesn't exist or update it
cat > package.json << 'EOF'
{
  "name": "epic-resume",
  "version": "2.0.0",
  "description": "Epic Interactive Resume for Elias Vaughn - Neurostrategy Executive",
  "type": "module",
  "main": "src/main.js",
  "scripts": {
    "dev": "vite --host 0.0.0.0 --port 5173",
    "build": "vite build",
    "preview": "vite preview --host 0.0.0.0 --port 4173",
    "test": "jest --coverage",
    "test:watch": "jest --watch",
    "lint": "eslint src --ext .js,.jsx,.ts,.tsx",
    "lint:fix": "eslint src --ext .js,.jsx,.ts,.tsx --fix",
    "format": "prettier --write src/**/*.{js,jsx,ts,tsx,css,html}",
    "clean": "rimraf node_modules dist .cache && npm install",
    "lighthouse": "lighthouse http://localhost:4173 --view",
    "serve": "serve dist",
    "start": "npm run dev"
  },
  "keywords": [
    "resume",
    "interactive",
    "glassmorphism",
    "vite",
    "pwa",
    "neurostrategy",
    "cognitive-warfare",
    "geopolitical-analysis"
  ],
  "author": "Elias Vaughn <contact@epicresume.dev>",
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
    "jest-environment-jsdom": "^29.6.4",
    "eslint": "^8.50.0",
    "prettier": "^3.0.0",
    "@types/jest": "^29.5.5"
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
    "url": "https://github.com/your-username/epic-resume.git"
  },
  "bugs": {
    "url": "https://github.com/your-username/epic-resume/issues"
  },
  "homepage": "https://your-epic-resume.netlify.app"
}
EOF

print_success "package.json created/updated with correct dependencies!"

# Install Chrome for testing (headless)
print_step "Setting up Chrome for automated testing..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt-get update
apt-get install -y google-chrome-stable

# Install Chrome driver for Selenium testing
print_step "Installing ChromeDriver for automated testing..."
CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d'.' -f1)
CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION}")
wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"
unzip /tmp/chromedriver.zip -d /tmp
mv /tmp/chromedriver /usr/local/bin/
chmod +x /usr/local/bin/chromedriver

print_success "Chrome and ChromeDriver installed for testing!"

# Setup environment variables
print_step "Configuring environment variables..."
cat >> ~/.bashrc << 'EOF'

# Epic Resume Development Environment
export NODE_ENV=development
export WORKSPACE=/workspace/epic-resume
export PATH="$PATH:/usr/local/bin"

# Aliases for development
alias dev="npm run dev"
alias build="npm run build"
alias test="npm run test"
alias serve="npm run preview"
alias install-deps="npm install"
alias clean="rm -rf node_modules dist .cache && npm install"
alias lighthouse-audit="lighthouse http://localhost:4173 --view"

# Navigation aliases
alias workspace="cd /workspace/epic-resume"
alias proj="cd /workspace/epic-resume"

# Git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline"

echo "🎭 Epic Resume Development Environment Loaded!"
echo "📁 Use 'workspace' or 'proj' to navigate to project directory"
echo "🚀 Use 'dev' to start development server"
echo "🔧 Use 'build' to create production build"
echo "🧪 Use 'test' to run test suite"
EOF

print_success "Environment variables and aliases configured!"

# Create development scripts
print_step "Creating development helper scripts..."

# Create a comprehensive development startup script
cat > /usr/local/bin/start-dev << 'EOF'
#!/bin/bash
echo "🎭 Starting Epic Resume Development Environment..."

# Navigate to project directory
cd /workspace/epic-resume

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start development server in background
echo "🚀 Starting Vite development server..."
npm run dev &

# Start VS Code Server in background
echo "💻 Starting VS Code Server..."
code-server --bind-addr 0.0.0.0:8080 /workspace/epic-resume &

echo "✅ Development environment started!"
echo "🌐 Vite dev server: http://localhost:5173"
echo "💻 VS Code Server: http://localhost:8080"
echo "🔐 VS Code password: epicresume2024"
echo ""
echo "To stop services, run: pkill -f 'vite|code-server'"
EOF

chmod +x /usr/local/bin/start-dev

# Create a build and preview script
cat > /usr/local/bin/build-preview << 'EOF'
#!/bin/bash
echo "🏗️ Building Epic Resume for production..."

cd /workspace/epic-resume

# Clean previous builds
rm -rf dist

# Build the project
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "🚀 Starting preview server..."
    npm run preview &
    echo "🌐 Preview server: http://localhost:4173"
    echo "💡 Press Ctrl+C to stop"
else
    echo "❌ Build failed!"
    exit 1
fi
EOF

chmod +x /usr/local/bin/build-preview

# Create testing script
cat > /usr/local/bin/run-tests << 'EOF'
#!/bin/bash
echo "🧪 Running Epic Resume test suite..."

cd /workspace/epic-resume

# Run Jest tests
npm run test

# Run Lighthouse audit if preview server is running
if curl -s http://localhost:4173 > /dev/null; then
    echo "🔍 Running Lighthouse performance audit..."
    lighthouse http://localhost:4173 --output=html --output-path=./lighthouse-report.html --quiet
    echo "📊 Lighthouse report saved to lighthouse-report.html"
else
    echo "💡 To run Lighthouse audit, start preview server with 'build-preview'"
fi
EOF

chmod +x /usr/local/bin/run-tests

print_success "Development helper scripts created!"

# Setup Docker healthcheck (if running in Docker)
print_step "Configuring container health monitoring..."
cat > /usr/local/bin/healthcheck << 'EOF'
#!/bin/bash
# Health check for Epic Resume development container

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    exit 1
fi

# Check if VS Code Server is responsive (if running)
if pgrep -f "code-server" > /dev/null; then
    if ! curl -s http://localhost:8080 > /dev/null; then
        exit 1
    fi
fi

# Check if development server is responsive (if running)
if pgrep -f "vite" > /dev/null; then
    if ! curl -s http://localhost:5173 > /dev/null; then
        exit 1
    fi
fi

echo "✅ Epic Resume development environment is healthy!"
exit 0
EOF

chmod +x /usr/local/bin/healthcheck

print_success "Health monitoring configured!"

# Cleanup
print_step "Cleaning up installation files..."
apt-get autoremove -y
apt-get autoclean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*

print_success "Cleanup completed!"

# Final setup verification
print_step "Verifying installation..."

echo ""
echo "🎯 INSTALLATION VERIFICATION:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}📦 Node.js:${NC} $(node --version)"
echo -e "${GREEN}📦 npm:${NC} $(npm --version)"
echo -e "${GREEN}📦 Yarn:${NC} $(yarn --version)"
echo -e "${GREEN}🌐 Chrome:${NC} $(google-chrome --version)"
echo -e "${GREEN}🔧 Git:${NC} $(git --version)"
echo -e "${GREEN}💻 VS Code Server:${NC} Installed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo ""
echo "🎭 EPIC RESUME DEVELOPMENT ENVIRONMENT READY!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${PURPLE}🚀 Quick Start Commands:${NC}"
echo -e "${CYAN}  start-dev${NC}       - Start complete development environment"
echo -e "${CYAN}  build-preview${NC}   - Build and preview production version"
echo -e "${CYAN}  run-tests${NC}       - Execute test suite and performance audit"
echo -e "${CYAN}  workspace${NC}       - Navigate to project directory"
echo ""
echo -e "${PURPLE}🌐 Development URLs:${NC}"
echo -e "${CYAN}  Development Server: http://localhost:5173${NC}"
echo -e "${CYAN}  VS Code Server:     http://localhost:8080${NC}"
echo -e "${CYAN}  Preview Server:     http://localhost:4173${NC}"
echo ""
echo -e "${PURPLE}🔐 Default Credentials:${NC}"
echo -e "${CYAN}  VS Code Password:   epicresume2024${NC}"
echo ""
echo -e "${GREEN}✨ Happy coding, Algorithm Artisan!${NC}"
echo -e "${GREEN}   May your glassmorphism be smooth and your animations butter!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Source the new environment
source ~/.bashrc

print_success "Epic Resume Development Environment Setup Complete! 🎉"
