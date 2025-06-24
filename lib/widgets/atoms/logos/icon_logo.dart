import 'package:flutter/material.dart';
import 'base_logo.dart';

/// Icon logo implementation - the square icon/favicon logo
class IconLogo extends BaseLogo {
  const IconLogo({
    super.key,
    super.size = LogoSize.medium,
    super.color,
    super.isTestMode = false,
    super.testDarkMode = false,
  });

  @override
  String getLightAssetPath() {
    return 'assets/img/dmtools-icon.svg';
  }

  @override
  String getDarkAssetPath() {
    return 'assets/img/dmtools-icon.svg';
  }

  @override
  double? getLogoWidth() {
    // Icon logo is square
    return size.size;
  }
} 