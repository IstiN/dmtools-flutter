import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class IntegrationsPage extends StatelessWidget {
  const IntegrationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.extension_outlined, size: 64, color: colors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'Integrations Management',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor),
          ),
          const SizedBox(height: 8),
          Text(
            'This section would show all integrations and their management interface.',
            style: TextStyle(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
