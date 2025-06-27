import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/workspace_summary.dart';
import '../widgets/recent_agents.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isWideScreen = ResponsiveUtils.isWideScreen(context);

    return Scaffold(
      body: Column(
        children: [
          // Full-width header
          Container(
            color: const Color(0xFF4776F6),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 60,
            child: Row(
              children: [
                // Logo section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.bubble_chart,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'DMTools',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 32),
                // Current page title
                const Icon(
                  Icons.dashboard_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // Right side actions
                IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Content area with sidebar and main content
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar navigation
                const SidebarNavigation(selectedIndex: 0),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF3F6AE0),
                                Color(0xFF2A4CC2),
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Welcome to DMTools',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Build, deploy, and manage AI agents with our powerful platform.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      children: [
                                        PrimaryButton(
                                          text: 'Get Started',
                                          onPressed: () {},
                                          size: ButtonSize.medium,
                                        ),
                                        WhiteOutlineButton(
                                          text: 'Learn More',
                                          onPressed: () {},
                                          size: ButtonSize.medium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const ResponsiveWidget(
                                tablet: SizedBox(width: 24),
                                desktop: SizedBox(width: 24),
                              ),
                              ResponsiveWidget(
                                tablet: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Tools',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2A4CC2),
                                      ),
                                    ),
                                  ),
                                ),
                                desktop: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Tools',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2A4CC2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Workspace and agents summary
                        const ResponsiveWidget(
                          mobile: Column(
                            children: [
                              WorkspaceSummary(),
                              SizedBox(height: 24),
                              RecentAgents(),
                            ],
                          ),
                          desktop: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Workspace summary
                              Expanded(
                                flex: 2,
                                child: WorkspaceSummary(),
                              ),

                              SizedBox(width: 24),

                              // Recent agents
                              Expanded(
                                flex: 3,
                                child: RecentAgents(),
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
          ),
        ],
      ),
    );
  }
}
