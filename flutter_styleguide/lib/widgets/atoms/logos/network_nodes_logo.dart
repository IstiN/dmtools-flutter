import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'base_logo.dart';

class NetworkNodesLogo extends BaseLogo {
  const NetworkNodesLogo({
    super.key,
    super.size,
    super.isDarkMode,
    super.isTestMode,
    bool testDarkMode = false,
  });

  @override
  double get width {
    // Use a more reasonable aspect ratio to prevent overflow
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
  Widget buildLogo(bool isDark) {
    // Use the network nodes logo that's visible on both light and dark backgrounds
    final String assetName = isDark 
        ? 'assets/img/dmtools-logo-network-nodes-dark.svg'
        : 'assets/img/dmtools-logo-network-nodes.svg';

    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      colorFilter: isDark ? 
        const ColorFilter.mode(Colors.white, BlendMode.srcIn) : 
        null,
      placeholderBuilder: (BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            'DM Tools',
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