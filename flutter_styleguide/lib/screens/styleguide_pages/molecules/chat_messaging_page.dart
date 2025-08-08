import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class ChatMessagingPage extends StatelessWidget {
  const ChatMessagingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Chat & Messaging'), backgroundColor: colors.cardBg),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          const ComponentDisplay(
            title: 'Chat & Messaging',
            description: 'Chat components including messages, input groups, and notification messages.',
            child: SizedBox.shrink(),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Chat Message Section
          _buildSection(
            context,
            'Chat Message',
            'Individual message components for chat interfaces',
            _buildChatMessageExample(context),
          ),

          // Rich Markdown Chat Messages Section
          _buildSection(
            context,
            'Markdown Chat Messages',
            'Chat messages with rich markdown formatting support',
            _buildMarkdownChatMessageExample(context),
          ),

          // Message Input Section
          _buildSection(
            context,
            'Message Input',
            'Input components for composing chat messages',
            _buildMessageInputExample(context),
          ),

          // Notification Message Section
          _buildSection(
            context,
            'Notification Message',
            'System notification and alert messages',
            _buildNotificationMessageExample(context),
          ),

          // Chat Status Section
          _buildSection(
            context,
            'Chat Status',
            'Status indicators for chat and messaging',
            _buildChatStatusExample(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description, Widget example) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: AppDimensions.spacingS),
        Text(description, style: TextStyle(fontSize: 14, color: context.colors.textColor.withValues(alpha: 0.8))),
        const SizedBox(height: AppDimensions.spacingM),
        example,
        const SizedBox(height: AppDimensions.spacingL),
      ],
    );
  }

  Widget _buildChatMessageExample(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        // User message
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                  color: colors.secondaryColor,
                  borderRadius: BorderRadius.circular(18),
                ),
              child: Text(
                'Hello! Can you help me with the integration setup?',
                style: TextStyle(color: colors.bgColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingS),
        // System message
        Row(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.borderColor),
              ),
              child: Text(
                'Of course! I\'d be happy to help you set up your integration. What type of integration are you working with?',
                style: TextStyle(color: colors.textColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageInputExample(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: colors.textColor.withValues(alpha: 0.6)),
              ),
              style: TextStyle(color: colors.textColor),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.attach_file, color: colors.textColor.withValues(alpha: 0.6)),
          ),
          PrimaryButton(text: 'Send', onPressed: () {}, size: ButtonSize.small),
        ],
      ),
    );
  }

  Widget _buildNotificationMessageExample(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        // Success notification
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.successColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.successColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: colors.successColor, size: 20),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: Text(
                  'Integration configured successfully!',
                  style: TextStyle(color: colors.successColor, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        // Warning notification
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.warningColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.warningColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.warning, color: colors.warningColor, size: 20),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: Text(
                  'Please check your API credentials.',
                  style: TextStyle(color: colors.warningColor, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatStatusExample(BuildContext context) {
    final colors = context.colors;

    return Wrap(
      spacing: AppDimensions.spacingM,
      runSpacing: AppDimensions.spacingS,
      children: [
        // Online status
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: colors.successColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text('Online', style: TextStyle(color: colors.textColor, fontSize: 12)),
          ],
        ),
        // Typing indicator
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: colors.accentColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text('Typing...', style: TextStyle(color: colors.textColor, fontSize: 12)),
          ],
        ),
        // Offline status
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: colors.textColor.withValues(alpha: 0.4), shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text('Offline', style: TextStyle(color: colors.textColor, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildMarkdownChatMessageExample(BuildContext context) {
    return Column(
      children: [
        // User markdown message
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: context.colors.accentColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const MarkdownRenderer(
                    data: '''I need help with **API integration**. Here's my current setup:

```json
{
  "endpoint": "https://api.example.com/v1",
  "auth": "Bearer token",
  "timeout": 30000
}
```

Can you help me fix the *authentication* issue?''',
                    shrinkWrap: true,
                    selectable: false,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(child: Icon(Icons.person_outline)),
            ],
          ),
        ),

        // Agent markdown response
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const CircleAvatar(child: Icon(Icons.smart_toy_outlined)),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: const MarkdownRenderer(
                    data: '''I can help you with that! Looking at your configuration, here are a few things to check:

## Authentication Issues

1. **Token Validation**: Verify your bearer token is still valid
2. **Headers**: Make sure you're including the proper headers
3. **Permissions**: Check if the token has the required scopes

### Quick Fix

Try updating your request like this:

```javascript
const response = await fetch('https://api.example.com/v1/data', {
  headers: {
    'Authorization': 'Bearer YOUR_TOKEN',
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
});
```

> **Note**: Always store tokens securely and never expose them in client-side code.

Would you like me to walk through the [authentication flow](https://docs.example.com/auth) step by step?''',
                    shrinkWrap: true,
                    selectable: false,
                  ),
                ),
              ),
            ],
          ),
        ),

        // System markdown message
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          alignment: Alignment.center,
          child: const MarkdownRenderer(
            data: '''## System Update

The integration has been **successfully configured**! 

- ✅ API endpoint validated
- ✅ Authentication verified  
- ✅ Connection established

You can now start using the integration. Check the [documentation](https://docs.example.com) for more details.''',
            shrinkWrap: true,
            selectable: false,
          ),
        ),
      ],
    );
  }
}
