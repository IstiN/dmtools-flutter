# DMTools Flutter - Deployment & Cache Busting

## Quick Start

### Development
```bash
# Hot reload development
flutter run -d chrome --web-experimental-hot-reload

# Development build (preserves placeholders)
./scripts/dev-build.sh
```

### Production Deployment
```bash
# Build with cache busting (recommended for production)
./scripts/build-with-cache-busting.sh

# Build specific targets
./scripts/build-with-cache-busting.sh main      # Main app only
./scripts/build-with-cache-busting.sh styleguide # Styleguide only
```

## Safari Cache Issue - SOLVED ✅

This repository now includes a comprehensive cache busting solution that resolves Safari's aggressive caching problems:

### What Was Added:
- **Service Workers** with intelligent cache management
- **Automatic versioning** based on timestamp + git hash
- **Build scripts** for seamless production deployment
- **Cache control headers** for proper browser behavior
- **Progressive Web App** compatibility maintained

### Benefits:
- ✅ Changes appear immediately after deployment
- ✅ Works in both Safari incognito and regular modes
- ✅ No manual cache clearing required
- ✅ Preserves development workflow
- ✅ Automatic fallback strategies for network issues

## File Structure

```
scripts/
├── update-cache-version.sh     # Updates version placeholders
├── build-with-cache-busting.sh # Production build with cache busting
└── dev-build.sh               # Development build (no cache busting)

web/
├── sw.js                      # Service worker for main app
├── index.html                 # Updated with service worker registration
└── manifest.json             # Updated with version field

flutter_styleguide/web/
├── sw.js                      # Service worker for styleguide
├── index.html                 # Updated with service worker registration
└── manifest.json             # Updated with version field

docs/
└── cache-busting-deployment.md # Detailed documentation
```

## How It Works

1. **Build Time**: `__BUILD_VERSION__` placeholders get replaced with `YYYYMMDDHHMMSS-{git-hash}`
2. **Service Worker**: Manages cache strategies per resource type
3. **Browser**: Automatically downloads updates when versions change
4. **Fallback**: Network-first strategy ensures latest content

## Deployment Checklist

1. ✅ Run production build: `./scripts/build-with-cache-busting.sh`
2. ✅ Deploy built files to hosting service
3. ✅ Configure server headers (see `docs/cache-busting-deployment.md`)
4. ✅ Test in both incognito and regular browser modes
5. ✅ Verify service worker registration in DevTools

## Troubleshooting

- **Changes not appearing?** Check DevTools > Application > Service Workers
- **Cache issues persist?** Hard refresh: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)
- **Service worker errors?** Check browser console and `docs/cache-busting-deployment.md`

For detailed documentation, see `docs/cache-busting-deployment.md`.