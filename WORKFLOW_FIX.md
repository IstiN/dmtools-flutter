# GitHub Workflow Fix

## Issue
Workflow failed with error:
```
Unable to determine Flutter version for channel: stable version: stable architecture: x64
Error: Process completed with exit code 1.
```

See: https://github.com/IstiN/dmtools-flutter/actions/runs/19067773420

## Root Cause
The workflow was passing `'stable'` as the `flutter-version` parameter when the input was empty:
```yaml
flutter-version: ${{ github.event.inputs.flutter_version || 'stable' }}
```

The `subosito/flutter-action@v2` expects either:
1. A specific version number (e.g., `3.24.0`)
2. An empty value (then it uses the `channel` parameter)

Passing the string `'stable'` as a version is invalid.

## Fix
Changed to:
```yaml
flutter-version: ${{ github.event.inputs.flutter_version }}
channel: 'stable'
```

Now when `flutter_version` input is empty, the action will use the `channel: 'stable'` to get the latest stable version.

## Testing
After committing this fix, re-run the workflow:
1. Go to Actions → Package DMTools Apps
2. Click "Run workflow"
3. Leave `flutter_version` **empty**
4. Set `server_version`: `v1.7.78`
5. Set `create_release`: unchecked (for testing)

## Expected Result
- ✅ Flutter will be installed from stable channel (latest)
- ✅ App will build successfully for all platforms
- ✅ Artifacts will be created
