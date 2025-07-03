import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../atoms/integration_type_icon.dart';
import '../atoms/integration_status_badge.dart';

/// Comprehensive card component for displaying integration information
class IntegrationCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String type;
  final String displayName;
  final bool enabled;
  final String? iconUrl;
  final int usageCount;
  final DateTime? lastUsedAt;
  final DateTime createdAt;
  final String createdByName;
  final List<String> workspaces;
  final VoidCallback? onEnable;
  final VoidCallback? onDisable;
  final VoidCallback? onTest;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final bool? isTestMode;
  final bool? testDarkMode;

  const IntegrationCard({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.displayName,
    required this.enabled,
    required this.usageCount,
    required this.createdAt,
    required this.createdByName,
    required this.workspaces,
    this.iconUrl,
    this.lastUsedAt,
    this.onEnable,
    this.onDisable,
    this.onTest,
    this.onEdit,
    this.onDelete,
    this.onShare,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = isTestMode == true ? (testDarkMode == true ? AppColors.dark : AppColors.light) : context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with integration type and status
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: colors.accentColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusM),
                topRight: Radius.circular(AppDimensions.radiusM),
              ),
            ),
            child: Row(
              children: [
                IntegrationTypeIcon(
                  integrationType: type,
                  iconUrl: iconUrl,
                  isTestMode: isTestMode,
                  testDarkMode: testDarkMode,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IntegrationStatusBadge(
                  status: enabled ? IntegrationStatus.enabled : IntegrationStatus.disabled,
                  isTestMode: isTestMode,
                  testDarkMode: testDarkMode,
                ),
              ],
            ),
          ),
          // Content
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    description,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  // Stats - simplified to prevent overflow
                  SizedBox(
                    height: AppDimensions.inputHeight + AppDimensions.spacingXs, // Fixed height to prevent overflow
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // If very narrow, show only key stats in compact format
                        if (constraints.maxWidth < 200) {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildCompactStat(
                                  usageCount.toString(),
                                  'Uses',
                                  Icons.analytics,
                                  colors,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spacingXs),
                              Expanded(
                                child: _buildCompactStat(
                                  _formatDate(lastUsedAt),
                                  'Last',
                                  Icons.access_time,
                                  colors,
                                ),
                              ),
                            ],
                          );
                        }
                        // Default horizontal layout with 3 stats
                        return Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                'Usage Count',
                                usageCount.toString(),
                                Icons.analytics,
                                colors,
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                'Workspaces',
                                workspaces.length.toString(),
                                Icons.business,
                                colors,
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                'Last Used',
                                _formatDate(lastUsedAt),
                                Icons.access_time,
                                colors,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  // Created info
                  Text(
                    'Created by $createdByName on ${_formatDate(createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  // Action buttons
                  Row(
                    children: [
                      if (enabled) ...[
                        SecondaryButton(
                          text: 'Disable',
                          onPressed: onDisable,
                          size: ButtonSize.small,
                          isTestMode: isTestMode ?? false,
                          testDarkMode: testDarkMode ?? false,
                        ),
                      ] else ...[
                        PrimaryButton(
                          text: 'Enable',
                          onPressed: onEnable,
                          size: ButtonSize.small,
                          isTestMode: isTestMode ?? false,
                          testDarkMode: testDarkMode ?? false,
                        ),
                      ],
                      const SizedBox(width: AppDimensions.spacingS),
                      OutlineButton(
                        text: 'Test',
                        onPressed: onTest,
                        size: ButtonSize.small,
                        isTestMode: isTestMode ?? false,
                        testDarkMode: testDarkMode ?? false,
                      ),
                      const Spacer(),
                      // More actions
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: colors.textMuted,
                          size: AppDimensions.iconSizeS + 2, // 18px equivalent
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              onEdit?.call();
                              break;
                            case 'share':
                              onShare?.call();
                              break;
                            case 'delete':
                              onDelete?.call();
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: AppDimensions.iconSizeS, color: colors.textColor),
                                const SizedBox(width: AppDimensions.spacingXs),
                                Text('Edit', style: TextStyle(color: colors.textColor)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'share',
                            child: Row(
                              children: [
                                Icon(Icons.share, size: AppDimensions.iconSizeS, color: colors.textColor),
                                const SizedBox(width: AppDimensions.spacingXs),
                                Text('Share', style: TextStyle(color: colors.textColor)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: AppDimensions.iconSizeS, color: colors.dangerColor),
                                const SizedBox(width: AppDimensions.spacingXs),
                                Text('Delete', style: TextStyle(color: colors.dangerColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, ThemeColorSet colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppDimensions.iconSizeXs - 2, color: colors.textMuted), // 12px equivalent
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: colors.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCompactStat(String value, String label, IconData icon, ThemeColorSet colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.textColor,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: colors.textMuted,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 30) {
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
