import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/widgets/atoms/buttons/app_buttons.dart';
import '../../theme/app_theme.dart';

class ChatInputGroup extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onClear;
  final bool isLoading;

  const ChatInputGroup({
    required this.controller,
    required this.onSend,
    required this.onClear,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: colors.textColor),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: colors.textMuted),
                filled: true,
                fillColor: colors.inputBg,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: colors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: colors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
                ),
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            text: 'Send',
            onPressed: onSend,
            icon: Icons.send,
            isLoading: isLoading,
          ),
          const SizedBox(width: 8),
          OutlineButton(
            text: 'Clear',
            onPressed: onClear,
            icon: Icons.clear,
          ),
        ],
      ),
    );
  }
}
