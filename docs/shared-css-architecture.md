# Shared CSS Architecture

## Overview

To ensure consistency and reduce code duplication between the main app and styleguide, we use a shared CSS architecture where common theme styles are defined once and used by both applications.

## Architecture

```
dmtools-flutter/
├── web/
│   ├── css/
│   │   └── shared-theme.css          # Shared CSS for main app
│   └── index.html                    # Main app HTML (imports shared CSS)
├── flutter_styleguide/
│   ├── web/
│   │   ├── css/
│   │   │   └── shared-theme.css      # Copy of shared CSS for styleguide
│   │   └── index.html                # Styleguide HTML (imports shared CSS)
│   └── ...
└── assets/
    └── css/
        └── shared-theme.css          # Original shared CSS file
```

## Shared CSS File Structure

The `shared-theme.css` file contains:

### 1. Loading Indicators
- Hides all default Flutter loading elements
- Ensures clean loading experience

### 2. Base Layout
- Sets up basic HTML/body styles
- Defines overflow and margin behavior

### 3. Dark Theme Styles
- Dark background colors (#121212)
- Light text colors (#E9ECEF)
- Flutter element styling
- Canvas element styling

### 4. Light Theme Styles
- Light background colors (#F8F9FA)
- Dark text colors (#212529)
- Flutter element styling
- Canvas element styling

### 5. Loading Indicator Styles
- Custom loading indicator appearance
- Responsive layout

## Benefits

### ✅ **Consistency**
- Both apps use identical theme styling
- No style drift between applications
- Unified visual experience

### ✅ **Maintainability**
- Single source of truth for theme styles
- Changes apply to both apps simultaneously
- Reduced maintenance overhead

### ✅ **DRY Principle**
- No CSS code duplication
- Easier to understand and modify
- Less chance of inconsistencies

### ✅ **Bug Fixes**
- Fix black overlay issue once, applies everywhere
- Centralized theme bug resolution
- Easier debugging and testing

## Implementation Details

### HTML Integration
Both `index.html` files include:
```html
<!-- Shared theme styles -->
<link rel="stylesheet" href="css/shared-theme.css">
```

### Theme Classes
The CSS uses theme classes applied to the `<html>` element:
- `html.theme-dark` - Dark theme styles
- `html.theme-light` - Light theme styles

### Flutter Element Targeting
Specific targeting of Flutter web elements:
- `flt-glass-pane` - Flutter glass pane container
- `flutter-view` - Main Flutter view
- `canvas[data-flt-renderer]` - Flutter canvas elements
- `flt-scene-host`, `flt-scene` - Flutter scene elements

## File Synchronization

Currently, the CSS file is duplicated in three locations:
1. `assets/css/shared-theme.css` - Original/master file
2. `web/css/shared-theme.css` - Main app copy
3. `flutter_styleguide/web/css/shared-theme.css` - Styleguide copy

### Updating Shared Styles

When making changes to shared styles:

1. **Update the master file**: `assets/css/shared-theme.css`
2. **Copy to main app**: `cp assets/css/shared-theme.css web/css/shared-theme.css`
3. **Copy to styleguide**: `cp assets/css/shared-theme.css flutter_styleguide/web/css/shared-theme.css`
4. **Test both applications**

### Future Improvements

Consider implementing:
- Build script to automatically sync CSS files
- Symbolic links (on supported systems)
- CDN hosting for truly shared resources
- CSS preprocessing with shared variables

## Troubleshooting

### CSS Not Loading
- Check that the CSS file exists in the correct location
- Verify the `<link>` tag in `index.html`
- Check browser developer tools for 404 errors

### Theme Not Applied
- Verify `html.theme-dark` or `html.theme-light` class is applied
- Check JavaScript theme detection script
- Inspect CSS specificity and !important rules

### Style Conflicts
- The shared CSS uses `!important` to override Flutter defaults
- Avoid additional `!important` rules that might conflict
- Use browser developer tools to debug style application

## Related Files

- `web/index.html` - Main app HTML with theme scripts
- `flutter_styleguide/web/index.html` - Styleguide HTML
- `lib/theme/` - Flutter theme definitions
- `flutter_styleguide/lib/theme/` - Styleguide theme definitions

## Version History

- **v1.0** - Initial shared CSS implementation
- Fixed black overlay issue on text input focus
- Established shared architecture between main app and styleguide 