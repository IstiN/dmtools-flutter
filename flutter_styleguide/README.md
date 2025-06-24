# DMTools Flutter Styleguide

A comprehensive Flutter implementation of the DMTools design system, showcasing UI components, design patterns, and visual guidelines following atomic design principles.

## Overview

The DMTools Flutter Styleguide is a living design system that demonstrates UI components and design patterns used throughout the DMTools application. It serves as both a reference for developers and a testing ground for new components, ensuring consistency and maintainability across the entire application ecosystem.

## How to Use This Library

### Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  dmtools_styleguide:
    git:
      url: https://github.com/yourusername/dmtools-flutter.git
      path: flutter_styleguide
```

### Basic Usage

Import the package and use the components:

```dart
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: PrimaryButton(
            text: 'Click Me',
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
```

### Theme Setup

To use the DMTools theme system, wrap your app with the `ThemeProvider`:

```dart
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      theme: themeProvider.isDarkMode ? 
        ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.dark.accentColor,
          ),
        ) : 
        ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.light.accentColor,
          ),
        ),
      home: MyHomePage(),
    );
  }
}
```

## Running the Demo App

The styleguide includes a demo app that showcases all components. To run it:

```bash
cd flutter_styleguide
flutter run -d chrome --web-experimental-hot-reload
```

## Architecture & Component Structure

The styleguide follows **Atomic Design** methodology, organizing components into five distinct levels of complexity:

1. **Atoms**: Basic building blocks (buttons, inputs, text elements)
2. **Molecules**: Groups of atoms functioning together (cards, search forms)
3. **Organisms**: Complex UI components (chat modules, headers)
4. **Templates**: Page layouts (not implemented yet)
5. **Pages**: Specific instances of templates (not implemented yet)

## Development

### Creating New Components

1. Create your component in the appropriate folder based on its complexity
2. Add it to the exports in `lib/dmtools_styleguide.dart`
3. Create a demo page or add it to an existing demo page
4. Add golden tests for the component

### Running Tests

```bash
flutter test
```

### Generating Golden Tests

```bash
flutter test --update-goldens
```

## Component Categories

### Atoms

- **Buttons**: Primary, Secondary, Outline, Text, Icon, Run
- **Text Elements**: Display, Headline, Title, Body, Label, Special
- **Logos & Icons**: Icon Logo, Wordmark Logo, Network Nodes Logo
- **Form Elements**: Text Input, Password Input, Select Dropdown, Checkbox, Radio
- **Status & Tags**: Status Dot, Tag Chip

### Molecules

- **Cards**: Custom Card, Agent Card, Application Item
- **Headers**: App Header, Base Section Header
- **Search**: Search Form
- **Chat Components**: Chat Input Group, Chat Message
- **User Interface**: User Profile Button, Action Button Group, Empty State

### Organisms

- **Chat Module**: Complete chat interface with messages and input
- **Page Header**: Application header with navigation and actions
- **Welcome Banner**: Hero banner with call-to-action buttons
- **Panel Base**: Collapsible content panel with customizable header
- **Workspace Management**: Workspace listing and management interface

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Chrome browser (for web development)

### Installation

```bash
# Navigate to the styleguide directory
cd flutter_styleguide

# Install dependencies
flutter pub get

# Run the styleguide
flutter run -d chrome --web-experimental-hot-reload
```

### Development Commands

```bash
# Run tests
flutter test

# Run golden tests
flutter test test/golden/

# Build for production
flutter build web

# Analyze code
flutter analyze
```

## Project Structure

```
flutter_styleguide/
├── lib/
│   ├── theme/                 # Theme definitions
│   │   ├── app_colors.dart    # Color palette
│   │   ├── app_dimensions.dart # Spacing & sizing
│   │   └── app_theme.dart     # Theme configuration
│   ├── widgets/
│   │   ├── atoms/            # Basic components
│   │   │   ├── buttons/      # Button variants
│   │   │   ├── texts/        # Text components
│   │   │   ├── logos/        # Logo components
│   │   │   └── form_elements.dart
│   │   ├── molecules/        # Compound components
│   │   │   ├── cards/        # Card components
│   │   │   ├── headers/      # Header components
│   │   │   └── search/       # Search components
│   │   ├── organisms/        # Complex components
│   │   └── styleguide/       # Styleguide components
│   ├── screens/
│   │   └── styleguide_pages/ # Styleguide pages
│   └── main.dart
├── test/
│   └── golden/               # Golden tests
├── assets/
│   ├── fonts/               # Custom fonts
│   ├── icons/               # Icon assets
│   └── images/              # Image assets
└── pubspec.yaml
```

## Dependencies

### Core Dependencies
- **Flutter**: UI framework
- **Provider**: State management
- **Google Fonts**: Typography
- **Flutter SVG**: SVG rendering

### Development Dependencies
- **flutter_test**: Testing framework
- **flutter_goldens**: Visual regression testing
- **flutter_lints**: Code quality

## Contributing

### Component Development Guidelines

1. **Follow Atomic Design**: Place components in appropriate hierarchy level
2. **Theme Integration**: All components must support light/dark themes
3. **Golden Tests**: Create visual tests for new components
4. **Documentation**: Update this README when adding new components
5. **Accessibility**: Ensure components meet WCAG guidelines

### Adding New Components

1. Create the component in the appropriate directory
2. Add theme support and color integration
3. Create golden tests for visual regression
4. Add to the appropriate styleguide page
5. Update the mermaid diagram if needed
6. Run tests to ensure everything works

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/golden/atoms_golden_test.dart

# Update golden tests
flutter test --update-goldens
```

## Design Principles

### **Consistency**
- All components follow the same design language
- Consistent spacing, typography, and color usage
- Unified interaction patterns

### **Accessibility**
- WCAG 2.1 AA compliance
- Proper contrast ratios
- Keyboard navigation support
- Screen reader compatibility

### **Performance**
- Minimal widget rebuilds
- Efficient state management
- Optimized asset loading
- Responsive design patterns

### **Maintainability**
- Clear component hierarchy
- Comprehensive documentation
- Automated testing
- Version control for design tokens

## License

This project is part of DMTools and follows its licensing terms. All components and design patterns are proprietary to DMTools.

## Support

For questions, issues, or contributions:
- Create an issue in the project repository
- Follow the contributing guidelines
- Ensure all tests pass before submitting changes

---

*This styleguide is a living document that evolves with the DMTools application. Regular updates ensure it remains current with the latest design patterns and component implementations.* 