import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// A button component that copies text to clipboard with visual feedback
///
/// This atom provides a convenient copy-to-clipboard functionality
/// with animated feedback and customizable appearance. Used in code
/// display blocks and configuration views.
class CopyButton extends StatefulWidget {
  const CopyButton({
    required this.textToCopy,
    this.label = 'Copy',
    this.copiedLabel = 'Copied!',
    this.icon = Icons.copy,
    this.copiedIcon = Icons.check,
    this.variant = CopyButtonVariant.outlined,
    this.size = CopyButtonSize.medium,
    this.onCopied,
    super.key,
  });

  final String textToCopy;
  final String label;
  final String copiedLabel;
  final IconData icon;
  final IconData copiedIcon;
  final CopyButtonVariant variant;
  final CopyButtonSize size;
  final VoidCallback? onCopied;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isCopied = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleCopy() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.textToCopy));

      // Trigger animation
      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      // Show copied state
      setState(() {
        _isCopied = true;
      });

      // Reset after delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isCopied = false;
          });
        }
      });

      widget.onCopied?.call();
    } catch (e) {
      // Handle copy error silently or show a snackbar
      debugPrint('Failed to copy text: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimensions = _getDimensions();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: _buildButton(colors, dimensions));
      },
    );
  }

  Widget _buildButton(ThemeColorSet colors, _ButtonDimensions dimensions) {
    switch (widget.variant) {
      case CopyButtonVariant.filled:
        return _FilledButton(
          onPressed: _handleCopy,
          colors: colors,
          dimensions: dimensions,
          label: _isCopied ? widget.copiedLabel : widget.label,
          icon: _isCopied ? widget.copiedIcon : widget.icon,
          isCopied: _isCopied,
        );
      case CopyButtonVariant.outlined:
        return _OutlinedButton(
          onPressed: _handleCopy,
          colors: colors,
          dimensions: dimensions,
          label: _isCopied ? widget.copiedLabel : widget.label,
          icon: _isCopied ? widget.copiedIcon : widget.icon,
          isCopied: _isCopied,
        );
      case CopyButtonVariant.text:
        return _TextButton(
          onPressed: _handleCopy,
          colors: colors,
          dimensions: dimensions,
          label: _isCopied ? widget.copiedLabel : widget.label,
          icon: _isCopied ? widget.copiedIcon : widget.icon,
          isCopied: _isCopied,
        );
      case CopyButtonVariant.iconOnly:
        return _IconOnlyButton(
          onPressed: _handleCopy,
          colors: colors,
          dimensions: dimensions,
          icon: _isCopied ? widget.copiedIcon : widget.icon,
          isCopied: _isCopied,
        );
    }
  }

  _ButtonDimensions _getDimensions() {
    switch (widget.size) {
      case CopyButtonSize.small:
        return const _ButtonDimensions(
          height: 32,
          horizontalPadding: 12,
          borderRadius: 6,
          iconSize: 14,
          fontSize: 12,
          spacing: 6,
        );
      case CopyButtonSize.medium:
        return const _ButtonDimensions(
          height: 40,
          horizontalPadding: 16,
          borderRadius: 8,
          iconSize: 18,
          fontSize: 14,
          spacing: 8,
        );
      case CopyButtonSize.large:
        return const _ButtonDimensions(
          height: 48,
          horizontalPadding: 20,
          borderRadius: 10,
          iconSize: 22,
          fontSize: 16,
          spacing: 10,
        );
    }
  }
}

/// Button variants for different use cases
enum CopyButtonVariant { filled, outlined, text, iconOnly }

/// Size options for the copy button
enum CopyButtonSize { small, medium, large }

class _ButtonDimensions {
  const _ButtonDimensions({
    required this.height,
    required this.horizontalPadding,
    required this.borderRadius,
    required this.iconSize,
    required this.fontSize,
    required this.spacing,
  });

  final double height;
  final double horizontalPadding;
  final double borderRadius;
  final double iconSize;
  final double fontSize;
  final double spacing;
}

class _FilledButton extends StatelessWidget {
  const _FilledButton({
    required this.onPressed,
    required this.colors,
    required this.dimensions,
    required this.label,
    required this.icon,
    required this.isCopied,
  });

  final VoidCallback onPressed;
  final ThemeColorSet colors;
  final _ButtonDimensions dimensions;
  final String label;
  final IconData icon;
  final bool isCopied;

  @override
  Widget build(BuildContext context) {
    final bgColor = isCopied ? colors.successColor : colors.accentColor;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(dimensions.borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        child: Container(
          height: dimensions.height,
          padding: EdgeInsets.symmetric(horizontal: dimensions.horizontalPadding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: dimensions.iconSize, color: Colors.white),
              SizedBox(width: dimensions.spacing),
              Text(
                label,
                style: TextStyle(fontSize: dimensions.fontSize, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  const _OutlinedButton({
    required this.onPressed,
    required this.colors,
    required this.dimensions,
    required this.label,
    required this.icon,
    required this.isCopied,
  });

  final VoidCallback onPressed;
  final ThemeColorSet colors;
  final _ButtonDimensions dimensions;
  final String label;
  final IconData icon;
  final bool isCopied;

  @override
  Widget build(BuildContext context) {
    final borderColor = isCopied ? colors.successColor : colors.accentColor;
    final contentColor = isCopied ? colors.successColor : colors.accentColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(dimensions.borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        child: Container(
          height: dimensions.height,
          padding: EdgeInsets.symmetric(horizontal: dimensions.horizontalPadding),
          decoration: BoxDecoration(
            border: Border.all(color: contentColor.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(dimensions.borderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: dimensions.iconSize, color: contentColor),
              SizedBox(width: dimensions.spacing),
              Text(
                label,
                style: TextStyle(fontSize: dimensions.fontSize, fontWeight: FontWeight.w500, color: contentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextButton extends StatelessWidget {
  const _TextButton({
    required this.onPressed,
    required this.colors,
    required this.dimensions,
    required this.label,
    required this.icon,
    required this.isCopied,
  });

  final VoidCallback onPressed;
  final ThemeColorSet colors;
  final _ButtonDimensions dimensions;
  final String label;
  final IconData icon;
  final bool isCopied;

  @override
  Widget build(BuildContext context) {
    final contentColor = isCopied ? colors.successColor : colors.accentColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(dimensions.borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        child: Container(
          height: dimensions.height,
          padding: EdgeInsets.symmetric(horizontal: dimensions.horizontalPadding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: dimensions.iconSize, color: contentColor),
              SizedBox(width: dimensions.spacing),
              Text(
                label,
                style: TextStyle(fontSize: dimensions.fontSize, fontWeight: FontWeight.w500, color: contentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconOnlyButton extends StatelessWidget {
  const _IconOnlyButton({
    required this.onPressed,
    required this.colors,
    required this.dimensions,
    required this.icon,
    required this.isCopied,
  });

  final VoidCallback onPressed;
  final ThemeColorSet colors;
  final _ButtonDimensions dimensions;
  final IconData icon;
  final bool isCopied;

  @override
  Widget build(BuildContext context) {
    final contentColor = isCopied ? colors.successColor : colors.accentColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(dimensions.borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        child: Container(
          width: dimensions.height,
          height: dimensions.height,
          decoration: BoxDecoration(
            border: Border.all(color: contentColor.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(dimensions.borderRadius),
          ),
          child: Icon(icon, size: dimensions.iconSize, color: contentColor),
        ),
      ),
    );
  }
}
