#!/bin/bash

# Development build script - preserves __BUILD_VERSION__ placeholders for hot reload
# Usage: ./scripts/dev-build.sh [main|styleguide|both]

set -e

TARGET="${1:-both}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔧 Starting development build..."
echo "📁 Project root: $PROJECT_ROOT"
echo "🎯 Target: $TARGET"

cd "$PROJECT_ROOT"

# Function to build main app for development
build_main_app_dev() {
    echo ""
    echo "📱 Building main app for development..."
    
    # Build the app with debug settings
    echo "🏗️  Running Flutter build for main app (development)..."
    flutter build web --debug --base-href "/" \
        --web-renderer canvaskit \
        --dart-define=WEB_AUTO_DETECT=true
    
    echo "✅ Main app development build completed"
}

# Function to build styleguide for development
build_styleguide_dev() {
    echo ""
    echo "🎨 Building styleguide for development..."
    
    cd flutter_styleguide
    
    # Build the styleguide with debug settings
    echo "🏗️  Running Flutter build for styleguide (development)..."
    flutter build web --debug --base-href "/" \
        --web-renderer canvaskit \
        --dart-define=WEB_AUTO_DETECT=true
    
    cd ..
    echo "✅ Styleguide development build completed"
}

# Function to display development instructions
show_dev_instructions() {
    echo ""
    echo "🎉 Development build completed!"
    echo ""
    echo "🔧 For development:"
    echo "   - Use 'flutter run -d chrome' for hot reload"
    echo "   - Service workers are registered but cache versions are not replaced"
    echo "   - Cache busting is disabled to allow for faster development"
    echo ""
    echo "🚀 For production deployment:"
    echo "   - Use './scripts/build-with-cache-busting.sh' instead"
    echo "   - This will enable proper cache busting and versioning"
    echo ""
}

# Execute based on target
case $TARGET in
    "main")
        build_main_app_dev
        ;;
    "styleguide")
        build_styleguide_dev
        ;;
    "both")
        build_main_app_dev
        build_styleguide_dev
        ;;
    *)
        echo "❌ Invalid target: $TARGET"
        echo "Usage: $0 [main|styleguide|both]"
        exit 1
        ;;
esac

show_dev_instructions