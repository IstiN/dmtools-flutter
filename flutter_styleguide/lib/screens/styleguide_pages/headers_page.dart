import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/styleguide/component_display.dart';
import '../../widgets/molecules/headers/headers.dart';
import '../../widgets/molecules/user_profile_button.dart';
import '../../widgets/atoms/buttons/app_buttons.dart';

class HeadersPage extends StatelessWidget {
  const HeadersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      children: [
        ComponentDisplay(
          title: 'App Header - With Title',
          description: 'Main application header with logo, title, search, and user profile dropdown',
          child: Column(
            children: [
              const SizedBox(height: 20),
              AppHeader(
                searchHintText: 'Search agents and apps...',
                searchWidth: 400,
                onSearch: (_) {},
                onProfilePressed: () {},
                onLogoPressed: () {},
                onThemeToggle: () {},
                isTestMode: true,
                profileButton: const UserProfileButton(
                  userName: 'Test User',
                  isTestMode: true,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                color: Colors.grey[850],
                child: AppHeader(
                  searchHintText: 'Search agents and apps...',
                  searchWidth: 400,
                  onSearch: (_) {},
                  onProfilePressed: () {},
                  onLogoPressed: () {},
                  onThemeToggle: () {},
                  isTestMode: true,
                  testDarkMode: true,
                  profileButton: const UserProfileButton(
                    userName: 'Test User',
                    isTestMode: true,
                    testDarkMode: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'App Header - Without Title',
          description: 'App header with logo only (no title text)',
          child: Column(
            children: [
              const SizedBox(height: 20),
              AppHeader(
                searchHintText: 'Search agents and apps...',
                searchWidth: 400,
                showTitle: false,
                onSearch: (_) {},
                onProfilePressed: () {},
                onLogoPressed: () {},
                onThemeToggle: () {},
                isTestMode: true,
                profileButton: const UserProfileButton(
                  userName: 'Test User',
                  isTestMode: true,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                color: Colors.grey[850],
                child: AppHeader(
                  searchHintText: 'Search agents and apps...',
                  searchWidth: 400,
                  showTitle: false,
                  onSearch: (_) {},
                  onProfilePressed: () {},
                  onLogoPressed: () {},
                  onThemeToggle: () {},
                  isTestMode: true,
                  testDarkMode: true,
                  profileButton: const UserProfileButton(
                    userName: 'Test User',
                    isTestMode: true,
                    testDarkMode: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'App Header - Without Search',
          description: 'App header without search bar',
          child: Column(
            children: [
              const SizedBox(height: 20),
              AppHeader(
                showSearch: false,
                onProfilePressed: () {},
                onLogoPressed: () {},
                onThemeToggle: () {},
                isTestMode: true,
                profileButton: const UserProfileButton(
                  userName: 'Test User',
                  isTestMode: true,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'App Header - With Custom Profile Button',
          description: 'App header with a custom profile button',
          child: Column(
            children: [
              const SizedBox(height: 20),
              AppHeader(
                searchHintText: 'Search agents and apps...',
                searchWidth: 400,
                onSearch: (_) {},
                onLogoPressed: () {},
                onThemeToggle: () {},
                profileButton: UserProfileButton(
                  userName: 'John Doe',
                  email: 'john.doe@example.com',
                  avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
                  isTestMode: true,
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
                isTestMode: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'App Header - Logged Out State',
          description: 'App header with logged out profile button',
          child: Column(
            children: [
              const SizedBox(height: 20),
              AppHeader(
                searchHintText: 'Search agents and apps...',
                searchWidth: 400,
                onSearch: (_) {},
                onLogoPressed: () {},
                onThemeToggle: () {},
                profileButton: const UserProfileButton(
                  loginState: LoginState.loggedOut,
                  isTestMode: true,
                ),
                isTestMode: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'Section Header',
          description: 'Header for content sections with optional view all button',
          child: Column(
            children: [
              const SizedBox(height: 20),
              BaseSectionHeader(
                title: 'Recent Agents',
                subtitle: '12 agents updated in the last 24 hours',
                viewAllText: 'View All',
                onViewAll: () {},
                isTestMode: true,
              ),
              const SizedBox(height: 20),
              BaseSectionHeader(
                title: 'Applications',
                viewAllText: 'View All',
                onViewAll: () {},
                isTestMode: true,
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.grey[850],
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                child: BaseSectionHeader(
                  title: 'Recent Agents',
                  subtitle: '12 agents updated in the last 24 hours',
                  viewAllText: 'View All',
                  onViewAll: () {},
                  isTestMode: true,
                  testDarkMode: true,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'Section Header - With Icon',
          description: 'Section header with leading icon',
          child: Column(
            children: [
              const SizedBox(height: 20),
              BaseSectionHeader(
                title: 'Recent Agents',
                leading: const Icon(Icons.smart_toy_outlined, size: 28),
                viewAllText: 'View All',
                onViewAll: () {},
                isTestMode: true,
              ),
              const SizedBox(height: 20),
              BaseSectionHeader(
                title: 'Applications',
                leading: const Icon(Icons.apps_outlined, size: 28),
                viewAllText: 'View All',
                onViewAll: () {},
                isTestMode: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // PageActionBar Examples - Direct Component Usage
        const Divider(),
        const SizedBox(height: AppDimensions.spacingL),

        // Basic page action bar
        const PageActionBar(
          title: 'Basic Page Action Bar',
          isTestMode: true,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Page action bar with actions
        PageActionBar(
          title: 'Page with Actions',
          actions: [
            PrimaryButton(
              text: 'Primary',
              onPressed: () {},
              size: ButtonSize.small,
              isTestMode: true,
            ),
            SecondaryButton(
              text: 'Secondary',
              onPressed: () {},
              size: ButtonSize.small,
              isTestMode: true,
            ),
            AppIconButton(
              text: 'Add',
              icon: Icons.add,
              onPressed: () {},
              size: ButtonSize.small,
              isTestMode: true,
            ),
          ],
          isTestMode: true,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Page action bar with border
        PageActionBar(
          title: 'Page with Border',
          showBorder: true,
          actions: [
            PrimaryButton(
              text: 'Action',
              onPressed: () {},
              size: ButtonSize.small,
              isTestMode: true,
            ),
          ],
          isTestMode: true,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Loading state page action bar
        PageActionBar(
          title: 'Loading Actions',
          isLoading: true,
          actions: [
            PrimaryButton(
              text: 'Process',
              onPressed: () {},
              size: ButtonSize.small,
              isTestMode: true,
            ),
          ],
          isTestMode: true,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Mobile layout demonstration
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: PageActionBar(
            title: 'Mobile Page Layout',
            actions: [
              PrimaryButton(
                text: 'Action 1',
                onPressed: () {},
                size: ButtonSize.small,
                isTestMode: true,
              ),
              SecondaryButton(
                text: 'Action 2',
                onPressed: () {},
                size: ButtonSize.small,
                isTestMode: true,
              ),
              OutlineButton(
                text: 'Action 3',
                onPressed: () {},
                size: ButtonSize.small,
                isTestMode: true,
              ),
              AppTextButton(
                text: 'Action 4',
                onPressed: () {},
                size: ButtonSize.small,
                isTestMode: true,
              ),
            ],
            isTestMode: true,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
      ],
    );
  }
}
