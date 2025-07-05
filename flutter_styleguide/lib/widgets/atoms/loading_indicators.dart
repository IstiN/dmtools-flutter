import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/theme/app_theme.dart';

class PulsingDotIndicator extends StatefulWidget {
  const PulsingDotIndicator({
    this.size = 24.0,
    super.key,
  });

  final double size;

  @override
  PulsingDotIndicatorState createState() => PulsingDotIndicatorState();
}

class PulsingDotIndicatorState extends State<PulsingDotIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FadeTransition(
      opacity: _animation,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.accentColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class BouncingDotsIndicator extends StatefulWidget {
  const BouncingDotsIndicator({
    super.key,
    this.numberOfDots = 3,
    this.size = 12.0,
    this.spacing = 4.0,
  });

  final int numberOfDots;
  final double size;
  final double spacing;

  @override
  BouncingDotsIndicatorState createState() => BouncingDotsIndicatorState();
}

class BouncingDotsIndicatorState extends State<BouncingDotsIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animations = List.generate(widget.numberOfDots, (index) {
      return Tween<double>(begin: 0, end: -widget.size).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            (index * 0.1) + 0.5,
            curve: Curves.bounceOut,
          ),
        ),
      );
    });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final width = widget.numberOfDots * widget.size + (widget.numberOfDots - 1) * widget.spacing;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: width,
          height: widget.size * 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.numberOfDots, (index) {
              return Transform.translate(
                offset: Offset(0, _animations[index].value),
                child: Padding(
                  padding: EdgeInsets.only(right: index == widget.numberOfDots - 1 ? 0 : widget.spacing),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(dimension: widget.size),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class RotatingSegmentsIndicator extends StatefulWidget {
  const RotatingSegmentsIndicator({
    super.key,
    this.size = 36.0,
    this.strokeWidth = 4.0,
    this.numberOfSegments = 6,
  });

  final double size;
  final double strokeWidth;
  final int numberOfSegments;

  @override
  RotatingSegmentsIndicatorState createState() => RotatingSegmentsIndicatorState();
}

class RotatingSegmentsIndicatorState extends State<RotatingSegmentsIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _RotatingSegmentsPainter(
              numberOfSegments: widget.numberOfSegments,
              strokeWidth: widget.strokeWidth,
              color: context.colors.accentColor,
            ),
          ),
        );
      },
    );
  }
}

class _RotatingSegmentsPainter extends CustomPainter {
  _RotatingSegmentsPainter({
    required this.numberOfSegments,
    required this.strokeWidth,
    required this.color,
  });

  final int numberOfSegments;
  final double strokeWidth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final segmentAngle = (2 * 3.14159) / numberOfSegments;
    final gap = segmentAngle / 4;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < numberOfSegments; i++) {
      final startAngle = i * segmentAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + gap / 2,
        segmentAngle - gap,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RotatingSegmentsPainter oldDelegate) => false;
}

class InfinityDotsIndicator extends StatefulWidget {
  const InfinityDotsIndicator({
    super.key,
    this.size = 60.0,
    this.numberOfDots = 15,
  });

  final double size;
  final int numberOfDots;

  @override
  InfinityDotsIndicatorState createState() => InfinityDotsIndicatorState();
}

class InfinityDotsIndicatorState extends State<InfinityDotsIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _InfinityDotsPainter(
            numberOfDots: widget.numberOfDots,
            animationValue: _controller.value,
            color: context.colors.accentColor,
          ),
        );
      },
    );
  }
}

class _InfinityDotsPainter extends CustomPainter {
  _InfinityDotsPainter({
    required this.numberOfDots,
    required this.animationValue,
    required this.color,
  });

  final int numberOfDots;
  final double animationValue;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final a = size.width / 2;

    const toInfinityPhaseEnd = 0.5;
    const holdInfinityPhaseEnd = 0.8;

    double transition;
    if (animationValue < toInfinityPhaseEnd) {
      final phaseProgress = animationValue / toInfinityPhaseEnd;
      transition = 1.0 - Curves.easeInOut.transform(phaseProgress);
    } else if (animationValue < holdInfinityPhaseEnd) {
      transition = 0.0;
    } else {
      final phaseProgress = (animationValue - holdInfinityPhaseEnd) / (1.0 - holdInfinityPhaseEnd);
      transition = Curves.easeInOut.transform(phaseProgress);
    }

