# DMTools Icon Deployment Guide

## ✅ Completed

### 1. Final Icon Design
- **Selected Icon**: DM.ai variant (dark slate gradient background with pill DNA element)
- **Location**: `assets/img/dmtools-icon-final-selected-dm.svg`
- **Alternative**: AI.n variant saved in styleguide for future use

### 2. Web Deployment
- ✅ **favicon.svg**: Deployed to `web/favicon.svg`
- ✅ **Main icon**: Updated `assets/img/dmtools-icon.svg`

## 📋 Manual PNG Generation Required

The flutter_launcher_icons package doesn't support SVG directly. PNG icons need to be generated manually for:

### Web PWA Icons Needed:
- `web/favicon.png` (32x32)
- `web/icons/Icon-192.png` (192x192)
- `web/icons/Icon-512.png` (512x512)
- `web/icons/Icon-maskable-192.png` (192x192 with safe zone)
- `web/icons/Icon-maskable-512.png` (512x512 with safe zone)

### Android Icons Needed:
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)

### iOS Icons Needed:
All icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`:
- Icon-App-20x20@1x.png (20x20)
- Icon-App-20x20@2x.png (40x40)
- Icon-App-20x20@3x.png (60x60)
- Icon-App-29x29@1x.png (29x29)
- Icon-App-29x29@2x.png (58x58)
- Icon-App-29x29@3x.png (87x87)
- Icon-App-40x40@1x.png (40x40)
- Icon-App-40x40@2x.png (80x80)
- Icon-App-40x40@3x.png (120x120)
- Icon-App-60x60@2x.png (120x120)
- Icon-App-60x60@3x.png (180x180)
- Icon-App-76x76@1x.png (76x76)
- Icon-App-76x76@2x.png (152x152)
- Icon-App-83.5x83.5@2x.png (167x167)
- Icon-App-1024x1024@1x.png (1024x1024)

### macOS Icons Needed:
All icons in `macos/Runner/Assets.xcassets/AppIcon.appiconset/`:
- app_icon_16.png (16x16)
- app_icon_32.png (32x32)
- app_icon_64.png (64x64)
- app_icon_128.png (128x128)
- app_icon_256.png (256x256)
- app_icon_512.png (512x512)
- app_icon_1024.png (1024x1024)

## 🛠️ PNG Generation Options

### Option 1: Online Tool
1. Open https://realfavicongenerator.net/ or https://icon.kitchen/
2. Upload `assets/img/dmtools-icon-final-selected-dm.svg`
3. Generate icons for all platforms
4. Download and extract to appropriate folders

### Option 2: HTML Generator (Provided)
1. Open `temp/icon_generator.html` in a browser
2. It will generate PNGs from the SVG
3. Download all sizes
4. Manually copy to appropriate folders

### Option 3: ImageMagick (if available)
```bash
# Install ImageMagick first
brew install imagemagick  # macOS
# or
apt-get install imagemagick  # Linux

# Then run conversion script
for size in 16 20 29 32 40 48 60 64 72 76 96 120 128 144 152 167 180 192 256 512 1024; do
  convert -background none -resize ${size}x${size} assets/img/dmtools-icon-final-selected-dm.svg icon-${size}.png
done
```

### Option 4: Inkscape (if available)
```bash
inkscape --export-png=output.png --export-width=1024 --export-height=1024 assets/img/dmtools-icon-final-selected-dm.svg
```

## 📝 Files Modified

- `web/favicon.svg` ✅
- `assets/img/dmtools-icon.svg` ✅
- `assets/img/dmtools-icon-final-selected-dm.svg` (source)
- `flutter_styleguide/assets/img/dmtools-icon-final-selected-dm.svg` (source)
- `flutter_styleguide/assets/img/dmtools-icon-final-selected-ain.svg` (alternative, saved for future)

## 🎨 Icon Specifications

**DM.ai Icon Design:**
- Dark slate gradient background (#1e293b → #334155)
- White pill/capsule element with DNA dots (cyan #06b6d4 and orange #f97316)
- Large white "DM" text
- Cyan "ai" badge bottom-aligned with DM
- Rounded square corners (rx="90" for 512x512 viewBox)

**Color Palette:**
- Background: `#1e293b` → `#334155` (dark slate gradient)
- Text: `#ffffff` (white)
- DNA dots: `#06b6d4` (cyan), `#f97316` (orange)
- Center line: `#3b82f6` (blue)
- AI badge: `#06b6d4` (cyan)

## 🚀 Deployment Status

- ✅ SVG icons deployed for web
- ⏳ PNG icons need manual generation
- ⏳ Android icons need update
- ⏳ iOS icons need update
- ⏳ macOS icons need update

## 📚 Alternative Icon

The **AI.n** icon variant is available in the styleguide for potential future use:
- Location: `flutter_styleguide/assets/img/dmtools-icon-final-selected-ain.svg`
- Purple gradient background
- Large white "AI" text + yellow ".n" badge
- Adobe Illustrator style

