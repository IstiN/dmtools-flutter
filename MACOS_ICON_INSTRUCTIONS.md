# macOS Icon Generation - Quick Guide

## Problem
The macOS app is showing the Flutter default icon because PNG files haven't been generated yet.

## Solution (3 Minutes)

### Step 1: Use Online Icon Generator

1. Open: https://icon.kitchen/i/H4sIAAAAAAAAA1VMQWrDMBDb9Yr%2BgL%2BQkONBaXPJqRf3YtvrtcFWgu1C%2FPquyaFIAxqNhDTy2sxGXt7AmhGcrLKx%2BQFa4BgLz4ZeYpGRKxRNaBJH0G2GXlYwxkq%2BQx8VCfqGPnEgRWvkJxTNcYQWOJLClCvUzXGAFlhiZQq1cxygBY5YmUIHHAdogSNWplA3xwFa4IiVKXTAcYAWOGJlCh1wHKAFjliZQgccB2iBY1HoT%2BFv6I%2FQ4%2F8VxRAAAA%3D%3D

or

2. Open https://www.appicon.co/
3. Upload your SVG: `assets/img/dmtools-icon-final-selected-dm.svg`
4. Download the macOS icons

### Step 2: Copy Icons to Project

After downloading, extract and copy to:
```
/Users/Uladzimir_Klyshevich/git/dmtools/dmtools-flutter/macos/Runner/Assets.xcassets/AppIcon.appiconset/
```

Required files:
- app_icon_16.png
- app_icon_32.png
- app_icon_64.png  
- app_icon_128.png
- app_icon_256.png
- app_icon_512.png
- app_icon_1024.png

### Step 3: Clean and Rebuild

```bash
cd /Users/Uladzimir_Klyshevich/git/dmtools/dmtools-flutter
flutter clean
flutter run -d macos
```

## Alternative: Manual Installation (Homebrew + ImageMagick)

If you want to automate this in the future:

```bash
# Install ImageMagick
brew install imagemagick

# Run conversion
cd /Users/Uladzimir_Klyshevich/git/dmtools/dmtools-flutter
for size in 16 32 64 128 256 512 1024; do
  convert -background none -resize ${size}x${size} \
    assets/img/dmtools-icon-final-selected-dm.svg \
    macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_${size}.png
done

# Clean and rebuild
flutter clean
flutter run -d macos
```

## Why Python Scripts Failed

Python SVG libraries (cairosvg, svglib) require system-level Cairo library installation, which adds complexity. The online tool or ImageMagick approach is simpler and more reliable.

