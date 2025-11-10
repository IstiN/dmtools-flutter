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
            _DetailsSummaryExample(),
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
          'Rich markdown rendering with beautiful syntax highlighting and code block copy functionality',
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

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Basic Markdown Example'),
        SizedBox(height: AppDimensions.spacingM),
        Padding(
          padding: EdgeInsets.all(AppDimensions.spacingM),
          child: MarkdownRenderer(data: markdownContent),
        ),
      ],
    );
  }
}

class _CodeBlockExample extends StatelessWidget {
  const _CodeBlockExample();

  @override
  Widget build(BuildContext context) {
    const codeMarkdown = '''
## Code Block Examples with Syntax Highlighting

Here are various code examples demonstrating beautiful syntax highlighting:

### Java Example

```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

**Explanation:**

- `public class Main { ... }`: This defines a class named `Main`. In Java, all code must reside within a class. `public` means this class is accessible from anywhere.

- `public static void main(String[] args) { ... }`: This is the main method. It's the entry point of your Java program.
  - `public`: Makes the method accessible from outside the class.
  - `static`: Allows the method to be called without creating an instance of the Main class.
  - `void`: Indicates that the method doesn't return any value.
  - `String[] args`: An array that can hold command-line arguments.

- `System.out.println("Hello, World!");`: This line prints text to the console.
  - `System.out`: Represents the standard output stream.
  - `println()`: A method that prints the given string and adds a newline character.
  - `"Hello, World!"`: The string literal to be printed.

### Dart Code Example

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

### JavaScript Example

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

### Python Example

```python
def greet(name):
    """Greet someone by name."""
    message = f"Hello, {name}!"
    print(message)
    return message

if __name__ == "__main__":
    greet("World")
```
''';

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Code Block Examples with Syntax Highlighting'),
        SizedBox(height: AppDimensions.spacingM),
        Padding(
          padding: EdgeInsets.all(AppDimensions.spacingM),
          child: MarkdownRenderer(data: codeMarkdown),
        ),
      ],
    );
  }
}

class _DetailsSummaryExample extends StatelessWidget {
  const _DetailsSummaryExample();

  @override
  Widget build(BuildContext context) {
    const detailsMarkdown = '''
## Collapsible Sections with Details/Summary

You can create collapsible sections using HTML `<details>` and `<summary>` tags:

<details>
<summary>Tips for collapsed sections</summary>

### You can add a header

You can add text within a collapsed section.

You can add an image or a code block, too.

```dart
void main() {
  print('Hello, World!');
}
```

- List items work too
- Another item
- And more items

</details>

<details open>
<summary>This section is open by default</summary>

This section uses the `open` attribute to display expanded by default.

You can include any markdown content here:
- **Bold text**
- *Italic text*
- [Links](https://example.com)
- Code blocks
- And more!

</details>

<details>
<summary>Technical Details</summary>

Here are some technical implementation details:

1. The details element creates a collapsible section
2. The summary element provides the clickable header
3. Content inside details is hidden until expanded
4. You can nest multiple details sections

```json
{
  "feature": "collapsible sections",
  "supported": true,
  "tags": ["details", "summary"]
}
```

</details>
''';

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Collapsible Sections (Details/Summary)'),
        SizedBox(height: AppDimensions.spacingM),
        Padding(
          padding: EdgeInsets.all(AppDimensions.spacingM),
          child: MarkdownRenderer(data: detailsMarkdown),
        ),
      ],
    );
  }
}

class _WebhookExample extends StatelessWidget {
  const _WebhookExample();

  @override
  Widget build(BuildContext context) {
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

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Webhook Documentation Example'),
        SizedBox(height: AppDimensions.spacingM),
        Padding(
          padding: EdgeInsets.all(AppDimensions.spacingM),
          child: MarkdownRenderer(data: webhookMarkdown),
        ),
      ],
    );
  }
}
