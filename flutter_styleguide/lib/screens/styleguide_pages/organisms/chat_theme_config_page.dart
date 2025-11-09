import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../../../widgets/styleguide/component_display.dart';

class ChatThemeConfigPage extends StatefulWidget {
  const ChatThemeConfigPage({super.key});

  @override
  State<ChatThemeConfigPage> createState() => _ChatThemeConfigPageState();
}

class _ChatThemeConfigPageState extends State<ChatThemeConfigPage> {
  ChatTheme _currentTheme = ChatTheme.day();
  bool _darkMode = false;
  bool _bubbleMode = true;
  double _textSize = 1.0;
  Color _nameColor = const Color(0xFF4285F4);

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Scaffold(
      backgroundColor: colors.bgColor,
      appBar: AppBar(
        title: const Text('Chat Theme Config'),
        backgroundColor: colors.cardBg,
        foregroundColor: colors.textColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Chat Theme Configuration',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: colors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Component for configuring chat themes with live preview, theme selection, accent colors, and various settings.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.spacingXl),

            // Component Display
            ComponentDisplay(
              title: 'Chat Theme Config',
              description: 'Full-featured chat theme configuration interface with live preview.',
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                decoration: BoxDecoration(
                  color: colors.cardBg,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(color: colors.borderColor),
                ),
                child: ChatThemeConfig(
                  initialTheme: _currentTheme,
                  initialDarkMode: _darkMode,
                  initialBubbleMode: _bubbleMode,
                  initialTextSize: _textSize,
                  initialNameColor: _nameColor,
                  onThemeChanged: (theme) {
                    setState(() {
                      _currentTheme = theme;
                    });
                  },
                  onDarkModeChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                  onBubbleModeChanged: (value) {
                    setState(() {
                      _bubbleMode = value;
                    });
                  },
                  onTextSizeChanged: (value) {
                    setState(() {
                      _textSize = value;
                    });
                  },
                  onNameColorChanged: (color) {
                    setState(() {
                      _nameColor = color;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.spacingXl),

            // Properties Table
            _buildPropertiesTable(colors),

            const SizedBox(height: AppDimensions.spacingXl),

            // Usage Example
            _buildUsageExample(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertiesTable(ThemeColorSet colors) {
    final properties = [
      {'property': 'initialTheme', 'type': 'ChatTheme', 'description': 'Initial theme configuration'},
      {'property': 'onThemeChanged', 'type': 'ValueChanged<ChatTheme>?', 'description': 'Callback when theme changes'},
      {'property': 'initialDarkMode', 'type': 'bool', 'description': 'Initial dark mode state'},
      {'property': 'onDarkModeChanged', 'type': 'ValueChanged<bool>?', 'description': 'Callback when dark mode toggles'},
      {'property': 'initialBubbleMode', 'type': 'bool', 'description': 'Initial bubble mode state'},
      {'property': 'onBubbleModeChanged', 'type': 'ValueChanged<bool>?', 'description': 'Callback when bubble mode toggles'},
      {'property': 'initialTextSize', 'type': 'double', 'description': 'Initial text size multiplier'},
      {'property': 'onTextSizeChanged', 'type': 'ValueChanged<double>?', 'description': 'Callback when text size changes'},
      {'property': 'initialNameColor', 'type': 'Color', 'description': 'Initial name color'},
      {'property': 'onNameColorChanged', 'type': 'ValueChanged<Color>?', 'description': 'Callback when name color changes'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Properties',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.textColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Container(
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            border: Border.all(color: colors.borderColor),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(4),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: colors.bgColor,
                  border: Border(bottom: BorderSide(color: colors.borderColor)),
                ),
                children: [
                  _buildTableCell('Property', colors, isHeader: true),
                  _buildTableCell('Type', colors, isHeader: true),
                  _buildTableCell('Description', colors, isHeader: true),
                ],
              ),
              ...properties.map((prop) => TableRow(
                    children: [
                      _buildTableCell(prop['property']!, colors),
                      _buildTableCell(prop['type']!, colors, isCode: true),
                      _buildTableCell(prop['description']!, colors),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, ThemeColorSet colors, {bool isHeader = false, bool isCode = false}) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingS),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 14 : 13,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? colors.textColor : (isCode ? colors.accentColor : colors.textSecondary),
          fontFamily: isCode ? 'monospace' : null,
        ),
      ),
    );
  }

  Widget _buildUsageExample(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage Example',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.textColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            border: Border.all(color: colors.borderColor),
          ),
          child: SelectableText(
            '''ChatThemeConfig(
  initialTheme: ChatTheme.day(),
  initialDarkMode: false,
  initialBubbleMode: true,
  initialTextSize: 1.0,
  initialNameColor: Color(0xFF4285F4),
  onThemeChanged: (theme) {
    // Handle theme change
  },
  onDarkModeChanged: (value) {
    // Handle dark mode toggle
  },
  onBubbleModeChanged: (value) {
    // Handle bubble mode toggle
  },
  onTextSizeChanged: (value) {
    // Handle text size change
  },
  onNameColorChanged: (color) {
    // Handle name color change
  },
  onWallpaperPressed: () {
    // Navigate to wallpaper selection
  },
  onAutoNightModePressed: () {
    // Navigate to auto-night mode config
  },
)''',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: colors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}

