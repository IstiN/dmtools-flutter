import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Form Group wrapper that provides consistent styling for form elements
class FormGroup extends StatelessWidget {
  final Widget child;
  final String label;
  final String? helperText;
  final bool? isTestMode;
  final bool? testDarkMode;

  const FormGroup({
    required this.child,
    required this.label,
    this.helperText,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.textColor,
          ),
        ),
        const SizedBox(height: 6),
        child,
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText!,
            style: TextStyle(
              fontSize: 12,
              color: colors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}

/// Text Input component
class TextInput extends StatelessWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isDisabled;
  final bool? isTestMode;
  final bool? testDarkMode;

  const TextInput({
    this.placeholder,
    this.controller,
    this.onChanged,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: !isDisabled,
      style: TextStyle(color: colors.textColor),
      decoration: InputDecoration(
        hintText: placeholder,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

/// Password Input component
class PasswordInput extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isDisabled;
  final bool? isTestMode;
  final bool? testDarkMode;

  const PasswordInput({
    this.placeholder,
    this.controller,
    this.onChanged,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      enabled: !widget.isDisabled,
      obscureText: _obscureText,
      style: TextStyle(color: colors.textColor),
      decoration: InputDecoration(
        hintText: widget.placeholder,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: colors.textMuted,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

/// Number Input component
class NumberInput extends StatelessWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isDisabled;
  final bool? isTestMode;
  final bool? testDarkMode;

  const NumberInput({
    this.placeholder,
    this.controller,
    this.onChanged,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: !isDisabled,
      keyboardType: TextInputType.number,
      style: TextStyle(color: colors.textColor),
      decoration: InputDecoration(
        hintText: placeholder,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

/// Textarea component
class TextArea extends StatelessWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isDisabled;
  final int minLines;
  final int maxLines;
  final bool? isTestMode;
  final bool? testDarkMode;

  const TextArea({
    this.placeholder,
    this.controller,
    this.onChanged,
    this.isDisabled = false,
    this.minLines = 3,
    this.maxLines = 5,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: !isDisabled,
      minLines: minLines,
      maxLines: maxLines,
      style: TextStyle(color: colors.textColor),
      decoration: InputDecoration(
        hintText: placeholder,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

/// Select Dropdown component
class SelectDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool isDisabled;
  final bool? isTestMode;
  final bool? testDarkMode;

  const SelectDropdown({
    required this.items,
    super.key,
    this.value,
    this.onChanged,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.inputBg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colors.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          onChanged: isDisabled ? null : onChanged,
          items: items,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: colors.textMuted),
          style: TextStyle(
            color: colors.textColor,
            fontSize: 14,
          ),
          dropdownColor: colors.cardBg,
        ),
      ),
    );
  }
}

/// Checkbox component
class CheckboxInput extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String label;
  final bool isDisabled;
  final bool? isTestMode;
  final bool? testDarkMode;

  const CheckboxInput({
    required this.value,
    required this.label,
    super.key,
    this.onChanged,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: isDisabled ? null : (val) => onChanged?.call(val ?? false),
          activeColor: colors.accentColor,
          checkColor: colors.whiteColor,
          side: BorderSide(color: colors.borderColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDisabled ? colors.textMuted : colors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// Radio Button component
class RadioInput<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?>? onChanged;
  final String label;
  final bool isDisabled;
  final bool? isTestMode;
  final bool? testDarkMode;

  const RadioInput({
    required this.value,
    required this.groupValue,
    required this.label,
    super.key,
    this.onChanged,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: isDisabled ? null : onChanged,
          activeColor: colors.accentColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDisabled ? colors.textMuted : colors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// View All Link component
class ViewAllLink extends StatelessWidget {
  final VoidCallback onPressed;
  final bool? isTestMode;
  final bool? testDarkMode;

  const ViewAllLink({
    required this.onPressed,
    super.key,
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'View All',
            style: TextStyle(
              color: colors.accentColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.arrow_forward,
            size: 16,
            color: colors.accentColor,
          ),
        ],
      ),
    );
  }
}

/// Demo widget for form elements showcase
class FormElementsWidget extends StatelessWidget {
  final bool? isTestMode;
  final bool? testDarkMode;

  const FormElementsWidget({
    super.key,
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Column(
      children: [
        // Basic text input
        TextFormField(
          style: TextStyle(color: colors.textColor),
          decoration: InputDecoration(
            labelText: 'Text Input',
            labelStyle: TextStyle(color: colors.textSecondary),
            hintText: 'Enter text here',
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.inputBg,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Password input
        TextFormField(
          obscureText: true,
          style: TextStyle(color: colors.textColor),
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: colors.textSecondary),
            hintText: 'Enter password',
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.inputBg,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
            ),
            suffixIcon: Icon(Icons.visibility_off, color: colors.textMuted),
          ),
        ),
        const SizedBox(height: 16),

        // Dropdown
        DropdownButtonFormField<String>(
          style: TextStyle(color: colors.textColor),
          dropdownColor: colors.cardBg,
          decoration: InputDecoration(
            labelText: 'Select Option',
            labelStyle: TextStyle(color: colors.textSecondary),
            filled: true,
            fillColor: colors.inputBg,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
            ),
          ),
          items: [
            DropdownMenuItem(
              value: 'option1',
              child: Text('Option 1', style: TextStyle(color: colors.textColor)),
            ),
            DropdownMenuItem(
              value: 'option2',
              child: Text('Option 2', style: TextStyle(color: colors.textColor)),
            ),
            DropdownMenuItem(
              value: 'option3',
              child: Text('Option 3', style: TextStyle(color: colors.textColor)),
            ),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }
}
