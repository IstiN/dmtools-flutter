import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:dmtools_styleguide/widgets/atoms/logos/logos.dart';
import '../golden_test_helper.dart';

void main() {
  GoldenToolkit.runWithConfiguration(
    config: GoldenToolkitConfiguration(
      enableRealShadows: true,
    ),
    () {
      group('Logo Components Golden Tests', () {
    testGoldens('WordmarkLogo - Light Mode', (tester) async {
      final builder = GoldenTestHelper.createDeviceBuilder(
        widgets: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  const WordmarkLogo(
                    size: LogoSize.small,
                    isTestMode: true,
                    isDarkMode: false,
                  ),
                  const SizedBox(height: 8),
                  const Text('Small'),
                ],
              ),
              Column(
                children: [
                  const WordmarkLogo(
                    size: LogoSize.medium,
                    isTestMode: true,
                    isDarkMode: false,
                  ),
                  const SizedBox(height: 8),
                  const Text('Medium'),
                ],
              ),
              Column(
                children: [
                  const WordmarkLogo(
                    size: LogoSize.large,
                    isTestMode: true,
                    isDarkMode: false,
                  ),
                  const SizedBox(height: 8),
                  const Text('Large'),
                ],
              ),
            ],
          ),
        ],
        name: 'wordmark_logo_light',
        isDarkMode: false,
      );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'wordmark_logo_light');
    });

    testGoldens('WordmarkLogo - Dark Mode', (tester) async {
      final builder = GoldenTestHelper.createDeviceBuilder(
        widgets: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  const WordmarkLogo(
                    size: LogoSize.small,
                    isTestMode: true,
                    isDarkMode: true,
                  ),
                  const SizedBox(height: 8),
                  const Text('Small', style: TextStyle(color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  const WordmarkLogo(
                    size: LogoSize.medium,
                    isTestMode: true,
                    isDarkMode: true,
                  ),
                  const SizedBox(height: 8),
                  const Text('Medium', style: TextStyle(color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  const WordmarkLogo(
                    size: LogoSize.large,
                    isTestMode: true,
                    isDarkMode: true,
                  ),
                  const SizedBox(height: 8),
                  const Text('Large', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
        name: 'wordmark_logo_dark',
        isDarkMode: true,
      );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'wordmark_logo_dark');
    });

    testGoldens('IconLogo - Light Mode', (tester) async {
      final builder = GoldenTestHelper.createDeviceBuilder(
        widgets: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  const IconLogo(
                    size: LogoSize.small,
                    isTestMode: true,
                    isDarkMode: false,
                  ),
                  const SizedBox(height: 8),
                  const Text('Small'),
                ],
              ),
              Column(
                children: [
                  const IconLogo(
                    size: LogoSize.medium,
                    isTestMode: true,
                    isDarkMode: false,
                  ),
                  const SizedBox(height: 8),
                  const Text('Medium'),
                ],
              ),
              Column(
                children: [
                  const IconLogo(
                    size: LogoSize.large,
                    isTestMode: true,
                    isDarkMode: false,
                  ),
                  const SizedBox(height: 8),
                  const Text('Large'),
                ],
              ),
            ],
          ),
        ],
        name: 'icon_logo_light',
        isDarkMode: false,
      );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'icon_logo_light');
    });

    testGoldens('IconLogo - Dark Mode', (tester) async {
      final builder = GoldenTestHelper.createDeviceBuilder(
        widgets: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  const IconLogo(
                    size: LogoSize.small,
                    isTestMode: true,
                    isDarkMode: true,
                  ),
                  const SizedBox(height: 8),
                  const Text('Small', style: TextStyle(color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  const IconLogo(
                    size: LogoSize.medium,
                    isTestMode: true,
                    isDarkMode: true,
                  ),
                  const SizedBox(height: 8),
                  const Text('Medium', style: TextStyle(color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  const IconLogo(
                    size: LogoSize.large,
                    isTestMode: true,
                    isDarkMode: true,
                  ),
                  const SizedBox(height: 8),
                  const Text('Large', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
        name: 'icon_logo_dark',
        isDarkMode: true,
      );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'icon_logo_dark');
    });

    testGoldens('NetworkNodesLogo - Light Mode', (tester) async {
      final builder = GoldenTestHelper.createDeviceBuilder(
        widgets: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  const NetworkNodesLogo(
                    size: LogoSize.small,
                    isTestMode: true,
                    isDarkMode: false,
                  ),
                  const SizedBox(height: 8),
                  const Text('Small'),
                ],
              ),
              Column(
                children: [
                  const NetworkNodesLogo(
                    size: LogoSize.medium,
                    isTestMode: true,
                    isDarkMode: false,
                  ),
                  const SizedBox(height: 8),
                  const Text('Medium'),
                ],
              ),
            ],
          ),
        ],
        name: 'network_nodes_logo_light',
        isDarkMode: false,
      );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'network_nodes_logo_light');
    });

    testGoldens('NetworkNodesLogo - Dark Mode', (tester) async {
      final builder = GoldenTestHelper.createDeviceBuilder(
        widgets: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  const NetworkNodesLogo(
                    size: LogoSize.small,
                    isTestMode: true,
                    isDarkMode: true,
                  ),
                  const SizedBox(height: 8),
                  const Text('Small', style: TextStyle(color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  const NetworkNodesLogo(
                    size: LogoSize.medium,
                    isTestMode: true,
                    isDarkMode: true,
                  ),
                  const SizedBox(height: 8),
                  const Text('Medium', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
        name: 'network_nodes_logo_dark',
        isDarkMode: true,
      );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'network_nodes_logo_dark');
    });

    testGoldens('Combined Logo - Light Mode', (tester) async {
      final builder = GoldenTestHelper.createDeviceBuilder(
        widgets: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      IconLogo(
                        size: LogoSize.small,
                        isTestMode: true,
                        isDarkMode: false,
                      ),
                      SizedBox(width: 8),
                      WordmarkLogo(
                        size: LogoSize.small,
                        isTestMode: true,
                        isDarkMode: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Small'),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      IconLogo(
                        size: LogoSize.medium,
                        isTestMode: true,
                        isDarkMode: false,
                      ),
                      SizedBox(width: 8),
                      WordmarkLogo(
                        size: LogoSize.medium,
                        isTestMode: true,
                        isDarkMode: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Medium'),
                ],
              ),
            ],
          ),
        ],
        name: 'combined_logo_light',
        isDarkMode: false,
      );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'combined_logo_light');
    });

    testGoldens('Combined Logo - Dark Mode', (tester) async {
      final builder = GoldenTestHelper.createDeviceBuilder(
        widgets: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      IconLogo(
                        size: LogoSize.small,
                        isTestMode: true,
                        isDarkMode: true,
                      ),
                      SizedBox(width: 8),
                      WordmarkLogo(
                        size: LogoSize.small,
                        isTestMode: true,
                        isDarkMode: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Small', style: TextStyle(color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      IconLogo(
                        size: LogoSize.medium,
                        isTestMode: true,
                        isDarkMode: true,
                      ),
                      SizedBox(width: 8),
                      WordmarkLogo(
                        size: LogoSize.medium,
                        isTestMode: true,
                        isDarkMode: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Medium', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
        name: 'combined_logo_dark',
        isDarkMode: true,
      );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'combined_logo_dark');
    });
  });
    },
  );
} 