import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class WorkspaceCard {
  final String name;
  final String description;
  final int memberCount;
  final int agentCount;
  final DateTime lastActive;

  WorkspaceCard({
    required this.name,
    required this.description,
    required this.memberCount,
    required this.agentCount,
    required this.lastActive,
  });
}

class WorkspaceSummary extends StatelessWidget {
  const WorkspaceSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;

    // Sample workspace data
    final workspaces = [
      WorkspaceCard(
        name: 'Marketing',
        description: 'Marketing team workspace',
        memberCount: 8,
        agentCount: 5,
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      WorkspaceCard(
        name: 'Development',
        description: 'Software development team',
        memberCount: 12,
        agentCount: 8,
        lastActive: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      WorkspaceCard(
        name: 'Customer Support',
        description: 'Customer support team',
        memberCount: 6,
        agentCount: 10,
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  'Your Workspaces',
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
              children: [
                // Workspace stats
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: 150,
                      child: _buildStatCard(
                        context,
                        '3',
                        'Workspaces',
                        Icons.folder_outlined,
                        colors.accentColor,
                        colors,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: _buildStatCard(
                        context,
                        '23',
                        'Agents',
                        Icons.smart_toy_outlined,
                        colors.successColor,
                        colors,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Workspace list
                ...workspaces.map((workspace) => _buildWorkspaceItem(context, workspace, colors)).toList(),
                
                const SizedBox(height: 16),
                
                // View all button
                SizedBox(
                  width: double.infinity,
                  child: OutlineButton(
                    text: 'View All Workspaces',
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

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color iconColor,
    ThemeColorSet colors,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceItem(BuildContext context, WorkspaceCard workspace, ThemeColorSet colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: colors.accentColor,
            child: Text(
              workspace.name.substring(0, 1),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workspace.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors.textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${workspace.memberCount} members · ${workspace.agentCount} agents',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: colors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
} 