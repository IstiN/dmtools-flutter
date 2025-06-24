# DMTools - AI Agent Management Platform

DMTools is a comprehensive platform for building, deploying, and managing AI agents. This repository contains the Flutter implementation of the DMTools application.

## Project Structure

This project is organized into three main components:

1. **Main Application** (root directory)
   - The main DMTools application
   - Uses the styleguide library for UI components

2. **UI Component Library** (`flutter_styleguide/`)
   - Reusable UI components following atomic design principles
   - Used by both the main application and the styleguide example app

3. **Styleguide Example App** (`flutter_styleguide/example/`)
   - Demonstrates the UI components in isolation
   - Serves as documentation for the UI library

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK (version 3.0.0 or higher)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/dmtools-flutter.git
cd dmtools-flutter
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the main application:

```bash
flutter run
```

### Running the Styleguide

To run the styleguide example app:

```bash
cd flutter_styleguide
flutter run -d chrome --web-experimental-hot-reload
```

## Development

### Project Structure

```
dmtools-flutter/
├── lib/                 # Main application code
│   ├── screens/         # Application screens
│   ├── widgets/         # Application-specific widgets
│   └── main.dart        # Application entry point
├── flutter_styleguide/  # UI component library
│   ├── lib/             # Library code
│   │   ├── widgets/     # Reusable UI components
│   │   ├── theme/       # Theme definitions
│   │   └── dmtools_styleguide.dart # Library exports
│   ├── example/         # Example app for the UI library
│   └── test/            # Tests for the UI library
└── pubspec.yaml         # Main application dependencies
```

### Next Steps

1. Fix layout issues in the main application
   - Fix overflow in workspace summary widget
   - Ensure responsive design for different screen sizes

2. Complete the UI component library
   - Add missing components (accent_card, empty_states)
   - Create comprehensive documentation
   - Add more examples to the styleguide app

3. Implement core functionality
   - Authentication system
   - Agent management
   - Workspace management
   - User management

4. Add tests
   - Unit tests for core functionality
   - Widget tests for UI components
   - Integration tests for key workflows

## License

This project is licensed under the MIT License - see the LICENSE file for details. 