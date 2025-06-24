import 'package:flutter/material.dart';
import 'base_search_form.dart';

/// Standard search form implementation
class StandardSearchForm extends BaseSearchForm {
  const StandardSearchForm({
    super.key,
    super.onSearch,
    super.hintText = 'Search...',
    super.autofocus = false,
    super.isTestMode = false,
    super.testDarkMode = false,
  });

  @override
  State<StandardSearchForm> createState() => _StandardSearchFormState();
}

class _StandardSearchFormState extends BaseSearchFormState<StandardSearchForm> {
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
                child: Center(
                  child: Text(
                    getSearchButtonText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
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