import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/form_elements.dart';
import '../atoms/sensitive_field_input.dart';
import '../atoms/buttons/app_buttons.dart';
import 'integration_type_selector.dart';

/// Dynamic configuration form that generates fields based on integration type parameters
class IntegrationConfigForm extends StatefulWidget {
  final IntegrationType integrationType;
  final Map<String, String> initialValues;
  final ValueChanged<Map<String, String>> onConfigChanged;
  final VoidCallback? onTestConnection;
  final bool isLoading;
  final String? testResult;
  final bool? isTestMode;
  final bool? testDarkMode;

  const IntegrationConfigForm({
    required this.integrationType,
    required this.initialValues,
    required this.onConfigChanged,
    this.onTestConnection,
    this.isLoading = false,
    this.testResult,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  State<IntegrationConfigForm> createState() => _IntegrationConfigFormState();
}

class _IntegrationConfigFormState extends State<IntegrationConfigForm> {
  late Map<String, TextEditingController> _controllers;
  late Map<String, String> _currentValues;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers = {};
    _currentValues = Map.from(widget.initialValues);

    for (final param in widget.integrationType.configParams) {
      _controllers[param.key] = TextEditingController(
        text: widget.initialValues[param.key] ?? param.defaultValue ?? '',
      );
      _controllers[param.key]!.addListener(() {
        _currentValues[param.key] = _controllers[param.key]!.text;
        widget.onConfigChanged(_currentValues);
      });
    }
  }

  @override
  void dispose() {
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
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: colors.borderColor),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: colors.accentColor,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  'Configuration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Configure your ${widget.integrationType.displayName} integration',
              style: TextStyle(
                fontSize: 14,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),

            // Configuration fields
            ...widget.integrationType.configParams.map((param) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                  child: _buildConfigField(param, colors),
                )),

            // Test connection section
            if (widget.onTestConnection != null) ...[
              const SizedBox(height: AppDimensions.spacingL),
              _buildTestSection(colors),
            ],

            // Setup instructions
            const SizedBox(height: AppDimensions.spacingL),
            _buildSetupInstructions(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigField(ConfigParam param, ThemeColorSet colors) {
    final isRequired = param.required;
    final label = '${param.displayName}${isRequired ? ' *' : ''}';

    Widget fieldWidget;

    if (param.type == 'select' && param.options.isNotEmpty) {
      // Dropdown field
      fieldWidget = DropdownButtonFormField<String>(
        value: _currentValues[param.key]?.isNotEmpty == true ? _currentValues[param.key] : param.defaultValue,
        items: param.options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _controllers[param.key]!.text = value;
              _currentValues[param.key] = value;
            });
            widget.onConfigChanged(_currentValues);
          }
        },
        decoration: InputDecoration(
          hintText: 'Select ${param.displayName}',
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
        ),
      );
    } else if (param.sensitive) {
      // Sensitive field
      fieldWidget = SensitiveFieldInput(
        controller: _controllers[param.key],
        placeholder: 'Enter ${param.displayName}',
        isTestMode: widget.isTestMode,
        testDarkMode: widget.testDarkMode,
      );
    } else {
      // Regular text field
      fieldWidget = TextInput(
        controller: _controllers[param.key],
        placeholder: 'Enter ${param.displayName}',
        isTestMode: widget.isTestMode,
        testDarkMode: widget.testDarkMode,
      );
    }

    return FormGroup(
      label: label,
      helperText: param.description,
      isTestMode: widget.isTestMode,
      testDarkMode: widget.testDarkMode,
      child: fieldWidget,
    );
  }

  Widget _buildTestSection(ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: colors.accentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: colors.accentColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wifi_tethering,
                color: colors.accentColor,
                size: 16,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'Test Connection',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Verify that your configuration is correct by testing the connection',
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              PrimaryButton(
                text: widget.isLoading ? 'Testing...' : 'Test Connection',
                onPressed: widget.isLoading ? null : widget.onTestConnection,
                size: ButtonSize.small,
                icon: widget.isLoading ? null : Icons.play_arrow,
                isTestMode: widget.isTestMode ?? false,
                testDarkMode: widget.testDarkMode ?? false,
              ),
              if (widget.testResult != null) ...[
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: _buildTestResult(colors),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestResult(ThemeColorSet colors) {
    final isSuccess = widget.testResult?.toLowerCase().contains('success') == true ||
        widget.testResult?.toLowerCase().contains('connected') == true;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isSuccess ? colors.successColor.withValues(alpha: 0.1) : colors.dangerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSuccess ? colors.successColor : colors.dangerColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            size: 12,
            color: isSuccess ? colors.successColor : colors.dangerColor,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              widget.testResult!,
              style: TextStyle(
                fontSize: 11,
                color: isSuccess ? colors.successColor : colors.dangerColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupInstructions(ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: colors.infoColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: colors.infoColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: colors.infoColor,
                size: 16,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'How to get your ${widget.integrationType.displayName} credentials',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            _getSetupInstructions(widget.integrationType.type),
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getSetupInstructions(String integrationType) {
    switch (integrationType.toLowerCase()) {
      case 'github':
        return '1. Go to GitHub Settings > Developer settings > Personal access tokens\n'
            '2. Click "Generate new token (classic)"\n'
            '3. Select the required scopes for your integration\n'
            '4. Copy the generated token and paste it above';
      case 'slack':
        return '1. Go to https://api.slack.com/apps\n'
            '2. Create a new app or select an existing one\n'
            '3. Go to "OAuth & Permissions" and copy the Bot User OAuth Token\n'
            '4. Paste the token above';
      case 'google':
        return '1. Go to Google Cloud Console\n'
            '2. Enable the required APIs for your project\n'
            '3. Create credentials (Service Account or OAuth 2.0)\n'
            '4. Download the JSON file or copy the API key';
      default:
        return 'Please refer to the ${widget.integrationType.displayName} documentation for instructions on obtaining the required credentials.';
    }
  }
}
