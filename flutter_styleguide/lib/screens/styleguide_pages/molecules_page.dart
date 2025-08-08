import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'molecules/paginated_data_table_page.dart';
import 'molecules/cards_page.dart';
import 'molecules/headers_page.dart';
import 'molecules/forms_page.dart';
import 'molecules/chat_messaging_page.dart';
import 'molecules/navigation_page.dart';
import 'molecules/loading_states_page.dart';

class MoleculeCard {
  final String title;
  final String code;
  final String description;
  final Widget Function(BuildContext) pageBuilder;
  final IconData icon;

  MoleculeCard({
    required this.title,
    required this.code,
    required this.description,
    required this.pageBuilder,
    this.icon = Icons.view_module,
  });
}

class MoleculesPage extends StatelessWidget {
  const MoleculesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final molecules = [
      MoleculeCard(
        title: 'Data Tables',
        code: '.dm-paginated-data-table',
        description: 'Advanced paginated data table with search, filtering, and responsive design.',
        pageBuilder: (context) => const PaginatedDataTablePage(),
        icon: Icons.table_view,
      ),
      MoleculeCard(
        title: 'Cards',
        code: '.feature-card',
        description: 'Various card components including feature cards, agent cards, and integration cards.',
        pageBuilder: (context) => const CardsPage(),
        icon: Icons.credit_card,
      ),
      MoleculeCard(
        title: 'Headers',
        code: '.section-header',
        description: 'Header components including app headers, section headers, and page action bars.',
        pageBuilder: (context) => const HeadersPage(),
        icon: Icons.view_headline,
      ),
      MoleculeCard(
        title: 'Forms',
        code: '.integration-config-form',
        description: 'Form components including integration forms, job configuration forms, and search forms.',
        pageBuilder: (context) => const FormsPage(),
        icon: Icons.description,
      ),
      MoleculeCard(
        title: 'Chat & Messaging',
        code: '.chat-message',
        description: 'Chat components including messages, input groups, and notification messages.',
        pageBuilder: (context) => const ChatMessagingPage(),
        icon: Icons.chat_bubble_outline,
      ),
      MoleculeCard(
        title: 'Navigation',
        code: '.navigation-menu',
        description: 'Navigation components including breadcrumbs, tabs, menus, and navigation bars.',
        pageBuilder: (context) => const NavigationPage(),
        icon: Icons.menu,
      ),
      MoleculeCard(
        title: 'Loading & States',
        code: '.loading-state-wrapper',
        description: 'Loading states, empty states, and state wrapper components.',
        pageBuilder: (context) => const LoadingStatesPage(),
        icon: Icons.hourglass_empty,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      children: [
        const ComponentDisplay(
          title: 'Molecules',
          description:
              'Mid-level components that combine atoms to form more complex UI elements. Each molecule serves a specific function and can be reused across different parts of the application.',
          child: SizedBox.shrink(),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        ...molecules.map((molecule) => _buildMoleculeCard(context, molecule)),
      ],
    );
  }

  Widget _buildMoleculeCard(BuildContext context, MoleculeCard molecule) {
    final colors = context.colors;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: molecule.pageBuilder));
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Row(
            children: [
              Icon(molecule.icon, size: 48, color: colors.textColor),
              const SizedBox(width: AppDimensions.spacingL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      molecule.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
                    ),
                    const SizedBox(height: AppDimensions.spacingS),
                    Text(
                      molecule.code,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: colors.textColor.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingS),
                    Text(
                      molecule.description,
                      style: TextStyle(fontSize: 14, color: colors.textColor.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: colors.textColor.withValues(alpha: 0.6), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
