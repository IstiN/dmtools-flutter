import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class MarkdownRendererPage extends StatelessWidget {
  const MarkdownRendererPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.cardBg,
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PageHeaderSection(),
            SizedBox(height: AppDimensions.spacingXl),
            _BasicExample(),
            SizedBox(height: AppDimensions.spacingXl),
            _CodeBlockExample(),
            SizedBox(height: AppDimensions.spacingXl),
            _WebhookExample(),
          ],
        ),
      ),
    );
  }
}

class _PageHeaderSection extends StatelessWidget {
  const _PageHeaderSection();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: 'Markdown Renderer',
          onThemeToggle: () {}, // Empty callback for demo
        ),
        Text(
          'Rich markdown rendering with code block copy functionality',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _BasicExample extends StatelessWidget {
  const _BasicExample();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    const markdownContent = '''
# Basic Markdown Features

This demonstrates the **MarkdownRenderer** component with various formatting options.

## Text Formatting

- **Bold text** and *italic text*
- [Links to external sites](https://flutter.dev)
- `Inline code` formatting
- Regular paragraph text with proper spacing

### Lists

1. Ordered list item 1
2. Ordered list item 2
3. Ordered list item 3

Unordered list:
- Bullet point 1
- Bullet point 2
- Bullet point 3

> This is a blockquote demonstrating how quoted text appears in our markdown renderer.

---

### Table Example

| Feature | Status | Description |
|---------|--------|-------------|
| Headers | ✓ | H1-H6 support |
| Links | ✓ | External links |
| Code | ✓ | Inline and blocks |
| Lists | ✓ | Ordered/unordered |
''';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Basic Markdown Example'),
        const SizedBox(height: AppDimensions.spacingM),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(color: colors.borderColor),
          ),
          child: const Padding(
            padding: EdgeInsets.all(AppDimensions.spacingM),
            child: MarkdownRenderer(data: markdownContent),
          ),
        ),
      ],
    );
  }
}

class _CodeBlockExample extends StatelessWidget {
  const _CodeBlockExample();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    const codeMarkdown = '''
## Code Block Examples

Here are various code examples with syntax highlighting:

### Dart Code
```dart
class MarkdownRenderer extends StatelessWidget {
  const MarkdownRenderer({
    required this.data,
    this.showCodeCopyButton = true,
    super.key,
  });

  final String data;
  final bool showCodeCopyButton;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MarkdownBody(data: data);
  }
}
```

### JSON Configuration
```json
{
  "webhook": {
    "url": "https://api.example.com/webhook",
    "method": "POST",
    "headers": {
      "Content-Type": "application/json",
      "Authorization": "Bearer token"
    }
  }
}
```

### Bash Script
```bash
#!/bin/bash
flutter pub get
flutter test
flutter build web
```

### JavaScript
```javascript
const markdownRenderer = {
  render: (content) => {
    return processMarkdown(content);
  },
  
  highlight: (code, language) => {
    return hljs.highlight(code, { language }).value;
  }
};
```
''';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Code Block Examples'),
        const SizedBox(height: AppDimensions.spacingM),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(color: colors.borderColor),
          ),
          child: const Padding(
            padding: EdgeInsets.all(AppDimensions.spacingM),
            child: MarkdownRenderer(data: codeMarkdown),
          ),
        ),
      ],
    );
  }
}

class _WebhookExample extends StatelessWidget {
  const _WebhookExample();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    const webhookMarkdown = '''
## Webhook Documentation Example

This shows how the markdown renderer can be used for API documentation:

### Setting Up Webhooks

Webhooks allow your application to receive real-time notifications when specific events occur.

#### Configuration

1. **Create a webhook endpoint** in your application
2. **Configure the webhook URL** in your dashboard
3. **Set up authentication** using API keys

#### Example Request

```bash
curl -X POST "https://api.example.com/webhooks" \\
  -H "Content-Type: application/json" \\
  -H "Authorization: Bearer YOUR_API_KEY" \\
  -d '{
    "url": "https://your-app.com/webhook",
    "events": ["user.created", "order.completed"],
    "secret": "webhook_secret_key"
  }'
```

#### Response Format

```json
{
  "id": "webhook_123",
  "url": "https://your-app.com/webhook",
  "events": ["user.created", "order.completed"],
  "created_at": "2024-01-15T10:30:00Z",
  "status": "active"
}
```

> **Important**: Always validate webhook signatures to ensure security.

#### Event Types

| Event | Description | Payload |
|-------|-------------|---------|
| `user.created` | New user registration | User object |
| `order.completed` | Order processing finished | Order object |
| `payment.failed` | Payment processing failed | Payment error |

For more information, see our [API documentation](https://docs.example.com).
''';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Webhook Documentation Example'),
        const SizedBox(height: AppDimensions.spacingM),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(color: colors.borderColor),
          ),
          child: const Padding(
            padding: EdgeInsets.all(AppDimensions.spacingM),
            child: MarkdownRenderer(data: webhookMarkdown),
          ),
        ),
      ],
    );
  }
}
