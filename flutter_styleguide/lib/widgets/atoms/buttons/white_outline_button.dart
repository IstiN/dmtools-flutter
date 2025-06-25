import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import 'base_button.dart';

/// White outline button component with transparent background and white text/border
/// Used for secondary actions on colored backgrounds like banners
class WhiteOutlineButton extends BaseButton {
  const WhiteOutlineButton({
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
  WhiteOutlineButtonState createState() => WhiteOutlineButtonState();
}

class WhiteOutlineButtonState extends BaseButtonState<WhiteOutlineButton> {
  @override
  Color getBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return Colors.transparent;
  }

  @override
  Color getTextColor(ThemeColorSet colors, bool isDarkMode) {
    return Colors.white;
  }

  @override
  Color getHoverBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return Colors.white.withValues(alpha: 0.15);
  }

  @override
  Color getHoverTextColor(ThemeColorSet colors, bool isDarkMode) {
    return Colors.white;
  }

  @override
  BorderSide getBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return const BorderSide(color: Colors.white, width: AppDimensions.borderWidthRegular);
  }

  @override
  BorderSide getHoverBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return const BorderSide(color: Colors.white, width: AppDimensions.borderWidthRegular);
  }
} 