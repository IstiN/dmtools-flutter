import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/molecules/agent_card.dart';
import 'package:dmtools_styleguide/widgets/molecules/empty_state.dart';
import 'package:dmtools_styleguide/widgets/molecules/user_profile_button.dart';
import 'package:dmtools_styleguide/widgets/atoms/status_dot.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('Molecules Golden Tests', () {
    goldenTest(
      'Agent Card - Light Mode',
      fileName: 'agent_card_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'agent_card_light',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildAgentCard()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Agent Card - Dark Mode',
      fileName: 'agent_card_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'agent_card_dark',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildAgentCard(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Empty State - Light Mode',
      fileName: 'empty_state_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'empty_state_light',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildEmptyState()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Empty State - Dark Mode',
      fileName: 'empty_state_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'empty_state_dark',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildEmptyState(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'User Profile Button - Light Mode',
      fileName: 'user_profile_button_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'user_profile_button_light',
            child: SizedBox(
              width: 400,
              height: 200,
              child: helper.createTestApp(_buildUserProfileButton()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'User Profile Button - Dark Mode',
      fileName: 'user_profile_button_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'user_profile_button_dark',
            child: SizedBox(
              width: 400,
              height: 200,
              child: helper.createTestApp(_buildUserProfileButton(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildAgentCard() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: AgentCard(
        title: 'Sample Agent',
        description: 'This is a sample agent description that demonstrates the card layout.',
        status: StatusType.online,
        statusLabel: 'Active',
        tags: const ['AI', 'Productivity', 'Automation'],
        runCount: 42,
        lastRunTime: '2 hours ago',
        onRun: () {},
        isTestMode: true,
      ),
    ),
  );
}

Widget _buildEmptyState() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: EmptyState(
        icon: Icons.add,
        title: 'Create New Item',
        message: 'Get started by creating your first item',
        onPressed: () {},
      ),
    ),
  );
}

Widget _buildUserProfileButton() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: UserProfileButton(
          userName: 'John Doe',
          onPressed: () {},
          isTestMode: true,
        ),
      ),
    ),
  );
}
