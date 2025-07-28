import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// A group of checkboxes for selecting integration types
///
/// This molecule provides a structured way to select multiple
/// integrations for MCP configuration with optional grouping
/// and validation feedback.
class IntegrationSelectionGroup extends StatelessWidget {
  const IntegrationSelectionGroup({
    required this.title,
    required this.integrations,
    required this.selectedIntegrations,
    required this.onIntegrationChanged,
    this.description,
    this.maxSelections,
    this.minSelections,
    this.error,
    this.layout = IntegrationSelectionLayout.vertical,
    this.checkboxSize = IntegrationCheckboxSize.medium,
    super.key,
  });

  final String title;
  final String? description;
  final List<IntegrationOption> integrations;
  final Set<String> selectedIntegrations;
  final ValueChanged<String> onIntegrationChanged;

  // Debug the integration selection change
  void _debugOnIntegrationChanged(String integrationId) {
    print('🔧 IntegrationSelectionGroup: Integration selection changed: $integrationId');
    print('🔧 IntegrationSelectionGroup: Current selections: $selectedIntegrations');
    onIntegrationChanged(integrationId);
  }

  final int? maxSelections;
  final int? minSelections;
  final String? error;
  final IntegrationSelectionLayout layout;
  final IntegrationCheckboxSize checkboxSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderSection(
          title: title,
          description: description,
          selectedCount: selectedIntegrations.length,
          maxSelections: maxSelections,
          minSelections: minSelections,
        ),
        const SizedBox(height: 16),
        _IntegrationList(
          integrations: integrations,
          selectedIntegrations: selectedIntegrations,
          onIntegrationChanged: _debugOnIntegrationChanged,
          layout: layout,
          checkboxSize: checkboxSize,
        ),
        if (error != null) ...[const SizedBox(height: 12), _ErrorMessage(error: error!)],
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.title,
    required this.selectedCount,
    this.description,
    this.maxSelections,
    this.minSelections,
  });

  final String title;
  final String? description;
  final int selectedCount;
  final int? maxSelections;
  final int? minSelections;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textColor),
              ),
            ),
            _SelectionCounter(selectedCount: selectedCount, maxSelections: maxSelections, minSelections: minSelections),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: 8),
          Text(description!, style: TextStyle(fontSize: 14, color: colors.textColor.withOpacity(0.7), height: 1.4)),
        ],
      ],
    );
  }
}

class _SelectionCounter extends StatelessWidget {
  const _SelectionCounter({required this.selectedCount, this.maxSelections, this.minSelections});

  final int selectedCount;
  final int? maxSelections;
  final int? minSelections;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final hasLimits = maxSelections != null || minSelections != null;
    if (!hasLimits && selectedCount == 0) return const SizedBox.shrink();

    String text;
    Color textColor = colors.textColor.withOpacity(0.6);

    if (maxSelections != null) {
      text = '$selectedCount/${maxSelections!} selected';
      if (selectedCount == maxSelections) {
        textColor = colors.warningColor;
      }
    } else if (minSelections != null) {
      if (selectedCount < minSelections!) {
        text = '$selectedCount/${minSelections!} required';
        textColor = colors.dangerColor;
      } else {
        text = '$selectedCount selected';
        textColor = colors.successColor;
      }
    } else {
      text = '$selectedCount selected';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: textColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),
      ),
    );
  }
}

class _IntegrationList extends StatelessWidget {
  const _IntegrationList({
    required this.integrations,
    required this.selectedIntegrations,
    required this.onIntegrationChanged,
    required this.layout,
    required this.checkboxSize,
  });

  final List<IntegrationOption> integrations;
  final Set<String> selectedIntegrations;
  final ValueChanged<String> onIntegrationChanged;
  final IntegrationSelectionLayout layout;
  final IntegrationCheckboxSize checkboxSize;

  void _debugOnIntegrationChanged(String integrationId) {
    print('🔧 _IntegrationList: Integration selection changed: $integrationId');
    print('🔧 _IntegrationList: Current selections before: $selectedIntegrations');
    onIntegrationChanged(integrationId);
    // We can't see the updated selections here since they're updated in the parent
    print('🔧 _IntegrationList: Called onIntegrationChanged');
  }

