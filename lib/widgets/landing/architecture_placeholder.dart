import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'package:dmtools_styleguide/widgets/molecules/custom_card.dart';

/// Architecture diagram placeholder styled as a PowerPoint slide
/// Uses styleguide components for consistent theming
class ArchitecturePlaceholder extends StatelessWidget {
  const ArchitecturePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return CustomCard(
      padding: const EdgeInsets.all(32),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.cardBg,
                colors.cardBg.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colors.borderColor.withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.architecture,
                  size: 64,
                  color: colors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Architecture Diagram',
                  style: textTheme.headlineMedium?.copyWith(
                    color: colors.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coming soon',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

