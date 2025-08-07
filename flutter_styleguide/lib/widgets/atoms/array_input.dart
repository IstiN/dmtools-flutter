import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

/// Array Input component for handling array-type parameters in forms
/// Provides add, edit, and remove functionality for string array values
class ArrayInput extends StatefulWidget {
  /// Current array of string values
  final List<String> values;

  /// Callback when array values change
  final ValueChanged<List<String>>? onChanged;

  /// Placeholder text for new item input
  final String? placeholder;

  /// Label for the array field
  final String? label;

  /// Maximum number of items allowed
  final int? maxItems;

  /// Minimum number of items required
  final int minItems;

  /// Whether the field is required
  final bool required;

  /// Custom validation function
  final String? Function(List<String>?)? validator;

  /// Test mode for styling
  final bool isTestMode;

  /// Dark mode for testing
  final bool testDarkMode;

  const ArrayInput({
    required this.values,
    this.onChanged,
    this.placeholder = 'Add new item',
    this.label,
    this.maxItems,
    this.minItems = 0,
    this.required = false,
    this.validator,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  State<ArrayInput> createState() => _ArrayInputState();
}

class _ArrayInputState extends State<ArrayInput> {
  bool _isAdding = false;
  int? _editingIndex;
  final TextEditingController _inputController = TextEditingController();
  String? _validationError;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  ThemeColorSet _getColors(BuildContext context) {
    if (widget.isTestMode) {
      return widget.testDarkMode ? AppColors.dark : AppColors.light;
    }
    return context.colorsListening;
  }

  void _validateArray() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.values);
      setState(() {
        _validationError = error;
      });
    } else {
      // Default validation
      if (widget.required && widget.values.isEmpty) {
        setState(() {
          _validationError = 'At least one item is required';
        });
      } else if (widget.values.length < widget.minItems) {
        setState(() {
          _validationError = 'Minimum ${widget.minItems} items required';
        });
      } else if (widget.maxItems != null && widget.values.length > widget.maxItems!) {
        setState(() {
          _validationError = 'Maximum ${widget.maxItems} items allowed';
        });
      } else {
        setState(() {
          _validationError = null;
        });
      }
    }
  }

  void _addItem() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty && !widget.values.contains(text)) {
      final newValues = [...widget.values, text];
      widget.onChanged?.call(newValues);
      _inputController.clear();
      setState(() {
        _isAdding = false;
      });
      _validateArray();
    }
  }

  void _editItem(int index) {
    final text = _inputController.text.trim();
    if (text.isNotEmpty && !widget.values.contains(text)) {
      final newValues = [...widget.values];
      newValues[index] = text;
      widget.onChanged?.call(newValues);
      _inputController.clear();
      setState(() {
        _editingIndex = null;
      });
      _validateArray();
    }
  }

  void _removeItem(int index) {
    final newValues = [...widget.values];
    newValues.removeAt(index);
    widget.onChanged?.call(newValues);
    _validateArray();
  }

  void _startAdding() {
    setState(() {
      _isAdding = true;
      _editingIndex = null;
      _inputController.clear();
    });
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _isAdding = false;
      _inputController.text = widget.values[index];
    });
  }

  void _cancelEditing() {
    setState(() {
      _isAdding = false;
      _editingIndex = null;
      _inputController.clear();
    });
  }

  bool get _canAddMore {
    return widget.maxItems == null || widget.values.length < widget.maxItems!;
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          Text.rich(
            TextSpan(
              text: widget.label!,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textColor),
              children: widget.required
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: colors.warningColor),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
        ],

        // Array container
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingS),
          decoration: BoxDecoration(
            color: colors.inputBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            border: Border.all(
              color: _validationError != null ? colors.dangerColor : colors.borderColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Existing items
              if (widget.values.isEmpty && !_isAdding) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
                  child: Text(
                    'No items added yet',
                    style: TextStyle(color: colors.textMuted, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ] else ...[
                ...widget.values.asMap().entries.map((entry) {
                  final index = entry.key;
                  final value = entry.value;
                  final isEditing = _editingIndex == index;

                  if (isEditing) {
                    return _buildEditInput(colors);
                  }

                  return _buildArrayItem(index, value, colors);
                }),
              ],

              // Add input
              if (_isAdding) _buildAddInput(colors),

              // Add button
              if (!_isAdding && _editingIndex == null && _canAddMore) ...[
                if (widget.values.isNotEmpty) const SizedBox(height: AppDimensions.spacingS),
                _buildAddButton(colors),
              ],
            ],
          ),
        ),

        // Validation error
        if (_validationError != null) ...[
          const SizedBox(height: AppDimensions.spacingXxs),
          Text(_validationError!, style: TextStyle(color: colors.dangerColor, fontSize: 12)),
        ],
      ],
    );
  }

  Widget _buildArrayItem(int index, String value, ThemeColorSet colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      padding: const EdgeInsets.all(AppDimensions.spacingS),
      decoration: BoxDecoration(
        color: colors.bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(value, style: TextStyle(color: colors.textColor, fontSize: 14)),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          _buildItemButton(icon: Icons.edit, onPressed: () => _startEditing(index), colors: colors),
          const SizedBox(width: AppDimensions.spacingXxs),
          _buildItemButton(icon: Icons.delete, onPressed: () => _removeItem(index), colors: colors, isDelete: true),
        ],
      ),
    );
  }

  Widget _buildItemButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ThemeColorSet colors,
    bool isDelete = false,
  }) {
    return SizedBox(
      width: 28,
      height: 28,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: AppDimensions.iconSizeXs, color: isDelete ? colors.dangerColor : colors.textSecondary),
        style: IconButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.zero),
      ),
    );
  }

  Widget _buildAddInput(ThemeColorSet colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              autofocus: true,
              style: TextStyle(color: colors.textColor),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: TextStyle(color: colors.textMuted),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingS,
                  vertical: AppDimensions.spacingXs,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  borderSide: BorderSide(color: colors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
                ),
                filled: true,
                fillColor: colors.bgColor,
              ),
              onSubmitted: (_) => _addItem(),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          _buildActionButton(icon: Icons.check, onPressed: _addItem, colors: colors),
          const SizedBox(width: AppDimensions.spacingXxs),
          _buildActionButton(icon: Icons.close, onPressed: _cancelEditing, colors: colors, isCancel: true),
        ],
      ),
    );
  }

  Widget _buildEditInput(ThemeColorSet colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              autofocus: true,
              style: TextStyle(color: colors.textColor),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: TextStyle(color: colors.textMuted),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingS,
                  vertical: AppDimensions.spacingXs,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  borderSide: BorderSide(color: colors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
                ),
                filled: true,
                fillColor: colors.bgColor,
              ),
              onSubmitted: (_) => _editItem(_editingIndex!),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          _buildActionButton(icon: Icons.check, onPressed: () => _editItem(_editingIndex!), colors: colors),
          const SizedBox(width: AppDimensions.spacingXxs),
          _buildActionButton(icon: Icons.close, onPressed: _cancelEditing, colors: colors, isCancel: true),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ThemeColorSet colors,
    bool isCancel = false,
  }) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: AppDimensions.iconSizeS, color: isCancel ? colors.textSecondary : colors.accentColor),
        style: IconButton.styleFrom(
          backgroundColor: isCancel
              ? colors.borderColor.withValues(alpha: 0.1)
              : colors.accentColor.withValues(alpha: 0.1),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildAddButton(ThemeColorSet colors) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _startAdding,
        icon: Icon(Icons.add, size: AppDimensions.iconSizeS, color: colors.accentColor),
        label: Text('Add Item', style: TextStyle(color: colors.accentColor, fontSize: 14)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM, vertical: AppDimensions.spacingS),
          side: BorderSide(color: colors.accentColor.withValues(alpha: 0.3)),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXs)),
        ),
      ),
    );
  }
}
