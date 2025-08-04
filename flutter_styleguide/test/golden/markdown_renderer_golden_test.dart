import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/molecules/markdown_renderer.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('Markdown Renderer Golden Tests', () {
    goldenTest(
      'Markdown Renderer - Light Mode',
      fileName: 'markdown_renderer_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'markdown_renderer_light',
            child: SizedBox(width: 600, height: 800, child: helper.createTestApp(_buildMarkdownRenderer())),
          ),
        ],
      ),
    );

    goldenTest(
      'Markdown Renderer - Dark Mode',
      fileName: 'markdown_renderer_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'markdown_renderer_dark',
            child: SizedBox(
              width: 600,
              height: 800,
              child: helper.createTestApp(_buildMarkdownRenderer(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Markdown Renderer with Code Blocks - Light Mode',
      fileName: 'markdown_code_blocks_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'markdown_code_blocks_light',
            child: SizedBox(width: 700, height: 600, child: helper.createTestApp(_buildMarkdownWithCodeBlocks())),
          ),
        ],
      ),
    );

    goldenTest(
      'Markdown Renderer with Code Blocks - Dark Mode',
      fileName: 'markdown_code_blocks_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'markdown_code_blocks_dark',
            child: SizedBox(
              width: 700,
              height: 600,
              child: helper.createTestApp(_buildMarkdownWithCodeBlocks(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildMarkdownRenderer() {
  const markdownContent = '''
# Markdown Renderer Demo

This is a demonstration of the **MarkdownRenderer** component with various formatting options.

## Features

- **Bold text** and *italic text*
- [Links](https://example.com)
- `Inline code` formatting
- Lists and more

### Unordered List
- Item 1
- Item 2
- Item 3

### Ordered List
1. First item
2. Second item
3. Third item

> This is a blockquote demonstrating how quoted text appears in our markdown renderer.

---

## Table Example

| Feature | Status | Notes |
|---------|--------|-------|
| Headers | ✓ | Working |
| Links | ✓ | Working |
| Code | ✓ | Working |

''';

  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SingleChildScrollView(child: MarkdownRenderer(data: markdownContent)),
  );
}

Widget _buildMarkdownWithCodeBlocks() {
  const markdownContent = '''
# Code Block Examples

Here are various code block examples to demonstrate syntax highlighting and copy functionality.

## JSON Example

```json
{
  "method": "POST",
  "url": "http://localhost:8080/api/v1/webhook",
  "headers": {
    "X-API-Key": "your-api-key",
    "Content-Type": "application/json"
  },
  "body": {
    "jobParameters": {
      "request": "Analyze this ticket",
      "inputJql": "key = DMC-123"
    }
  }
}
```

## Dart Example

```dart
class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello, World!'),
    );
  }
}
```

## Bash Example

```bash
curl -X POST "http://localhost:8080/api/webhook" \\
  -H "X-API-Key: your-key" \\
  -H "Content-Type: application/json" \\
  -d '{"data": "example"}'
```

Inline code like `flutter run` should also work well.
''';

  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SingleChildScrollView(child: MarkdownRenderer(data: markdownContent)),
  );
}
