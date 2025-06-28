import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'base_logo.dart';

class IconLogo extends BaseLogo {
  const IconLogo({
    super.key,
    super.size,
    super.isDarkMode,
    super.isTestMode,
    bool testDarkMode = false,
  });

  @override
  Widget buildLogo(bool isDark) {
    const String assetName = 'assets/img/dmtools-icon.svg';
    final color = isDark ? Colors.white : Colors.black;

    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
      placeholderBuilder: (BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Icon(
            Icons.device_hub,
            color: isDark ? Colors.white : Colors.black,
            size: height * 0.6,
          ),
        ),
      ),
    );
  }
} 