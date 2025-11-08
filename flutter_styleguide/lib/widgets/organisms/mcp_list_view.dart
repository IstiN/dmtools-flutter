import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// States for the MCP list view
enum McpListState { loading, empty, populated, error }

/// Filter options for MCP configurations
enum McpListFilter { all, active, inactive, error }

/// Sort options for MCP configurations
enum McpListSort { nameAsc, nameDesc, dateAsc, dateDesc, integrationsDesc }

/// A complete list management component for MCP configurations
///
/// This organism provides search, filtering, sorting, and empty state handling
/// for MCP configuration lists. Includes responsive layout support.
class McpListView extends StatefulWidget {
  const McpListView({
    required this.configurations,
    required this.state,
    required this.availableIntegrations,
    this.onConfigurationTap,
    this.onCreateNew,
    this.onDelete,
    this.onEdit,
    this.onViewCode,
    this.onCopyCode,
    this.searchQuery = '',
    this.filter = McpListFilter.all,
    this.sort = McpListSort.nameAsc,
    this.onSearchChanged,
    this.onFilterChanged,
    this.onSortChanged,
    this.showSearch = true,
    this.showFilters = true,
    this.showSort = true,
    this.emptyStateTitle = 'No MCP Configurations',
    this.emptyStateMessage = 'Create your first MCP configuration to get started',
    this.errorMessage,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  final List<McpConfiguration> configurations;
  final McpListState state;
  final List<IntegrationOption> availableIntegrations;
  final ValueChanged<McpConfiguration>? onConfigurationTap;
  final VoidCallback? onCreateNew;
  final Future<bool> Function(McpConfiguration)? onDelete;
  final ValueChanged<McpConfiguration>? onEdit;
  final ValueChanged<McpConfiguration>? onViewCode;
  final Function(BuildContext, McpConfiguration)? onCopyCode;
  final String searchQuery;
  final McpListFilter filter;
  final McpListSort sort;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<McpListFilter>? onFilterChanged;
  final ValueChanged<McpListSort>? onSortChanged;
  final bool showSearch;
  final bool showFilters;
  final bool showSort;
  final String emptyStateTitle;
  final String emptyStateMessage;
  final String? errorMessage;
  final bool isTestMode;
  final bool testDarkMode;

  @override
  State<McpListView> createState() => _McpListViewState();
}

class _McpListViewState extends State<McpListView> {
  late TextEditingController _searchController;
  late List<McpConfiguration> _filteredConfigurations;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _updateFilteredConfigurations();
  }

  @override
  void didUpdateWidget(McpListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.configurations != widget.configurations ||
        oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.filter != widget.filter ||
        oldWidget.sort != widget.sort) {
      _updateFilteredConfigurations();
    }
    if (oldWidget.searchQuery != widget.searchQuery) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilteredConfigurations() {
    final filtered = widget.configurations.where((config) {
      // Apply search filter
      if (widget.searchQuery.isNotEmpty) {
        final query = widget.searchQuery.toLowerCase();
        if (!config.name.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Apply status filter
      switch (widget.filter) {
        case McpListFilter.all:
          return true;
        case McpListFilter.active:
          return config.integrationIds.isNotEmpty;
        case McpListFilter.inactive:
          return config.integrationIds.isEmpty;
        case McpListFilter.error:
          // For demo purposes, consider configs with odd IDs as having errors
          return config.id.hashCode % 2 == 1;
      }
    }).toList();

    // Apply sorting
    switch (widget.sort) {
      case McpListSort.nameAsc:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case McpListSort.nameDesc:
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
      case McpListSort.dateAsc:
        filtered.sort((a, b) => (a.createdAt ?? DateTime.now()).compareTo(b.createdAt ?? DateTime.now()));
        break;
      case McpListSort.dateDesc:
        filtered.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
        break;
      case McpListSort.integrationsDesc:
        filtered.sort((a, b) => b.integrationIds.length.compareTo(a.integrationIds.length));
        break;
    }

    _filteredConfigurations = filtered;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showSearch || widget.showFilters || widget.showSort)
          _ControlsSection(
            searchController: _searchController,
            filter: widget.filter,
            sort: widget.sort,
            onSearchChanged: widget.onSearchChanged,
            onFilterChanged: widget.onFilterChanged,
            onSortChanged: widget.onSortChanged,
            showSearch: widget.showSearch,
            showFilters: widget.showFilters,
            showSort: widget.showSort,
            colors: colors,
          ),
        Flexible(child: _buildContent(colors)),
      ],
    );
  }

