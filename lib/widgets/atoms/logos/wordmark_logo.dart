import 'package:flutter/material.dart';
import 'base_logo.dart';

/// Wordmark logo implementation - text-only logo
class WordmarkLogo extends BaseLogo {
  const WordmarkLogo({
    super.key,
    super.size = LogoSize.medium,
    super.color,
    super.isTestMode = false,
    super.testDarkMode = false,
  });

  @override
  String getLightAssetPath() {
    return 'assets/img/dmtools-logo-wordmark-adaptive.svg';
  }

  @override
  String getDarkAssetPath() {
    return 'assets/img/dmtools-logo-wordmark-adaptive.svg';
  }

  @override
  double? getLogoWidth() {
    // Wordmark logo has a specific aspect ratio
    return size.size * 3.0;
  }
} 