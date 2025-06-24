import 'package:flutter/material.dart';

/// Base class for empty state components
abstract class BaseEmptyState extends StatefulWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onPressed;
  final bool isTestMode;
  final bool testDarkMode;

  const BaseEmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.onPressed,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);
}

/// Base state class for empty state components
abstract class BaseEmptyStateState<T extends BaseEmptyState> extends State<T> {
  bool isHovering = false;

  /// Get the border color based on hover state and theme
  Color getBorderColor(BuildContext context, bool isHovering, bool isDark) {
    return isHovering 
        ? const Color(0xFF6078F0).withOpacity(0.8)
        : (isDark ? Colors.white.withOpacity(0.2) : Colors.grey.withOpacity(0.3));
  }

  /// Get the icon color based on hover state
  Color getIconColor(bool isHovering) {
    return isHovering
        ? const Color(0xFF6078F0)
        : const Color(0xFF6C757D);
  }

  /// Get the title color based on hover state and theme
  Color getTitleColor(bool isHovering, bool isDark) {
    return isHovering
        ? const Color(0xFF6078F0)
        : (isDark ? Colors.white : const Color(0xFF212529));
  }

  /// Get the message color based on theme
  Color getMessageColor(bool isDark) {
    return isDark ? Colors.white70 : const Color(0xFF6C757D);
  }

  /// Get the border radius for the empty state
  BorderRadius getBorderRadius() {
    return BorderRadius.circular(12);
  }

  /// Get the padding for the empty state
  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0);
  }

  /// Handle mouse enter event
  void onMouseEnter(PointerEvent event) {
    if (mounted) {
      setState(() => isHovering = true);
    }
  }

  /// Handle mouse exit event
  void onMouseExit(PointerEvent event) {
    if (mounted) {
      setState(() => isHovering = false);
    }
  }

  /// Build the empty state content
  Widget buildContent(BuildContext context, bool isDark);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark;
    
    if (widget.isTestMode) {
      isDark = widget.testDarkMode;
    } else {
      isDark = theme.brightness == Brightness.dark;
    }

    return MouseRegion(
      onEnter: onMouseEnter,
      onExit: onMouseExit,
      cursor: widget.onPressed != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: buildContent(context, isDark),
      ),
    );
  }
} 