#!/bin/bash

# Package macOS Flutter app with embedded DMTools server
# Usage: ./scripts/package-macos.sh <version> <arch>
# Example: ./scripts/package-macos.sh 1.7.77 aarch64

set -e

VERSION="${1:-latest}"
ARCH="${2:-aarch64}"  # aarch64 or x64
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build/macos-package"
RELEASE_DIR="$PROJECT_ROOT/build/release"

echo "🚀 Packaging DMTools Flutter App for macOS ($ARCH)"
echo "📦 Version: $VERSION"
echo "🏗️  Build Directory: $BUILD_DIR"

# Clean build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$RELEASE_DIR"

# Step 1: Build Flutter macOS app
echo ""
echo "📱 Step 1: Building Flutter macOS app..."
cd "$PROJECT_ROOT"
flutter clean
flutter pub get
flutter build macos --release

# Copy built app to build directory
cp -R "$PROJECT_ROOT/build/macos/Build/Products/Release/dmtools.app" "$BUILD_DIR/"

# Step 2: Download DMTools server bundle
echo ""
echo "📥 Step 2: Downloading DMTools server bundle..."
SERVER_BUNDLE="dmtools-server-api-macos-${ARCH}.zip"

if [ "$VERSION" = "latest" ]; then
    DOWNLOAD_URL="https://github.com/IstiN/dmtools/releases/latest/download/${SERVER_BUNDLE}"
else
    DOWNLOAD_URL="https://github.com/IstiN/dmtools/releases/download/v${VERSION}/${SERVER_BUNDLE}"
fi

echo "Downloading from: $DOWNLOAD_URL"
curl -L -o "$BUILD_DIR/${SERVER_BUNDLE}" "$DOWNLOAD_URL"

# Step 3: Extract server bundle into app
echo ""
echo "📦 Step 3: Embedding server into app bundle..."
SERVER_DIR="$BUILD_DIR/dmtools.app/Contents/Resources/server"
mkdir -p "$SERVER_DIR"
unzip -q "$BUILD_DIR/${SERVER_BUNDLE}" -d "$BUILD_DIR/temp-server"

