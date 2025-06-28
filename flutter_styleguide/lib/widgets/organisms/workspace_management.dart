import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/buttons/app_buttons.dart';
import 'panel_base.dart';

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

class WorkspaceManagement extends StatelessWidget {
  final List<WorkspaceCard> workspaces;
  final Function(WorkspaceCard)? onWorkspaceSelected;
  final VoidCallback? onCreateWorkspace;
  final bool? isTestMode;
  final bool? testDarkMode;

  const WorkspaceManagement({
    required this.workspaces, super.key,
    this.onWorkspaceSelected,
    this.onCreateWorkspace,
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    dynamic colors;
    
    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Workspaces',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colors.textColor,
              ),
            ),
            PrimaryButton(
              text: 'Create Workspace',
              onPressed: onCreateWorkspace,
              icon: Icons.add,
              isTestMode: isTestMode ?? false,
              testDarkMode: isDarkMode,
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Workspaces list or empty state
        if (workspaces.isEmpty)
          _buildEmptyState(isDarkMode, colors)
        else
          PanelBase(
            title: 'Your Workspaces',
            isTestMode: isTestMode,
            testDarkMode: isDarkMode,
            content: Column(
              children: [
                for (var workspace in workspaces)
                  _buildWorkspaceCard(context, workspace, colors, isDarkMode),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDarkMode, dynamic colors) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: colors.borderColor,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_work,
            size: 48,
            color: colors.accentColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No Workspaces Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first workspace to start collaborating with your team.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Create Workspace',
            onPressed: onCreateWorkspace,
            isTestMode: isTestMode ?? false,
            testDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceCard(BuildContext context, WorkspaceCard workspace, dynamic colors, bool isDarkMode) {
    return InkWell(
      onTap: () => onWorkspaceSelected?.call(workspace),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? colors.bgColor : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: Border.all(color: colors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.accentColor,
                  child: Text(
                    workspace.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.textColor,
                        ),
                      ),
                      Text(
                        workspace.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                  context,
                  Icons.people,
                  '${workspace.memberCount} members',
                  colors,
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  context,
                  Icons.smart_toy,
                  '${workspace.agentCount} agents',
                  colors,
                ),
                const Spacer(),
                Text(
                  'Last active: ${_formatDate(workspace.lastActive)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label, dynamic colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: colors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
} 