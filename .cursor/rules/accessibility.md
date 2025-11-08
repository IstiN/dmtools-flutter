---
description: 
globs: 
alwaysApply: true
---

# Accessibility Rules for UI Development

## CRITICAL: Always Implement Accessibility

**Every interactive UI component MUST include accessibility features.** This is not optional.

## Required Properties for All Interactive Components

### 1. Test Identifiers (testId)

**MANDATORY** for all buttons, inputs, cards, and interactive elements.

```dart
// ✅ REQUIRED
PrimaryButton(text: 'Submit', testId: 'button-submit-form', onPressed: () {})

// ❌ FORBIDDEN
PrimaryButton(text: 'Submit', onPressed: () {}) // Missing testId
```

**Naming Convention:**
- Format: `{component}-{context}-{detail}`
- Examples: `button-submit-form`, `input-email-login`, `card-agent-gpt4`
- Use kebab-case (lowercase with hyphens)
- Be descriptive and contextual

### 2. Semantic Labels (semanticLabel)

**MANDATORY** for screen reader support.

```dart
// ✅ REQUIRED
PrimaryButton(text: 'OK', semanticLabel: 'Confirm and close dialog', onPressed: () {})

// ❌ FORBIDDEN
PrimaryButton(text: 'OK', onPressed: () {}) // Missing semanticLabel
```

**Guidelines:**
- Be descriptive: "Submit form and continue" not just "Submit"
- Include context: "Close dialog" not just "Close"
- Use action verbs: "Save changes", "Delete item", "Navigate to settings"

### 3. Keyboard Navigation

**MANDATORY** for all interactive elements.

**Required Keys:**
- **Tab/Shift+Tab**: Navigate between elements
- **Enter/Space**: Activate buttons and controls
- **Escape**: Close modals, dialogs, and cancel actions
- **Arrow keys**: Navigate within lists, menus, and groups

**Implementation:**
```dart
Focus(
  focusNode: _focusNode,
  onKeyEvent: (node, event) {
    if (event.logicalKey == LogicalKeyboardKey.enter && event is KeyDownEvent) {
      onPressed?.call();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  },
  child: YourButton(),
)
```

### 4. Focus Indicators

**MANDATORY** - All focusable elements must show clear focus state.

```dart
// Use box shadow outline (prevents size changes/jumping)
final effectiveShadows = _isFocused && !widget.isDisabled
    ? [...baseShadows, BoxShadow(color: colors.accentColor.withValues(alpha: 0.8), spreadRadius: 2.0)]
    : baseShadows;
```

**Requirements:**
- Must be visible (2px+ outline or shadow)
- Use theme accent color
- Don't change element size (prevents "jumping")
- Show on keyboard navigation (Tab key)
- Hide when disabled

## Component-Specific Rules

### Buttons

**MUST HAVE:**
- ✅ `testId` parameter
- ✅ `semanticLabel` parameter
- ✅ `semanticHint` parameter (optional but recommended)
- ✅ Focus widget with keyboard handling
- ✅ Focus indicator (box shadow outline)
- ✅ Disabled state semantics
- ✅ Loading state semantics

**Example:**
```dart
PrimaryButton(
  text: 'Save Changes',
  testId: 'button-save-settings',
  semanticLabel: 'Save settings changes',
  onPressed: () => saveSettings(),
)
```

### Form Inputs

**MUST HAVE:**
- ✅ `testId` parameter
- ✅ `semanticLabel` parameter
- ✅ `autofocus: true` when appropriate (login forms, search bars, chat inputs)
- ✅ Focus node for programmatic focus management
- ✅ Proper label association
- ✅ Error state semantics

**Example:**
```dart
TextInput(
  placeholder: 'Enter email',
  testId: 'input-email-login',
  semanticLabel: 'Email address input',
  focusNode: emailFocusNode,
  autofocus: true, // For login, search, chat
)
```

### Dialogs and Modals

