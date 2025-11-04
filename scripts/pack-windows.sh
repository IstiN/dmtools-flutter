#!/bin/bash
set -e

# Pack Windows Flutter app with embedded DMTools server
# Usage: ./pack-windows.sh <flutter-build-dir> <server-bundle-zip> <output-dir> <version>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_BUILD_DIR="$1"
SERVER_BUNDLE_ZIP="$2"
OUTPUT_DIR="$3"
VERSION="$4"

if [ -z "$FLUTTER_BUILD_DIR" ] || [ -z "$SERVER_BUNDLE_ZIP" ] || [ -z "$OUTPUT_DIR" ] || [ -z "$VERSION" ]; then
    echo "Usage: $0 <flutter-build-dir> <server-bundle-zip> <output-dir> <version>"
    echo "Example: $0 build/windows/x64/runner/Release dmtools-server-api-windows-x64.zip dist v1.0.0"
    exit 1
fi

echo "📦 Packing DMTools Windows Application"
echo "Flutter Build: $FLUTTER_BUILD_DIR"
echo "Server Bundle: $SERVER_BUNDLE_ZIP"
echo "Output Directory: $OUTPUT_DIR"
echo "Version: $VERSION"

# Create output directory and convert to absolute path
mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR=$(cd "$OUTPUT_DIR" && pwd)
TEMP_DIR=$(mktemp -d)

# Extract server bundle
echo "🔓 Extracting server bundle..."
unzip -q "$SERVER_BUNDLE_ZIP" -d "$TEMP_DIR"
SERVER_DIR=$(find "$TEMP_DIR" -type d \( -name "dmtools-standalone-*" -o -name "dmtools-server-api-*" \) | head -1)

if [ -z "$SERVER_DIR" ]; then
    echo "❌ Error: Could not find server directory in bundle"
    exit 1
fi

echo "✅ Server extracted to: $SERVER_DIR"

# Create package directory
PACKAGE_NAME="DMTools-$VERSION-windows-x64"
PACKAGE_DIR="$TEMP_DIR/$PACKAGE_NAME"
mkdir -p "$PACKAGE_DIR"

