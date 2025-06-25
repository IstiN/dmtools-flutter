import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

enum AppButtonStyle {
  primary,
  secondary,
  outline,
  tertiary,
  link,
}

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final AppButtonStyle style;
  final bool isSmall;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.style = AppButtonStyle.primary,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final textStyle = _getTextStyle(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(width: isSmall ? 4 : 8),
          ],
          Text(text, style: textStyle),
        ],
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final double verticalPadding = isSmall ? 8 : 12;
    final double horizontalPadding = isSmall ? 16 : 24;
    
    switch (style) {
      case AppButtonStyle.secondary:
        return theme.elevatedButtonTheme.style!.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          side: WidgetStateProperty.all(BorderSide(color: AppColors.accentColor, width: 1.5)),
          overlayColor: WidgetStateProperty.all(AppColors.accentColor.withValues(alpha: 0.1)),
        );
      case AppButtonStyle.tertiary:
         return theme.elevatedButtonTheme.style!.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          side: WidgetStateProperty.all(BorderSide(color: theme.dividerColor)),
           overlayColor: WidgetStateProperty.all(AppColors.accentColor.withValues(alpha: 0.1)),
        );
      case AppButtonStyle.outline:
        return theme.elevatedButtonTheme.style!.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          side: WidgetStateProperty.all(const BorderSide(color: Colors.white70, width: 1.5)),
          overlayColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.15)),
        );
      case AppButtonStyle.link:
        return TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          foregroundColor: AppColors.accentColor,
          textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: isSmall ? 12 : 14),
        );
      case AppButtonStyle.primary:
      default:
        return theme.elevatedButtonTheme.style!.copyWith(
           padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding))
        );
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final double fontSize = isSmall ? 13 : 15;

    switch (style) {
       case AppButtonStyle.secondary:
        return TextStyle(color: AppColors.accentColor, fontWeight: FontWeight.w500, fontSize: fontSize);
      case AppButtonStyle.tertiary:
        return TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, fontWeight: FontWeight.w500, fontSize: fontSize);
      case AppButtonStyle.outline:
        return TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: fontSize);
      case AppButtonStyle.link:
        return TextStyle(color: AppColors.accentColor, fontWeight: FontWeight.w500, fontSize: fontSize);
      case AppButtonStyle.primary:
      default:
        return TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: fontSize);
    }
  }
} 