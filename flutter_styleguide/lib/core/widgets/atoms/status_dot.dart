import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

enum StatusDotType {
  success,
  warning,
  error,
  info,
  offline,
  processing,
}

class StatusDot extends StatelessWidget {
  final StatusDotType type;
  final double size;

  const StatusDot({
    super.key,
    this.type = StatusDotType.success,
    this.size = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getColor(context),
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getColor(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    switch (type) {
      case StatusDotType.success:
        return colors.successColor;
      case StatusDotType.warning:
        return colors.warningColor;
      case StatusDotType.error:
        return colors.dangerColor;
      case StatusDotType.info:
        return colors.infoColor;
      case StatusDotType.offline:
        return colors.textMuted;
      case StatusDotType.processing:
        return colors.accentColor;
    }
  }
} 