import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/accessibility_utils.dart';
import '../../theme/app_theme.dart';
import '../atoms/navigation_icon.dart';

/// Navigation item model for the sidebar
/// Supports both SVG icons (preferred) and Material icons (fallback)
class NavigationItem {
  final IconData? icon;
  final String? svgIconPath;
  final String label;
  final String route;

  const NavigationItem({required this.label, required this.route, this.icon, this.svgIconPath})
    : assert(icon != null || svgIconPath != null, 'Either icon or svgIconPath must be provided');
}

/// Navigation sidebar component that provides consistent navigation across the app
/// Features vertical layout with icons above text labels, matching modern navigation patterns
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
    this.width = 110,
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
      width: width,
      color: bgColor,
      child: Column(
        children: [
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
        ],
      ),
    );
  }
}

/// Private widget for individual navigation items
/// Displays icon above text label, centered vertically
class _NavigationItem extends StatefulWidget {
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
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
  final GlobalKey<State<NavigationIcon>> _iconKey = GlobalKey<State<NavigationIcon>>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isTestMode ? (widget.testDarkMode ?? false) : context.isDarkMode;
    // Active state: cyan color (#06b6d4) from logo dots and ai badge
    const Color activeColor = Color(0xFF06B6D4);
    // Active background: slightly darker/lighter based on theme
    final Color activeBgColor = isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0);
    // Inactive state: theme-aware
    final Color inactiveColor = isDarkMode ? Colors.white : const Color(0xFF424242);

    // Generate test ID based on menu item label
    final testId = generateTestId('menu-item', {'label': widget.item.label.toLowerCase().replaceAll(' ', '-')});
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
      child: Container(
        key: ValueKey(testId),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: widget.isSelected ? activeBgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: handleTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.item.svgIconPath != null
                      ? NavigationIcon(
                          key: _iconKey,
                          svgAssetPath: widget.item.svgIconPath!,
                          color: widget.isSelected ? activeColor : inactiveColor,
                          size: 36,
                        )
                      : Icon(widget.item.icon, color: widget.isSelected ? activeColor : inactiveColor, size: 36),
                  const SizedBox(height: 4),
                  Text(
                    widget.item.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.isSelected ? activeColor : inactiveColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
