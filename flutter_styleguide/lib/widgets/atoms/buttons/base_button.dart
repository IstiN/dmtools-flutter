import 'package:dmtools_styleguide/core/services/user_interaction_tracker.dart';
import 'package:dmtools_styleguide/theme/app_colors.dart';
import 'package:dmtools_styleguide/theme/app_dimensions.dart';
import 'package:dmtools_styleguide/theme/app_theme.dart';
import 'package:dmtools_styleguide/utils/accessibility_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Base class for all button components
/// This provides common functionality and properties for all button variants
abstract class BaseButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final IconData? icon;
  final bool isFullWidth;
  final bool isLoading;
  final bool isDisabled;
  final bool isTestMode;
  final bool testDarkMode;
  final bool enableInteractionTracking;
  final String? analyticsId;
  final String? analyticsScreenName;
  final Map<String, dynamic>? analyticsMetadata;
  
  // Accessibility properties
  final String? semanticLabel;
  final String? testId;
  final String? semanticHint;

  const BaseButton({
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.icon,
    this.isFullWidth = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
    this.enableInteractionTracking = true,
    this.analyticsId,
    this.analyticsScreenName,
    this.analyticsMetadata,
    this.semanticLabel,
    this.testId,
    this.semanticHint,
    super.key,
  });
}

/// Base state class for all button components
abstract class BaseButtonState<T extends BaseButton> extends State<T> {
  bool _isHovering = false;
  bool _isPressed = false;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// Get the background color for the button
  Color getBackgroundColor(ThemeColorSet colors, bool isDarkMode);

  /// Get the text color for the button
  Color getTextColor(ThemeColorSet colors, bool isDarkMode);

  /// Get the hover background color for the button
  Color getHoverBackgroundColor(ThemeColorSet colors, bool isDarkMode);

  /// Get the hover text color for the button
  Color getHoverTextColor(ThemeColorSet colors, bool isDarkMode);

  /// Get the border side for the button
  BorderSide getBorderSide(ThemeColorSet colors, bool isDarkMode);

  /// Get the hover border side for the button
  BorderSide getHoverBorderSide(ThemeColorSet colors, bool isDarkMode);

  /// Get the box shadows for the button
  List<BoxShadow> getBoxShadows(ThemeColorSet colors, bool isDarkMode) {
    return [];
  }

  /// Get the hover box shadows for the button
  List<BoxShadow> getHoverBoxShadows(ThemeColorSet colors, bool isDarkMode) {
    return [];
  }

  /// Get the border radius for the button
  BorderRadius getBorderRadius() {
    return BorderRadius.circular(AppDimensions.radiusM);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;

    if (widget.isTestMode) {
      isDarkMode = widget.testDarkMode;
    } else {
      // Use optimized theme extension instead of direct Provider access
      isDarkMode = context.isDarkMode;
    }

    // Use optimized theme extension for colors
    final ThemeColorSet colors = context.colors;

    // Get dimensions from AppDimensions
    const paddings = AppDimensions.buttonPadding;
    const fontSizes = AppDimensions.buttonFontSize;
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
            const SizedBox(width: AppDimensions.spacingXs),
          ],
          Text(
            widget.text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: fontSizes[widget.size],
                  fontWeight: FontWeight.w500,
                  color: isHovering ? hoverTextColor : textColor,
                  height: 1.2, // Add line height for better text centering
                ),
            textAlign: TextAlign.center, // Ensure text is centered
          ),
        ],
      );
    }

    // Generate test ID and semantic label
    final generatedTestId = widget.testId ?? generateTestId('button', {'action': widget.text});
    final generatedLabel = widget.semanticLabel ?? generateSemanticLabel('button', widget.text);
    final generatedHint = widget.semanticHint;
    
    // Determine state for semantics
    final semanticHint = widget.isLoading 
        ? 'Loading' 
        : generatedHint;

    final trackedOnPressed = effectiveOnPressed == null
        ? null
        : () {
            if (widget.enableInteractionTracking) {
              final metadata = <String, dynamic>{
                'button_variant': widget.runtimeType.toString(),
                'button_size': widget.size.name,
                if (widget.analyticsMetadata != null) ...widget.analyticsMetadata!,
              };
              UserInteractionTracker.instance.trackButtonInteraction(
                context: context,
                label: widget.text,
                size: widget.size,
                analyticsId: widget.analyticsId,
                screenNameOverride: widget.analyticsScreenName,
                metadata: metadata,
                testId: generatedTestId,
                isDisabled: widget.isDisabled,
                isLoading: widget.isLoading,
              );
            }
            effectiveOnPressed();
          };

    return Semantics(
      label: generatedLabel,
      hint: semanticHint,
      button: true,
      enabled: trackedOnPressed != null && !widget.isLoading,
      focusable: true,
      onTap: trackedOnPressed,
      child: Focus(
        focusNode: _focusNode,
        onFocusChange: (focused) {
          setState(() => _isFocused = focused);
        },
        onKeyEvent: (node, event) {
          if (trackedOnPressed != null && 
              (event.logicalKey == LogicalKeyboardKey.enter || 
               event.logicalKey == LogicalKeyboardKey.space) &&
              event is KeyDownEvent) {
            trackedOnPressed();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          cursor: trackedOnPressed != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: trackedOnPressed,
            child: Container(
              key: ValueKey(generatedTestId),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: isHovering ? 1.0 : 0.0),
                duration: AppDimensions.animationDurationFast,
                builder: (context, value, child) {
                  final currentTransform = isCurrentlyPressed
                      ? Matrix4.translationValues(0, -1, 0) // Less of a lift when pressed
                      : Matrix4.translationValues(0, -2 * value, 0); // Hover lift

                  // Build button with focus indicator using box shadow outline
                  // This prevents size changes that cause "jumping"
                  final effectiveBorder = Border.fromBorderSide(BorderSide.lerp(borderSide, hoverBorderSide, value));
                  
                  // Add focus outline using box shadow (doesn't change button size)
                  final baseShadows = BoxShadow.lerpList(shadows, hoverShadows, value) ?? [];
                  final effectiveShadows = _isFocused && !widget.isDisabled
                      ? [
                          ...baseShadows,
                          BoxShadow(
                            color: colors.accentColor.withValues(alpha: 0.8),
                            spreadRadius: 2.0, // Creates outline effect
                          ),
                        ]
                      : baseShadows;

                  return Transform(
                    transform: currentTransform,
                    child: Container(
                      width: widget.isFullWidth ? double.infinity : null,
                      padding: paddings[widget.size],
                      decoration: BoxDecoration(
                        color: Color.lerp(bgColor, hoverBgColor, value),
                        borderRadius: getBorderRadius(),
                        border: effectiveBorder,
                        boxShadow: effectiveShadows,
                      ),
                      alignment: Alignment.center,
                      child: child,
                    ),
                  );
                },
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
