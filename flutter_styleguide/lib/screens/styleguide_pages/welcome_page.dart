import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListView(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      children: [
        Padding(
          padding: EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DMTools Style Guide',
                style: theme.textTheme.headlineLarge,
              ),
              SizedBox(height: AppDimensions.spacingM),
              Text(
                'Welcome to the DMTools Style Guide. This is a comprehensive collection of UI components and design patterns used across the DMTools application.',
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: AppDimensions.spacingL),
              Text(
                'Getting Started',
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: AppDimensions.spacingS),
              Text(
                'Use the navigation menu to explore different categories of components:',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: AppDimensions.spacingM),
              _buildNavigationItem(
                context, 
                'Colors & Typography', 
                'Explore the color palette and text styles'
              ),
              _buildNavigationItem(
                context, 
                'Atoms', 
                'Basic building blocks like buttons, inputs, and icons'
              ),
              _buildNavigationItem(
                context, 
                'Molecules', 
                'Combinations of atoms like cards, search forms, and headers'
              ),
              _buildNavigationItem(
                context, 
                'Organisms', 
                'Complex UI components composed of molecules and atoms'
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildNavigationItem(BuildContext context, String title, String description) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right, size: 20),
          SizedBox(width: AppDimensions.spacingXs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 