    for (int i = 0; i < numberOfDots; i++) {
      final t = 2 * pi * (animationValue + i / numberOfDots);
      final denominator = 1 + pow(sin(t), 2);
      final infinityPosition = center +
          Offset(
            (a * cos(t)) / denominator,
            (a * 0.7 * sin(t) * cos(t)) / denominator,
          );

      final chaoticRadius = a * ((i + 1) / numberOfDots);
      final chaoticAngle = 2 * pi * animationValue * (i % 2 == 0 ? 1 : -1) * (i * 0.5 + 1);
      final chaoticPosition = center + Offset(chaoticRadius * cos(chaoticAngle), chaoticRadius * sin(chaoticAngle));

      final dotPosition = Offset.lerp(infinityPosition, chaoticPosition, transition)!;

      final distance = (dotPosition - center).distance;
      final maxDistance = size.width / 2;
      final dotRadius = (size.width / 20 * (1 - distance / maxDistance)).clamp(1.0, 5.0);
      final opacity = (1 - (distance / maxDistance) * 0.7).clamp(0.1, 1.0);

      final paint = Paint()..color = color.withAlpha((opacity * 255).round());
      canvas.drawCircle(dotPosition, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(_InfinityDotsPainter oldDelegate) => oldDelegate.animationValue != animationValue;
}

class ChromosomeIndicator extends StatefulWidget {
  const ChromosomeIndicator({
    super.key,
    this.size = 60.0,
    this.numberOfDots = 20,
  });

  final double size;
  final int numberOfDots;

  @override
  ChromosomeIndicatorState createState() => ChromosomeIndicatorState();
}

class ChromosomeIndicatorState extends State<ChromosomeIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _ChromosomePainter(
            numberOfDots: widget.numberOfDots,
            animationValue: _controller.value,
            color: context.colors.accentColor,
          ),
        );
      },
    );
  }
}

class _ChromosomePainter extends CustomPainter {
  _ChromosomePainter({
    required this.numberOfDots,
    required this.animationValue,
    required this.color,
  });

  final int numberOfDots;
  final double animationValue;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ellipseWidth = size.width;
    final ellipseHeight = size.width / 4;

    const toShapePhaseEnd = 0.5;
    const holdShapePhaseEnd = 0.8;

    double transition;
    double pulse = 0.0;
    if (animationValue < toShapePhaseEnd) {
      final phaseProgress = animationValue / toShapePhaseEnd;
      transition = 1.0 - Curves.easeInOut.transform(phaseProgress);
    } else if (animationValue < holdShapePhaseEnd) {
      transition = 0.0;
      final pulseProgress = (animationValue - toShapePhaseEnd) / (holdShapePhaseEnd - toShapePhaseEnd);
      pulse = sin(pulseProgress * 4 * pi);
    } else {
      final phaseProgress = (animationValue - holdShapePhaseEnd) / (1.0 - holdShapePhaseEnd);
      transition = Curves.easeInOut.transform(phaseProgress);
    }

    final halfDots = (numberOfDots / 2).floor();

    for (int i = 0; i < numberOfDots; i++) {
      final double t = 2 * pi * ((i % halfDots) / halfDots);

      final double xUnrotated = ellipseWidth / 2 * cos(t);
      final double yUnrotated = ellipseHeight / 2 * sin(t);

      final double rotation = i < halfDots ? (pi / 4) : (-pi / 4);

      final double xRotated = xUnrotated * cos(rotation) - yUnrotated * sin(rotation);
      final double yRotated = xUnrotated * sin(rotation) + yUnrotated * cos(rotation);

      final shapePosition = center + Offset(xRotated, yRotated);

      final chaoticRadius = (size.width / 2) * ((i + 1) / numberOfDots);
      final chaoticAngle = 2 * pi * animationValue * (i % 2 == 0 ? 1 : -1) * (i * 0.5 + 1);
      final chaoticPosition = center + Offset(chaoticRadius * cos(chaoticAngle), chaoticRadius * sin(chaoticAngle));

      final dotPosition = Offset.lerp(shapePosition, chaoticPosition, transition)!;

      final distance = (dotPosition - center).distance;
      final maxDistance = size.width / 2;
      final baseDotRadius = (size.width / 20 * (1 - distance / maxDistance)).clamp(1.0, 5.0);
      final dotRadius = (baseDotRadius + pulse * 0.75).clamp(1.0, 6.0);
      final opacity = (1 - (distance / maxDistance) * 0.7).clamp(0.1, 1.0);

      final paint = Paint()..color = color.withAlpha((opacity * 255).round());
      canvas.drawCircle(dotPosition, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(_ChromosomePainter oldDelegate) => oldDelegate.animationValue != animationValue;
}

class DnaIndicator extends StatefulWidget {
  const DnaIndicator({
    super.key,
    this.size = 80.0,
    this.numberOfDots = 40,
  });

  final double size;
  final int numberOfDots;

  @override
  DnaIndicatorState createState() => DnaIndicatorState();
}

class DnaIndicatorState extends State<DnaIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size * 0.35),
          painter: _DnaPainter(
            numberOfDots: widget.numberOfDots,
            controller: _controller,
            color: colors.accentColor,
          ),
        );
      },
    );
  }
}

