import 'package:flutter/material.dart';
import '../../core/models/page_loading_state.dart';
import '../../theme/app_theme.dart';
import '../molecules/empty_state.dart';

/// A wrapper widget that handles different page loading states using existing styleguide components
class LoadingStateWrapper extends StatelessWidget {
  /// Creates a loading state wrapper
  const LoadingStateWrapper({
    required this.state,
    required this.child,
    this.loadingMessage = 'Loading...',
    this.errorTitle = 'Error',
    this.errorMessage,
    this.emptyTitle = 'No data found',
    this.emptyMessage = 'There is nothing to display',
    this.emptyIcon = Icons.inbox_outlined,
    this.onRetry,
    this.onEmptyAction,
    this.emptyActionText,
    super.key,
  });

  /// The current loading state
  final PageLoadingState state;

  /// The content to show when state is loaded
  final Widget child;

  /// Message to show during loading
  final String loadingMessage;

  /// Title for error state
  final String errorTitle;

  /// Message for error state
  final String? errorMessage;

  /// Title for empty state
  final String emptyTitle;

  /// Message for empty state
  final String emptyMessage;

  /// Icon for empty state
  final IconData emptyIcon;

  /// Callback for retry action in error state
  final VoidCallback? onRetry;

  /// Callback for action in empty state
  final VoidCallback? onEmptyAction;

  /// Text for empty state action button
  final String? emptyActionText;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case PageLoadingState.loading:
        return _LoadingIndicator(message: loadingMessage);
      case PageLoadingState.error:
        return _ErrorState(title: errorTitle, message: errorMessage ?? 'An error occurred', onRetry: onRetry);
      case PageLoadingState.empty:
        return EmptyState(icon: emptyIcon, title: emptyTitle, message: emptyMessage, onPressed: onEmptyAction);
      case PageLoadingState.loaded:
        return child;
    }
  }
}

/// Internal loading indicator using existing patterns
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(context.colors.accentColor),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: context.colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Internal error state using existing patterns
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.title, required this.message, this.onRetry});

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.colors.dangerColor),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: context.colors.textColor),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textColor.withValues(alpha: 0.7)),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.accentColor,
                  foregroundColor: context.colors.bgColor,
                ),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
