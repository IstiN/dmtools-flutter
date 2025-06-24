import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/styleguide/component_display.dart';
import '../../widgets/styleguide/theme_switch.dart';
import '../../widgets/atoms/status_dot.dart';
import '../../widgets/atoms/buttons/app_buttons.dart';
import '../../widgets/molecules/molecules.dart';
import '../../core/models/agent.dart';

class MoleculesPage extends StatelessWidget {
  const MoleculesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListView(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      children: [
        ComponentDisplay(
          title: 'Theme Switch',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('The theme switch component allows users to toggle between light and dark modes.'),
              SizedBox(height: AppDimensions.spacingM),
              ThemeSwitch(
                isDarkMode: themeProvider.isDarkMode,
                onToggle: () {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        
        // Cards section
        ComponentDisplay(
          title: 'Cards',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Cards are used to group related information. Different card styles are available for different use cases.'),
              SizedBox(height: AppDimensions.spacingM),
              
              UnderlinedSectionHeader(
                title: 'Standard Card',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppDimensions.spacingS),
              SizedBox(
                width: 300,
                child: StandardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Card Title', style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: AppDimensions.spacingXs),
                      Text('This is some content within a basic card.', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: AppDimensions.spacingM),
              UnderlinedSectionHeader(
                title: 'Compact Card',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppDimensions.spacingS),
              SizedBox(
                width: 300,
                child: CompactCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Compact Card', style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: AppDimensions.spacingXs),
                      Text('A card with smaller padding and radius.', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: AppDimensions.spacingM),
              UnderlinedSectionHeader(
                title: 'Accent Card',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppDimensions.spacingS),
              SizedBox(
                width: 300,
                child: AccentCard(
                  title: 'Accent Card',
                  icon: Icons.star,
                  child: Text('A card with a colored header section.'),
                ),
              ),
              
              SizedBox(height: AppDimensions.spacingM),
              UnderlinedSectionHeader(
                title: 'Agent Card',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppDimensions.spacingS),
              SizedBox(
                width: 400,
                child: AgentCard(
                  title: 'Sample Agent',
                  description: 'This is a sample agent description that explains what the agent does and its capabilities.',
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
        SizedBox(height: AppDimensions.spacingXl),
        
        // Search Forms section
        ComponentDisplay(
          title: 'Search Forms',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Search forms combine an input field and a button for search functionality.'),
              SizedBox(height: AppDimensions.spacingM),
              
              UnderlinedSectionHeader(
                title: 'Standard Search Form',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppDimensions.spacingS),
              const StandardSearchForm(),
              
              SizedBox(height: AppDimensions.spacingM),
              UnderlinedSectionHeader(
                title: 'Compact Search Form',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppDimensions.spacingS),
              const CompactSearchForm(),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        
        // Section Headers section
        ComponentDisplay(
          title: 'Section Headers',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Section headers are used to label and organize content sections.'),
              SizedBox(height: AppDimensions.spacingM),
              
              UnderlinedSectionHeader(
                title: 'Standard Section Header',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppDimensions.spacingS),
              StandardSectionHeader(
                title: 'Section Title',
                onViewAll: () {},
              ),
              
              SizedBox(height: AppDimensions.spacingM),
              UnderlinedSectionHeader(
                title: 'Underlined Section Header',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppDimensions.spacingS),
              UnderlinedSectionHeader(
                title: 'Section With Underline',
                onViewAll: () {},
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        
        // Empty States section
        ComponentDisplay(
          title: 'Empty States',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Empty states are used when no content is available or to prompt user action.'),
              SizedBox(height: AppDimensions.spacingM),
              
              UnderlinedSectionHeader(
                title: 'Dashed Border Empty State',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppDimensions.spacingS),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DashedEmptyState(
                      icon: Icons.add,
                      title: 'Create New Agent',
                      message: 'Configure automation for your tasks',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppDimensions.spacingM),
              UnderlinedSectionHeader(
                title: 'Solid Border Empty State',
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: AppDimensions.spacingS),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SolidEmptyState(
                      icon: Icons.add,
                      title: 'Create New Item',
                      message: 'Get started by creating your first item',
                      onPressed: () {},
                      elevation: 2.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        
        // Other components
        ComponentDisplay(
          title: 'Login Provider Selector',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A component that allows users to choose from multiple authentication providers.'),
              SizedBox(height: AppDimensions.spacingM),
              const LoginProviderSelector(),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Application Item',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('List items specifically designed for displaying application information with metadata.'),
              SizedBox(height: AppDimensions.spacingM),
              ApplicationItem(onOpen: () {}),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Chat Message',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Displays a single message in a chat interface, with variations for sender.'),
              SizedBox(height: AppDimensions.spacingM),
              const ChatMessage(
                text: 'This is a message from the user.',
                sender: MessageSender.user,
              ),
              SizedBox(height: AppDimensions.spacingXs),
              const ChatMessage(
                text: 'This is a message from the agent.',
                sender: MessageSender.agent,
              ),
              SizedBox(height: AppDimensions.spacingXs),
              const ChatMessage(
                text: 'This is a system notification.',
                sender: MessageSender.system,
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Chat Input Group',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A group containing a textarea for message input and action buttons like send or attach.'),
              SizedBox(height: AppDimensions.spacingM),
              const ChatInputGroup(),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Action Button Group',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A simple horizontal group of action buttons, typically used for form submissions or main actions in a section.'),
              SizedBox(height: AppDimensions.spacingM),
              ActionButtonGroup(
                buttons: [
                  SecondaryButton(
                    text: 'Generate Action',
                    onPressed: () {},
                  ),
                  PrimaryButton(
                    text: 'Save Action',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Notification Message',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Notification messages for displaying system messages, alerts, or feedback to the user.'),
              SizedBox(height: AppDimensions.spacingM),
              const NotificationMessage(
                message: 'This is an info notification message.',
                type: NotificationType.info,
              ),
              SizedBox(height: AppDimensions.spacingS),
              const NotificationMessage(
                message: 'This is a success notification message.',
                type: NotificationType.success,
              ),
              SizedBox(height: AppDimensions.spacingS),
              const NotificationMessage(
                message: 'This is a warning notification message.',
                type: NotificationType.warning,
              ),
              SizedBox(height: AppDimensions.spacingS),
              const NotificationMessage(
                message: 'This is an error notification message.',
                type: NotificationType.error,
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'User Profile Button',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A button that displays user information and can be clicked to open a dropdown menu.'),
              SizedBox(height: AppDimensions.spacingM),
              const UserProfileButton(
                username: 'John Doe',
                email: 'john.doe@example.com',
              ),
            ],
          ),
        ),
      ],
    );
  }
} 