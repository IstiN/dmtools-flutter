import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// import 'package:flutter/material.dart'; // Unused
import 'package:dmtools_styleguide/main.dart' as app;

void main() {
  // Use hash-based URLs for styleguide (easier for local dev and static hosting)
  setUrlStrategy(const HashUrlStrategy());
  app.main();
} 