**MUST HAVE:**
- ✅ `PopScope` with ESC key handling
- ✅ `FocusScope` with `autofocus: true` to trap focus
- ✅ First focusable element gets focus automatically
- ✅ `barrierDismissible: true` for ESC and outside click
- ✅ Proper focus management when opening/closing

**Example:**
```dart
showDialog(
  context: context,
  barrierDismissible: true,
  builder: (context) => PopScope(
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) Navigator.of(context).pop();
    },
    child: Dialog(
      child: FocusScope(
        autofocus: true,
        child: YourDialogContent(), // First element should have autofocus
      ),
    ),
  ),
);
```

### Navigation Items

**MUST HAVE:**
- ✅ `testId` with menu item context
- ✅ `semanticLabel` with selection state
- ✅ Keyboard navigation support
- ✅ Selected state semantics

**Example:**
```dart
Semantics(
  label: '${item.label} navigation item${isSelected ? ', selected' : ''}',
  button: true,
  selected: isSelected,
  child: Container(key: ValueKey(generateTestId('menu-item', {'label': item.label}))),
)
```

### Cards and List Items

**MUST HAVE:**
- ✅ `testId` with contextual identifier
- ✅ `semanticLabel` describing the card content
- ✅ Keyboard activation support
- ✅ Proper role semantics

**Example:**
```dart
Semantics(
  label: '${agent.name} agent card',
  button: true,
  child: Container(key: ValueKey(generateTestId('card', {'type': 'agent', 'name': agent.name}))),
)
```

## Autofocus Rules

### When to Use Autofocus

**ALWAYS use autofocus for:**
- ✅ Login/authentication forms (username/email field)
- ✅ Search input fields
- ✅ Chat message input fields
- ✅ First input in multi-step forms
- ✅ First focusable element in dialogs

