import 'package:dmtools_styleguide/core/config/app_config.dart';
import 'package:dmtools_styleguide/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_colors.dart';

enum OAuthProvider {
  google,
  microsoft,
  github,
}

/// A button specifically designed for OAuth provider login options.
class OAuthProviderButton extends StatefulWidget {
  final OAuthProvider provider;
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final bool isLoading;
  final bool isDisabled;

  const OAuthProviderButton({
    super.key,
    required this.provider,
    required this.text,
    this.onPressed,
    this.isFullWidth = true,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  State<OAuthProviderButton> createState() => _OAuthProviderButtonState();
}

class _OAuthProviderButtonState extends State<OAuthProviderButton> {
  bool _isHovering = false;
  bool _isLoading = false;

  Future<void> _handleOnPressed() async {
    if (widget.onPressed != null) {
      widget.onPressed!();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final providerName = widget.provider.toString().split('.').last.toLowerCase();
    final url = Uri.parse('${AppConfig.backendBaseUrl}/oauth2/authorization/$providerName');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, webOnlyWindowName: '_self');
    } else {
      // ignore: avoid_print
      print('Could not launch $url');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch login URL for $providerName')),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    // --- Base Colors ---
    Color getBaseBackgroundColor() {
      return isDark ? colors.oauthButtonBgDark : Colors.white;
    }

    Color getTextColor() {
      return isDark ? colors.textColor : colors.textSecondary;
    }

    Widget getIcon() {
      switch (widget.provider) {
        case OAuthProvider.google:
          return Transform.translate(
            offset: const Offset(0, -1.5),
            child: Text(
              'G',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: colors.googleRed,
              ),
            ),
          );
        case OAuthProvider.microsoft:
          return Icon(
            Icons.window,
            color: colors.microsoftBlue,
            size: AppDimensions.iconSizeM,
          );
        case OAuthProvider.github:
          return Icon(
            Icons.code,
            color: isDark ? colors.textColor : colors.githubBlack,
            size: AppDimensions.oauthIconSize,
          );
      }
    }

    Color getBorderColor() {
      switch (widget.provider) {
        case OAuthProvider.google:
          return isDark ? colors.oauthBorderDark : colors.oauthBorderLight;
        case OAuthProvider.microsoft:
          return colors.microsoftBlue;
        case OAuthProvider.github:
          return isDark ? colors.oauthBorderDark : colors.githubBlack;
      }
    }

    // --- State-based Colors ---
    final baseBackgroundColor = getBaseBackgroundColor();
    final hoverColor = isDark ? colors.hoverBgDark : colors.hoverBgLight;

    final materialColor = _isHovering && !widget.isDisabled
        ? Color.alphaBlend(hoverColor, baseBackgroundColor)
        : baseBackgroundColor;

    final effectiveTextColor =
        widget.isDisabled ? (isDark ? colors.disabledDarkText : colors.disabledLightText) : getTextColor();
    
    final bool showLoading = widget.isLoading || _isLoading;

    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      height: AppDimensions.oauthButtonHeight,
      child: Material(
        color: widget.isDisabled
            ? (isDark ? colors.disabledDarkBg : colors.disabledLightBg)
            : materialColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          side: BorderSide(
              color: widget.isDisabled ? Colors.transparent : getBorderColor(),
              width: 1.0),
        ),
        child: InkWell(
          onTap: widget.isDisabled || showLoading ? null : _handleOnPressed,
          onHover: (hovering) {
            if (!widget.isDisabled) {
              setState(() => _isHovering = hovering);
            }
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Padding(
            padding: AppDimensions.oauthButtonPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showLoading)
                  SizedBox(
                    width: AppDimensions.iconSizeL,
                    height: AppDimensions.iconSizeL,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                    ),
                  )
                else
                  SizedBox(
                    width: AppDimensions.iconSizeL,
                    height: AppDimensions.iconSizeL,
                    child: Align(
                      alignment: Alignment.center,
                      child: getIcon(),
                    ),
                  ),
                const SizedBox(width: AppDimensions.spacingM),
                Text(
                  widget.text,
                  style: TextStyle(
                    color: effectiveTextColor,
                    fontSize: AppDimensions.oauthButtonFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 