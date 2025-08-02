import 'package:flutter/material.dart';
import '../../core/models/page_loading_state.dart';
import '../../widgets/molecules/loading_state_wrapper.dart';
import '../../widgets/styleguide/component_section.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/atoms/texts/app_text.dart';

/// Demo page showcasing loading state components
class LoadingStatesPage extends StatefulWidget {
  const LoadingStatesPage({super.key});

  @override
  State<LoadingStatesPage> createState() => _LoadingStatesPageState();
}

class _LoadingStatesPageState extends State<LoadingStatesPage> {
  PageLoadingState _selectedState = PageLoadingState.initial;
  String _selectedSimulation = 'success';
  bool _isSimulationRunning = false;

  Future<void> _startSimulation() async {
    if (_isSimulationRunning) return;

    setState(() {
      _isSimulationRunning = true;
      _selectedState = PageLoadingState.loading;
    });

    // Simulate loading time (2-3 seconds)
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    setState(() {
      _isSimulationRunning = false;
      switch (_selectedSimulation) {
        case 'success':
          _selectedState = PageLoadingState.loaded;
          break;
        case 'error':
          _selectedState = PageLoadingState.error;
          break;
        case 'empty':
          _selectedState = PageLoadingState.empty;
          break;
      }
    });
  }

  void _startSimulationWithType(String type) {
    setState(() {
      _selectedSimulation = type;
    });
    _startSimulation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading States'), backgroundColor: context.colors.bgColor, elevation: 0),
      backgroundColor: context.colors.bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ComponentSection(
              title: 'Realistic Loading Simulation',
              description: 'Choose a result type and simulate a real loading operation',
              child: Column(
                children: [
                  _SimulationControls(
                    selectedSimulation: _selectedSimulation,
                    onSimulationChanged: (simulation) => setState(() => _selectedSimulation = simulation),
                    onStartSimulation: _startSimulation,
                    isRunning: _isSimulationRunning,
                  ),
                  const SizedBox(height: AppDimensions.spacingL),
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: context.colors.borderColor),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: LoadingStateWrapper(
                      state: _selectedState,
                      loadingMessage: 'Simulating data loading operation...',
                      errorTitle: 'Simulation Failed',
                      errorMessage:
                          'The simulated operation encountered an error. This demonstrates how error states are handled.',
                      emptyTitle: 'No Data Available',
                      emptyMessage: 'The simulation returned no data. This shows how empty states are displayed.',
                      emptyIcon: Icons.search_off,
                      onRetry: _startSimulation,
                      onEmptyAction: () => _startSimulationWithType('success'),
                      emptyActionText: 'Load Sample Data',
                      child: const _DemoContent(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            ComponentSection(
              title: 'Usage Example',
              description: 'How to use LoadingStateWrapper in your components',
              child: _UsageExample(),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
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

class _SimulationControls extends StatelessWidget {
  const _SimulationControls({
    required this.selectedSimulation,
    required this.onSimulationChanged,
    required this.onStartSimulation,
    required this.isRunning,
  });

  final String selectedSimulation;
  final ValueChanged<String> onSimulationChanged;
  final VoidCallback onStartSimulation;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumTitleText('Choose simulation result:', color: context.colors.textColor),
        const SizedBox(height: AppDimensions.spacingS),
        Wrap(
          spacing: AppDimensions.spacingXs,
          children: [
            _SimulationChip(
              label: 'Success (Data)',
              value: 'success',
              isSelected: selectedSimulation == 'success',
              onSelected: !isRunning ? () => onSimulationChanged('success') : null,
              color: context.colors.successColor,
            ),
            _SimulationChip(
              label: 'Error',
              value: 'error',
              isSelected: selectedSimulation == 'error',
              onSelected: !isRunning ? () => onSimulationChanged('error') : null,
              color: context.colors.dangerColor,
            ),
            _SimulationChip(
              label: 'Empty',
              value: 'empty',
              isSelected: selectedSimulation == 'empty',
              onSelected: !isRunning ? () => onSimulationChanged('empty') : null,
              color: context.colors.warningColor,
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingM),
        ElevatedButton.icon(
          onPressed: isRunning ? null : onStartSimulation,
          icon: isRunning
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(context.colors.bgColor),
                  ),
                )
              : const Icon(Icons.play_arrow),
          label: Text(isRunning ? 'Simulating...' : 'Start Simulation'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.accentColor,
            foregroundColor: context.colors.bgColor,
            padding: AppDimensions.buttonPadding[ButtonSize.medium]!,
          ),
        ),
      ],
    );
  }
}

class _SimulationChip extends StatelessWidget {
  const _SimulationChip({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onSelected,
    required this.color,
  });

  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback? onSelected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected != null ? (_) => onSelected!() : null,
      selectedColor: color.withValues(alpha: 0.2),
      backgroundColor: context.colors.cardBg,
      labelStyle: TextStyle(
        color: isSelected ? color : context.colors.textColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(color: isSelected ? color : context.colors.borderColor, width: isSelected ? 2 : 1),
    );
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
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: context.colors.borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: AppDimensions.iconSizeXl + AppDimensions.spacingM,
            color: context.colors.successColor,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          LargeTitleText('Content Loaded Successfully!', color: context.colors.textColor),
          const SizedBox(height: AppDimensions.spacingXs),
          MediumBodyText(
            'This is the content that appears when the loading state is "loaded".',
            color: context.colors.textSecondary,
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
      padding: AppDimensions.cardPaddingM,
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
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
        _StatePreview(
          title: 'Loading State',
          description: 'Shows a spinner with customizable message',
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: context.colors.borderColor.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: const LoadingStateWrapper(
              state: PageLoadingState.loading,
              loadingMessage: 'Loading your data...',
              child: SizedBox(),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _StatePreview(
          title: 'Error State',
          description: 'Shows error message with optional retry button',
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: context.colors.borderColor.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: LoadingStateWrapper(
              state: PageLoadingState.error,
              errorTitle: 'Failed to Load',
              errorMessage: 'Unable to connect to server.',
              onRetry: () {},
              child: const SizedBox(),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _StatePreview(
          title: 'Empty State',
          description: 'Uses the existing EmptyState component with interactive features',
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: context.colors.borderColor.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
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
      padding: AppDimensions.cardPaddingM,
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: context.colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediumTitleText(title, color: context.colors.textColor),
          const SizedBox(height: AppDimensions.spacingXxs),
          SmallBodyText(description, color: context.colors.textSecondary),
          const SizedBox(height: AppDimensions.spacingM),
          child,
        ],
      ),
    );
  }
}
