import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/app_colors.dart';
import '../../atoms/logos/logos.dart';
import '../search/search_forms.dart';
import '../user_profile_button.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';

/// Header component for the application
class AppHeader extends StatelessWidget {
  final String title;
  final bool showSearchBar;
  final List<Widget> actions;
  final VoidCallback? onThemeToggle;
  final SearchCallback? onSearch;
  final LoginState loginState;
  final String username;
  final String? email;
  final String? avatarUrl;
  final VoidCallback? onProfilePressed;
  final bool isTestMode;
  final bool testDarkMode;

  const AppHeader({
    Key? key,
    this.title = 'DMTools',
    this.showSearchBar = true,
    this.actions = const [],
    this.onThemeToggle,
    this.onSearch,
    this.loginState = LoginState.loggedIn,
    this.username = 'User',
    this.email,
    this.avatarUrl,
    this.onProfilePressed,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;
    
    if (isTestMode) {
      isDarkMode = testDarkMode;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }
    
    return Container(
      width: double.infinity,
      color: colors.accentColor,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      child: Column(
        children: [
          // Main header row
          Row(
            children: [
              // Logo
              NetworkNodesLogo(
                size: LogoSize.small,
                color: Colors.white,
                isTestMode: isTestMode,
                testDarkMode: testDarkMode,
              ),
              SizedBox(width: AppDimensions.spacingS),
              
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              
              const Spacer(),
              
              // Actions
              ...actions,
              
              // Theme toggle
              if (onThemeToggle != null) ...[
                SizedBox(width: AppDimensions.spacingS),
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                  ),
                  onPressed: onThemeToggle,
                  tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                ),
              ],
              
              // User profile
              SizedBox(width: AppDimensions.spacingS),
              Theme(
                data: Theme.of(context).copyWith(
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                  ),
                ),
                child: UserProfileButton(
                  username: username,
                  email: email,
                  avatarUrl: avatarUrl,
                  onPressed: onProfilePressed,
                  loginState: loginState,
                  isTestMode: isTestMode,
                  testDarkMode: testDarkMode,
                ),
              ),
            ],
          ),
          
          // Search bar
          if (showSearchBar) ...[
            SizedBox(height: AppDimensions.spacingS),
            CompactSearchForm(
              onSearch: onSearch,
              hintText: 'Search...',
              isTestMode: isTestMode,
              testDarkMode: testDarkMode,
            ),
          ],
        ],
      ),
    );
  }
} 