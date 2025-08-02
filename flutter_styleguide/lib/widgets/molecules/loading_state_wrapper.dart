import 'package:flutter/material.dart';
import '../../core/models/page_loading_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_dimensions.dart';
import '../molecules/empty_state.dart';
import '../atoms/texts/app_text.dart';

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
      case PageLoadingState.initial:
        return _InitialState();
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
            width: AppDimensions.iconSizeL,
            height: AppDimensions.iconSizeL,
            child: CircularProgressIndicator(
              strokeWidth: AppDimensions.loadingIndicatorStrokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(context.colors.accentColor),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          MediumBodyText(message, textAlign: TextAlign.center, color: context.colors.textSecondary),
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
        padding: const EdgeInsets.all(AppDimensions.spacingXs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: AppDimensions.iconSizeXl, color: context.colors.dangerColor),
            const SizedBox(height: AppDimensions.spacingXs),
            Flexible(
              child: MediumTitleText(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                color: context.colors.textColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXxs),
            Flexible(
              child: SmallBodyText(
                message,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                color: context.colors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spacingXs),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.accentColor,
                  foregroundColor: context.colors.bgColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: const Size(60, 28),
                ),
                child: const SmallLabelText('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Initial state widget - shows nothing until an action is triggered
class _InitialState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: AppDimensions.iconSizeXl + AppDimensions.spacingM,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          MediumBodyText('Click "Start Simulation" to begin', color: context.colors.textSecondary),
        ],
      ),
    );
  }
}
