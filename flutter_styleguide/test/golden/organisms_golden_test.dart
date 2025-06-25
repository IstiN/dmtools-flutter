import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/widgets/organisms/chat_module.dart';
import 'package:dmtools_styleguide/widgets/organisms/page_header.dart';
import 'package:dmtools_styleguide/widgets/organisms/welcome_banner.dart';
import 'package:dmtools_styleguide/widgets/organisms/panel_base.dart';
import 'package:dmtools_styleguide/widgets/organisms/workspace_management.dart';
import '../golden_test_helper.dart';

void main() {
  group('Organisms Golden Tests', () {
    testWidgets('Page Header - Light Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          PageHeader(
            title: 'DMTools',
            onThemeToggle: () {},
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
            isTestMode: true,
            testDarkMode: false,
          ),
        ),
      );
      await expectLater(
        find.byType(PageHeader),
        matchesGoldenFile('goldens/page_header_light.png'),
      );
    });

    testWidgets('Page Header - Dark Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          PageHeader(
            title: 'DMTools',
            onThemeToggle: () {},
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
            isTestMode: true,
            testDarkMode: true,
          ),
          darkMode: true,
        ),
      );
      await expectLater(
        find.byType(PageHeader),
        matchesGoldenFile('goldens/page_header_dark.png'),
      );
    });

    testWidgets('Welcome Banner - Light Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: WelcomeBanner(
              title: 'Welcome to DMTools',
              subtitle: 'Build, deploy, and manage AI agents with our powerful platform.',
              onPrimaryAction: () {},
              onSecondaryAction: () {},
              primaryActionText: 'Get Started',
              secondaryActionText: 'Learn More',
              isTestMode: true,
              testDarkMode: false,
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(WelcomeBanner),
        matchesGoldenFile('goldens/welcome_banner_light.png'),
      );
    });

    testWidgets('Welcome Banner - Dark Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: WelcomeBanner(
              title: 'Welcome to DMTools',
              subtitle: 'Build, deploy, and manage AI agents with our powerful platform.',
              onPrimaryAction: () {},
              onSecondaryAction: () {},
              primaryActionText: 'Get Started',
              secondaryActionText: 'Learn More',
              isTestMode: true,
              testDarkMode: true,
            ),
          ),
          darkMode: true,
        ),
      );
      await expectLater(
        find.byType(WelcomeBanner),
        matchesGoldenFile('goldens/welcome_banner_dark.png'),
      );
    });

    testWidgets('Chat Module - Light Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ChatModule(
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
              onSendMessage: (message) {},
              isTestMode: true,
              testDarkMode: false,
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(ChatModule),
        matchesGoldenFile('goldens/chat_module_light.png'),
      );
    });

    testWidgets('Chat Module - Dark Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ChatModule(
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
              onSendMessage: (message) {},
              isTestMode: true,
              testDarkMode: true,
            ),
          ),
          darkMode: true,
        ),
      );
      await expectLater(
        find.byType(ChatModule),
        matchesGoldenFile('goldens/chat_module_dark.png'),
      );
    });

    testWidgets('Panel Base - Light Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PanelBase(
              title: 'Panel Title',
              headerStyle: PanelHeaderStyle.primary,
              isTestMode: true,
              testDarkMode: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {},
                ),
              ],
              content: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('This is the content area of the panel.'),
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(PanelBase),
        matchesGoldenFile('goldens/panel_base_light.png'),
      );
    });

    testWidgets('Panel Base - Dark Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PanelBase(
              title: 'Panel Title',
              headerStyle: PanelHeaderStyle.primary,
              isTestMode: true,
              testDarkMode: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {},
                ),
              ],
              content: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('This is the content area of the panel.'),
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(PanelBase),
        matchesGoldenFile('goldens/panel_base_dark.png'),
      );
    });

    testWidgets('Workspace Management - Light Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          Padding(
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
              ],
              onWorkspaceSelected: (_) {},
              onCreateWorkspace: () {},
              isTestMode: true,
              testDarkMode: false,
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(WorkspaceManagement),
        matchesGoldenFile('goldens/workspace_management_light.png'),
      );
    });

    testWidgets('Workspace Management - Dark Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          Padding(
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
              ],
              onWorkspaceSelected: (_) {},
              onCreateWorkspace: () {},
              isTestMode: true,
              testDarkMode: true,
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(WorkspaceManagement),
        matchesGoldenFile('goldens/workspace_management_dark.png'),
      );
    });

    testWidgets('All Organisms - Light Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    title: 'DMTools',
                    onThemeToggle: () {},
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                    isTestMode: true,
                    testDarkMode: false,
                  ),
                  const SizedBox(height: 16),
                  WelcomeBanner(
                    title: 'Welcome to DMTools',
                    subtitle: 'Build, deploy, and manage AI agents with our powerful platform.',
                    onPrimaryAction: () {},
                    onSecondaryAction: () {},
                    primaryActionText: 'Get Started',
                    secondaryActionText: 'Learn More',
                    isTestMode: true,
                    testDarkMode: false,
                  ),
                  const SizedBox(height: 16),
                  PanelBase(
                    title: 'Panel Title',
                    headerStyle: PanelHeaderStyle.primary,
                    isTestMode: true,
                    testDarkMode: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                    content: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('This is the content area of the panel.'),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    ],
                    onSendMessage: (message) {},
                    isTestMode: true,
                    testDarkMode: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(SingleChildScrollView),
        matchesGoldenFile('goldens/all_organisms_light.png'),
      );
    });

    testWidgets('All Organisms - Dark Mode', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        createTestApp(
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    title: 'DMTools',
                    onThemeToggle: () {},
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                    isTestMode: true,
                    testDarkMode: true,
                  ),
                  const SizedBox(height: 16),
                  WelcomeBanner(
                    title: 'Welcome to DMTools',
                    subtitle: 'Build, deploy, and manage AI agents with our powerful platform.',
                    onPrimaryAction: () {},
                    onSecondaryAction: () {},
                    primaryActionText: 'Get Started',
                    secondaryActionText: 'Learn More',
                    isTestMode: true,
                    testDarkMode: true,
                  ),
                  const SizedBox(height: 16),
                  PanelBase(
                    title: 'Panel Title',
                    headerStyle: PanelHeaderStyle.primary,
                    isTestMode: true,
                    testDarkMode: true,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                    content: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('This is the content area of the panel.'),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    ],
                    onSendMessage: (message) {},
                    isTestMode: true,
                    testDarkMode: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(SingleChildScrollView),
        matchesGoldenFile('goldens/all_organisms_dark.png'),
      );
    });
  });
} 