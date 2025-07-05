import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/atoms/loading_indicators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../golden_test_helper.dart' as helper;

void main() {
  group('Loading Indicators Golden Tests', () {
    goldenTest(
      'All Indicators - Light Mode',
      fileName: 'loading_indicators_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'loading_indicators_light',
            child: SizedBox(
              width: 300,
              height: 500,
              child: helper.createTestApp(_buildIndicators()),
            ),
          ),
        ],
      ),
      pumpBeforeTest: (tester) async {
        await tester.pump(const Duration(milliseconds: 500));
      },
    );

    goldenTest(
      'All Indicators - Dark Mode',
      fileName: 'loading_indicators_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'loading_indicators_dark',
            child: SizedBox(
              width: 300,
              height: 500,
              child: helper.createTestApp(_buildIndicators(), darkMode: true),
            ),
          ),
        ],
      ),
      pumpBeforeTest: (tester) async {
        await tester.pump(const Duration(milliseconds: 500));
      },
    );
  });
}

Widget _buildIndicators() {
  return const RepaintBoundary(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PulsingDotIndicator(),
        BouncingDotsIndicator(),
        RotatingSegmentsIndicator(),
        InfinityDotsIndicator(),
        ChromosomeIndicator(),
        DnaIndicator(),
        FadingGridIndicator(),
      ],
    ),
  );
}
