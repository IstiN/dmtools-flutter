# Cache Busting and Deployment Guide

This document explains how to solve Safari's aggressive caching issues and ensure your Flutter web app always updates after deployment.

## Problem

Safari and other browsers aggressively cache web app resources, causing users to see old versions even after deployment. This is especially problematic for Progressive Web Apps (PWAs) and Single Page Applications (SPAs).

## Solution Overview

We've implemented a comprehensive cache busting strategy that includes:

1. **Service Workers** with proper cache management
2. **Build-time versioning** for all resources
3. **Automatic cache invalidation** on deployment
4. **Consistent cache control headers**

## Files Modified

### Service Workers
- `web/sw.js` - Main app service worker
- `flutter_styleguide/web/sw.js` - Styleguide service worker

### HTML Files
- `web/index.html` - Service worker registration and versioned resources
- `flutter_styleguide/web/index.html` - Service worker registration and versioned resources

### Manifests
- `web/manifest.json` - Added version field
- `flutter_styleguide/web/manifest.json` - Added version field

### Build Scripts
- `scripts/update-cache-version.sh` - Updates version placeholders
- `scripts/build-with-cache-busting.sh` - Complete production build
- `scripts/dev-build.sh` - Development build (preserves placeholders)

## How It Works

### 1. Version Generation
During build, `__BUILD_VERSION__` placeholders are replaced with:
```
YYYYMMDDHHMMSS-{git-hash}
```
Example: `20241220143022-a1b2c3d`

### 2. Service Worker Strategy
- **Network-first** for HTML and Flutter resources
- **Cache-first** for static assets (images, CSS)
- **Network-only** for API calls
- **Automatic cache cleanup** on version updates

### 3. Cache Control Headers
```html
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
```

### 4. Resource Versioning
All JavaScript and CSS files include version query parameters:
```html
<script src="flutter_bootstrap.js?v=20241220143022-a1b2c3d"></script>
<link rel="stylesheet" href="css/shared-theme.css?v=20241220143022-a1b2c3d">
```

## Usage

### Development
For development with hot reload:
```bash
# Start development server
flutter run -d chrome --web-experimental-hot-reload

# Or build for development testing
./scripts/dev-build.sh
```

### Production Deployment
For production builds with cache busting:
```bash
# Build everything with cache busting
./scripts/build-with-cache-busting.sh

# Build only main app
./scripts/build-with-cache-busting.sh main

# Build only styleguide
./scripts/build-with-cache-busting.sh styleguide
```

## Server Configuration

### Nginx Example
```nginx
# Cache static assets for 1 year
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# Don't cache HTML and service workers
location ~* \.(html|htm)$ {
    add_header Cache-Control "no-cache, no-store, must-revalidate";
    add_header Pragma "no-cache";
    add_header Expires "0";
}

# Don't cache service worker
location = /sw.js {
    add_header Cache-Control "no-cache, no-store, must-revalidate";
    add_header Pragma "no-cache";
    add_header Expires "0";
}
```

### Apache Example
```apache
# Cache static assets
<LocationMatch "\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$">
    ExpiresActive On
    ExpiresDefault "access plus 1 year"
    Header set Cache-Control "public, immutable"
</LocationMatch>

# Don't cache HTML
<LocationMatch "\.(html|htm)$">
    Header set Cache-Control "no-cache, no-store, must-revalidate"
    Header set Pragma "no-cache"
    Header set Expires "0"
</LocationMatch>

# Don't cache service worker
<Location "/sw.js">
    Header set Cache-Control "no-cache, no-store, must-revalidate"
    Header set Pragma "no-cache"
    Header set Expires "0"
</Location>
```

## Testing

### Verify Cache Busting Works
1. Build and deploy: `./scripts/build-with-cache-busting.sh`
2. Open app in browser
3. Make a change and redeploy
4. Refresh the page - changes should appear immediately
5. Test in both incognito and regular browser modes

### Debug Service Worker
1. Open browser DevTools
2. Go to Application/Storage tab
3. Check Service Workers section
4. Verify cache versions are updating

### Safari Specific Testing
1. Test in Safari incognito mode (should always work)
2. Test in Safari regular mode
3. Clear Safari cache if needed: Safari > Develop > Empty Caches
4. Service worker should force updates automatically

## Troubleshooting

### Changes Not Appearing
1. Check if service worker is registered: Browser DevTools > Application > Service Workers
2. Verify version numbers are updating in network requests
3. Try hard refresh: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)
4. Clear browser cache manually if needed

### Service Worker Issues
1. Unregister old service workers: DevTools > Application > Service Workers > Unregister
2. Clear all storage: DevTools > Application > Storage > Clear storage
3. Check console for service worker errors

### Build Issues
1. Ensure scripts are executable: `chmod +x scripts/*.sh`
2. Check git is available for hash generation
3. Verify all placeholder files exist before running build script

## Development Workflow

1. **Development**: Use `flutter run -d chrome` for hot reload
2. **Testing**: Use `./scripts/dev-build.sh` for development builds
3. **Production**: Use `./scripts/build-with-cache-busting.sh` for deployment
4. **Deploy**: Upload built files to hosting service with proper server configuration

## Benefits

- ✅ Safari cache issues resolved
- ✅ Automatic updates after deployment
- ✅ Works in both incognito and regular browser modes
- ✅ Preserves development workflow
- ✅ Progressive Web App compatible
- ✅ No manual cache clearing required for users

## Notes

- Service workers may take one refresh cycle to activate new versions
- Users on very old browsers without service worker support may still need manual cache clearing
- The build version is visible in browser DevTools for debugging
- Cache strategies can be customized per resource type in the service worker files