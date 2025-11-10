import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Animated navigation icon widget that supports SVG icons with click animations
/// Animations work cross-platform (web, mobile, desktop)
class NavigationIcon extends StatefulWidget {
  final String svgAssetPath;
  final Color color;
  final double size;
  final VoidCallback? onTap;

  const NavigationIcon({
    required this.svgAssetPath,
    required this.color,
    this.size = 24,
    this.onTap,
    super.key,
  });

  @override
  State<NavigationIcon> createState() => _NavigationIconState();
}

class _NavigationIconState extends State<NavigationIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Scale animation: slightly grow then return
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 50,
      ),
    ]).animate(_controller);

    // Subtle rotation animation
    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -0.1).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.1, end: 0.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Public method to trigger animation from parent widget
  void triggerAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: SvgPicture.asset(
              widget.svgAssetPath,
              width: widget.size,
              height: widget.size,
              colorFilter: ColorFilter.mode(
                widget.color,
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      },
    );
  }
}

