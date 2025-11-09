import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/organisms/chat_module.dart';
import 'package:dmtools_styleguide/widgets/organisms/chat_theme.dart';
import 'package:dmtools_styleguide/widgets/organisms/chat_theme_config.dart';
import 'package:dmtools_styleguide/widgets/organisms/color_picker_widget.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  setUpAll(() async {
    await helper.GoldenTestHelper.loadAppFonts();
  });

  group('Chat Theme Golden Tests', () {
    // ChatThemeConfig tests
    goldenTest(
      'Chat Theme Config - Day Theme - Light Mode',
      fileName: 'chat_theme_config_day_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_theme_config_day_light',
            child: SizedBox(
              width: 600,
              height: 1200,
              child: helper.createTestApp(_buildChatThemeConfig(ChatTheme.day())),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Theme Config - Day Theme - Dark Mode',
      fileName: 'chat_theme_config_day_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_theme_config_day_dark',
            child: SizedBox(
              width: 600,
              height: 1200,
              child: helper.createTestApp(_buildChatThemeConfig(ChatTheme.day()), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Theme Config - Night Accent Theme - Light Mode',
      fileName: 'chat_theme_config_night_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_theme_config_night_light',
            child: SizedBox(
              width: 600,
              height: 1200,
              child: helper.createTestApp(_buildChatThemeConfig(ChatTheme.nightAccent())),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Theme Config - Night Accent Theme - Dark Mode',
      fileName: 'chat_theme_config_night_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_theme_config_night_dark',
            child: SizedBox(
              width: 600,
              height: 1200,
              child: helper.createTestApp(_buildChatThemeConfig(ChatTheme.nightAccent()), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Theme Config - Day Classic Theme - Light Mode',
      fileName: 'chat_theme_config_day_classic_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_theme_config_day_classic_light',
            child: SizedBox(
              width: 600,
              height: 1200,
              child: helper.createTestApp(_buildChatThemeConfig(ChatTheme.dayClassic())),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Theme Config - System Theme - Dark Mode',
      fileName: 'chat_theme_config_system_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_theme_config_system_dark',
            child: SizedBox(
              width: 600,
              height: 1200,
              child: helper.createTestApp(_buildChatThemeConfig(ChatTheme.system()), darkMode: true),
            ),
          ),
        ],
      ),
    );

    // ColorPickerWidget tests
    goldenTest(
      'Color Picker Widget - Blue Color - Light Mode',
      fileName: 'color_picker_blue_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'color_picker_blue_light',
            child: SizedBox(
              width: 450,
              height: 400,
              child: helper.createTestApp(_buildColorPicker(const Color(0xFF4285F4))),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Color Picker Widget - Blue Color - Dark Mode',
      fileName: 'color_picker_blue_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'color_picker_blue_dark',
            child: SizedBox(
              width: 450,
              height: 400,
              child: helper.createTestApp(_buildColorPicker(const Color(0xFF4285F4)), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Color Picker Widget - Red Color - Light Mode',
      fileName: 'color_picker_red_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'color_picker_red_light',
            child: SizedBox(
              width: 450,
              height: 400,
              child: helper.createTestApp(_buildColorPicker(const Color(0xFFEA4335))),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Color Picker Widget - Green Color - Light Mode',
      fileName: 'color_picker_green_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'color_picker_green_light',
            child: SizedBox(
              width: 450,
              height: 400,
              child: helper.createTestApp(_buildColorPicker(const Color(0xFF34A853))),
            ),
          ),
        ],
      ),
    );

    // ChatModule with different themes
    goldenTest(
      'Chat Module - Day Theme - Light Mode',
      fileName: 'chat_module_day_theme_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_module_day_theme_light',
            child: SizedBox(
              width: 800,
              height: 600,
              child: helper.createTestApp(_buildChatModuleWithTheme(ChatTheme.day())),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Module - Day Theme - Dark Mode',
      fileName: 'chat_module_day_theme_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_module_day_theme_dark',
            child: SizedBox(
              width: 800,
              height: 600,
              child: helper.createTestApp(_buildChatModuleWithTheme(ChatTheme.day()), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Module - Night Accent Theme - Dark Mode',
      fileName: 'chat_module_night_theme_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_module_night_theme_dark',
            child: SizedBox(
              width: 800,
              height: 600,
              child: helper.createTestApp(_buildChatModuleWithTheme(ChatTheme.nightAccent()), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Module - Day Classic Theme - Light Mode',
      fileName: 'chat_module_day_classic_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_module_day_classic_light',
            child: SizedBox(
              width: 800,
              height: 600,
              child: helper.createTestApp(_buildChatModuleWithTheme(ChatTheme.dayClassic())),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Module - System Theme - Dark Mode',
      fileName: 'chat_module_system_theme_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_module_system_theme_dark',
            child: SizedBox(
              width: 800,
              height: 600,
              child: helper.createTestApp(_buildChatModuleWithTheme(ChatTheme.system()), darkMode: true),
            ),
          ),
        ],
      ),
    );

    // ChatModule with custom colors
    goldenTest(
      'Chat Module - Custom Colors - Light Mode',
      fileName: 'chat_module_custom_colors_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_module_custom_colors_light',
            child: SizedBox(
              width: 800,
              height: 600,
              child: helper.createTestApp(_buildChatModuleWithCustomTheme()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Chat Module - Custom Colors - Dark Mode',
      fileName: 'chat_module_custom_colors_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_module_custom_colors_dark',
            child: SizedBox(
              width: 800,
              height: 600,
              child: helper.createTestApp(_buildChatModuleWithCustomTheme(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    // ChatModule with bubble mode disabled
    goldenTest(
      'Chat Module - No Bubble Mode - Light Mode',
      fileName: 'chat_module_no_bubble_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_module_no_bubble_light',
            child: SizedBox(
              width: 800,
              height: 600,
              child: helper.createTestApp(_buildChatModuleNoBubble()),
            ),
          ),
        ],
      ),
    );

    // ChatModule with different text sizes
    goldenTest(
      'Chat Module - Large Text Size - Light Mode',
      fileName: 'chat_module_large_text_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'chat_module_large_text_light',
            child: SizedBox(
              width: 800,
              height: 600,
              child: helper.createTestApp(_buildChatModuleLargeText()),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildChatThemeConfig(ChatTheme initialTheme) {
  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: ChatThemeConfig(
        initialTheme: initialTheme,
        onThemeChanged: (_) {},
        onDarkModeChanged: (_) {},
        onBubbleModeChanged: (_) {},
        onTextSizeChanged: (_) {},
        onNameColorChanged: (_) {},
      ),
    ),
  );
}

Widget _buildColorPicker(Color initialColor) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ColorPickerWidget(
        initialColor: initialColor,
        onColorChanged: (_) {},
      ),
    ),
  );
}

Widget _buildChatModuleWithTheme(ChatTheme theme) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ChatInterface(
        messages: [
          ChatMessage(
            message: 'Hello! How can I help you today?',
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
          ChatMessage(
            message: 'I need help with setting up a new agent.',
            isUser: true,
            timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
          ),
          ChatMessage(
            message: 'Sure, I can guide you through the process. What type of agent would you like to create?',
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          ),
          ChatMessage(
            message: 'I want to create a customer support agent.',
            isUser: true,
            timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
          ),
          ChatMessage(
            message: 'Great choice! A customer support agent can help automate responses and improve efficiency.',
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
          ),
        ],
        onSendMessage: (_) {},
        chatTheme: theme,
        isTestMode: true,
      ),
    ),
  );
}

Widget _buildChatModuleWithCustomTheme() {
  final customTheme = ChatTheme.day().copyWith(
    userMessageColor: const Color(0xFF9333EA), // Purple
    aiMessageColor: const Color(0xFFE5E5E5),
    userMessageTextColor: Colors.white,
    aiMessageTextColor: const Color(0xFF212529),
    nameColor: const Color(0xFF9333EA),
    dateTextColor: const Color(0xFF6C757D),
  );

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ChatInterface(
        messages: [
          ChatMessage(
            message: 'This is a custom themed chat!',
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
          ChatMessage(
            message: 'I can see the purple bubbles for my messages.',
            isUser: true,
            timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
          ),
          ChatMessage(
            message: 'Yes, the theme has been customized with purple accent colors.',
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          ),
        ],
        onSendMessage: (_) {},
        chatTheme: customTheme,
        isTestMode: true,
      ),
    ),
  );
}

Widget _buildChatModuleNoBubble() {
  final theme = ChatTheme.day().copyWith(bubbleMode: false);

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ChatInterface(
        messages: [
          ChatMessage(
            message: 'This chat has bubble mode disabled.',
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
          ChatMessage(
            message: 'The messages have square corners instead of rounded bubbles.',
            isUser: true,
            timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
          ),
          ChatMessage(
            message: 'This gives a more traditional chat appearance.',
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          ),
        ],
        onSendMessage: (_) {},
        chatTheme: theme,
        isTestMode: true,
      ),
    ),
  );
}

Widget _buildChatModuleLargeText() {
  final theme = ChatTheme.day().copyWith(textSize: 1.5);

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ChatInterface(
        messages: [
          ChatMessage(
            message: 'This chat has larger text size for better readability.',
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
          ChatMessage(
            message: 'The text is 1.5x the normal size.',
            isUser: true,
            timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
          ),
          ChatMessage(
            message: 'This is useful for accessibility and better visibility.',
            isUser: false,
            timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          ),
        ],
        onSendMessage: (_) {},
        chatTheme: theme,
        isTestMode: true,
      ),
    ),
  );
}

