import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class HeadersPage extends StatelessWidget {
  const HeadersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Headers'), backgroundColor: colors.cardBg),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          const ComponentDisplay(
            title: 'Headers',
            description: 'Header components including app headers, section headers, and page action bars.',
            child: SizedBox.shrink(),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // App Header Section
          _buildSection(
            context,
            'App Header',
            'Main application header with navigation and theme controls',
            _buildAppHeaderExample(context),
          ),

          // Section Header Section
          _buildSection(
            context,
            'Section Header',
            'Headers for organizing content sections',
            _buildSectionHeaderExample(),
          ),

          // Page Action Bar Section
          _buildSection(
            context,
            'Page Action Bar',
            'Action bar with buttons and controls for page-level actions',
            _buildPageActionBarExample(),
          ),

          // Base Section Header Section
          _buildSection(
            context,
            'Base Section Header',
            'Simple header with title and optional subtitle',
            _buildBaseSectionHeaderExample(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description, Widget example) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: AppDimensions.spacingS),
        Text(description, style: TextStyle(fontSize: 14, color: context.colors.textColor.withValues(alpha: 0.8))),
        const SizedBox(height: AppDimensions.spacingM),
        example,
        const SizedBox(height: AppDimensions.spacingL),
      ],
    );
  }

  Widget _buildAppHeaderExample(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.borderColor),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: const AppHeader(),
    );
  }

  Widget _buildSectionHeaderExample() {
    return const Column(
      children: [
        SectionHeader(title: 'Recent Projects'),
        SizedBox(height: AppDimensions.spacingM),
        SectionHeader(title: 'Settings'),
      ],
    );
  }

  Widget _buildPageActionBarExample() {
    return const PageActionBar(
      title: 'Project Management',
      actions: [
        SecondaryButton(text: 'Export', size: ButtonSize.small),
        PrimaryButton(text: 'New Project', size: ButtonSize.small),
      ],
    );
  }

  Widget _buildBaseSectionHeaderExample(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Row(
              children: [
                const Icon(Icons.person, size: 24),
                const SizedBox(width: AppDimensions.spacingM),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('User Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(
                      'Manage your profile settings',
                      style: TextStyle(fontSize: 14, color: context.colors.textColor.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spacingM),
            child: Row(
              children: [
                Icon(Icons.security, size: 24),
                SizedBox(width: AppDimensions.spacingM),
                Text('Security', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
