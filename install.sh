#!/bin/bash

# Epic Resume Development Environment Setup Script - FIXED VERSION
# ChromeDriver issue resolved - focuses on essential dependencies only
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

# Function to install package with error handling
install_package_safe() {
    local package=$1
    local description=$2
    
    print_step "Installing $description..."
    if apt-get install -y "$package"; then
        print_success "$description installed successfully"
    else
        print_warning "$description installation failed, continuing..."
    fi
}

# Function to install npm package globally with error handling
install_npm_package_safe() {
    local package=$1
    local description=$2
    
    print_step "Installing $description..."
    if npm install -g "$package" --silent; then
        print_success "$description installed successfully"
    else
        print_warning "$description installation failed, continuing..."
    fi
}

# System update and basic tools
print_step "Updating Ubuntu system and installing essential packages..."
apt-get update -y
apt-get upgrade -y

# Essential system packages
ESSENTIAL_PACKAGES=(
    "curl"
    "wget" 
    "git"
    "build-essential"
    "software-properties-common"
    "apt-transport-https"
    "ca-certificates"
    "gnupg"
    "lsb-release"
    "unzip"
    "vim"
    "nano"
    "htop"
    "tree"
    "jq"
)

for package in "${ESSENTIAL_PACKAGES[@]}"; do
    install_package_safe "$package" "Essential package: $package"
done

print_success "Essential system packages installation completed!"

# Install Node.js (Latest LTS - v20)
print_step "Installing Node.js LTS (v20) via NodeSource repository..."
if curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -; then
    install_package_safe "nodejs" "Node.js LTS"
    
    # Verify Node.js installation
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        NODE_VERSION=$(node --version)
        NPM_VERSION=$(npm --version)
        print_success "Node.js $NODE_VERSION and npm $NPM_VERSION installed successfully!"
    else
        print_error "Node.js installation verification failed"
    fi
else
    print_error "Failed to add NodeSource repository"
fi

# Install Yarn (alternative package manager)
print_step "Installing Yarn package manager..."
if curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
   echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
   apt-get update; then
    
    install_package_safe "yarn" "Yarn package manager"
    
    if command -v yarn &> /dev/null; then
        YARN_VERSION=$(yarn --version)
        print_success "Yarn $YARN_VERSION installed successfully!"
    fi
else
    print_warning "Yarn installation failed, npm will be used instead"
fi

# Install global npm packages for development
print_step "Installing global development tools..."

# Clear npm cache to avoid issues
npm cache clean --force || print_warning "Failed to clean npm cache"

# Set npm configuration for better performance
npm config set audit-level high
npm config set fund false
npm config set update-notifier false

# Essential development packages
ESSENTIAL_NPM_PACKAGES=(
    "vite@latest"
    "serve@latest"
    "http-server@latest"
    "eslint@latest"
    "prettier@latest"
    "typescript@latest"
)

for package in "${ESSENTIAL_NPM_PACKAGES[@]}"; do
    install_npm_package_safe "$package" "Development tool: $package"
done

# Optional development packages
OPTIONAL_NPM_PACKAGES=(
    "nodemon@latest"
    "concurrently@latest"
    "rimraf@latest"
    "lighthouse@latest"
)

print_step "Installing optional development tools..."
for package in "${OPTIONAL_NPM_PACKAGES[@]}"; do
    install_npm_package_safe "$package" "Optional tool: $package"
done

# Verify global package installations
print_step "Verifying global package installations..."
echo "📦 Installed global packages:"
npm list -g --depth=0 2>/dev/null | grep -E "(vite|serve|eslint|prettier|typescript|lighthouse)" || echo "Some packages may not have installed correctly"

print_success "Global development tools installation completed!"

# Install VS Code Server (for container development)
print_step "Installing Visual Studio Code Server..."
if curl -fsSL https://code-server.dev/install.sh | sh; then
    print_success "VS Code Server installed!"
    
    # Configure VS Code Server
    mkdir -p ~/.config/code-server
    cat > ~/.config/code-server/config.yaml << 'EOF'
bind-addr: 0.0.0.0:8080
auth: password
password: epicresume2024
cert: false
EOF
    print_success "VS Code Server configured!"
else
    print_warning "VS Code Server installation failed"
fi

# Install Chrome for testing (without ChromeDriver)
print_step "Setting up Chrome for testing..."
if wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
   echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
   apt-get update; then
    
    install_package_safe "google-chrome-stable" "Google Chrome"
    
    if command -v google-chrome &> /dev/null; then
        CHROME_VERSION=$(google-chrome --version)
        print_success "Chrome installed: $CHROME_VERSION"
    fi
else
    print_warning "Chrome installation failed"
fi

