import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class SidebarNavigation extends StatelessWidget {
  final int selectedIndex;

  const SidebarNavigation({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;

    // Navigation items
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.dashboard_outlined, 'label': 'Dashboard'},
      {'icon': Icons.smart_toy_outlined, 'label': 'Agents'},
      {'icon': Icons.folder_outlined, 'label': 'Workspaces'},
      {'icon': Icons.person_outline, 'label': 'Users'},
      {'icon': Icons.settings_outlined, 'label': 'Settings'},
    ];

    return Container(
      width: 240,
      height: double.infinity,
      color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F7FA),
      child: Column(
        children: [
          // Navigation items
          Expanded(
            child: ListView.builder(
              itemCount: navItems.length,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemBuilder: (context, index) {
                final bool isSelected = index == selectedIndex;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.accentColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      navItems[index]['icon'],
                      color: isSelected ? Colors.white : colors.textSecondary,
                      size: 20,
                    ),
                    title: Text(
                      navItems[index]['label'],
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.white : colors.textColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      // Handle navigation
                    },
                    minLeadingWidth: 24,
                    horizontalTitleGap: 12,
                  ),
                );
              },
            ),
          ),
          
          // User profile button
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF282828) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.borderColor),
            ),
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
        ],
      ),
    );
  }
} 