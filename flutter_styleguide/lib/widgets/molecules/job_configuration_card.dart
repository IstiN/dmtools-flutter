import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Comprehensive card component for displaying AI job configuration information
class JobConfigurationCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String jobType;
  final bool enabled;
  final int executionCount;
  final DateTime? lastExecutedAt;
  final DateTime createdAt;
  final String createdByName;
  final List<String> requiredIntegrations;
  final VoidCallback? onExecute;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTest;
  final VoidCallback? onViewDetails;
  final bool? isTestMode;
  final bool? testDarkMode;

  const JobConfigurationCard({
    required this.id,
    required this.name,
    required this.description,
    required this.jobType,
    required this.enabled,
    required this.executionCount,
    required this.createdAt,
    required this.createdByName,
    required this.requiredIntegrations,
    this.lastExecutedAt,
    this.onExecute,
    this.onEdit,
    this.onDelete,
    this.onTest,
    this.onViewDetails,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeColorSet colors;

    if (isTestMode == true) {
      final isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      colors = context.colors;
    }

    return Card(
      elevation: 2,
      color: colors.cardBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status and actions
          _buildHeader(colors),

          // Content - use Expanded to take available space
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Job type and name
                  _buildTitleSection(colors),
                  const SizedBox(height: AppDimensions.spacingS),

                  // Description
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: colors.textSecondary, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacingM),

                  // Integrations
                  _buildIntegrationsSection(colors),
                  const SizedBox(height: AppDimensions.spacingM),

                  // Stats
                  _buildStatsSection(colors),
                ],
              ),
            ),
          ),

          // Action buttons
          _buildActionButtons(colors),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: enabled ? colors.successColor.withValues(alpha: 0.1) : colors.textMuted.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusS),
          topRight: Radius.circular(AppDimensions.radiusS),
        ),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: enabled ? colors.successColor : colors.textMuted, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            enabled ? 'Active' : 'Disabled',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: enabled ? colors.successColor : colors.textMuted,
            ),
          ),
          const Spacer(),
          // Job type icon
          Icon(_getJobTypeIcon(jobType), size: 20, color: enabled ? colors.accentColor : colors.textMuted),
        ],
      ),
    );
  }

  Widget _buildTitleSection(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.textColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingS, vertical: AppDimensions.spacingXs),
          decoration: BoxDecoration(
            color: colors.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          ),
          child: Text(
            _getJobTypeDisplayName(jobType),
            style: TextStyle(fontSize: 12, color: colors.accentColor, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildIntegrationsSection(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required Integrations',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.textMuted),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        Wrap(
          spacing: AppDimensions.spacingXs,
          runSpacing: AppDimensions.spacingXs,
          children:
              requiredIntegrations
                  .take(3)
                  .map(
                    (integration) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingS, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.borderColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      ),
                      child: Text(integration, style: TextStyle(fontSize: 10, color: colors.textSecondary)),
                    ),
                  )
                  .toList()
                ..addAll(
                  requiredIntegrations.length > 3
                      ? [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingS, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.borderColor.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                            ),
                            child: Text(
                              '+${requiredIntegrations.length - 3}',
                              style: TextStyle(fontSize: 10, color: colors.textSecondary),
                            ),
                          ),
                        ]
                      : [],
                ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(ThemeColorSet colors) {
    return Row(
      children: [
        Expanded(child: _buildStatItem('Executions', executionCount.toString(), colors)),
        Expanded(
          child: _buildStatItem(
            'Last Run',
            lastExecutedAt != null ? _formatRelativeTime(lastExecutedAt!) : 'Never',
            colors,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: colors.textMuted)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingS),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderColor.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PrimaryButton(
              text: 'Execute',
              icon: Icons.play_arrow,
              onPressed: enabled ? onExecute : null,
              size: ButtonSize.small,
              isTestMode: isTestMode ?? false,
              testDarkMode: testDarkMode ?? false,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          AppIconButton(
            text: 'Details',
            icon: Icons.info_outline,
            onPressed: onViewDetails,
            size: ButtonSize.small,
            isTestMode: isTestMode ?? false,
            testDarkMode: testDarkMode ?? false,
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          AppIconButton(
            text: 'Test',
            icon: Icons.science,
            onPressed: onTest,
            size: ButtonSize.small,
            isTestMode: isTestMode ?? false,
            testDarkMode: testDarkMode ?? false,
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          AppIconButton(
            text: 'Edit',
            icon: Icons.edit,
            onPressed: onEdit,
            size: ButtonSize.small,
            isTestMode: isTestMode ?? false,
            testDarkMode: testDarkMode ?? false,
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          AppIconButton(
            text: 'Delete',
            icon: Icons.delete,
            onPressed: onDelete,
            size: ButtonSize.small,
            isTestMode: isTestMode ?? false,
            testDarkMode: testDarkMode ?? false,
          ),
        ],
      ),
    );
  }

  IconData _getJobTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'expert':
        return Icons.psychology;
      case 'testcasesgenerator':
        return Icons.quiz;
      default:
        return Icons.smart_toy;
    }
  }

  String _getJobTypeDisplayName(String type) {
    switch (type.toLowerCase()) {
      case 'expert':
        return 'Expert Analysis';
      case 'testcasesgenerator':
        return 'Test Cases Generator';
      default:
        return type;
    }
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
