import 'package:flutter/material.dart';
import '../../core/models/page_loading_state.dart';
import '../../widgets/molecules/loading_state_wrapper.dart';
import '../../widgets/styleguide/component_section.dart';
import '../../theme/app_theme.dart';

/// Demo page showcasing loading state components
class LoadingStatesPage extends StatefulWidget {
  const LoadingStatesPage({super.key});

  @override
  State<LoadingStatesPage> createState() => _LoadingStatesPageState();
}

class _LoadingStatesPageState extends State<LoadingStatesPage> {
  PageLoadingState _selectedState = PageLoadingState.loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading States'), backgroundColor: context.colors.bgColor, elevation: 0),
      backgroundColor: context.colors.bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ComponentSection(
              title: 'Interactive Demo',
              description: 'Select a state to see how LoadingStateWrapper handles it',
              child: Column(
                children: [
                  _StateSelector(
                    selectedState: _selectedState,
                    onStateChanged: (state) => setState(() => _selectedState = state),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 300,
                    child: LoadingStateWrapper(
                      state: _selectedState,
                      loadingMessage: 'Loading demo content...',
                      errorTitle: 'Demo Error',
                      errorMessage: 'This is a simulated error for demonstration purposes.',
                      emptyTitle: 'No Demo Data',
                      emptyMessage: 'This is how an empty state looks when there is no content to display.',
                      onRetry: () => setState(() => _selectedState = PageLoadingState.loading),
                      onEmptyAction: () => setState(() => _selectedState = PageLoadingState.loaded),
                      emptyActionText: 'Load Content',
                      child: const _DemoContent(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ComponentSection(
              title: 'Usage Example',
              description: 'How to use LoadingStateWrapper in your components',
              child: _UsageExample(),
            ),
            const SizedBox(height: 32),
            ComponentSection(
              title: 'Individual States',
              description: 'Examples of each loading state',
              child: _IndividualStatesDemo(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateSelector extends StatelessWidget {
  const _StateSelector({required this.selectedState, required this.onStateChanged});

  final PageLoadingState selectedState;
  final ValueChanged<PageLoadingState> onStateChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: PageLoadingState.values.map((state) {
        final isSelected = state == selectedState;
        return ChoiceChip(
          label: Text(_getStateLabel(state)),
          selected: isSelected,
          onSelected: (_) => onStateChanged(state),
          selectedColor: context.colors.accentColor.withValues(alpha: 0.2),
          backgroundColor: context.colors.cardBg,
          labelStyle: TextStyle(
            color: isSelected ? context.colors.accentColor : context.colors.textColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  String _getStateLabel(PageLoadingState state) {
    switch (state) {
      case PageLoadingState.loading:
        return 'Loading';
      case PageLoadingState.loaded:
        return 'Loaded';
      case PageLoadingState.error:
        return 'Error';
      case PageLoadingState.empty:
        return 'Empty';
    }
  }
}

class _DemoContent extends StatelessWidget {
  const _DemoContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 48, color: context.colors.successColor),
          const SizedBox(height: 16),
          Text(
            'Content Loaded Successfully!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: context.colors.textColor),
          ),
          const SizedBox(height: 8),
          Text(
            'This is the content that appears when the loading state is "loaded".',
            style: TextStyle(color: context.colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _UsageExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.borderColor),
      ),
      child: const Text('''
// Basic usage with LoadingStateMixin
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with LoadingStateMixin {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await handleAsyncOperation(() async {
      // Your async operation here
      await Future.delayed(Duration(seconds: 2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingStateWrapper(
      state: loadingState,
      loadingMessage: 'Loading data...',
      errorMessage: errorMessage,
      onRetry: _loadData,
      child: YourContent(),
    );
  }
}''', style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
    );
  }
}

class _IndividualStatesDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _StatePreview(
          title: 'Loading State',
          description: 'Shows a spinner with customizable message',
          child: SizedBox(
            height: 120,
            child: LoadingStateWrapper(
              state: PageLoadingState.loading,
              loadingMessage: 'Loading your data...',
              child: SizedBox(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _StatePreview(
          title: 'Error State',
          description: 'Shows error message with optional retry button',
          child: SizedBox(
            height: 200,
            child: LoadingStateWrapper(
              state: PageLoadingState.error,
              errorTitle: 'Failed to Load',
              errorMessage: 'Unable to connect to the server. Please check your connection.',
              onRetry: () {},
              child: const SizedBox(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _StatePreview(
          title: 'Empty State',
          description: 'Uses the existing EmptyState component with interactive features',
          child: SizedBox(
            height: 200,
            child: LoadingStateWrapper(
              state: PageLoadingState.empty,
              emptyTitle: 'No Items Found',
              emptyMessage: 'Create your first item to get started',
              emptyIcon: Icons.add_circle_outline,
              onEmptyAction: () {},
              emptyActionText: 'Create Item',
              child: const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatePreview extends StatelessWidget {
  const _StatePreview({required this.title, required this.description, required this.child});

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.colors.textColor),
          ),
          const SizedBox(height: 4),
          Text(description, style: TextStyle(fontSize: 14, color: context.colors.textSecondary)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
