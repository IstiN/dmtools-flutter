import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class RecentAgents extends StatelessWidget {
  const RecentAgents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;

    // Sample agent data
    final agents = [
      {
        'title': 'Customer Support Agent',
        'description': 'Handles customer inquiries and resolves issues',
        'status': StatusType.online,
        'statusLabel': 'Active',
        'tags': ['Support', 'Customer Service'],
        'runCount': 125,
        'lastRunTime': '2 hours ago',
      },
      {
        'title': 'Data Analysis Agent',
        'description': 'Analyzes marketing data and generates reports',
        'status': StatusType.online,
        'statusLabel': 'Active',
        'tags': ['Analytics', 'Marketing'],
        'runCount': 87,
        'lastRunTime': '45 minutes ago',
      },
      {
        'title': 'Code Review Agent',
        'description': 'Reviews code and provides feedback',
        'status': StatusType.offline,
        'statusLabel': 'Inactive',
        'tags': ['Development', 'Code Quality'],
        'runCount': 42,
        'lastRunTime': '3 days ago',
      },
    ];

    return Container(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF4776F6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
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
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Search bar
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      filled: true,
                      fillColor: colors.inputBg,
                    ),
                  ),
                ),
                
                // Agent cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: agents.length,
                  itemBuilder: (context, index) {
                    final agent = agents[index];
                    return _buildAgentItem(context, agent, colors);
                  },
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
        ],
      ),
    );
  }
  
  Widget _buildAgentItem(BuildContext context, Map<String, dynamic> agent, ThemeColorSet colors) {
    final bool isActive = (agent['status'] as StatusType) == StatusType.online;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
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
                  agent['title'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFE6F7ED) : const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? const Color(0xFF34C759) : const Color(0xFF8E8E93),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      agent['statusLabel'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive ? const Color(0xFF34C759) : const Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            agent['description'] as String,
            style: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (agent['tags'] as List<String>).map((tag) => _buildTag(tag)).toList(),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isNarrow = constraints.maxWidth < 400;
              
              return isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            _buildStat(
                              Icons.replay_circle_filled_outlined,
                              'Runs',
                              (agent['runCount'] as int).toString(),
                              colors,
                            ),
                            const SizedBox(width: 24),
                            _buildStat(
                              Icons.access_time_outlined,
                              'Last Run',
                              agent['lastRunTime'] as String,
                              colors,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
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
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        _buildStat(
                          Icons.replay_circle_filled_outlined,
                          'Runs',
                          (agent['runCount'] as int).toString(),
                          colors,
                        ),
                        const SizedBox(width: 24),
                        _buildStat(
                          Icons.access_time_outlined,
                          'Last Run',
                          agent['lastRunTime'] as String,
                          colors,
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
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
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF666666),
        ),
      ),
    );
  }
  
  Widget _buildStat(IconData icon, String label, String value, ThemeColorSet colors) {
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