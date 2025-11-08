import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// A custom checkbox component for integration selection
///
/// This atom provides a styled checkbox with optional description
/// and custom visual states for MCP integration selection forms.
class IntegrationCheckbox extends StatelessWidget {
  const IntegrationCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
    this.enabled = true,
    this.size = IntegrationCheckboxSize.medium,
    super.key,
  });

  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final IntegrationCheckboxSize size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimensions = _getDimensions();
    final isInteractive = enabled && onChanged != null;

    return GestureDetector(
      onTap: isInteractive
          ? () {
              debugPrint('🔧 IntegrationCheckbox: Tapped on "$label", changing from $value to ${!value}');
              onChanged!(!value);
            }
          : null,
      child: Container(
        padding: EdgeInsets.all(dimensions.containerPadding),
        decoration: BoxDecoration(
          color: _getBackgroundColor(colors),
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
          border: Border.all(color: _getBorderColor(colors), width: dimensions.borderWidth),
        ),
        child: Row(
          children: [
            _CustomCheckbox(value: value, size: dimensions.checkboxSize, colors: colors, enabled: isInteractive),
            SizedBox(width: dimensions.spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: dimensions.labelFontSize,
                      fontWeight: FontWeight.w500,
                      color: _getTextColor(colors),
                    ),
                  ),
                  if (description != null) ...[
                    SizedBox(height: dimensions.descriptionSpacing),
                    Text(
                      description!,
                      style: TextStyle(fontSize: dimensions.descriptionFontSize, color: _getDescriptionColor(colors)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(ThemeColorSet colors) {
    if (!enabled) return colors.cardBg.withValues(alpha: 0.5);
    if (value) return colors.accentColor.withValues(alpha: 0.1);
    return colors.cardBg;
  }

  Color _getBorderColor(ThemeColorSet colors) {
    if (!enabled) return colors.borderColor.withValues(alpha: 0.5);
    if (value) return colors.accentColor;
    return colors.borderColor;
  }

  Color _getTextColor(ThemeColorSet colors) {
    if (!enabled) return colors.textColor.withValues(alpha: 0.5);
    return colors.textColor;
  }

  Color _getDescriptionColor(ThemeColorSet colors) {
    if (!enabled) return colors.textColor.withValues(alpha: 0.3);
    return colors.textColor.withValues(alpha: 0.7);
  }

  _CheckboxDimensions _getDimensions() {
    switch (size) {
      case IntegrationCheckboxSize.small:
        return const _CheckboxDimensions(
          containerPadding: 12,
          borderRadius: 8,
          borderWidth: 1,
          spacing: 8,
          checkboxSize: 16,
          labelFontSize: 13,
          descriptionFontSize: 11,
          descriptionSpacing: 4,
        );
      case IntegrationCheckboxSize.medium:
        return const _CheckboxDimensions(
          containerPadding: 16,
          borderRadius: 12,
          borderWidth: 1.5,
          spacing: 12,
          checkboxSize: 20,
          labelFontSize: 15,
          descriptionFontSize: 13,
          descriptionSpacing: 6,
        );
      case IntegrationCheckboxSize.large:
        return const _CheckboxDimensions(
          containerPadding: 20,
          borderRadius: 16,
          borderWidth: 2,
          spacing: 16,
          checkboxSize: 24,
          labelFontSize: 17,
          descriptionFontSize: 15,
          descriptionSpacing: 8,
        );
    }
  }
}

/// Custom checkbox widget with enhanced styling
class _CustomCheckbox extends StatelessWidget {
  const _CustomCheckbox({required this.value, required this.size, required this.colors, required this.enabled});

  final bool value;
  final double size;
  final ThemeColorSet colors;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: value ? (enabled ? colors.accentColor : colors.accentColor.withValues(alpha: 0.5)) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: value
              ? (enabled ? colors.accentColor : colors.accentColor.withValues(alpha: 0.5))
              : (enabled ? colors.borderColor : colors.borderColor.withValues(alpha: 0.5)),
          width: 2,
        ),
      ),
      child: value
          ? Icon(Icons.check, size: size * 0.7, color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.5))
          : null,
    );
  }
}

/// Size variants for the integration checkbox
enum IntegrationCheckboxSize { small, medium, large }

class _CheckboxDimensions {
  const _CheckboxDimensions({
    required this.containerPadding,
    required this.borderRadius,
    required this.borderWidth,
    required this.spacing,
    required this.checkboxSize,
    required this.labelFontSize,
    required this.descriptionFontSize,
    required this.descriptionSpacing,
  });

  final double containerPadding;
  final double borderRadius;
  final double borderWidth;
  final double spacing;
  final double checkboxSize;
  final double labelFontSize;
  final double descriptionFontSize;
  final double descriptionSpacing;
}