  Widget _buildContent(ThemeColorSet colors) {
    switch (widget.state) {
      case McpListState.loading:
        return _LoadingState(colors: colors);
      case McpListState.error:
        return _ErrorState(
          message: widget.errorMessage ?? 'Failed to load MCP configurations',
          onRetry: widget.onCreateNew,
          colors: colors,
        );
      case McpListState.empty:
        return _EmptyState(
          title: widget.emptyStateTitle,
          message: widget.emptyStateMessage,
          onCreateNew: widget.onCreateNew,
          colors: colors,
        );
      case McpListState.populated:
        if (_filteredConfigurations.isEmpty) {
          return _NoResultsState(searchQuery: widget.searchQuery, filter: widget.filter, colors: colors);
        }
        return _ConfigurationList(
          configurations: _filteredConfigurations,
          onConfigurationTap: widget.onConfigurationTap,
          onDelete: widget.onDelete,
          onEdit: widget.onEdit,
          onViewCode: widget.onViewCode,
          onCopyCode: widget.onCopyCode,
          colors: colors,
          isTestMode: widget.isTestMode,
          testDarkMode: widget.testDarkMode,
          availableIntegrations: widget.availableIntegrations,
        );
    }
  }
}

class _ControlsSection extends StatelessWidget {
  const _ControlsSection({
    required this.searchController,
    required this.filter,
    required this.sort,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.showSearch,
    required this.showFilters,
    required this.showSort,
    required this.colors,
  });

