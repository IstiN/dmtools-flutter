import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

/// Text button component with no background or border
/// Used for minimal actions like "Cancel" or in tight spaces
class AppTextButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final IconData? icon;
  final bool isFullWidth;
  final bool isLoading;
  final bool isDisabled;
  final bool isTestMode;
  final bool testDarkMode;

  const AppTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
    this.isFullWidth = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  @override
  AppTextButtonState createState() => AppTextButtonState();
}

class AppTextButtonState extends State<AppTextButton> {
  bool _isHovering = false;
  bool _isPressed = false;

  Color getBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return Colors.transparent;
  }

  Color getTextColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.accentColor;
  }

  Color getHoverBackgroundColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.hoverBg;
  }

  Color getHoverTextColor(ThemeColorSet colors, bool isDarkMode) {
    return colors.accentColor;
  }

  BorderSide getBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return BorderSide.none;
  }

  BorderSide getHoverBorderSide(ThemeColorSet colors, bool isDarkMode) {
    return BorderSide.none;
  }

  List<BoxShadow> getBoxShadows(ThemeColorSet colors, bool isDarkMode) {
    return [];
  }

  List<BoxShadow> getHoverBoxShadows(ThemeColorSet colors, bool isDarkMode) {
    return [];
  }

  BorderRadius getBorderRadius() {
    return BorderRadius.circular(AppDimensions.radiusM);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isTestMode
        ? widget.testDarkMode
        : Provider.of<ThemeProvider>(context).isDarkMode;
    final ThemeColorSet colors = isDarkMode ? AppColors.dark : AppColors.light;

    // Get dimensions from AppDimensions
    final paddings = AppDimensions.buttonPadding;
    final fontSizes = AppDimensions.buttonFontSize;
    final iconSizes = AppDimensions.buttonIconSize;
    
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
        width: fontSizes[widget.size]!,
        height: fontSizes[widget.size]!,
        child: CircularProgressIndicator(
          strokeWidth: AppDimensions.borderWidthThin,
          valueColor: AlwaysStoppedAnimation<Color>(isHovering ? hoverTextColor : textColor),
        ),
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: iconSizes[widget.size], color: isHovering ? hoverTextColor : textColor),
            SizedBox(width: AppDimensions.spacingXs),
          ],
          Text(
            widget.text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: fontSizes[widget.size],
              fontWeight: FontWeight.w500,
              color: isHovering ? hoverTextColor : textColor,
            ),
          ),
        ],
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: effectiveOnPressed,
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
                width: widget.isFullWidth ? double.infinity : null,
                padding: paddings[widget.size],
                decoration: BoxDecoration(
                  color: Color.lerp(bgColor, hoverBgColor, value),
                  borderRadius: getBorderRadius(),
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