import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/organisms/chat_module.dart';
import 'package:dmtools_styleguide/widgets/organisms/page_header.dart';
import 'package:dmtools_styleguide/widgets/organisms/welcome_banner.dart';
import 'package:dmtools_styleguide/widgets/organisms/panel_base.dart';
import 'package:dmtools_styleguide/widgets/organisms/workspace_management.dart';
import 'package:dmtools_styleguide/widgets/molecules/ai_integration_selector.dart';
import 'package:dmtools_styleguide/widgets/molecules/file_attachment_picker.dart';
import 'package:dmtools_styleguide/models/mcp_config_option.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('Organisms Golden Tests', () {
    goldenTest(
      'Page Header - Light Mode',
      fileName: 'page_header_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'page_header_light',
            child: SizedBox(width: 1200, height: 200, child: helper.createTestApp(_buildPageHeader())),
          ),
        ],
      ),
    );

    goldenTest(
      'Page Header - Dark Mode',
      fileName: 'page_header_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'page_header_dark',
            child: SizedBox(width: 1200, height: 200, child: helper.createTestApp(_buildPageHeader(), darkMode: true)),
          ),
        ],
      ),
    );

    goldenTest(
      'Welcome Banner - Light Mode',
      fileName: 'welcome_banner_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'welcome_banner_light',
            child: SizedBox(width: 1000, height: 600, child: helper.createTestApp(_buildWelcomeBanner())),
          ),
        ],
      ),
    );

    goldenTest(
      'Welcome Banner - Dark Mode',
      fileName: 'welcome_banner_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'welcome_banner_dark',
            child: SizedBox(
              width: 1000,
              height: 600,
              child: helper.createTestApp(_buildWelcomeBanner(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Module - Light Mode',
      fileName: 'chat_module_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_module_light',
            child: SizedBox(width: 800, height: 600, child: helper.createTestApp(_buildChatModule())),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Module - Dark Mode',
      fileName: 'chat_module_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_module_dark',
            child: SizedBox(width: 800, height: 600, child: helper.createTestApp(_buildChatModule(), darkMode: true)),
          ),
        ],
      ),
    );

    goldenTest(
      'Enhanced Chat Module with AI Integration - Light Mode',
      fileName: 'enhanced_chat_module_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'enhanced_chat_module_light',
            child: SizedBox(width: 800, height: 600, child: helper.createTestApp(_buildEnhancedChatModule())),
          ),
        ],
      ),
    );

    goldenTest(
      'Enhanced Chat Module with AI Integration - Dark Mode',
      fileName: 'enhanced_chat_module_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'enhanced_chat_module_dark',
            child: SizedBox(
              width: 800,
              height: 600,
              child: helper.createTestApp(_buildEnhancedChatModule(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Panel Base - Light Mode',
      fileName: 'panel_base_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'panel_base_light',
            child: SizedBox(width: 800, height: 400, child: helper.createTestApp(_buildPanelBase())),
          ),
        ],
      ),
    );

    goldenTest(
      'Panel Base - Dark Mode',
      fileName: 'panel_base_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'panel_base_dark',
            child: SizedBox(width: 800, height: 400, child: helper.createTestApp(_buildPanelBase(), darkMode: true)),
          ),
        ],
      ),
    );

    goldenTest(
      'Workspace Management - Light Mode',
      fileName: 'workspace_management_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'workspace_management_light',
            child: SizedBox(width: 1000, height: 600, child: helper.createTestApp(_buildWorkspaceManagement())),
          ),
        ],
      ),
    );

    goldenTest(
      'Workspace Management - Dark Mode',
      fileName: 'workspace_management_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'workspace_management_dark',
            child: SizedBox(
              width: 1000,
              height: 600,
              child: helper.createTestApp(_buildWorkspaceManagement(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildPageHeader() {
  return Scaffold(
    body: PageHeader(
      title: 'DMTools',
      onThemeToggle: () {},
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
      isTestMode: true,
    ),
  );
}

Widget _buildWelcomeBanner() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: WelcomeBanner(
        title: 'Welcome to DMTools',
        subtitle: 'Build, deploy, and manage AI agents with our powerful platform.',
        onPrimaryAction: () {},
        onSecondaryAction: () {},
        isTestMode: true,
      ),
    ),
  );
}

Widget _buildChatModule() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ChatInterface(
        messages: [
          ChatMessage(message: 'Hello! How can I help you today?', isUser: false),
          ChatMessage(message: 'I need help with setting up a new agent.', isUser: true),
          ChatMessage(
            message: 'Sure, I can guide you through the process. What type of agent would you like to create?',
            isUser: false,
          ),
        ],
        onSendMessage: (message) {},
        isTestMode: true,
      ),
    ),
  );
}

Widget _buildPanelBase() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: PanelBase(
        title: 'Panel Title',
        isTestMode: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
        content: const Padding(padding: EdgeInsets.all(16.0), child: Text('This is the content area of the panel.')),
      ),
    ),
  );
}

Widget _buildWorkspaceManagement() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: WorkspaceManagement(
        workspaces: [
          WorkspaceCard(
            name: 'Marketing Team',
            description: 'Workspace for marketing team projects and campaigns',
            memberCount: 8,
            agentCount: 3,
            lastActive: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          WorkspaceCard(
            name: 'Development Team',
            description: 'Software development and engineering workspace',
            memberCount: 12,
            agentCount: 5,
            lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
        ],
        onWorkspaceSelected: (_) {},
        onCreateWorkspace: () {},
        isTestMode: true,
      ),
    ),
  );
}

Widget _buildEnhancedChatModule() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ChatInterface(
        messages: [
          ChatMessage(
            message: 'Welcome! I can help you with various tasks. Which AI would you like to use?',
            isUser: false,
          ),
          ChatMessage(
            message: 'I\'d like to analyze some code. Let me switch to OpenAI for better code analysis.',
            isUser: true,
          ),
          ChatMessage(
            message:
                'Great choice! OpenAI is excellent for code analysis. Please share your code and I\'ll help you review it.',
            isUser: false,
          ),
        ],
        aiIntegrations: const [
          AiIntegration(id: '1', type: 'openai', displayName: 'OpenAI GPT-4'),
          AiIntegration(id: '2', type: 'gemini', displayName: 'Google Gemini'),
          AiIntegration(id: '3', type: 'openai', displayName: 'Claude 3.5', isActive: false),
        ],
        selectedAiIntegration: const AiIntegration(id: '1', type: 'openai', displayName: 'OpenAI GPT-4'),
        mcpConfigurations: const [
          McpConfigOption.fromConfig(id: 'jira-1', name: 'Jira Integration'),
          McpConfigOption.fromConfig(id: 'confluence-1', name: 'Confluence Tools'),
          McpConfigOption.fromConfig(id: 'github-1', name: 'GitHub Assistant'),
        ],
        selectedMcpConfiguration: const McpConfigOption.fromConfig(id: 'jira-1', name: 'Jira Integration'),
        onMcpConfigurationChanged: (config) {},
        attachments: [
          FileAttachment(
            name: 'example.dart',
            size: 2048,
            type: 'dart',
            bytes: const [],
            uploadedAt: DateTime(2024, 1, 15, 10, 30),
          ),
        ],
        onSendMessage: (message) {},
        onAiIntegrationChanged: (integration) {},
        onAttachmentsChanged: (attachments) {},
        onAttachmentPressed: () {},
        title: 'AI-Enhanced Chat with MCP',
        isTestMode: true,
      ),
    ),
  );
}