class _DnaPainter extends CustomPainter {
  _DnaPainter({
    required this.numberOfDots,
    required this.controller,
    required this.color,
  }) : super(repaint: controller);

  final int numberOfDots;
  final Animation<double> controller;
  final Color color;

  Offset _calculateDnaPositionForDot(int i, Size size, Offset center) {
    final halfDots = (numberOfDots / 2).floor();
    final isTopStrand = i < halfDots;
    final dotOnStrand = isTopStrand ? i : i - halfDots;
    final horizontalProgress = halfDots > 1 ? dotOnStrand / (halfDots - 1) : 0.5;

    final x = size.width * (horizontalProgress - 0.5);
    final waveAngle = horizontalProgress * pi * 3;
    final y = size.height / 2 * sin(waveAngle);

    return center + Offset(x, isTopStrand ? y : -y);
  }

  Offset _calculateChaoticPositionForDot(int i, Size size, Offset center, double t) {
    final chaoticRadius = (size.width / 2.4) * (i / numberOfDots * 0.6 + 0.8);
    final chaoticAngle = 2 * pi * t * 1.5 * (1.5 + sin(i)) * (i % 2 == 0 ? 1 : -1.5) + (i * pi / 3);
    return center + Offset(chaoticRadius * cos(chaoticAngle), chaoticRadius * sin(chaoticAngle));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final t = controller.value;
    final center = Offset(size.width / 2, size.height / 2);

    const expandEndTime = 0.1;
    const chaosEndTime = 0.3;
    const struggleEndTime = 0.7;
    const finalGatherEndTime = 0.9;
    const holdEndTime = 0.95;

    for (int i = 0; i < numberOfDots; i++) {
      final dnaPosition = _calculateDnaPositionForDot(i, size, center);
      Offset dotPosition;
      final bool isStruggleDot = i % 3 == 0;

      if (t < expandEndTime) {
        final phaseProgress = t / expandEndTime;
        final targetChaosPos = _calculateChaoticPositionForDot(i, size, center, expandEndTime);
        dotPosition = Offset.lerp(center, targetChaosPos, Curves.easeOut.transform(phaseProgress))!;
      } else if (t < chaosEndTime) {
        dotPosition = _calculateChaoticPositionForDot(i, size, center, t);
      } else if (t < struggleEndTime) {
        if (isStruggleDot) {
          final timeIntoStruggle = t - chaosEndTime;
          const struggleDuration = struggleEndTime - chaosEndTime;
          const numberOfStruggles = 2;
          const singleStruggleDuration = struggleDuration / numberOfStruggles;

          final currentStruggleIndex = (timeIntoStruggle / singleStruggleDuration).floor();
          final timeIntoCurrentStruggle = timeIntoStruggle - (currentStruggleIndex * singleStruggleDuration);
          final tAtStruggleStart = chaosEndTime + (currentStruggleIndex * singleStruggleDuration);
          final chaosPosAtStruggleStart = _calculateChaoticPositionForDot(i, size, center, tAtStruggleStart);

          const halfStruggleDuration = singleStruggleDuration / 2;

          if (timeIntoCurrentStruggle < halfStruggleDuration) {
            final phaseProgress = timeIntoCurrentStruggle / halfStruggleDuration;
            dotPosition = Offset.lerp(chaosPosAtStruggleStart, center, Curves.easeIn.transform(phaseProgress))!;
          } else {
            final phaseProgress = (timeIntoCurrentStruggle - halfStruggleDuration) / halfStruggleDuration;
            final tAtStruggleEnd = chaosEndTime + ((currentStruggleIndex + 1) * singleStruggleDuration);
            final chaosPosAtStruggleEnd = _calculateChaoticPositionForDot(i, size, center, tAtStruggleEnd);
            dotPosition = Offset.lerp(center, chaosPosAtStruggleEnd, Curves.easeOut.transform(phaseProgress))!;
          }
        } else {
          dotPosition = _calculateChaoticPositionForDot(i, size, center, t);
        }
      } else if (t < finalGatherEndTime) {
        final phaseProgress = (t - struggleEndTime) / (finalGatherEndTime - struggleEndTime);
        final startPosition = _calculateChaoticPositionForDot(i, size, center, struggleEndTime);
        dotPosition = Offset.lerp(startPosition, dnaPosition, Curves.easeInOut.transform(phaseProgress))!;
      } else if (t < holdEndTime) {
        dotPosition = dnaPosition;
      } else {
        final phaseProgress = (t - holdEndTime) / (1.0 - holdEndTime);
        dotPosition = Offset.lerp(dnaPosition, center, Curves.easeIn.transform(phaseProgress))!;
      }

      final distance = (dotPosition - center).distance;
      final maxDistance = size.width / 2;
      var dotRadius = (size.width / 40 * (1 - distance / maxDistance)).clamp(1.0, 4.0);
      final opacity = (1 - (distance / maxDistance) * 0.7).clamp(0.1, 1.0);

      if (t > expandEndTime && t < struggleEndTime) {
        final double pulse = (sin(t * 2 * pi * 5) + 1) / 2;
        dotRadius = (dotRadius * (1.0 + pulse * 0.4)).clamp(1.0, 5.0);
      }

      final paint = Paint()..color = color.withAlpha((opacity * 255).round());
      canvas.drawCircle(dotPosition, dotRadius, paint);
    }

    double rungOpacity = 0.0;
    if (t >= struggleEndTime && t < finalGatherEndTime) {
      rungOpacity = (t - struggleEndTime) / (finalGatherEndTime - struggleEndTime);
    } else if (t >= finalGatherEndTime && t < holdEndTime) {
      rungOpacity = 1.0;
    } else if (t >= holdEndTime) {
      rungOpacity = 1.0 - ((t - holdEndTime) / (1.0 - holdEndTime));
    }
    rungOpacity = rungOpacity.clamp(0.0, 1.0);

    if (rungOpacity > 0.1) {
      final paint = Paint()
        ..color = color.withAlpha((rungOpacity * 255 * 0.6).round())
        ..strokeWidth = 0.8;

      const rungCount = 10;
      for (int j = 0; j < rungCount; j++) {
        final double horizontalProgress = (j + 0.5) / rungCount;
        final double x = size.width * (horizontalProgress - 0.5);
        final double waveAngle = horizontalProgress * pi * 3;
        final double y = size.height / 2 * sin(waveAngle);
        canvas.drawLine(
          center + Offset(x, y),
          center + Offset(x, -y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DnaPainter oldDelegate) => true;
}

class FadingGridIndicator extends StatefulWidget {
  const FadingGridIndicator({
    super.key,
    this.size = 40.0,
    this.gridSize = 3,
  });

  final double size;
  final int gridSize;

  @override
  FadingGridIndicatorState createState() => FadingGridIndicatorState();
}

class FadingGridIndicatorState extends State<FadingGridIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _FadingGridPainter(
            gridSize: widget.gridSize,
            animationValue: _controller.value,
            color: context.colors.accentColor,
          ),
        );
      },
    );
  }
}

class _FadingGridPainter extends CustomPainter {
  _FadingGridPainter({
    required this.gridSize,
    required this.animationValue,
    required this.color,
  });

  final int gridSize;
  final double animationValue;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double spacing = size.width / gridSize;
    final double dotSize = spacing / 3;

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        final double dx = spacing / 2 + j * spacing;
        final double dy = spacing / 2 + i * spacing;

        final delay = (i + j) / (gridSize * 2);
        final opacity = (sin((animationValue - delay) * 2 * pi) + 1) / 2;

        final paint = Paint()..color = color.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
        canvas.drawCircle(Offset(dx, dy), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_FadingGridPainter oldDelegate) => oldDelegate.animationValue != animationValue;
}
