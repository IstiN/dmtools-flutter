import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('New Icon Proposals Golden Tests', () {
    goldenTest(
      'DNA Icon - Multiple Sizes - Light Mode',
      fileName: 'dna_icon_sizes_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'dna_icon_sizes_light',
            child: SizedBox(
              width: 800,
              height: 400,
              child: helper.createTestApp(_buildIconSizes('assets/img/dmtools-icon-dna.svg')),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'DNA Icon - Multiple Sizes - Dark Mode',
      fileName: 'dna_icon_sizes_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'dna_icon_sizes_dark',
            child: SizedBox(
              width: 800,
              height: 400,
              child: helper.createTestApp(_buildIconSizes('assets/img/dmtools-icon-dna.svg'), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'DNA Icon - Background Variations',
      fileName: 'dna_icon_backgrounds',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'dna_icon_backgrounds',
            child: SizedBox(
              width: 800,
              height: 400,
              child: helper.createTestApp(_buildIconBackgrounds('assets/img/dmtools-icon-dna.svg')),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'AI Icon - Multiple Sizes - Light Mode',
      fileName: 'ai_icon_sizes_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'ai_icon_sizes_light',
            child: SizedBox(
              width: 800,
              height: 400,
              child: helper.createTestApp(_buildIconSizes('assets/img/dmtools-icon-ai.svg')),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'AI Icon - Multiple Sizes - Dark Mode',
      fileName: 'ai_icon_sizes_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'ai_icon_sizes_dark',
            child: SizedBox(
              width: 800,
              height: 400,
              child: helper.createTestApp(_buildIconSizes('assets/img/dmtools-icon-ai.svg'), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'AI Icon - Background Variations',
      fileName: 'ai_icon_backgrounds',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'ai_icon_backgrounds',
            child: SizedBox(
              width: 800,
              height: 400,
              child: helper.createTestApp(_buildIconBackgrounds('assets/img/dmtools-icon-ai.svg')),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Both Icons Comparison - Light Mode',
      fileName: 'both_icons_comparison_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'both_icons_comparison_light',
            child: SizedBox(
              width: 800,
              height: 500,
              child: helper.createTestApp(_buildBothIconsComparison()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Both Icons Comparison - Dark Mode',
      fileName: 'both_icons_comparison_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'both_icons_comparison_dark',
            child: SizedBox(
              width: 800,
              height: 500,
              child: helper.createTestApp(_buildBothIconsComparison(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildIconSizes(String assetPath) {
  const sizes = [16.0, 32.0, 64.0, 128.0, 256.0];

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: sizes.map((size) {
          return Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    assetPath,
                    width: size,
                    height: size,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${size.toInt()}px',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          );
        }).toList(),
      ),
    ),
  );
}

Widget _buildIconBackgrounds(String assetPath) {
  const backgrounds = [
    _BackgroundConfig('White', Colors.white, Colors.black),
    _BackgroundConfig('Light Gray', Color(0xFFF5F5F5), Colors.black),
    _BackgroundConfig('Dark Gray', Color(0xFF424242), Colors.white),
    _BackgroundConfig('Black', Colors.black, Colors.white),
    _BackgroundConfig('Blue', Color(0xFF466AF1), Colors.white),
  ];

  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        children: backgrounds.map((bg) {
          return Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: bg.bgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.asset(
                    assetPath,
                    width: 64,
                    height: 64,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bg.label,
                style: TextStyle(fontSize: 12, color: bg.labelColor),
              ),
            ],
          );
        }).toList(),
      ),
    ),
  );
}

Widget _buildBothIconsComparison() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DNA Icon',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _IconPreviewCard(assetPath: 'assets/img/dmtools-icon-dna.svg', size: 64),
              SizedBox(width: 16),
              _IconPreviewCard(assetPath: 'assets/img/dmtools-icon-dna.svg', size: 128),
            ],
          ),
          SizedBox(height: 32),
          Text(
            'DM.ai Icon',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _IconPreviewCard(assetPath: 'assets/img/dmtools-icon-ai.svg', size: 64),
              SizedBox(width: 16),
              _IconPreviewCard(assetPath: 'assets/img/dmtools-icon-ai.svg', size: 128),
            ],
          ),
        ],
      ),
    ),
  );
}

class _IconPreviewCard extends StatelessWidget {
  final String assetPath;
  final double size;

  const _IconPreviewCard({
    required this.assetPath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SvgPicture.asset(
          assetPath,
          width: size,
          height: size,
        ),
      ),
    );
  }
}

class _BackgroundConfig {
  final String label;
  final Color bgColor;
  final Color labelColor;

  const _BackgroundConfig(this.label, this.bgColor, this.labelColor);
}

