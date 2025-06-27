import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import '../../../widgets/organisms/chat_module.dart';
import '../../../widgets/styleguide/component_display.dart';

class ChatModulePage extends StatelessWidget {
  const ChatModulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Module'),
        backgroundColor: colors.accentColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat Module',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
                  ChatModule(
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
                border: Border.all(
                  color: colors.borderColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DART',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      '''
ChatModule(
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
              description: 'The ChatModule widget accepts the following properties:',
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(2),
                  },
                  border: TableBorder.all(
                    color: colors.borderColor,
                  ),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: colors.bgColor,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Property',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.textColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Type',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.textColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Description',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colors.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildTableRow('messages', 'List<ChatMessage>', 'List of chat messages to display', colors),
                    _buildTableRow('onSendMessage', 'Function(String)', 'Callback when a message is sent', colors),
                    _buildTableRow('onAttachmentPressed', 'VoidCallback?', 'Callback when attachment button is pressed', colors),
                    _buildTableRow('showHeader', 'bool', 'Whether to show the chat header', colors),
                    _buildTableRow('title', 'String', 'Title shown in the header', colors),
                    _buildTableRow('isLoading', 'bool', 'Whether to show loading indicator', colors),
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
            style: TextStyle(
              fontFamily: 'monospace',
              color: colors.textColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            type,
            style: TextStyle(
              fontFamily: 'monospace',
              color: colors.textColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            description,
            style: TextStyle(
              color: colors.textColor,
            ),
          ),
        ),
      ],
    );
  }
} 