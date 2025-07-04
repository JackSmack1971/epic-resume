#!/bin/bash

# Epic Resume Development Environment Troubleshooting Script
# Fixes common issues and optimizes the development setup

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_step() {
    echo -e "${CYAN}🔧 $1${NC}"
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

echo "🛠️ Epic Resume Environment Troubleshooting"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check system requirements
print_step "Checking system requirements..."

# Check Ubuntu version
if command -v lsb_release &> /dev/null; then
    UBUNTU_VERSION=$(lsb_release -rs)
    echo "📋 Ubuntu Version: $UBUNTU_VERSION"
    if (( $(echo "$UBUNTU_VERSION >= 20.04" | bc -l) )); then
        print_success "Ubuntu version is compatible"
    else
        print_warning "Ubuntu version may be too old (recommended: 20.04+)"
    fi
else
    print_warning "Cannot determine Ubuntu version"
fi

# Check memory
MEMORY_GB=$(free -g | grep '^Mem:' | awk '{print $2}')
echo "💾 Available Memory: ${MEMORY_GB}GB"
if [ "$MEMORY_GB" -ge 2 ]; then
    print_success "Memory requirements met"
else
    print_warning "Low memory detected (recommended: 4GB+)"
fi

# Check disk space
DISK_SPACE=$(df -h / | awk 'NR==2{print $4}')
echo "💽 Available Disk Space: $DISK_SPACE"

print_step "Diagnosing Node.js environment..."

# Check Node.js installation
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_success "Node.js installed: $NODE_VERSION"
    
    # Check if Node version is compatible
    NODE_MAJOR=$(echo $NODE_VERSION | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_MAJOR" -ge 18 ]; then
        print_success "Node.js version is compatible"
    else
        print_warning "Node.js version may be too old (recommended: v18+)"
        print_step "Updating Node.js to latest LTS..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
        apt-get install -y nodejs
    fi
else
    print_error "Node.js not found! Installing..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt-get install -y nodejs
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    print_success "npm installed: $NPM_VERSION"
else
    print_error "npm not found!"
fi

# Fix npm configuration issues
print_step "Fixing npm configuration..."
npm config delete proxy 2>/dev/null || true
npm config delete https-proxy 2>/dev/null || true
npm config delete http-proxy 2>/dev/null || true
npm config set registry https://registry.npmjs.org/
npm config set audit-level high
npm config set fund false
npm config set update-notifier false

# Clear npm cache
print_step "Clearing npm cache..."
npm cache clean --force

# Check global packages
print_step "Checking global packages..."
echo "📦 Currently installed global packages:"
npm list -g --depth=0 2>/dev/null || echo "No global packages found"

# Install missing essential packages
print_step "Installing/updating essential packages..."

ESSENTIAL_PACKAGES=(
    "vite@latest"
    "serve@latest" 
    "eslint@latest"
    "prettier@latest"
    "typescript@latest"
)

for package in "${ESSENTIAL_PACKAGES[@]}"; do
    package_name=$(echo $package | cut -d'@' -f1)
    echo "Installing $package_name..."
    if npm install -g "$package" --silent; then
        print_success "$package_name installed successfully"
    else
        print_warning "$package_name installation failed, skipping..."
    fi
done

# Check Yarn
print_step "Checking Yarn installation..."
if command -v yarn &> /dev/null; then
    YARN_VERSION=$(yarn --version)
    print_success "Yarn installed: $YARN_VERSION"
else
    print_step "Installing Yarn..."
    npm install -g yarn@latest
fi

# Check browsers
print_step "Checking browser installations..."

if command -v google-chrome &> /dev/null; then
    CHROME_VERSION=$(google-chrome --version)
    print_success "Chrome installed: $CHROME_VERSION"
else
    print_warning "Chrome not found"
    print_step "Installing Chrome..."
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
    apt-get update
    apt-get install -y google-chrome-stable
fi

# Check VS Code Server
print_step "Checking VS Code Server..."
if command -v code-server &> /dev/null; then
    print_success "VS Code Server is installed"
else
    print_step "Installing VS Code Server..."
    curl -fsSL https://code-server.dev/install.sh | sh
fi

# Test project setup
print_step "Testing project environment..."

# Navigate to workspace
if [ -d "/workspace/epic-resume" ]; then
    cd /workspace/epic-resume
    print_success "Project directory found"
    
    # Check package.json
    if [ -f "package.json" ]; then
        print_success "package.json found"
        
        # Install project dependencies
        print_step "Installing project dependencies..."
        if npm install; then
            print_success "Project dependencies installed successfully"
        else
            print_warning "Some dependencies may have failed to install"
        fi
        
        # Test build
        print_step "Testing build process..."
        if npm run build; then
            print_success "Build process works correctly"
        else
            print_warning "Build process encountered issues"
        fi
        
    else
        print_warning "package.json not found in project directory"
    fi
else
    print_warning "Project directory not found at /workspace/epic-resume"
    print_step "Creating project directory..."
    mkdir -p /workspace/epic-resume
fi

# Check ports availability
print_step "Checking port availability..."
PORTS=(5173 4173 8080)
for port in "${PORTS[@]}"; do
    if netstat -tuln | grep ":$port " > /dev/null; then
        print_warning "Port $port is in use"
        echo "   To free port $port: sudo fuser -k $port/tcp"
    else
        print_success "Port $port is available"
    fi
done

# Performance optimization
print_step "Applying performance optimizations..."

# Increase file watchers limit
echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf
sysctl -p > /dev/null 2>&1 || true

# Optimize npm for container environment
npm config set cache-min 86400
npm config set cache-max 864000

print_success "Performance optimizations applied"

# Create quick test
print_step "Creating environment test..."
cat > /tmp/test-env.js << 'EOF'
#!/usr/bin/env node

console.log('🧪 Epic Resume Environment Test');
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

try {
    // Test Node.js
    console.log('✅ Node.js:', process.version);
    
    // Test ES modules
    const fs = require('fs');
    console.log('✅ File system access: Working');
    
    // Test async/await
    (async () => {
        console.log('✅ Async/await: Working');
        
        // Test basic Vite functionality
        try {
            require('vite');
            console.log('✅ Vite: Available');
        } catch (e) {
            console.log('⚠️ Vite: Not available globally');
        }
        
        console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        console.log('🎭 Environment test completed!');
    })();
    
} catch (error) {
    console.error('❌ Environment test failed:', error.message);
}
EOF

node /tmp/test-env.js
rm /tmp/test-env.js

# Final verification
print_step "Final environment verification..."

echo ""
echo "🎯 TROUBLESHOOTING SUMMARY:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check all critical components
COMPONENTS=(
    "node:Node.js"
    "npm:npm" 
    "yarn:Yarn"
    "vite:Vite"
    "google-chrome:Chrome"
    "code-server:VS Code Server"
)

for component in "${COMPONENTS[@]}"; do
    cmd=$(echo $component | cut -d: -f1)
    name=$(echo $component | cut -d: -f2)
    
    if command -v $cmd &> /dev/null; then
        echo -e "${GREEN}✅ $name: Available${NC}"
    else
        echo -e "${RED}❌ $name: Missing${NC}"
    fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Provide next steps
echo ""
echo "🚀 NEXT STEPS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${CYAN}1. Navigate to project: cd /workspace/epic-resume${NC}"
echo -e "${CYAN}2. Install dependencies: npm install${NC}"
echo -e "${CYAN}3. Start development: npm run dev${NC}"
echo -e "${CYAN}4. Access at: http://localhost:5173${NC}"
echo ""
echo -e "${PURPLE}🔧 To run this troubleshooter again: ./troubleshoot.sh${NC}"
echo ""

print_success "Troubleshooting completed! Your Epic Resume environment should now be ready! 🎉"
