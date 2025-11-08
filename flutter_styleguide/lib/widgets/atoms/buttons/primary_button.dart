import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'base_button.dart';

/// Primary button component with filled background and white text
/// Used for main call-to-action buttons
class PrimaryButton extends BaseButton {
  const PrimaryButton({
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
  PrimaryButtonState createState() => PrimaryButtonState();
}

class PrimaryButtonState extends BaseButtonState<PrimaryButton> {
  @override
  Color getBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.buttonBg;
  }

  @override
  Color getTextColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.primaryTextOnAccent;
  }

  @override
  Color getHoverBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.buttonHover;
  }

  @override
  Color getHoverTextColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.primaryTextOnAccent;
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
        color: colors.shadowColor,
        blurRadius: 12,
        offset: const Offset(0, 4),
      )
    ];
  }
}
