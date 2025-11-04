#!/bin/bash
set -e

# Pack macOS Flutter app with embedded DMTools server
# Usage: ./pack-macos.sh <flutter-app-path> <server-bundle-zip> <output-dir> <version>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_APP_PATH="$1"
SERVER_BUNDLE_ZIP="$2"
OUTPUT_DIR="$3"
VERSION="$4"

if [ -z "$FLUTTER_APP_PATH" ] || [ -z "$SERVER_BUNDLE_ZIP" ] || [ -z "$OUTPUT_DIR" ] || [ -z "$VERSION" ]; then
    echo "Usage: $0 <flutter-app-path> <server-bundle-zip> <output-dir> <version>"
    echo "Example: $0 build/macos/Build/Products/Release/dmtools.app dmtools-server-api-macos-aarch64.zip dist v1.0.0"
    exit 1
fi

echo "📦 Packing DMTools macOS Application"
echo "Flutter App: $FLUTTER_APP_PATH"
echo "Server Bundle: $SERVER_BUNDLE_ZIP"
echo "Output Directory: $OUTPUT_DIR"
echo "Version: $VERSION"

# Create output directory
mkdir -p "$OUTPUT_DIR"
TEMP_DIR=$(mktemp -d)

# Extract server bundle
echo "🔓 Extracting server bundle..."
unzip -q "$SERVER_BUNDLE_ZIP" -d "$TEMP_DIR"

# Find server directory (supports both standalone and api-only bundles)
SERVER_DIR=$(find "$TEMP_DIR" -type d \( -name "dmtools-standalone-*" -o -name "dmtools-server-api-*" \) | head -1)

if [ -z "$SERVER_DIR" ]; then
    echo "❌ Error: Could not find server directory in bundle"
    echo "📂 Available directories:"
    find "$TEMP_DIR" -type d -maxdepth 2
    exit 1
fi

echo "✅ Server extracted to: $SERVER_DIR"

# Copy Flutter app to temp location
echo "📱 Copying Flutter app..."
APP_NAME="DMTools.app"
TEMP_APP="$TEMP_DIR/$APP_NAME"
cp -R "$FLUTTER_APP_PATH" "$TEMP_APP"

# Create Resources directory inside app bundle
RESOURCES_DIR="$TEMP_APP/Contents/Resources"
mkdir -p "$RESOURCES_DIR/server"

