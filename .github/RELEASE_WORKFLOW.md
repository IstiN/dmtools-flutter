# GitHub Release Workflow Documentation

## Overview

The enhanced deployment workflow now performs two main functions when code is pushed to the `main` branch:

1. **Deploy to GitHub Pages** (existing functionality)
2. **Create a Release with SPA ZIP** (new functionality)

## Workflow Features

### Release Creation (`release` job)

When a push to `main` occurs, the workflow will:

1. **Build both applications** (main app + styleguide) with production optimizations
2. **Apply cache busting** for proper browser cache management
3. **Create a complete SPA package** containing:
   - Main application at root level
   - Styleguide at `/styleguide/` subdirectory
   - Complete assets (fonts, images, icons)
   - Service workers for offline functionality
   - Version information and deployment README

4. **Generate automated release** with:
   - Version tag: `v2024.09.11-a1b2c3d` (date + git hash)
   - ZIP file: `dmtools-flutter-spa-v2024.09.11-a1b2c3d.zip`
   - Comprehensive release notes with deployment instructions

## Release Package Options

Each release includes **three separate packages** to choose from:

### 📦 Combined Package
```
dmtools-flutter-spa-combined-v2024.09.11-a1b2c3d.zip
├── config.js                     # Main app configuration (EDIT THIS!)
├── config.template.js            # Configuration template/backup
├── index.html                    # Main app entry point
├── main.dart.js                  # Main app compiled code
├── flutter_service_worker.js     # Service worker
├── assets/                       # Main app assets
├── styleguide/                   # Styleguide subdirectory
│   ├── config.js                 # Styleguide configuration (EDIT THIS!)
│   ├── config.template.js        # Configuration template/backup
│   ├── index.html                # Styleguide entry point
│   ├── main.dart.js              # Styleguide compiled code
│   └── assets/                   # Styleguide assets
├── VERSION.txt                   # Build information
└── README.md                     # Deployment instructions
```

### 📱 Main Application Only
```
dmtools-flutter-main-app-v2024.09.11-a1b2c3d.zip
├── config.js                     # Runtime configuration (EDIT THIS!)
├── config.template.js            # Configuration template/backup
├── index.html                    # Main app entry point
├── main.dart.js                  # Main app compiled code
├── flutter_service_worker.js     # Service worker
├── assets/                       # All static assets
├── VERSION.txt                   # Build information
└── README.md                     # Deployment instructions
```

### 🎨 Styleguide Only
```
dmtools-flutter-styleguide-v2024.09.11-a1b2c3d.zip
├── config.js                     # Runtime configuration (EDIT THIS!)
├── config.template.js            # Configuration template/backup
├── index.html                    # Styleguide entry point
├── main.dart.js                  # Styleguide compiled code
├── flutter_service_worker.js     # Service worker
├── assets/                       # All static assets
├── VERSION.txt                   # Build information
└── README.md                     # Deployment instructions
```

## ⚙️ Easy API Configuration

**Key Feature**: No rebuilding required! Simply edit the JavaScript configuration files.

### Quick Setup

**Choose your deployment strategy:**

#### Combined Package
1. **Edit `config.js`** in the root directory (for main app)
2. **Edit `styleguide/config.js`** in the styleguide directory
3. **Change the API base URL** in both files:
   ```javascript
   apiBaseUrl: 'http://your-server:8080'  // Change this line
   ```

#### Separate Packages
1. **Edit `config.js`** in the package root
2. **Change the API base URL**:
   ```javascript
   apiBaseUrl: 'http://your-server:8080'  // Change this line
   ```

### Configuration Options

- **apiBaseUrl**: Your API server URL
- **environment**: 'development' or 'production' 
- **enableLogging**: true/false for debug output
- **enableMockData**: true/false to use sample data
- **timeoutDuration**: API request timeout in seconds

## Deployment Instructions for Consumers

### For Internal Hosting

1. Download the latest release ZIP from the GitHub releases page
2. Extract to your web server's document root
3. Configure server for SPA routing (examples included in ZIP)
4. Set up proper cache headers for optimal performance

### Server Configuration Examples

The release includes complete configuration examples for:
- **Nginx** - Modern web server configuration
- **Apache** - Traditional Apache setup
- **Cache headers** - Proper browser caching setup
- **SPA routing** - Single Page Application URL handling

## Workflow Triggers

The release creation is triggered by:
- ✅ Push to `main` branch
- ✅ Manual workflow dispatch
- ❌ Pull requests (builds but doesn't create release)

## Version Naming

- **Format**: `v{YYYY.MM.DD}-{git-hash}`
- **Example**: `v2024.09.11-a1b2c3d`
- **Benefits**: 
  - Clear date-based versioning
  - Unique identification via git hash
  - Sortable chronologically

## File Structure Impact

The workflow:
- ✅ Builds production-ready code
- ✅ Applies cache busting
- ✅ Resets development files after build
- ✅ No impact on development workflow
- ✅ No persistent changes to repository

## Permissions

The workflow requires:
- `contents: write` - To create releases and tags
- `pages: write` - To deploy to GitHub Pages
- `id-token: write` - For GitHub Pages deployment

## Monitoring

Each workflow run provides:
- Build logs and timing information
- Release structure verification
- ZIP file size and contents
- Version information and cache details

## Benefits for Consumers

1. **Flexible Deployment Options** - Choose combined or separate packages
2. **Self-Contained Packages** - Everything needed for deployment
3. **Production Optimized** - Minified, tree-shaken, cache-optimized
4. **Deployment Ready** - Includes server configuration examples
5. **Versioned Releases** - Clear versioning and release notes
6. **Internal Hosting** - Perfect for corporate/private deployments

## Package Selection Guide

### 🔗 Use Combined Package When:
- You want both main app and styleguide together
- Single deployment with everything included
- Complete DMTools experience

### 📱 Use Main App Only When:
- Production deployment without design documentation
- Smaller package size needed
- Only the core functionality required

### 🎨 Use Styleguide Only When:
- Design team reference documentation
- Component library showcase
- Separate styleguide hosting
- Testing UI components independently

## Future Enhancements

Potential future improvements:
- Checksums for security verification
- Multiple format support (tar.gz, etc.)
- Environment-specific builds
- Automated testing of packaged releases
