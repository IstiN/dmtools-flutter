# DMTools App Packaging Scripts

This directory contains scripts for packaging DMTools Flutter apps with embedded DMTools server and JRE.

## 📁 Scripts Overview

- **`pack-macos.sh`** - Packages macOS Flutter app with embedded server
- **`pack-windows.sh`** - Packages Windows Flutter app with embedded server
- **`test-packaging.sh`** - Test packaging locally before using in CI/CD

## 🚀 Quick Start - Test Locally

The easiest way to test packaging is to use the test script:

```bash
# Test with default server version (v1.7.77)
./scripts/test-packaging.sh

# Test with specific server version
./scripts/test-packaging.sh v1.7.80

# Test with local server bundle
./scripts/test-packaging.sh v1.7.77 /path/to/dmtools-server-api-macos-aarch64.zip
```

This will:
1. Download the server bundle (if not provided)
2. Build Flutter app for macOS
3. Package everything into a DMG
4. Place output in `dist-test/` directory

## 🔧 Manual Packaging

### macOS

```bash
# Build Flutter app
flutter build macos --release

# Download server bundle from GitHub releases
curl -L -o dmtools-server-api-macos-aarch64.zip \
  "https://github.com/IstiN/dmtools/releases/download/v1.7.77/dmtools-server-api-macos-aarch64.zip"

# Package
./scripts/pack-macos.sh \
  build/macos/Build/Products/Release/dmtools.app \
  dmtools-server-api-macos-aarch64.zip \
  dist \
  v1.7.77
```

**Output:** `dist/DMTools-v1.7.77-macos-arm64.dmg`

### Windows

```bash
# Build Flutter app
flutter build windows --release

# Download server bundle from GitHub releases
curl -L -o dmtools-server-api-windows-x64.zip \
  "https://github.com/IstiN/dmtools/releases/download/v1.7.77/dmtools-server-api-windows-x64.zip"

# Package (run on macOS/Linux with zip command)
./scripts/pack-windows.sh \
  build/windows/x64/runner/Release \
  dmtools-server-api-windows-x64.zip \
  dist \
  v1.7.77
```

**Output:** `dist/DMTools-v1.7.77-windows-x64.zip`

## 🤖 GitHub Actions Workflow

The packaging is automated via GitHub Actions:

**File:** `.github/workflows/package-apps.yml`

### Trigger Workflow

1. Go to GitHub Actions tab
2. Select "Package DMTools Apps" workflow
3. Click "Run workflow"
4. Fill in:
   - **Server version:** e.g., `v1.7.77`
   - **Flutter version:** (optional) leave empty for latest stable
   - **Create release:** Check to create GitHub release

### What the Workflow Does

1. **Build macOS apps** (both Apple Silicon and Intel)
2. **Build Windows app**
3. **Download server bundles** from dmtools releases
4. **Package apps** with embedded server
5. **Upload artifacts** for download
6. **(Optional) Create release** with all packages

### Artifacts

After workflow completes, download artifacts:
- `dmtools-macos-arm64` - macOS Apple Silicon DMG
- `dmtools-macos-x64` - macOS Intel DMG
- `dmtools-windows-x64` - Windows ZIP

## 📦 Package Structure

### macOS DMG

```
DMTools.app/
├── Contents/
│   ├── MacOS/
│   │   ├── dmtools         # Wrapper script
│   │   └── dmtools.bin     # Original Flutter executable
│   ├── Resources/
│   │   ├── server/         # Embedded server
│   │   │   ├── run.sh      # Server startup
│   │   │   ├── launch.sh   # Server launcher with port handling
│   │   │   ├── jre/        # Embedded JRE
│   │   │   └── dmtools-standalone.jar
│   │   └── ... (Flutter assets)
│   └── Info.plist
```

### Windows ZIP

```
DMTools-v1.7.77-windows-x64/
├── dmtools.exe              # Flutter application
├── launch.cmd               # Main launcher
├── server/                  # Embedded server
│   ├── run.cmd              # Server startup
│   ├── jre/                 # Embedded JRE
│   └── dmtools-standalone.jar
├── data/                    # Flutter dependencies
└── README.txt               # User guide
```

## 🎯 How It Works

### Startup Flow

