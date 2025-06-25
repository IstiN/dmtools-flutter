import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import 'base_button.dart';

/// Primary button component with filled background and white text
/// Used for main call-to-action buttons
class PrimaryButton extends BaseButton {
  const PrimaryButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    bool isFullWidth = false,
    bool isLoading = false,
    bool isDisabled = false,
    bool isTestMode = false,
    bool testDarkMode = false,
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
  PrimaryButtonState createState() => PrimaryButtonState();
}

class PrimaryButtonState extends BaseButtonState<PrimaryButton> {
  @override
  Color getBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.buttonBg;
  }

  @override
  Color getTextColor(ThemeColorSet colors, bool isDarkMode) {
    return Colors.white;
  }

  @override
  Color getHoverBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.buttonHover;
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
        color: const Color(0xFF000000).withValues(alpha: 0.15),
        blurRadius: 12,
        offset: const Offset(0, 4),
      )
    ];
  }
} 