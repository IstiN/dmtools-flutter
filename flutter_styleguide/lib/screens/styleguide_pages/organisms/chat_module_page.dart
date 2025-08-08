import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import '../../../widgets/organisms/chat_module.dart';
import '../../../widgets/styleguide/component_display.dart';

class ChatModulePage extends StatelessWidget {
  // Properties data structure for cleaner table generation
  static const List<Map<String, String>> _propertyData = [
    {'property': 'messages', 'type': 'List<ChatMessage>', 'description': 'List of chat messages to display'},
    {'property': 'onSendMessage', 'type': 'Function(String)', 'description': 'Callback when a message is sent'},
    {
      'property': 'onAttachmentPressed',
      'type': 'VoidCallback?',
      'description': 'Callback when attachment button is pressed',
    },
    {'property': 'showHeader', 'type': 'bool', 'description': 'Whether to show the chat header'},
    {'property': 'title', 'type': 'String', 'description': 'Title shown in the header'},
    {'property': 'isLoading', 'type': 'bool', 'description': 'Whether to show loading indicator'},
  ];
  const ChatModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Chat Module')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chat Module', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Interactive chat component with message display and input area.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            ComponentDisplay(
              title: 'Default Chat Module',
              description: 'Standard chat module with header and message input.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.spacingM),
                  ChatInterface(
                    messages: [
                      ChatMessage(message: 'Hello! How can I help you today?', isUser: false),
                      ChatMessage(message: 'I need help with setting up a new agent.', isUser: true),
                      ChatMessage(
                        message:
                            'Sure, I can guide you through the process. What type of agent would you like to create?',
                        isUser: false,
                      ),
                    ],
                    onSendMessage: (message) {
                      // Handle sending message
                    },
                    onAttachmentPressed: () {
                      // Handle attachment
                    },
                    isTestMode: true,
                    testDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            ComponentDisplay(
              title: 'Rich Markdown Chat Module',
              description: 'Chat module showcasing rich markdown formatting with code blocks, lists, and links.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.spacingM),
                  ChatInterface(
                    messages: [
                      ChatMessage(
                        message:
                            'Hi! I need help with **API integration**. Here\'s my current setup:\n\n```json\n{\n  "endpoint": "https://api.example.com/v1",\n  "method": "POST",\n  "headers": {\n    "Authorization": "Bearer token",\n    "Content-Type": "application/json"\n  }\n}\n```\n\nI\'m getting a *401 Unauthorized* error. Can you help?',
                        isUser: true,
                      ),
                      ChatMessage(
                        message:
                            '''I can help you with that authentication issue! Let me walk you through the troubleshooting steps:

## Common Authentication Problems

1. **Expired Token**: Check if your bearer token is still valid
2. **Wrong Headers**: Verify all required headers are included
3. **Invalid Permissions**: Ensure the token has proper scopes

### Quick Diagnostic Steps

Try this updated configuration:

```javascript
const config = {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer YOUR_VALID_TOKEN',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'YourApp/1.0'
  }
};
```

> **Pro Tip**: Always check the API response headers for additional error details.

### Next Steps

- [ ] Verify token expiration
- [ ] Check API documentation for required headers
- [ ] Test with a fresh token
- [ ] Review [authentication guide](https://docs.example.com/auth)

Would you like me to help you generate a new token?''',
                        isUser: false,
                      ),
                      ChatMessage(
                        message: '''Perfect! That worked. The issue was missing the `Accept` header. 

Here's my working code now:

```dart
final response = await http.post(
  Uri.parse('https://api.example.com/v1/data'),
  headers: {
    'Authorization': 'Bearer \$token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
  body: jsonEncode(payload),
);
```

**Thank you!** This is exactly what I needed. 🎉''',
                        isUser: true,
                      ),
                      ChatMessage(
                        message: '''Excellent! 🎉 I'm glad we got that sorted out.

## Summary

✅ **Problem**: Missing `Accept` header causing 401 error  
✅ **Solution**: Added proper headers to API request  
✅ **Result**: Successful authentication and data retrieval

### Additional Resources

For future reference, here are some helpful links:

- [API Documentation](https://docs.example.com/api)
- [Authentication Best Practices](https://docs.example.com/auth/best-practices)
- [Error Code Reference](https://docs.example.com/errors)

Feel free to reach out if you need help with anything else! 😊''',
                        isUser: false,
                      ),
                    ],
                    onSendMessage: (message) {
                      // Handle sending message
                    },
                    onAttachmentPressed: () {
                      // Handle attachment
                    },
                    title: 'API Support Chat',
                    isTestMode: true,
                    testDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DART',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      '''
ChatInterface(
  messages: [
    ChatMessage(
      message: 'Hello! How can I help you today?',
      isUser: false,
    ),
    ChatMessage(
      message: 'I need help with setting up a new agent.',
      isUser: true,
    ),
    ChatMessage(
      message: 'Sure, I can guide you through the process. What type of agent would you like to create?',
      isUser: false,
    ),
  ],
  onSendMessage: (message) {
    // Handle sending message
  },
  onAttachmentPressed: () {
    // Handle attachment
  },
),''',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        height: 1.5,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            ComponentDisplay(
              title: 'Properties',
              description: 'The ChatInterface widget accepts the following properties:',
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Table(
                  columnWidths: const {0: FlexColumnWidth(), 1: FlexColumnWidth(), 2: FlexColumnWidth(2)},
                  border: TableBorder.all(color: colors.borderColor),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: colors.bgColor),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Property',
                            style: TextStyle(fontWeight: FontWeight.bold, color: colors.textColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Type',
                            style: TextStyle(fontWeight: FontWeight.bold, color: colors.textColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold, color: colors.textColor),
                          ),
                        ),
                      ],
                    ),
                    // Generate table rows from data structure
                    ..._propertyData.map(
                      (property) =>
                          _buildTableRow(property['property']!, property['type']!, property['description']!, colors),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String property, String type, String description, dynamic colors) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            property,
            style: TextStyle(fontFamily: 'monospace', color: colors.textColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            type,
            style: TextStyle(fontFamily: 'monospace', color: colors.textColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(description, style: TextStyle(color: colors.textColor)),
        ),
      ],
    );
  }
}
