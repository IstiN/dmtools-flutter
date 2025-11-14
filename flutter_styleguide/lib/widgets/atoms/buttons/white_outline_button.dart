import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import 'base_button.dart';

/// White outline button component with transparent background and white text/border
/// Used for secondary actions on colored backgrounds like banners
class WhiteOutlineButton extends BaseButton {
  const WhiteOutlineButton({
    required super.text,
    super.onPressed,
    super.size,
    super.icon,
    super.isFullWidth,
    super.isLoading,
    super.isDisabled,
    super.isTestMode,
    super.testDarkMode,
    super.enableInteractionTracking,
    super.analyticsId,
    super.analyticsScreenName,
    super.analyticsMetadata,
    super.semanticLabel,
    super.testId,
    super.semanticHint,
    super.key,
  });

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
