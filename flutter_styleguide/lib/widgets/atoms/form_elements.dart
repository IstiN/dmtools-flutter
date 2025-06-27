import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;

    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;

    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: !isDisabled,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(color: colors.textMuted),
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
    Key? key,
  }) : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
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
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      enabled: !widget.isDisabled,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(color: colors.textMuted),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;

    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: !isDisabled,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(color: colors.textMuted),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;

    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: !isDisabled,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(color: colors.textMuted),
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
    Key? key,
    this.value,
    this.onChanged,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;

    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

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
    Key? key,
    this.onChanged,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;

    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: isDisabled ? null : onChanged,
          activeColor: colors.accentColor,
        ),
        Text(
          label,
          style: TextStyle(
            color: colors.textColor,
            fontSize: 14,
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
    Key? key,
    this.onChanged,
    this.isDisabled = false,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;

    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: isDisabled ? null : onChanged,
          activeColor: colors.accentColor,
        ),
        Text(
          label,
          style: TextStyle(
            color: colors.textColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

/// View All Link component
class ViewAllLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool? isTestMode;
  final bool? testDarkMode;

  const ViewAllLink({
    required this.text,
    Key? key,
    this.onTap,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;

    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: colors.accentColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            size: 16,
            color: colors.accentColor,
          ),
        ],
      ),
    );
  }
}

class FormElementsWidget extends StatelessWidget {
  final bool? isTestMode;
  final bool? testDarkMode;

  const FormElementsWidget({
    Key? key,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Basic text input
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Text Input',
            hintText: 'Enter text here',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Password input
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: const Icon(Icons.visibility_off),
          ),
        ),
        const SizedBox(height: 16),

        // Dropdown
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Select Option',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'option1', child: Text('Option 1')),
            DropdownMenuItem(value: 'option2', child: Text('Option 2')),
            DropdownMenuItem(value: 'option3', child: Text('Option 3')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }
}
