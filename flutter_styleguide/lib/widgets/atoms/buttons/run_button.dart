import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import 'base_button.dart';

/// Run button component with green background
/// Used specifically for run/execute actions
class RunButton extends BaseButton {
  const RunButton({
    required super.text,
    super.onPressed,
    super.size,
    super.icon,
    super.isFullWidth,
    super.isLoading,
    super.isDisabled,
    super.isTestMode,
    super.testDarkMode,
    super.key,
  });

  @override
  RunButtonState createState() => RunButtonState();
}

class RunButtonState extends BaseButtonState<RunButton> {
  @override
  Color getBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.successColor;
  }

  @override
  Color getTextColor(ThemeColorSet colors, bool isDarkMode) {
    return Colors.white;
  }

  @override
  Color getHoverBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    // Use a slightly darker shade of the success color for hover
    final successColor = colors.successColor;
    return isDarkMode
        ? HSLColor.fromColor(successColor).withLightness(HSLColor.fromColor(successColor).lightness * 0.85).toColor()
        : HSLColor.fromColor(successColor).withLightness(HSLColor.fromColor(successColor).lightness * 0.8).toColor();
  }

  @override
  Color getHoverTextColor(ThemeColorSet colors, bool isDarkMode) {
    return Colors.white;
  }

  @override
  BorderSide getBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return BorderSide.none;
  }

  @override
  BorderSide getHoverBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return BorderSide.none;
  }

  @override
  List<BoxShadow> getHoverBoxShadows(ThemeColorSet colors, bool isDarkMode) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 12,
        offset: const Offset(0, 4),
      )
    ];
  }

  @override
  BorderRadius getBorderRadius() {
    return BorderRadius.circular(AppDimensions.radiusS);
  }
}
