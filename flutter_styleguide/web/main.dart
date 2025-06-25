import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/main.dart' as app;

void main() {
  setUrlStrategy(PathUrlStrategy());
  app.main();
} 