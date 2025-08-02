# GitHub Actions Workflows

This directory contains the automated CI/CD workflows for the DMTools Flutter project.

## Workflows

### 🚀 `deploy-pages.yml` - Production Deployment
**Automatic deployment to https://ai-native.agency with cache busting**

**Triggers:**
- Push to `main` branch
- Manual workflow dispatch
- Pull requests to `main` (build only, no deploy)

**Process:**
1. **Setup**: Flutter installation and dependencies
2. **Asset Sync**: Synchronize shared assets between main app and styleguide
3. **🎯 Cache Busting**: Automatically applies versioning to resolve Safari caching issues
4. **Testing**: Runs tests for both main app and styleguide
5. **Build**: Production builds with optimization and PWA support
6. **Deploy**: Deploys to GitHub Pages with custom domain
7. **Cleanup**: Resets files to development state

**Cache Busting Features:**
- ✅ Automatic version generation (`YYYYMMDDHHMMSS-{git-hash}`)
- ✅ Service worker cache management
- ✅ Resource versioning for all JS/CSS files
- ✅ Safari aggressive caching resolved
- ✅ Creates `VERSION.txt` for deployment tracking

### 🧪 `ci.yml` - Continuous Integration
**Comprehensive testing and validation**

**Triggers:**
- Pull requests to `main` or `develop`
- Push to `main` or `develop`

**Jobs:**
1. **test**: Code analysis and unit tests
2. **authentication-tests**: OAuth and token handling validation
3. **build-check**: Build verification for production readiness

**Features:**
- Flutter analyze for code quality
- Unit test execution with coverage
- Authentication flow validation
- Build verification
- Detailed test summaries in PR comments

## Environment Variables

### Production Build Configuration
- `FLUTTER_ENV=production`
- `baseUrl=https://dmtools-431977789017.us-central1.run.app`
- `BACKEND_BASE_URL=https://dmtools-431977789017.us-central1.run.app`

### Build Optimizations
- Content Security Policy (CSP) enabled
- Source maps disabled for production
- Tree shaking for icons
- Optimization level 4
- PWA offline-first strategy

## Deployment Structure

```
_site/
├── index.html              # Main app (root)
├── VERSION.txt             # Cache version info
├── navigation.html         # App navigation page
└── styleguide/            # Styleguide subdirectory
    └── index.html         # Styleguide app
```

## Cache Busting Implementation

The deployment workflow automatically applies cache busting using:

1. **`scripts/update-cache-version.sh`** - Replaces `__BUILD_VERSION__` placeholders
2. **Service Workers** - Handle cache invalidation and updates
3. **Versioned Resources** - All JS/CSS files get version query parameters
4. **Cache Headers** - Proper HTTP headers prevent aggressive caching

### Example Version Output:
```
Cache version: 20241220143022-a1b2c3d
Deployment time: 2024-12-20 14:30:45 UTC
```

## Monitoring

- **Deployment Status**: Check GitHub Actions tab
- **Live Version**: Visit `https://ai-native.agency/VERSION.txt`
- **Service Worker**: Check browser DevTools > Application > Service Workers

## Local Development

For local development, use:
```bash
# Hot reload development
flutter run -d chrome --web-experimental-hot-reload

# Development build (no cache busting)
./scripts/dev-build.sh
```

The workflows automatically preserve your local development environment by resetting placeholder files after deployment.