#!/bin/bash

# Complete build script with cache busting for production deployment
# Usage: ./scripts/build-with-cache-busting.sh [main|styleguide|both]

set -e

TARGET="${1:-both}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🏗️  Starting production build with cache busting..."
echo "📁 Project root: $PROJECT_ROOT"
echo "🎯 Target: $TARGET"

cd "$PROJECT_ROOT"

# Function to build main app
build_main_app() {
    echo ""
    echo "📱 Building main app..."
    
    # Update cache versions
    echo "🔄 Updating main app cache versions..."
    bash scripts/update-cache-version.sh
    
    # Build the app
    echo "🏗️  Running Flutter build for main app..."
    flutter build web --release --base-href "/" \
        --web-renderer canvaskit \
        --dart-define=WEB_AUTO_DETECT=true
    
    echo "✅ Main app build completed"
}

# Function to build styleguide
build_styleguide() {
    echo ""
    echo "🎨 Building styleguide..."
    
    cd flutter_styleguide
    
    # Update cache versions
    echo "🔄 Updating styleguide cache versions..."
    cd ..
    bash scripts/update-cache-version.sh
    cd flutter_styleguide
    
    # Build the styleguide
    echo "🏗️  Running Flutter build for styleguide..."
    flutter build web --release --base-href "/" \
        --web-renderer canvaskit \
        --dart-define=WEB_AUTO_DETECT=true
    
    cd ..
    echo "✅ Styleguide build completed"
}

# Function to display post-build instructions
show_post_build_instructions() {
    echo ""
    echo "🎉 Build completed successfully!"
    echo ""
    echo "📋 Post-build checklist:"
    echo "   1. Deploy the built files to your hosting service"
    echo "   2. Ensure your server sends proper cache headers:"
    echo "      - HTML files: Cache-Control: no-cache"
    echo "      - JS/CSS files: Cache-Control: max-age=31536000 (1 year)"
    echo "      - Service Worker: Cache-Control: no-cache"
    echo "   3. Test in incognito mode first to verify changes"
    echo "   4. Clear browser cache for testing in regular mode"
    echo ""
    echo "🔧 Server Configuration Example (nginx):"
    echo "   location ~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {"
    echo "       expires 1y;"
    echo "       add_header Cache-Control \"public, immutable\";"
    echo "   }"
    echo ""
    echo "   location ~* \\.(html|htm|js)$ {"
    echo "       add_header Cache-Control \"no-cache, no-store, must-revalidate\";"
    echo "   }"
    echo ""
    echo "💡 For Safari cache issues:"
    echo "   - Service workers will force updates on deployment"
    echo "   - Users may need to refresh once after first deployment"
    echo "   - Incognito mode will always show latest version"
}

# Execute based on target
case $TARGET in
    "main")
        build_main_app
        ;;
    "styleguide")
        build_styleguide
        ;;
    "both")
        build_main_app
        build_styleguide
        ;;
    *)
        echo "❌ Invalid target: $TARGET"
        echo "Usage: $0 [main|styleguide|both]"
        exit 1
        ;;
esac

show_post_build_instructions