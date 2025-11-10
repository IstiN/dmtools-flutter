import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';

/// A tab item model for the TabbedHeader component
class HeaderTab {
  /// Unique identifier for the tab
  final String id;

  /// Display title of the tab
  final String title;

  /// Whether this tab can be closed
  final bool closeable;

  /// Optional icon for the tab
  final IconData? icon;

  const HeaderTab({
    required this.id,
    required this.title,
    this.closeable = true,
    this.icon,
  });
}

/// A professional tabbed header component with add/close functionality
///
/// Features:
/// - Multiple tabs with selection state
/// - Add new tab button (+)
/// - Close tab functionality (X button)
/// - Smooth animations and hover effects
/// - Theme-aware styling
/// - Responsive design
/// - Keyboard navigation support
class TabbedHeader extends StatefulWidget {
  /// List of tabs to display
  final List<HeaderTab> tabs;

  /// Currently selected tab ID
  final String? selectedTabId;

  /// Callback when a tab is selected
  final Function(String tabId)? onTabSelected;

  /// Callback when add tab button is pressed
  final VoidCallback? onAddTab;

  /// Callback when a tab close button is pressed
  final Function(String tabId)? onCloseTab;

  /// Maximum number of tabs allowed (null for unlimited)
  final int? maxTabs;

  /// Height of the header
  final double height;

  /// Whether to show the add tab button
  final bool showAddButton;

  /// Optional leading widget (e.g., recent icon)
  final Widget? leading;

  /// Optional trailing actions (e.g., menu button)
  final List<Widget>? actions;

  /// Test mode flag for golden tests
  final bool isTestMode;

  /// Dark mode override for testing
  final bool testDarkMode;

  const TabbedHeader({
    required this.tabs,
    super.key,
    this.selectedTabId,
    this.onTabSelected,
    this.onAddTab,
    this.onCloseTab,
    this.maxTabs,
    this.height = 48,
    this.showAddButton = true,
    this.leading,
    this.actions,
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  @override
  State<TabbedHeader> createState() => _TabbedHeaderState();
}

class _TabbedHeaderState extends State<TabbedHeader> {

  @override
  Widget build(BuildContext context) {
    final colors = widget.isTestMode 
        ? (widget.testDarkMode ? AppColors.dark : AppColors.light) 
        : context.colorsListening;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: colors.textMuted.withValues(alpha: AppDimensions.headerBorderOpacity),
          ),
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppDimensions.headerMinHeight,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppDimensions.spacingS,
            right: AppDimensions.spacingM,
            top: AppDimensions.spacingS,
            bottom: AppDimensions.spacingXs,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tabs section
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < widget.tabs.length; i++) ...[
                          if (i > 0) const SizedBox(width: AppDimensions.spacingXs),
                          _buildTab(widget.tabs[i], colors),
                        ],
                      ],
                    ),
                  ),
                ),

                // Add tab button (right side with other actions)
                if (widget.showAddButton && _canAddMoreTabs) ...[
                  const SizedBox(width: AppDimensions.spacingM),
                  _buildAddButton(colors),
                ],

                // Leading widget (optional) - now on the right after + button
                if (widget.leading != null) ...[
                  const SizedBox(width: AppDimensions.spacingS),
                  widget.leading!,
                ],

                // Trailing actions (optional)
                if (widget.actions != null && widget.actions!.isNotEmpty) ...[
                  const SizedBox(width: AppDimensions.spacingS),
                  ...widget.actions!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get _canAddMoreTabs {
    if (widget.maxTabs == null) return true;
    return widget.tabs.length < widget.maxTabs!;
  }

  Widget _buildTab(HeaderTab tab, dynamic colors) {
    final isSelected = tab.id == widget.selectedTabId;
    final textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onTabSelected?.call(tab.id),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppDimensions.spacingS,
            right: tab.closeable ? AppDimensions.spacingS : AppDimensions.spacingM,
            top: AppDimensions.spacingXs,
            bottom: AppDimensions.spacingXs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tab icon (optional) with color animation
              if (tab.icon != null) ...[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    tab.icon,
                    key: ValueKey('${tab.id}_$isSelected'),
                    size: 14,
                    color: isSelected ? colors.accentColor : colors.textColor,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingXs),
              ],

              // Tab title with smooth style transitions using Heading 5
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                style: textTheme.headlineMedium!.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? colors.accentColor : colors.textColor,
                  letterSpacing: 0.0,
                ),
                child: Text(
                  tab.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Close button
              if (tab.closeable) ...[
                const SizedBox(width: AppDimensions.spacingXs),
                _buildCloseButton(tab.id, colors, isSelected),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(String tabId, dynamic colors, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onCloseTab?.call(tabId),
        child: Padding(
          padding: const EdgeInsets.only(top: 3, left: 2, right: 2),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.close,
              key: ValueKey('${tabId}_close_$isSelected'),
              size: 14,
              color: isSelected 
                  ? colors.accentColor.withValues(alpha: 0.8)
                  : colors.textMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(dynamic colors) {
    return Theme(
      data: Theme.of(context).copyWith(
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: TextStyle(
            color: colors.textColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
      ),
      child: IconButton(
        icon: Icon(Icons.add, size: 20, color: colors.textColor),
        onPressed: widget.onAddTab,
        tooltip: 'Add new tab',
        iconSize: 20,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}