1. User launches the app (DMTools.app on macOS, launch.cmd on Windows)
2. Launcher checks if port 8080 is available
3. If port is busy, prompts user for alternative port
4. Starts embedded server on selected port
5. Waits for server health check (max 60 seconds)
6. Launches Flutter app with `--server-port` parameter
7. App connects to local server

### Port Handling

**macOS:**
- Default port: 8080
- If busy: Shows native dialog to enter alternative port
- Custom port via env var: `export DMTOOLS_PORT=9090`

**Windows:**
- Default port: 8080
- If busy: Console prompt for alternative port
- Custom port via env var: `set DMTOOLS_PORT=9090`

### Server Logs

- **macOS:** `DMTools.app/Contents/Resources/server/dmtools-server.log`
- **Windows:** `server/dmtools-server.log`

## 🧪 Testing Packaged Apps

### macOS

```bash
# Build test package
./scripts/test-packaging.sh

# Open DMG
open dist-test/*.dmg

# Drag to Applications and launch
# Or test directly:
open dist-test/*.dmg
# Then from mounted DMG:
open /Volumes/DMTools*/DMTools.app
```

### Windows

Since Windows packaging requires a Windows environment, test the script logic:

```bash
# Test script execution (won't create final package on macOS)
./scripts/pack-windows.sh \
  build/windows/x64/runner/Release \
  dmtools-server-api-windows-x64.zip \
  dist-test \
  v1.7.77
```

Then test on actual Windows machine.

## 🔧 Troubleshooting

### Script fails to download server bundle

**Solution:** Download manually from [dmtools releases](https://github.com/IstiN/dmtools/releases) and provide path:

```bash
./scripts/test-packaging.sh v1.7.77 /path/to/bundle.zip
```

### Flutter build fails

**Check:**
- Flutter is installed: `flutter --version`
- Dependencies fetched: `flutter pub get`
- Target platform supported: `flutter doctor`

### Server fails to start in packaged app

**Check:**
- Port is available (8080)
- JRE is included in server bundle
- Server logs in app bundle

### macOS: "App is damaged and can't be opened"

**Solution:**
```bash
# Remove quarantine attribute
xattr -cr /Applications/DMTools.app

# Or during development:
xattr -cr dist-test/*.dmg
```

### Windows: "Windows protected your PC"

**Solution:**
- Click "More info" → "Run anyway"
- Or add folder to Windows Defender exclusions

## 📝 Script Parameters

### pack-macos.sh

```bash
./pack-macos.sh <flutter-app-path> <server-bundle-zip> <output-dir> <version>
```

- `flutter-app-path`: Path to built .app bundle
- `server-bundle-zip`: Path to server ZIP (e.g., dmtools-server-api-macos-aarch64.zip)
- `output-dir`: Where to place output DMG
- `version`: Version string (e.g., v1.7.77)

### pack-windows.sh

```bash
./pack-windows.sh <flutter-build-dir> <server-bundle-zip> <output-dir> <version>
```

- `flutter-build-dir`: Path to Windows build directory
- `server-bundle-zip`: Path to server ZIP (dmtools-server-api-windows-x64.zip)
- `output-dir`: Where to place output ZIP
- `version`: Version string (e.g., v1.7.77)

### test-packaging.sh

```bash
./test-packaging.sh [server-version] [server-bundle-path]
```

- `server-version`: (Optional) Server version tag, default: v1.7.77
- `server-bundle-path`: (Optional) Path to local server bundle

## 🔐 Security Notes

- Scripts do NOT sign or notarize macOS apps
- For production, add code signing:
  ```bash
  codesign --force --deep --sign "Developer ID" DMTools.app
  xcrun notarytool submit ...
  ```
- Windows apps are unsigned - users will see SmartScreen warnings

## 📚 Additional Resources

- [Flutter Desktop Documentation](https://docs.flutter.dev/desktop)
- [DMTools Server Repository](https://github.com/IstiN/dmtools)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 🤝 Contributing

When modifying packaging scripts:

1. Test locally with `test-packaging.sh`
2. Test on actual platforms (macOS, Windows)
3. Update this README with changes
4. Test GitHub Actions workflow in your fork
5. Submit PR with description of changes

---

**Questions?** Open an issue in the [dmtools-flutter repository](https://github.com/IstiN/dmtools-flutter/issues).

