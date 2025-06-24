import 'package:flutter/material.dart';
import 'base_search_form.dart';

/// Compact search form implementation with icon button instead of text button
class CompactSearchForm extends BaseSearchForm {
  const CompactSearchForm({
    super.key,
    super.onSearch,
    super.hintText = 'Search...',
    super.autofocus = false,
    super.isTestMode = false,
    super.testDarkMode = false,
  });

  @override
  State<CompactSearchForm> createState() => _CompactSearchFormState();
}

class _CompactSearchFormState extends BaseSearchFormState<CompactSearchForm> {
  @override
  double getSearchButtonWidth() {
    return 40; // Square button
  }

  @override
  Widget buildSearchForm(BuildContext context, ThemeColorSet colors, bool isDarkMode) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: getBorderRadius(),
      ),
      child: TextField(
        controller: controller,
        autofocus: widget.autofocus,
        textAlignVertical: TextAlignVertical.center,
        onSubmitted: (value) => handleSearch(),
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
            borderRadius: getBorderRadius(),
            borderSide: BorderSide(color: colors.borderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: getBorderRadius(),
            borderSide: BorderSide(color: colors.borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: getBorderRadius(),
            borderSide: BorderSide(color: colors.accentColor, width: 1),
          ),
          filled: true,
          fillColor: colors.inputBg,
          suffixIcon: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: handleSearch,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(getBorderRadius().topRight.x),
                bottomRight: Radius.circular(getBorderRadius().bottomRight.x),
              ),
              hoverColor: colors.accentHover,
              child: Ink(
                width: getSearchButtonWidth(),
                decoration: BoxDecoration(
                  color: colors.accentColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(getBorderRadius().topRight.x),
                    bottomRight: Radius.circular(getBorderRadius().bottomRight.x),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: getSearchButtonWidth(),
            minHeight: 40,
          ),
        ),
      ),
    );
  }
} 