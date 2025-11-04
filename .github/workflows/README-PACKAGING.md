# DMTools Application Packaging Workflows

## ✅ Main Workflow: `package-apps.yml`

**This is the primary workflow for creating production artifacts.**

### What it does:
- ✅ Builds Flutter application for macOS (arm64 + x64) and Windows (x64)
- ✅ Downloads **standalone server bundles** from [dmtools-server](https://github.com/IstiN/dmtools-server/releases)
- ✅ Packages application with embedded server
- ✅ Creates distribution-ready packages:
  - `DMTools-{version}-macos-arm64.dmg`
  - `DMTools-{version}-macos-x64.dmg`
  - `DMTools-{version}-windows-x64.zip`

### How to run:

#### Via GitHub UI (recommended):
1. Go to [GitHub Actions](../../actions)
2. Select "Package DMTools Apps"
3. Click "Run workflow"
4. Fill in parameters:
   - **server_version**: `v1.7.78` (version from dmtools-server releases)
   - **flutter_version**: leave empty for latest stable
   - **create_release**: ☑️ if you want to automatically create a GitHub release

#### Result:
- **Artifacts** available in Artifacts section (stored for 7 days)
- **Release** created automatically if `create_release = true`

---

## 📦 Artifact Structure:

### macOS DMG:
```
DMTools-v1.7.87-macos-arm64.dmg
└── DMTools.app/
    ├── Contents/
    │   ├── MacOS/
    │   │   └── dmtools (wrapper script)
    │   │   └── dmtools.bin (Flutter app)
    │   └── Resources/
    │       └── server/
    │           ├── run.sh (server launcher)
    │           ├── start-server.sh (port checker + launcher)
    │           ├── jre/ (embedded JRE)
    │           └── dmtools-standalone.jar
```

**Installation:**
- Drag DMTools.app to Applications folder
- First launch: server starts on port 8080
- If port is busy: dialog will prompt to choose another port

### Windows ZIP:
```
DMTools-v1.7.87-windows-x64.zip
└── DMTools-v1.7.87-windows-x64/
    ├── launch.cmd (main launcher)
    ├── dmtools.exe (Flutter app)
    ├── server/
    │   ├── run.cmd (server launcher)
    │   ├── jre/ (embedded JRE)
    │   └── dmtools-standalone.jar
    └── README.txt
```

**Installation:**
- Extract ZIP
- Run `launch.cmd`
- Server starts on port 8080

---

## 🔧 Local Testing:

### macOS:
```bash
# 1. Download standalone server bundle
curl -L -o dmtools-standalone-macos-aarch64-v1.7.78.zip \
  "https://github.com/IstiN/dmtools-server/releases/download/v1.7.78/dmtools-standalone-macos-aarch64-v1.7.78.zip"

# 2. Build Flutter app
flutter build macos --release

# 3. Package
./scripts/pack-macos.sh \
  build/macos/Build/Products/Release/dmtools.app \
  dmtools-standalone-macos-aarch64-v1.7.78.zip \
  dist \
  v1.7.87

# 4. Result:
# dist/DMTools-v1.7.87-macos-arm64.dmg
```

### Windows (on macOS/Linux via WSL):
```bash
# 1. Download standalone server bundle
curl -L -o dmtools-standalone-windows-x64-v1.7.78.zip \
  "https://github.com/IstiN/dmtools-server/releases/download/v1.7.78/dmtools-standalone-windows-x64-v1.7.78.zip"

# 2. Build Flutter app (on Windows machine or via cross-compile)
flutter build windows --release

# 3. Package
./scripts/pack-windows.sh \
  build/windows/x64/runner/Release \
  dmtools-standalone-windows-x64-v1.7.78.zip \
  dist \
  v1.7.87

# 4. Result:
# dist/DMTools-v1.7.87-windows-x64.zip
```

---

## 🔍 Troubleshooting:

### Workflow failed: "Failed to download server bundle"
**Cause:** Server version not found in dmtools-server releases

**Solution:**
1. Check that version exists: https://github.com/IstiN/dmtools-server/releases
2. Use exact tag name (e.g., `v1.7.78`, not `1.7.78`)
3. Ensure standalone bundle is published (not API-only)

### macOS app crashes on startup
**Cause:** Server cannot start

**Diagnostics:**
1. Check log: `~/Library/Logs/DMTools/dmtools-server.log`
2. Check port: `lsof -i :8080`
3. Ensure **standalone** bundle is used (not API-only)

### Windows app shows "Server failed to start"
**Cause:** Port is busy or configuration is missing

**Solution:**
1. Close processes on port 8080
2. Check log: `server\dmtools-server.log`
3. Try different port:
   ```cmd
   set DMTOOLS_PORT=8081
   launch.cmd
   ```

---

## 📋 Pre-release Checklist:

- [ ] DMTools server version is published and includes **standalone** bundles
- [ ] Flutter app builds without errors: `flutter build macos --release`
- [ ] Packaging scripts work locally
- [ ] Tested on clean system (without dev dependencies)
- [ ] Credentials are saved and auto-login works
- [ ] Titlebar padding is correct (12px on macOS)
- [ ] Icon displays correctly (DM.ai icon)

---

## 🚀 Release Process:

### 1. Prepare server bundle:
```bash
cd ../dmtools-server
git tag v1.7.78
git push origin v1.7.78
# Wait for GitHub Actions to build and publish standalone bundles
```

### 2. Package Flutter app:
```bash
# GitHub Actions → Package DMTools Apps → Run workflow
# server_version: v1.7.78
# create_release: true
```

### 3. Result:
- GitHub Release created automatically
- DMG and ZIP available in Releases
- Changelog can be added manually

---

## 📝 Notes:

- **Standalone vs API-only bundles**: Always use **standalone** for desktop applications
- **Server lifecycle**: Server starts on app launch and stops on app close
- **Port management**: App automatically prompts to select another port if 8080 is busy
- **Credentials**: Saved in SharedPreferences (Keychain fallback on macOS)
- **Auto-login**: Works on app restart
