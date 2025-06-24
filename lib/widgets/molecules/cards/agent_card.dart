import 'package:flutter/material.dart';
import '../../atoms/status_dot.dart';
import '../../atoms/tag_chip.dart';
import '../../atoms/buttons/app_buttons.dart';
import '../../../theme/app_dimensions.dart';
import 'accent_card.dart';

/// Agent card implementation that displays agent information
class AgentCard extends StatelessWidget {
  final String title;
  final String description;
  final StatusType status;
  final String statusLabel;
  final List<String> tags;
  final int runCount;
  final String lastRunTime;
  final VoidCallback onRun;
  final bool isTestMode;
  final bool testDarkMode;

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
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Status indicator for the header
    final statusWidget = Row(
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
    );

    return AccentCard(
      title: title,
      icon: Icons.smart_toy_outlined,
      trailing: statusWidget,
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
                icon: Icons.play_arrow,
                size: ButtonSize.small,
                isTestMode: isTestMode,
                testDarkMode: testDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }
} 