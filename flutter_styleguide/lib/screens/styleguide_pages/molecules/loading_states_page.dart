import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class LoadingStatesPage extends StatefulWidget {
  const LoadingStatesPage({super.key});

  @override
  State<LoadingStatesPage> createState() => _LoadingStatesPageState();
}

class _LoadingStatesPageState extends State<LoadingStatesPage> {
  bool _isLoading = false;
  bool _hasError = false;
  bool _isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Loading & States'), backgroundColor: colors.cardBg),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          const ComponentDisplay(
            title: 'Loading & States',
            description: 'Loading indicators, empty states, error states, and progress components.',
            child: SizedBox.shrink(),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Demo Controls
          Wrap(
            spacing: AppDimensions.spacingS,
            runSpacing: AppDimensions.spacingS,
            children: [
              SecondaryButton(
                text: _isLoading ? 'Stop Loading' : 'Show Loading',
                onPressed: () => setState(() => _isLoading = !_isLoading),
                size: ButtonSize.small,
              ),
              SecondaryButton(
                text: _hasError ? 'Clear Error' : 'Show Error',
                onPressed: () => setState(() => _hasError = !_hasError),
                size: ButtonSize.small,
              ),
              SecondaryButton(
                text: _isEmpty ? 'Show Data' : 'Show Empty',
                onPressed: () => setState(() => _isEmpty = !_isEmpty),
                size: ButtonSize.small,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Loading Indicators Section
          _buildSection(
            context,
            'Loading Indicators',
            'Various loading and progress indicators',
            _buildLoadingIndicatorsExample(context),
          ),

          // Empty States Section
          _buildSection(
            context,
            'Empty States',
            'Empty state components for when no data is available',
            _buildEmptyStatesExample(context),
          ),

          // Error States Section
          _buildSection(
            context,
            'Error States',
            'Error handling and retry mechanisms',
            _buildErrorStatesExample(context),
          ),

          // Progress Indicators Section
          _buildSection(
            context,
            'Progress Indicators',
            'Step-by-step progress and completion indicators',
            _buildProgressIndicatorsExample(context),
          ),

          // Interactive Demo Section
          _buildSection(
            context,
            'Interactive Demo',
            'Interactive demo showing different states',
            _buildInteractiveDemoExample(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description, Widget example) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: AppDimensions.spacingS),
        Text(description, style: TextStyle(fontSize: 14, color: context.colors.textColor.withValues(alpha: 0.8))),
        const SizedBox(height: AppDimensions.spacingM),
        example,
        const SizedBox(height: AppDimensions.spacingL),
      ],
    );
  }

  Widget _buildLoadingIndicatorsExample(BuildContext context) {
    final colors = context.colors;

    return Wrap(
      spacing: AppDimensions.spacingL,
      runSpacing: AppDimensions.spacingL,
      children: [
        // Circular loader
        Column(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(colors.accentColor),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text('Circular', style: TextStyle(color: colors.textColor, fontSize: 12)),
          ],
        ),
        // Linear loader
        Column(
          children: [
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colors.accentColor),
                backgroundColor: colors.borderColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text('Linear', style: TextStyle(color: colors.textColor, fontSize: 12)),
          ],
        ),
        // Dots loader
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.accentColor.withValues(alpha: 0.3 + (index * 0.3)),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text('Dots', style: TextStyle(color: colors.textColor, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyStatesExample(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 48, color: colors.textColor.withValues(alpha: 0.4)),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'No data available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Get started by adding your first item',
            style: TextStyle(fontSize: 14, color: colors.textColor.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          PrimaryButton(text: 'Add Item', onPressed: () {}, size: ButtonSize.small),
        ],
      ),
    );
  }

  Widget _buildErrorStatesExample(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: colors.dangerColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.dangerColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: colors.dangerColor),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'Something went wrong',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.dangerColor),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Unable to load data. Please check your connection.',
            style: TextStyle(fontSize: 14, color: colors.textColor.withValues(alpha: 0.7)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SecondaryButton(text: 'Retry', onPressed: () {}, size: ButtonSize.small),
              const SizedBox(width: AppDimensions.spacingS),
              SecondaryButton(text: 'Contact Support', onPressed: () {}, size: ButtonSize.small),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicatorsExample(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        // Step progress
        Row(
          children: List.generate(4, (index) {
            final isCompleted = index < 2;
            final isActive = index == 2;

            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted || isActive ? colors.accentColor : colors.borderColor,
                      shape: BoxShape.circle,
                      border: isActive ? Border.all(color: colors.accentColor, width: 2) : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(Icons.check, color: colors.bgColor, size: 16)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isActive ? colors.bgColor : colors.textColor.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                    ),
                  ),
                  if (index < 3)
                    Expanded(child: Container(height: 2, color: isCompleted ? colors.accentColor : colors.borderColor)),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        // Progress bar with percentage
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upload Progress',
                  style: TextStyle(color: colors.textColor, fontWeight: FontWeight.w500),
                ),
                Text('65%', style: TextStyle(color: colors.textColor, fontSize: 12)),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingS),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.65,
                minHeight: 8,
                valueColor: AlwaysStoppedAnimation<Color>(colors.accentColor),
                backgroundColor: colors.borderColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractiveDemoExample(BuildContext context) {
    final colors = context.colors;

    if (_isLoading) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.borderColor),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colors.accentColor)),
              const SizedBox(height: AppDimensions.spacingM),
              Text('Loading...', style: TextStyle(color: colors.textColor)),
            ],
          ),
        ),
      );
    }

    if (_hasError) {
      return Container(
        height: 150,
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: colors.dangerColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.dangerColor.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: colors.dangerColor, size: 32),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                'Error occurred',
                style: TextStyle(color: colors.dangerColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    if (_isEmpty) {
      return Container(
        height: 150,
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.borderColor),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, color: colors.textColor.withValues(alpha: 0.4), size: 32),
              const SizedBox(height: AppDimensions.spacingS),
              Text('No items found', style: TextStyle(color: colors.textColor.withValues(alpha: 0.7))),
            ],
          ),
        ),
      );
    }

    // Success state with data
    return Container(
      height: 150,
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: colors.successColor, size: 20),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'Data loaded successfully',
                style: TextStyle(color: colors.successColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: colors.accentColor.withValues(alpha: 0.1),
                    radius: 16,
                    child: Text('${index + 1}', style: TextStyle(color: colors.accentColor, fontSize: 12)),
                  ),
                  title: Text('Item ${index + 1}', style: TextStyle(color: colors.textColor, fontSize: 14)),
                  subtitle: Text(
                    'Description for item ${index + 1}',
                    style: TextStyle(color: colors.textColor.withValues(alpha: 0.6), fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
