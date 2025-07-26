import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// A required integration selection component that matches AI Job Configuration style
/// but supports multi-select functionality
class RequiredIntegrationSelection extends StatelessWidget {
  const RequiredIntegrationSelection({
    required this.title,
    required this.integrations,
    required this.selectedIntegrations,
    required this.onIntegrationChanged,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<IntegrationOption> integrations;
  final Set<String> selectedIntegrations;
  final ValueChanged<String> onIntegrationChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderSection(title: title, subtitle: subtitle, colors: colors),
        const SizedBox(height: 16),
        ...integrations.map(
          (integration) => _IntegrationItem(
            integration: integration,
            isSelected: selectedIntegrations.contains(integration.id),
            onChanged: () => onIntegrationChanged(integration.id),
            colors: colors,
          ),
        ),
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.title, required this.subtitle, required this.colors});

  final String title;
  final String? subtitle;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: TextStyle(fontSize: 14, color: colors.textColor.withValues(alpha: 0.7))),
        ],
      ],
    );
  }
}

class _IntegrationItem extends StatelessWidget {
  const _IntegrationItem({
    required this.integration,
    required this.isSelected,
    required this.onChanged,
    required this.colors,
  });

  final IntegrationOption integration;
  final bool isSelected;
  final VoidCallback onChanged;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                integration.displayName,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textColor),
              ),
              const SizedBox(width: 8),
              if (integration.isRequired)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.warningColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Required',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: colors.warningColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: isSelected,
            onChanged: (_) => onChanged(),
            title: Text(integration.displayName, style: TextStyle(fontSize: 14, color: colors.textColor)),
            subtitle: integration.description != null
                ? Text(
                    integration.description!,
                    style: TextStyle(fontSize: 12, color: colors.textColor.withValues(alpha: 0.7)),
                  )
                : null,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
            activeColor: colors.accentColor,
            checkColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
