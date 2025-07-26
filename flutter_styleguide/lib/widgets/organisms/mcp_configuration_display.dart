import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Display modes for the configuration
enum McpDisplayMode { overview, code, integrations }

/// Theme options for code display
enum McpCodeTheme { light, dark, auto }

/// Output format options for generated code
enum McpCodeFormat {
  cursor('Cursor', 'For Cursor IDE integration'),
  json('JSON', 'Standard JSON configuration'),
  shell('Shell', 'Command line usage');

  const McpCodeFormat(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// Complete configuration display for MCP configurations
///
/// This organism provides configuration overview, generated code display,
/// integration management, and action handling. Includes responsive layout.
class McpConfigurationDisplay extends StatefulWidget {
  const McpConfigurationDisplay({
    required this.configuration,
    this.generatedCode,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
    this.onRefreshCode,
    this.onCopyCode,
    this.onDownloadCode,
    this.initialMode = McpDisplayMode.overview,
    this.codeTheme = McpCodeTheme.auto,
    this.showActions = true,
    this.showModeToggle = true,
    this.isLoading = false,
    this.error,
    super.key,
  });

  final McpConfiguration configuration;
  final String? generatedCode;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final VoidCallback? onRefreshCode;
  final VoidCallback? onCopyCode;
  final VoidCallback? onDownloadCode;
  final McpDisplayMode initialMode;
  final McpCodeTheme codeTheme;
  final bool showActions;
  final bool showModeToggle;
  final bool isLoading;
  final String? error;

  @override
  State<McpConfigurationDisplay> createState() => _McpConfigurationDisplayState();
}

class _McpConfigurationDisplayState extends State<McpConfigurationDisplay> {
  late McpDisplayMode _currentMode;
  McpCodeFormat _selectedFormat = McpCodeFormat.json;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.initialMode;
  }

  void _setMode(McpDisplayMode mode) {
    setState(() {
      _currentMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _HeaderSection(
          configuration: widget.configuration,
          onEdit: widget.onEdit,
          onDelete: widget.onDelete,
          onDuplicate: widget.onDuplicate,
          showActions: widget.showActions,
          colors: colors,
        ),

        if (widget.showModeToggle) _ModeToggle(currentMode: _currentMode, onModeChanged: _setMode, colors: colors),

        Expanded(
          child: widget.isLoading
              ? _LoadingContent(colors: colors)
              : widget.error != null
              ? _ErrorContent(error: widget.error!, onRetry: widget.onRefreshCode, colors: colors)
              : _buildContent(colors),
        ),
      ],
    );
  }

  Widget _buildContent(ThemeColorSet colors) {
    switch (_currentMode) {
      case McpDisplayMode.overview:
        return _OverviewContent(configuration: widget.configuration, colors: colors);
      case McpDisplayMode.code:
        return _CodeContent(
          configuration: widget.configuration,
          generatedCode: widget.generatedCode,
          selectedFormat: _selectedFormat,
          onFormatChanged: (format) => setState(() => _selectedFormat = format),
          onCopyCode: widget.onCopyCode,
          onDownloadCode: widget.onDownloadCode,
          onRefreshCode: widget.onRefreshCode,
          codeTheme: widget.codeTheme,
          colors: colors,
        );
      case McpDisplayMode.integrations:
        return _IntegrationsContent(configuration: widget.configuration, colors: colors);
    }
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.configuration,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
    required this.showActions,
    required this.colors,
  });

