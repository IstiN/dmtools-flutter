import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

// Navigation item model
class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.label,
  });
}

class SidebarNavigation extends StatelessWidget {
  final int selectedIndex;

  const SidebarNavigation({
    required this.selectedIndex, Key? key,
  }) : super(key: key);

  // Const navigation items with proper typing
  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    _NavItem(icon: Icons.smart_toy_outlined, label: 'Agents'),
    _NavItem(icon: Icons.folder_outlined, label: 'Workspaces'),
    _NavItem(icon: Icons.person_outline, label: 'Users'),
    _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return ColoredBox(
      color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F7FA),
      child: SizedBox(
        width: 240,
        height: double.infinity,
        child: Column(
          children: [
            // Navigation items
            Expanded(
              child: ListView.builder(
                itemCount: _navItems.length,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                itemBuilder: (context, index) {
                  final bool isSelected = index == selectedIndex;
                  final navItem = _navItems[index];

                  return _NavItemWidget(
                    item: navItem,
                    isSelected: isSelected,
                    onTap: () {
                      // Handle navigation
                    },
                  );
                },
              ),
            ),

            // User profile button
            const _UserProfileSection(),
          ],
        ),
      ),
    );
  }
}

// Private widget for navigation item
class _NavItemWidget extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? colors.accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(
            item.icon,
            color: isSelected ? Colors.white : colors.textSecondary,
            size: 20,
          ),
          title: Text(
            item.label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : colors.textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: onTap,
          minLeadingWidth: 24,
          horizontalTitleGap: 12,
        ),
      ),
    );
  }
}

// Private widget for user profile section
class _UserProfileSection extends StatelessWidget {
  const _UserProfileSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDarkMode = context.isDarkMode;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF282828) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colors.accentColor,
                radius: 16,
                child: const Text(
                  'JD',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colors.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.logout,
                color: colors.textSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
