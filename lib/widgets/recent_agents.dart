import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

// Agent data model
class _AgentData {
  final String title;
  final String description;
  final StatusType status;
  final String statusLabel;
  final List<String> tags;
  final int runCount;
  final String lastRunTime;

  const _AgentData({
    required this.title,
    required this.description,
    required this.status,
    required this.statusLabel,
    required this.tags,
    required this.runCount,
    required this.lastRunTime,
  });
}

class RecentAgents extends StatelessWidget {
  const RecentAgents({super.key});

  // Sample agent data with proper typing
  static const List<_AgentData> _sampleAgents = [
    _AgentData(
      title: 'Customer Support Agent',
      description: 'Handles customer inquiries and resolves issues',
      status: StatusType.online,
      statusLabel: 'Active',
      tags: ['Support', 'Customer Service'],
      runCount: 125,
      lastRunTime: '2 hours ago',
    ),
    _AgentData(
      title: 'Data Analysis Agent',
      description: 'Analyzes marketing data and generates reports',
      status: StatusType.online,
      statusLabel: 'Active',
      tags: ['Analytics', 'Marketing'],
      runCount: 87,
      lastRunTime: '45 minutes ago',
    ),
    _AgentData(
      title: 'Code Review Agent',
      description: 'Reviews code and provides feedback',
      status: StatusType.offline,
      statusLabel: 'Inactive',
      tags: ['Development', 'Code Quality'],
      runCount: 42,
      lastRunTime: '3 days ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Container(
      height: 500, // Fixed height to prevent unbounded constraints
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const _RecentAgentsHeader(),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search bar
                  _SearchBar(colors: colors),

                  // Agent cards
                  Expanded(
                    child: ListView.builder(
                      itemCount: _sampleAgents.length,
                      itemBuilder: (context, index) {
                        final agent = _sampleAgents[index];
                        return _AgentItem(
                          title: agent.title,
                          description: agent.description,
                          status: agent.status,
                          statusLabel: agent.statusLabel,
                          tags: agent.tags,
                          runCount: agent.runCount,
                          lastRunTime: agent.lastRunTime,
                          colors: colors,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // View all button
                  OutlineButton(
                    text: 'View All Agents',
                    onPressed: () {},
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Private widget for header
class _RecentAgentsHeader extends StatelessWidget {
  const _RecentAgentsHeader();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFF4776F6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            const Text(
              'Recent Agents',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// Private widget for search bar
class _SearchBar extends StatelessWidget {
  final dynamic colors;

  const _SearchBar({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        height: 40,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search agents...',
            hintStyle: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
            ),
            prefixIcon: Icon(Icons.search, color: colors.textSecondary, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            filled: true,
            fillColor: colors.inputBg,
          ),
        ),
      ),
    );
  }
}

// Private widget instead of method
class _AgentItem extends StatelessWidget {
  final String title;
  final String description;
  final StatusType status;
  final String statusLabel;
  final List<String> tags;
  final int runCount;
  final String lastRunTime;
  final dynamic colors;

  const _AgentItem({
    required this.title,
    required this.description,
    required this.status,
    required this.statusLabel,
    required this.tags,
    required this.runCount,
    required this.lastRunTime,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == StatusType.online;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.smart_toy_outlined,
                    color: colors.accentColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textColor,
                      ),
                    ),
                  ),
                  _StatusBadge(
                    isActive: isActive,
                    statusLabel: statusLabel,
                    colors: colors,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.play_circle_outline, size: 16, color: colors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        'Runs: $runCount',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: colors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        'Last run: $lastRunTime',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: 'Run',
                    onPressed: () {},
                    size: ButtonSize.small,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Private widget for status badge
class _StatusBadge extends StatelessWidget {
  final bool isActive;
  final String statusLabel;
  final dynamic colors;

  const _StatusBadge({
    required this.isActive,
    required this.statusLabel,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? colors.successColor.withValues(alpha: 0.1) : colors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? colors.successColor : colors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? colors.successColor : colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
