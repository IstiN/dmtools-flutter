import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/widgets/styleguide/component_display.dart';
import 'package:dmtools_styleguide/theme/app_dimensions.dart';
import 'package:dmtools_styleguide/widgets/atoms/loading_indicators.dart';
import 'package:dmtools_styleguide/widgets/styleguide/component_item.dart';

class LoadingIndicatorsPage extends StatelessWidget {
  const LoadingIndicatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      children: [
        ComponentDisplay(
          title: 'Pulsing Dot',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ComponentItem(
                title: 'Default',
                child: PulsingDotIndicator(),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              const ComponentItem(
                title: 'Large',
                child: PulsingDotIndicator(size: 48.0),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              ComponentItem(
                title: 'On Dark Background',
                child: Theme(
                  data: ThemeData.dark(),
                  child: Builder(
                    builder: (context) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(AppDimensions.spacingXs),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(AppDimensions.spacingM),
                          child: PulsingDotIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Bouncing Dots',
          child: BouncingDotsIndicator(),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Rotating Segments',
          child: RotatingSegmentsIndicator(),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Infinity Dots',
          child: InfinityDotsIndicator(),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Chromosome',
          child: ChromosomeIndicator(),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'DNA Helix',
          child: DnaIndicator(),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Fading Grid',
          child: FadingGridIndicator(),
        ),
      ],
    );
  }
}
