import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Mixin that provides automatic loading state management for StatefulWidgets
///
/// Usage:
/// ```dart
/// class MyPage extends StatefulWidget {
///   @override
///   State<MyPage> createState() => _MyPageState();
/// }
///
/// class _MyPageState extends State<MyPage> with LoadingStateMixin<MyPage> {
///   @override
///   Widget build(BuildContext context) {
///     return buildWithLoadingState(
///       child: MyContent(),
///       loadingMessage: 'Loading data...',
///       emptyTitle: 'No data found',
///       emptyMessage: 'Try refreshing the page',
///       errorTitle: 'Failed to load data',
///     );
///   }
///
///   @override
///   Future<void> loadData() async {
///     // Your async loading logic here
///     final data = await myApiCall();
///
///     if (data.isEmpty) {
///       setEmpty();
///     } else {
///       setLoaded();
///     }
///   }
/// }
/// ```
mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  PageLoadingState _loadingState = PageLoadingState.loading;
  String? _errorMessage;
  bool _isLoadingData = false;

  /// Current loading state
  PageLoadingState get loadingState => _loadingState;

  /// Current error message if any
  String? get errorMessage => _errorMessage;

  /// Whether data is currently being loaded
  bool get isLoadingData => _isLoadingData;

  @override
  void initState() {
    super.initState();
    // Start loading data automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  /// Override this method to implement your data loading logic
  ///
  /// Call setLoaded(), setEmpty(), or setError() based on the results
  Future<void> loadData();

  /// Set the loading state to loading
  void setLoading() {
    if (!mounted) return;
    setState(() {
      _loadingState = PageLoadingState.loading;
      _errorMessage = null;
      _isLoadingData = true;
    });
  }

  /// Set the loading state to loaded (data available)
  void setLoaded() {
    if (!mounted) return;
    setState(() {
      _loadingState = PageLoadingState.loaded;
      _errorMessage = null;
      _isLoadingData = false;
    });
  }

  /// Set the loading state to empty (no data available)
  void setEmpty() {
    if (!mounted) return;
    setState(() {
      _loadingState = PageLoadingState.empty;
      _errorMessage = null;
      _isLoadingData = false;
    });
  }

  /// Set the loading state to error
  void setError(String message) {
    if (!mounted) return;
    setState(() {
      _loadingState = PageLoadingState.error;
      _errorMessage = message;
      _isLoadingData = false;
    });
  }

  /// Retry loading data
  Future<void> retry() async {
    if (_isLoadingData) return;

    setLoading();
    await loadData();
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
  }) async {
    if (_isLoadingData) return;

    setLoading();

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
  }) async {
    if (_isLoadingData) return null;

    setLoading();

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
      return null;
    }
  }

  /// Build widget with automatic loading state wrapper
  Widget buildWithLoadingState({
    required Widget child,
    String? loadingMessage,
    String? errorTitle,
    String? emptyTitle,
    String? emptyMessage,
    IconData? emptyIcon,
    VoidCallback? onEmptyAction,
  }) {
    return LoadingStateWrapper(
      state: _loadingState,
      loadingMessage: loadingMessage ?? 'Loading...',
      errorTitle: errorTitle ?? 'Error',
      errorMessage: _errorMessage,
      emptyTitle: emptyTitle ?? 'No data',
      emptyMessage: emptyMessage ?? 'No data available',
      emptyIcon: emptyIcon ?? Icons.inbox_outlined,
      onRetry: retry,
      onEmptyAction: onEmptyAction,
      child: child,
    );
  }
}
