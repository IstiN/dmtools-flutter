import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Model for AI integration data
class AiIntegration {
  final String id;
  final String type;
  final String displayName;
  final String? iconUrl;
  final bool isActive;

  const AiIntegration({
    required this.id,
    required this.type,
    required this.displayName,
    this.iconUrl,
    this.isActive = true,
  });
}

/// Compact dropdown selector for AI integrations in chat interface
/// Displays current AI provider with icon and allows switching between available integrations
class AiIntegrationSelector extends StatelessWidget {
  final List<AiIntegration> integrations;
  final AiIntegration? selectedIntegration;
  final ValueChanged<AiIntegration?>? onIntegrationChanged;
  final bool isDisabled;
  final bool? isTestMode;
  final bool? testDarkMode;

  const AiIntegrationSelector({
    required this.integrations,
    super.key,
    this.selectedIntegration,
    this.onIntegrationChanged,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = isTestMode == true
        ? (testDarkMode == true ? AppColors.dark : AppColors.light)
        : context.colorsListening;

    if (integrations.isEmpty) {
      return _buildEmptyState(colors);
    }

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.inputBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AiIntegration>(
          value: selectedIntegration,
          onChanged: isDisabled ? null : onIntegrationChanged,
          items: integrations.map((integration) {
            return DropdownMenuItem<AiIntegration>(value: integration, child: _buildDropdownItem(integration, colors));
          }).toList(),
          icon: Icon(Icons.keyboard_arrow_down, color: colors.textMuted, size: 16),
          isDense: true,
          style: TextStyle(color: colors.textColor, fontSize: 13),
          dropdownColor: colors.cardBg,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(AiIntegration integration, ThemeColorSet colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IntegrationTypeIcon(
          integrationType: integration.type,
          iconUrl: integration.iconUrl,
          size: 16,
          isTestMode: isTestMode,
          testDarkMode: testDarkMode,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            integration.displayName,
            style: TextStyle(color: colors.textColor, fontSize: 13, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (!integration.isActive) ...[
          const SizedBox(width: 4),
          Icon(Icons.warning_amber_rounded, color: colors.warningColor, size: 12),
        ],
      ],
    );
  }

  Widget _buildEmptyState(ThemeColorSet colors) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: colors.inputBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, color: colors.warningColor, size: 16),
          const SizedBox(width: 6),
          Text(
            'No AI',
            style: TextStyle(color: colors.textMuted, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
