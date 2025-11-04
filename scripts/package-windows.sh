#!/bin/bash

# Package Windows Flutter app with embedded DMTools server
# Usage: ./scripts/package-windows.sh <version>
# Example: ./scripts/package-windows.sh 1.7.77
# Note: This script must be run on macOS/Linux. Use package-windows.ps1 for native Windows builds.

set -e

VERSION="${1:-latest}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build/windows-package"
RELEASE_DIR="$PROJECT_ROOT/build/release"

echo "🚀 Packaging DMTools Flutter App for Windows"
echo "📦 Version: $VERSION"
echo "🏗️  Build Directory: $BUILD_DIR"

# Clean build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$RELEASE_DIR"

# Step 1: Build Flutter Windows app
echo ""
echo "📱 Step 1: Building Flutter Windows app..."
cd "$PROJECT_ROOT"

# Check if running on macOS/Linux
if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "⚠️  Warning: Building Windows app on $OSTYPE"
    echo "    For best results, run this on Windows or use GitHub Actions"
    echo ""
    # We can still prepare the structure, Flutter Windows build needs Windows
fi

flutter clean
flutter pub get

# Try to build Windows (will work only on Windows)
if flutter build windows --release 2>/dev/null; then
    echo "✅ Flutter Windows build successful"
    cp -R "$PROJECT_ROOT/build/windows/x64/runner/Release" "$BUILD_DIR/dmtools"
else
    echo "⚠️  Skipping Flutter build (not on Windows)"
    echo "    Creating package structure for manual build..."
    mkdir -p "$BUILD_DIR/dmtools"
fi

# Step 2: Download DMTools server bundle
echo ""
echo "📥 Step 2: Downloading DMTools server bundle..."
SERVER_BUNDLE="dmtools-server-api-windows-x64.zip"

if [ "$VERSION" = "latest" ]; then
    DOWNLOAD_URL="https://github.com/IstiN/dmtools/releases/latest/download/${SERVER_BUNDLE}"
else
    DOWNLOAD_URL="https://github.com/IstiN/dmtools/releases/download/v${VERSION}/${SERVER_BUNDLE}"
fi

echo "Downloading from: $DOWNLOAD_URL"
curl -L -o "$BUILD_DIR/${SERVER_BUNDLE}" "$DOWNLOAD_URL"

# Step 3: Extract server bundle into app
echo ""
echo "📦 Step 3: Embedding server into app..."
SERVER_DIR="$BUILD_DIR/dmtools/server"
mkdir -p "$SERVER_DIR"
unzip -q "$BUILD_DIR/${SERVER_BUNDLE}" -d "$BUILD_DIR/temp-server"

