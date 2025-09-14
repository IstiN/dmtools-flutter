import 'package:flutter/foundation.dart';
import '../models/user.dart';

/// Interface for providing authentication tokens with change notification
abstract class AuthTokenProvider extends ChangeNotifier {
  /// Get a valid access token for API calls
  Future<String?> getAccessToken();

  /// Check if the provider is currently authenticated
  bool get isAuthenticated;

  /// Check if the provider should use mock data
  bool get shouldUseMockData;

  /// Check if the provider is in demo mode
  bool get isDemoMode;

  /// Get the current user information
  UserDto? get currentUser;
}
