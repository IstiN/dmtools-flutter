/// Enum representing different page loading states
enum PageLoadingState {
  /// Page is currently loading data
  loading,

  /// Page has loaded content successfully
  loaded,

  /// Page encountered an error while loading
  error,

  /// Page loaded successfully but has no content to display
  empty,
}

/// Extension methods for PageLoadingState
extension PageLoadingStateExtension on PageLoadingState {
  /// Returns true if the page is currently loading
  bool get isLoading => this == PageLoadingState.loading;

  /// Returns true if the page has loaded content
  bool get isLoaded => this == PageLoadingState.loaded;

  /// Returns true if the page is in error state
  bool get isError => this == PageLoadingState.error;

  /// Returns true if the page is in empty state
  bool get isEmpty => this == PageLoadingState.empty;

  /// Returns true if the page can display content (loaded or empty)
  bool get canShowContent => isLoaded || isEmpty;

  /// Returns true if the page needs loading indicator
  bool get needsLoadingIndicator => isLoading;
}
