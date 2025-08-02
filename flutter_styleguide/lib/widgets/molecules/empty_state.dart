import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_dimensions.dart';
import 'dart:ui';

class EmptyState extends StatefulWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onPressed;

  const EmptyState({required this.icon, required this.title, required this.message, this.onPressed, super.key});

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = context.isDarkMode;

    // Colors based on the web version
    final borderColor = _isHovering
        ? colors.accentColor.withValues(alpha: 0.8)
        : (isDark ? colors.whiteColor.withValues(alpha: 0.2) : colors.textMuted.withValues(alpha: 0.3));

    final iconColor = _isHovering ? colors.accentColor : colors.textMuted;

    final titleColor = _isHovering ? colors.accentColor : colors.textColor;

    final messageColor = isDark ? colors.textSecondary : colors.textMuted;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: widget.onPressed != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: AppDimensions.animationDurationFast,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: CustomPaint(
            painter: DashedBorderPainter(borderColor: borderColor),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingXs),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: AppDimensions.animationDurationFast,
                    child: Icon(widget.icon, size: AppDimensions.iconSizeL, color: iconColor),
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  AnimatedDefaultTextStyle(
                    duration: AppDimensions.animationDurationFast,
                    style: TextStyle(fontWeight: FontWeight.w600, color: titleColor, fontSize: 16),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXxs),
                  Text(
                    widget.message,
                    style: TextStyle(color: messageColor, fontSize: 13),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color borderColor;

  DashedBorderPainter({required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = AppDimensions.borderWidthThick
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(AppDimensions.radiusL),
        ),
      );

    final Path dashPath = Path();

    const double dashWidth = AppDimensions.spacingXs * 0.75; // 6.0
    const double dashSpace = AppDimensions.spacingXxs; // 4.0

    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(pathMetric.extractPath(distance, distance + dashWidth), Offset.zero);
        distance += dashWidth;
        distance += dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor;
  }
}
