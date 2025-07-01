import 'dart:async';
import 'package:chopper/chopper.dart';
import '../../providers/auth_provider.dart';

/// Interceptor that adds authentication headers to requests
class AuthInterceptor implements Interceptor {
  final AuthProvider authProvider;

  const AuthInterceptor(this.authProvider);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    // Get valid access token
    final accessToken = await authProvider.getAccessToken();

    if (accessToken != null) {
      final request = applyHeaders(
        chain.request,
        {'Authorization': 'Bearer $accessToken'},
      );
      return chain.proceed(request);
    } else {
      // No valid token, proceed without auth header
      // The API will return 401 if authentication is required
      return chain.proceed(chain.request);
    }
  }
}
