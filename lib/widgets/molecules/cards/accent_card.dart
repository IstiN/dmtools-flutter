import 'package:flutter/material.dart';
import 'base_card.dart';
import '../../../theme/app_dimensions.dart';

/// Accent card implementation with a colored header
class AccentCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;
  final Color? headerColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? headerPadding;
  final bool hasShadow;
  final bool hasBorder;
  final Widget? trailing;

  const AccentCard({
    Key? key,
    required this.title,
    required this.child,
    this.icon,
    this.headerColor,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.contentPadding,
    this.headerPadding,
    this.hasShadow = true,
    this.hasBorder = true,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerBgColor = headerColor ?? theme.colorScheme.primary.withOpacity(0.1);
    final defaultHeaderPadding = const EdgeInsets.all(16);
    final defaultContentPadding = AppDimensions.cardPaddingM;
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: hasBorder 
            ? Border.all(
                color: borderColor ?? theme.dividerColor,
                width: 1,
              )
            : null,
        boxShadow: hasShadow 
            ? [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: elevation ?? 2.0,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with accent color
          Container(
            padding: headerPadding ?? defaultHeaderPadding,
            decoration: BoxDecoration(
              color: headerBgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailing != null) ...[
                  const Spacer(),
                  trailing!,
                ],
              ],
            ),
          ),
          // Content area
          Padding(
            padding: contentPadding ?? defaultContentPadding,
            child: child,
          ),
        ],
      ),
    );
  }
} 