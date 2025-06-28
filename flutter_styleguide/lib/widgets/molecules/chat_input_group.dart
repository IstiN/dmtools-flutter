import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/widgets/atoms/buttons/app_buttons.dart';

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(),
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
