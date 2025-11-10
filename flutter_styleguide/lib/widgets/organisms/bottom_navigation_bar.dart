import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'navigation_sidebar.dart';
import '../../theme/app_theme.dart';
import '../atoms/navigation_icon.dart';

/// Bottom navigation bar component for mobile devices
/// Transforms the vertical sidebar navigation into horizontal bottom tabs
class BottomNavigationBarWidget extends StatelessWidget {
  final List<NavigationItem> items;
  final String? currentRoute;
  final VoidCallback? onItemTap;
  final bool isTestMode;
  final bool? testDarkMode;

  const BottomNavigationBarWidget({
    required this.items,
    this.currentRoute,
    this.onItemTap,
    this.isTestMode = false,
    this.testDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get theme-aware background color
    final isDarkMode = isTestMode ? (testDarkMode ?? false) : context.isDarkMode;
    // Use darker charcoal background matching the design, but theme-aware
    final Color bgColor = isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5);

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < items.length; i++)
              Expanded(
                child: _BottomNavItem(
                  item: items[i],
                  isSelected: currentRoute == items[i].route,
                  onTap: () {
                    if (onItemTap != null) {
                      onItemTap!();
                    }
                    if (!isTestMode) {
                      context.go(items[i].route);
                    }
                  },
                  isTestMode: isTestMode,
                  testDarkMode: testDarkMode,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Private widget for individual bottom navigation items
class _BottomNavItem extends StatefulWidget {
  final NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isTestMode;
  final bool? testDarkMode;

  const _BottomNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.isTestMode = false,
    this.testDarkMode,
  });

  @override
  State<_BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<_BottomNavItem> {
  final GlobalKey<State<NavigationIcon>> _iconKey = GlobalKey<State<NavigationIcon>>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isTestMode ? (widget.testDarkMode ?? false) : context.isDarkMode;
    // Active state: cyan color (#06b6d4) from logo dots and ai badge
    const Color activeColor = Color(0xFF06B6D4);
    // Inactive state: theme-aware
    final Color inactiveColor = isDarkMode ? Colors.white : const Color(0xFF424242);

    // Generate semantic label for accessibility
    final semanticLabel = '${widget.item.label} navigation item${widget.isSelected ? ', selected' : ''}';

    void handleTap() {
      // Trigger animation if icon exists
      if (widget.item.svgIconPath != null) {
        final iconState = _iconKey.currentState;
        // Use dynamic to access triggerAnimation method
        if (iconState != null) {
          try {
            (iconState as dynamic).triggerAnimation();
          } catch (_) {
            // Animation trigger failed, continue with tap
          }
        }
      }
      // Execute the actual tap handler
      widget.onTap();
    }

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: true,
      selected: widget.isSelected,
      onTap: handleTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: handleTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.item.svgIconPath != null
                    ? NavigationIcon(
                        key: _iconKey,
                        svgAssetPath: widget.item.svgIconPath!,
                        color: widget.isSelected ? activeColor : inactiveColor,
                        size: 32,
                      )
                    : Icon(
                        widget.item.icon,
                        color: widget.isSelected ? activeColor : inactiveColor,
                        size: 32,
                      ),
                const SizedBox(height: 4),
                Text(
                  widget.item.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isSelected ? activeColor : inactiveColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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

