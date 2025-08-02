import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../providers/loading_state_provider.dart';

/// A widget that automatically handles loading states with a provider
///
/// Usage:
/// ```dart
/// LoadingStateWidget<MyDataProvider>(
///   create: (context) => MyDataProvider(),
///   onLoad: (provider) => provider.loadMyData(),
///   loadingMessage: 'Loading my data...',
///   emptyTitle: 'No data found',
///   emptyMessage: 'Try refreshing the page',
///   errorTitle: 'Failed to load data',
///   builder: (context, provider) {
///     return ListView.builder(
///       itemCount: provider.data.length,
///       itemBuilder: (context, index) {
///         return ListTile(title: Text(provider.data[index].name));
///       },
///     );
///   },
/// )
/// ```
class LoadingStateWidget<T extends LoadingStateProvider> extends StatefulWidget {
  /// Creates the provider instance
  final T Function(BuildContext context) create;

  /// Called when the widget is first created to start loading data
  final Future<void> Function(T provider) onLoad;

  /// Builder function that builds the content when data is loaded
  final Widget Function(BuildContext context, T provider) builder;

  /// Loading message to display
  final String? loadingMessage;

  /// Error title to display
  final String? errorTitle;

  /// Empty state title
  final String? emptyTitle;

  /// Empty state message
  final String? emptyMessage;

  /// Empty state icon
  final IconData? emptyIcon;

  /// Action for empty state
  final VoidCallback? onEmptyAction;

  const LoadingStateWidget({
    required this.create,
    required this.onLoad,
    required this.builder,
    this.loadingMessage,
    this.errorTitle,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyIcon,
    this.onEmptyAction,
    super.key,
  });

  @override
  State<LoadingStateWidget<T>> createState() => _LoadingStateWidgetState<T>();
}

class _LoadingStateWidgetState<T extends LoadingStateProvider> extends State<LoadingStateWidget<T>> {
  late T _provider;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _provider = widget.create(context);

    // Start loading data after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      await widget.onLoad(_provider);
    } catch (e) {
      _provider.setError('Failed to load data: $e');
    }
  }

  Future<void> _retry() async {
    _isInitialized = false;
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: _provider,
      child: Consumer<T>(
        builder: (context, provider, child) {
          return LoadingStateWrapper(
            state: provider.loadingState,
            loadingMessage: widget.loadingMessage ?? 'Loading...',
            errorTitle: widget.errorTitle ?? 'Error',
            errorMessage: provider.errorMessage,
            emptyTitle: widget.emptyTitle ?? 'No data',
            emptyMessage: widget.emptyMessage ?? 'No data available',
            emptyIcon: widget.emptyIcon ?? Icons.inbox_outlined,
            onRetry: _retry,
            onEmptyAction: widget.onEmptyAction,
            child: widget.builder(context, provider),
          );
        },
      ),
    );
  }
}

/// A simplified widget for cases where you don't need a provider
///
/// Usage:
/// ```dart
/// SimpleLoadingStateWidget(
///   onLoad: () async {
///     final data = await myApiCall();
///     return data.isNotEmpty;
///   },
///   loadingMessage: 'Loading data...',
///   emptyTitle: 'No data found',
///   builder: (context, data) {
///     return MyContent(data: data);
///   },
/// )
/// ```
class SimpleLoadingStateWidget<T> extends StatefulWidget {
  /// Async function that loads data and returns whether data is available
  final Future<T?> Function() onLoad;

  /// Builder function that builds the content when data is loaded
  final Widget Function(BuildContext context, T? data) builder;

  /// Function to check if the loaded data is empty
  final bool Function(T data)? isEmptyCheck;

  /// Loading message to display
  final String? loadingMessage;

  /// Error title to display
  final String? errorTitle;

  /// Empty state title
  final String? emptyTitle;

  /// Empty state message
  final String? emptyMessage;

  /// Empty state icon
  final IconData? emptyIcon;

  /// Action for empty state
  final VoidCallback? onEmptyAction;

  const SimpleLoadingStateWidget({
    required this.onLoad,
    required this.builder,
    this.isEmptyCheck,
    this.loadingMessage,
    this.errorTitle,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyIcon,
    this.onEmptyAction,
    super.key,
  });

  @override
  State<SimpleLoadingStateWidget<T>> createState() => _SimpleLoadingStateWidgetState<T>();
}

class _SimpleLoadingStateWidgetState<T> extends State<SimpleLoadingStateWidget<T>> {
  PageLoadingState _loadingState = PageLoadingState.loading;
  String? _errorMessage;
  T? _data;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Start loading data after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (_isLoading) return;

    setState(() {
      _loadingState = PageLoadingState.loading;
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final result = await widget.onLoad();

      if (!mounted) return;

      if (result == null || (widget.isEmptyCheck != null && widget.isEmptyCheck!(result))) {
        setState(() {
          _loadingState = PageLoadingState.empty;
          _data = result;
          _isLoading = false;
        });
      } else {
        setState(() {
          _loadingState = PageLoadingState.loaded;
          _data = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingState = PageLoadingState.error;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingStateWrapper(
      state: _loadingState,
      loadingMessage: widget.loadingMessage ?? 'Loading...',
      errorTitle: widget.errorTitle ?? 'Error',
      errorMessage: _errorMessage,
      emptyTitle: widget.emptyTitle ?? 'No data',
      emptyMessage: widget.emptyMessage ?? 'No data available',
      emptyIcon: widget.emptyIcon ?? Icons.inbox_outlined,
      onRetry: _loadData,
      onEmptyAction: widget.onEmptyAction,
      child: widget.builder(context, _data),
    );
  }
}
