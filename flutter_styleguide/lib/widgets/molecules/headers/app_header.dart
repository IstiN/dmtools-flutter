import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_colors.dart';
import '../../atoms/logos/logos.dart';
import '../user_profile_button.dart';
import '../search/search_forms.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showSearch;
  final bool showTitle;
  final bool showHamburgerMenu;
  final Function(String)? onSearch;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onLogoPressed;
  final VoidCallback? onHamburgerPressed;
  final VoidCallback? onThemeToggle;
  final List<Widget>? actions;
  final UserProfileButton? profileButton;
  final bool isTestMode;
  final bool testDarkMode;
  final String searchHintText;
  final double searchWidth;

  const AppHeader({
    super.key,
    this.title = 'DMTools',
    this.showSearch = true,
    this.showTitle = true,
    this.showHamburgerMenu = false,
    this.onSearch,
    this.onProfilePressed,
    this.onLogoPressed,
    this.onHamburgerPressed,
    this.onThemeToggle,
    this.actions,
    this.profileButton,
    this.isTestMode = false,
    this.testDarkMode = false,
    this.searchHintText = 'Search...',
    this.searchWidth = 300,
  });

  @override
  Widget build(BuildContext context) {
    final colors = isTestMode ? (testDarkMode ? AppColors.dark : AppColors.light) : context.colorsListening;
    final isDarkMode = isTestMode ? testDarkMode : context.isDarkMode;
    final theme = Theme.of(context);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor ?? colors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo or Hamburger section
          if (showHamburgerMenu) ...[
            IconButton(
              icon: Icon(
                Icons.menu,
                color: colors.textColor,
                size: 24,
              ),
              onPressed: onHamburgerPressed,
              tooltip: 'Open navigation menu',
            ),
          ] else ...[
            InkWell(
              onTap: onLogoPressed,
              child: Row(
                children: [
                  NetworkNodesLogo(
                    size: LogoSize.small,
                    isDarkMode: isDarkMode,
                    isTestMode: true,
                  ),
                  if (showTitle) ...[
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'DM',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: ' Tools',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Search in the center (if enabled)
          if (showSearch) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: searchWidth),
                    child: SearchForm(
                      hintText: searchHintText,
                      onSearch: onSearch ?? (_) {},
                      isTestMode: isTestMode,
                      testDarkMode: isDarkMode,
                    ),
                  ),
                ),
              ),
            ),
          ] else ...[
            // If no search, use Spacer to push right-side items to the end
            const Spacer(),
          ],

          // Right side actions and profile
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Actions (if provided)
              if (actions != null) ...actions!,

              // Theme toggle
              if (onThemeToggle != null) ...[
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: colors.textColor,
                  ),
                  onPressed: onThemeToggle,
                  tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                ),
              ],

              const SizedBox(width: 8),

              // Profile button
              profileButton ??
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Text(
                      'VK',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
