import 'package:flutter/material.dart';
import 'base_logo.dart';

class WordmarkLogo extends BaseLogo {
  const WordmarkLogo({
    super.key,
    super.size,
    super.isDarkMode,
    super.isTestMode,
  });

  @override
  double get width {
    switch (size) {
      case LogoSize.small:
        return 100.0;
      case LogoSize.medium:
        return 140.0;
      case LogoSize.large:
        return 180.0;
    }
  }

  @override
  double get height {
    // Slightly smaller than base logo sizes
    switch (size) {
      case LogoSize.small:
        return 18.0;
      case LogoSize.medium:
        return 24.0;
      case LogoSize.large:
        return 36.0;
    }
  }

  @override
  Widget buildLogo(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final fontSize = height * 0.8;
    
    return Text(
      'DMTools',
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
    );
  }
} 