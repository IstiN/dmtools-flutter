import 'package:flutter/widgets.dart';
import '../models/page_loading_state.dart';

/// Mixin for managing page loading states consistently
mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  PageLoadingState _loadingState = PageLoadingState.loading;
  String? _errorMessage;

  /// Current loading state
  PageLoadingState get loadingState => _loadingState;

  /// Current error message
  String? get errorMessage => _errorMessage;

  /// Set the loading state to loading
  void setLoading() {
    if (mounted) {
      setState(() {
        _loadingState = PageLoadingState.loading;
        _errorMessage = null;
      });
    }
  }

  /// Set the loading state to loaded
  void setLoaded() {
    if (mounted) {
      setState(() {
        _loadingState = PageLoadingState.loaded;
        _errorMessage = null;
      });
    }
  }

  /// Set the loading state to empty
  void setEmpty() {
    if (mounted) {
      setState(() {
        _loadingState = PageLoadingState.empty;
        _errorMessage = null;
      });
    }
  }

  /// Set the loading state to error with optional message
  void setError([String? message]) {
    if (mounted) {
      setState(() {
        _loadingState = PageLoadingState.error;
        _errorMessage = message;
      });
    }
  }

  /// Handle async operations with automatic state management
  Future<void> handleAsyncOperation(
    Future<void> Function() operation, {
    bool setLoadingFirst = true,
    bool setLoadedOnSuccess = true,
    String? errorPrefix,
  }) async {
    if (setLoadingFirst) {
      setLoading();
    }

    try {
      await operation();
      if (setLoadedOnSuccess) {
        setLoaded();
      }
    } catch (e) {
      final message = errorPrefix != null ? '$errorPrefix: $e' : e.toString();
      setError(message);
    }
  }

  /// Handle async operations that return data with automatic state management
  Future<R?> handleAsyncDataOperation<R>(
    Future<R> Function() operation, {
    bool setLoadingFirst = true,
    bool checkEmpty = false,
    bool Function(R)? isEmptyCheck,
    String? errorPrefix,
  }) async {
    if (setLoadingFirst) {
      setLoading();
    }

    try {
      final result = await operation();

      if (checkEmpty && (isEmptyCheck?.call(result) ?? false)) {
        setEmpty();
      } else {
        setLoaded();
      }

      return result;
    } catch (e) {
      final message = errorPrefix != null ? '$errorPrefix: $e' : e.toString();
      setError(message);
      return null;
    }
  }
}
