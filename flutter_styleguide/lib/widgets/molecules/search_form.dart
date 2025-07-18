import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Reusable search form component
class SearchForm extends StatefulWidget {
  final String hintText;
  final bool autofocus;
  final ValueChanged<String>? onSearch;
  final bool? isTestMode;
  final bool? testDarkMode;

  const SearchForm({
    this.hintText = 'Search...',
    this.autofocus = false,
    this.onSearch,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSearch() {
    if (widget.onSearch != null) {
      widget.onSearch!(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        textAlignVertical: TextAlignVertical.center,
        onSubmitted: (value) => _handleSearch(),
        style: TextStyle(
          color: colors.textColor,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: colors.textMuted,
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colors.accentColor),
          ),
          filled: true,
          fillColor: colors.inputBg,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: colors.textMuted,
              size: 20,
            ),
            onPressed: _handleSearch,
          ),
        ),
      ),
    );
  }
}