# Copy server files into app bundle
echo "🔧 Embedding server into app bundle..."
cp -R "$SERVER_DIR"/* "$RESOURCES_DIR/server/"

# Create launcher script that only starts the server (app wrapper will launch the app)
echo "📝 Creating server launcher script..."
cat > "$RESOURCES_DIR/server/start-server.sh" << 'EOF'
#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/dmtools-server.log"

# Default server port
SERVER_PORT="${DMTOOLS_PORT:-8080}"

# Check if port is available
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 1
    fi
    return 0
}

# Start server
start_server() {
    local port=$1
    echo "🚀 Starting DMTools server on port $port..." >> "$LOG_FILE"
    
    # Start server in background
    cd "$SCRIPT_DIR"
    ./run.sh --server.port=$port >> "$LOG_FILE" 2>&1 &
    SERVER_PID=$!
    
    # Save PID for cleanup
    echo $SERVER_PID > "$SCRIPT_DIR/server.pid"
    
    echo "⏳ Waiting for server to start (PID: $SERVER_PID)..." >> "$LOG_FILE"
    
    # Wait for server to be ready (max 60 seconds)
    for i in {1..60}; do
        if curl -s "http://localhost:$port/actuator/health" > /dev/null 2>&1; then
            echo "✅ Server is ready on port $port!" >> "$LOG_FILE"
            return 0
        fi
        
        # Check if process died (configuration error)
        if ! ps -p $SERVER_PID > /dev/null 2>&1; then
            echo "❌ Server process died. Checking for configuration errors..." >> "$LOG_FILE"
            
            # Check for common configuration errors
            if grep -q "Could not resolve placeholder 'jwt.secret'" "$LOG_FILE"; then
                osascript -e 'display dialog "DMTools Server Configuration Error\n\nThe server bundle is missing required configuration (jwt.secret).\n\nThis is an API-only bundle that requires external configuration.\n\nPlease use a standalone bundle or configure the server properly." buttons {"OK"} default button "OK" with icon caution with title "Configuration Missing"'
                return 1
            elif grep -q "Could not resolve placeholder" "$LOG_FILE"; then
                osascript -e 'display dialog "DMTools Server Configuration Error\n\nThe server bundle is missing required configuration.\n\nCheck the log file for details:\n'$LOG_FILE'" buttons {"OK"} default button "OK" with icon caution with title "Configuration Missing"'
                return 1
            else
                osascript -e 'display dialog "DMTools Server Failed to Start\n\nThe server stopped unexpectedly.\n\nCheck the log file for details:\n'$LOG_FILE'" buttons {"OK"} default button "OK" with icon caution with title "Server Error"'
                return 1
            fi
        fi
        
        sleep 1
    done
    
    echo "❌ Server failed to start within 60 seconds. Check log: $LOG_FILE" >> "$LOG_FILE"
    return 1
}

# Prompt for port if default is busy
if ! check_port $SERVER_PORT; then
    echo "⚠️  Port $SERVER_PORT is busy" >> "$LOG_FILE"
    
    # Show dialog to user
    NEW_PORT=$(osascript -e "set dialogResult to display dialog \"Port $SERVER_PORT is already in use. Please enter a different port:\" default answer \"8081\" buttons {\"Cancel\", \"OK\"} default button \"OK\" with title \"DMTools Server Port\"" -e "text returned of dialogResult" 2>/dev/null)
    
    if [ -z "$NEW_PORT" ]; then
        osascript -e "display dialog \"DMTools server could not start. Port $SERVER_PORT is busy.\" buttons {\"OK\"} default button \"OK\" with icon caution with title \"DMTools\""
        exit 1
    fi
    
    SERVER_PORT=$NEW_PORT
    
    if ! check_port $SERVER_PORT; then
        osascript -e "display dialog \"Port $SERVER_PORT is also busy. Please close other applications and try again.\" buttons {\"OK\"} default button \"OK\" with icon caution with title \"DMTools\""
        exit 1
    fi
fi

# Start the server
if start_server $SERVER_PORT; then
    # Save port for app to use
    echo $SERVER_PORT > "$SCRIPT_DIR/server-port.txt"
    echo "Server started successfully on port $SERVER_PORT" >> "$LOG_FILE"
    exit 0
else
    osascript -e "display dialog \"Failed to start DMTools server. Check console for details.\" buttons {\"OK\"} default button \"OK\" with icon caution with title \"DMTools\""
    exit 1
fi
EOF

chmod +x "$RESOURCES_DIR/server/start-server.sh"

# Create app startup script that launches the server first
echo "📝 Creating app wrapper..."
MACOS_DIR="$TEMP_APP/Contents/MacOS"
ORIGINAL_EXEC=$(ls "$MACOS_DIR" | grep -v "launcher" | head -1)

if [ -n "$ORIGINAL_EXEC" ]; then
    # Rename original executable
    mv "$MACOS_DIR/$ORIGINAL_EXEC" "$MACOS_DIR/${ORIGINAL_EXEC}.bin"
    
    # Create wrapper script
    cat > "$MACOS_DIR/$ORIGINAL_EXEC" <<'WRAPPER_SCRIPT'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="$SCRIPT_DIR/../Resources"
SERVER_PID_FILE="$RESOURCES_DIR/server/server.pid"

# Function to stop server
stop_server() {
    echo "🛑 Stopping server..." >> "$RESOURCES_DIR/server/dmtools-server.log"
    if [ -f "$SERVER_PID_FILE" ]; then
        SERVER_PID=$(cat "$SERVER_PID_FILE")
        if ps -p $SERVER_PID > /dev/null 2>&1; then
            echo "Killing server process $SERVER_PID" >> "$RESOURCES_DIR/server/dmtools-server.log"
            kill $SERVER_PID 2>/dev/null || kill -9 $SERVER_PID 2>/dev/null
            rm -f "$SERVER_PID_FILE"
        fi
    fi
    
    # Clean up port file
    rm -f "$RESOURCES_DIR/server/server-port.txt"
}

# Set up trap to stop server on exit
trap stop_server EXIT INT TERM

# Check for old server instances and clean them up
if [ -f "$SERVER_PID_FILE" ]; then
    OLD_PID=$(cat "$SERVER_PID_FILE")
    if ps -p $OLD_PID > /dev/null 2>&1; then
        echo "⚠️  Found old server instance (PID: $OLD_PID), stopping it..." >> "$RESOURCES_DIR/server/dmtools-server.log"
        kill $OLD_PID 2>/dev/null || kill -9 $OLD_PID 2>/dev/null
    fi
    rm -f "$SERVER_PID_FILE"
    rm -f "$RESOURCES_DIR/server/server-port.txt"
fi

# Check if server is already running
if [ -f "$RESOURCES_DIR/server/server-port.txt" ]; then
    SERVER_PORT=$(cat "$RESOURCES_DIR/server/server-port.txt")
    if curl -s "http://localhost:$SERVER_PORT/actuator/health" > /dev/null 2>&1; then
        # Server already running, just launch app and wait for it
        "$SCRIPT_DIR/EXEC_NAME_PLACEHOLDER.bin" --server-port=$SERVER_PORT "$@"
        # When app exits, trap will clean up server
        exit $?
    fi
fi

# Server not running, start it first
"$RESOURCES_DIR/server/start-server.sh"

# Check if server started successfully
if [ -f "$RESOURCES_DIR/server/server-port.txt" ]; then
    SERVER_PORT=$(cat "$RESOURCES_DIR/server/server-port.txt")
    # Launch app with server port (this will block until app exits)
    "$SCRIPT_DIR/EXEC_NAME_PLACEHOLDER.bin" --server-port=$SERVER_PORT "$@"
    # When app exits, trap will clean up server
    exit $?
else
    # Server failed to start, exit
    exit 1
fi
WRAPPER_SCRIPT

    # Replace placeholder with actual executable name
    sed -i '' "s/EXEC_NAME_PLACEHOLDER/${ORIGINAL_EXEC}/g" "$MACOS_DIR/$ORIGINAL_EXEC"
    
    chmod +x "$MACOS_DIR/$ORIGINAL_EXEC"
fi

# Update Info.plist with version
if [ -f "$TEMP_APP/Contents/Info.plist" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION" "$TEMP_APP/Contents/Info.plist" 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $VERSION" "$TEMP_APP/Contents/Info.plist" 2>/dev/null || true
fi

# Create DMG with drag & drop window
echo "💿 Creating DMG with installation window..."
DMG_NAME="DMTools-$VERSION-macos-$(uname -m).dmg"
DMG_PATH="$OUTPUT_DIR/$DMG_NAME"

# Remove old DMG if exists
rm -f "$DMG_PATH"

# Create temporary folder for DMG contents
DMG_TEMP="$TEMP_DIR/dmg_contents"
mkdir -p "$DMG_TEMP"

# Copy app to DMG folder
cp -R "$TEMP_APP" "$DMG_TEMP/DMTools.app"

# Create symbolic link to Applications folder
ln -s /Applications "$DMG_TEMP/Applications"

# Create temporary DMG
TEMP_DMG="$TEMP_DIR/temp.dmg"
hdiutil create -volname "DMTools $VERSION" -srcfolder "$DMG_TEMP" -ov -format UDRW "$TEMP_DMG"

# Mount the temporary DMG
MOUNT_DIR="/Volumes/DMTools $VERSION"
hdiutil attach "$TEMP_DMG" -mountpoint "$MOUNT_DIR"

# Configure Finder window appearance
sleep 2
osascript <<EOD
tell application "Finder"
    tell disk "DMTools $VERSION"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {100, 100, 600, 400}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 100
        set position of item "DMTools.app" of container window to {125, 150}
        set position of item "Applications" of container window to {375, 150}
        update without registering applications
        close
    end tell
end tell
EOD

# Sync and unmount
sync
hdiutil detach "$MOUNT_DIR"

# Convert to compressed final DMG
hdiutil convert "$TEMP_DMG" -format UDZO -o "$DMG_PATH"

# Cleanup
rm -rf "$TEMP_DIR"

echo "✅ macOS package created: $DMG_PATH"
echo "📊 Size: $(du -h "$DMG_PATH" | cut -f1)"

