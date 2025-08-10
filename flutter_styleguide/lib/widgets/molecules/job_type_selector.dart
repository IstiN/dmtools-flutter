import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../organisms/job_configuration_management.dart';

/// Grid selector for choosing job types when creating new configurations
class JobTypeSelector extends StatelessWidget {
  final List<JobType> jobTypes;
  final JobType? selectedType;
  final ValueChanged<JobType> onSelectionChanged;
  final bool? isTestMode;
  final bool? testDarkMode;

  const JobTypeSelector({
    required this.jobTypes,
    required this.onSelectionChanged,
    this.selectedType,
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

    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spacingM,
        mainAxisSpacing: AppDimensions.spacingM,
        mainAxisExtent: 200,
      ),
      itemCount: jobTypes.length,
      itemBuilder: (context, index) {
        final jobType = jobTypes[index];
        final isSelected = selectedType?.type == jobType.type;

        return _JobTypeCard(
          jobType: jobType,
          isSelected: isSelected,
          onTap: () => onSelectionChanged(jobType),
          colors: colors,
        );
      },
    );
  }
}

class _JobTypeCard extends StatelessWidget {
  final JobType jobType;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeColorSet colors;

  const _JobTypeCard({required this.jobType, required this.isSelected, required this.onTap, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      color: colors.cardBg,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            border: Border.all(color: isSelected ? colors.accentColor : colors.borderColor, width: isSelected ? 2 : 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and selection indicator
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spacingS),
                      decoration: BoxDecoration(
                        color: colors.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      ),
                      child: Icon(_getJobTypeIcon(jobType.type), size: 24, color: colors.accentColor),
                    ),
                    const Spacer(),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: colors.accentColor, shape: BoxShape.circle),
                        child: const Icon(Icons.check, size: 16, color: Colors.white),
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingM),

                // Title
                Text(
                  jobType.displayName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.textColor),
                ),
                const SizedBox(height: AppDimensions.spacingS),

                // Description
                Expanded(
                  child: Text(
                    jobType.description,
                    style: TextStyle(fontSize: 12, color: colors.textSecondary, height: 1.3),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Footer with integrations count
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingS,
                        vertical: AppDimensions.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: colors.borderColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      ),
                      child: Text(
                        _getJobTypeCategory(jobType.type),
                        style: TextStyle(fontSize: 10, color: colors.textMuted, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${jobType.requiredIntegrations.length + jobType.optionalIntegrations.length} integrations',
                      style: TextStyle(fontSize: 10, color: colors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

  String _getJobTypeCategory(String type) {
    switch (type.toLowerCase()) {
      case 'expert':
        return 'Analysis';
      case 'testcasesgenerator':
        return 'Testing';
      default:
        return 'AI Job';
    }
  }
}
