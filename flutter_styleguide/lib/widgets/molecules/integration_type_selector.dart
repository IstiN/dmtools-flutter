import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/integration_type_icon.dart';

/// Model for integration type data
class IntegrationType {
  final String type;
  final String displayName;
  final String description;
  final String? iconUrl;
  final List<ConfigParam> configParams;

  const IntegrationType({
    required this.type,
    required this.displayName,
    required this.description,
    required this.configParams,
    this.iconUrl,
  });
}

class ConfigParam {
  final String key;
  final String displayName;
  final String description;
  final bool required;
  final bool sensitive;
  final String? defaultValue;
  final String type;
  final List<String> options;

  const ConfigParam({
    required this.key,
    required this.displayName,
    required this.description,
    required this.required,
    required this.sensitive,
    required this.type,
    required this.options,
    this.defaultValue,
  });
}

/// Grid selector for choosing integration types when creating new integrations
class IntegrationTypeSelector extends StatelessWidget {
  final List<IntegrationType> integrationTypes;
  final IntegrationType? selectedType;
  final ValueChanged<IntegrationType> onTypeSelected;
  final bool? isTestMode;
  final bool? testDarkMode;

  const IntegrationTypeSelector({
    required this.integrationTypes,
    required this.onTypeSelected,
    this.selectedType,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use flexible layout that adapts to available space
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Integration Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Choose the type of service you want to integrate with',
              style: TextStyle(
                fontSize: 14,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            // Use Flexible instead of Expanded to handle constrained heights
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppDimensions.spacingM,
                  mainAxisSpacing: AppDimensions.spacingM,
                  childAspectRatio: 0.8,
                ),
                itemCount: integrationTypes.length,
                itemBuilder: (context, index) {
                  final integrationType = integrationTypes[index];
                  final isSelected = selectedType?.type == integrationType.type;

                  return _buildTypeCard(integrationType, isSelected, colors);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTypeCard(IntegrationType integrationType, bool isSelected, ThemeColorSet colors) {
    return GestureDetector(
      onTap: () => onTypeSelected(integrationType),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? colors.accentColor.withValues(alpha: 0.1) : colors.cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: isSelected ? colors.accentColor : colors.borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: colors.accentColor.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            else
              BoxShadow(
                color: colors.shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and name
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color:
                    isSelected ? colors.accentColor.withValues(alpha: 0.1) : colors.accentColor.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusM),
                  topRight: Radius.circular(AppDimensions.radiusM),
                ),
              ),
              child: Row(
                children: [
                  IntegrationTypeIcon(
                    integrationType: integrationType.type,
                    iconUrl: integrationType.iconUrl,
                    isTestMode: isTestMode,
                    testDarkMode: testDarkMode,
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          integrationType.displayName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? colors.accentColor : colors.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _getIntegrationCategory(integrationType.type),
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: colors.accentColor,
                    ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Expanded(
                      child: Text(
                        integrationType.description,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingS),
                    // Features/Tags
                    Row(
                      children: [
                        if (integrationType.configParams.any((param) => param.sensitive)) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.warningColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.security,
                                  size: 10,
                                  color: colors.warningColor,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Auth',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: colors.warningColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.successColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Popular',
                            style: TextStyle(
                              fontSize: 9,
                              color: colors.successColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getIntegrationCategory(String type) {
    switch (type) {
      case 'github':
      case 'gitlab':
      case 'bitbucket':
        return 'Version Control';
      case 'slack':
      case 'teams':
      case 'discord':
        return 'Communication';
      case 'google':
      case 'aws':
      case 'azure':
        return 'Cloud Services';
      default:
        return 'Integration';
    }
  }
}

/// Helper widget to show integration type details
class IntegrationTypeDetails extends StatelessWidget {
  final IntegrationType integrationType;
  final bool? isTestMode;
  final bool? testDarkMode;

  const IntegrationTypeDetails({
    required this.integrationType,
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

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IntegrationTypeIcon(
                integrationType: integrationType.type,
                iconUrl: integrationType.iconUrl,
                isTestMode: isTestMode,
                testDarkMode: testDarkMode,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                integrationType.displayName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            integrationType.description,
            style: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'Required Configuration:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          ...integrationType.configParams.where((param) => param.required).map((param) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      param.sensitive ? Icons.security : Icons.settings,
                      size: 12,
                      color: param.sensitive ? colors.warningColor : colors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      param.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textColor,
                      ),
                    ),
                    if (param.sensitive) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: colors.warningColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Sensitive',
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.warningColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
