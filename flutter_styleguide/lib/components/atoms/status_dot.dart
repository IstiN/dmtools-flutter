import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

enum StatusType {
  success,
  warning,
  error,
  info,
  neutral,
}

class StatusDot extends StatelessWidget {
  final StatusType status;
  final double size;

  const StatusDot({
    required this.status, Key? key,
    this.size = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getColorForStatus(),
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getColorForStatus() {
    switch (status) {
      case StatusType.success:
        return AppColors.successColor;
      case StatusType.warning:
        return AppColors.warningColor;
      case StatusType.error:
        return AppColors.dangerColor;
      case StatusType.info:
        return AppColors.infoColor;
      case StatusType.neutral:
        return AppColors.lightTextSecondary;
    }
  }
} 