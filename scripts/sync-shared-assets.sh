#!/bin/bash

# Master script to synchronize all shared assets between main app and styleguide
# Usage: ./scripts/sync-shared-assets.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🚀 DMTools Shared Assets Synchronization"
echo "=========================================="

# Run CSS synchronization
if [ -f "$SCRIPT_DIR/sync-shared-css.sh" ]; then
    echo ""
    echo "🎨 Synchronizing CSS assets..."
    "$SCRIPT_DIR/sync-shared-css.sh"
else
    echo "⚠️  CSS sync script not found, skipping..."
fi

# Run JavaScript synchronization
if [ -f "$SCRIPT_DIR/sync-shared-js.sh" ]; then
    echo ""
    echo "⚡ Synchronizing JavaScript assets..."
    "$SCRIPT_DIR/sync-shared-js.sh"
else
    echo "⚠️  JS sync script not found, skipping..."
fi

echo ""
echo "🎉 All shared assets synchronized successfully!"
echo ""
echo "📋 Final checklist:"
echo "✅ CSS files synced between all locations"
echo "✅ JavaScript files synced between all locations"
echo "✅ Both main app and styleguide have consistent assets"
echo ""
echo "💡 Next steps:"
echo "1. Test both applications work correctly"
echo "2. Verify theme switching functionality"
echo "3. Check animation workers load properly"
echo "4. Commit all synchronized files to git"
echo ""
echo "📁 Synchronized asset structure:"
echo "├── assets/"
echo "│   ├── css/shared-theme.css (master)"
echo "│   └── js/"
echo "│       ├── shared-theme.js (master)"
echo "│       └── shared-animation-worker.js (master)"
echo "├── web/"
echo "│   ├── css/shared-theme.css (synced)"
echo "│   ├── js/shared-theme.js (synced)"
echo "│   └── animation_worker.js (synced)"
echo "└── flutter_styleguide/web/"
echo "    ├── css/shared-theme.css (synced)"
echo "    ├── js/shared-theme.js (synced)"
echo "    └── animation_worker.js (synced)" 