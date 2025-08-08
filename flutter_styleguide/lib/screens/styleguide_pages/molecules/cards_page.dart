import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Cards'), backgroundColor: colors.cardBg),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          const ComponentDisplay(
            title: 'Cards',
            description: 'Various card components including feature cards, agent cards, and integration cards.',
            child: SizedBox.shrink(),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Feature Card Section
          _buildSection(
            context,
            'Feature Card',
            'Displays features with icons, titles, and descriptions',
            _buildFeatureCardExample(),
          ),

          // Agent Card Section
          _buildSection(
            context,
            'Agent Card',
            'Shows agent information with status and actions',
            _buildAgentCardExample(context),
          ),

          // Integration Card Section
          _buildSection(
            context,
            'Integration Card',
            'Displays integration options and configuration',
            _buildIntegrationCardExample(context),
          ),

          // Custom Card Section
          _buildSection(context, 'Custom Card', 'General purpose card component', _buildCustomCardExample(context)),
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

  Widget _buildFeatureCardExample() {
    return const Wrap(
      spacing: AppDimensions.spacingM,
      runSpacing: AppDimensions.spacingM,
      children: [
        FeatureCard(icon: Icons.dashboard, title: 'Dashboard', description: 'Overview of your projects and tasks'),
        FeatureCard(icon: Icons.analytics, title: 'Analytics', description: 'Detailed insights and reports'),
      ],
    );
  }

  Widget _buildAgentCardExample(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spacingM,
      runSpacing: AppDimensions.spacingM,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Development Agent',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.colors.textColor),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Text(
                  'AI assistant for code generation and review',
                  style: TextStyle(fontSize: 14, color: context.colors.textColor.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingS, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntegrationCardExample(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spacingM,
      runSpacing: AppDimensions.spacingM,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GitHub Integration',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.colors.textColor),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Text(
                  'Connect your GitHub repositories',
                  style: TextStyle(fontSize: 14, color: context.colors.textColor.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Configured',
                      style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomCardExample(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spacingM,
      runSpacing: AppDimensions.spacingM,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              children: [
                const Icon(Icons.info, size: 32),
                const SizedBox(height: AppDimensions.spacingS),
                const Text('Information Card'),
                const SizedBox(height: AppDimensions.spacingS),
                Text(
                  'This is a custom card with flexible content',
                  style: TextStyle(color: context.colors.textColor.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
