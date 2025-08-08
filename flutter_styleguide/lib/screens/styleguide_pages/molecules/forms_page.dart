import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class FormsPage extends StatelessWidget {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Forms'), backgroundColor: colors.cardBg),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          const ComponentDisplay(
            title: 'Forms',
            description: 'Form components including integration forms, job configuration forms, and search forms.',
            child: SizedBox.shrink(),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Search Form Section
          _buildSection(
            context,
            'Search Form',
            'Search input with filters and advanced options',
            _buildSearchFormExample(),
          ),

          // Integration Selection Section
          _buildSection(
            context,
            'Integration Selection',
            'Components for selecting and configuring integrations',
            _buildIntegrationSelectionExample(),
          ),

          // Job Type Selector Section
          _buildSection(
            context,
            'Job Type Selector',
            'Selector for different job types and configurations',
            _buildJobTypeSelectorExample(),
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

  Widget _buildSearchFormExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search projects, tasks, or agents...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Wrap(
              spacing: AppDimensions.spacingS,
              children: ['All', 'Active', 'Completed', 'Archived']
                  .map(
                    (filter) => FilterChip(label: Text(filter), selected: filter == 'All', onSelected: (selected) {}),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationSelectionExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Integration Type Selector', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: AppDimensions.spacingM),
            DropdownButtonFormField<String>(
              value: 'GitHub',
              decoration: const InputDecoration(labelText: 'Integration Type', border: OutlineInputBorder()),
              items: [
                'GitHub',
                'GitLab',
                'Bitbucket',
                'Azure DevOps',
              ].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: AppDimensions.spacingM),
            const Text('Selected Integrations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: AppDimensions.spacingS),
            Wrap(
              spacing: AppDimensions.spacingS,
              children: ['GitHub', 'GitLab', 'Jira', 'Confluence', 'Slack', 'Teams']
                  .map(
                    (integration) => FilterChip(
                      label: Text(integration),
                      selected: ['GitHub', 'Jira'].contains(integration),
                      onSelected: (selected) {},
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobTypeSelectorExample() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Job Type Selector', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: AppDimensions.spacingM),
            DropdownButtonFormField<String>(
              value: 'Analysis',
              decoration: const InputDecoration(labelText: 'Job Type', border: OutlineInputBorder()),
              items: [
                'Analysis',
                'Code Review',
                'Testing',
                'Documentation',
                'Deployment',
              ].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
