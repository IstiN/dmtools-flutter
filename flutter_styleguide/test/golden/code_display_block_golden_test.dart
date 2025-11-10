import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/molecules/code_display_block.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('Code Display Block Golden Tests', () {
    goldenTest(
      'Code Display Block - Java - Light Mode',
      fileName: 'code_display_java_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_java_light',
            child: SizedBox(
              width: 700,
              height: 400,
              child: helper.createTestApp(_buildJavaCodeBlock()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Code Display Block - Java - Dark Mode',
      fileName: 'code_display_java_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_java_dark',
            child: SizedBox(
              width: 700,
              height: 300,
              child: helper.createTestApp(_buildJavaCodeBlock(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Code Display Block - JSON - Light Mode',
      fileName: 'code_display_json_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_json_light',
            child: SizedBox(
              width: 700,
              height: 500,
              child: helper.createTestApp(_buildJsonCodeBlock()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Code Display Block - JSON - Dark Mode',
      fileName: 'code_display_json_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_json_dark',
            child: SizedBox(
              width: 700,
              height: 500,
              child: helper.createTestApp(_buildJsonCodeBlock(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Code Display Block - Dart - Light Mode',
      fileName: 'code_display_dart_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_dart_light',
            child: SizedBox(
              width: 700,
              height: 400,
              child: helper.createTestApp(_buildDartCodeBlock()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Code Display Block - Dart - Dark Mode',
      fileName: 'code_display_dart_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_dart_dark',
            child: SizedBox(
              width: 700,
              height: 300,
              child: helper.createTestApp(_buildDartCodeBlock(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Code Display Block - JavaScript - Light Mode',
      fileName: 'code_display_javascript_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_javascript_light',
            child: SizedBox(
              width: 700,
              height: 400,
              child: helper.createTestApp(_buildJavaScriptCodeBlock()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Code Display Block - JavaScript - Dark Mode',
      fileName: 'code_display_javascript_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_javascript_dark',
            child: SizedBox(
              width: 700,
              height: 300,
              child: helper.createTestApp(_buildJavaScriptCodeBlock(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Code Display Block - Bash - Light Mode',
      fileName: 'code_display_bash_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_bash_light',
            child: SizedBox(
              width: 700,
              height: 400,
              child: helper.createTestApp(_buildBashCodeBlock()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Code Display Block - Bash - Dark Mode',
      fileName: 'code_display_bash_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_bash_dark',
            child: SizedBox(
              width: 700,
              height: 300,
              child: helper.createTestApp(_buildBashCodeBlock(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Code Display Block - All Languages - Light Mode',
      fileName: 'code_display_all_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_all_light',
            child: SizedBox(
              width: 800,
              height: 1200,
              child: helper.createTestApp(_buildAllLanguagesCodeBlock()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Code Display Block - All Languages - Dark Mode',
      fileName: 'code_display_all_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'code_display_all_dark',
            child: SizedBox(
              width: 800,
              height: 1200,
              child: helper.createTestApp(_buildAllLanguagesCodeBlock(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildJavaCodeBlock() {
  const javaCode = '''public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
        int number = 42;
        boolean isTrue = true;
    }
}''';

  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: CodeDisplayBlock(
      code: javaCode,
      language: 'java',
      title: 'Java Example',
      theme: CodeDisplayTheme.auto,
    ),
  );
}

Widget _buildJsonCodeBlock() {
  const jsonCode = '''{
  "webhook": {
    "url": "https://api.example.com/webhook",
    "method": "POST",
    "headers": {
      "Content-Type": "application/json",
      "Authorization": "Bearer token"
    },
    "body": {
      "jobParameters": {
        "request": "Analyze this ticket",
        "inputJql": "key = DMC-123"
      }
    }
  }
}''';

  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: CodeDisplayBlock(
      code: jsonCode,
      language: 'json',
      title: 'JSON Example',
      theme: CodeDisplayTheme.auto,
    ),
  );
}

Widget _buildDartCodeBlock() {
  const dartCode = '''class MarkdownRenderer extends StatelessWidget {
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
}''';

  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: CodeDisplayBlock(
      code: dartCode,
      language: 'dart',
      title: 'Dart Example',
      theme: CodeDisplayTheme.auto,
    ),
  );
}

Widget _buildJavaScriptCodeBlock() {
  const jsCode = '''const markdownRenderer = {
  render: (content) => {
    return processMarkdown(content);
  },
  
  highlight: (code, language) => {
    return hljs.highlight(code, { language }).value;
  }
};

function greet(name) {
  return `Hello, \${name}!`;
}''';

  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: CodeDisplayBlock(
      code: jsCode,
      language: 'javascript',
      title: 'JavaScript Example',
      theme: CodeDisplayTheme.auto,
    ),
  );
}

Widget _buildBashCodeBlock() {
  const bashCode = '''curl -X POST "https://api.example.com/webhooks" \\
  -H "Content-Type: application/json" \\
  -H "Authorization: Bearer YOUR_API_KEY" \\
  -d '{
    "url": "https://your-app.com/webhook",
    "events": ["user.created", "order.completed"],
    "secret": "webhook_secret_key"
  }' ''';

  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: CodeDisplayBlock(
      code: bashCode,
      language: 'bash',
      title: 'Bash Example',
      theme: CodeDisplayTheme.auto,
    ),
  );
}

Widget _buildAllLanguagesCodeBlock() {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CodeDisplayBlock(
            code: '''public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}''',
            language: 'java',
            title: 'Java',
            theme: CodeDisplayTheme.auto,
          ),
          SizedBox(height: 16),
          CodeDisplayBlock(
            code: '''{
  "webhook": {
    "url": "https://api.example.com/webhook",
    "method": "POST"
  }
}''',
            language: 'json',
            title: 'JSON',
            theme: CodeDisplayTheme.auto,
          ),
          SizedBox(height: 16),
          CodeDisplayBlock(
            code: '''class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}''',
            language: 'dart',
            title: 'Dart',
            theme: CodeDisplayTheme.auto,
          ),
          SizedBox(height: 16),
          CodeDisplayBlock(
            code: '''const example = {
  render: (content) => {
    return processMarkdown(content);
  }
};''',
            language: 'javascript',
            title: 'JavaScript',
            theme: CodeDisplayTheme.auto,
          ),
          SizedBox(height: 16),
          CodeDisplayBlock(
            code: '''curl -X POST "https://api.example.com/webhook" \\
  -H "Content-Type: application/json" \\
  -d '{"data": "example"}' ''',
            language: 'bash',
            title: 'Bash',
            theme: CodeDisplayTheme.auto,
          ),
        ],
      ),
    ),
  );
}

