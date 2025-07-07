#!/bin/bash

# Script to synchronize shared JavaScript files between main app and styleguide
# Usage: ./scripts/sync-shared-js.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# JavaScript files to sync
MASTER_THEME_JS="$ROOT_DIR/assets/js/shared-theme.js"
MASTER_ANIMATION_JS="$ROOT_DIR/assets/js/shared-animation-worker.js"

MAIN_APP_THEME_JS="$ROOT_DIR/web/js/shared-theme.js"
MAIN_APP_ANIMATION_JS="$ROOT_DIR/web/animation_worker.js"

STYLEGUIDE_THEME_JS="$ROOT_DIR/flutter_styleguide/web/js/shared-theme.js"
STYLEGUIDE_ANIMATION_JS="$ROOT_DIR/flutter_styleguide/web/animation_worker.js"

echo "🔄 Synchronizing shared JavaScript files..."

# Check if master files exist
if [ ! -f "$MASTER_THEME_JS" ]; then
    echo "❌ Error: Master theme JS file not found at $MASTER_THEME_JS"
    exit 1
fi

if [ ! -f "$MASTER_ANIMATION_JS" ]; then
    echo "❌ Error: Master animation JS file not found at $MASTER_ANIMATION_JS"
    exit 1
fi

# Create directories if they don't exist
mkdir -p "$(dirname "$MAIN_APP_THEME_JS")"
mkdir -p "$(dirname "$STYLEGUIDE_THEME_JS")"

# Copy theme JS files
echo "📄 Copying $MASTER_THEME_JS to main app..."
cp "$MASTER_THEME_JS" "$MAIN_APP_THEME_JS"

echo "📄 Copying $MASTER_THEME_JS to styleguide..."
cp "$MASTER_THEME_JS" "$STYLEGUIDE_THEME_JS"

# Copy animation worker JS files
echo "📄 Copying $MASTER_ANIMATION_JS to main app..."
cp "$MASTER_ANIMATION_JS" "$MAIN_APP_ANIMATION_JS"

echo "📄 Copying $MASTER_ANIMATION_JS to styleguide..."
cp "$MASTER_ANIMATION_JS" "$STYLEGUIDE_ANIMATION_JS"

# Verify files were copied
echo ""
echo "✅ Verification:"
echo "Main app theme JS:      $([ -f "$MAIN_APP_THEME_JS" ] && echo "✓ EXISTS" || echo "✗ MISSING")"
echo "Main app animation JS:  $([ -f "$MAIN_APP_ANIMATION_JS" ] && echo "✓ EXISTS" || echo "✗ MISSING")"
echo "Styleguide theme JS:    $([ -f "$STYLEGUIDE_THEME_JS" ] && echo "✓ EXISTS" || echo "✗ MISSING")"
echo "Styleguide animation JS: $([ -f "$STYLEGUIDE_ANIMATION_JS" ] && echo "✓ EXISTS" || echo "✗ MISSING")"

echo ""
echo "🎉 JavaScript synchronization complete!"
echo ""
echo "📋 Next steps:"
echo "1. Update HTML files to include shared-theme.js"
echo "2. Test theme switching in both applications"
echo "3. Verify animation workers load correctly"
echo "4. Commit all synchronized JavaScript files" 