/// Accessibility utilities for generating test identifiers and semantic labels
/// for automation testing and screen reader support.
library;

/// Generates a human-readable test identifier based on component type and parameters.
///
/// Examples:
/// - `generateTestId('button', {'action': 'submit'})` → 'button-submit'
/// - `generateTestId('card', {'type': 'agent', 'name': 'GPT-4'})` → 'card-agent-gpt4'
/// - `generateTestId('input', {'field': 'email'})` → 'input-email'
///
/// Parameters are processed in alphabetical order for consistency.
/// Values are sanitized to lowercase with special characters replaced by hyphens.
String generateTestId(String componentType, [Map<String, dynamic>? params]) {
  final sanitizedType = _sanitize(componentType);
  
  if (params == null || params.isEmpty) {
    return sanitizedType;
  }

  // Sort parameters by key for consistent ordering
  final sortedKeys = params.keys.toList()..sort();
  final parts = <String>[sanitizedType];

  for (final key in sortedKeys) {
    final value = params[key];
    if (value != null) {
      parts.add(_sanitize(value.toString()));
    }
  }

  return parts.join('-');
}

/// Generates a human-readable semantic label for screen readers.
///
/// Examples:
/// - `generateSemanticLabel('button', 'Submit form')` → 'Submit form button'
/// - `generateSemanticLabel('card', 'Agent GPT-4')` → 'Agent GPT-4 card'
/// - `generateSemanticLabel('input', 'Email address')` → 'Email address input field'
String generateSemanticLabel(String componentType, String context) {
  final type = componentType.toLowerCase();
  
  // Add appropriate suffix based on component type
  final suffix = _getComponentSuffix(type);
  
  if (suffix.isEmpty) {
    return context;
  }
  
  return '$context $suffix';
}

/// Sanitizes a string for use in test identifiers.
/// Converts to lowercase and replaces special characters with hyphens.
String _sanitize(String value) {
  return value
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}

/// Gets an appropriate suffix for a component type to use in semantic labels.
String _getComponentSuffix(String componentType) {
  switch (componentType) {
    case 'button':
      return 'button';
    case 'input':
    case 'textfield':
    case 'textinput':
      return 'input field';
    case 'checkbox':
      return 'checkbox';
    case 'radio':
      return 'radio button';
    case 'select':
    case 'dropdown':
      return 'dropdown';
    case 'card':
      return 'card';
    case 'header':
      return 'header';
    case 'link':
      return 'link';
    case 'icon':
      return 'icon';
    case 'logo':
      return 'logo';
    case 'image':
      return 'image';
    case 'status':
      return 'status indicator';
    case 'tag':
    case 'chip':
      return 'tag';
    default:
      return '';
  }
}

/// Validates that a test identifier follows the correct format.
/// Returns true if valid, false otherwise.
bool isValidTestId(String testId) {
  if (testId.isEmpty) return false;
  
  // Must contain only lowercase letters, numbers, and hyphens
  // Cannot start or end with hyphen
  final pattern = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$');
  return pattern.hasMatch(testId);
}

/// Combines multiple test ID parts into a valid test identifier.
///
/// Example:
/// ```dart
/// combineTestIdParts(['form', 'login', 'submit']) → 'form-login-submit'
/// ```
String combineTestIdParts(List<String> parts) {
  final sanitizedParts = parts
      .where((part) => part.isNotEmpty)
      .map((part) => _sanitize(part))
      .where((part) => part.isNotEmpty)
      .toList();
  
  return sanitizedParts.join('-');
}

/// Extracts the component type from a test identifier.
///
/// Example:
/// ```dart
/// extractComponentType('button-submit') → 'button'
/// extractComponentType('card-agent-gpt4') → 'card'
/// ```
String extractComponentType(String testId) {
  final parts = testId.split('-');
  return parts.isNotEmpty ? parts.first : '';
}

