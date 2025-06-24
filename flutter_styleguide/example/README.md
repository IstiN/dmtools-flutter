# DMTools Styleguide Example

This is an example application that demonstrates how to use the DMTools Styleguide library in a Flutter project.

## Getting Started

1. Make sure you have Flutter installed and set up on your machine.
2. Clone the repository:

```bash
git clone https://github.com/yourusername/dmtools-flutter.git
```

3. Navigate to the example directory:

```bash
cd dmtools-flutter/flutter_styleguide/example
```

4. Run the app:

```bash
flutter run
```

## What's Included

This example demonstrates:

- Setting up the ThemeProvider for light/dark mode
- Using various components from the styleguide:
  - Buttons (Primary, Secondary, Outline, White Outline)
  - Agent Card
  - Chat Module
  - Welcome Banner

## Structure

The example app is structured as follows:

- `main.dart`: Main application entry point
- `pubspec.yaml`: Dependencies configuration

## How to Use Components

Each component from the styleguide can be imported from the main library package:

```dart
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
```

Then you can use any component in your widgets:

```dart
PrimaryButton(
  text: 'Click Me',
  onPressed: () {
    // Your action here
  },
)
```

For more details on available components and their usage, see the main [DMTools Styleguide README](../README.md). 