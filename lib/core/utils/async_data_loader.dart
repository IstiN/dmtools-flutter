import 'package:flutter/foundation.dart';

/// Utility class for handling async data loading operations with common patterns
class AsyncDataLoader {
  /// Execute multiple async operations in parallel and return combined results
  ///
  /// Usage:
  /// ```dart
  /// final results = await AsyncDataLoader.loadMultiple([
  ///   () => apiService.getUsers(),
  ///   () => apiService.getSettings(),
  ///   () => apiService.getNotifications(),
  /// ]);
  ///
  /// final users = results[0] as List<User>;
  /// final settings = results[1] as Settings;
  /// final notifications = results[2] as List<Notification>;
  /// ```
  static Future<List<dynamic>> loadMultiple(
    List<Future<dynamic> Function()> operations, {
    String? errorPrefix,
  }) async {
    try {
      final futures = operations.map((op) => op()).toList();
      return await Future.wait(futures);
    } catch (e) {
      final message = errorPrefix != null ? '$errorPrefix: $e' : e.toString();
      if (kDebugMode) {
        debugPrint('AsyncDataLoader.loadMultiple error: $message');
      }
      rethrow;
    }
  }

  /// Execute async operations in sequence (one after another)
  ///
  /// Usage:
  /// ```dart
  /// final results = await AsyncDataLoader.loadSequential([
  ///   () => authService.login(),
  ///   () => userService.getProfile(),
  ///   () => dataService.getUserData(),
  /// ]);
  /// ```
  static Future<List<dynamic>> loadSequential(
    List<Future<dynamic> Function()> operations, {
    String? errorPrefix,
  }) async {
    final results = <dynamic>[];

    try {
      for (final operation in operations) {
        final result = await operation();
        results.add(result);
      }
      return results;
    } catch (e) {
      final message = errorPrefix != null ? '$errorPrefix: $e' : e.toString();
      if (kDebugMode) {
        debugPrint('AsyncDataLoader.loadSequential error: $message');
      }
      rethrow;
    }
  }

  /// Execute an async operation with retry logic
  ///
  /// Usage:
  /// ```dart
  /// final data = await AsyncDataLoader.loadWithRetry(
  ///   () => apiService.getData(),
  ///   maxRetries: 3,
  ///   retryDelay: Duration(seconds: 2),
  /// );
  /// ```
  static Future<T> loadWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
    String? errorPrefix,
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;

        if (attempts >= maxRetries) {
          final message = errorPrefix != null ? '$errorPrefix: $e' : e.toString();
          if (kDebugMode) {
            debugPrint('AsyncDataLoader.loadWithRetry failed after $maxRetries attempts: $message');
          }
          rethrow;
        }

        if (kDebugMode) {
          debugPrint('AsyncDataLoader.loadWithRetry attempt $attempts failed, retrying in ${retryDelay.inSeconds}s: $e');
        }

        await Future.delayed(retryDelay);
      }
    }

    throw Exception('Should not reach here');
  }

  /// Execute an async operation with timeout
  ///
  /// Usage:
  /// ```dart
  /// final data = await AsyncDataLoader.loadWithTimeout(
  ///   () => apiService.getData(),
  ///   timeout: Duration(seconds: 30),
  /// );
  /// ```
  static Future<T> loadWithTimeout<T>(
    Future<T> Function() operation, {
    Duration timeout = const Duration(seconds: 30),
    String? errorPrefix,
  }) async {
    try {
      return await operation().timeout(timeout);
    } catch (e) {
      final message = errorPrefix != null ? '$errorPrefix: $e' : e.toString();
      if (kDebugMode) {
        debugPrint('AsyncDataLoader.loadWithTimeout error: $message');
      }
      rethrow;
    }
  }

  /// Execute an async operation with both retry and timeout
  ///
  /// Usage:
  /// ```dart
  /// final data = await AsyncDataLoader.loadWithRetryAndTimeout(
  ///   () => apiService.getData(),
  ///   maxRetries: 3,
  ///   retryDelay: Duration(seconds: 2),
  ///   timeout: Duration(seconds: 30),
  /// );
  /// ```
  static Future<T> loadWithRetryAndTimeout<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
    Duration timeout = const Duration(seconds: 30),
    String? errorPrefix,
  }) async {
    return loadWithRetry(
      () => loadWithTimeout(operation, timeout: timeout, errorPrefix: errorPrefix),
      maxRetries: maxRetries,
      retryDelay: retryDelay,
      errorPrefix: errorPrefix,
    );
  }

  /// Load data with progress callback
  ///
  /// Usage:
  /// ```dart
  /// final data = await AsyncDataLoader.loadWithProgress(
  ///   operations: [
  ///     () => apiService.getUsers(),
  ///     () => apiService.getSettings(),
  ///     () => apiService.getNotifications(),
  ///   ],
  ///   onProgress: (completed, total) {
  ///     debugPrint('Progress: $completed/$total');
  ///   },
  /// );
  /// ```
  static Future<List<dynamic>> loadWithProgress(
    List<Future<dynamic> Function()> operations, {
    void Function(int completed, int total)? onProgress,
    String? errorPrefix,
  }) async {
    final results = <dynamic>[];
    final total = operations.length;

    try {
      for (int i = 0; i < operations.length; i++) {
        final result = await operations[i]();
        results.add(result);

        onProgress?.call(i + 1, total);
      }

      return results;
    } catch (e) {
      final message = errorPrefix != null ? '$errorPrefix: $e' : e.toString();
      if (kDebugMode) {
        debugPrint('AsyncDataLoader.loadWithProgress error: $message');
      }
      rethrow;
    }
  }

  /// Cache results of async operations for a specified duration
  static final Map<String, _CacheEntry> _cache = {};

  /// Load data with caching
  ///
  /// Usage:
  /// ```dart
  /// final data = await AsyncDataLoader.loadWithCache(
  ///   key: 'user_data',
  ///   operation: () => apiService.getUserData(),
  ///   cacheDuration: Duration(minutes: 5),
  /// );
  /// ```
  static Future<T> loadWithCache<T>(
    String key,
    Future<T> Function() operation, {
    Duration cacheDuration = const Duration(minutes: 5),
    String? errorPrefix,
  }) async {
    final cacheEntry = _cache[key];

    // Check if we have valid cached data
    if (cacheEntry != null && !cacheEntry.isExpired) {
      if (kDebugMode) {
        debugPrint('AsyncDataLoader.loadWithCache: Using cached data for key: $key');
      }
      return cacheEntry.data as T;
    }

    try {
      if (kDebugMode) {
        debugPrint('AsyncDataLoader.loadWithCache: Loading fresh data for key: $key');
      }

      final result = await operation();

      // Cache the result
      _cache[key] = _CacheEntry(
        data: result,
        expiresAt: DateTime.now().add(cacheDuration),
      );

      return result;
    } catch (e) {
      final message = errorPrefix != null ? '$errorPrefix: $e' : e.toString();
      if (kDebugMode) {
        debugPrint('AsyncDataLoader.loadWithCache error for key $key: $message');
      }
      rethrow;
    }
  }

  /// Clear all cached data
  static void clearCache() {
    _cache.clear();
    if (kDebugMode) {
      debugPrint('AsyncDataLoader: Cache cleared');
    }
  }

  /// Clear specific cache entry
  static void clearCacheEntry(String key) {
    _cache.remove(key);
    if (kDebugMode) {
      debugPrint('AsyncDataLoader: Cache entry cleared for key: $key');
    }
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiresAt;

  _CacheEntry({required this.data, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
