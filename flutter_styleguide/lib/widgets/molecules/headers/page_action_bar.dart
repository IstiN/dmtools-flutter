import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../responsive/responsive_builder.dart';

/// A standardized page-level header component that provides a unified pattern
/// for page titles with action buttons. Replaces inconsistent header implementations
/// across the application.
///
/// Features:
/// - Optimized 48px height for better space utilization
/// - Responsive design for desktop, tablet, and mobile
/// - Theme-aware styling with light/dark mode support
/// - Accessibility support with semantic labels
/// - Loading state support for action buttons
/// - Consistent typography and spacing
class PageActionBar extends StatelessWidget {
  /// The main title text displayed in the header
  final String title;

  /// List of action widgets (buttons, icons) displayed on the right side
  final List<Widget>? actions;

  /// Whether the component is in a loading state
  final bool isLoading;

  /// Custom padding override (defaults to standard spacing)
  final EdgeInsets? padding;

  /// Whether to show a bottom border separator
  final bool showBorder;

  /// Test mode flag for golden tests and testing
  final bool isTestMode;

  /// Dark mode override for testing
  final bool testDarkMode;

  /// Maximum number of actions to show on mobile before overflow
  final int maxMobileActions;

  const PageActionBar({
    required this.title,
    super.key,
    this.actions,
    this.isLoading = false,
    this.padding,
    this.showBorder = false,
    this.isTestMode = false,
    this.testDarkMode = false,
    this.maxMobileActions = 2,
  });

  @override
  Widget build(BuildContext context) {
    final colors = isTestMode ? (testDarkMode ? AppColors.dark : AppColors.light) : context.colorsListening;

    return SimpleResponsiveBuilder(
      mobile: (context, constraints) => _buildMobileLayout(context, colors),
      desktop: (context, constraints) => _buildDesktopLayout(context, colors),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, dynamic colors) {
    return _buildBaseContainer(
      colors: colors,
      child: Row(
        children: [
          _buildTitle(context, colors),
          const Spacer(),
          if (actions != null) _buildActions(context, colors, showAll: true),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, dynamic colors) {
    final hasActions = actions != null && actions!.isNotEmpty;

    if (!hasActions) {
      return _buildBaseContainer(
        colors: colors,
        child: _buildTitle(context, colors),
      );
    }

    // If we have few actions, show inline
    if (actions!.length <= maxMobileActions) {
      return _buildBaseContainer(
        colors: colors,
        child: Row(
          children: [
            Expanded(child: _buildTitle(context, colors)),
            const SizedBox(width: AppDimensions.spacingS),
            _buildActions(context, colors, showAll: true),
          ],
        ),
      );
    }

    // For many actions, stack vertically with dynamic height
    return _buildBaseContainer(
      colors: colors,
      dynamicHeight: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(context, colors),
          const SizedBox(height: AppDimensions.spacingXs),
          _buildActions(context, colors, showAll: false),
        ],
      ),
    );
  }

  Widget _buildBaseContainer({
    required dynamic colors,
    required Widget child,
    bool dynamicHeight = false,
  }) {
    final defaultPadding = const EdgeInsets.symmetric(
      horizontal: AppDimensions.spacingM,
      vertical: AppDimensions.spacingS,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: showBorder
            ? Border(
                bottom: BorderSide(
                  color: colors.textMuted.withValues(alpha: AppDimensions.headerBorderOpacity),
                ),
              )
            : null,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AppDimensions.headerMinHeight,
          maxHeight: dynamicHeight ? double.infinity : AppDimensions.headerMinHeight,
        ),
        child: Padding(
          padding: padding ?? defaultPadding,
          child: child,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, dynamic colors) {
    return Semantics(
      header: true,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildActions(BuildContext context, dynamic colors, {required bool showAll}) {
    if (actions == null || actions!.isEmpty) {
      return const SizedBox.shrink();
    }

    if (isLoading) {
      return _buildLoadingIndicator(context, colors);
    }

    final actionsToShow = showAll ? actions! : actions!.take(maxMobileActions).toList();

    return Semantics(
      container: true,
      label: 'Page actions',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < actionsToShow.length; i++) ...[
            if (i > 0) const SizedBox(width: AppDimensions.spacingXs),
            // Use Flexible only when not showing all actions (mobile layout)
            if (!showAll)
              Flexible(
                child: actionsToShow[i],
              )
            else
              actionsToShow[i], // Desktop layout - no constraints
          ],
          if (!showAll && actions!.length > maxMobileActions) ...[
            const SizedBox(width: AppDimensions.spacingXs),
            _buildOverflowMenu(context, colors),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context, dynamic colors) {
    return SizedBox(
      width: AppDimensions.loadingIndicatorSize,
      height: AppDimensions.loadingIndicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: AppDimensions.loadingIndicatorStrokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(colors.accentColor),
      ),
    );
  }

  Widget _buildOverflowMenu(BuildContext context, dynamic colors) {
    final overflowActions = actions!.skip(maxMobileActions).toList();

    return PopupMenuButton<int>(
      icon: Icon(
        Icons.more_vert,
        color: colors.textColor,
        size: AppDimensions.overflowMenuIconSize,
      ),
      tooltip: 'More actions',
      itemBuilder: (context) => [
        for (int i = 0; i < overflowActions.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: overflowActions[i],
          ),
      ],
    );
  }
}
