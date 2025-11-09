import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

class FontsPage extends StatelessWidget {
  const FontsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final ThemeColorSet colors = isDarkMode ? AppColors.dark : AppColors.light;

    final fontFamilies = [
      {'name': 'Inter', 'style': null},
      {'name': 'Roboto', 'style': GoogleFonts.roboto()},
      {'name': 'Open Sans', 'style': GoogleFonts.openSans()},
      {'name': 'Lato', 'style': GoogleFonts.lato()},
      {'name': 'Montserrat', 'style': GoogleFonts.montserrat()},
      {'name': 'Poppins', 'style': GoogleFonts.poppins()},
      {'name': 'Nunito', 'style': GoogleFonts.nunito()},
      {'name': 'Raleway', 'style': GoogleFonts.raleway()},
      {'name': 'Source Sans 3', 'style': GoogleFonts.sourceSans3()},
      {'name': 'Ubuntu', 'style': GoogleFonts.ubuntu()},
      {'name': 'Noto Sans', 'style': GoogleFonts.notoSans()},
      {'name': 'Work Sans', 'style': GoogleFonts.workSans()},
      {'name': 'Playfair Display', 'style': GoogleFonts.playfairDisplay()},
      {'name': 'Merriweather', 'style': GoogleFonts.merriweather()},
      {'name': 'Oswald', 'style': GoogleFonts.oswald()},
      {'name': 'Roboto Condensed', 'style': GoogleFonts.robotoCondensed()},
      {'name': 'System Default', 'style': null},
    ];

    TextStyle? _getFontStyle(String fontName, TextStyle? fontStyle) {
      if (fontName == 'Inter') {
        return TextStyle(fontFamily: 'Inter');
      }
      return fontStyle;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppDimensions.cardPaddingL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Font Families Comparison',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),
                Text(
                  'Compare available font families for chat customization',
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXl),
                Card(
                  color: colors.cardBg,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    side: BorderSide(color: colors.borderColor),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      border: TableBorder(
                        horizontalInside: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
                        verticalInside: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
                        top: BorderSide(color: colors.borderColor),
                        bottom: BorderSide(color: colors.borderColor),
                        left: BorderSide(color: colors.borderColor),
                        right: BorderSide(color: colors.borderColor),
                      ),
                      columnWidths: const {
                        0: FixedColumnWidth(150),
                        1: FixedColumnWidth(300),
                        2: FixedColumnWidth(200),
                        3: FixedColumnWidth(200),
                        4: FixedColumnWidth(200),
                      },
                      children: [
                        // Header row
                        TableRow(
                          decoration: BoxDecoration(color: colors.hoverBg),
                          children: [
                            _buildTableCell('Font Name', colors, isHeader: true),
                            _buildTableCell('Sample Text', colors, isHeader: true),
                            _buildTableCell('Uppercase', colors, isHeader: true),
                            _buildTableCell('Lowercase', colors, isHeader: true),
                            _buildTableCell('Numbers & Symbols', colors, isHeader: true),
                          ],
                        ),
                        // Data rows
                        ...fontFamilies.map((font) {
                          final fontName = font['name'] as String;
                          final fontStyle = font['style'] as TextStyle?;
                          final textStyle = _getFontStyle(fontName, fontStyle);

                          return TableRow(
                            children: [
                              _buildTableCell(
                                fontName,
                                colors,
                                textStyle: textStyle?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              _buildTableCell(
                                'The quick brown fox jumps over the lazy dog',
                                colors,
                                textStyle: textStyle?.copyWith(fontSize: 14),
                              ),
                              _buildTableCell(
                                'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                                colors,
                                textStyle: textStyle?.copyWith(fontSize: 14),
                              ),
                              _buildTableCell(
                                'abcdefghijklmnopqrstuvwxyz',
                                colors,
                                textStyle: textStyle?.copyWith(fontSize: 14),
                              ),
                              _buildTableCell(
                                '0123456789 !@#\$%^&*()',
                                colors,
                                textStyle: textStyle?.copyWith(fontSize: 14),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, ThemeColorSet colors, {bool isHeader = false, TextStyle? textStyle}) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Text(
        text,
        style: textStyle ??
            TextStyle(
              fontSize: isHeader ? 12 : 14,
              fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
              color: isHeader ? colors.textSecondary : colors.textColor,
            ),
      ),
    );
  }
}

