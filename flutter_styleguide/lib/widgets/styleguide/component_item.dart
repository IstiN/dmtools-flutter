import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/texts/app_text.dart';

class ComponentItem extends StatelessWidget {
  final String title;
  final Widget child;
  final String? codeSnippet;

  const ComponentItem({
    Key? key,
    required this.title,
    required this.child,
    this.codeSnippet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumTitleText(title),
        SizedBox(height: AppDimensions.spacingS),
        child,
        if (codeSnippet != null) ...[
          SizedBox(height: AppDimensions.spacingS),
          CodeText(codeSnippet!),
        ],
      ],
    );
  }
} 