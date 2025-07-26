import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Status types for MCP configurations
enum McpStatus {
  active('Active', Icons.check_circle),
  inactive('Inactive', Icons.cancel),
  error('Error', Icons.error),
  pending('Pending', Icons.schedule);

  const McpStatus(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// A chip component that displays MCP status with integration count
///
/// This atom shows the status of an MCP configuration along with
/// the number of active integrations. Used in lists and detail views.
class McpStatusChip extends StatelessWidget {
  const McpStatusChip({
    required this.status,
    required this.integrationCount,
    this.size = McpStatusChipSize.medium,
    super.key,
  });

  final McpStatus status;
  final int integrationCount;
  final McpStatusChipSize size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimensions = _getDimensions();
    final statusColor = _getStatusColor(colors);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: dimensions.horizontalPadding, vertical: dimensions.verticalPadding),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: dimensions.iconSize, color: statusColor),
          SizedBox(width: dimensions.spacing),
          Text(
            integrationCount > 0 ? '${status.label} ($integrationCount)' : status.label,
            style: TextStyle(fontSize: dimensions.fontSize, fontWeight: FontWeight.w500, color: statusColor),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ThemeColorSet colors) {
    switch (status) {
      case McpStatus.active:
        return colors.successColor;
      case McpStatus.inactive:
        return colors.textColor.withOpacity(0.6);
      case McpStatus.error:
        return colors.dangerColor;
      case McpStatus.pending:
        return colors.warningColor;
    }
  }

  _ChipDimensions _getDimensions() {
    switch (size) {
      case McpStatusChipSize.small:
        return const _ChipDimensions(
          horizontalPadding: 8,
          verticalPadding: 4,
          borderRadius: 12,
          iconSize: 12,
          fontSize: 11,
          spacing: 4,
        );
      case McpStatusChipSize.medium:
        return const _ChipDimensions(
          horizontalPadding: 12,
          verticalPadding: 6,
          borderRadius: 16,
          iconSize: 16,
          fontSize: 13,
          spacing: 6,
        );
      case McpStatusChipSize.large:
        return const _ChipDimensions(
          horizontalPadding: 16,
          verticalPadding: 8,
          borderRadius: 20,
          iconSize: 20,
          fontSize: 15,
          spacing: 8,
        );
    }
  }
}

/// Size variants for the MCP status chip
enum McpStatusChipSize { small, medium, large }

class _ChipDimensions {
  const _ChipDimensions({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
    required this.iconSize,
    required this.fontSize,
    required this.spacing,
  });

  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double iconSize;
  final double fontSize;
  final double spacing;
}
