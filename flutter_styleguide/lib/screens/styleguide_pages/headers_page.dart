import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class HeadersPage extends StatefulWidget {
  const HeadersPage({super.key});

  @override
  State<HeadersPage> createState() => _HeadersPageState();
}

class _HeadersPageState extends State<HeadersPage> {
  // State for tabbed header example with icons
  List<HeaderTab> _tabs = [
    const HeaderTab(id: '1', title: 'Dashboard', icon: Icons.dashboard),
    const HeaderTab(id: '2', title: 'Projects', icon: Icons.folder),
    const HeaderTab(id: '3', title: 'Settings', icon: Icons.settings, closeable: false),
  ];
  String _selectedTabId = '1';
  int _tabCounter = 4;

  // State for simple tabbed header example without icons
  List<HeaderTab> _simpleTabs = [
    const HeaderTab(id: '1', title: 'Overview'),
    const HeaderTab(id: '2', title: 'Details'),
    const HeaderTab(id: '3', title: 'History'),
  ];
  String _selectedSimpleTabId = '1';
  int _simpleTabCounter = 4;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      children: [
        ComponentDisplay(
          title: 'App Header - With Title',
          description: 'Main application header with logo, title, search, and user profile dropdown',
          child: Column(
            children: [
              const SizedBox(height: 20),
              AppHeader(
                searchHintText: 'Search agents and apps...',
                searchWidth: 400,
                onSearch: (_) {},
                onProfilePressed: () {},
                onLogoPressed: () {},
                onThemeToggle: () {},
                isTestMode: true,
                profileButton: const UserProfileButton(
                  userName: 'Test User',
                  isTestMode: true,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                color: Colors.grey[850],
                child: AppHeader(
                  searchHintText: 'Search agents and apps...',
                  searchWidth: 400,
                  onSearch: (_) {},
                  onProfilePressed: () {},
                  onLogoPressed: () {},
                  onThemeToggle: () {},
                  isTestMode: true,
                  testDarkMode: true,
                  profileButton: const UserProfileButton(
                    userName: 'Test User',
                    isTestMode: true,
                    testDarkMode: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'App Header - Without Title',
          description: 'App header with logo only (no title text)',
          child: Column(
            children: [
              const SizedBox(height: 20),
              AppHeader(
                searchHintText: 'Search agents and apps...',
                searchWidth: 400,
                showTitle: false,
                onSearch: (_) {},
                onProfilePressed: () {},
                onLogoPressed: () {},
                onThemeToggle: () {},
                isTestMode: true,
                profileButton: const UserProfileButton(
                  userName: 'Test User',
                  isTestMode: true,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                color: Colors.grey[850],
                child: AppHeader(
                  searchHintText: 'Search agents and apps...',
                  searchWidth: 400,
                  showTitle: false,
                  onSearch: (_) {},
                  onProfilePressed: () {},
                  onLogoPressed: () {},
                  onThemeToggle: () {},
                  isTestMode: true,
                  testDarkMode: true,
                  profileButton: const UserProfileButton(
                    userName: 'Test User',
                    isTestMode: true,
                    testDarkMode: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'App Header - Without Search',
          description: 'App header without search bar',
          child: Column(
            children: [
              const SizedBox(height: 20),
              AppHeader(
                showSearch: false,
                onProfilePressed: () {},
                onLogoPressed: () {},
                onThemeToggle: () {},
                isTestMode: true,
                profileButton: const UserProfileButton(
                  userName: 'Test User',
                  isTestMode: true,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'App Header - With Custom Profile Button',
          description: 'App header with a custom profile button',
          child: Column(
            children: [
              const SizedBox(height: 20),
              AppHeader(
                searchHintText: 'Search agents and apps...',
                searchWidth: 400,
                onSearch: (_) {},
                onLogoPressed: () {},
                onThemeToggle: () {},
                profileButton: UserProfileButton(
                  userName: 'John Doe',
                  email: 'john.doe@example.com',
                  avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
                  isTestMode: true,
                  dropdownItems: [
                    UserProfileDropdownItem(
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () {},
                    ),
                    UserProfileDropdownItem(
                      icon: Icons.dark_mode,
                      label: 'Dark mode',
                      onTap: () {},
                    ),
                    UserProfileDropdownItem(
                      icon: Icons.logout,
                      label: 'Logout',
                      onTap: () {},
                    ),
                  ],
                ),
                isTestMode: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'App Header - Logged Out State',
          description: 'App header with logged out profile button',
          child: Column(
            children: [
              const SizedBox(height: 20),
              AppHeader(
                searchHintText: 'Search agents and apps...',
                searchWidth: 400,
                onSearch: (_) {},
                onLogoPressed: () {},
                onThemeToggle: () {},
                profileButton: const UserProfileButton(
                  loginState: LoginState.loggedOut,
                  isTestMode: true,
                ),
                isTestMode: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'Section Header',
          description: 'Header for content sections with optional view all button',
          child: Column(
            children: [
              const SizedBox(height: 20),
              BaseSectionHeader(
                title: 'Recent Agents',
                subtitle: '12 agents updated in the last 24 hours',
                viewAllText: 'View All',
                onViewAll: () {},
                isTestMode: true,
              ),
              const SizedBox(height: 20),
              BaseSectionHeader(
                title: 'Applications',
                viewAllText: 'View All',
                onViewAll: () {},
                isTestMode: true,
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.grey[850],
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                child: BaseSectionHeader(
                  title: 'Recent Agents',
                  subtitle: '12 agents updated in the last 24 hours',
                  viewAllText: 'View All',
                  onViewAll: () {},
                  isTestMode: true,
                  testDarkMode: true,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ComponentDisplay(
          title: 'Section Header - With Icon',
          description: 'Section header with leading icon',
          child: Column(
            children: [
              const SizedBox(height: 20),
              BaseSectionHeader(
                title: 'Recent Agents',
                leading: const Icon(Icons.smart_toy_outlined, size: 28),
                viewAllText: 'View All',
                onViewAll: () {},
                isTestMode: true,
              ),
              const SizedBox(height: 20),
              BaseSectionHeader(
                title: 'Applications',
                leading: const Icon(Icons.apps_outlined, size: 28),
                viewAllText: 'View All',
                onViewAll: () {},
                isTestMode: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // PageActionBar Examples - Direct Component Usage
        const Divider(),
        const SizedBox(height: AppDimensions.spacingL),

        // Basic page action bar
        const PageActionBar(
          title: 'Basic Page Action Bar',
          isTestMode: true,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Page action bar with actions
        PageActionBar(
          title: 'Page with Actions',
          actions: [
            PrimaryButton(
              text: 'Primary',
              onPressed: () {},
              size: ButtonSize.small,
              isTestMode: true,
            ),
            SecondaryButton(
              text: 'Secondary',
              onPressed: () {},
              size: ButtonSize.small,
              isTestMode: true,
            ),
            AppIconButton(
              text: 'Add',
              icon: Icons.add,
              onPressed: () {},
              size: ButtonSize.small,
              isTestMode: true,
            ),
          ],
          isTestMode: true,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Page action bar with border
        PageActionBar(
          title: 'Page with Border',
          showBorder: true,
          actions: [
            PrimaryButton(
              text: 'Action',
              onPressed: () {},
              size: ButtonSize.small,
              isTestMode: true,
            ),
          ],
          isTestMode: true,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Loading state page action bar
        PageActionBar(
          title: 'Loading Actions',
          isLoading: true,
          actions: [
            PrimaryButton(
              text: 'Process',
              onPressed: () {},
              size: ButtonSize.small,
              isTestMode: true,
            ),
          ],
          isTestMode: true,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Mobile layout demonstration
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: PageActionBar(
            title: 'Mobile Page Layout',
            actions: [
              PrimaryButton(
                text: 'Action 1',
                onPressed: () {},
                size: ButtonSize.small,
                isTestMode: true,
              ),
              SecondaryButton(
                text: 'Action 2',
                onPressed: () {},
                size: ButtonSize.small,
                isTestMode: true,
              ),
              OutlineButton(
                text: 'Action 3',
                onPressed: () {},
                size: ButtonSize.small,
                isTestMode: true,
              ),
              AppTextButton(
                text: 'Action 4',
                onPressed: () {},
                size: ButtonSize.small,
                isTestMode: true,
              ),
            ],
            isTestMode: true,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Tabbed Header Example - With Icons
        ComponentDisplay(
          title: 'Tabbed Header - With Icons',
          description: 'Professional tabbed header with icons, add/close functionality, recent history, and options menu',
          child: _TabbedHeaderExample(
            tabs: _tabs,
            selectedTabId: _selectedTabId,
            onTabSelected: (id) {
              setState(() => _selectedTabId = id);
            },
            onAddTab: () {
              setState(() {
                _tabs = [
                  ..._tabs,
                  HeaderTab(
                    id: '$_tabCounter',
                    title: 'Tab $_tabCounter',
                    icon: Icons.tab,
                  ),
                ];
                _tabCounter++;
              });
            },
            onCloseTab: (id) {
              setState(() {
                _tabs = _tabs.where((tab) => tab.id != id).toList();
                if (_selectedTabId == id && _tabs.isNotEmpty) {
                  _selectedTabId = _tabs.first.id;
                }
              });
            },
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Tabbed Header Example - Without Icons
        ComponentDisplay(
          title: 'Tabbed Header - Simple',
          description: 'Tabbed header without icons for a cleaner, more compact appearance',
          child: _TabbedHeaderExample(
            tabs: _simpleTabs,
            selectedTabId: _selectedSimpleTabId,
            onTabSelected: (id) {
              setState(() => _selectedSimpleTabId = id);
            },
            onAddTab: () {
              setState(() {
                _simpleTabs = [
                  ..._simpleTabs,
                  HeaderTab(
                    id: '$_simpleTabCounter',
                    title: 'Tab $_simpleTabCounter',
                  ),
                ];
                _simpleTabCounter++;
              });
            },
            onCloseTab: (id) {
              setState(() {
                _simpleTabs = _simpleTabs.where((tab) => tab.id != id).toList();
                if (_selectedSimpleTabId == id && _simpleTabs.isNotEmpty) {
                  _selectedSimpleTabId = _simpleTabs.first.id;
                }
              });
            },
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
      ],
    );
  }
}

class _TabbedHeaderExample extends StatelessWidget {
  final List<HeaderTab> tabs;
  final String selectedTabId;
  final Function(String) onTabSelected;
  final VoidCallback onAddTab;
  final Function(String) onCloseTab;

  const _TabbedHeaderExample({
    required this.tabs,
    required this.selectedTabId,
    required this.onTabSelected,
    required this.onAddTab,
    required this.onCloseTab,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            TabbedHeader(
              tabs: tabs,
              selectedTabId: selectedTabId,
              onTabSelected: onTabSelected,
              onAddTab: onAddTab,
              onCloseTab: onCloseTab,
              leading: IconButton(
                icon: const Icon(Icons.history, size: 20),
                onPressed: () {
                  debugPrint('Recent button pressed');
                },
                tooltip: 'Recent',
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  tooltip: 'More options',
                  onSelected: (value) {
                    debugPrint('Selected: $value');
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'save',
                      child: Row(
                        children: [
                          Icon(Icons.save, size: 18),
                          SizedBox(width: 12),
                          Text('Save Layout'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'restore',
                      child: Row(
                        children: [
                          Icon(Icons.restore, size: 18),
                          SizedBox(width: 12),
                          Text('Restore Default'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'closeAll',
                      child: Row(
                        children: [
                          Icon(Icons.close_fullscreen, size: 18),
                          SizedBox(width: 12),
                          Text('Close All Tabs'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Content area to show selected tab
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: SizedBox(
                height: 150,
                child: Center(
                  child: Text(
                    'Content for ${tabs.firstWhere((tab) => tab.id == selectedTabId).title}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          'Interactive example: Click tabs to switch • + to add • X to close • History icon for recent • ⋮ for options',
          style: TextStyle(
            fontSize: 12,
            color: context.colors.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
