import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

import '../atoms/sensitive_field_input.dart';
import '../atoms/buttons/app_buttons.dart';
import '../atoms/array_input.dart';

/// Configuration parameter model for dynamic form generation
class ConfigParameter {
  final String key;
  final String displayName;
  final String description;
  final bool required;
  final bool sensitive;
  final String type; // 'string', 'boolean', 'number', 'select', 'textarea', 'array'
  final dynamic defaultValue;
  final List<String> options; // For select type
  final String? placeholder;
  final String? validationPattern;

  const ConfigParameter({
    required this.key,
    required this.displayName,
    required this.description,
    required this.required,
    this.sensitive = false,
    this.type = 'string',
    this.defaultValue,
    this.options = const [],
    this.placeholder,
    this.validationPattern,
  });

  factory ConfigParameter.fromJson(Map<String, dynamic> json) {
    return ConfigParameter(
      key: json['key'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      required: json['required'] as bool? ?? false,
      sensitive: json['sensitive'] as bool? ?? false,
      type: json['type'] as String? ?? 'string',
      defaultValue: json['defaultValue'],
      options: (json['options'] as List<dynamic>?)?.cast<String>() ?? [],
      placeholder: json['placeholder'] as String?,
      validationPattern: json['validationPattern'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'displayName': displayName,
      'description': description,
      'required': required,
      'sensitive': sensitive,
      'type': type,
      'defaultValue': defaultValue,
      'options': options,
      'placeholder': placeholder,
      'validationPattern': validationPattern,
    };
  }
}

/// Available integration category model for selection
class AvailableIntegration {
  final String id;
  final String name;
  final String type;
  final String displayName;
  final bool enabled;
  final String? description;

  const AvailableIntegration({
    required this.id,
    required this.name,
    required this.type,
    required this.displayName,
    required this.enabled,
    this.description,
  });
}

/// Generic configuration form that works with JSON-based configuration
class DynamicConfigForm extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<ConfigParameter> parameters;
  final Map<String, dynamic> initialValues;
  final String? initialName;
  final List<String> requiredIntegrationTypes;
  final List<String> optionalIntegrationTypes;
  final List<AvailableIntegration> availableIntegrations;
  final List<String> selectedIntegrations;
  final ValueChanged<Map<String, dynamic>> onConfigChanged;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<List<String>>? onIntegrationsChanged;
  final VoidCallback? onTestConfiguration;
  final VoidCallback? onCreateIntegration;
  final bool isLoading;
  final String? testResult;
  final bool? isTestMode;
  final bool? testDarkMode;

  const DynamicConfigForm({
    required this.title,
    required this.parameters,
    required this.initialValues,
    required this.requiredIntegrationTypes,
    required this.availableIntegrations,
    required this.selectedIntegrations,
    required this.onConfigChanged,
    this.subtitle,
    this.initialName,
    this.optionalIntegrationTypes = const [],
    this.onNameChanged,
    this.onIntegrationsChanged,
    this.onTestConfiguration,
    this.onCreateIntegration,
    this.isLoading = false,
    this.testResult,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  State<DynamicConfigForm> createState() => _DynamicConfigFormState();
}

class _DynamicConfigFormState extends State<DynamicConfigForm> {
  late Map<String, TextEditingController> _controllers;
  late TextEditingController _nameController;
  late Map<String, dynamic> _currentValues;
  late List<String> _currentIntegrations;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  /// Helper method to safely convert API boolean values that might come as strings
  bool _safeBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) {
      return defaultValue;
    }
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return defaultValue;
  }

  /// Helper method to safely convert dynamic lists to List of String
  List<String> _safeStringList(dynamic value) {
    if (value == null) {
      return <String>[];
    }
    if (value is List<String>) {
      return value;
    }
    if (value is List) {
      return value.map((item) => item?.toString() ?? '').toList();
    }
    return <String>[];
  }

  void _initializeControllers() {
    debugPrint('🔧 DynamicConfigForm: Initializing controllers');
    debugPrint('🔧   - Initial values: ${widget.initialValues}');
    debugPrint('🔧   - Parameters count: ${widget.parameters.length}');

    _controllers = {};
    _currentValues = Map.from(widget.initialValues);
    _currentIntegrations = List.from(widget.selectedIntegrations);

    // Convert string boolean values to actual booleans in initial values
    for (final param in widget.parameters) {
      if (param.type == 'boolean' && _currentValues.containsKey(param.key)) {
        _currentValues[param.key] = _safeBool(_currentValues[param.key]);
      }
    }

    // Initialize name controller
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _nameController.addListener(() {
      widget.onNameChanged?.call(_nameController.text);
    });

    // Initialize parameter controllers
    for (final param in widget.parameters) {
      debugPrint('🔧   - Processing parameter: ${param.key}');
      debugPrint('🔧     - Type: ${param.type}');
      debugPrint('🔧     - Required: ${param.required}');
      debugPrint('🔧     - Default value: ${param.defaultValue}');
      debugPrint('🔧     - Initial value: ${widget.initialValues[param.key]}');

      if (param.type != 'boolean' && param.type != 'array') {
        var initialValue = widget.initialValues[param.key] ?? param.defaultValue;

        // For required fields without default values, provide sensible defaults
        if (initialValue == null && param.required) {
          switch (param.type) {
            case 'email':
              initialValue = 'user@example.com';
              debugPrint('🔧     - Applied email default for required field');
              break;
            case 'select':
              if (param.options.isNotEmpty) {
                initialValue = param.options.first;
                debugPrint('🔧     - Applied first option default for required select field');
              }
              break;
            case 'number':
              initialValue = '0';
              debugPrint('🔧     - Applied number default for required field');
              break;
            default:
              initialValue = 'Please enter ${param.displayName.toLowerCase()}';
              debugPrint('🔧     - Applied text placeholder default for required field');
              break;
          }
        }

        final textValue = initialValue?.toString() ?? '';

        debugPrint('🔧     - Final text value: "$textValue"');

        _controllers[param.key] = TextEditingController(text: textValue);

        // Set the value in _currentValues immediately
        if (textValue.isNotEmpty) {
          _currentValues[param.key] = textValue;
          debugPrint('🔧     - Set current value: ${_currentValues[param.key]}');
        } else if (param.required) {
          // For required fields without values, set a proper default
          String defaultValue = '';
          switch (param.key.toLowerCase()) {
            case 'inputjql':
              defaultValue = 'project = DMC';
              break;
            case 'initiator':
              defaultValue = 'system';
              break;
            default:
              defaultValue = param.defaultValue?.toString() ?? '';
          }

          if (defaultValue.isNotEmpty) {
            _currentValues[param.key] = defaultValue;
            _controllers[param.key]!.text = defaultValue;
            debugPrint('🔧     - Set required field default: ${_currentValues[param.key]}');
          } else {
            debugPrint('🔧     - ⚠️ Required field "${param.key}" has empty value!');
          }
        }

        _controllers[param.key]!.addListener(() {
          _updateValue(param.key, _controllers[param.key]!.text, param.type);
        });
      } else if (param.type == 'array') {
        // For array types, always ensure safe conversion
        List<String> initialArray = [];

        // Check initial values first
        if (widget.initialValues[param.key] != null) {
          initialArray = _safeStringList(widget.initialValues[param.key]);
          debugPrint('🔧     - Converted array from initialValues: ${_currentValues[param.key]} -> $initialArray');
        }
        // Check if there's already a value in _currentValues that needs conversion
        else if (_currentValues.containsKey(param.key)) {
          initialArray = _safeStringList(_currentValues[param.key]);
          debugPrint('🔧     - Converted existing array value: ${_currentValues[param.key]} -> $initialArray');
        }
        // Use default value if available
        else if (param.defaultValue != null) {
          initialArray = _safeStringList(param.defaultValue);
          debugPrint('🔧     - Converted array from defaultValue: $initialArray');
        }

        // Always set the converted value
        _currentValues[param.key] = initialArray;
        debugPrint('🔧     - Set array value: ${_currentValues[param.key]}');
      } else {
        // For boolean types, we don't need controllers but still need initial values
        if (!_currentValues.containsKey(param.key)) {
          _currentValues[param.key] = param.defaultValue ?? false;
          debugPrint('🔧     - Set boolean default: ${_currentValues[param.key]}');
        }
      }
    }

    debugPrint('🔧   - Final _currentValues: $_currentValues');

    // Immediately notify parent about the initial values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onConfigChanged(_currentValues);
    });
  }

  void _updateValue(String key, dynamic value, String type) {
    dynamic convertedValue = value;

    // Convert value based on type
    switch (type) {
      case 'number':
        convertedValue = int.tryParse(value.toString()) ?? 0;
        break;
      case 'boolean':
        convertedValue = _safeBool(value);
        break;
      case 'array':
        // Safely convert value to List<String>
        convertedValue = _safeStringList(value);
        break;
      default:
        convertedValue = value.toString();
    }

    setState(() {
      _currentValues[key] = convertedValue;
    });
    widget.onConfigChanged(_currentValues);
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;

    if (widget.isTestMode == true) {
      isDarkMode = widget.testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      colors = context.colorsListening;
      isDarkMode = context.isDarkMode;
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: AppDimensions.spacingS),
                Text(widget.subtitle!, style: TextStyle(fontSize: 14, color: colors.textSecondary)),
              ],
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Direct content without Expanded to avoid unbounded height constraints
          _buildFormContent(colors),
        ],
      ),
    );
  }

  Widget _buildFormContent(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name field (if name callback is provided)
        if (widget.onNameChanged != null) ...[
          _buildTextField(
            'Configuration Name',
            'Enter a name for this configuration',
            _nameController,
            required: true,
            colors: colors,
          ),
          const SizedBox(height: AppDimensions.spacingL),
        ],

        // Parameters section
        if (widget.parameters.isNotEmpty) ...[
          _buildSectionHeader('Configuration Parameters', colors),
          const SizedBox(height: AppDimensions.spacingM),
          ...widget.parameters.map((param) => _buildParameterField(param, colors)),
        ],

        // Integrations section
        if (widget.requiredIntegrationTypes.isNotEmpty || widget.optionalIntegrationTypes.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.spacingL),
          _buildIntegrationsSection(colors),
        ],

        // Test section
        if (widget.onTestConfiguration != null) ...[
          const SizedBox(height: AppDimensions.spacingL),
          _buildTestSection(colors),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, ThemeColorSet colors) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textColor),
    );
  }

  Widget _buildParameterField(ConfigParameter param, ThemeColorSet colors) {
    Widget field;

    switch (param.type) {
      case 'boolean':
        field = _buildBooleanField(param, colors);
        break;
      case 'select':
        field = _buildSelectField(param, colors);
        break;
      case 'textarea':
        field = _buildTextAreaField(param, colors);
        break;
      case 'number':
        field = _buildNumberField(param, colors);
        break;
      case 'array':
        field = _buildArrayField(param, colors);
        break;
      default:
        field = _buildStringField(param, colors);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingL),
      child: field,
    );
  }

  Widget _buildStringField(ConfigParameter param, ThemeColorSet colors) {
    if (param.sensitive) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: param.displayName,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textColor),
              children: param.required
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: colors.warningColor),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
          SensitiveFieldInput(
            placeholder: param.placeholder ?? param.description,
            controller: _controllers[param.key]!,
            isTestMode: widget.isTestMode ?? false,
          ),
        ],
      );
    } else {
      return _buildTextField(
        param.displayName,
        param.placeholder ?? param.description,
        _controllers[param.key]!,
        colors: colors,
        required: param.required,
      );
    }
  }

  Widget _buildNumberField(ConfigParameter param, ThemeColorSet colors) {
    return _buildTextField(
      param.displayName,
      param.placeholder ?? param.description,
      _controllers[param.key]!,
      required: param.required,
      keyboardType: TextInputType.number,
      colors: colors,
    );
  }

  /// Helper method to safely convert values to strings
  String _safeString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  Widget _buildBooleanField(ConfigParameter param, ThemeColorSet colors) {
    final value = _safeBool(_currentValues[param.key]);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM, vertical: AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: colors.bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  param.displayName,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textColor),
                ),
                if (param.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(param.description, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) => _updateValue(param.key, newValue, param.type),
            activeThumbColor: colors.accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectField(ConfigParameter param, ThemeColorSet colors) {
    final value = _safeString(_currentValues[param.key], defaultValue: param.defaultValue?.toString() ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          param.displayName,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textColor),
        ),
        if (param.description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(param.description, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
        ],
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: param.options.contains(value) ? value : null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              borderSide: BorderSide(color: colors.accentColor, width: 2),
            ),
            filled: true,
            fillColor: colors.bgColor,
          ),
          items: param.options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option, style: TextStyle(color: colors.textColor)),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              _updateValue(param.key, newValue, param.type);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTextAreaField(ConfigParameter param, ThemeColorSet colors) {
    return _buildTextField(
      param.displayName,
      param.placeholder ?? param.description,
      _controllers[param.key]!,
      required: param.required,
      maxLines: 4,
      colors: colors,
    );
  }

  Widget _buildTextField(
    String label,
    String placeholder,
    TextEditingController controller, {
    required ThemeColorSet colors,
    bool required = false,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textColor),
            children: required
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: colors.warningColor),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: colors.textMuted),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              borderSide: BorderSide(color: colors.accentColor, width: 2),
            ),
            filled: true,
            fillColor: colors.bgColor,
          ),
          style: TextStyle(color: colors.textColor),
        ),
      ],
    );
  }

  Widget _buildIntegrationsSection(ThemeColorSet colors) {
    final allSections = <Widget>[];

    // Required integrations section
    if (widget.requiredIntegrationTypes.isNotEmpty) {
      allSections.add(_buildSectionHeader('Required Integrations', colors));
      allSections.add(const SizedBox(height: AppDimensions.spacingM));

      for (final type in widget.requiredIntegrationTypes) {
        final available = widget.availableIntegrations
            .where((integration) => integration.type == type && integration.enabled)
            .toList();

        final selected = _currentIntegrations
            .where(
              (id) =>
                  widget.availableIntegrations.any((integration) => integration.id == id && integration.type == type),
            )
            .toList();

        allSections.add(_buildIntegrationTypeSelection(type, available, selected, colors, true));
      }
    }

    // Optional integrations section
    if (widget.optionalIntegrationTypes.isNotEmpty) {
      if (widget.requiredIntegrationTypes.isNotEmpty) {
        allSections.add(const SizedBox(height: AppDimensions.spacingL));
      }
      allSections.add(_buildSectionHeader('Optional Integrations', colors));
      allSections.add(const SizedBox(height: AppDimensions.spacingM));

      for (final type in widget.optionalIntegrationTypes) {
        final available = widget.availableIntegrations
            .where((integration) => integration.type == type && integration.enabled)
            .toList();

        final selected = _currentIntegrations
            .where(
              (id) =>
                  widget.availableIntegrations.any((integration) => integration.id == id && integration.type == type),
            )
            .toList();

        allSections.add(_buildIntegrationTypeSelection(type, available, selected, colors, false));
      }
    }

    return Column(children: allSections);
  }

  Widget _buildIntegrationTypeSelection(
    String type,
    List<AvailableIntegration> available,
    List<String> selected,
    ThemeColorSet colors,
    bool isRequired,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: colors.bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                type,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textColor),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isRequired
                      ? colors.warningColor.withValues(alpha: 0.1)
                      : colors.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isRequired ? 'Required' : 'Optional',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isRequired ? colors.warningColor : colors.accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          if (available.isEmpty) ...[
            Row(
              children: [
                Icon(Icons.warning, size: 16, color: colors.warningColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No $type integrations configured',
                    style: TextStyle(fontSize: 12, color: colors.textSecondary),
                  ),
                ),
                TextButton.icon(
                  onPressed: widget.onCreateIntegration,
                  icon: Icon(Icons.add, size: 16, color: colors.accentColor),
                  label: Text('Create Integration', style: TextStyle(fontSize: 12, color: colors.accentColor)),
                ),
              ],
            ),
          ] else ...[
            // For optional integrations, add a "None" option
            if (!isRequired) ...[
              RadioListTile<String?>(
                value: null,
                groupValue: selected.isNotEmpty ? selected.first : null,
                onChanged: (value) {
                  setState(() {
                    // Remove any existing selections for this category type
                    _currentIntegrations.removeWhere(
                      (id) => widget.availableIntegrations.any((avail) => avail.id == id && avail.type == type),
                    );
                  });
                  widget.onIntegrationsChanged?.call(_currentIntegrations);
                },
                title: Text('None', style: TextStyle(fontSize: 14, color: colors.textColor)),
                subtitle: Text(
                  'No integration selected for this category',
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ],
            ...available.map((integration) {
              return RadioListTile<String>(
                value: integration.id,
                groupValue: selected.isNotEmpty ? selected.first : null,
                onChanged: (value) {
                  setState(() {
                    // Remove any existing selections for this category type
                    _currentIntegrations.removeWhere(
                      (id) => widget.availableIntegrations.any((avail) => avail.id == id && avail.type == type),
                    );

                    // Add the new selection
                    if (value != null) {
                      _currentIntegrations.add(value);
                    }
                  });
                  widget.onIntegrationsChanged?.call(_currentIntegrations);
                },
                title: Text(integration.name, style: TextStyle(fontSize: 14, color: colors.textColor)),
                subtitle: integration.description != null
                    ? Text(integration.description!, style: TextStyle(fontSize: 12, color: colors.textSecondary))
                    : null,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildTestSection(ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: colors.bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test Configuration',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textColor),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Verify that your configuration is working correctly',
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              SecondaryButton(
                text: widget.isLoading ? 'Testing...' : 'Test Configuration',
                onPressed: widget.isLoading ? null : widget.onTestConfiguration,
                isTestMode: widget.isTestMode ?? false,
              ),
            ],
          ),
          if (widget.testResult != null) ...[
            const SizedBox(height: AppDimensions.spacingM),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingS),
              decoration: BoxDecoration(
                color: colors.successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                border: Border.all(color: colors.successColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: colors.successColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(widget.testResult!, style: TextStyle(fontSize: 12, color: colors.successColor)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildArrayField(ConfigParameter param, ThemeColorSet colors) {
    final currentArray = _currentValues[param.key] as List<String>? ?? <String>[];

    return ArrayInput(
      values: currentArray,
      onChanged: (newValues) => _updateValue(param.key, newValues, param.type),
      placeholder: param.placeholder ?? 'Enter new item',
      label: param.displayName,
      required: param.required,
      isTestMode: widget.isTestMode ?? false,
      testDarkMode: widget.testDarkMode ?? false,
      validator: (values) {
        if (param.required && (values == null || values.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
