import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

/// Callback for search actions
typedef SearchCallback = void Function(String query);

/// Base class for search form components
abstract class BaseSearchForm extends StatefulWidget {
  final SearchCallback? onSearch;
  final String hintText;
  final bool autofocus;
  final bool isTestMode;
  final bool testDarkMode;

  const BaseSearchForm({
    Key? key,
    this.onSearch,
    this.hintText = 'Search...',
    this.autofocus = false,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);
}

/// Base state class for search form components
abstract class BaseSearchFormState<T extends BaseSearchForm> extends State<T> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Handle search action
  void handleSearch() {
    if (widget.onSearch != null) {
      widget.onSearch!(controller.text);
    }
  }

  /// Get the border radius for the search form
  BorderRadius getBorderRadius() {
    return BorderRadius.circular(AppDimensions.radiusXs);
  }

  /// Get the search button text
  String getSearchButtonText() {
    return 'Search';
  }

  /// Get the search button width
  double getSearchButtonWidth() {
    return 100;
  }

  /// Build the search form
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode;
    if (widget.isTestMode) {
      isDarkMode = widget.testDarkMode;
    } else {
      isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    }
    final ThemeColorSet colors = isDarkMode ? AppColors.dark : AppColors.light;
    
    return buildSearchForm(context, colors, isDarkMode);
  }

  /// Build the search form UI
  Widget buildSearchForm(BuildContext context, ThemeColorSet colors, bool isDarkMode);
} 