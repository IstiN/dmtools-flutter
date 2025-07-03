import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/integration_type_icon.dart';
import '../atoms/buttons/primary_button.dart';
import '../atoms/buttons/secondary_button.dart';

import 'integration_management.dart';
import '../responsive/responsive_builder.dart';

/// Detailed integration page showing comprehensive information and setup
class IntegrationDetail extends StatefulWidget {
  final IntegrationDefinition integration;
  final Function(IntegrationDefinition, Map<String, String>) onSetupIntegration;
  final VoidCallback? onBack;
  final bool? isTestMode;
  final bool? testDarkMode;

  const IntegrationDetail({
    required this.integration,
    required this.onSetupIntegration,
    this.onBack,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  State<IntegrationDetail> createState() => _IntegrationDetailState();
}

class _IntegrationDetailState extends State<IntegrationDetail> {
  final Map<String, String> _configValues = {};

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;

    if (widget.isTestMode == true) {
      isDarkMode = widget.testDarkMode ?? false;
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and header
          Row(
            children: [
              if (widget.onBack != null)
                IconButton(
                  icon: Icon(Icons.arrow_back, color: colors.textColor),
                  onPressed: widget.onBack,
                  tooltip: 'Back to integrations',
                ),
              Expanded(
                child: _buildHeader(colors),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingXl),

          // Main content - responsive layout
          ResponsiveWidget(
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(colors),
                const SizedBox(height: AppDimensions.spacingXl),
                _buildConfigSection(colors),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column - Information
                Expanded(
                  child: _buildInfoSection(colors),
                ),
                const SizedBox(width: AppDimensions.spacingXl),
                // Right column - Configuration
                Expanded(
                  child: _buildConfigSection(colors),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IntegrationTypeIcon(
              integrationType: widget.integration.type,
              iconUrl: widget.integration.iconUrl,
              size: 48,
              isTestMode: widget.isTestMode,
              testDarkMode: widget.testDarkMode,
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.integration.displayName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: colors.textColor,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingS),
                      if (widget.integration.isPopular)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.accentColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Popular',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors.primaryTextOnAccent,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(
                    widget.integration.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingM),
        // Tags and metadata
        Wrap(
          spacing: AppDimensions.spacingS,
          runSpacing: AppDimensions.spacingXs,
          children: [
            // Category
            _buildTag(widget.integration.category, colors.accentColor, colors),
            // Difficulty
            _buildTag(
              '${widget.integration.setupDifficulty} setup',
              _getDifficultyColor(widget.integration.setupDifficulty, colors),
              colors,
            ),
            // Tags
            ...widget.integration.tags.map((tag) => _buildTag(tag, colors.textMuted, colors)),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color, ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoSection(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Features section
        _buildSectionCard(
          title: 'Features',
          icon: Icons.star_outline,
          colors: colors,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.integration.features.map((feature) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingXs),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: colors.successColor,
                    ),
                    const SizedBox(width: AppDimensions.spacingS),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Setup instructions
        _buildSectionCard(
          title: 'Setup Instructions',
          icon: Icons.assignment_outlined,
          colors: colors,
          child: _buildSetupInstructions(colors),
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Documentation link
        if (widget.integration.documentationUrl != null)
          _buildSectionCard(
            title: 'Documentation',
            icon: Icons.description_outlined,
            colors: colors,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help? Check out the official documentation for detailed setup guides and troubleshooting.',
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),
                SecondaryButton(
                  text: 'View Documentation',
                  onPressed: () {
                    // TODO: Open documentation URL
                    debugPrint('Opening documentation: ${widget.integration.documentationUrl}');
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildConfigSection(ThemeColorSet colors) {
    return _buildSectionCard(
      title: 'Configuration',
      icon: Icons.settings_outlined,
      colors: colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure your ${widget.integration.displayName} integration',
            style: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Configuration form would go here
          // For now, showing a placeholder
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            decoration: BoxDecoration(
              color: colors.bgColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: colors.borderColor),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.construction,
                  size: 48,
                  color: colors.textMuted,
                ),
                const SizedBox(height: AppDimensions.spacingM),
                Text(
                  'Configuration Form',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.textColor,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Text(
                  'Dynamic configuration form will be displayed here based on the integration type requirements.',
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingL),
                PrimaryButton(
                  text: 'Setup Integration',
                  onPressed: () {
                    widget.onSetupIntegration(widget.integration, _configValues);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required ThemeColorSet colors,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.accentColor, size: 20),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          child,
        ],
      ),
    );
  }

  Widget _buildSetupInstructions(ThemeColorSet colors) {
    // Get setup instructions based on integration type
    final instructions = _getSetupInstructions(widget.integration.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instructions.asMap().entries.map((entry) {
        final index = entry.key;
        final instruction = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colors.accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colors.primaryTextOnAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: Text(
                  instruction,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<String> _getSetupInstructions(String integrationType) {
    switch (integrationType.toLowerCase()) {
      case 'github':
        return [
          'Go to GitHub Settings > Developer settings > Personal access tokens',
          'Click "Generate new token" and select required scopes',
          'Copy the generated token (you won\'t see it again)',
          'Paste the token in the configuration form below',
        ];
      case 'slack':
        return [
          'Go to your Slack workspace settings',
          'Navigate to "Apps" and search for incoming webhooks',
          'Create a new webhook URL for your desired channel',
          'Copy the webhook URL and paste it below',
        ];
      case 'jira':
        return [
          'Log in to your Jira instance as an administrator',
          'Go to Settings > System > API tokens',
          'Create a new API token with required permissions',
          'Configure the token and server URL below',
        ];
      default:
        return [
          'Visit the service\'s developer or API settings page',
          'Create new API credentials or access tokens',
          'Copy the required configuration values',
          'Enter the values in the configuration form below',
        ];
    }
  }

  Color _getDifficultyColor(String difficulty, ThemeColorSet colors) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return colors.successColor;
      case 'medium':
        return colors.warningColor;
      case 'hard':
        return colors.dangerColor;
      default:
        return colors.textMuted;
    }
  }
}
