import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_colors.dart';

/// Widget for selecting font family with visual preview tiles
class FontPickerWidget extends StatelessWidget {
  final String selectedFont;
  final ValueChanged<String> onFontSelected;
  final ThemeColorSet colors;

  const FontPickerWidget({
    required this.selectedFont,
    required this.onFontSelected,
    required this.colors,
    super.key,
  });

  static const List<String> availableFonts = [
    'Inter',
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Poppins',
    'Nunito',
    'Raleway',
    'Source Sans 3',
    'Ubuntu',
    'Noto Sans',
    'Work Sans',
    'Playfair Display',
    'Merriweather',
    'Oswald',
    'Roboto Condensed',
    'System Default',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spacingM,
      runSpacing: AppDimensions.spacingM,
      children: availableFonts.map((font) {
        return _buildFontTile(font);
      }).toList(),
    );
  }

  Widget _buildFontTile(String fontName) {
    final isSelected = selectedFont == fontName;
    final textStyle = _getFontTextStyle(fontName);

    return GestureDetector(
      onTap: () => onFontSelected(fontName),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentColor.withValues(alpha: 0.1) : colors.cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: Border.all(
            color: isSelected ? colors.accentColor : colors.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Font name
            Text(
              fontName,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? colors.accentColor : colors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            // Preview text "Hello" with applied font
            Text(
              'Hello',
              style: textStyle?.copyWith(
                fontSize: 14, // Chat message size
                color: colors.textColor,
              ) ??
                  TextStyle(
                    fontSize: 14,
                    color: colors.textColor,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? _getFontTextStyle(String fontName) {
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
}