  final TextEditingController searchController;
  final McpListFilter filter;
  final McpListSort sort;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<McpListFilter>? onFilterChanged;
  final ValueChanged<McpListSort>? onSortChanged;
  final bool showSearch;
  final bool showFilters;
  final bool showSort;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBg,
        border: Border(bottom: BorderSide(color: colors.borderColor)),
      ),
      child: Column(
        children: [
          if (showSearch) ...[
            _SearchField(controller: searchController, onChanged: onSearchChanged, colors: colors),
            const SizedBox(height: 12),
          ],
          if (showFilters || showSort)
            Row(
              children: [
                if (showFilters) ...[
                  Expanded(
                    child: _FilterDropdown(value: filter, onChanged: onFilterChanged, colors: colors),
                  ),
                  if (showSort) const SizedBox(width: 12),
                ],
                if (showSort)
                  Expanded(
                    child: _SortDropdown(value: sort, onChanged: onSortChanged, colors: colors),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged, required this.colors});

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search configurations...',
        prefixIcon: Icon(Icons.search, color: colors.textColor.withOpacity(0.6)),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: colors.textColor.withOpacity(0.6)),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.accentColor, width: 2),
        ),
        filled: true,
        fillColor: colors.bgColor,
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({required this.value, required this.onChanged, required this.colors});

  final McpListFilter value;
  final ValueChanged<McpListFilter>? onChanged;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<McpListFilter>(
      initialValue: value,
      onChanged: (filter) => filter != null ? onChanged?.call(filter) : null,
      decoration: InputDecoration(
        labelText: 'Filter',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: McpListFilter.all, child: Text('All')),
        DropdownMenuItem(value: McpListFilter.active, child: Text('Active')),
        DropdownMenuItem(value: McpListFilter.inactive, child: Text('Inactive')),
        DropdownMenuItem(value: McpListFilter.error, child: Text('Error')),
      ],
    );
  }
}

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({required this.value, required this.onChanged, required this.colors});

  final McpListSort value;
  final ValueChanged<McpListSort>? onChanged;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<McpListSort>(
      initialValue: value,
      onChanged: (sort) => sort != null ? onChanged?.call(sort) : null,
      decoration: InputDecoration(
        labelText: 'Sort by',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: McpListSort.nameAsc, child: Text('Name A-Z')),
        DropdownMenuItem(value: McpListSort.nameDesc, child: Text('Name Z-A')),
        DropdownMenuItem(value: McpListSort.dateAsc, child: Text('Oldest first')),
        DropdownMenuItem(value: McpListSort.dateDesc, child: Text('Newest first')),
        DropdownMenuItem(value: McpListSort.integrationsDesc, child: Text('Most integrations')),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.colors});

  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colors.accentColor),
          const SizedBox(height: 16),
          Text('Loading configurations...', style: TextStyle(color: colors.textColor.withOpacity(0.7))),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry, required this.colors});

  final String message;
  final VoidCallback? onRetry;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colors.dangerColor),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textColor),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textColor.withOpacity(0.7)),
            ),
            if (onRetry != null) ...[const SizedBox(height: 24), AppButton(text: 'Retry', onPressed: onRetry!)],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.message, required this.onCreateNew, required this.colors});

  final String title;
  final String message;
  final VoidCallback? onCreateNew;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.integration_instructions, size: 64, color: colors.textColor.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textColor),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textColor.withOpacity(0.7)),
            ),
            if (onCreateNew != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: 'Create Your First MCP',
                onPressed: () {
                  debugPrint('🔧 McpListView: Create Your First MCP button pressed');
                  onCreateNew!();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NoResultsState extends StatelessWidget {
  const _NoResultsState({required this.searchQuery, required this.filter, required this.colors});

  final String searchQuery;
  final McpListFilter filter;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: colors.textColor.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'No Results Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.isNotEmpty
                  ? 'No configurations match "$searchQuery"'
                  : 'No configurations match the current filter',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textColor.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfigurationList extends StatelessWidget {
  const _ConfigurationList({
    required this.configurations,
    required this.onConfigurationTap,
    required this.onDelete,
    required this.onEdit,
    required this.onViewCode,
    required this.onCopyCode,
    required this.colors,
    required this.availableIntegrations,
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  final List<McpConfiguration> configurations;
  final ValueChanged<McpConfiguration>? onConfigurationTap;
  final Future<bool> Function(McpConfiguration)? onDelete;
  final ValueChanged<McpConfiguration>? onEdit;
  final ValueChanged<McpConfiguration>? onViewCode;
  final Function(BuildContext, McpConfiguration)? onCopyCode;
  final ThemeColorSet colors;
  final bool isTestMode;
  final bool testDarkMode;
  final List<IntegrationOption> availableIntegrations;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isWideScreen(context)
            ? 3
            : ResponsiveUtils.isTablet(context)
            ? 2
            : 1,
        crossAxisSpacing: AppDimensions.spacingL,
        mainAxisSpacing: AppDimensions.spacingL,
        mainAxisExtent: 280, // Fixed height for MCP cards
      ),
      itemCount: configurations.length,
      itemBuilder: (context, index) {
        final config = configurations[index];
        return McpCard(
          name: config.name,
          status: McpStatus.active, // Using a default status
          integrationIds: config.integrationIds,
          availableIntegrations: availableIntegrations,
          createdAt: config.createdAt,
          onTap: () => onConfigurationTap?.call(config),
          onEdit: () => onEdit?.call(config),
          onDelete: onDelete == null ? null : () async => await onDelete!.call(config),
          onViewCode: () => onViewCode?.call(config),
          onCopyCode: () => onCopyCode?.call(context, config),
          isTestMode: isTestMode,
          testDarkMode: testDarkMode,
        );
      },
    );
  }
}
