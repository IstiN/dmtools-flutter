import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    bool isDarkMode;
    ThemeColorSet colors;

    if (widget.isTestMode == true) {
      isDarkMode = widget.testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

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
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show/hide button
            IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                size: 16,
                color: colors.textMuted,
              ),
              onPressed: widget.isDisabled
                  ? null
                  : () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
              tooltip: _obscureText ? 'Show value' : 'Hide value',
              splashRadius: 20,
            ),
            // Copy button (optional)
            if (widget.showCopyButton && widget.controller?.text.isNotEmpty == true)
              IconButton(
                icon: Icon(
                  Icons.copy,
                  size: 16,
                  color: colors.textMuted,
                ),
                onPressed: widget.isDisabled
                    ? null
                    : () {
                        // TODO: Implement clipboard copy
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Value copied to clipboard'),
                            backgroundColor: colors.successColor,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                tooltip: 'Copy to clipboard',
                splashRadius: 20,
              ),
          ],
        ),
      ),
    );
  }
}
