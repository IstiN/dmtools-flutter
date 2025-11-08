import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'base_button.dart';

/// Base style button component with light background and border
/// Used for basic actions or as a foundation for custom buttons
class BaseStyleButton extends BaseButton {
  const BaseStyleButton({
    required super.text,
    super.onPressed,
    super.size,
    super.icon,
    super.isFullWidth,
    super.isLoading,
    super.isDisabled,
    super.isTestMode,
    super.testDarkMode,
    super.semanticLabel,
    super.testId,
    super.semanticHint,
    super.key,
  });

  @override
  BaseStyleButtonState createState() => BaseStyleButtonState();
}

class BaseStyleButtonState extends BaseButtonState<BaseStyleButton> {
  @override
  Color getBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.baseButtonBg;
  }

  @override
  Color getTextColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.textSecondary;
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
    return BorderSide(color: colors.borderColor);
  }

  @override
  BorderSide getHoverBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return BorderSide(color: colors.accentColor);
  }
}
