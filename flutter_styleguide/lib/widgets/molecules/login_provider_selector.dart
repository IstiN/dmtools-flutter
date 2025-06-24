import 'package:dmtools_styleguide/widgets/atoms/buttons/oauth_provider_button.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_dimensions.dart';

class LoginProviderSelector extends StatefulWidget {
  final String title;
  final String subtitle;

  const LoginProviderSelector({
    super.key,
    this.title = 'Sign in to DMTools',
    this.subtitle = 'Choose a provider to continue',
  });

  @override
  State<LoginProviderSelector> createState() => _LoginProviderSelectorState();
}

class _LoginProviderSelectorState extends State<LoginProviderSelector> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      width: AppDimensions.dialogWidth, // Fixed width to match reference design
      padding: AppDimensions.dialogPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            widget.subtitle,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingXl),
          const OAuthProviderButton(
            provider: OAuthProvider.google,
            text: 'Continue with Google',
          ),
          const SizedBox(height: AppDimensions.spacingM),
          const OAuthProviderButton(
            provider: OAuthProvider.microsoft,
            text: 'Continue with Microsoft',
          ),
          const SizedBox(height: AppDimensions.spacingM),
          const OAuthProviderButton(
            provider: OAuthProvider.github,
            text: 'Continue with GitHub',
          ),
        ],
      ),
    );
  }
} 