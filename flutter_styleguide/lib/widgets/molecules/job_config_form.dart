import 'package:flutter/material.dart';
import '../organisms/dynamic_config_form.dart';
import '../organisms/job_configuration_management.dart';

/// Dynamic job configuration form that builds fields based on job type parameters
class JobConfigForm extends StatelessWidget {
  final JobType jobType;
  final List<IntegrationCategory> availableIntegrations;
  final Map<String, dynamic> initialValues;
  final String? initialName;
  final List<String> initialIntegrations;
  final ValueChanged<Map<String, dynamic>> onConfigChanged;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<List<String>>? onIntegrationsChanged;
  final VoidCallback? onTestConfiguration;
  final VoidCallback? onCreateIntegration;
  final bool isLoading;
  final String? testResult;
  final bool? isTestMode;
  final bool? testDarkMode;

  const JobConfigForm({
    required this.jobType,
    required this.availableIntegrations,
    required this.initialValues,
    required this.onConfigChanged,
    this.initialName,
    this.initialIntegrations = const [],
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
  Widget build(BuildContext context) {
    // Convert JobType parameters to ConfigParameter format
    final configParameters = jobType.parameters.map((param) {
      return ConfigParameter(
        key: param.key,
        displayName: param.displayName,
        description: param.description,
        required: param.required,
        type: param.type,
        defaultValue: param.defaultValue,
        options: param.options ?? [],
      );
    }).toList();

    // Convert IntegrationCategory to AvailableIntegration format
    // Handle both individual integrations and category groupings
    final availableIntegrationsConverted = availableIntegrations.map((cat) {
      // Extract category type and integration ID from the type field
      // Format could be:
      // - "CategoryType" (for empty categories)
      // - "UUID" (for individual integrations - need to map back to category)
      // - "CategoryType:UUID" (compound format)

      debugPrint('🔧 JobConfigForm: Converting IntegrationCategory:');
      debugPrint('🔧   - type: "${cat.type}"');
      debugPrint('🔧   - displayName: "${cat.displayName}"');
      debugPrint('🔧   - description: "${cat.description}"');

      String categoryType;
      String integrationId;

      if (cat.type.contains(':')) {
        // Compound format: "CategoryType:UUID"
        final parts = cat.type.split(':');
        categoryType = parts[0];
        integrationId = cat.type; // Use full compound ID
        debugPrint('🔧   - Format: Compound (CategoryType:UUID)');
        debugPrint('🔧   - Extracted categoryType: "$categoryType"');
        debugPrint('🔧   - Using integrationId: "$integrationId"');
      } else if (cat.type.length > 10 && cat.type.contains('-')) {
        // Looks like a UUID - try to extract category from description
        integrationId = cat.type;
        debugPrint('🔧   - Format: UUID (${cat.type.length} chars)');

        // Extract category type from description if available
        if (cat.description.contains(' integration')) {
          final parts = cat.description.split(' integration');
          debugPrint('🔧   - Description contains " integration", parts: $parts');
          if (parts.isNotEmpty) {
            final extractedType = parts[0].replaceAll(RegExp(r'^.*: '), ''); // Remove prefix if exists
            categoryType = extractedType;
            debugPrint('🔧   - After regex removal: "$extractedType"');
          } else {
            categoryType = cat.type; // Fallback
            debugPrint('🔧   - Fallback to type (no parts)');
          }
        } else {
          categoryType = cat.type; // Fallback
          debugPrint('🔧   - Fallback to type (no " integration" found)');
        }
        debugPrint('🔧   - Final categoryType: "$categoryType"');
        debugPrint('🔧   - Using integrationId: "$integrationId"');
      } else {
        // Simple category type
        categoryType = cat.type;
        integrationId = cat.type;
        debugPrint('🔧   - Format: Simple category type');
        debugPrint('🔧   - Using categoryType: "$categoryType"');
        debugPrint('🔧   - Using integrationId: "$integrationId"');
      }

      final result = AvailableIntegration(
        id: integrationId, // Unique identifier for selection
        name: cat.displayName,
        type: categoryType, // Category type for grouping
        displayName: cat.displayName,
        enabled: cat.available,
        description: cat.description,
      );

      debugPrint('🔧   - Final AvailableIntegration:');
      debugPrint('🔧     - id: "${result.id}"');
      debugPrint('🔧     - type: "${result.type}"');
      debugPrint('🔧     - name: "${result.name}"');
      debugPrint('🔧 ----------------------------------------');

      return result;
    }).toList();

    return DynamicConfigForm(
      title: jobType.displayName,
      subtitle: jobType.description,
      parameters: configParameters,
      initialValues: initialValues,
      initialName: initialName ?? (onNameChanged != null ? '${jobType.displayName} Configuration' : null),
      requiredIntegrationTypes: jobType.requiredIntegrations,
      availableIntegrations: availableIntegrationsConverted,
      selectedIntegrations: initialIntegrations,
      onConfigChanged: onConfigChanged,
      onNameChanged: onNameChanged,
      onIntegrationsChanged: onIntegrationsChanged,
      onTestConfiguration: onTestConfiguration,
      onCreateIntegration: onCreateIntegration,
      isLoading: isLoading,
      testResult: testResult,
      isTestMode: isTestMode,
      testDarkMode: testDarkMode,
    );
  }
}
