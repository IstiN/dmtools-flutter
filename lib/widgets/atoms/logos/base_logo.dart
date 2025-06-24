import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_dimensions.dart';

/// Logo sizes for consistent sizing across the application
enum LogoSize {
  xs(24.0),
  small(32.0),
  medium(48.0),
  large(64.0),
  xl(96.0),
  xxl(128.0);

  final double size;
  const LogoSize(this.size);
}

/// Base class for logo components
abstract class BaseLogo extends StatelessWidget {
  final LogoSize size;
  final Color? color;
  final bool isTestMode;
  final bool testDarkMode;

  const BaseLogo({
    Key? key,
    this.size = LogoSize.medium,
    this.color,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  /// Get the light theme asset path
  String getLightAssetPath();

  /// Get the dark theme asset path
  String getDarkAssetPath();

  /// Get the current asset path based on theme
  String getAssetPath(bool isDarkMode) {
    return isDarkMode ? getDarkAssetPath() : getLightAssetPath();
  }

  /// Get the logo width based on size
  double? getLogoWidth() {
    return null; // Default to null for SVGs that maintain aspect ratio
  }

  /// Get the logo height based on size
  double getLogoHeight() {
    return size.size;
  }

  /// Build the logo widget
  @override
  Widget build(BuildContext context) {
    final isDarkMode = isTestMode ? testDarkMode : Theme.of(context).brightness == Brightness.dark;
    final assetPath = getAssetPath(isDarkMode);

    return SvgPicture.asset(
      assetPath,
      height: getLogoHeight(),
      width: getLogoWidth(),
      fit: BoxFit.contain,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
} 