  final McpConfiguration configuration;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final bool showActions;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBg,
        border: Border(bottom: BorderSide(color: colors.borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  configuration.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textColor),
                ),
                const SizedBox(height: 8),
                if (configuration.createdAt != null)
                  Text(
                    'Created ${_formatDate(configuration.createdAt!)}',
                    style: TextStyle(fontSize: 14, color: colors.textColor.withValues(alpha: 0.7)),
                  ),
                const SizedBox(height: 4),
                if (configuration.id != null)
                  Text(
                    'ID: ${configuration.id}',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textColor.withValues(alpha: 0.5),
                      fontFamily: 'monospace',
                    ),
                  ),
              ],
            ),
          ),
          if (showActions) ...[
            const SizedBox(width: 16),
            _ActionMenu(onEdit: onEdit, onDelete: onDelete, onDuplicate: onDuplicate, colors: colors),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

class _ActionMenu extends StatelessWidget {
  const _ActionMenu({required this.onEdit, required this.onDelete, required this.onDuplicate, required this.colors});

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: colors.textColor),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'duplicate':
            onDuplicate?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        if (onEdit != null)
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
        if (onDuplicate != null)
          PopupMenuItem(
            value: 'duplicate',
            child: Row(
              children: [
                Icon(Icons.copy, size: 16, color: colors.textColor),
                const SizedBox(width: 8),
                const Text('Duplicate'),
              ],
            ),
          ),
        if (onDelete != null) ...[
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
      ],
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.currentMode, required this.onModeChanged, required this.colors});

  final McpDisplayMode currentMode;
  final ValueChanged<McpDisplayMode> onModeChanged;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colors.cardBg,
        border: Border(bottom: BorderSide(color: colors.borderColor)),
      ),
      child: Row(
        children: [
          _ModeButton(
            label: 'Overview',
            icon: Icons.info_outline,
            isSelected: currentMode == McpDisplayMode.overview,
            onPressed: () => onModeChanged(McpDisplayMode.overview),
            colors: colors,
          ),
          const SizedBox(width: 8),
          _ModeButton(
            label: 'Code',
            icon: Icons.code,
            isSelected: currentMode == McpDisplayMode.code,
            onPressed: () => onModeChanged(McpDisplayMode.code),
            colors: colors,
          ),
          const SizedBox(width: 8),
          _ModeButton(
            label: 'Integrations',
            icon: Icons.extension,
            isSelected: currentMode == McpDisplayMode.integrations,
            onPressed: () => onModeChanged(McpDisplayMode.integrations),
            colors: colors,
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
    required this.colors,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? colors.accentColor : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : colors.textColor.withValues(alpha: 0.7)),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : colors.textColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({required this.colors});

  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colors.accentColor),
          const SizedBox(height: 16),
          Text('Loading configuration...', style: TextStyle(color: colors.textColor.withValues(alpha: 0.7))),
        ],
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.error, required this.onRetry, required this.colors});

  final String error;
  final VoidCallback? onRetry;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colors.dangerColor),
            const SizedBox(height: 16),
            Text(
              'Error Loading Configuration',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textColor.withValues(alpha: 0.7)),
            ),
            if (onRetry != null) ...[const SizedBox(height: 24), PrimaryButton(text: 'Retry', onPressed: onRetry!)],
          ],
        ),
      ),
    );
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.configuration, required this.colors});

  final McpConfiguration configuration;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatsSection(configuration: configuration, colors: colors),
          const SizedBox(height: 32),

          _IntegrationsSummary(
            title: 'Configured Integrations',
            integrations: configuration.integrations,
            emptyMessage: 'No integrations configured',
            colors: colors,
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.configuration, required this.colors});

  final McpConfiguration configuration;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    final integrationCount = configuration.integrations.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuration Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Integrations',
                  value: '$integrationCount',
                  icon: Icons.extension,
                  colors: colors,
                ),
              ),
              Expanded(
                child: _StatItem(label: 'Token', value: 'Generated', icon: Icons.key, colors: colors),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Created',
                  value: configuration.createdAt != null
                      ? '${configuration.createdAt!.day}/${configuration.createdAt!.month}/${configuration.createdAt!.year}'
                      : 'Unknown',
                  icon: Icons.calendar_today,
                  colors: colors,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: 'Token',
                  value: configuration.token != null ? '${configuration.token!.substring(0, 8)}...' : 'Not generated',
                  icon: Icons.security,
                  colors: colors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value, required this.icon, required this.colors});

  final String label;
  final String value;
  final IconData icon;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.textColor.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: colors.textColor.withValues(alpha: 0.7))),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textColor),
            ),
          ],
        ),
      ],
    );
  }
}

