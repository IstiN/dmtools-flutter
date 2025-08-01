import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

enum ButtonStyle {
  primary,
  secondary,
  outline,
  tertiary,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle style;
  final bool isFullWidth;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;

  const AppButton({
    required this.text,
    required this.onPressed,
    this.style = ButtonStyle.primary,
    this.isFullWidth = false,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isIconButton = icon != null;

    final buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(right: 8),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_getContentColor()),
            ),
          )
        else if (isIconButton)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(icon, size: 18, color: _getContentColor()),
          ),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _getContentColor(),
          ),
        ),
      ],
    );

    Widget button;

    switch (style) {
      case ButtonStyle.primary:
        button = ElevatedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );
        break;
      case ButtonStyle.secondary:
        button = ElevatedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );
        break;
      case ButtonStyle.outline:
        button = OutlinedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accentColor,
            side: BorderSide(color: isDisabled ? AppColors.disabledLightText : AppColors.accentColor),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );
        break;
      case ButtonStyle.tertiary:
        button = TextButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accentColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );
        break;
    }

    return button;
  }

  Color _getContentColor() {
    if (isDisabled) {
      return AppColors.disabledLightText;
    }

    switch (style) {
      case ButtonStyle.primary:
      case ButtonStyle.secondary:
        return Colors.white;
      case ButtonStyle.outline:
      case ButtonStyle.tertiary:
        return AppColors.accentColor;
    }
  }
}
