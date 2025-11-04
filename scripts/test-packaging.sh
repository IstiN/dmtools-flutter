#!/bin/bash
set -e

# Test packaging script - builds and packages DMTools locally
# Usage: ./test-packaging.sh [server-version] [server-bundle-path]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SERVER_VERSION="${1:-v1.7.77}"
SERVER_BUNDLE_PATH="$2"

echo "🧪 Testing DMTools Packaging"
echo "Project Root: $PROJECT_ROOT"
echo "Server Version: $SERVER_VERSION"

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    MACOS_ARCH="aarch64"
elif [ "$ARCH" = "x86_64" ]; then
    MACOS_ARCH="x64"
else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
fi

echo "Architecture: $MACOS_ARCH"

# Download server bundle if not provided
if [ -z "$SERVER_BUNDLE_PATH" ]; then
    echo "📥 Downloading server bundle..."
    BUNDLE_NAME="dmtools-server-api-macos-${MACOS_ARCH}.zip"
    BUNDLE_PATH="$PROJECT_ROOT/$BUNDLE_NAME"
    
    if [ -f "$BUNDLE_PATH" ]; then
        echo "✅ Using existing bundle: $BUNDLE_PATH"
    else
        DOWNLOAD_URL="https://github.com/IstiN/dmtools/releases/download/$SERVER_VERSION/$BUNDLE_NAME"
        echo "Downloading from: $DOWNLOAD_URL"
        
        curl -L -o "$BUNDLE_PATH" "$DOWNLOAD_URL"
        
        if [ $? -ne 0 ]; then
            echo "❌ Failed to download server bundle"
            echo "Please download manually from:"
            echo "$DOWNLOAD_URL"
            exit 1
        fi
        
        echo "✅ Downloaded: $(du -h "$BUNDLE_PATH" | cut -f1)"
    fi
    
    SERVER_BUNDLE_PATH="$BUNDLE_PATH"
else
    if [ ! -f "$SERVER_BUNDLE_PATH" ]; then
        echo "❌ Server bundle not found: $SERVER_BUNDLE_PATH"
        exit 1
    fi
    echo "✅ Using provided bundle: $SERVER_BUNDLE_PATH"
fi

# Build Flutter app for macOS
echo "🔨 Building Flutter app for macOS..."
cd "$PROJECT_ROOT"

# Check if flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "Flutter version:"
flutter --version

echo "Getting dependencies..."
flutter pub get

echo "Building macOS app..."
flutter build macos --release

FLUTTER_APP_PATH="$PROJECT_ROOT/build/macos/Build/Products/Release/dmtools.app"

if [ ! -d "$FLUTTER_APP_PATH" ]; then
    echo "❌ Flutter build failed - app not found at: $FLUTTER_APP_PATH"
    exit 1
fi

echo "✅ Flutter app built: $FLUTTER_APP_PATH"

# Package the app
echo "📦 Packaging app with server..."
OUTPUT_DIR="$PROJECT_ROOT/dist-test"
mkdir -p "$OUTPUT_DIR"

"$SCRIPT_DIR/pack-macos.sh" \
    "$FLUTTER_APP_PATH" \
    "$SERVER_BUNDLE_PATH" \
    "$OUTPUT_DIR" \
    "$SERVER_VERSION"

echo ""
echo "✅ Packaging test complete!"
echo ""
echo "📂 Output directory: $OUTPUT_DIR"
echo "📦 Package contents:"
ls -lh "$OUTPUT_DIR"

echo ""
echo "🧪 To test the package:"
echo "  1. Open the DMG file: open $OUTPUT_DIR/*.dmg"
echo "  2. Drag DMTools to Applications"
echo "  3. Launch DMTools from Applications"
echo "  4. If port 8080 is busy, enter an alternative port when prompted"
echo ""
echo "🧹 To clean up test build:"
echo "  rm -rf $OUTPUT_DIR"
echo "  rm -f $SERVER_BUNDLE_PATH"
echo ""

