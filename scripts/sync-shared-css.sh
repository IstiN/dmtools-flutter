#!/bin/bash

# Script to synchronize shared CSS files between main app and styleguide
# Usage: ./scripts/sync-shared-css.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

MASTER_CSS="$ROOT_DIR/assets/css/shared-theme.css"
MAIN_APP_CSS="$ROOT_DIR/web/css/shared-theme.css"
STYLEGUIDE_CSS="$ROOT_DIR/flutter_styleguide/web/css/shared-theme.css"

echo "🔄 Synchronizing shared CSS files..."

# Check if master file exists
if [ ! -f "$MASTER_CSS" ]; then
    echo "❌ Error: Master CSS file not found at $MASTER_CSS"
    exit 1
fi

# Create directories if they don't exist
mkdir -p "$(dirname "$MAIN_APP_CSS")"
mkdir -p "$(dirname "$STYLEGUIDE_CSS")"

# Copy master file to both locations
echo "📄 Copying $MASTER_CSS to main app..."
cp "$MASTER_CSS" "$MAIN_APP_CSS"

echo "📄 Copying $MASTER_CSS to styleguide..."
cp "$MASTER_CSS" "$STYLEGUIDE_CSS"

# Verify files were copied successfully
if [ -f "$MAIN_APP_CSS" ] && [ -f "$STYLEGUIDE_CSS" ]; then
    echo "✅ Successfully synchronized shared CSS files:"
    echo "   📱 Main app: $MAIN_APP_CSS"
    echo "   🎨 Styleguide: $STYLEGUIDE_CSS"
    
    # Show file sizes for verification
    echo ""
    echo "📊 File sizes:"
    echo "   Master:     $(wc -c < "$MASTER_CSS") bytes"
    echo "   Main app:   $(wc -c < "$MAIN_APP_CSS") bytes"
    echo "   Styleguide: $(wc -c < "$STYLEGUIDE_CSS") bytes"
    
    # Calculate checksums to verify identical files
    MASTER_CHECKSUM=$(shasum -a 256 "$MASTER_CSS" | cut -d' ' -f1)
    MAIN_APP_CHECKSUM=$(shasum -a 256 "$MAIN_APP_CSS" | cut -d' ' -f1)
    STYLEGUIDE_CHECKSUM=$(shasum -a 256 "$STYLEGUIDE_CSS" | cut -d' ' -f1)
    
    if [ "$MASTER_CHECKSUM" = "$MAIN_APP_CHECKSUM" ] && [ "$MASTER_CHECKSUM" = "$STYLEGUIDE_CHECKSUM" ]; then
        echo ""
        echo "🔐 Checksum verification: ✅ All files are identical"
    else
        echo ""
        echo "⚠️  Warning: Checksums don't match - files may not be identical"
        echo "   Master:     $MASTER_CHECKSUM"
        echo "   Main app:   $MAIN_APP_CHECKSUM"
        echo "   Styleguide: $STYLEGUIDE_CHECKSUM"
    fi
else
    echo "❌ Error: Failed to copy one or more files"
    exit 1
fi

echo ""
echo "🎉 CSS synchronization complete!"
echo ""
echo "💡 Next steps:"
echo "   1. Test both applications to ensure styles are working correctly"
echo "   2. Commit the changes to version control"
echo "   3. Run 'flutter analyze' to check for any issues" 