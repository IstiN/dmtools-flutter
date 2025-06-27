import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import 'base_button.dart';

/// Outline button component with transparent background and border
/// Used for tertiary actions or in places where visual weight should be reduced
class OutlineButton extends BaseButton {
  const OutlineButton({
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    bool isFullWidth = false,
    bool isLoading = false,
    bool isDisabled = false,
    bool isTestMode = false,
    bool testDarkMode = false,
    Key? key,
  }) : super(
          key: key,
          text: text,
          onPressed: onPressed,
          size: size,
          icon: icon,
          isFullWidth: isFullWidth,
          isLoading: isLoading,
          isDisabled: isDisabled,
          isTestMode: isTestMode,
          testDarkMode: testDarkMode,
        );

  @override
  OutlineButtonState createState() => OutlineButtonState();
}

class OutlineButtonState extends BaseButtonState<OutlineButton> {
  @override
  Color getBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return Colors.transparent;
  }

  @override
  Color getTextColor(ThemeColorSet colors, bool isDarkMode) {
    return _getTextColor(isDarkMode, colors);
  }

  @override
  Color getHoverBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return _getHoverColor(isDarkMode, colors);
  }

  @override
  Color getHoverTextColor(ThemeColorSet colors, bool isDarkMode) {
    return isDarkMode ? Colors.white : colors.accentColor;
  }

  @override
  BorderSide getBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return BorderSide(
        color: isDarkMode ? Colors.white.withValues(alpha: 0.8) : colors.accentColor,
        width: AppDimensions.borderWidthRegular);
  }

  @override
  BorderSide getHoverBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return getBorderSide(colors, isDarkMode);
  }

  Color _getTextColor(bool isDarkMode, ThemeColorSet colors) {
    return isDarkMode ? Colors.white.withValues(alpha: 0.9) : colors.accentColor;
  }

  Color _getHoverColor(bool isDarkMode, ThemeColorSet colors) {
    return isDarkMode ? Colors.white.withValues(alpha: 0.15) : colors.hoverBg;
  }
}
