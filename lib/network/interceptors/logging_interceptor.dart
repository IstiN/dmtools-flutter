import 'dart:async';
import 'dart:developer' as developer;
import 'package:chopper/chopper.dart';

/// Interceptor that logs HTTP requests and responses
class LoggingInterceptor implements Interceptor {
  const LoggingInterceptor();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;

    // Log request
    developer.log(
      '→ ${request.method} ${request.url}',
      name: 'API Request',
    );

    if (request.body != null) {
      developer.log(
        'Request Body: ${request.body}',
        name: 'API Request',
      );
    }

    final response = await chain.proceed(request);

    // Log response
    developer.log(
      '← ${response.statusCode} ${request.method} ${request.url}',
      name: 'API Response',
    );

    if (response.error != null) {
      developer.log(
        'Error: ${response.error}',
        name: 'API Response',
        error: response.error,
      );
    }

    return response;
  }
}
