import 'package:flutter/foundation.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Base provider class that handles loading states automatically
///
/// Usage:
/// ```dart
/// class MyDataProvider extends LoadingStateProvider {
///   List<MyData> _data = [];
///   List<MyData> get data => _data;
///
///   Future<void> loadMyData() async {
///     await executeWithLoadingState(() async {
///       _data = await myApiCall();
///       return _data.isNotEmpty;
///     });
///   }
/// }
/// ```
abstract class LoadingStateProvider extends ChangeNotifier {
  PageLoadingState _loadingState = PageLoadingState.loading;
  String? _errorMessage;
  bool _isLoadingData = false;

  /// Current loading state
  PageLoadingState get loadingState => _loadingState;

  /// Current error message if any
  String? get errorMessage => _errorMessage;

  /// Whether data is currently being loaded
  bool get isLoadingData => _isLoadingData;

  /// Set the loading state to loading
  void setLoading({bool notify = true}) {
    _loadingState = PageLoadingState.loading;
    _errorMessage = null;
    _isLoadingData = true;
    if (notify) notifyListeners();
  }

  /// Set the loading state to loaded (data available)
  void setLoaded({bool notify = true}) {
    _loadingState = PageLoadingState.loaded;
    _errorMessage = null;
    _isLoadingData = false;
    if (notify) notifyListeners();
  }

  /// Set the loading state to empty (no data available)
  void setEmpty({bool notify = true}) {
    _loadingState = PageLoadingState.empty;
    _errorMessage = null;
    _isLoadingData = false;
    if (notify) notifyListeners();
  }

  /// Set the loading state to error
  void setError(String message, {bool notify = true}) {
    _loadingState = PageLoadingState.error;
    _errorMessage = message;
    _isLoadingData = false;
    if (notify) notifyListeners();
  }

  /// Clear error state
  void clearError({bool notify = true}) {
    _errorMessage = null;
    if (notify) notifyListeners();
  }

  /// Execute an async operation with automatic state management
  ///
  /// Usage:
  /// ```dart
  /// await executeWithLoadingState(() async {
  ///   final data = await myApiCall();
  ///   return data.isNotEmpty; // Return true if data is available, false if empty
  /// });
  /// ```
  Future<void> executeWithLoadingState(
    Future<bool> Function() operation, {
    String? errorPrefix,
    bool setLoadingFirst = true,
  }) async {
    if (_isLoadingData && setLoadingFirst) return;

    if (setLoadingFirst) {
      setLoading();
    }

    try {
      final hasData = await operation();
      if (hasData) {
        setLoaded();
      } else {
        setEmpty();
      }
    } catch (e) {
      final message = errorPrefix != null ? '$errorPrefix: $e' : e.toString();
      setError(message);
      if (kDebugMode) {
        print('LoadingStateProvider: Error in executeWithLoadingState: $e');
      }
    }
  }

  /// Execute an async operation that returns data with automatic state management
  ///
  /// Usage:
  /// ```dart
  /// final data = await executeWithLoadingStateAndData(() async {
  ///   return await myApiCall();
  /// }, isEmptyCheck: (data) => data.isEmpty);
  /// ```
  Future<R?> executeWithLoadingStateAndData<R>(
    Future<R> Function() operation, {
    bool Function(R)? isEmptyCheck,
    String? errorPrefix,
    bool setLoadingFirst = true,
  }) async {
    if (_isLoadingData && setLoadingFirst) return null;

    if (setLoadingFirst) {
      setLoading();
    }

    try {
      final result = await operation();

      if (isEmptyCheck != null && isEmptyCheck(result)) {
        setEmpty();
      } else {
        setLoaded();
      }

      return result;
    } catch (e) {
      final message = errorPrefix != null ? '$errorPrefix: $e' : e.toString();
      setError(message);
      if (kDebugMode) {
        print('LoadingStateProvider: Error in executeWithLoadingStateAndData: $e');
      }
      return null;
    }
  }

  /// Refresh data with loading state management
  Future<void> refresh();

  /// Retry the last operation
  Future<void> retry() async {
    if (_isLoadingData) return;
    await refresh();
  }
}
