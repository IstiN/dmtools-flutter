import 'package:flutter/material.dart';

/// Provider to manage demo mode state
class DemoModeProvider with ChangeNotifier {
  bool _isDemoMode = false;

  bool get isDemoMode => _isDemoMode;

  void enableDemoMode() {
    _isDemoMode = true;
    notifyListeners();
  }

  void disableDemoMode() {
    _isDemoMode = false;
    notifyListeners();
  }

  void toggleDemoMode() {
    _isDemoMode = !_isDemoMode;
    notifyListeners();
  }
}
