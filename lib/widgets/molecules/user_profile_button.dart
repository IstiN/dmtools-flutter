import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/buttons/app_buttons.dart';

/// Login state enum
enum LoginState {
  loggedIn,
  loggedOut,
  loading
}

/// User profile button for displaying user information and login state
class UserProfileButton extends StatelessWidget {
  final String username;
  final String? email;
  final String? avatarUrl;
  final VoidCallback? onPressed;
  final LoginState loginState;
  final bool isTestMode;
  final bool testDarkMode;

  const UserProfileButton({
    Key? key,
    required this.username,
    this.email,
    this.avatarUrl,
    this.onPressed,
    this.loginState = LoginState.loggedIn,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case LoginState.loggedIn:
        return _buildLoggedInButton(context);
      case LoginState.loggedOut:
        return _buildLoggedOutButton(context);
      case LoginState.loading:
        return _buildLoadingButton(context);
    }
  }

  /// Build the logged in user profile button
  Widget _buildLoggedInButton(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXs)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAvatar(),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                username,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (email != null)
                Text(
                  email!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }

  /// Build the logged out button
  Widget _buildLoggedOutButton(BuildContext context) {
    return SecondaryButton(
      text: 'Login',
      onPressed: onPressed,
      icon: Icons.login,
      isTestMode: isTestMode,
      testDarkMode: testDarkMode,
    );
  }

  /// Build the loading button
  Widget _buildLoadingButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Loading...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Build the avatar widget
  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 14,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
      child: avatarUrl == null ? const Icon(Icons.person_outline, size: 16) : null,
    );
  }
} 