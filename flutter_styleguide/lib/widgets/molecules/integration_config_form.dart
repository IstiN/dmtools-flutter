import 'package:flutter/material.dart';
import '../organisms/dynamic_config_form.dart';
import 'integration_type_selector.dart';

/// Dynamic configuration form that generates fields based on integration type parameters
/// Now uses the shared DynamicConfigForm organism for consistency with job configurations
class IntegrationConfigForm extends StatelessWidget {
  final IntegrationType integrationType;
  final Map<String, String> initialValues;
  final String? initialName;
  final ValueChanged<Map<String, String>> onConfigChanged;
  final ValueChanged<String>? onNameChanged;
  final VoidCallback? onTestConnection;
  final bool isLoading;
  final String? testResult;
  final bool? isTestMode;
  final bool? testDarkMode;

  const IntegrationConfigForm({
    required this.integrationType,
    required this.initialValues,
    required this.onConfigChanged,
    this.initialName,
    this.onNameChanged,
    this.onTestConnection,
    this.isLoading = false,
    this.testResult,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Convert IntegrationType.configParams to ConfigParameter format
    final configParameters = integrationType.configParams.map((param) {
      return ConfigParameter(
        key: param.key,
        displayName: param.displayName,
        description: param.description,
        required: param.required,
        sensitive: param.sensitive,
        type: param.type,
        defaultValue: param.defaultValue,
        options: param.options,
      );
    }).toList();

    // Convert Map<String, String> to Map<String, dynamic> for compatibility
    final dynamicInitialValues = Map<String, dynamic>.from(initialValues);

    return DynamicConfigForm(
      title: 'Configuration',
      subtitle: 'Configure your ${integrationType.displayName} integration',
      parameters: configParameters,
      initialValues: dynamicInitialValues,
      initialName: initialName ?? '${integrationType.displayName} Integration',
      requiredIntegrationTypes: const [], // Integrations don't require other integrations
      availableIntegrations: const [], // No sub-integrations needed
      selectedIntegrations: const [],
      onConfigChanged: (values) {
        // Convert Map<String, dynamic> back to Map<String, String>
        final stringValues = Map<String, String>.from(
          values.map((key, value) => MapEntry(key, value?.toString() ?? '')),
        );
        onConfigChanged(stringValues);
      },
      onNameChanged: onNameChanged,
      onTestConfiguration: onTestConnection,
      isLoading: isLoading,
      testResult: testResult,
      isTestMode: isTestMode,
      testDarkMode: testDarkMode,
    );
  }
}
