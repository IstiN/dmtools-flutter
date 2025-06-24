import 'package:flutter/material.dart';
import 'base_empty_state.dart';

/// Empty state with solid border
class SolidEmptyState extends BaseEmptyState {
  final Color? backgroundColor;
  final double? elevation;

  const SolidEmptyState({
    super.key,
    required super.icon,
    required super.title,
    required super.message,
    super.onPressed,
    super.isTestMode = false,
    super.testDarkMode = false,
    this.backgroundColor,
    this.elevation,
  });

  @override
  State<SolidEmptyState> createState() => _SolidEmptyStateState();
}

class _SolidEmptyStateState extends BaseEmptyStateState<SolidEmptyState> {
  @override
  Widget buildContent(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final borderColor = getBorderColor(context, isHovering, isDark);
    final iconColor = getIconColor(isHovering);
    final titleColor = getTitleColor(isHovering, isDark);
    final messageColor = getMessageColor(isDark);
    final bgColor = widget.backgroundColor ?? (isDark ? Colors.grey[850] : Colors.grey[50]);
    final elevation = widget.elevation ?? 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: getBorderRadius(),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: elevation > 0 
            ? [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: elevation,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: getPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                widget.icon,
                size: 40,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: titleColor,
                fontSize: 24,
              ),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              style: TextStyle(
                color: messageColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 