# Move extracted server files
EXTRACTED_DIR=$(ls -d "$BUILD_DIR/temp-server/dmtools-server-api-macos-${ARCH}")
mv "$EXTRACTED_DIR"/* "$SERVER_DIR/"
rm -rf "$BUILD_DIR/temp-server"
rm "$BUILD_DIR/${SERVER_BUNDLE}"

# Make run.sh executable
chmod +x "$SERVER_DIR/run.sh"

# Step 4: Create launcher script
echo ""
echo "🔧 Step 4: Creating launcher script..."
cat > "$BUILD_DIR/dmtools.app/Contents/Resources/launch-dmtools.sh" << 'LAUNCHER_EOF'
#!/bin/bash

# DMTools Launcher - Starts server then opens Flutter app
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$SCRIPT_DIR/server"
APP_DIR="$(cd "$SCRIPT_DIR/../MacOS" && pwd)"
LOG_DIR="$HOME/.dmtools/logs"
PID_FILE="$HOME/.dmtools/server.pid"

mkdir -p "$LOG_DIR"
mkdir -p "$(dirname "$PID_FILE")"

echo "🚀 Starting DMTools..."

# Function to check if port is available
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 1  # Port is busy
    else
        return 0  # Port is available
    fi
}

# Function to wait for server to be ready
wait_for_server() {
    local port=$1
    local max_attempts=60
    local attempt=0
    
    echo "⏳ Waiting for server to start on port $port..."
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s "http://localhost:$port/actuator/health" > /dev/null 2>&1; then
            echo "✅ Server is ready!"
            return 0
        fi
        sleep 1
        attempt=$((attempt + 1))
        echo -n "."
    done
    
    echo ""
    echo "❌ Server failed to start within 60 seconds"
    return 1
}

# Check if server is already running
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if ps -p "$OLD_PID" > /dev/null 2>&1; then
        echo "ℹ️  Server is already running (PID: $OLD_PID)"
        PORT=$(lsof -Pan -p "$OLD_PID" -i 2>/dev/null | grep LISTEN | awk '{print $9}' | cut -d: -f2 | head -1)
        if [ -z "$PORT" ]; then
            PORT=8080
        fi
    else
        rm "$PID_FILE"
    fi
fi

# Determine server port
SERVER_PORT=8080

if ! check_port $SERVER_PORT; then
    echo "⚠️  Port $SERVER_PORT is already in use"
    
    # Try to find an available port
    for port in 8081 8082 8083 8084 8085 8090 8888 9090; do
        if check_port $port; then
            SERVER_PORT=$port
            echo "✅ Using alternative port: $SERVER_PORT"
            break
        fi
    done
    
    # If no port found, ask user
    if ! check_port $SERVER_PORT; then
        # Use osascript to show dialog
        USER_PORT=$(osascript -e 'text returned of (display dialog "Port 8080-9090 are busy. Enter a custom port:" default answer "9999")')
        if [ -n "$USER_PORT" ]; then
            SERVER_PORT=$USER_PORT
        else
            echo "❌ No port selected. Exiting."
            exit 1
        fi
    fi
fi

echo "🌐 Starting DMTools server on port $SERVER_PORT..."

# Start server in background
cd "$SERVER_DIR"
export SERVER_PORT
nohup ./run.sh --server.port=$SERVER_PORT > "$LOG_DIR/server.log" 2>&1 &
SERVER_PID=$!
echo $SERVER_PID > "$PID_FILE"

echo "📝 Server PID: $SERVER_PID"
echo "📄 Log file: $LOG_DIR/server.log"

# Wait for server to be ready
if wait_for_server $SERVER_PORT; then
    # Launch Flutter app
    echo "🎨 Launching DMTools UI..."
    
    # Set server URL environment variable for Flutter app
    export DMTOOLS_SERVER_URL="http://localhost:$SERVER_PORT"
    
    # Launch the Flutter app
    "$APP_DIR/dmtools" &
    
    echo "✅ DMTools is running!"
    echo "   Server: http://localhost:$SERVER_PORT"
    echo "   Logs: $LOG_DIR/server.log"
    echo ""
    echo "To stop the server, run: kill $SERVER_PID"
else
    echo "❌ Failed to start server. Check logs at: $LOG_DIR/server.log"
    kill $SERVER_PID 2>/dev/null || true
    rm "$PID_FILE"
    exit 1
fi
LAUNCHER_EOF

chmod +x "$BUILD_DIR/dmtools.app/Contents/Resources/launch-dmtools.sh"

# Step 5: Update Info.plist to use launcher script
echo ""
echo "📝 Step 5: Updating app configuration..."
INFO_PLIST="$BUILD_DIR/dmtools.app/Contents/Info.plist"

# Backup original Info.plist
cp "$INFO_PLIST" "$INFO_PLIST.backup"

# Create a wrapper executable that calls the launcher script
cat > "$BUILD_DIR/dmtools.app/Contents/MacOS/dmtools-launcher" << 'WRAPPER_EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/../Resources/launch-dmtools.sh"
WRAPPER_EOF

chmod +x "$BUILD_DIR/dmtools.app/Contents/MacOS/dmtools-launcher"

# Step 6: Create distribution package
echo ""
echo "📦 Step 6: Creating distribution package..."

APP_NAME="DMTools-${VERSION}-macos-${ARCH}"
DIST_DIR="$BUILD_DIR/${APP_NAME}"
mkdir -p "$DIST_DIR"

# Copy app
cp -R "$BUILD_DIR/dmtools.app" "$DIST_DIR/"

# Create README
cat > "$DIST_DIR/README.txt" << 'README_EOF'
DMTools for macOS
=================

Installation:
1. Copy dmtools.app to your Applications folder
2. Double-click dmtools.app to launch

First Launch:
- macOS may show a security warning for unsigned apps
- Go to System Preferences → Privacy & Security → Allow
- Or right-click the app → Open → Open

The app will:
1. Start the DMTools server (on port 8080 or next available)
2. Wait for the server to be ready
3. Launch the Flutter UI

Server Logs:
- Located at: ~/.dmtools/logs/server.log

Stopping the Server:
- The server runs in the background
- To stop it, check ~/.dmtools/server.pid for the process ID
- Or use: pkill -f dmtools-server

Troubleshooting:
- If port 8080 is busy, the app will automatically try alternative ports
- Check server logs at ~/.dmtools/logs/server.log for issues
- Ensure you have at least 2GB RAM available

Version: ${VERSION}
Architecture: ${ARCH}
README_EOF

# Create uninstall script
cat > "$DIST_DIR/uninstall.sh" << 'UNINSTALL_EOF'
#!/bin/bash

echo "🗑️  Uninstalling DMTools..."

# Stop server
if [ -f "$HOME/.dmtools/server.pid" ]; then
    PID=$(cat "$HOME/.dmtools/server.pid")
    kill $PID 2>/dev/null && echo "✅ Stopped server (PID: $PID)"
    rm "$HOME/.dmtools/server.pid"
fi

# Remove data (ask user)
read -p "Remove all DMTools data? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$HOME/.dmtools"
    echo "✅ Removed DMTools data"
fi

# Remove app (ask user for path)
read -p "Remove app from /Applications? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "/Applications/dmtools.app"
    echo "✅ Removed application"
fi

echo "✅ Uninstall complete!"
UNINSTALL_EOF

chmod +x "$DIST_DIR/uninstall.sh"

# Create ZIP archive
cd "$BUILD_DIR"
zip -r -q "$RELEASE_DIR/${APP_NAME}.zip" "${APP_NAME}"

# Calculate checksum
cd "$RELEASE_DIR"
shasum -a 256 "${APP_NAME}.zip" > "${APP_NAME}.zip.sha256"

echo ""
echo "✅ Package created successfully!"
echo ""
echo "📦 Package: $RELEASE_DIR/${APP_NAME}.zip"
echo "🔐 SHA256: $RELEASE_DIR/${APP_NAME}.zip.sha256"
echo ""
echo "📊 Package size:"
du -h "$RELEASE_DIR/${APP_NAME}.zip"
echo ""
echo "🧪 To test the package:"
echo "   unzip $RELEASE_DIR/${APP_NAME}.zip"
echo "   open ${APP_NAME}/dmtools.app"

