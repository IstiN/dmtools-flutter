import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/texts/app_text.dart';

class ColorSwatchItem extends StatelessWidget {
  final Color color;
  final String name;
  final String hexCode;
  final Color? textColor;

  const ColorSwatchItem({
    Key? key,
    required this.color,
    required this.name,
    required this.hexCode,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contrastColor = textColor ?? _getContrastColor(color);
    
    return Container(
      width: 180,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: hexCode));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: MediumBodyText('$hexCode copied to clipboard', color: Colors.white),
                duration: AppDimensions.animationDurationMedium,
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Padding(
            padding: AppDimensions.cardPaddingM,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmallTitleText(
                  name,
                  color: contrastColor,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.spacingXxs),
                Text(
                  'RGB(${(color.r * 255.0).round()}, ${(color.g * 255.0).round()}, ${(color.b * 255.0).round()})',
                  style: TextStyle(
                    fontSize: 10,
                    color: contrastColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getContrastColor(Color backgroundColor) {
    // Calculate relative luminance
    double luminance = 0.299 * (backgroundColor.r * 255.0).round() + 
                       0.587 * (backgroundColor.g * 255.0).round() + 
                       0.114 * (backgroundColor.b * 255.0).round();
    
    // Use white text on dark backgrounds and black text on light backgrounds
    return luminance > 128 ? Colors.black : Colors.white;
  }
} 