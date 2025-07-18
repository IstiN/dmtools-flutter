import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

/// Input field specifically designed for sensitive configuration parameters
/// like API keys, tokens, and passwords
class SensitiveFieldInput extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isDisabled;
  final bool showCopyButton;
  final bool? isTestMode;
  final bool? testDarkMode;

  const SensitiveFieldInput({
    this.placeholder,
    this.controller,
    this.onChanged,
    this.isDisabled = false,
    this.showCopyButton = true,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  State<SensitiveFieldInput> createState() => _SensitiveFieldInputState();
}

class _SensitiveFieldInputState extends State<SensitiveFieldInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      enabled: !widget.isDisabled,
      obscureText: _obscureText,
      style: TextStyle(
        fontFamily: 'monospace',
        color: colors.textColor,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: widget.placeholder ?? 'Enter sensitive value...',
        hintStyle: TextStyle(
          color: colors.textMuted,
          fontFamily: 'monospace',
          fontSize: 14,
        ),
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        // Security icon as prefix
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Icon(
            Icons.security,
            size: 16,
            color: colors.textMuted,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 16,
        ),
        // Suffix with visibility toggle and copy button
        suffixIcon: _buildSuffixActions(colors),
      ),
    );
  }

  Widget _buildSuffixActions(ThemeColorSet colors) {
    final actions = <Widget>[];

    // Visibility toggle
    actions.add(
      IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 18,
          color: colors.textMuted,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        tooltip: _obscureText ? 'Show value' : 'Hide value',
        constraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
        padding: const EdgeInsets.all(8),
      ),
    );

    // Copy button (if enabled and has controller)
    if (widget.showCopyButton && widget.controller != null) {
      actions.add(
        IconButton(
          icon: Icon(
            Icons.copy_outlined,
            size: 18,
            color: colors.textMuted,
          ),
          onPressed: () => _copyToClipboard(colors),
          tooltip: 'Copy to clipboard',
          constraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          padding: const EdgeInsets.all(8),
        ),
      );
    }

    if (actions.length == 1) {
      return actions.first;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions,
    );
  }

  void _copyToClipboard(ThemeColorSet colors) {
    if (widget.controller?.text.isNotEmpty == true) {
      Clipboard.setData(ClipboardData(text: widget.controller!.text));

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Copied to clipboard',
            style: TextStyle(color: colors.textColor),
          ),
          backgroundColor: colors.cardBg,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