# Move extracted server files
EXTRACTED_DIR=$(ls -d "$BUILD_DIR/temp-server/dmtools-server-api-windows-x64")
mv "$EXTRACTED_DIR"/* "$SERVER_DIR/"
rm -rf "$BUILD_DIR/temp-server"
rm "$BUILD_DIR/${SERVER_BUNDLE}"

# Step 4: Create launcher script
echo ""
echo "🔧 Step 4: Creating launcher script..."
cat > "$BUILD_DIR/dmtools/launch-dmtools.cmd" << 'LAUNCHER_EOF'
@echo off
setlocal enabledelayedexpansion

:: DMTools Launcher - Starts server then opens Flutter app

set "SCRIPT_DIR=%~dp0"
set "SERVER_DIR=%SCRIPT_DIR%server"
set "LOG_DIR=%USERPROFILE%\.dmtools\logs"
set "PID_FILE=%USERPROFILE%\.dmtools\server.pid"
set "SERVER_PORT=8080"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if not exist "%USERPROFILE%\.dmtools" mkdir "%USERPROFILE%\.dmtools"

echo.
echo ========================================
echo   DMTools Launcher
echo ========================================
echo.

:: Check if server is already running
if exist "%PID_FILE%" (
    set /p OLD_PID=<"%PID_FILE%"
    tasklist /FI "PID eq !OLD_PID!" 2>NUL | find /I /N "java.exe">NUL
    if "!ERRORLEVEL!"=="0" (
        echo [INFO] Server is already running (PID: !OLD_PID!)
        goto :LaunchUI
    ) else (
        del "%PID_FILE%"
    )
)

:: Check if port 8080 is available
echo [INFO] Checking port %SERVER_PORT%...
netstat -ano | findstr ":%SERVER_PORT% " | findstr "LISTENING" >NUL
if "!ERRORLEVEL!"=="0" (
    echo [WARN] Port %SERVER_PORT% is already in use
    echo [INFO] Trying alternative ports...
    
    :: Try alternative ports
    for %%p in (8081 8082 8083 8084 8085 8090 8888 9090) do (
        netstat -ano | findstr ":%%p " | findstr "LISTENING" >NUL
        if "!ERRORLEVEL!"=="1" (
            set SERVER_PORT=%%p
            echo [INFO] Using alternative port: !SERVER_PORT!
            goto :StartServer
        )
    )
    
    :: Ask user for custom port
    set /p SERVER_PORT="[INPUT] Enter a custom port (e.g., 9999): "
)

:StartServer
echo.
echo [INFO] Starting DMTools server on port %SERVER_PORT%...

:: Start server in background
cd /d "%SERVER_DIR%"
start "DMTools Server" /B cmd /c "run.cmd --server.port=%SERVER_PORT% > "%LOG_DIR%\server.log" 2>&1"

:: Get PID of the server process (approximate, as we started through cmd)
for /f "tokens=2" %%a in ('tasklist /FI "WINDOWTITLE eq DMTools Server*" /FO LIST ^| findstr "PID:"') do (
    set SERVER_PID=%%a
)

if not "!SERVER_PID!"=="" (
    echo !SERVER_PID! > "%PID_FILE%"
    echo [INFO] Server PID: !SERVER_PID!
)

echo [INFO] Log file: %LOG_DIR%\server.log
echo.
echo [WAIT] Waiting for server to start...

:: Wait for server to be ready (max 60 seconds)
set /a count=0
:WaitLoop
set /a count+=1
if !count! GTR 60 (
    echo.
    echo [ERROR] Server failed to start within 60 seconds
    echo [ERROR] Check logs at: %LOG_DIR%\server.log
    pause
    exit /b 1
)

:: Check if server is responding
curl -s "http://localhost:%SERVER_PORT%/actuator/health" >NUL 2>&1
if "!ERRORLEVEL!"=="0" (
    echo.
    echo [SUCCESS] Server is ready!
    goto :LaunchUI
) else (
    echo|set /p="."
    timeout /t 1 /nobreak >NUL
    goto :WaitLoop
)

:LaunchUI
echo.
echo [INFO] Launching DMTools UI...

:: Set server URL environment variable
set "DMTOOLS_SERVER_URL=http://localhost:%SERVER_PORT%"

:: Launch Flutter app
cd /d "%SCRIPT_DIR%"
if exist "dmtools.exe" (
    start "" "dmtools.exe"
) else (
    echo [ERROR] dmtools.exe not found in %SCRIPT_DIR%
    echo [ERROR] Please ensure the Flutter Windows build is complete
    pause
    exit /b 1
)

echo.
echo ========================================
echo   DMTools is running!
echo ========================================
echo   Server: http://localhost:%SERVER_PORT%
echo   Logs: %LOG_DIR%\server.log
echo.
echo   To stop the server, close this window
echo   or use Task Manager to end java.exe
echo ========================================
echo.

:: Keep window open to show server status
pause
LAUNCHER_EOF

# Convert line endings to Windows (CRLF)
if command -v unix2dos &> /dev/null; then
    unix2dos "$BUILD_DIR/dmtools/launch-dmtools.cmd" 2>/dev/null || true
fi

# Step 5: Create distribution package
echo ""
echo "📦 Step 5: Creating distribution package..."

APP_NAME="DMTools-${VERSION}-windows-x64"
DIST_DIR="$BUILD_DIR/${APP_NAME}"
mkdir -p "$DIST_DIR"

# Copy app
cp -R "$BUILD_DIR/dmtools"/* "$DIST_DIR/"

# Create README
cat > "$DIST_DIR/README.txt" << 'README_EOF'
DMTools for Windows
===================

Installation:
1. Extract this ZIP file to a folder (e.g., C:\Program Files\DMTools)
2. Double-click launch-dmtools.cmd to start

First Launch:
- Windows Defender may show a warning for unsigned apps
- Click "More info" → "Run anyway"
- Or add the folder to Windows Defender exclusions

The launcher will:
1. Start the DMTools server (on port 8080 or next available)
2. Wait for the server to be ready
3. Launch the Flutter UI

Server Logs:
- Located at: %USERPROFILE%\.dmtools\logs\server.log

Stopping the Server:
- Close the launcher window
- Or use Task Manager to end java.exe processes

Requirements:
- Windows 10 or later
- 2GB RAM minimum, 4GB recommended
- No Java installation required (embedded JRE)

Troubleshooting:
- If port 8080 is busy, the launcher will try alternative ports
- Check server logs at %USERPROFILE%\.dmtools\logs\server.log
- Ensure Windows Defender isn't blocking the application

Version: ${VERSION}
README_EOF

# Create uninstall script
cat > "$DIST_DIR/uninstall.cmd" << 'UNINSTALL_EOF'
@echo off
echo.
echo ========================================
echo   DMTools Uninstaller
echo ========================================
echo.

:: Stop server
if exist "%USERPROFILE%\.dmtools\server.pid" (
    set /p PID=<"%USERPROFILE%\.dmtools\server.pid"
    taskkill /PID %PID% /F >NUL 2>&1
    if "!ERRORLEVEL!"=="0" (
        echo [SUCCESS] Stopped server (PID: %PID%)
    )
    del "%USERPROFILE%\.dmtools\server.pid"
)

:: Ask to remove data
set /p REMOVE_DATA="Remove all DMTools data? (Y/N): "
if /I "%REMOVE_DATA%"=="Y" (
    rmdir /s /q "%USERPROFILE%\.dmtools" 2>NUL
    echo [SUCCESS] Removed DMTools data
)

echo.
echo [SUCCESS] Uninstall complete!
echo.
echo To remove the application, delete this folder:
echo %~dp0
echo.
pause
UNINSTALL_EOF

# Convert line endings to Windows (CRLF)
if command -v unix2dos &> /dev/null; then
    unix2dos "$DIST_DIR/README.txt" 2>/dev/null || true
    unix2dos "$DIST_DIR/uninstall.cmd" 2>/dev/null || true
fi

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
echo "⚠️  Note: If Flutter Windows build was skipped:"
echo "   - Build must be completed on a Windows machine"
echo "   - Copy build/windows/x64/runner/Release/* to the package"
echo ""
echo "🧪 To test the package (on Windows):"
echo "   1. Extract ${APP_NAME}.zip"
echo "   2. Run launch-dmtools.cmd"

