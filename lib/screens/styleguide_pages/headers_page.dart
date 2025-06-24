import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/styleguide/component_display.dart';
import '../../widgets/styleguide/component_item.dart';
import '../../widgets/molecules/headers/headers.dart';
import '../../widgets/molecules/user_profile_button.dart';

class HeadersPage extends StatelessWidget {
  const HeadersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      children: [
        ComponentDisplay(
          title: 'App Header',
          child: Column(
            children: [
              ComponentItem(
                title: 'Default Header',
                child: _buildHeaderExample(
                  showSearchBar: true,
                  loginState: LoginState.loggedIn,
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Header without Search Bar',
                child: _buildHeaderExample(
                  showSearchBar: false,
                  loginState: LoginState.loggedIn,
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Header with Logged Out State',
                child: _buildHeaderExample(
                  showSearchBar: true,
                  loginState: LoginState.loggedOut,
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Header with Loading State',
                child: _buildHeaderExample(
                  showSearchBar: true,
                  loginState: LoginState.loading,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Section Headers',
          child: Column(
            children: [
              ComponentItem(
                title: 'Standard Section Header',
                child: StandardSectionHeader(
                  title: 'Section Title',
                  onViewAll: () {},
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Underlined Section Header',
                child: UnderlinedSectionHeader(
                  title: 'Section With Underline',
                  onViewAll: () {},
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Section Header with Custom Trailing Widget',
                child: StandardSectionHeader(
                  title: 'Custom Actions',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {},
                        tooltip: 'Filter',
                      ),
                      IconButton(
                        icon: const Icon(Icons.sort),
                        onPressed: () {},
                        tooltip: 'Sort',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a header example with different configurations
  Widget _buildHeaderExample({
    required bool showSearchBar,
    required LoginState loginState,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHeader(
          title: 'DMTools',
          showSearchBar: showSearchBar,
          onThemeToggle: () {},
          onSearch: (query) {},
          loginState: loginState,
          username: 'John Doe',
          email: 'john.doe@example.com',
          onProfilePressed: () {},
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
              tooltip: 'Notifications',
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spacingS),
        Text(
          'The app header includes the logo, title, search bar, theme toggle, and user profile.',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
} 