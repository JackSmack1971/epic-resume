#!/bin/bash

# VS Code Extension Troubleshooting Script for Epic Resume
# Fixes common extension installation issues

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

echo "🛠️ VS Code Extension Troubleshooting for Epic Resume"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if code-server is installed
print_step "Checking VS Code Server installation..."
if command -v code-server &> /dev/null; then
    print_success "VS Code Server is installed"
    CODE_SERVER_VERSION=$(code-server --version | head -1)
    echo "📦 Version: $CODE_SERVER_VERSION"
else
    print_warning "VS Code Server not found. Installing..."
    curl -fsSL https://code-server.dev/install.sh | sh
fi

# Check current extensions
print_step "Checking currently installed extensions..."
CURRENT_EXTENSIONS=$(code-server --list-extensions 2>/dev/null || echo "")
if [ -n "$CURRENT_EXTENSIONS" ]; then
    echo "📦 Currently installed extensions:"
    echo "$CURRENT_EXTENSIONS"
    EXTENSION_COUNT=$(echo "$CURRENT_EXTENSIONS" | wc -l)
    print_success "$EXTENSION_COUNT extensions currently installed"
else
    print_warning "No extensions currently installed"
fi

# Essential extensions for Epic Resume project
print_step "Installing/updating essential extensions for Epic Resume..."

# Core development extensions
CORE_EXTENSIONS=(
    "esbenp.prettier-vscode"              # Code formatting - ESSENTIAL
    "dbaeumer.vscode-eslint"              # Linting - ESSENTIAL
    "ms-vscode.vscode-typescript-next"    # TypeScript support
)

# Web development extensions
WEB_EXTENSIONS=(
    "formulahendry.auto-rename-tag"       # HTML tag utilities
    "christian-kohler.path-intellisense"  # Path completion
    "ritwickdey.liveserver"               # Live reload server
)

# Optional styling extensions
STYLING_EXTENSIONS=(
    "bradlc.vscode-tailwindcss"          # Tailwind CSS (if using)
    "ms-vscode.vscode-css-peek"          # CSS peek functionality
)

install_extension_safely() {
    local extension=$1
    local category=$2
    
    echo "Installing $extension ($category)..."
    
    # Try to install the extension
    if code-server --install-extension "$extension" --force 2>/dev/null; then
        print_success "$extension installed successfully"
        return 0
    else
        # Try alternative installation method
        if code-server --install-extension "$extension" 2>/dev/null; then
            print_success "$extension installed successfully (alternative method)"
            return 0
        else
            print_warning "$extension installation failed"
            return 1
        fi
    fi
}

# Install core extensions
print_step "Installing core development extensions..."
CORE_SUCCESS=0
for extension in "${CORE_EXTENSIONS[@]}"; do
    if install_extension_safely "$extension" "core"; then
        ((CORE_SUCCESS++))
    fi
done

# Install web development extensions
print_step "Installing web development extensions..."
WEB_SUCCESS=0
for extension in "${WEB_EXTENSIONS[@]}"; do
    if install_extension_safely "$extension" "web"; then
        ((WEB_SUCCESS++))
    fi
done

# Install styling extensions
print_step "Installing styling extensions..."
STYLING_SUCCESS=0
for extension in "${STYLING_EXTENSIONS[@]}"; do
    if install_extension_safely "$extension" "styling"; then
        ((STYLING_SUCCESS++))
    fi
done

# Alternative extension installation method
print_step "Trying alternative installation methods for failed extensions..."

# Manual extension installation function
install_extension_manual() {
    local extension=$1
    echo "Attempting manual installation of $extension..."
    
    # Download and install extension manually
    EXTENSION_URL="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/${extension%.*}/vsextensions/${extension#*.}/latest/vspackage"
    
    if curl -s -L "$EXTENSION_URL" > /tmp/"$extension".vsix 2>/dev/null; then
        if code-server --install-extension /tmp/"$extension".vsix --force 2>/dev/null; then
            print_success "$extension installed manually"
            rm -f /tmp/"$extension".vsix
            return 0
        fi
    fi
    
    rm -f /tmp/"$extension".vsix
    return 1
}

# Common problematic extensions and their fixes
PROBLEMATIC_EXTENSIONS=(
    "ms-vscode.vscode-json"               # Often fails - use built-in JSON support
    "pranaygp.vscode-css-peek"           # May be deprecated
    "zignd.html-css-class-completion"    # May have issues
)

print_step "Removing problematic extensions that may cause conflicts..."
for extension in "${PROBLEMATIC_EXTENSIONS[@]}"; do
    if echo "$CURRENT_EXTENSIONS" | grep -q "$extension"; then
        echo "Removing potentially problematic extension: $extension"
        code-server --uninstall-extension "$extension" 2>/dev/null || true
    fi
done

# Create VS Code settings for Epic Resume project
print_step "Creating optimized VS Code settings for Epic Resume..."
mkdir -p /workspace/epic-resume/.vscode

cat > /workspace/epic-resume/.vscode/settings.json << 'EOF'
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],
  "files.associations": {
    "*.css": "css",
    "*.js": "javascript",
    "*.html": "html"
  },
  "emmet.includeLanguages": {
    "javascript": "javascriptreact"
  },
  "css.validate": true,
  "html.validate.styles": true,
  "html.validate.scripts": true,
  "typescript.preferences.includePackageJsonAutoImports": "auto",
  "javascript.preferences.includePackageJsonAutoImports": "auto"
}
EOF

print_success "VS Code settings configured for Epic Resume development"

# Create recommended extensions file
cat > /workspace/epic-resume/.vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "ms-vscode.vscode-typescript-next",
    "formulahendry.auto-rename-tag",
    "christian-kohler.path-intellisense",
    "ritwickdey.liveserver"
  ]
}
EOF

print_success "Extension recommendations file created"

# Final verification
print_step "Final verification of VS Code setup..."

FINAL_EXTENSIONS=$(code-server --list-extensions 2>/dev/null || echo "")
FINAL_COUNT=$(echo "$FINAL_EXTENSIONS" | grep -c . || echo "0")

echo ""
echo "🎯 INSTALLATION SUMMARY:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ Core extensions installed: $CORE_SUCCESS/${#CORE_EXTENSIONS[@]}${NC}"
echo -e "${GREEN}✅ Web development extensions: $WEB_SUCCESS/${#WEB_EXTENSIONS[@]}${NC}"
echo -e "${GREEN}✅ Styling extensions: $STYLING_SUCCESS/${#STYLING_EXTENSIONS[@]}${NC}"
echo -e "${GREEN}✅ Total extensions installed: $FINAL_COUNT${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$FINAL_COUNT" -gt 0 ]; then
    echo -e "${GREEN}🎉 VS Code is ready for Epic Resume development!${NC}"
    echo ""
    echo "📦 Installed extensions:"
    echo "$FINAL_EXTENSIONS"
else
    print_warning "No extensions were installed, but VS Code Server will still work"
    echo "💡 You can install extensions manually from VS Code Server interface"
fi

echo ""
echo "🚀 Next steps:"
echo "1. Access VS Code Server: http://localhost:8080"
echo "2. Password: epicresume2024"
echo "3. Open folder: /workspace/epic-resume"
echo "4. Start coding your Epic Resume! 🎭"

print_success "VS Code extension troubleshooting completed!"
