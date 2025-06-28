import 'dart:async';
import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(),
      ciGoldensConfig: CiGoldensConfig(),
    ),
    run: () async {
      // Setup fonts for testing
      await _setupFonts();
      await testMain();
    },
  );
}

Future<void> _setupFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Disable runtime font fetching for tests
  GoogleFonts.config.allowRuntimeFetching = false;

  // Use system fonts for testing to avoid asset loading issues
  // The visual tests will use fallback fonts which is acceptable for golden tests
}
