import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import 'base_button.dart';

/// Secondary button component with transparent background and accent text/border
/// Used for secondary actions alongside primary buttons
class SecondaryButton extends BaseButton {
  const SecondaryButton({
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
  SecondaryButtonState createState() => SecondaryButtonState();
}

class SecondaryButtonState extends BaseButtonState<SecondaryButton> {
  @override
  Color getBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return Colors.transparent;
  }

  @override
  Color getTextColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.accentColor;
  }

  @override
  Color getHoverBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.hoverBg;
  }

  @override
  Color getHoverTextColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.accentColor;
  }

  @override
  BorderSide getBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return BorderSide(color: colors.accentColor, width: AppDimensions.borderWidthRegular);
  }

  @override
  BorderSide getHoverBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return BorderSide(color: colors.accentColor, width: AppDimensions.borderWidthRegular);
  }
}
