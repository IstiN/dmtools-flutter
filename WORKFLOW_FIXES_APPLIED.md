# Workflow Fixes Applied

## Issues Fixed

### 1. ✅ Fixed Flutter Version Parameter
**Problem**: Workflow was passing `'stable'` as flutter-version when input was empty
**Fix**: Changed to pass empty value, letting the action use channel: 'stable'
```yaml
flutter-version: ${{ github.event.inputs.flutter_version }}
```

### 2. ✅ Fixed Server Bundle Download
**Problems**:
- Wrong repository: `IstiN/dmtools-server` → Should be `IstiN/dmtools`
- Wrong bundle names: Included version in name, but releases don't have versioned names

**Fix**: Updated download URLs and bundle names
```yaml
# Before
BUNDLE_NAME="dmtools-standalone-macos-x64-$SERVER_VERSION.zip"
URL="https://github.com/IstiN/dmtools-server/releases/download/$SERVER_VERSION/$BUNDLE_NAME"

# After  
BUNDLE_NAME="dmtools-standalone-macos-x64.zip"
URL="https://github.com/IstiN/dmtools/releases/download/$SERVER_VERSION/$BUNDLE_NAME"
```

**Verified**: Release v1.7.78 exists in IstiN/dmtools with these bundles:
- `dmtools-standalone-macos-aarch64.zip`
- `dmtools-standalone-macos-x64.zip`
- `dmtools-standalone-windows-x64.zip`

### 3. ✅ Disabled Windows Build
**Problem**: Flutter project doesn't have Windows desktop support enabled
**Fix**: Renamed job to `build-windows-disabled` and updated dependencies

To enable Windows support later, run:
```bash
flutter create --platforms=windows .
```

## Changes Summary

- ✅ Fixed Flutter version parameter (removed 'stable' default)
- ✅ Fixed repository URL (dmtools-server → dmtools)
- ✅ Fixed bundle names (removed version suffix)
- ✅ Disabled Windows build (not yet supported)
- ✅ Updated create-release dependencies

## Next Steps

1. Push changes to GitHub
2. Trigger workflow with:
   - `server_version`: v1.7.78
   - `flutter_version`: (leave empty)
   - `create_release`: false
3. Monitor execution

## Expected Result

✅ macOS builds (arm64 and x64) should complete successfully  
✅ DMG artifacts should be created  
❌ Windows build skipped (temporarily disabled)

