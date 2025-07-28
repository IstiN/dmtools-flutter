import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'package:flutter/material.dart';

class McpConfigurationDisplay extends StatefulWidget {
  const McpConfigurationDisplay({
    required this.configuration,
    this.generatedCode,
    this.onEdit,
    this.onDelete,
    this.onRefreshCode,
    this.isLoading = false,
    this.selectedFormat = 'json',
    this.onFormatChanged,
    super.key,
  });

  final McpConfiguration configuration;
  final String? generatedCode;
  final VoidCallback? onEdit;
  final Future<bool> Function()? onDelete;
  final VoidCallback? onRefreshCode;
  final bool isLoading;
  final String selectedFormat;
  final ValueChanged<String?>? onFormatChanged;

  @override
  State<McpConfigurationDisplay> createState() => _McpConfigurationDisplayState();
}

class _McpConfigurationDisplayState extends State<McpConfigurationDisplay> with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  final ValueNotifier<bool> _showElevated = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _showElevated.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final show = _scrollController.offset > 0;
      if (_showElevated.value != show) {
        _showElevated.value = show;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final codeSection = _CodeSection(
      generatedCode: widget.generatedCode,
      isLoading: widget.isLoading,
      selectedFormat: widget.selectedFormat,
      onFormatChanged: widget.onFormatChanged,
      onRefreshCode: widget.onRefreshCode,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL, vertical: AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.configuration.name,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(color: colors.textColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppDimensions.spacingXs),
                      Text(
                        'ID: ${widget.configuration.id ?? 'N/A'}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: colors.textColor.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ),
                _ActionButtons(onEdit: widget.onEdit, onDelete: widget.onDelete),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Expanded(
              child: ListView(
                children: [
                  codeSection,
                  _IntegrationsSection(integrationIds: widget.configuration.integrationIds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({this.onEdit, this.onDelete});

  final VoidCallback? onEdit;
  final Future<bool> Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onEdit != null) AppIconButton(text: 'Edit', icon: Icons.edit_outlined, onPressed: onEdit),
        const SizedBox(width: AppDimensions.spacingS),
        if (onDelete != null)
          AppIconButton(
            text: 'Delete',
            icon: Icons.delete_outline,
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Configuration?'),
                  content: const Text(
                    'Are you sure you want to delete this MCP configuration? This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
                  ],
                ),
              );
              if (confirmed == true) {
                await onDelete!();
              }
            },
          ),
      ],
    );
  }
}

class _CodeSection extends StatelessWidget {
  final String? generatedCode;
  final bool isLoading;
  final String selectedFormat;
  final ValueChanged<String?>? onFormatChanged;
  final VoidCallback? onRefreshCode;

  const _CodeSection({
    required this.selectedFormat,
    this.generatedCode,
    this.isLoading = false,
    this.onFormatChanged,
    this.onRefreshCode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Custom handler that updates format and triggers refresh
    void handleFormatChange(String? newFormat) {
      if (newFormat != null && newFormat != selectedFormat) {
        // First update the format
        onFormatChanged?.call(newFormat);
        // Then trigger refresh with the new format
        onRefreshCode?.call();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Generated Configuration',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.cardBg,
            border: Border.all(color: colors.borderColor),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            boxShadow: [
              BoxShadow(color: colors.shadowColor.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Format:', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(width: AppDimensions.spacingM),
                    SizedBox(
                      width: 120,
                      child: SelectDropdown<String>(
                        value: selectedFormat,
                        items: const [
                          DropdownMenuItem(value: 'json', child: Text('JSON')),
                          DropdownMenuItem(value: 'cursor', child: Text('Cursor')),
                        ],
                        onChanged: handleFormatChange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingL),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (generatedCode != null)
                  CodeDisplayBlock(code: generatedCode!, language: selectedFormat, theme: CodeDisplayTheme.auto)
                else
                  const Center(child: Text('Could not load code.')),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
      ],
    );
  }
}

class _IntegrationsSection extends StatelessWidget {
  const _IntegrationsSection({required this.integrationIds});

  final List<String> integrationIds;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Integrations', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppDimensions.spacingM),
        if (integrationIds.isEmpty)
          const Center(child: Text('No integrations are configured for this MCP.'))
        else
          ...integrationIds.map(
            (id) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: colors.borderColor),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: ListTile(
                  leading: IntegrationTypeIcon(integrationType: id),
                  title: Text(id),
                  subtitle: Text('Description for $id'), // Placeholder for description
                  trailing: const TagChip(label: 'Enabled'),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
