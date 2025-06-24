import 'package:flutter/material.dart';
import 'base_logo.dart';

/// Network Nodes logo implementation - the main logo for the application
class NetworkNodesLogo extends BaseLogo {
  const NetworkNodesLogo({
    super.key,
    super.size = LogoSize.medium,
    super.color,
    super.isTestMode = false,
    super.testDarkMode = false,
  });

  @override
  String getLightAssetPath() {
    return 'assets/img/dmtools-logo-network-nodes.svg';
  }

  @override
  String getDarkAssetPath() {
    return 'assets/img/dmtools-logo-network-nodes-dark.svg';
  }

  @override
  double? getLogoWidth() {
    // Network nodes logo has a specific aspect ratio
    return size.size * 2.5;
  }
} 