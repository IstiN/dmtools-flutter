import 'package:flutter/material.dart';
import 'dart:ui';
import 'base_empty_state.dart';

/// Empty state with dashed border
class DashedEmptyState extends BaseEmptyState {
  const DashedEmptyState({
    super.key,
    required super.icon,
    required super.title,
    required super.message,
    super.onPressed,
    super.isTestMode = false,
    super.testDarkMode = false,
  });

  @override
  State<DashedEmptyState> createState() => _DashedEmptyStateState();
}

class _DashedEmptyStateState extends BaseEmptyStateState<DashedEmptyState> {
  @override
  Widget buildContent(BuildContext context, bool isDark) {
    final borderColor = getBorderColor(context, isHovering, isDark);
    final iconColor = getIconColor(isHovering);
    final titleColor = getTitleColor(isHovering, isDark);
    final messageColor = getMessageColor(isDark);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: getBorderRadius(),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(borderColor: borderColor),
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
      ),
    );
  }
}

/// Custom painter for drawing a dashed border
class DashedBorderPainter extends CustomPainter {
  final Color borderColor;
  
  DashedBorderPainter({
    required this.borderColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(12),
      ));
    
    final Path dashPath = Path();
    
    const double dashWidth = 6.0;
    const double dashSpace = 4.0;
    
    double distance = 0.0;
    
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
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