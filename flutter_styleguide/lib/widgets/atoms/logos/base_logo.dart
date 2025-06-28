import 'package:flutter/material.dart';

enum LogoSize {
  small,
  medium,
  large,
}

abstract class BaseLogo extends StatelessWidget {
  final LogoSize size;
  final bool isDarkMode;
  final bool isTestMode;

  const BaseLogo({
    super.key,
    this.size = LogoSize.medium,
    this.isDarkMode = false,
    this.isTestMode = false,
  });

  double get height {
    switch (size) {
      case LogoSize.small:
        return 40.0;
      case LogoSize.medium:
        return 48.0;
      case LogoSize.large:
        return 64.0;
    }
  }

  double get width {
    // Override in subclasses if aspect ratio is different
    return height;
  }

  Color get primaryColor => isDarkMode ? Colors.white : Colors.black;
  Color get accentColor => const Color(0xFF466AF1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actualDarkMode = isTestMode ? isDarkMode : theme.brightness == Brightness.dark;
    
    return SizedBox(
      width: width,
      height: height,
      child: buildLogo(actualDarkMode),
    );
  }

  Widget buildLogo(bool isDark);
} 