# Copy Flutter build
echo "📱 Copying Flutter build..."
cp -R "$FLUTTER_BUILD_DIR"/* "$PACKAGE_DIR/"

# Download Visual C++ Redistributable installer
echo "📥 Downloading Visual C++ Redistributable..."
VCREDIST_URL="https://aka.ms/vs/17/release/vc_redist.x64.exe"
VCREDIST_PATH="$PACKAGE_DIR/vc_redist.x64.exe"
curl -L -o "$VCREDIST_PATH" "$VCREDIST_URL" 2>/dev/null || echo "⚠️ Warning: Could not download VC++ Redistributable"

# Create server directory
mkdir -p "$PACKAGE_DIR/server"

# Copy server files
echo "🔧 Embedding server..."
cp -R "$SERVER_DIR"/* "$PACKAGE_DIR/server/"

# Create setup script for first-time installation
echo "📝 Creating setup script..."
cat > "$PACKAGE_DIR/setup.cmd" << 'EOF'
@echo off
echo ========================================
echo   DMTools Setup
echo ========================================
echo.

:: Check if Visual C++ Redistributable is installed
echo [INFO] Checking for Visual C++ Redistributable...
where /q msvcp140.dll 2>nul
if %errorlevel% neq 0 (
    echo [WARN] Visual C++ Redistributable not found
    echo [INFO] Installing Visual C++ Redistributable...
    
    if exist "%~dp0vc_redist.x64.exe" (
        echo Please wait while installing prerequisites...
        "%~dp0vc_redist.x64.exe" /install /quiet /norestart
        if %errorlevel% equ 0 (
            echo [SUCCESS] Visual C++ Redistributable installed successfully
        ) else (
            echo [WARN] Installation completed with code: %errorlevel%
            echo You may need to restart your computer
        )
    ) else (
        echo [ERROR] vc_redist.x64.exe not found
        echo Please download and install Visual C++ Redistributable manually:
        echo https://aka.ms/vs/17/release/vc_redist.x64.exe
        pause
        exit /b 1
    )
) else (
    echo [SUCCESS] Visual C++ Redistributable is already installed
)

echo.
echo [SUCCESS] Setup completed! You can now run launch.cmd
echo.
pause
EOF

# Convert to Windows line endings (CRLF)
if command -v unix2dos &> /dev/null; then
    unix2dos "$PACKAGE_DIR/setup.cmd" 2>/dev/null || sed -i 's/$/\r/' "$PACKAGE_DIR/setup.cmd"
else
    sed -i '' $'s/$/\r/' "$PACKAGE_DIR/setup.cmd" 2>/dev/null || sed -i 's/$/\r/' "$PACKAGE_DIR/setup.cmd"
fi

# Create launcher batch script
echo "📝 Creating launcher script..."
cat > "$PACKAGE_DIR/launch.cmd" << 'EOF'
@echo off
setlocal enabledelayedexpansion

:: Check for Visual C++ Redistributable
where /q msvcp140.dll 2>nul
if %errorlevel% neq 0 (
    echo ========================================
    echo   Missing Prerequisites
    echo ========================================
    echo.
    echo Visual C++ Redistributable is not installed.
    echo Please run setup.cmd first to install prerequisites.
    echo.
    pause
    exit /b 1
)

set "SERVER_DIR=%~dp0server"
set "LOG_FILE=%SERVER_DIR%\dmtools-server.log"
set "PORT_FILE=%SERVER_DIR%\server-port.txt"
set "SERVER_PORT=8080"

:: Check if port is provided via environment
if defined DMTOOLS_PORT set "SERVER_PORT=%DMTOOLS_PORT%"

:CHECK_PORT
:: Check if port is available
netstat -ano | findstr ":%SERVER_PORT%" >nul 2>&1
if %errorlevel% equ 0 (
    echo Port %SERVER_PORT% is busy
    set /p "NEW_PORT=Enter a different port (or press Ctrl+C to cancel): "
    if not "!NEW_PORT!"=="" (
        set "SERVER_PORT=!NEW_PORT!"
        goto CHECK_PORT
    ) else (
        echo ERROR: Port %SERVER_PORT% is busy. Please choose another port.
        pause
        exit /b 1
    )
)

echo Starting DMTools server on port %SERVER_PORT%...

:: Kill existing server if any
taskkill /F /IM java.exe /FI "WINDOWTITLE eq DMTools Server*" >nul 2>&1

:: Start server in background
cd /d "%SERVER_DIR%"
start "DMTools Server" /MIN cmd /c "run.cmd --server.port=%SERVER_PORT% > "%LOG_FILE%" 2>&1"

echo Waiting for server to start...

:: Wait for server to be ready (max 60 seconds)
set "COUNTER=0"
:WAIT_LOOP
timeout /t 1 /nobreak >nul
set /a COUNTER+=1

:: Check if server is responding
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://localhost:%SERVER_PORT%/actuator/health' -TimeoutSec 1; exit 0 } catch { exit 1 }" >nul 2>&1
if %errorlevel% equ 0 (
    echo Server is ready on port %SERVER_PORT%!
    echo %SERVER_PORT% > "%PORT_FILE%"
    goto START_APP
)

if %COUNTER% lss 60 goto WAIT_LOOP

echo ERROR: Server failed to start. Check log: %LOG_FILE%
pause
exit /b 1

:START_APP
echo Launching DMTools app...

:: Get the Flutter executable name
for %%F in ("%~dp0*.exe") do (
    if not "%%~nF"=="launcher" (
        start "" "%%F" --server-port=%SERVER_PORT%
        goto END
    )
)

echo ERROR: Could not find DMTools executable
pause
exit /b 1

:END
exit /b 0
EOF

# Convert to Windows line endings (CRLF)
if command -v unix2dos &> /dev/null; then
    unix2dos "$PACKAGE_DIR/launch.cmd" 2>/dev/null || sed -i 's/$/\r/' "$PACKAGE_DIR/launch.cmd"
else
    sed -i '' $'s/$/\r/' "$PACKAGE_DIR/launch.cmd" 2>/dev/null || sed -i 's/$/\r/' "$PACKAGE_DIR/launch.cmd"
fi

# Create README
cat > "$PACKAGE_DIR/README.txt" << EOF
DMTools v$VERSION - Windows Edition
====================================

FIRST TIME INSTALLATION:
1. Extract the ZIP file to a folder (e.g., C:\Program Files\DMTools)
2. Run setup.cmd as Administrator to install prerequisites
   - This will install Visual C++ Redistributable if needed
   - Required for Flutter applications to run
3. After setup completes, you can use launch.cmd

Quick Start:
1. Double-click launch.cmd to start DMTools
2. The server will start automatically on port 8080
3. If port 8080 is busy, you'll be prompted to choose another port
4. The app will launch once the server is ready

Prerequisites:
- Windows 10/11 (x64)
- Visual C++ Redistributable 2015-2022 (included in setup.cmd)
- At least 2GB RAM
- Internet connection (for first-time setup only)

Custom Port:
You can set a custom port before launching:
  set DMTOOLS_PORT=9090
  launch.cmd

Files:
- setup.cmd         : First-time setup (installs prerequisites)
- launch.cmd        : Main launcher (starts server + app)
- vc_redist.x64.exe : Visual C++ Redistributable installer
- dmtools.exe       : Flutter application
- server/           : Embedded DMTools server
- server/run.cmd    : Server startup script

Troubleshooting:
- If you get "msvcp140.dll not found" error, run setup.cmd
- If server fails to start, check server/dmtools-server.log
- Ensure no firewall is blocking ports
- Port must be between 1024-65535
- Try running as Administrator if you have permission issues

Manual VC++ Installation:
If setup.cmd fails, download and install manually:
https://aka.ms/vs/17/release/vc_redist.x64.exe

For more help: https://github.com/IstiN/dmtools
EOF

# Convert to Windows line endings (CRLF)
if command -v unix2dos &> /dev/null; then
    unix2dos "$PACKAGE_DIR/README.txt" 2>/dev/null || sed -i 's/$/\r/' "$PACKAGE_DIR/README.txt"
else
    sed -i '' $'s/$/\r/' "$PACKAGE_DIR/README.txt" 2>/dev/null || sed -i 's/$/\r/' "$PACKAGE_DIR/README.txt"
fi

# Create ZIP package
echo "📦 Creating ZIP package..."
ZIP_NAME="DMTools-$VERSION-windows-x64.zip"
ZIP_PATH="$OUTPUT_DIR/$ZIP_NAME"

cd "$TEMP_DIR"
# Use 7z (available on Windows GitHub runners) instead of zip
if command -v 7z &> /dev/null; then
    7z a -tzip "$ZIP_PATH" "$PACKAGE_NAME" > /dev/null
elif command -v zip &> /dev/null; then
    zip -r -q "$ZIP_PATH" "$PACKAGE_NAME"
else
    echo "❌ Error: No zip command available (tried 7z and zip)"
    exit 1
fi

# Cleanup
cd "$SCRIPT_DIR"
rm -rf "$TEMP_DIR"

echo "✅ Windows package created: $ZIP_PATH"
echo "📊 Size: $(du -h "$ZIP_PATH" | cut -f1)"

