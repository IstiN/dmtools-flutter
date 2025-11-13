import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'base_logo.dart';

class DmAiLogo extends BaseLogo {
  const DmAiLogo({
    super.key,
    super.size,
    super.isDarkMode,
    super.isTestMode,
  });

  @override
  double get width {
    // Aspect ratio is approximately 3:1 (300:100)
    switch (size) {
      case LogoSize.small:
        return 120.0;
      case LogoSize.medium:
        return 150.0;
      case LogoSize.large:
        return 200.0;
    }
  }

  @override
  double get height {
    // Aspect ratio is approximately 3:1 (300:100)
    switch (size) {
      case LogoSize.small:
        return 40.0;
      case LogoSize.medium:
        return 50.0;
      case LogoSize.large:
        return 67.0;
    }
  }

  @override
  Widget buildLogo(bool isDark) {
    // Use dark version for dark theme, light version for light theme
    final String assetName = isDark
        ? 'assets/img/dmtools-logo-dm-ai-dark.svg'
        : 'assets/img/dmtools-logo-dm-ai-light.svg';

    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      placeholderBuilder: (BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            'DM ai',
            style: TextStyle(
              fontSize: height * 0.4,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}





