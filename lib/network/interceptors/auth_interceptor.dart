import 'dart:async';
import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import '../../core/interfaces/auth_token_provider.dart';

/// Interceptor that adds authentication headers to requests and handles auth failures
class AuthInterceptor implements Interceptor {
  final AuthTokenProvider authProvider;
  final Function()? onAuthenticationFailed;

  const AuthInterceptor(
    this.authProvider, {
    this.onAuthenticationFailed,
  });

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    // Get valid access token
    final accessToken = await authProvider.getAccessToken();

    Response<BodyType> response;

    if (accessToken != null) {
      if (kDebugMode) {
        debugPrint('🔑 AuthInterceptor: Adding Authorization header for ${chain.request.url}');
        debugPrint('🔑 AuthInterceptor: Token: ${accessToken.substring(0, 20)}...');
      }
      final request = applyHeaders(
        chain.request,
        {'Authorization': 'Bearer $accessToken'},
      );
      response = await chain.proceed(request);
    } else {
      if (kDebugMode) {
        debugPrint('❌ AuthInterceptor: No access token available for ${chain.request.url}');
      }
      // No valid token, proceed without auth header
      // The API will return 401 if authentication is required
      response = await chain.proceed(chain.request);
    }

    // Check response for authentication failures
    if (response.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('❌ AuthInterceptor: 401 Unauthorized response detected');
        debugPrint('   Triggering authentication failure callback');
      }
      onAuthenticationFailed?.call();
    } else if (response.statusCode == 200 && response.body != null) {
      // Check if response body contains authenticated: false
      try {
        dynamic bodyData;
        if (response.body is String) {
          bodyData = jsonDecode(response.body as String);
        } else if (response.body is Map) {
          bodyData = response.body;
        }

        if (bodyData is Map && bodyData.containsKey('authenticated')) {
          final authenticated = bodyData['authenticated'];
          if (authenticated == false) {
            if (kDebugMode) {
              debugPrint('❌ AuthInterceptor: Response indicates authenticated: false');
              debugPrint('   Triggering authentication failure callback');
            }
            onAuthenticationFailed?.call();
          }
        }
      } catch (e) {
        // Ignore parsing errors - not all responses will be JSON maps
        if (kDebugMode) {
          debugPrint('⚠️ AuthInterceptor: Could not parse response body for auth check: $e');
        }
      }
    }

    return response;
  }
}