  @override
  Widget build(BuildContext context) {
    switch (layout) {
      case IntegrationSelectionLayout.vertical:
        return _VerticalLayout(
          integrations: integrations,
          selectedIntegrations: selectedIntegrations,
          onIntegrationChanged: _debugOnIntegrationChanged,
          checkboxSize: checkboxSize,
        );
      case IntegrationSelectionLayout.grid:
        return _GridLayout(
          integrations: integrations,
          selectedIntegrations: selectedIntegrations,
          onIntegrationChanged: _debugOnIntegrationChanged,
          checkboxSize: checkboxSize,
        );
      case IntegrationSelectionLayout.horizontal:
        return _HorizontalLayout(
          integrations: integrations,
          selectedIntegrations: selectedIntegrations,
          onIntegrationChanged: _debugOnIntegrationChanged,
          checkboxSize: checkboxSize,
        );
    }
  }
}

class _VerticalLayout extends StatelessWidget {
  const _VerticalLayout({
    required this.integrations,
    required this.selectedIntegrations,
    required this.onIntegrationChanged,
    required this.checkboxSize,
  });

  final List<IntegrationOption> integrations;
  final Set<String> selectedIntegrations;
  final ValueChanged<String> onIntegrationChanged;
  final IntegrationCheckboxSize checkboxSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: integrations.map((integration) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: IntegrationCheckbox(
            label: integration.displayName,
            description: integration.description,
            value: selectedIntegrations.contains(integration.id),
            enabled: integration.enabled,
            size: checkboxSize,
            onChanged: integration.enabled
                ? (value) {
                    print(
                      '🔧 _VerticalLayout: Checkbox changed for ${integration.displayName} (${integration.id}) to $value',
                    );
                    onIntegrationChanged(integration.id);
                  }
                : null,
          ),
        );
      }).toList(),
    );
  }
}

class _GridLayout extends StatelessWidget {
  const _GridLayout({
    required this.integrations,
    required this.selectedIntegrations,
    required this.onIntegrationChanged,
    required this.checkboxSize,
  });

  final List<IntegrationOption> integrations;
  final Set<String> selectedIntegrations;
  final ValueChanged<String> onIntegrationChanged;
  final IntegrationCheckboxSize checkboxSize;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: integrations.length,
      itemBuilder: (context, index) {
        final integration = integrations[index];
        return IntegrationCheckbox(
          label: integration.displayName,
          description: integration.description,
          value: selectedIntegrations.contains(integration.id),
          enabled: integration.enabled,
          size: checkboxSize,
          onChanged: integration.enabled
              ? (value) {
                  print(
                    '🔧 _GridLayout: Checkbox changed for ${integration.displayName} (${integration.id}) to $value',
                  );
                  onIntegrationChanged(integration.id);
                }
              : null,
        );
      },
    );
  }
}

class _HorizontalLayout extends StatelessWidget {
  const _HorizontalLayout({
    required this.integrations,
    required this.selectedIntegrations,
    required this.onIntegrationChanged,
    required this.checkboxSize,
  });

  final List<IntegrationOption> integrations;
  final Set<String> selectedIntegrations;
  final ValueChanged<String> onIntegrationChanged;
  final IntegrationCheckboxSize checkboxSize;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: integrations.map((integration) {
          final isLast = integration == integrations.last;
          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 12),
            child: SizedBox(
              width: 250, // Fixed width for horizontal scrolling
              child: IntegrationCheckbox(
                label: integration.displayName,
                description: integration.description,
                value: selectedIntegrations.contains(integration.id),
                enabled: integration.enabled,
                size: checkboxSize,
                onChanged: integration.enabled
                    ? (value) {
                        print(
                          '🔧 _HorizontalLayout: Checkbox changed for ${integration.displayName} (${integration.id}) to $value',
                        );
                        onIntegrationChanged(integration.id);
                      }
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.dangerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.dangerColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 16, color: colors.dangerColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(fontSize: 13, color: colors.dangerColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

/// Layout options for the integration selection group
enum IntegrationSelectionLayout { vertical, grid, horizontal }

/// Data class for integration options
class IntegrationOption {
  const IntegrationOption({
    required this.id,
    required this.displayName,
    this.description,
    this.enabled = true,
    this.isRequired = false,
  });

  final String id;
  final String displayName;
  final String? description;
  final bool enabled;
  final bool isRequired;
}
