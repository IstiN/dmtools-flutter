import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/styleguide/component_display.dart';
import '../../widgets/styleguide/component_item.dart';
import '../../widgets/molecules/user_profile_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      children: [
        ComponentDisplay(
          title: 'User Profile Button',
          child: Column(
            children: [
              ComponentItem(
                title: 'Logged In State',
                child: _buildProfileExample(
                  loginState: LoginState.loggedIn,
                  hasAvatar: false,
                  hasEmail: true,
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Logged In State with Avatar',
                child: _buildProfileExample(
                  loginState: LoginState.loggedIn,
                  hasAvatar: true,
                  hasEmail: true,
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Logged In State (Username Only)',
                child: _buildProfileExample(
                  loginState: LoginState.loggedIn,
                  hasAvatar: false,
                  hasEmail: false,
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Logged Out State',
                child: _buildProfileExample(
                  loginState: LoginState.loggedOut,
                  hasAvatar: false,
                  hasEmail: false,
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Loading State',
                child: _buildProfileExample(
                  loginState: LoginState.loading,
                  hasAvatar: false,
                  hasEmail: false,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'User Profile Button in Context',
          child: Column(
            children: [
              ComponentItem(
                title: 'In Header (Light Background)',
                child: _buildProfileInContext(
                  bgColor: Colors.white,
                  textColor: Colors.black87,
                  loginState: LoginState.loggedIn,
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'In Header (Dark Background)',
                child: _buildProfileInContext(
                  bgColor: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  loginState: LoginState.loggedIn,
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'In Header (Logged Out)',
                child: _buildProfileInContext(
                  bgColor: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  loginState: LoginState.loggedOut,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a profile button example
  Widget _buildProfileExample({
    required LoginState loginState,
    required bool hasAvatar,
    required bool hasEmail,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserProfileButton(
          username: 'John Doe',
          email: hasEmail ? 'john.doe@example.com' : null,
          avatarUrl: hasAvatar ? 'https://i.pravatar.cc/300' : null,
          onPressed: () {},
          loginState: loginState,
        ),
        SizedBox(height: AppDimensions.spacingS),
        Text(
          'The user profile button displays user information and login state.',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  /// Build a profile button in context
  Widget _buildProfileInContext({
    required Color bgColor,
    required Color textColor,
    required LoginState loginState,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          ),
          child: Row(
            children: [
              Icon(Icons.menu, color: textColor),
              const Spacer(),
              Theme(
                data: ThemeData(
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: textColor),
                  ),
                ),
                child: UserProfileButton(
                  username: 'John Doe',
                  email: 'john.doe@example.com',
                  onPressed: () {},
                  loginState: loginState,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingS),
        Text(
          'The user profile button adapts to different background colors and contexts.',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
} 