**NEVER use autofocus for:**
- ❌ Buttons (unless it's the only action)
- ❌ Secondary inputs
- ❌ Read-only content

**Implementation Pattern:**
```dart
class _MyFormState extends State<MyForm> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNode.canRequestFocus) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      autofocus: true,
    );
  }
}
```

## Focus Management Rules

### Dialog Focus Management

**REQUIRED Pattern:**
```dart
showDialog(
  context: context,
  barrierDismissible: true,
  builder: (context) => PopScope(
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) Navigator.of(context).pop();
    },
    child: Dialog(child: FocusScope(autofocus: true, child: YourDialogContent())),
  ),
);
```

### Page Navigation Focus

**REQUIRED Pattern:**
```dart
class _MyPageState extends State<MyPage> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNode.canRequestFocus) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
```

## Testing Requirements

### Unit Tests

**MUST include tests for:**
- ✅ Test ID generation
- ✅ Semantic label generation
- ✅ Keyboard event handling
- ✅ Focus state management
- ✅ Disabled state semantics
- ✅ Loading state semantics

**Example:**
```dart
testWidgets('Button accessibility', (tester) async {
  await tester.pumpWidget(PrimaryButton(text: 'Submit', testId: 'button-submit', onPressed: () {}));
  expect(find.byKey(const ValueKey('button-submit')), findsOneWidget);
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
});
```

### E2E Tests

**MUST verify:**
- ✅ Elements accessible via Playwright's accessibility tree
- ✅ Keyboard navigation works
- ✅ Focus indicators visible
- ✅ Screen reader announcements correct

## Accessibility Checklist

Before submitting any UI component, verify:

### Required Properties
- [ ] `testId` parameter provided
- [ ] `semanticLabel` parameter provided
- [ ] `semanticHint` parameter provided (if applicable)
- [ ] Focus node created and disposed properly
- [ ] Keyboard event handling implemented
- [ ] Focus indicator implemented (box shadow outline)

### Keyboard Navigation
- [ ] Tab/Shift+Tab navigates correctly
- [ ] Enter/Space activates element
- [ ] Escape closes modals/dialogs
- [ ] Arrow keys work for lists/menus
- [ ] Focus order is logical

### Focus Management
- [ ] Autofocus used appropriately (forms, search, chat)
- [ ] Dialog focus trapped with FocusScope
- [ ] First focusable element gets focus in dialogs
- [ ] Focus restored after closing dialogs

### Visual Indicators
- [ ] Focus indicator visible (2px+ outline)
- [ ] Focus indicator doesn't change element size
- [ ] Focus indicator uses theme accent color
- [ ] Disabled state clearly indicated

### Screen Reader Support
- [ ] Semantic labels are descriptive
- [ ] State changes announced (selected, disabled, loading)
- [ ] Error messages accessible
- [ ] Form labels properly associated

## Code Generation Rules

When creating new UI components:

1. **Always add accessibility parameters** to constructor
2. **Always implement Focus widget** for interactive elements
3. **Always add focus indicator** using box shadow outline
4. **Always add keyboard event handling**
5. **Always generate test IDs** using `generateTestId()`
6. **Always generate semantic labels** using `generateSemanticLabel()`
7. **Always dispose FocusNodes** in dispose method
8. **Always add unit tests** for accessibility features

## Common Patterns

### Button Pattern
```dart
class _MyButtonState extends State<MyButton> {
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testId = widget.testId ?? generateTestId('button', {'action': widget.text});
    return Semantics(
      label: widget.semanticLabel ?? generateSemanticLabel('button', widget.text),
      button: true,
      child: Focus(
        focusNode: _focusNode,
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        onKeyEvent: (node, event) {
          if (event.logicalKey == LogicalKeyboardKey.enter && event is KeyDownEvent) {
            widget.onPressed?.call();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Container(
          key: ValueKey(testId),
          decoration: BoxDecoration(boxShadow: _isFocused ? [focusShadow] : []),
        ),
      ),
    );
  }
}
```

### Input Pattern
```dart
class _MyInputState extends State<MyInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNode.canRequestFocus) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel ?? generateSemanticLabel('input', 'Text input'),
      child: TextField(
        key: ValueKey(widget.testId ?? generateTestId('input', {'field': 'text'})),
        focusNode: _focusNode,
        autofocus: widget.autofocus,
      ),
    );
  }
}
```

## Forbidden Patterns

### ❌ NEVER Do This

```dart
// Missing accessibility properties
PrimaryButton(text: 'Submit', onPressed: () {}); // NO testId, NO semanticLabel

// Missing focus management
TextField(controller: controller); // NO focusNode, NO autofocus when needed

// Missing keyboard handling
GestureDetector(onTap: () {}, child: Container(...)); // NO Focus widget

// Missing focus indicator
Focus(child: Button()); // NO visual focus indicator

// Missing dispose - FocusNode in StatefulWidget (should be in State class)
class MyWidget extends StatefulWidget {
  final _focusNode = FocusNode(); // ❌ FORBIDDEN
}
```

## Import Requirements

```dart
import 'package:dmtools_styleguide/utils/accessibility_utils.dart';
import 'package:flutter/services.dart'; // LogicalKeyboardKey
```

## Resources

- See `flutter_styleguide/ACCESSIBILITY.md` for detailed documentation
- See `flutter_styleguide/lib/utils/accessibility_utils.dart` for utility functions
- See `flutter_styleguide/lib/mixins/accessibility_mixin.dart` for reusable patterns
- Run tests: `flutter test test/widgets/atoms/buttons/accessibility_test.dart`

## Enforcement

**These rules are MANDATORY.** Any UI component without proper accessibility implementation will be rejected.

**Before committing:**
1. Run `flutter analyze` - must pass
2. Run `flutter test` - all accessibility tests must pass
3. Manually test keyboard navigation
4. Verify focus indicators appear
5. Test with screen reader (VoiceOver/NVDA)

---

**Remember:** Accessibility is not optional. Every user deserves equal access to your UI.

