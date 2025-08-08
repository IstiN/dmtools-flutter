import 'dart:async';

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_dimensions.dart';

import '../responsive/responsive_builder.dart';

/// Data structure for table column definitions
class DataTableColumn {
  final String key;
  final String label;
  final bool sortable;
  final double? width;
  final TextAlign? alignment;

  const DataTableColumn({required this.key, required this.label, this.sortable = false, this.width, this.alignment});
}

/// A paginated data table component with search functionality
/// Supports custom row rendering, pagination, and responsive design
class DMPaginatedDataTable extends StatefulWidget {
  /// Column definitions with headers and sort options
  final List<DataTableColumn> columns;

  /// Current page data to display
  final List<Map<String, dynamic>> data;

  /// Custom row renderer function
  final Widget Function(Map<String, dynamic>) rowBuilder;

  /// Total number of items across all pages
  final int totalItems;

  /// Current page index (0-based)
  final int currentPage;

  /// Number of items per page
  final int pageSize;

  /// Callback when page changes
  final Function(int) onPageChanged;

  /// Callback when search query changes
  final Function(String?)? onSearchChanged;

  /// Current search query
  final String? searchQuery;

  /// Whether to show search functionality
  final bool showSearch;

  /// Whether to show pagination controls
  final bool showPagination;

  /// Whether to show loading state
  final bool isLoading;

  /// Message when no data available
  final String emptyMessage;

  /// Search input placeholder text
  final String searchPlaceholder;

  const DMPaginatedDataTable({
    required this.columns,
    required this.data,
    required this.rowBuilder,
    required this.totalItems,
    required this.onPageChanged,
    this.currentPage = 0,
    this.pageSize = 50,
    this.onSearchChanged,
    this.searchQuery,
    this.showSearch = true,
    this.showPagination = true,
    this.isLoading = false,
    this.emptyMessage = 'No data available',
    this.searchPlaceholder = 'Search...',
    super.key,
  });

  @override
  State<DMPaginatedDataTable> createState() => _DMPaginatedDataTableState();
}

