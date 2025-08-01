import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'organisms/page_header_page.dart';
import 'organisms/welcome_banner_page.dart';
import 'organisms/panel_base_page.dart';
import 'organisms/chat_module_page.dart';
import 'organisms/workspace_management_page.dart';
import 'organisms/integration_management_page.dart';
import 'organisms/navigation_sidebar_page.dart';
import 'organisms/mcp_management_page.dart';
import 'job_configuration_page.dart';

class OrganismCard {
  final String title;
  final String code;
  final String description;
  final Widget Function(BuildContext) pageBuilder;
  final IconData icon;

  OrganismCard({
    required this.title,
    required this.code,
    required this.description,
    required this.pageBuilder,
    this.icon = Icons.widgets,
  });
}

class OrganismsPage extends StatelessWidget {
  const OrganismsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final organisms = [
      OrganismCard(
        title: 'Page Header',
        code: '.page-header',
        description: 'Main navigation header with logo, theme toggle, and action buttons.',
        pageBuilder: (context) => const PageHeaderPage(),
        icon: Icons.web,
      ),
      OrganismCard(
        title: 'Welcome Banner',
        code: '.welcome-banner',
        description: 'Prominent banner component for main page headers with logo, text, and call-to-action buttons.',
        pageBuilder: (context) => const WelcomeBannerShowcasePage(),
        icon: Icons.campaign,
      ),
      OrganismCard(
        title: 'Panel Base',
        code: '.panel-base',
        description: 'Foundational panel structure with header and content area. Base for other modules.',
        pageBuilder: (context) => const PanelBasePage(),
        icon: Icons.dashboard,
      ),
      OrganismCard(
        title: 'Chat Module',
        code: '.chat-module',
        description: 'Interactive chat component with message display and input area.',
        pageBuilder: (context) => const ChatModulePage(),
        icon: Icons.chat,
      ),
      OrganismCard(
        title: 'Navigation Sidebar',
        code: '.navigation-sidebar',
        description: 'Consistent navigation component for application with proper theming and responsive behavior.',
        pageBuilder: (context) => const NavigationSidebarPage(),
        icon: Icons.menu,
      ),
      OrganismCard(
        title: 'Workspace Management',
        code: '.workspace-*',
        description: 'Complete workspace management system with cards, forms, and user management.',
        pageBuilder: (context) => const WorkspaceManagementPage(),
        icon: Icons.group_work,
      ),
      OrganismCard(
        title: 'Integration Management',
        code: '.integration-*',
        description:
            'Complete integration management system with discovery, cards, forms, configuration, and CRUD operations.',
        pageBuilder: (context) => const IntegrationManagementPage(),
        icon: Icons.integration_instructions,
      ),
      OrganismCard(
        title: 'AI Job Configuration',
        code: '.job-config-*',
        description:
            'Complete AI job configuration management system with job type selection, dynamic forms, and execution controls.',
        pageBuilder: (context) => const JobConfigurationPage(),
        icon: Icons.smart_toy,
      ),
      OrganismCard(
        title: 'MCP Management',
        code: '.mcp-*',
        description:
            'Complete MCP configuration management system with creation forms, list views, and code generation.',
        pageBuilder: (context) => const McpManagementPage(),
        icon: Icons.api,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      children: [
        Text('Organisms', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'More complex UI components composed of groups of molecules and/or atoms.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Organism cards grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveUtils.getGridColumnCount(context),
          crossAxisSpacing: AppDimensions.spacingM,
          mainAxisSpacing: AppDimensions.spacingM,
          childAspectRatio: 1.2,
          children: organisms.map((organism) => _OrganismCard(organism: organism)).toList(),
        ),
      ],
    );
  }
}

class _OrganismCard extends StatelessWidget {
  final OrganismCard organism;

  const _OrganismCard({required this.organism});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Card(
      elevation: 2,
      color: colors.cardBg,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: organism.pageBuilder)),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    organism.icon,
                    color: colors.accentColor,
                    size: AppDimensions.iconSizeL + 4, // 28px equivalent
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          organism.title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textColor),
                        ),
                        const SizedBox(height: AppDimensions.spacingXxs),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.bgColor,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                          ),
                          child: Text(
                            organism.code,
                            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: colors.accentColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Flexible(
                child: Text(
                  organism.description,
                  style: TextStyle(color: colors.textSecondary, height: 1.4),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: organism.pageBuilder)),
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Component'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingS,
                      vertical: AppDimensions.spacingXs,
                    ),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
