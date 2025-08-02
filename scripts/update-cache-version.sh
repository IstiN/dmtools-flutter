#!/bin/bash

# Script to update cache version for deployment
# This should be run during the build process

set -e

# Generate version based on timestamp and git commit
TIMESTAMP=$(date +%Y%m%d%H%M%S)
GIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_VERSION="${TIMESTAMP}-${GIT_HASH}"

echo "🔄 Updating cache version to: ${BUILD_VERSION}"

# Function to update version in files
update_version() {
    local file="$1"
    if [ -f "$file" ]; then
        echo "   Updating: $file"
        sed -i.bak "s/__BUILD_VERSION__/${BUILD_VERSION}/g" "$file"
        rm -f "${file}.bak"
    else
        echo "   ⚠️  File not found: $file"
    fi
}

# Update main app files
echo "📱 Updating main app cache versions..."
update_version "web/index.html"
update_version "web/manifest.json"
update_version "web/sw.js"

# Update styleguide files
echo "🎨 Updating styleguide cache versions..."
update_version "flutter_styleguide/web/index.html"
update_version "flutter_styleguide/web/manifest.json"
update_version "flutter_styleguide/web/sw.js"

echo "✅ Cache version update completed: ${BUILD_VERSION}"

# Optional: Update CSS and JS files with version query parameters
echo "🔗 Adding version parameters to static resources..."

# Update shared CSS references
find web -name "*.html" -exec sed -i.bak "s/shared-theme\.css/shared-theme.css?v=${BUILD_VERSION}/g" {} \;
find web -name "*.html" -exec sed -i.bak "s/shared-theme\.js/shared-theme.js?v=${BUILD_VERSION}/g" {} \;
find web -name "*.html" -exec sed -i.bak "s/animation_worker\.js/animation_worker.js?v=${BUILD_VERSION}/g" {} \;

find flutter_styleguide/web -name "*.html" -exec sed -i.bak "s/shared-theme\.css/shared-theme.css?v=${BUILD_VERSION}/g" {} \;
find flutter_styleguide/web -name "*.html" -exec sed -i.bak "s/shared-theme\.js/shared-theme.js?v=${BUILD_VERSION}/g" {} \;
find flutter_styleguide/web -name "*.html" -exec sed -i.bak "s/animation_worker\.js/animation_worker.js?v=${BUILD_VERSION}/g" {} \;

# Clean up .bak files
find web -name "*.bak" -delete 2>/dev/null || true
find flutter_styleguide/web -name "*.bak" -delete 2>/dev/null || true

echo "🚀 All cache versions updated successfully!"
echo "💡 Remember to run this script before 'flutter build web' for production!"