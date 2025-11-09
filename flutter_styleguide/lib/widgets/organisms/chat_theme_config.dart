import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'font_picker_widget.dart';

/// Chat theme configuration widget matching the screenshot design
class ChatThemeConfig extends StatefulWidget {
  final ChatTheme initialTheme;
  final ValueChanged<ChatTheme>? onThemeChanged;
  final bool initialDarkMode;
  final ValueChanged<bool>? onDarkModeChanged;
  final bool initialBubbleMode;
  final ValueChanged<bool>? onBubbleModeChanged;
  final double initialTextSize;
  final ValueChanged<double>? onTextSizeChanged;
  final Color initialNameColor;
  final ValueChanged<Color>? onNameColorChanged;

  const ChatThemeConfig({
    required this.initialTheme,
    super.key,
    this.onThemeChanged,
    this.initialDarkMode = false,
    this.onDarkModeChanged,
    this.initialBubbleMode = true,
    this.onBubbleModeChanged,
    this.initialTextSize = 1.0,
    this.onTextSizeChanged,
    this.initialNameColor = const Color(0xFF4285F4),
    this.onNameColorChanged,
  });

  @override
  State<ChatThemeConfig> createState() => _ChatThemeConfigState();
}

class _ChatThemeConfigState extends State<ChatThemeConfig> {
  late ChatTheme _currentTheme;
  late bool _darkMode;
  late bool _bubbleMode;
  late double _textSize;
  late Color _nameColor;
  late ChatThemeType _selectedThemeType;
  late bool _showAgentName;
  late String _selectedFont;

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.initialTheme;
    _darkMode = widget.initialDarkMode;
    _bubbleMode = widget.initialBubbleMode;
    _textSize = widget.initialTextSize;
    _nameColor = widget.initialNameColor;
    _selectedThemeType = ChatThemeType.day;
    _showAgentName = widget.initialTheme.showAgentName;
    _selectedFont = widget.initialTheme.fontFamily ?? 'Inter';
  }

  void _selectThemeType(ChatThemeType themeType) {
    setState(() {
      _selectedThemeType = themeType;
      final newTheme = themeType.toTheme();
      // Preserve current background colors if they're null (system background)
      final preservedBackgroundLight = _currentTheme.backgroundColorLight == null 
          ? null 
          : newTheme.backgroundColorLight;
      final preservedBackgroundDark = _currentTheme.backgroundColorDark == null 
          ? null 
          : newTheme.backgroundColorDark;
      _currentTheme = newTheme.copyWith(
            textSize: _textSize,
            bubbleMode: _bubbleMode,
            nameColor: _nameColor,
            showAgentName: _showAgentName,
            fontFamily: _selectedFont == 'Inter' ? null : _selectedFont,
            backgroundColorLight: preservedBackgroundLight,
            backgroundColorDark: preservedBackgroundDark,
          );
      _updateLocalStateFromTheme();
    });
    widget.onThemeChanged?.call(_currentTheme);
  }


  void _updateLocalStateFromTheme() {
    _textSize = _currentTheme.textSize;
    _bubbleMode = _currentTheme.bubbleMode;
    _nameColor = _currentTheme.nameColor;
    _showAgentName = _currentTheme.showAgentName;
    _selectedFont = _currentTheme.fontFamily ?? 'Inter';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // COLOR THEME Section (above preview)
          _buildColorThemeSection(colors),

          const SizedBox(height: AppDimensions.spacingXl),

          // Chat Preview with side controls
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side controls
              Expanded(
                child: _buildLeftSideControls(colors),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              // Chat Preview (wider)
              Expanded(
                flex: 3,
                child: _buildChatPreview(colors),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              // Right side controls
              Expanded(
                child: _buildRightSideControls(colors),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // TEXT SIZE and FONT FAMILY Section (in one line, immediately under preview)
          _buildTextSizeAndFontSection(colors),

          const SizedBox(height: AppDimensions.spacingXl),

          // Settings List (bottom)
          _buildSettingsList(colors),

          const SizedBox(height: AppDimensions.spacingXl),

          // Chat Background Color
          _buildChatBackgroundColorSection(colors),
        ],
      ),
    );
  }

  Widget _buildChatPreview(ThemeColorSet colors) {
    // Use theme backgroundColor based on dark mode, otherwise transparent
    final backgroundColor = _currentTheme.getBackgroundColor(_darkMode) ?? Colors.transparent;

    // Apply bubble mode - use rounded rectangles if false, circles if true
    final borderRadius = _currentTheme.bubbleMode ? 18.0 : 8.0;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI/Incoming messages (left) - from "DM.ai"
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vertical line indicator
              Container(
                width: 3,
                height: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: _currentTheme.nameColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sender name (only if showAgentName is true)
                    if (_currentTheme.showAgentName) ...[
                      Text(
                        _currentTheme.agentName,
                        style: TextStyle(
                          fontSize: 14 * _currentTheme.textSize,
                          fontWeight: FontWeight.w500,
                          color: _currentTheme.nameColor,
                          fontFamily: _currentTheme.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    // Message bubble with timestamp inside
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _currentTheme.aiMessageColor,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning! 👋',
                            style: TextStyle(
                              fontSize: 14 * _currentTheme.textSize,
                              color: _currentTheme.aiMessageTextColor,
                              fontFamily: _currentTheme.fontFamily,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '21:20',
                            style: TextStyle(
                              fontSize: 10 * _currentTheme.textSize,
                              color: _currentTheme.dateTextColor,
                              fontFamily: _currentTheme.fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _currentTheme.aiMessageColor,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Do you know what time it is?',
                            style: TextStyle(
                              fontSize: 14 * _currentTheme.textSize,
                              color: _currentTheme.aiMessageTextColor,
                              fontFamily: _currentTheme.fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // User/Outgoing messages (right) - from current user
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _currentTheme.userMessageColor,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning! 👋',
                          style: TextStyle(
                            fontSize: 14 * _currentTheme.textSize,
                            color: _currentTheme.userMessageTextColor,
                            fontFamily: _currentTheme.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '21:18',
                          style: TextStyle(
                            fontSize: 10 * _currentTheme.textSize,
                            color: _currentTheme.dateTextColor,
                            fontFamily: _currentTheme.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _currentTheme.userMessageColor,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'It\'s morning in Tokyo 😎',
                          style: TextStyle(
                            fontSize: 14 * _currentTheme.textSize,
                            color: _currentTheme.userMessageTextColor,
                            fontFamily: _currentTheme.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '21:22',
                          style: TextStyle(
                            fontSize: 10 * _currentTheme.textSize,
                            color: _currentTheme.dateTextColor,
                            fontFamily: _currentTheme.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorThemeSection(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COLOR THEME',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        // Theme preview cards - all 16 themes
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildThemeCard(ChatThemeType.defaultTheme, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.dayClassic, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.day, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.nightAccent, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.system, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.modernMinimal, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.vibrantSunset, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.oceanBreeze, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.forestGreen, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.purpleDream, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.warmCoffee, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.coolTech, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.pastelSoft, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.highContrast, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.midnightBlue, colors),
              const SizedBox(width: AppDimensions.spacingS),
              _buildThemeCard(ChatThemeType.goldenHour, colors),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(ChatThemeType themeType, ThemeColorSet colors) {
    final theme = themeType.toTheme();
    final isSelected = _selectedThemeType == themeType;
    final isDarkMode = context.isDarkMode;
    final backgroundColor = theme.getBackgroundColor(isDarkMode) ?? colors.cardBg;

    return GestureDetector(
      onTap: () => _selectThemeType(themeType),
      child: Container(
        width: 100,
        height: 80,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: Border.all(
            color: isSelected ? const Color(0xFFFBBC05) : colors.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Miniature chat preview
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Incoming message
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 40,
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.aiMessageColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Outgoing message
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 50,
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.userMessageColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSideControls(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LEFT MESSAGE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _buildTextColorRow(
          'Background Color',
          _currentTheme.aiMessageColor,
          (color) {
            setState(() {
              _currentTheme = _currentTheme.copyWith(aiMessageColor: color);
            });
            widget.onThemeChanged?.call(_currentTheme);
          },
          colors,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        _buildTextColorRow(
          'Text Color',
          _currentTheme.aiMessageTextColor,
          (color) {
            setState(() {
              _currentTheme = _currentTheme.copyWith(aiMessageTextColor: color);
            });
            widget.onThemeChanged?.call(_currentTheme);
          },
          colors,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          'AGENT',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _buildNameColorRow(colors),
        const SizedBox(height: AppDimensions.spacingS),
        _buildSettingRow(
          'Show Agent Name',
          _showAgentName,
          (value) {
            setState(() {
              _showAgentName = value;
              _currentTheme = _currentTheme.copyWith(showAgentName: value);
            });
            widget.onThemeChanged?.call(_currentTheme);
          },
          colors,
        ),
      ],
    );
  }

  Widget _buildRightSideControls(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RIGHT MESSAGE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _buildTextColorRow(
          'Background Color',
          _currentTheme.userMessageColor,
          (color) {
            setState(() {
              _currentTheme = _currentTheme.copyWith(userMessageColor: color);
            });
            widget.onThemeChanged?.call(_currentTheme);
          },
          colors,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        _buildTextColorRow(
          'Text Color',
          _currentTheme.userMessageTextColor,
          (color) {
            setState(() {
              _currentTheme = _currentTheme.copyWith(userMessageTextColor: color);
            });
            widget.onThemeChanged?.call(_currentTheme);
          },
          colors,
        ),
      ],
    );
  }

  Widget _buildSettingsList(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SETTINGS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _buildSettingRow(
          'Dark Mode',
          _darkMode,
          (value) {
            setState(() {
              _darkMode = value;
              // Background colors are now handled separately for light and dark modes
              // No need to update them here as they are selected independently
            });
            widget.onDarkModeChanged?.call(value);
            widget.onThemeChanged?.call(_currentTheme);
          },
          colors,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        _buildSettingRow(
          'Bubble Mode',
          _bubbleMode,
          (value) {
            setState(() {
              _bubbleMode = value;
              _currentTheme = _currentTheme.copyWith(bubbleMode: value);
            });
            widget.onBubbleModeChanged?.call(value);
            widget.onThemeChanged?.call(_currentTheme);
          },
          colors,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        _buildTextColorRow(
          'Date Text Color',
          _currentTheme.dateTextColor,
          (color) {
            setState(() {
              _currentTheme = _currentTheme.copyWith(dateTextColor: color);
            });
            widget.onThemeChanged?.call(_currentTheme);
          },
          colors,
        ),
      ],
    );
  }

  Widget _buildSettingRow(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
    ThemeColorSet colors,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textColor,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: const Color(0xFFFBBC05),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildNameColorRow(ThemeColorSet colors) {
    return InkWell(
      onTap: () => _showColorPicker(colors),
      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Agent Name Color',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textColor,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _nameColor,
                border: Border.all(color: colors.borderColor),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showColorPicker(
    ThemeColorSet colors, {
    Color? currentColor,
    ValueChanged<Color>? onColorSelected,
  }) {
    final colorToUse = currentColor ?? _nameColor;
    final onSelected = onColorSelected ?? (color) {
      setState(() {
        _nameColor = color;
        _currentTheme = _currentTheme.copyWith(nameColor: color);
      });
      widget.onNameColorChanged?.call(color);
      widget.onThemeChanged?.call(_currentTheme);
    };
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.cardBg,
        title: Text(
          colorToUse == _nameColor
              ? 'Select Name Color'
              : (colorToUse == (_currentTheme.backgroundColorLight ?? Colors.white)
                  ? 'Select Light Theme Background Color'
                  : (colorToUse == (_currentTheme.backgroundColorDark ?? const Color(0xFF1E1E1E))
                      ? 'Select Dark Theme Background Color'
                      : (colorToUse == _currentTheme.aiMessageColor
                          ? 'Select Left Message Background Color'
                          : (colorToUse == _currentTheme.aiMessageTextColor
                              ? 'Select Left Message Text Color'
                              : (colorToUse == _currentTheme.userMessageTextColor
                                  ? 'Select Right Message Text Color'
                                  : 'Select Date Text Color'))))),
          style: TextStyle(color: colors.textColor),
        ),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Visual color picker
                ColorPickerWidget(
                  initialColor: colorToUse,
                  onColorChanged: onSelected,
                ),
                const SizedBox(height: 24),
                // Divider
                Divider(color: colors.borderColor),
                const SizedBox(height: 16),
                // Preset colors section
                Text(
                  'Preset Colors',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                // All preset colors in a grid
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ...ChatAccentColors.accentColors.map((color) {
                      final isSelected = colorToUse == color;
                      return GestureDetector(
                        onTap: () {
                          onSelected(color);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(
                              color: isSelected ? const Color(0xFFFBBC05) : colors.borderColor,
                              width: isSelected ? 3 : 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 24)
                              : null,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              // Color is already applied via onColorChanged callback
              Navigator.of(context).pop();
            },
            child: Text(
              'Set',
              style: TextStyle(
                color: colorToUse,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFontFamilySection(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FONT FAMILY',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _buildFontPickerButton(colors),
      ],
    );
  }

  Widget _buildFontPickerButton(ThemeColorSet colors) {
    final currentFontStyle = _getFontTextStyleForButton(_selectedFont);
    
    return GestureDetector(
      onTap: () => _showFontPicker(colors),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: Border.all(color: colors.borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedFont,
              style: currentFontStyle?.copyWith(
                fontSize: 14,
                color: colors.textColor,
              ) ??
                  TextStyle(
                    fontSize: 14,
                    color: colors.textColor,
                  ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? _getFontTextStyleForButton(String fontName) {
    if (fontName == 'Inter') {
      return const TextStyle(fontFamily: 'Inter');
    }
    if (fontName == 'System Default') {
      return null;
    }

    try {
      switch (fontName) {
        case 'Roboto':
          return GoogleFonts.roboto();
        case 'Open Sans':
          return GoogleFonts.openSans();
        case 'Lato':
          return GoogleFonts.lato();
        case 'Montserrat':
          return GoogleFonts.montserrat();
        case 'Poppins':
          return GoogleFonts.poppins();
        case 'Nunito':
          return GoogleFonts.nunito();
        case 'Raleway':
          return GoogleFonts.raleway();
        case 'Source Sans 3':
          return GoogleFonts.sourceSans3();
        case 'Ubuntu':
          return GoogleFonts.ubuntu();
        case 'Noto Sans':
          return GoogleFonts.notoSans();
        case 'Work Sans':
          return GoogleFonts.workSans();
        case 'Playfair Display':
          return GoogleFonts.playfairDisplay();
        case 'Merriweather':
          return GoogleFonts.merriweather();
        case 'Oswald':
          return GoogleFonts.oswald();
        case 'Roboto Condensed':
          return GoogleFonts.robotoCondensed();
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  void _showFontPicker(ThemeColorSet colors) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: colors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Font Family',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              Flexible(
                child: SingleChildScrollView(
                  child: FontPickerWidget(
                    selectedFont: _selectedFont,
                    onFontSelected: (value) {
                      setState(() {
                        _selectedFont = value;
                        _currentTheme = _currentTheme.copyWith(
                          fontFamily: value == 'System Default' ? null : value,
                        );
                        _updateLocalStateFromTheme();
                      });
                      widget.onThemeChanged?.call(_currentTheme);
                      Navigator.of(dialogContext).pop();
                    },
                    colors: colors,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBackgroundColorSection(ThemeColorSet colors) {
    final isSystemBackground = _currentTheme.backgroundColorLight == null && 
                               _currentTheme.backgroundColorDark == null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHAT BACKGROUND',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _buildSettingRow(
          'Use System Background',
          isSystemBackground,
          (value) {
            setState(() {
              _currentTheme = _currentTheme.copyWith(
                clearBackgroundColor: value,
                backgroundColorLight: value ? null : Colors.white,
                backgroundColorDark: value ? null : const Color(0xFF1E1E1E),
              );
            });
            widget.onThemeChanged?.call(_currentTheme);
          },
          colors,
        ),
        if (!isSystemBackground) ...[
          const SizedBox(height: AppDimensions.spacingS),
          _buildTextColorRow(
            'Light Theme Background',
            _currentTheme.backgroundColorLight ?? Colors.white,
            (color) {
              setState(() {
                _currentTheme = _currentTheme.copyWith(backgroundColorLight: color);
              });
              widget.onThemeChanged?.call(_currentTheme);
            },
            colors,
          ),
          const SizedBox(height: AppDimensions.spacingS),
          _buildTextColorRow(
            'Dark Theme Background',
            _currentTheme.backgroundColorDark ?? const Color(0xFF1E1E1E),
            (color) {
              setState(() {
                _currentTheme = _currentTheme.copyWith(backgroundColorDark: color);
              });
              widget.onThemeChanged?.call(_currentTheme);
            },
            colors,
          ),
        ],
      ],
    );
  }

  Widget _buildTextSizeAndFontSection(ThemeColorSet colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text Size
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TEXT SIZE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Row(
                children: [
                  Text(
                    'A',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _textSize,
                      min: 0.8,
                      max: 1.5,
                      divisions: 7,
                      activeColor: const Color(0xFFFBBC05),
                      inactiveColor: colors.borderColor,
                      onChanged: (value) {
                        setState(() {
                          _textSize = value;
                          _currentTheme = _currentTheme.copyWith(textSize: value);
                          _updateLocalStateFromTheme();
                        });
                        widget.onTextSizeChanged?.call(value);
                        widget.onThemeChanged?.call(_currentTheme);
                      },
                    ),
                  ),
                  Text(
                    'A',
                    style: TextStyle(
                      fontSize: 18,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.spacingXl),
        // Font Family
        Expanded(
          child: _buildFontFamilySection(colors),
        ),
      ],
    );
  }


  Widget _buildTextColorRow(
    String label,
    Color currentColor,
    ValueChanged<Color> onColorChanged,
    ThemeColorSet colors,
  ) {
    return InkWell(
      onTap: () => _showColorPicker(colors, currentColor: currentColor, onColorSelected: onColorChanged),
      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textColor,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentColor,
                border: Border.all(color: colors.borderColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

