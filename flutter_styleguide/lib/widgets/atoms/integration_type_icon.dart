import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

/// Displays an icon for an integration type with fallback to generic icon
class IntegrationTypeIcon extends StatelessWidget {
  final String integrationType;
  final String? iconUrl;
  final double size;
  final bool? isTestMode;
  final bool? testDarkMode;

  const IntegrationTypeIcon({
    required this.integrationType,
    this.iconUrl,
    this.size = 24,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;

    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

    // Return icon based on integration type with fallback
    return _buildIcon(colors);
  }

  Widget _buildIcon(ThemeColorSet colors) {
    // If iconUrl is provided, try to load it
    if (iconUrl != null && iconUrl!.isNotEmpty) {
      if (iconUrl!.endsWith('.svg')) {
        return SvgPicture.network(
          iconUrl!,
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(colors.textColor, BlendMode.srcIn),
          placeholderBuilder: (context) => _getDefaultIcon(colors),
        );
      } else {
        return Image.network(
          iconUrl!,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) => _getDefaultIcon(colors),
        );
      }
    }

    // Use predefined icons for common integration types
    return _getDefaultIcon(colors);
  }

  Widget _getDefaultIcon(ThemeColorSet colors) {
    IconData iconData;
    Color? iconColor;

    switch (integrationType.toLowerCase()) {
      case 'github':
        iconData = Icons.code;
        iconColor = colors.textColor;
        break;
      case 'slack':
        iconData = Icons.chat;
        iconColor = colors.textColor;
        break;
      case 'google':
      case 'google_drive':
        iconData = Icons.cloud;
        iconColor = colors.textColor;
        break;
      case 'microsoft':
      case 'microsoft_teams':
        iconData = Icons.business;
        iconColor = colors.textColor;
        break;
      case 'jira':
        iconData = Icons.bug_report;
        iconColor = colors.textColor;
        break;
      case 'trello':
        iconData = Icons.dashboard;
        iconColor = colors.textColor;
        break;
      case 'notion':
        iconData = Icons.description;
        iconColor = colors.textColor;
        break;
      case 'webhook':
        iconData = Icons.webhook;
        iconColor = colors.textColor;
        break;
      case 'api':
        iconData = Icons.api;
        iconColor = colors.textColor;
        break;
      case 'database':
        iconData = Icons.storage;
        iconColor = colors.textColor;
        break;
      default:
        iconData = Icons.integration_instructions;
        iconColor = colors.textColor;
    }

    return Icon(
      iconData,
      size: size,
      color: iconColor,
    );
  }
}
