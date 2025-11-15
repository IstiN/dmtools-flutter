import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef BuildMeasureCallback = Widget Function();

Widget measureBuild(String name, BuildMeasureCallback builder) {
  if (!kIsWeb || !kDebugMode) {
    return builder();
  }

  final sw = Stopwatch()..start();
  final widget = builder();
  sw.stop();

  final ms = sw.elapsedMicroseconds / 1000;
  dev.log('[BuildPerf] $name ${ms.toStringAsFixed(2)}ms');
  return widget;
}

