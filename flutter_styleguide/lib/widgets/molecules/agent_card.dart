import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../atoms/buttons/app_buttons.dart';
import '../atoms/status_dot.dart';
import '../atoms/tag_chip.dart';
import '../../models/agent.dart';
import '../../theme/app_dimensions.dart';

class AgentCard extends StatelessWidget {
  final String title;
  final String description;
  final StatusType status;
  final String statusLabel;
  final List<String> tags;
  final int runCount;
  final String lastRunTime;
  final VoidCallback onRun;
  final bool? isTestMode;
  final bool? testDarkMode;

  const AgentCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.statusLabel,
    required this.tags,
    required this.runCount,
    required this.lastRunTime,
    required this.onRun,
    this.isTestMode,
    this.testDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode; // Unused variable
    // final colors = isDarkMode ? AppColors.dark : AppColors.light; // Unused variable

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with accent color
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.smart_toy_outlined,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                // Status indicator
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatusDot(status: status),
                    const SizedBox(width: 8),
                    Text(
                      statusLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Content area
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags
                      .map<Widget>((tag) => TagChip(
                            label: tag,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                // Stats and action
                Row(
                  children: [
                    // Run count
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.replay_circle_filled_outlined, color: theme.hintColor, size: 16),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Runs',
                                  style: theme.textTheme.bodySmall,
                                ),
                                Text(
                                  runCount.toString(),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Last run time
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time_outlined, color: theme.hintColor, size: 16),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last Run',
                                  style: theme.textTheme.bodySmall,
                                ),
                                Text(
                                  lastRunTime,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.hintColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Run button
                    PrimaryButton(
                      text: 'Run',
                      onPressed: onRun,
                      size: ButtonSize.small,
                      icon: Icons.play_arrow,
                      isTestMode: isTestMode ?? false,
                      testDarkMode: testDarkMode ?? false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 