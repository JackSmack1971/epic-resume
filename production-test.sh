#!/bin/bash

# Epic Resume Production Deployment Testing Script
# Tests the live deployment at https://phenomenal-halva-379d04.netlify.app/

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

SITE_URL="https://phenomenal-halva-379d04.netlify.app"
GITHUB_URL="https://github.com/JackSmack1971/epic-resume"

print_step() {
    echo -e "${CYAN}🔍 $1${NC}"
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

print_info() {
    echo -e "${PURPLE}📊 $1${NC}"
}

echo "🎭 Epic Resume Production Deployment Testing"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Site URL: $SITE_URL"
echo "📁 Repository: $GITHUB_URL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1: Basic Connectivity
print_step "Testing basic connectivity..."
if curl -s --head "$SITE_URL" | head -n 1 | grep -q "200 OK"; then
    print_success "Site is accessible"
else
    print_error "Site is not accessible"
    exit 1
fi

# Test 2: SSL Certificate
print_step "Checking SSL certificate..."
if curl -s --head "$SITE_URL" | grep -q "HTTP/2"; then
    print_success "HTTPS enabled with HTTP/2 support"
else
    print_warning "HTTPS may not be properly configured"
fi

# Test 3: Security Headers
print_step "Checking security headers..."
HEADERS=$(curl -s -I "$SITE_URL")

if echo "$HEADERS" | grep -q "X-Frame-Options"; then
    print_success "X-Frame-Options header present"
else
    print_warning "X-Frame-Options header missing"
fi

if echo "$HEADERS" | grep -q "X-Content-Type-Options"; then
    print_success "X-Content-Type-Options header present"
else
    print_warning "X-Content-Type-Options header missing"
fi

if echo "$HEADERS" | grep -q "Content-Security-Policy"; then
    print_success "Content-Security-Policy header present"
else
    print_warning "Content-Security-Policy header missing"
fi

# Test 4: Critical Resources
print_step "Testing critical resources..."

# Test main HTML
if curl -s "$SITE_URL" | grep -q "Elias Vaughn"; then
    print_success "Main HTML content loads correctly"
else
    print_error "Main HTML content issue detected"
fi

# Test CSS loading
if curl -s "$SITE_URL" | grep -q "style.css"; then
    print_success "CSS reference found in HTML"
else
    print_warning "CSS reference not found - may affect styling"
fi

# Test JavaScript loading
if curl -s "$SITE_URL" | grep -q "main.js"; then
    print_success "JavaScript reference found in HTML"
else
    print_error "JavaScript reference not found - site may not function properly"
fi

# Test 5: Meta Tags for SEO
print_step "Checking SEO and social media meta tags..."
HTML_CONTENT=$(curl -s "$SITE_URL")

if echo "$HTML_CONTENT" | grep -q "og:url.*phenomenal-halva-379d04.netlify.app"; then
    print_success "Open Graph URL correctly set"
else
    print_error "Open Graph URL not properly configured"
fi

if echo "$HTML_CONTENT" | grep -q "og:image"; then
    print_success "Open Graph image meta tag present"
else
    print_warning "Open Graph image meta tag missing"
fi

if echo "$HTML_CONTENT" | grep -q "twitter:card"; then
    print_success "Twitter Card meta tags present"
else
    print_warning "Twitter Card meta tags missing"
fi

# Test 6: PWA Manifest
print_step "Testing PWA manifest..."
MANIFEST_URL="$SITE_URL/manifest.json"
if curl -s --head "$MANIFEST_URL" | head -n 1 | grep -q "200"; then
    print_success "PWA manifest accessible"
    
    # Check manifest content
    MANIFEST_CONTENT=$(curl -s "$MANIFEST_URL")
    if echo "$MANIFEST_CONTENT" | grep -q "Epic Interactive Resume"; then
        print_success "PWA manifest content valid"
    else
        print_warning "PWA manifest content may have issues"
    fi
else
    print_warning "PWA manifest not accessible"
fi

# Test 7: Performance Check
print_step "Running basic performance analysis..."

# Test page size
PAGE_SIZE=$(curl -s "$SITE_URL" | wc -c)
PAGE_SIZE_KB=$((PAGE_SIZE / 1024))

if [ $PAGE_SIZE_KB -lt 500 ]; then
    print_success "Page size: ${PAGE_SIZE_KB}KB (Good)"
elif [ $PAGE_SIZE_KB -lt 1000 ]; then
    print_warning "Page size: ${PAGE_SIZE_KB}KB (Acceptable)"
else
    print_warning "Page size: ${PAGE_SIZE_KB}KB (Consider optimization)"
fi

# Test 8: Mobile Responsiveness
print_step "Testing mobile responsiveness indicators..."
if echo "$HTML_CONTENT" | grep -q 'viewport.*width=device-width'; then
    print_success "Mobile viewport meta tag configured"
else
    print_error "Mobile viewport meta tag missing"
fi

# Test 9: Accessibility Features
print_step "Checking accessibility features..."
if echo "$HTML_CONTENT" | grep -q 'aria-label'; then
    print_success "ARIA labels found"
else
    print_warning "ARIA labels not detected"
fi

if echo "$HTML_CONTENT" | grep -q 'alt='; then
    print_success "Image alt attributes found"
else
    print_warning "Image alt attributes not detected"
fi

# Test 10: JavaScript Console Errors (if browser testing tools available)
print_step "Checking for common JavaScript issues..."
if echo "$HTML_CONTENT" | grep -q 'type="module"'; then
    print_success "ES6 modules properly configured"
else
    print_warning "ES6 modules configuration not detected"
fi

# Test 11: External Dependencies
print_step "Testing external dependencies..."
if echo "$HTML_CONTENT" | grep -q 'fonts.googleapis.com'; then
    print_success "Google Fonts reference found"
    
    # Test if Google Fonts is accessible
    if curl -s --head "https://fonts.googleapis.com" | head -n 1 | grep -q "200"; then
        print_success "Google Fonts accessible"
    else
        print_warning "Google Fonts may not be accessible"
    fi
else
    print_info "No external font dependencies detected"
fi

# Test 12: Lighthouse Performance (if available)
print_step "Attempting Lighthouse performance test..."
if command -v lighthouse &> /dev/null; then
    echo "Running Lighthouse audit..."
    lighthouse "$SITE_URL" --output=json --output-path=./live-site-audit.json --chrome-flags="--headless" --quiet
    
    if [ -f ./live-site-audit.json ]; then
        PERFORMANCE_SCORE=$(cat ./live-site-audit.json | grep -o '"performance":[0-9.]*' | cut -d':' -f2)
        ACCESSIBILITY_SCORE=$(cat ./live-site-audit.json | grep -o '"accessibility":[0-9.]*' | cut -d':' -f2)
        
        print_info "Performance Score: ${PERFORMANCE_SCORE:-'N/A'}"
        print_info "Accessibility Score: ${ACCESSIBILITY_SCORE:-'N/A'}"
        
        rm -f ./live-site-audit.json
    fi
else
    print_info "Lighthouse not available for automated testing"
    print_info "Run manually: lighthouse $SITE_URL --view"
fi

# Test Summary
echo ""
echo "🎯 PRODUCTION DEPLOYMENT TEST SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

print_info "🌐 Site URL: $SITE_URL"
print_info "📁 Repository: $GITHUB_URL"
print_info "📊 Page Size: ${PAGE_SIZE_KB}KB"

echo ""
echo "🔧 MANUAL TESTING CHECKLIST:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "□ Open site in multiple browsers (Chrome, Firefox, Safari, Edge)"
echo "□ Test on mobile devices (iOS Safari, Android Chrome)"
echo "□ Verify all animations and glassmorphism effects work"
echo "□ Test theme toggle functionality"
echo "□ Check navigation smooth scrolling"
echo "□ Verify particle effects performance"
echo "□ Test PWA installation (Add to Home Screen)"
echo "□ Check social media sharing (LinkedIn, Twitter)"
echo "□ Verify all sections load and display correctly"
echo "□ Test accessibility with screen readers"

echo ""
echo "🚀 PERFORMANCE OPTIMIZATION RECOMMENDATIONS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "• Run: npm run lighthouse -- for detailed performance audit"
echo "• Consider implementing the CSS optimization from previous recommendations"
echo "• Add WebP image formats for better compression"
echo "• Implement service worker caching for offline support"
echo "• Consider lazy loading for non-critical sections"

echo ""
print_success "Production deployment testing completed! 🎉"

echo ""
echo "💡 Quick Commands for Further Testing:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "# Run Lighthouse audit"
echo "lighthouse $SITE_URL --view"
echo ""
echo "# Test different devices"
echo "lighthouse $SITE_URL --preset=perf --emulated-form-factor=mobile --view"
echo ""
echo "# Check Core Web Vitals"
echo "lighthouse $SITE_URL --only-categories=performance --view"
