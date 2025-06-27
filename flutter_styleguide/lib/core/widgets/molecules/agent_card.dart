import 'package:flutter/material.dart';
import '../atoms/app_button.dart';
import '../atoms/status_dot.dart';
import '../atoms/tag_chip.dart';
import '../../models/agent.dart';

class AgentCard extends StatelessWidget {
  final CoreAgent agent;

  const AgentCard({
    required this.agent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.smart_toy, color: theme.primaryColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(agent.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          StatusDot(type: agent.isActive ? StatusDotType.success : StatusDotType.offline),
                          const SizedBox(width: 6),
                          Text(
                            agent.isActive ? 'Active' : 'Inactive',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Description
            Text(
              agent.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: agent.tags.map((tag) => TagChip(label: tag)).toList(),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_box, size: 14, color: theme.hintColor),
                    const SizedBox(width: 8),
                    Text('${agent.runCount} runs', style: theme.textTheme.bodySmall),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 14, color: theme.hintColor),
                    const SizedBox(width: 8),
                    Text(agent.lastRun, style: theme.textTheme.bodySmall),
                  ],
                ),
                AppButton(
                  onPressed: () {},
                  text: 'Run',
                  icon: const Icon(Icons.play_arrow, size: 12),
                  isSmall: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