class _DMPaginatedDataTableState extends State<DMPaginatedDataTable> {
  late final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery ?? '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(DMPaginatedDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery && _searchController.text != widget.searchQuery) {
      _searchController.text = widget.searchQuery ?? '';
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      // ignore: avoid_print
      print('🔍 Debounced Search Triggered: "$value"');
      if (widget.onSearchChanged != null) {
        widget.onSearchChanged!(value.isEmpty ? null : value);
      }
    });
  }

  int get totalPages => (widget.totalItems / widget.pageSize).ceil();

  @override
  Widget build(BuildContext context) {
    return SimpleResponsiveBuilder(
      mobile: (context, constraints) => _buildMobileLayout(),
      desktop: (context, constraints) => _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    final colors = context.colorsListening;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBg,
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showSearch) _buildSearchBar(),
          if (widget.showSearch) Divider(color: colors.borderColor.withValues(alpha: 0.1), height: 1),
          _buildTableContainer(),
          if (widget.showPagination) Divider(color: colors.borderColor.withValues(alpha: 0.1), height: 1),
          if (widget.showPagination) _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showSearch) _buildSearchBar(),
        if (widget.showSearch) const SizedBox(height: AppDimensions.spacingM),
        _buildMobileTableContainer(),
        if (widget.showPagination) const SizedBox(height: AppDimensions.spacingM),
        if (widget.showPagination) _buildPaginationControls(),
      ],
    );
  }

  Widget _buildSearchBar() {
    final colors = context.colorsListening;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.bgColor.withValues(alpha: 0.5),
                  border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: TextStyle(color: colors.textColor, fontSize: 14, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    hintText: widget.searchPlaceholder,
                    hintStyle: TextStyle(color: colors.textMuted.withValues(alpha: 0.6), fontSize: 14),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.search_outlined, color: colors.textMuted.withValues(alpha: 0.7), size: 20),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.clear_outlined,
                                color: colors.textMuted.withValues(alpha: 0.7),
                                size: 18,
                              ),
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${widget.totalItems} items',
                  style: TextStyle(color: colors.textMuted, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContainer() {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    if (widget.data.isEmpty) {
      return _buildEmptyState();
    }

    return Column(mainAxisSize: MainAxisSize.min, children: [_buildTableHeader(), _buildTableBody()]);
  }

  Widget _buildMobileTableContainer() {
    final colors = context.colorsListening;

    if (widget.isLoading) {
      return _buildLoadingState();
    }

    if (widget.data.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: colors.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            final item = widget.data[index];
            return widget.rowBuilder(item);
          },
          separatorBuilder: (context, index) => Divider(color: colors.borderColor, height: 1),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    final colors = context.colorsListening;

    return Container(
      height: 48, // Fixed height for consistency
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: colors.hoverBg.withValues(alpha: 0.5),
        border: Border(bottom: BorderSide(color: colors.borderColor.withValues(alpha: 0.3))),
      ),
      child: Row(
        children: widget.columns.asMap().entries.map((entry) {
          final index = entry.key;
          final column = entry.value;
          return Expanded(
            flex: column.width?.round() ?? 1,
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 16 : 0, // Add left padding to first column
                right: 16,
              ),
              child: Text(
                column.label.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: colors.textColor.withValues(alpha: 0.8),
                  letterSpacing: 1.0,
                ),
                textAlign: column.alignment ?? TextAlign.left,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTableBody() {
    final colors = context.colorsListening;

    return Column(
      children: widget.data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == widget.data.length - 1;

        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: !isLast ? Border(bottom: BorderSide(color: colors.borderColor.withValues(alpha: 0.1))) : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Optional: Add row tap handler if needed
              },
              hoverColor: colors.hoverBg.withValues(alpha: 0.4),
              splashColor: colors.accentColor.withValues(alpha: 0.1),
              child: Container(
                constraints: const BoxConstraints(minHeight: 56), // Minimum professional height
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL, vertical: 12),
                child: widget.rowBuilder(item),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadingState() {
    final colors = context.colorsListening;

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colors.accentColor),
                strokeWidth: 2,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text('Loading data...', style: TextStyle(color: colors.textSecondary, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final colors = context.colorsListening;

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.textMuted.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(Icons.search_off_outlined, size: 32, color: colors.textMuted.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(widget.emptyMessage, style: TextStyle(color: colors.textSecondary, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildPaginationInfo(), _buildPaginationButtons()],
      ),
    );
  }

  Widget _buildPaginationInfo() {
    final colors = context.colorsListening;
    final startItem = widget.currentPage * widget.pageSize + 1;
    final endItem = ((widget.currentPage + 1) * widget.pageSize).clamp(0, widget.totalItems);

    return Text(
      'Showing $startItem-$endItem of ${widget.totalItems} items',
      style: TextStyle(color: colors.textSecondary, fontSize: 14),
    );
  }

  Widget _buildPaginationButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous button
        _buildPaginationArrowButton(
          icon: Icons.chevron_left,
          isEnabled: widget.currentPage > 0,
          onPressed: widget.currentPage > 0 ? () => widget.onPageChanged(widget.currentPage - 1) : null,
        ),
        const SizedBox(width: AppDimensions.spacingS),

        // Page numbers
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingS),
          child: Row(mainAxisSize: MainAxisSize.min, children: _buildPageNumbers()),
        ),

        const SizedBox(width: AppDimensions.spacingS),

        // Next button
        _buildPaginationArrowButton(
          icon: Icons.chevron_right,
          isEnabled: widget.currentPage < totalPages - 1,
          onPressed: widget.currentPage < totalPages - 1 ? () => widget.onPageChanged(widget.currentPage + 1) : null,
        ),
      ],
    );
  }

  Widget _buildPaginationArrowButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onPressed,
  }) {
    final colors = context.colorsListening;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isEnabled ? colors.cardBg : colors.bgColor,
        border: Border.all(
          color: isEnabled ? colors.borderColor.withValues(alpha: 0.3) : colors.borderColor.withValues(alpha: 0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Icon(icon, size: 18, color: isEnabled ? colors.textColor : colors.textMuted.withValues(alpha: 0.5)),
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    final colors = context.colorsListening;
    final List<Widget> pageButtons = [];
    const int maxVisiblePages = 5;

    // Handle edge case where there are no pages
    if (totalPages <= 0) {
      return pageButtons;
    }

    int startPage = (widget.currentPage - maxVisiblePages ~/ 2).clamp(
      0,
      (totalPages - maxVisiblePages).clamp(0, totalPages),
    );
    final int endPage = (startPage + maxVisiblePages - 1).clamp(0, totalPages - 1);

    // Adjust start if we're near the end
    if (endPage - startPage < maxVisiblePages - 1 && totalPages > 0) {
      startPage = (endPage - maxVisiblePages + 1).clamp(0, totalPages - 1);
    }

    for (int i = startPage; i <= endPage && i < totalPages; i++) {
      final isSelected = i == widget.currentPage;

      pageButtons.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? colors.accentColor : Colors.transparent,
            border: !isSelected
                ? Border.all(color: colors.borderColor.withValues(alpha: 0.3))
                : Border.all(color: colors.accentColor),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => widget.onPageChanged(i),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? colors.whiteColor : colors.textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return pageButtons;
  }
}
