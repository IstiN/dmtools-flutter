import 'package:flutter/material.dart';

enum AuthProvider {
  google,
  microsoft,
  github,
  custom,
}

class AuthService with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _currentUser;
  String? _error;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get currentUser => _currentUser;
  String? get error => _error;

  /// Simulates a login process with the given provider
  Future<bool> login(AuthProvider provider) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful login
      _isLoggedIn = true;
      
      switch (provider) {
        case AuthProvider.google:
          _currentUser = 'Google User';
          break;
        case AuthProvider.microsoft:
          _currentUser = 'Microsoft User';
          break;
        case AuthProvider.github:
          _currentUser = 'GitHub User';
          break;
        case AuthProvider.custom:
          _currentUser = 'Custom OAuth User';
          break;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Simulates a logout process
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      _isLoggedIn = false;
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clears any error messages
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 