class _IntegrationsSummary extends StatelessWidget {
  const _IntegrationsSummary({
    required this.title,
    required this.integrations,
    required this.emptyMessage,
    required this.colors,
  });

  final String title;
  final List<McpIntegrationType> integrations;
  final String emptyMessage;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
        ),
        const SizedBox(height: 12),
        if (integrations.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.borderColor),
            ),
            child: Text(
              emptyMessage,
              style: TextStyle(color: colors.textColor.withValues(alpha: 0.7), fontStyle: FontStyle.italic),
            ),
          )
        else
          ...integrations.map(
            (integration) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.borderColor),
              ),
              child: Row(
                children: [
                  IntegrationTypeIcon(integrationType: integration.name, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      integration.displayName,
                      style: TextStyle(fontWeight: FontWeight.w500, color: colors.textColor),
                    ),
                  ),
                  Icon(Icons.check_circle, color: colors.successColor, size: 16),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _CodeContent extends StatelessWidget {
  const _CodeContent({
    required this.configuration,
    required this.generatedCode,
    required this.selectedFormat,
    required this.onFormatChanged,
    required this.onCopyCode,
    required this.onDownloadCode,
    required this.onRefreshCode,
    required this.codeTheme,
    required this.colors,
  });

  final McpConfiguration configuration;
  final String? generatedCode;
  final McpCodeFormat selectedFormat;
  final ValueChanged<McpCodeFormat> onFormatChanged;
  final VoidCallback? onCopyCode;
  final VoidCallback? onDownloadCode;
  final VoidCallback? onRefreshCode;
  final McpCodeTheme codeTheme;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    final code = generatedCode ?? _generateDefaultCode();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Generated Configuration',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(color: colors.textColor.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CodeHeader(
                  selectedFormat: selectedFormat,
                  onFormatChanged: onFormatChanged,
                  formattedCode: _getFormattedCode(code, selectedFormat),
                  onCopyCode: onCopyCode,
                  onDownloadCode: onDownloadCode,
                  onRefreshCode: onRefreshCode,
                  colors: colors,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 400,
                  child: CodeDisplayBlock(
                    code: _getFormattedCode(code, selectedFormat),
                    language: _getLanguageForFormat(selectedFormat),
                    showLineNumbers: true,
                    theme: _getCodeDisplayTheme(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedCode(String code, McpCodeFormat format) {
    switch (format) {
      case McpCodeFormat.cursor:
        return _generateCursorFormat();
      case McpCodeFormat.json:
        return code; // Already in JSON format
      case McpCodeFormat.shell:
        return _generateShellFormat();
    }
  }

  String _getLanguageForFormat(McpCodeFormat format) {
    switch (format) {
      case McpCodeFormat.cursor:
        return 'json';
      case McpCodeFormat.json:
        return 'json';
      case McpCodeFormat.shell:
        return 'bash';
    }
  }

  String _generateCursorFormat() {
    // Generate Cursor IDE integration format
    return '''
{
  "mcpServers": {
    "${configuration.name.toLowerCase().replaceAll(' ', '-')}": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-${configuration.name.toLowerCase()}"],
      "env": {
${configuration.integrations.map((integration) => '        "${integration.name.toUpperCase()}_API_KEY": "your-${integration.name}-api-key"').join(',\n')}
      }
    }
  }
}''';
  }

  String _generateShellFormat() {
    // Generate shell command format
    final envVars = configuration.integrations
        .map((integration) => '${integration.name.toUpperCase()}_API_KEY="your-${integration.name}-api-key"')
        .join(' ');

    return '''
# MCP Configuration: ${configuration.name}
# Set environment variables
export $envVars

# Run MCP server
npx -y @modelcontextprotocol/server-${configuration.name.toLowerCase().replaceAll(' ', '-')}''';
  }

  CodeDisplayTheme _getCodeDisplayTheme() {
    switch (codeTheme) {
      case McpCodeTheme.light:
        return CodeDisplayTheme.light;
      case McpCodeTheme.dark:
        return CodeDisplayTheme.dark;
      case McpCodeTheme.auto:
        return CodeDisplayTheme.auto;
    }
  }

  String _generateDefaultCode() {
    return '''
{
  "mcpServers": {
    "${configuration.name.toLowerCase().replaceAll(' ', '-')}": {
      "command": "npx",
      "args": ["@dmtools/mcp-server"],
      "env": {
        "DMTOOLS_TOKEN": "${configuration.token ?? 'GENERATE_TOKEN'}",
        "DMTOOLS_INTEGRATIONS": "${configuration.integrations.map((i) => i.name).join(',')}"
      }
    }
  }
}''';
  }
}

class _CodeHeader extends StatelessWidget {
  const _CodeHeader({
    required this.selectedFormat,
    required this.onFormatChanged,
    required this.formattedCode,
    required this.onCopyCode,
    required this.onDownloadCode,
    required this.onRefreshCode,
    required this.colors,
  });

  final McpCodeFormat selectedFormat;
  final ValueChanged<McpCodeFormat> onFormatChanged;
  final String formattedCode;
  final VoidCallback? onCopyCode;
  final VoidCallback? onDownloadCode;
  final VoidCallback? onRefreshCode;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Format:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textColor.withValues(alpha: 0.7)),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colors.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<McpCodeFormat>(
              value: selectedFormat,
              onChanged: (format) => format != null ? onFormatChanged(format) : null,
              style: TextStyle(color: colors.textColor, fontSize: 14, fontWeight: FontWeight.w500),
              dropdownColor: colors.cardBg,
              icon: Icon(Icons.arrow_drop_down, color: colors.textColor.withValues(alpha: 0.7), size: 18),
              items: McpCodeFormat.values.map((format) {
                return DropdownMenuItem<McpCodeFormat>(value: format, child: Text(format.displayName));
              }).toList(),
            ),
          ),
        ),
        const Spacer(),
        if (onCopyCode != null) ...[
          CopyButton(
            textToCopy: formattedCode,
            variant: CopyButtonVariant.iconOnly,
            size: CopyButtonSize.small,
            onCopied: onCopyCode,
          ),
          const SizedBox(width: 8),
        ],
        if (onDownloadCode != null) ...[
          IconButton(
            onPressed: onDownloadCode,
            icon: Icon(Icons.download, color: colors.textColor.withValues(alpha: 0.7), size: 20),
            tooltip: 'Download',
            iconSize: 20,
          ),
          const SizedBox(width: 8),
        ],
        if (onRefreshCode != null)
          IconButton(
            onPressed: onRefreshCode,
            icon: Icon(Icons.refresh, color: colors.textColor.withValues(alpha: 0.7), size: 20),
            tooltip: 'Refresh Code',
            iconSize: 20,
          ),
      ],
    );
  }
}

class _IntegrationsContent extends StatelessWidget {
  const _IntegrationsContent({required this.configuration, required this.colors});

  final McpConfiguration configuration;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Integration Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor),
          ),
          const SizedBox(height: 20),

          ...configuration.integrations.map(
            (integration) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(color: colors.textColor.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IntegrationTypeIcon(integrationType: integration.name),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              integration.displayName,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Type: ${integration.name}',
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.textColor.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colors.successColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Enabled',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.successColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    integration.description,
                    style: TextStyle(fontSize: 14, color: colors.textColor.withValues(alpha: 0.7), height: 1.4),
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
