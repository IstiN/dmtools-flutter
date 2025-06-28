import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/atoms/logos/logos.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('Logo Components Golden Tests', () {
    goldenTest(
      'WordmarkLogo - Light Mode',
      fileName: 'wordmark_logo_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'wordmark_logo_light',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildWordmarkLogo()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'WordmarkLogo - Dark Mode',
      fileName: 'wordmark_logo_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'wordmark_logo_dark',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildWordmarkLogo(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'IconLogo - Light Mode',
      fileName: 'icon_logo_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'icon_logo_light',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildIconLogo()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'IconLogo - Dark Mode',
      fileName: 'icon_logo_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'icon_logo_dark',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildIconLogo(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'NetworkNodesLogo - Light Mode',
      fileName: 'network_nodes_logo_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'network_nodes_logo_light',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildNetworkNodesLogo()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'NetworkNodesLogo - Dark Mode',
      fileName: 'network_nodes_logo_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'network_nodes_logo_dark',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildNetworkNodesLogo(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Combined Logo - Light Mode',
      fileName: 'combined_logo_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'combined_logo_light',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildCombinedLogo()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Combined Logo - Dark Mode',
      fileName: 'combined_logo_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'combined_logo_dark',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildCombinedLogo(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildWordmarkLogo() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: [
          Column(
            children: [
              WordmarkLogo(
                size: LogoSize.small,
                isTestMode: true,
              ),
              SizedBox(height: 8),
              Text(
                'Small',
              ),
            ],
          ),
          Column(
            children: [
              WordmarkLogo(
                isTestMode: true,
              ),
              SizedBox(height: 8),
              Text(
                'Medium',
              ),
            ],
          ),
          Column(
            children: [
              WordmarkLogo(
                size: LogoSize.large,
                isTestMode: true,
              ),
              SizedBox(height: 8),
              Text(
                'Large',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildIconLogo() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: [
          Column(
            children: [
              IconLogo(
                size: LogoSize.small,
                isTestMode: true,
              ),
              SizedBox(height: 8),
              Text(
                'Small',
              ),
            ],
          ),
          Column(
            children: [
              IconLogo(
                isTestMode: true,
              ),
              SizedBox(height: 8),
              Text(
                'Medium',
              ),
            ],
          ),
          Column(
            children: [
              IconLogo(
                size: LogoSize.large,
                isTestMode: true,
              ),
              SizedBox(height: 8),
              Text(
                'Large',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildNetworkNodesLogo() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: [
          Column(
            children: [
              NetworkNodesLogo(
                size: LogoSize.small,
                isTestMode: true,
              ),
              SizedBox(height: 8),
              Text(
                'Small',
              ),
            ],
          ),
          Column(
            children: [
              NetworkNodesLogo(
                isTestMode: true,
              ),
              SizedBox(height: 8),
              Text(
                'Medium',
              ),
            ],
          ),
          Column(
            children: [
              NetworkNodesLogo(
                size: LogoSize.large,
                isTestMode: true,
              ),
              SizedBox(height: 8),
              Text(
                'Large',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildCombinedLogo() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconLogo(
                size: LogoSize.small,
                isTestMode: true,
              ),
              WordmarkLogo(
                size: LogoSize.small,
                isTestMode: true,
              ),
              NetworkNodesLogo(
                size: LogoSize.small,
                isTestMode: true,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconLogo(
                isTestMode: true,
              ),
              WordmarkLogo(
                isTestMode: true,
              ),
              NetworkNodesLogo(
                isTestMode: true,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconLogo(
                size: LogoSize.large,
                isTestMode: true,
              ),
              WordmarkLogo(
                size: LogoSize.large,
                isTestMode: true,
              ),
              NetworkNodesLogo(
                size: LogoSize.large,
                isTestMode: true,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
