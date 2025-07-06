import 'dart:math';

import 'package:dmtools_styleguide/theme/app_theme.dart';
import 'package:flutter/material.dart';

// V8: Interwoven Solid Strands (Based on user reference)
class DnaLogo extends StatelessWidget {
  const DnaLogo({
    super.key,
    this.size = 140.0,
    this.color1,
    this.color2,
  });

  final double size;
  final Color? color1;
  final Color? color2;
  static const double aspectRatio = 0.25;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return CustomPaint(
      size: Size(size, size * aspectRatio),
      painter: _DnaLogoPainter(
        color1: color1 ?? colors.accentColor,
        color2: color2 ?? colors.secondaryColor,
      ),
    );
  }
}

class _DnaLogoPainter extends CustomPainter {
  const _DnaLogoPainter({required this.color1, required this.color2});

  final Color color1;
  final Color color2;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final amplitude = height / 2.2;
    final centerY = height / 2;
    final strokeWidth = height / 6;
    const twists = 1.5;
    const totalAngle = twists * 2 * pi;

    final rungPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = strokeWidth / 8
      ..strokeCap = StrokeCap.round;

    final rungCount = (twists * 8).round();
    for (int i = 1; i < rungCount; i++) {
      final progress = i / rungCount;
      final x = width * progress;
      final angle = progress * totalAngle;
      final yOffset = amplitude * sin(angle);
      canvas.drawLine(
        Offset(x, centerY + yOffset),
        Offset(x, centerY - yOffset),
        rungPaint,
      );
    }

    final path1 = Path();
    final path2 = Path();

    for (double x = 0; x <= width; x++) {
      final angle = (x / width) * totalAngle;
      if (x == 0) {
        path1.moveTo(x, centerY + amplitude * sin(angle));
        path2.moveTo(x, centerY - amplitude * sin(angle));
      } else {
        path1.lineTo(x, centerY + amplitude * sin(angle));
        path2.lineTo(x, centerY - amplitude * sin(angle));
      }
    }

    final paint1 = Paint()
      ..color = color1
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final paint2 = Paint()
      ..color = color2
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Interweaving logic
    final segmentCount = (twists * 2).floor();
    for (int i = 0; i < segmentCount; i++) {
      final start = i / segmentCount;
      final end = (i + 1) / segmentCount;

      final segment1 = _extractPathSegment(path1, start, end);
      final segment2 = _extractPathSegment(path2, start, end);

      if (i.isEven) {
        canvas.drawPath(segment2, paint2);
        canvas.drawPath(segment1, paint1);
      } else {
        canvas.drawPath(segment1, paint1);
        canvas.drawPath(segment2, paint2);
      }
    }
  }

  Path _extractPathSegment(Path source, double start, double end) {
    final path = Path();
    for (final metric in source.computeMetrics()) {
      final startPos = metric.length * start;
      final endPos = metric.length * end;
      final extracted = metric.extractPath(startPos, endPos);
      path.addPath(extracted, Offset.zero);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _DnaLogoPainter oldDelegate) =>
      color1 != oldDelegate.color1 || color2 != oldDelegate.color2;
}
