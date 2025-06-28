import 'package:flutter/material.dart';
// import 'package:dmtools_styleguide/widgets/atoms/buttons/app_buttons.dart'; // Unused

class ActionButtonGroup extends StatelessWidget {
  final List<Widget> buttons;

  const ActionButtonGroup({required this.buttons, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: buttons,
    );
  }
} 