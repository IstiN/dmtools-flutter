# DMTools Flutter

A Flutter implementation of the DMTools AI Agent Management Platform with comprehensive design system and UI components.

## Overview

DMTools Flutter is a cross-platform application built with Flutter that provides:
- **Main Application**: The core DMTools AI Agent Management Platform
- **Design System**: A comprehensive Flutter styleguide with reusable UI components
- **Cross-Platform Support**: Web, Android, iOS, and desktop platforms
- **Web-First Development**: Optimized for fast web development with VS Code integration

## Quick Start

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio (for Android development)
- Xcode (for iOS development, macOS only)
- Chrome browser (for web development)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/dmtools-flutter.git
cd dmtools-flutter

# Install dependencies for main app
flutter pub get

# Install dependencies for styleguide
cd flutter_styleguide
flutter pub get
cd ..
```

## Development Workflow

### 🌐 Web Development

The project is optimized for web development with streamlined VS Code integration.

#### VS Code Launch Configurations (F5 Menu)
- **Flutter Styleguide (Web)** - `http://localhost:8888`
- **Main App (Web)** - `http://localhost:8080`

#### Manual Web Commands
```bash
# Run main app on web
flutter run -d chrome --web-experimental-hot-reload --web-port=8080

# Run styleguide on web
cd flutter_styleguide
flutter run -d chrome --web-experimental-hot-reload --web-port=8888
```

#### VS Code Tasks (Ctrl/Cmd + Shift + P → "Tasks: Run Task")
- **Flutter: Clean** - Clean build cache
- **Flutter: Pub Get** - Install dependencies
- **Flutter: Test** - Run all tests
- **Flutter: Analyze** - Run static analysis
- **Flutter: Build Web** - Build for web production
- **Styleguide: Clean** - Clean styleguide build cache
- **Styleguide: Pub Get** - Install styleguide dependencies
- **Styleguide: Test** - Run styleguide tests
- **Styleguide: Test (Update Goldens)** - Update golden test files
- **Styleguide: Build Web** - Build styleguide for web

## Project Structure

```
dmtools-flutter/
├── lib/                      # Main application source
│   ├── main.dart            # Application entry point
│   ├── screens/             # Application screens
│   └── widgets/             # Custom widgets
├── flutter_styleguide/      # Design system package
│   ├── lib/                 # Styleguide components
│   ├── test/                # Tests and golden tests
│   └── assets/              # Design system assets

├── .vscode/                 # VS Code configuration
│   ├── launch.json          # Web launch configurations
│   ├── tasks.json           # Development tasks
│   ├── settings.json        # Development settings
│   └── extensions.json      # Recommended extensions
├── android/                 # Android platform files
├── ios/                     # iOS platform files
├── web/                     # Web platform files
└── assets/                  # Application assets
```

## Development

### Running Tests
```bash
# Run all tests for main app
flutter test

# Run styleguide tests
cd flutter_styleguide
flutter test

# Run golden tests
flutter test test/golden/

# Update golden tests
flutter test --update-goldens
```

### Building for Production

#### Web Build
```bash
# Build main app for web
flutter build web

# Build styleguide for web
cd flutter_styleguide
flutter build web
```

#### Android Build
```bash
# Build APK for testing
flutter build apk

# Build App Bundle for Play Store
flutter build appbundle
```

#### iOS Build
```bash
# Build for iOS
flutter build ios
```

### Code Quality
```bash
# Run code analysis
flutter analyze

# Check formatting
dart format --set-exit-if-changed .

# Run linter
flutter analyze --fatal-infos
```

## Additional Platform Development

For Android, iOS, or desktop development, you can use Flutter's standard commands:

```bash
# Android (requires Android Studio setup)
flutter run -d android

# iOS (requires Xcode on macOS)
flutter run -d ios

# Desktop
flutter run -d macos    # macOS
flutter run -d windows  # Windows
flutter run -d linux    # Linux
```

## Flutter Styleguide

The project includes a comprehensive design system in the `flutter_styleguide/` directory. This package provides:

- **Atomic Design Components**: Atoms, Molecules, and Organisms
- **Theme System**: Light/dark mode support with consistent colors
- **Typography**: Google Fonts integration with DMTools typography scale
- **Icons & Logos**: SVG-based icon system
- **Interactive Demo**: Live component showcase and documentation
- **Golden Tests**: Visual regression testing for all components

### Using the Styleguide Package

```dart
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

// Use components
PrimaryButton(
  text: 'Click Me',
  onPressed: () {},
)

// Apply theme
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  home: MyApp(),
)
```

See `flutter_styleguide/README.md` for detailed component documentation.

## Contributing

### Development Workflow
1. Create feature branch from `main`
2. Make changes following coding standards
3. Run tests and ensure they pass
4. Update documentation if needed
5. Submit pull request

### Coding Standards
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` for consistent formatting
- Write tests for new features
- Update golden tests when UI changes
- Document public APIs

### Testing Requirements
- Unit tests for business logic
- Widget tests for UI components
- Golden tests for visual regression
- Integration tests for user flows

## VS Code Development

### Recommended Workflow
1. **Daily Development**: Use F5 with web configurations for fast iteration
2. **Testing**: Use tasks (Ctrl/Cmd + Shift + P) for testing and building
3. **Code Quality**: Run analyze and format tasks regularly

### Keyboard Shortcuts
- **F5**: Launch web app (main or styleguide)
- **Ctrl/Cmd + Shift + P**: Access development tasks
- **Ctrl/Cmd + `**: Open integrated terminal

### Extensions
The project includes recommended VS Code extensions:
- Dart & Flutter extensions
- Error Lens for better error visibility
- TODO Tree for task management
- Code Spell Checker

## Deployment

### Web Deployment
```bash
# Build for web
flutter build web

# Deploy to hosting service
# (Firebase Hosting, Netlify, etc.)
```

### Android Deployment
```bash
# Build release APK
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release
```

### iOS Deployment
```bash
# Build for iOS
flutter build ios --release

# Archive and submit via Xcode
```

## Troubleshooting

### Common Issues

#### Flutter Doctor Issues
```bash
# Check Flutter installation
flutter doctor -v

# Use enhanced diagnostics
./scripts/android-setup.sh --doctor
```

#### Dependency Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get

# Use fix script
./scripts/android-setup.sh --fix
```

### Getting Help

1. **Flutter Doctor**: `flutter doctor -v` for environment diagnostics
2. **VS Code Tasks**: Access development tools via Command Palette
3. **Documentation**: Check `flutter_styleguide/README.md` for component docs

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions, issues, or contributions:
- Create an issue in the project repository
- Follow the contributing guidelines
- Use the built-in diagnostic tools
- Ensure all tests pass before submitting changes

---

*DMTools Flutter - Building the future of AI Agent Management with enhanced developer experience* 🚀 