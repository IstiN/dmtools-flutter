import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/integration_type_icon.dart';
import '../atoms/buttons/app_buttons.dart';
import '../molecules/headers/page_action_bar.dart';
import '../molecules/integration_type_selector.dart';

/// Detailed integration page showing comprehensive information and setup
class IntegrationDetail extends StatefulWidget {
  final IntegrationType integration;
  final Function(IntegrationType, Map<String, String>) onSetupIntegration;
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
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    ThemeColorSet colors;

    if (widget.isTestMode == true) {
      final isDarkMode = widget.testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      colors = context.colors;
    }

    return Container(
      color: colors.bgColor,
      child: Column(
        children: [
          PageActionBar(
            title: widget.integration.displayName,
            showBorder: true,
            actions: widget.onBack != null
                ? [
                    AppIconButton(
                      text: 'Back',
                      icon: Icons.arrow_back,
                      onPressed: widget.onBack!,
                      size: ButtonSize.small,
                      isTestMode: widget.isTestMode ?? false,
                    ),
                  ]
                : [],
            isTestMode: widget.isTestMode ?? false,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Integration header
                  _buildIntegrationHeader(colors),
                  const SizedBox(height: AppDimensions.spacingXl),

                  // Description
                  _buildDescription(colors),
                  const SizedBox(height: AppDimensions.spacingXl),

                  // Configuration
                  _buildConfiguration(colors),
                  const SizedBox(height: AppDimensions.spacingXl),

                  // Setup button
                  _buildSetupButton(colors),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationHeader(ThemeColorSet colors) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colors.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: IntegrationTypeIcon(
            integrationType: widget.integration.type,
            size: 40,
            iconUrl: widget.integration.iconUrl,
            isTestMode: widget.isTestMode,
            testDarkMode: widget.testDarkMode,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.integration.displayName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                _getIntegrationCategory(widget.integration.type),
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this integration',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.textColor,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          widget.integration.description,
          style: TextStyle(
            fontSize: 16,
            color: colors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildConfiguration(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configuration Requirements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.textColor,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        ...widget.integration.configParams.map((param) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        param.displayName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textColor,
                        ),
                      ),
                      if (param.required) ...[
                        const SizedBox(width: 4),
                        Text(
                          '*',
                          style: TextStyle(
                            color: colors.dangerColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    param.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildSetupButton(ThemeColorSet colors) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: 'Setup Integration',
        isLoading: _isLoading,
        onPressed: () {
          widget.onSetupIntegration(widget.integration, _configValues);
        },
        isTestMode: widget.isTestMode ?? false,
        testDarkMode: widget.testDarkMode ?? false,
      ),
    );
  }

  String _getIntegrationCategory(String type) {
    switch (type.toLowerCase()) {
      case 'github':
      case 'gitlab':
      case 'bitbucket':
        return 'Version Control';
      case 'slack':
      case 'teams':
      case 'discord':
        return 'Communication';
      case 'jira':
      case 'linear':
      case 'asana':
      case 'trello':
        return 'Project Management';
      case 'aws':
      case 'gcp':
      case 'azure':
        return 'Cloud Services';
      case 'jenkins':
      case 'circleci':
        return 'CI/CD';
      case 'postgresql':
      case 'mongodb':
        return 'Databases';
      case 'webhook':
      case 'api':
        return 'Custom';
      case 'confluence':
        return 'Documentation';
      default:
        return 'Integration';
    }
  }
}