# REMOVED: ChromeDriver installation (causing issues with new Chrome versions)
print_warning "ChromeDriver installation skipped (deprecated distribution method)"
print_warning "For automated testing, consider using @playwright/test or selenium-webdriver with built-in driver management"

# Setup Git configuration (optional - can be customized)
print_step "Configuring Git (default settings)..."
git config --global init.defaultBranch main || true
git config --global pull.rebase false || true
git config --global user.name "Epic Resume Developer" || true
git config --global user.email "developer@epicresume.dev" || true

print_success "Git configured with default settings!"

# Create or update package.json with correct dependencies
print_step "Setting up project workspace..."
if [ ! -d "/workspace" ]; then
    mkdir -p /workspace
fi

cd /workspace

if [ ! -d "epic-resume" ]; then
    print_step "Creating Epic Resume project directory..."
    mkdir -p epic-resume
fi

cd epic-resume

# Create minimal package.json if it doesn't exist
if [ ! -f "package.json" ]; then
    print_step "Creating package.json..."
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
    "start": "npm run dev"
  },
  "keywords": [
    "resume",
    "interactive",
    "glassmorphism",
    "vite",
    "pwa"
  ],
  "author": "Elias Vaughn",
  "license": "MIT",
  "dependencies": {
    "vite": "^4.5.0"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/JackSmack1971/epic-resume.git"
  },
  "homepage": "https://phenomenal-halva-379d04.netlify.app"
}
EOF
    print_success "package.json created!"
fi

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
alias serve="npm run preview"
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
EOF

print_success "Environment variables and aliases configured!"

# Create development helper scripts
print_step "Creating development helper scripts..."

# Create a development startup script
cat > /usr/local/bin/start-dev << 'EOF'
#!/bin/bash
echo "🎭 Starting Epic Resume Development Environment..."

cd /workspace/epic-resume

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start development server
echo "🚀 Starting Vite development server..."
npm run dev &

# Start VS Code Server if available
if command -v code-server &> /dev/null; then
    echo "💻 Starting VS Code Server..."
    code-server --bind-addr 0.0.0.0:8080 /workspace/epic-resume &
fi

echo "✅ Development environment started!"
echo "🌐 Vite dev server: http://localhost:5173"
echo "💻 VS Code Server: http://localhost:8080"
echo "🔐 VS Code password: epicresume2024"
EOF

chmod +x /usr/local/bin/start-dev

print_success "Development helper scripts created!"

# Cleanup
print_step "Cleaning up installation files..."
apt-get autoremove -y || true
apt-get autoclean || true
rm -rf /var/lib/apt/lists/* || true
rm -rf /tmp/* || true

print_success "Cleanup completed!"

# Final verification
print_step "Verifying installation..."

echo ""
echo "🎯 INSTALLATION VERIFICATION:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check critical components
COMPONENTS=(
    "node:Node.js"
    "npm:npm" 
    "vite:Vite"
    "google-chrome:Chrome"
    "code-server:VS Code Server"
)

for component in "${COMPONENTS[@]}"; do
    cmd=$(echo $component | cut -d: -f1)
    name=$(echo $component | cut -d: -f2)
    
    if command -v $cmd &> /dev/null; then
        if [ "$cmd" = "node" ]; then
            version=$(node --version)
        elif [ "$cmd" = "npm" ]; then
            version=$(npm --version)
        elif [ "$cmd" = "google-chrome" ]; then
            version=$(google-chrome --version | awk '{print $3}')
        else
            version="✓"
        fi
        echo -e "${GREEN}✅ $name: $version${NC}"
    else
        echo -e "${RED}❌ $name: Missing${NC}"
    fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo ""
echo "🎭 EPIC RESUME DEVELOPMENT ENVIRONMENT READY!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${PURPLE}🚀 Quick Start Commands:${NC}"
echo -e "${CYAN}  start-dev${NC}       - Start complete development environment"
echo -e "${CYAN}  workspace${NC}       - Navigate to project directory"
echo ""
echo -e "${PURPLE}🌐 Development URLs:${NC}"
echo -e "${CYAN}  Development Server: http://localhost:5173${NC}"
echo -e "${CYAN}  VS Code Server:     http://localhost:8080${NC}"
echo ""
echo -e "${PURPLE}🔐 Default Credentials:${NC}"
echo -e "${CYAN}  VS Code Password:   epicresume2024${NC}"
echo ""
echo -e "${GREEN}✨ Happy coding, Algorithm Artisan!${NC}"
echo -e "${GREEN}   May your glassmorphism be smooth and your animations fluid!${NC}"
echo ""
echo -e "${YELLOW}📝 Note: ChromeDriver skipped due to Google's deprecated distribution method${NC}"
echo -e "${YELLOW}   For automated testing, consider using Playwright or modern testing tools${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

print_success "Epic Resume Development Environment Setup Complete! 🎉"
