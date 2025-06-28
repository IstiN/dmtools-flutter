import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/styleguide/component_display.dart';
import '../../widgets/molecules/user_profile_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      children: [
        ComponentDisplay(
          title: 'User Profile Button - Logged In',
          description: 'User profile button with user name and avatar',
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UserProfileButton(
                    userName: 'John Doe',
                    email: 'john.doe@example.com',
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UserProfileButton(
                    userName: 'Jane Smith',
                    avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'User Profile Button with Dropdown',
          description: 'User profile button with dropdown menu',
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UserProfileButton(
                    userName: 'Vladimir Klyshevich',
                    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
                    dropdownItems: [
                      UserProfileDropdownItem(
                        icon: Icons.settings,
                        label: 'Settings',
                        onTap: () {},
                      ),
                      UserProfileDropdownItem(
                        icon: Icons.dark_mode,
                        label: 'Dark mode',
                        onTap: () {},
                      ),
                      UserProfileDropdownItem(
                        icon: Icons.logout,
                        label: 'Logout',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'User Profile Button - Logged Out',
          description: 'User profile button in logged out state',
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UserProfileButton(
                    onPressed: () {},
                    loginState: LoginState.loggedOut,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'User Profile Button - Loading',
          description: 'User profile button in loading state',
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UserProfileButton(
                    onPressed: () {},
                    loginState: LoginState.loading,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'User Profile Button - Dark Mode',
          description: 'User profile button in dark mode',
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            color: Colors.grey[850],
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserProfileButton(
                      userName: 'John Doe',
                      email: 'john.doe@example.com',
                      onPressed: () {},
                      isTestMode: true,
                      testDarkMode: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserProfileButton(
                      userName: 'Vladimir Klyshevich',
                      avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
                      isTestMode: true,
                      testDarkMode: true,
                      dropdownItems: [
                        UserProfileDropdownItem(
                          icon: Icons.settings,
                          label: 'Settings',
                          onTap: () {},
                        ),
                        UserProfileDropdownItem(
                          icon: Icons.dark_mode,
                          label: 'Dark mode',
                          onTap: () {},
                        ),
                        UserProfileDropdownItem(
                          icon: Icons.logout,
                          label: 'Logout',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserProfileButton(
                      onPressed: () {},
                      loginState: LoginState.loggedOut,
                      isTestMode: true,
                      testDarkMode: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserProfileButton(
                      onPressed: () {},
                      loginState: LoginState.loading,
                      isTestMode: true,
                      testDarkMode: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 