import 'package:dmtools_styleguide/core/services/user_interaction_tracker.dart';
import 'package:dmtools_styleguide/theme/app_colors.dart';
import 'package:dmtools_styleguide/theme/app_dimensions.dart';
import 'package:dmtools_styleguide/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Icon button component with square shape and icon
/// Used for compact actions like settings, delete, etc.
class AppIconButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final bool isTestMode;
  final bool testDarkMode;
  final bool enableInteractionTracking;
  final String? analyticsId;
  final String? analyticsScreenName;
  final Map<String, dynamic>? analyticsMetadata;

  const AppIconButton({
    required this.text,
    required this.icon,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
    this.enableInteractionTracking = true,
    this.analyticsId,
    this.analyticsScreenName,
    this.analyticsMetadata,
    super.key,
  });

  @override
  AppIconButtonState createState() => AppIconButtonState();
}

class AppIconButtonState extends State<AppIconButton> {
  bool _isHovering = false;
  bool _isPressed = false;

  Color getBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return Colors.transparent;
  }

  Color getTextColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.textSecondary;
  }

  Color getHoverBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.hoverBg;
  }

  Color getHoverTextColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.accentColor;
  }

  BorderSide getBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return BorderSide(color: colors.borderColor);
  }

  BorderSide getHoverBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return getBorderSide(colors, isDarkMode);
  }

  List<BoxShadow> getBoxShadows(ThemeColorSet colors, bool isDarkMode) {
    return [];
  }

  List<BoxShadow> getHoverBoxShadows(ThemeColorSet colors, bool isDarkMode) {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isTestMode ? widget.testDarkMode : Provider.of<ThemeProvider>(context).isDarkMode;
    final ThemeColorSet colors = isDarkMode ? AppColors.dark : AppColors.light;

    // Get dimensions from AppDimensions
    const iconSizes = AppDimensions.buttonIconSize;

    final effectiveOnPressed = widget.isDisabled || widget.isLoading ? null : widget.onPressed;

    // Get style properties
    Color bgColor;
    Color textColor;
    Color hoverBgColor;
    Color hoverTextColor;
    BorderSide borderSide;
    BorderSide hoverBorderSide;
    List<BoxShadow> shadows;
    List<BoxShadow> hoverShadows;

    // If disabled, use disabled styles
    if (widget.isDisabled) {
      bgColor = isDarkMode ? colors.disabledDarkBg : colors.disabledLightBg;
      textColor = isDarkMode ? colors.disabledDarkText : colors.disabledLightText;
      borderSide = BorderSide.none;
      hoverBgColor = bgColor;
      hoverTextColor = textColor;
      hoverBorderSide = BorderSide.none;
      shadows = [];
      hoverShadows = [];
    } else {
      // Use the variant-specific styles
      bgColor = getBackgroundColor(colors, isDarkMode);
      textColor = getTextColor(colors, isDarkMode);
      hoverBgColor = getHoverBackgroundColor(colors, isDarkMode);
      hoverTextColor = getHoverTextColor(colors, isDarkMode);
      borderSide = getBorderSide(colors, isDarkMode);
      hoverBorderSide = getHoverBorderSide(colors, isDarkMode);
      shadows = getBoxShadows(colors, isDarkMode);
      hoverShadows = getHoverBoxShadows(colors, isDarkMode);
    }

    final isHovering = _isHovering && !widget.isDisabled;
    final isCurrentlyPressed = _isPressed && !widget.isDisabled;

    // Build button content
    Widget content;
    if (widget.isLoading) {
      content = SizedBox(
        width: iconSizes[widget.size]!,
        height: iconSizes[widget.size]!,
        child: CircularProgressIndicator(
          strokeWidth: AppDimensions.borderWidthThin,
          valueColor: AlwaysStoppedAnimation<Color>(isHovering ? hoverTextColor : textColor),
        ),
      );
    } else {
      content = Icon(widget.icon, size: iconSizes[widget.size], color: isHovering ? hoverTextColor : textColor);
    }

    final trackedOnPressed = effectiveOnPressed == null
        ? null
        : () {
            if (widget.enableInteractionTracking) {
              final metadata = <String, dynamic>{
                'button_variant': widget.runtimeType.toString(),
                'button_size': widget.size.name,
                'icon_code_point': widget.icon.codePoint,
                if (widget.analyticsMetadata != null) ...widget.analyticsMetadata!,
              };
              UserInteractionTracker.instance.trackButtonInteraction(
                context: context,
                label: widget.text,
                size: widget.size,
                analyticsId: widget.analyticsId,
                screenNameOverride: widget.analyticsScreenName,
                metadata: metadata,
                isDisabled: widget.isDisabled,
                isLoading: widget.isLoading,
              );
            }
            effectiveOnPressed();
          };

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: trackedOnPressed != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: trackedOnPressed,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: isHovering ? 1.0 : 0.0),
          duration: AppDimensions.animationDurationFast,
          builder: (context, value, child) {
            final currentTransform = isCurrentlyPressed
                ? Matrix4.translationValues(0, -1, 0) // Less of a lift when pressed
                : Matrix4.translationValues(0, -2 * value, 0); // Hover lift

            return Transform(
              transform: currentTransform,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color.lerp(bgColor, hoverBgColor, value),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.fromBorderSide(BorderSide.lerp(borderSide, hoverBorderSide, value)),
                  boxShadow: BoxShadow.lerpList(shadows, hoverShadows, value),
                ),
                alignment: Alignment.center,
                child: child,
              ),
            );
          },
          child: content,
        ),
      ),
    );
  }
}
