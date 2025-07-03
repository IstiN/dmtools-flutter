import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/styleguide/component_display.dart';
import '../../widgets/molecules/agent_card.dart';
import '../../widgets/molecules/application_item.dart';
import '../../widgets/molecules/chat_input_group.dart';
import '../../widgets/molecules/custom_card.dart';
import '../../widgets/molecules/empty_state.dart';
import '../../widgets/molecules/login_provider_selector.dart';
import '../../widgets/molecules/search_form.dart';
import '../../widgets/molecules/user_profile_button.dart';
import '../../widgets/molecules/action_button_group.dart';
import '../../widgets/atoms/buttons/app_buttons.dart';
import '../../widgets/styleguide/theme_switch.dart';
import '../../widgets/molecules/chat_message.dart';
import '../../widgets/atoms/status_dot.dart';
import '../../widgets/molecules/integration_card.dart';
import '../../widgets/molecules/integration_type_selector.dart';
import '../../widgets/molecules/integration_config_form.dart';

class MoleculesPage extends StatelessWidget {
  const MoleculesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      children: [
        ComponentDisplay(
          title: 'Theme Switch',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('The theme switch component allows users to toggle between light and dark modes.'),
              const SizedBox(height: AppDimensions.spacingM),
              ThemeSwitch(
                isDarkMode: context.isDarkMode,
                onToggle: () {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Card',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Cards are used to group related information. The base style provides background, border, shadow, and rounded corners.'),
              const SizedBox(height: AppDimensions.spacingM),
              SizedBox(
                width: AppDimensions.dialogWidth * 0.625, // 300px equivalent
                child: CustomCard(
                  child: Padding(
                    padding: AppDimensions.cardPaddingM,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Card Title', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Text('This is some content within a basic card.',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Search Form',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A common molecule for search functionality, combining an input field and a button.'),
              SizedBox(height: AppDimensions.spacingM),
              SearchForm(),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Section Header',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A common pattern for section headers with a title and a "view all" link.'),
              const SizedBox(height: AppDimensions.spacingM),
              Text(
                'Section Title',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Agent Card',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Cards specifically designed for displaying agent information with status, description, and actions.'),
              const SizedBox(height: AppDimensions.spacingM),
              SizedBox(
                width: AppDimensions.dialogWidth * 0.833, // 400px equivalent
                child: AgentCard(
                  title: 'Sample Agent',
                  description:
                      'This is a sample agent description that explains what the agent does and its capabilities.',
                  status: StatusType.online,
                  statusLabel: 'Active',
                  tags: const ['Category'],
                  runCount: 5,
                  lastRunTime: 'Today',
                  onRun: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Login Provider Selector',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A component that allows users to choose from multiple authentication providers.'),
              SizedBox(height: AppDimensions.spacingM),
              LoginProviderSelector(),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Application Item',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('List items specifically designed for displaying application information with metadata.'),
              const SizedBox(height: AppDimensions.spacingM),
              ApplicationItem(onOpen: () {}),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Empty State',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A pattern for displaying empty states or call-to-action areas when no content is available.'),
              const SizedBox(height: AppDimensions.spacingM),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: EmptyState(
                      icon: Icons.add,
                      title: 'Create New Agent',
                      message: 'Configure automation for your tasks',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: EmptyState(
                      icon: Icons.add,
                      title: 'Create New Item',
                      message: 'Get started by creating your first item',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Chat Message',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Displays a single message in a chat interface, with variations for sender.'),
              SizedBox(height: AppDimensions.spacingM),
              ChatMessage(
                text: 'This is a message from the user.',
                sender: MessageSender.user,
              ),
              SizedBox(height: AppDimensions.spacingXs),
              ChatMessage(
                text: 'This is a message from the agent.',
                sender: MessageSender.agent,
              ),
              SizedBox(height: AppDimensions.spacingXs),
              ChatMessage(
                text: 'This is a system notification.',
                sender: MessageSender.system,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Chat Input Group',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A group containing a textarea for message input and action buttons like send or attach.'),
              const SizedBox(height: AppDimensions.spacingM),
              ChatInputGroup(
                controller: TextEditingController(),
                onSend: () {},
                onClear: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Action Button Group',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'A simple horizontal group of action buttons, typically used for form submissions or main actions in a section.'),
              const SizedBox(height: AppDimensions.spacingM),
              ActionButtonGroup(
                buttons: [
                  SecondaryButton(
                    text: 'Cancel',
                    onPressed: () {},
                  ),
                  PrimaryButton(
                    text: 'Submit',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Notification Message',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Floating messages to provide feedback to the user (success, error, info, warning).'),
              const SizedBox(height: AppDimensions.spacingM),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Success message'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Error message'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Info message'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Warning message'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'User Profile Button',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Displays user information with avatar, name, and optional dropdown indicator.'),
              const SizedBox(height: AppDimensions.spacingM),
              Row(
                children: [
                  UserProfileButton(
                    userName: 'John Doe',
                    avatarUrl: 'https://ui-avatars.com/api/?name=John+Doe&background=667eea&color=fff&size=48',
                    onPressed: () {},
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  UserProfileButton(
                    userName: 'Jane Smith',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Integration Card',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Displays integration information with status, usage, and action buttons.'),
              const SizedBox(height: AppDimensions.spacingM),
              SizedBox(
                width: AppDimensions.dialogWidth * 0.833, // 400px equivalent
                child: IntegrationCard(
                  id: '1',
                  name: 'GitHub Integration',
                  description: 'Connect to GitHub repositories',
                  type: 'github',
                  displayName: 'GitHub',
                  enabled: true,
                  usageCount: 42,
                  createdAt: DateTime.now().subtract(const Duration(days: 7)),
                  createdByName: 'John Doe',
                  workspaces: const ['Development Team'],
                  lastUsedAt: DateTime.now().subtract(const Duration(hours: 2)),
                  onEnable: () {},
                  onDisable: () {},
                  onTest: () {},
                  onEdit: () {},
                  onDelete: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Integration Type Selector',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Grid-based selector for choosing integration types when creating new integrations.'),
              const SizedBox(height: AppDimensions.spacingM),
              SizedBox(
                height: 300,
                child: IntegrationTypeSelector(
                  integrationTypes: const [
                    IntegrationType(
                      type: 'github',
                      displayName: 'GitHub',
                      description: 'Connect to GitHub repositories',
                      configParams: [
                        ConfigParam(
                          key: 'token',
                          displayName: 'Token',
                          description: 'API Token',
                          required: true,
                          sensitive: true,
                          type: 'string',
                          options: [],
                        )
                      ],
                    ),
                    IntegrationType(
                      type: 'slack',
                      displayName: 'Slack',
                      description: 'Send notifications to Slack',
                      configParams: [
                        ConfigParam(
                          key: 'webhook_url',
                          displayName: 'Webhook URL',
                          description: 'Slack webhook URL',
                          required: true,
                          sensitive: true,
                          type: 'string',
                          options: [],
                        )
                      ],
                    ),
                    IntegrationType(
                      type: 'google',
                      displayName: 'Google Cloud',
                      description: 'Connect to Google Cloud services',
                      configParams: [
                        ConfigParam(
                          key: 'service_account',
                          displayName: 'Service Account',
                          description: 'Service account credentials',
                          required: true,
                          sensitive: true,
                          type: 'string',
                          options: [],
                        )
                      ],
                    ),
                  ],
                  selectedType: const IntegrationType(
                    type: 'github',
                    displayName: 'GitHub',
                    description: 'Connect to GitHub repositories',
                    configParams: [],
                  ),
                  onTypeSelected: (type) {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Integration Config Form',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dynamic configuration form that adapts to different integration type requirements.'),
              const SizedBox(height: AppDimensions.spacingM),
              SizedBox(
                height: 400,
                child: IntegrationConfigForm(
                  integrationType: const IntegrationType(
                    type: 'github',
                    displayName: 'GitHub',
                    description: 'Connect to GitHub repositories',
                    configParams: [
                      ConfigParam(
                        key: 'token',
                        displayName: 'Personal Access Token',
                        description: 'GitHub personal access token with repo access',
                        required: true,
                        sensitive: true,
                        type: 'string',
                        options: [],
                      ),
                      ConfigParam(
                        key: 'repository',
                        displayName: 'Repository',
                        description: 'Repository name (owner/repo)',
                        required: true,
                        sensitive: false,
                        type: 'string',
                        options: [],
                      )
                    ],
                  ),
                  initialValues: const {'token': 'ghp_example123', 'repository': 'owner/repo'},
                  onConfigChanged: (config) {},
                  onTestConnection: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
