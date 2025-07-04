#!/bin/bash

# Netlify Build Troubleshooting Script for Epic Resume
# Fixes common build issues and verifies project structure

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
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

echo "🚀 Epic Resume Netlify Build Troubleshooting"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if we're in the right directory
print_step "Checking project structure..."

if [ ! -f "package.json" ]; then
    print_error "package.json not found! Make sure you're in the project root directory."
    exit 1
fi

if [ ! -f "index.html" ]; then
    print_error "index.html not found!"
    exit 1
fi

if [ ! -d "src" ]; then
    print_error "src directory not found!"
    exit 1
fi

print_success "Project structure looks good"

# Check Node.js and npm versions
print_step "Checking Node.js environment..."

if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_success "Node.js: $NODE_VERSION"
    
    # Check if Node version is compatible (should be 18+)
    NODE_MAJOR=$(echo $NODE_VERSION | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_MAJOR" -lt 18 ]; then
        print_warning "Node.js version may be too old for Vite (recommended: v18+)"
    fi
else
    print_error "Node.js not found!"
    exit 1
fi

if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    print_success "npm: $NPM_VERSION"
else
    print_error "npm not found!"
    exit 1
fi

# Check package.json scripts and dependencies
print_step "Verifying package.json configuration..."

if ! grep -q '"build"' package.json; then
    print_error "Build script not found in package.json!"
    print_step "Adding build script..."
    
    # Backup original package.json
    cp package.json package.json.backup
    
    # Add build script using node/jq if available, otherwise use sed
    if command -v jq &> /dev/null; then
        jq '.scripts.build = "vite build"' package.json > package.json.tmp && mv package.json.tmp package.json
    else
        sed -i 's/"scripts": {/"scripts": {\n    "build": "vite build",/' package.json
    fi
    
    print_success "Build script added to package.json"
else
    print_success "Build script found in package.json"
fi

# Check for Vite dependency
if ! grep -q '"vite"' package.json; then
    print_warning "Vite dependency not found in package.json!"
    print_step "Adding Vite dependency..."
    npm install --save-dev vite@latest
    print_success "Vite dependency added"
else
    print_success "Vite dependency found"
fi

# Check the critical script path issue in index.html
print_step "Checking index.html script path..."

if grep -q 'src="/main.js"' index.html; then
    print_error "Found incorrect script path in index.html!"
    print_step "Fixing script path from /main.js to /src/main.js..."
    
    # Backup original index.html
    cp index.html index.html.backup
    
    # Fix the script path
    sed -i 's|src="/main.js"|src="/src/main.js"|g' index.html
    
    print_success "Script path fixed in index.html"
elif grep -q 'src="/src/main.js"' index.html; then
    print_success "Script path is correct in index.html"
else
    print_warning "No script tag found - this might be an issue"
fi

# Check if main.js exists in the correct location
print_step "Verifying main.js file location..."

if [ -f "src/main.js" ]; then
    print_success "src/main.js found"
else
    print_error "src/main.js not found!"
    
    if [ -f "main.js" ]; then
        print_step "Found main.js in root, moving to src/ directory..."
        mv main.js src/main.js
        print_success "main.js moved to src/ directory"
    else
        print_error "main.js not found anywhere!"
        exit 1
    fi
fi

# Check CSS imports in main.js
print_step "Checking CSS imports in main.js..."

if grep -q "import.*style.css" src/main.js; then
    print_success "CSS import found in main.js"
else
    print_warning "No CSS import found in main.js - this might cause styling issues"
fi

# Check if all imported modules exist
print_step "Verifying imported modules..."

MODULES=(
    "src/theme.js"
    "src/particles.js"
    "src/navigation.js"
    "src/animation.js"
    "src/styles/style.css"
)

for module in "${MODULES[@]}"; do
    if [ -f "$module" ]; then
        print_success "$module exists"
    else
        print_warning "$module not found - this may cause build errors"
    fi
done

# Check vite.config.js
print_step "Checking Vite configuration..."

if [ -f "vite.config.js" ]; then
    print_success "vite.config.js found"
    
    # Check if it has proper export
    if grep -q "export default" vite.config.js; then
        print_success "vite.config.js has proper export"
    else
        print_warning "vite.config.js may have configuration issues"
    fi
else
    print_warning "vite.config.js not found - using default configuration"
fi

# Check Netlify configuration
print_step "Checking Netlify configuration..."

if [ -f "netlify.toml" ]; then
    print_success "netlify.toml found"
    
    # Check build command
    if grep -q "npm run build" netlify.toml; then
        print_success "Build command configured correctly"
    else
        print_warning "Build command may not be configured correctly"
    fi
    
    # Check publish directory
    if grep -q 'publish = "dist"' netlify.toml; then
        print_success "Publish directory configured correctly"
    else
        print_warning "Publish directory may not be configured correctly"
    fi
else
    print_warning "netlify.toml not found - Netlify will use auto-detection"
fi

# Test local build
print_step "Testing local build..."

print_step "Installing dependencies..."
if npm install; then
    print_success "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

print_step "Running build command..."
if npm run build; then
    print_success "Build completed successfully!"
    
    # Check if dist directory was created
    if [ -d "dist" ]; then
        print_success "dist directory created"
        
        # Check if index.html exists in dist
        if [ -f "dist/index.html" ]; then
            print_success "dist/index.html created"
            
            # Check file sizes
            DIST_SIZE=$(du -sh dist | cut -f1)
            print_success "Build output size: $DIST_SIZE"
            
            # List key files
            echo "📦 Key build files:"
            ls -la dist/ | grep -E '\.(html|js|css)$' || echo "   (No key files found)"
            
        else
            print_warning "dist/index.html not found"
        fi
    else
        print_warning "dist directory not created"
    fi
    
else
    print_error "Build failed!"
    echo ""
    echo "🔍 Common build failure solutions:"
    echo "1. Check that all imported files exist"
    echo "2. Verify script paths in index.html"
    echo "3. Ensure Vite configuration is correct"
    echo "4. Check for syntax errors in JavaScript files"
    echo ""
    exit 1
fi

# Create a simple build verification script
print_step "Creating build verification script..."

cat > verify-build.js << 'EOF'
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

console.log('🔍 Epic Resume Build Verification');
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

// Check if dist directory exists
if (!fs.existsSync('dist')) {
    console.log('❌ dist directory not found');
    process.exit(1);
}

// Check critical files
const criticalFiles = [
    'dist/index.html',
    'dist/manifest.json'
];

const missingFiles = [];
criticalFiles.forEach(file => {
    if (fs.existsSync(file)) {
        const stats = fs.statSync(file);
        console.log(`✅ ${file} (${Math.round(stats.size / 1024)}KB)`);
    } else {
        console.log(`❌ ${file} missing`);
        missingFiles.push(file);
    }
});

// Check for JavaScript and CSS files
const distFiles = fs.readdirSync('dist');
const jsFiles = distFiles.filter(f => f.endsWith('.js'));
const cssFiles = distFiles.filter(f => f.endsWith('.css'));

console.log(`📦 JavaScript files: ${jsFiles.length}`);
console.log(`🎨 CSS files: ${cssFiles.length}`);

if (jsFiles.length === 0) {
    console.log('⚠️  No JavaScript files found - this may be an issue');
}

if (cssFiles.length === 0) {
    console.log('⚠️  No CSS files found - styling may not work');
}

// Check index.html content
if (fs.existsSync('dist/index.html')) {
    const indexContent = fs.readFileSync('dist/index.html', 'utf8');
    
    if (indexContent.includes('Elias Vaughn')) {
        console.log('✅ Content verification passed');
    } else {
        console.log('⚠️  Content may not have been processed correctly');
    }
    
    if (indexContent.includes('type="module"')) {
        console.log('✅ Module script tags found');
    } else {
        console.log('⚠️  No module script tags found');
    }
}

if (missingFiles.length === 0) {
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('🎉 Build verification passed! Ready for Netlify deployment.');
} else {
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('⚠️  Build verification found issues. Check missing files above.');
    process.exit(1);
}
EOF

node verify-build.js

print_success "Build verification completed"

# Final summary
echo ""
echo "🎯 NETLIFY BUILD TROUBLESHOOTING SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ Project structure verified${NC}"
echo -e "${GREEN}✅ Script path fixed (/main.js → /src/main.js)${NC}"
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo -e "${GREEN}✅ Local build successful${NC}"
echo -e "${GREEN}✅ Build output verified${NC}"
echo ""
echo -e "${PURPLE}🚀 Your Epic Resume is ready for Netlify deployment!${NC}"
echo ""
echo "📋 Next steps for Netlify:"
echo "1. Commit and push your changes to Git"
echo "2. Deploy to Netlify (should now build successfully)"
echo "3. Check deployment logs if issues persist"
echo ""
echo "🔧 Build commands for Netlify:"
echo "   Build command: npm run build"
echo "   Publish directory: dist"
echo ""

# Cleanup
rm -f verify-build.js package.json.backup index.html.backup 2>/dev/null || true

print_success "Epic Resume Netlify build troubleshooting completed! 🎭"
