import 'package:flutter/material.dart';
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
    final colors =
        isTestMode == true ? (testDarkMode == true ? AppColors.dark : AppColors.light) : context.colorsListening;

    // Return icon based on integration type with fallback
    return _buildIcon(colors);
  }

  Widget _buildIcon(ThemeColorSet colors) {
    // Always use the default icon fallback approach for now
    // This prevents SVG loading errors from crashing the app
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
      case 'postgresql':
      case 'mongodb':
        iconData = Icons.storage;
        iconColor = colors.textColor;
        break;
      case 'confluence':
        iconData = Icons.description;
        iconColor = colors.textColor;
        break;
      case 'linear':
        iconData = Icons.timeline;
        iconColor = colors.textColor;
        break;
      case 'asana':
        iconData = Icons.assignment;
        iconColor = colors.textColor;
        break;
      case 'bitbucket':
        iconData = Icons.source;
        iconColor = colors.textColor;
        break;
      case 'gitlab':
        iconData = Icons.merge;
        iconColor = colors.textColor;
        break;
      case 'teams':
        iconData = Icons.video_call;
        iconColor = colors.textColor;
        break;
      case 'discord':
        iconData = Icons.forum;
        iconColor = colors.textColor;
        break;
      case 'aws':
        iconData = Icons.cloud_queue;
        iconColor = colors.textColor;
        break;
      case 'gcp':
      case 'azure':
        iconData = Icons.cloud_circle;
        iconColor = colors.textColor;
        break;
      case 'jenkins':
      case 'circleci':
        iconData = Icons.build_circle;
        iconColor = colors.textColor;
        break;
      case 'gemini':
        iconData = Icons.auto_awesome;
        iconColor = colors.textColor;
        break;
      case 'openai':
        iconData = Icons.psychology;
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
