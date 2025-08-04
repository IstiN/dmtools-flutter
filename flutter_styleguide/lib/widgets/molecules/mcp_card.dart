import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// A card component that displays MCP configuration information
///
/// This molecule shows an MCP configuration with its name, status,
/// integrations count, and provides action menu for management.
class McpCard extends StatelessWidget {
  const McpCard({
    required this.name,
    required this.status,
    required this.integrationIds,
    required this.availableIntegrations,
    this.description,
    this.createdAt,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onViewCode,
    this.onCopyCode,
    this.size = McpCardSize.medium,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  final String name;
  final String? description;
  final McpStatus status;
  final List<String> integrationIds;
  final List<IntegrationOption> availableIntegrations;
  final DateTime? createdAt;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final Future<bool> Function()? onDelete;
  final VoidCallback? onViewCode;
  final VoidCallback? onCopyCode;
  final McpCardSize size;
  final bool? isTestMode;
  final bool? testDarkMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimensions = _getDimensions();

    // Convert integration IDs to display names
    final integrationDisplayNames = integrationIds.map((id) {
      final integration = availableIntegrations.firstWhere(
        (integration) => integration.id == id,
        orElse: () => IntegrationOption(id: id, displayName: 'Unknown Integration', description: ''),
      );
      return integration.displayName;
    }).toList();

    return Material(
      color: colors.cardBg,
      borderRadius: BorderRadius.circular(dimensions.borderRadius),
      elevation: dimensions.elevation,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        child: Container(
          padding: EdgeInsets.all(dimensions.padding),
          decoration: BoxDecoration(
            border: Border.all(color: colors.borderColor, width: dimensions.borderWidth),
            borderRadius: BorderRadius.circular(dimensions.borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderRow(name: name, dimensions: dimensions),
              if (description != null) ...[
                SizedBox(height: dimensions.spacing),
                _DescriptionText(description: description!, dimensions: dimensions),
              ],
              SizedBox(height: dimensions.spacing),
              _IntegrationsPreview(integrationNames: integrationDisplayNames, dimensions: dimensions),
              if (createdAt != null) ...[
                SizedBox(height: dimensions.spacing),
                _CreatedAtText(createdAt: createdAt!, dimensions: dimensions),
              ],
              // Add action buttons at the bottom like AI Jobs
              _ActionButtons(
                onEdit: onEdit,
                onDelete: onDelete,
                isTestMode: isTestMode ?? false,
                testDarkMode: testDarkMode ?? false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _CardDimensions _getDimensions() {
    switch (size) {
      case McpCardSize.small:
        return const _CardDimensions(
          padding: 12,
          borderRadius: 8,
          borderWidth: 1,
          elevation: 1,
          spacing: 8,
          titleFontSize: 14,
          descriptionFontSize: 12,
          metaFontSize: 11,
          chipSize: McpStatusChipSize.small,
        );
      case McpCardSize.medium:
        return const _CardDimensions(
          padding: 16,
          borderRadius: 12,
          borderWidth: 1,
          elevation: 2,
          spacing: 12,
          titleFontSize: 16,
          descriptionFontSize: 14,
          metaFontSize: 12,
          chipSize: McpStatusChipSize.medium,
        );
      case McpCardSize.large:
        return const _CardDimensions(
          padding: 20,
          borderRadius: 16,
          borderWidth: 1,
          elevation: 3,
          spacing: 16,
          titleFontSize: 18,
          descriptionFontSize: 16,
          metaFontSize: 14,
          chipSize: McpStatusChipSize.large,
        );
    }
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.name, required this.dimensions});

  final String name;
  final _CardDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: dimensions.titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: colors.textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText({required this.description, required this.dimensions});

  final String description;
  final _CardDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Text(
      description,
      style: TextStyle(fontSize: dimensions.descriptionFontSize, color: colors.textColor.withOpacity(0.7), height: 1.4),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _IntegrationsPreview extends StatelessWidget {
  const _IntegrationsPreview({required this.integrationNames, required this.dimensions});

  final List<String> integrationNames;
  final _CardDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (integrationNames.isEmpty) {
      return Text(
        'No integrations configured',
        style: TextStyle(
          fontSize: dimensions.metaFontSize,
          color: colors.textColor.withOpacity(0.5),
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children:
          integrationNames.take(3).map((name) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.accentColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IntegrationTypeIcon(integrationType: name.toLowerCase(), size: dimensions.metaFontSize),
                  const SizedBox(width: 4),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: dimensions.metaFontSize,
                      color: colors.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList()..addAll([
            if (integrationNames.length > 3)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.textColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${integrationNames.length - 3} more',
                  style: TextStyle(
                    fontSize: dimensions.metaFontSize,
                    color: colors.textColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ]),
    );
  }
}

class _CreatedAtText extends StatelessWidget {
  const _CreatedAtText({required this.createdAt, required this.dimensions});

  final DateTime createdAt;
  final _CardDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    String timeAgo;
    if (difference.inDays > 0) {
      timeAgo = '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      timeAgo = '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      timeAgo = '${difference.inMinutes}m ago';
    } else {
      timeAgo = 'Just now';
    }

    return Text(
      'Created $timeAgo',
      style: TextStyle(fontSize: dimensions.metaFontSize, color: colors.textColor.withOpacity(0.5)),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({this.onEdit, this.onDelete, this.isTestMode = false, this.testDarkMode = false});

  final VoidCallback? onEdit;
  final Future<bool> Function()? onDelete;
  final bool isTestMode;
  final bool testDarkMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingS),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderColor.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          const Spacer(),
          AppIconButton(
            text: 'Edit',
            icon: Icons.edit,
            onPressed: onEdit,
            size: ButtonSize.small,
            isTestMode: isTestMode,
            testDarkMode: testDarkMode,
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          AppIconButton(
            text: 'Delete',
            icon: Icons.delete,
            onPressed: onDelete,
            size: ButtonSize.small,
            isTestMode: isTestMode,
            testDarkMode: testDarkMode,
          ),
        ],
      ),
    );
  }
}

class _ActionMenu extends StatefulWidget {
  const _ActionMenu();

  @override
  State<_ActionMenu> createState() => _ActionMenuState();
}

class _ActionMenuState extends State<_ActionMenu> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: colors.textColor.withValues(alpha: 0.6), size: 20),
      onSelected: (value) {
        // Demo menu - no actual actions
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16, color: colors.textColor),
              const SizedBox(width: 8),
              const Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'view_code',
          child: Row(
            children: [
              Icon(Icons.code, size: 16, color: colors.textColor),
              const SizedBox(width: 8),
              const Text('View Code'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'copy_code',
          child: Row(
            children: [
              Icon(Icons.copy, size: 16, color: colors.textColor),
              const SizedBox(width: 8),
              const Text('Copy Code'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 16, color: colors.dangerColor),
              const SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: colors.dangerColor)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Size variants for the MCP card
enum McpCardSize { small, medium, large }

class _CardDimensions {
  const _CardDimensions({
    required this.padding,
    required this.borderRadius,
    required this.borderWidth,
    required this.elevation,
    required this.spacing,
    required this.titleFontSize,
    required this.descriptionFontSize,
    required this.metaFontSize,
    required this.chipSize,
  });

  final double padding;
  final double borderRadius;
  final double borderWidth;
  final double elevation;
  final double spacing;
  final double titleFontSize;
  final double descriptionFontSize;
  final double metaFontSize;
  final McpStatusChipSize chipSize;
}
