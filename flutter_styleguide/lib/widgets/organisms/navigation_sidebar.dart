import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../atoms/logos/logos.dart';

/// Navigation item model for the sidebar
class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

/// Navigation sidebar component that provides consistent navigation across the app
class NavigationSidebar extends StatelessWidget {
  final List<NavigationItem> items;
  final bool isMobile;
  final String? currentRoute;
  final VoidCallback? onItemTap;
  final bool showLogo;
  final bool showFooter;
  final double width;
  final bool isTestMode;
  final bool? testDarkMode;

  const NavigationSidebar({
    required this.items,
    this.isMobile = false,
    this.currentRoute,
    this.onItemTap,
    this.showLogo = true,
    this.showFooter = true,
    this.width = 240,
    this.isTestMode = false,
    this.testDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isTestMode ? (testDarkMode ?? false) : context.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;
    final Color bgColor = isDarkMode ? AppColors.darkSidebarBg : AppColors.lightSidebarBg;

    return Container(
      width: width,
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile && showLogo) ...[
            Container(
              padding: const EdgeInsets.all(12),
              child: NetworkNodesLogo(
                size: LogoSize.small,
                isDarkMode: isDarkMode,
                isTestMode: isTestMode,
              ),
            ),
            Divider(color: colors.dividerColor, height: 1),
          ],
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (int i = 0; i < items.length; i++)
                  _NavigationItem(
                    item: items[i],
                    isSelected: currentRoute == items[i].route,
                    onTap: () {
                      if (onItemTap != null) {
                        onItemTap!();
                      }
                      if (!isTestMode) {
                        context.go(items[i].route);
                        if (isMobile) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    isTestMode: isTestMode,
                    testDarkMode: testDarkMode,
                  ),
              ],
            ),
          ),
          if (!isMobile && showFooter) ...[
            Divider(color: colors.dividerColor, height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '© 2025 DMTools. All rights reserved.',
                style: TextStyle(
                  fontSize: 11,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Private widget for individual navigation items
class _NavigationItem extends StatelessWidget {
  final NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isTestMode;
  final bool? testDarkMode;

  const _NavigationItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.isTestMode = false,
    this.testDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isTestMode ? (testDarkMode ?? false) : context.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;

    final Color textColor = colors.textSecondary;
    const Color selectedTextColor = AppColors.primaryTextOnAccent;
    const Color selectedBgColor = AppColors.selectedBgColor;
    final Color hoverBgColor = isDarkMode ? AppColors.darkHoverBgColor : AppColors.lightHoverBgColor;

    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isSelected ? selectedBgColor : Colors.transparent,
        borderRadius: BorderRadius.zero,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.zero,
          hoverColor: isSelected ? Colors.transparent : hoverBgColor,
          onTap: onTap,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isSelected ? selectedTextColor : textColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? selectedTextColor : textColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
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

/// Extension to add theme access for the component
extension _ThemeContext on BuildContext {
  bool get isDarkMode {
    // This should match the main app's theme detection
    return Theme.of(this).brightness == Brightness.dark;
  }
}
