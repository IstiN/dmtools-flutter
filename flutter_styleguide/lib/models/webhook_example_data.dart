import 'webhook_key.dart';

/// Data structure for webhook integration examples
class WebhookExampleData {
  final String name;
  final String content;
  final WebhookIntegrationType type;

  const WebhookExampleData({required this.name, required this.content, required this.type});

  factory WebhookExampleData.fromApiResponse({required String name, required String renderedTemplate}) {
    // Map API example names to integration types
    final type = _mapNameToType(name);

    return WebhookExampleData(name: name, content: renderedTemplate, type: type);
  }

  static WebhookIntegrationType _mapNameToType(String name) {
    final lowercaseName = name.toLowerCase();

    if (lowercaseName.contains('curl')) {
      return WebhookIntegrationType.curl;
    } else if (lowercaseName.contains('jira')) {
      return WebhookIntegrationType.jiraAutomation;
    } else if (lowercaseName.contains('github')) {
      return WebhookIntegrationType.githubActions;
    } else if (lowercaseName.contains('postman')) {
      return WebhookIntegrationType.postman;
    } else {
      return WebhookIntegrationType.curl; // default fallback
    }
  }
}
