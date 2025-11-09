import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Demo page showcasing UI components from the styleguide
class ComponentsDemoPage extends StatefulWidget {
  const ComponentsDemoPage({super.key});

  @override
  State<ComponentsDemoPage> createState() => _ComponentsDemoPageState();
}

class _ComponentsDemoPageState extends State<ComponentsDemoPage> {
  // Tabbed Header state
  List<HeaderTab> _tabs = [
    const HeaderTab(id: '1', title: 'Dashboard', icon: Icons.dashboard),
    const HeaderTab(id: '2', title: 'Analytics', icon: Icons.bar_chart),
    const HeaderTab(id: '3', title: 'Reports', icon: Icons.description),
    const HeaderTab(id: '4', title: 'Settings', icon: Icons.settings, closeable: false),
  ];
  String _selectedTabId = '1';
  int _tabCounter = 5;

  void _handleAddTab() {
    setState(() {
      _tabs = [
        ..._tabs,
        HeaderTab(
          id: '$_tabCounter',
          title: 'Tab $_tabCounter',
          icon: Icons.fiber_new,
        ),
      ];
      _selectedTabId = '$_tabCounter';
      _tabCounter++;
    });
  }

  void _handleCloseTab(String tabId) {
    setState(() {
      _tabs = _tabs.where((tab) => tab.id != tabId).toList();
      // If we closed the selected tab, select the first available tab
      if (_selectedTabId == tabId && _tabs.isNotEmpty) {
        _selectedTabId = _tabs.first.id;
      }
    });
  }

  void _handleTabSelected(String tabId) {
    setState(() {
      _selectedTabId = tabId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Column(
      children: [
        // Tabbed Header Demo
        Expanded(
          child: ColoredBox(
            color: colors.bgColor,
            child: Column(
              children: [
                // Header with Tabs
                TabbedHeader(
                  tabs: _tabs,
                  selectedTabId: _selectedTabId,
                  onTabSelected: _handleTabSelected,
                  onAddTab: _handleAddTab,
                  onCloseTab: _handleCloseTab,
                ),

                // Content Area
                Expanded(
                  child: _buildTabContent(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    final colors = context.colorsListening;
    final selectedTab = _tabs.firstWhere(
      (tab) => tab.id == _selectedTabId,
      orElse: () => _tabs.first,
    );

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab title
          Text(
            selectedTab.title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingM),

          // Tab description
          Text(
            'This is the content area for ${selectedTab.title}.',
            style: TextStyle(
              fontSize: 16,
              color: colors.textMuted,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // Demo cards
          Expanded(
            child: GridView.count(
              crossAxisCount: ResponsiveUtils.isWideScreen(context) ? 3 : 1,
              mainAxisSpacing: AppDimensions.spacingM,
              crossAxisSpacing: AppDimensions.spacingM,
              childAspectRatio: 2,
              children: [
                _buildDemoCard(
                  'Feature 1',
                  'This card demonstrates content in ${selectedTab.title}',
                  Icons.star,
                  colors,
                ),
                _buildDemoCard(
                  'Feature 2',
                  'Another feature card example',
                  Icons.favorite,
                  colors,
                ),
                _buildDemoCard(
                  'Feature 3',
                  'More content to showcase',
                  Icons.lightbulb,
                  colors,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // Instructions
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: colors.accentColor.withValues(alpha: 0.3),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colors.accentColor,
                    size: 24,
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tabbed Header Demo',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colors.textColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Text(
                          '• Click tabs to switch between views\n'
                          '• Click the + button to add new tabs\n'
                          '• Click X to close tabs (except Settings)\n'
                          '• Works in both light and dark themes',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(String title, String description, IconData icon, dynamic colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: colors.accentColor,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colors.textColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

