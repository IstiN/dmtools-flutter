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
  const RecentAgents({Key? key}) : super(key: key);

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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
                  const _SearchBar(),

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
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // View all button
                  SizedBox(
                    width: double.infinity,
                    child: OutlineButton(
                      text: 'View All Agents',
                      onPressed: () {},
                      isFullWidth: true,
                    ),
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
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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

  const _AgentItem({
    required this.title,
    required this.description,
    required this.status,
    required this.statusLabel,
    required this.tags,
    required this.runCount,
    required this.lastRunTime,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bool isActive = status == StatusType.online;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
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
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) => _TagChip(label: tag)).toList(),
              ),
              const SizedBox(height: 16),
              SimpleResponsiveBuilder(
                breakpoint: ResponsiveBreakpoints.agentCardNarrowThreshold,
                mobile: (context, constraints) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _StatWidget(
                          icon: Icons.replay_circle_filled_outlined,
                          label: 'Runs',
                          value: runCount.toString(),
                        ),
                        const SizedBox(width: 24),
                        _StatWidget(
                          icon: Icons.access_time_outlined,
                          label: 'Last Run',
                          value: lastRunTime,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _RunButton(),
                  ],
                ),
                desktop: (context, constraints) => Row(
                  children: [
                    _StatWidget(
                      icon: Icons.replay_circle_filled_outlined,
                      label: 'Runs',
                      value: runCount.toString(),
                    ),
                    const SizedBox(width: 24),
                    _StatWidget(
                      icon: Icons.access_time_outlined,
                      label: 'Last Run',
                      value: lastRunTime,
                    ),
                    const Spacer(),
                    const _RunButton(),
                  ],
                ),
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

  const _StatusBadge({
    required this.isActive,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE6F7ED) : const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? const Color(0xFF34C759) : const Color(0xFF8E8E93),
              ),
              child: const SizedBox(width: 6, height: 6),
            ),
            const SizedBox(width: 4),
            Text(
              statusLabel,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? const Color(0xFF34C759) : const Color(0xFF8E8E93),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Private widget for tag chip
class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ),
    );
  }
}

// Private widget for stat display
class _StatWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatWidget({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colors.textSecondary),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: colors.textSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colors.textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Private widget for run button
class _RunButton extends StatelessWidget {
  const _RunButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.play_arrow, size: 16),
      label: const Text('Run'),
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.accentColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
