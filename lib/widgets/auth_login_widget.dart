import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/services/oauth_service.dart' show OAuthProvider;

class AuthLoginWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthLoginWidget({
    super.key,
    this.title = 'Sign in to DMTools',
    this.subtitle = 'Choose a provider to continue',
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          width: 480, // Fixed width to match styleguide
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Error message
              if (authProvider.hasError) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authProvider.error ?? 'Authentication failed',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // OAuth provider buttons
              _OAuthProviderButton(
                provider: OAuthProvider.google,
                text: 'Continue with Google',
                onPressed: authProvider.isLoading ? null : () => _handleLogin(context, OAuthProvider.google),
                isLoading: authProvider.isLoading,
              ),
              const SizedBox(height: 16),
              _OAuthProviderButton(
                provider: OAuthProvider.microsoft,
                text: 'Continue with Microsoft',
                onPressed: authProvider.isLoading ? null : () => _handleLogin(context, OAuthProvider.microsoft),
                isLoading: authProvider.isLoading,
              ),
              const SizedBox(height: 16),
              _OAuthProviderButton(
                provider: OAuthProvider.github,
                text: 'Continue with GitHub',
                onPressed: authProvider.isLoading ? null : () => _handleLogin(context, OAuthProvider.github),
                isLoading: authProvider.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleLogin(BuildContext context, OAuthProvider provider) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(provider);
    if (!success && context.mounted) {
      // Error handling is managed by the AuthProvider and displayed in the UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _OAuthProviderButton extends StatefulWidget {
  final OAuthProvider provider;
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _OAuthProviderButton({
    required this.provider,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<_OAuthProviderButton> createState() => _OAuthProviderButtonState();
}

class _OAuthProviderButtonState extends State<_OAuthProviderButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Provider-specific styling
    Color getIconColor() {
      switch (widget.provider) {
        case OAuthProvider.google:
          return const Color(0xFFEA4335); // Google Red
        case OAuthProvider.microsoft:
          return const Color(0xFF0078D4); // Microsoft Blue
        case OAuthProvider.github:
          return isDark ? Colors.white : Colors.black87;
      }
    }

    Widget getIcon() {
      switch (widget.provider) {
        case OAuthProvider.google:
          return Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            child: Text(
              'G',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: getIconColor(),
              ),
            ),
          );
        case OAuthProvider.microsoft:
          return Icon(
            Icons.window,
            color: getIconColor(),
            size: 20,
          );
        case OAuthProvider.github:
          return Icon(
            Icons.code,
            color: getIconColor(),
            size: 20,
          );
      }
    }

    final backgroundColor = isDark
        ? (widget.onPressed == null ? Colors.grey.shade800 : Colors.grey.shade900)
        : (widget.onPressed == null ? Colors.grey.shade200 : Colors.white);

    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final textColor = widget.onPressed == null
        ? (isDark ? Colors.grey.shade600 : Colors.grey.shade400)
        : (isDark ? Colors.white : Colors.black87);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor),
        ),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                else
                  getIcon(),
                const SizedBox(width: 12),
                Text(
                  widget.text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
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
