# Accessibility Guide

## Overview

The DMTools Flutter Styleguide implements comprehensive accessibility features to ensure all UI components are:
- **Screen reader compatible** with proper semantic labels
- **Automation testable** with human-readable test identifiers  
- **Keyboard navigable** with full keyboard support
- **WCAG 2.1 AA compliant** following accessibility standards

## Core Features

### 1. Test Identifiers (testId)

All interactive components support `testId` parameter for automation testing with tools like Playwright.

**Format**: `{component}-{context}-{detail}`

**Examples**:
```dart
// Buttons
PrimaryButton(text: 'Submit', testId: 'button-submit')
// Auto-generated: button-submit

// Inputs
TextInput(placeholder: 'Email', testId: 'input-email')
// Auto-generated: input-email

// Cards
AgentCard(agent: agent, testId: 'card-agent-gpt4')
// Auto-generated: card-agent-{agentName}
```

### 2. Semantic Labels (semanticLabel)

Human-readable descriptions for screen readers.

**Examples**:
```dart
PrimaryButton(
  text: 'OK',
  semanticLabel: 'Confirm action',
  semanticHint: 'Confirms the dialog and proceeds',
)

TextInput(
  placeholder: 'Search',
  semanticLabel: 'Search agents',
)
```

### 3. Keyboard Navigation

All interactive components support keyboard navigation:
- **Tab/Shift+Tab**: Navigate between elements
- **Enter/Space**: Activate buttons and controls
- **Arrow keys**: Navigate within lists and groups
- **Escape**: Close modals and cancel actions

## Component Examples

### Buttons

```dart
// Basic usage with auto-generated testId
PrimaryButton(
  text: 'Submit',
  onPressed: () {},
)
// testId: button-submit
// semanticLabel: Submit button

// Custom accessibility properties
PrimaryButton(
  text: 'Save',
  testId: 'button-save-form',
  semanticLabel: 'Save form data',
  semanticHint: 'Saves the current form',
  onPressed: () {},
)

// Disabled state
PrimaryButton(
  text: 'Submit',
  isDisabled: true,
  onPressed: () {},
)
// Screen readers announce: "Submit button, disabled"

// Loading state
PrimaryButton(
  text: 'Submitting',
  isLoading: true,
  onPressed: () {},
)
// Screen readers announce: "Submitting button, loading"
```

### Form Elements

```dart
// Text Input
TextInput(
  placeholder: 'Enter your email',
  testId: 'input-email',
  semanticLabel: 'Email address',
  controller: emailController,
  onChanged: (value) => handleEmailChange(value),
)

// With FormGroup for better labeling
FormGroup(
  label: 'Email Address',
  helperText: 'We will never share your email',
  child: TextInput(
    placeholder: 'user@example.com',
    testId: 'input-email',
  ),
)
```

### Cards

```dart
// Agent Card with contextual testId
AgentCard(
  agent: agent,
  testId: 'card-agent-${agent.id}',
  onTap: () => selectAgent(agent),
)
// Screen readers announce: "Agent {name} card, button"
```

## Accessibility Utilities

### generateTestId()

Generates consistent test identifiers:

```dart
import 'package:dmtools_styleguide/utils/accessibility_utils.dart';

// Simple
final testId = generateTestId('button', {'action': 'submit'});
// Result: 'button-submit'

// Complex
final testId = generateTestId('card', {
  'type': 'agent',
  'name': 'GPT-4',
});
// Result: 'card-gpt-4-agent'
```

### generateSemanticLabel()

Creates human-readable semantic labels:

```dart
final label = generateSemanticLabel('button', 'Submit form');
// Result: 'Submit form button'

final label = generateSemanticLabel('input', 'Email address');
// Result: 'Email address input field'
```

### AccessibilityMixin

Reusable accessibility patterns:

```dart
class MyWidget extends StatelessWidget with AccessibilityMixin {
  @override
  Widget build(BuildContext context) {
    return buildButtonSemantics(
      child: YourButtonWidget(),
      label: 'My Button',
      enabled: true,
      onTap: () {},
    );
  }
}
```

## Automation Testing

### Playwright Example

```typescript
// Navigate to page
await page.goto('http://localhost:8080');

// Find and click button by testId
await page.click('[data-test-id="button-submit"]');

// Find input by testId
await page.fill('[data-test-id="input-email"]', 'test@example.com');

// Verify button is disabled
const button = await page.locator('[data-test-id="button-save"]');
await expect(button).toBeDisabled();
```

### Flutter Integration Test

```dart
testWidgets('Button accessibility', (tester) async {
  await tester.pumpWidget(MyApp());

  // Find by testId
  final button = find.byKey(const ValueKey('button-submit'));
  expect(button, findsOneWidget);

  // Verify keyboard navigation
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
});
```

## Best Practices

### 1. Always Provide Context

❌ Bad:
```dart
PrimaryButton(text: 'OK', testId: 'button-1')
```

✅ Good:
```dart
PrimaryButton(
  text: 'OK',
  testId: 'button-confirm-dialog',
  semanticLabel: 'Confirm and close dialog',
)
```

### 2. Use Descriptive Labels

❌ Bad:
```dart
semanticLabel: 'Button'
```

✅ Good:
```dart
semanticLabel: 'Submit form and continue to next step'
```

### 3. Maintain Consistency

Use consistent naming patterns:
- `button-{action}-{context}`
- `input-{fieldName}`
- `card-{type}-{identifier}`

### 4. Test with Screen Readers

Test your implementation with:
- **macOS**: VoiceOver (Cmd+F5)
- **Windows**: NVDA or JAWS
- **Linux**: Orca
- **Mobile**: TalkBack (Android) / VoiceOver (iOS)

### 5. Keyboard Navigation Flow

Ensure logical tab order:
1. Primary actions first
2. Secondary actions second
3. Form fields in reading order
4. Cancel/close actions last

## WCAG 2.1 AA Compliance

### Implemented Standards

✅ **1.3.1 Info and Relationships**: Semantic structure through Semantics widgets  
✅ **2.1.1 Keyboard**: Full keyboard navigation support  
✅ **2.4.3 Focus Order**: Logical focus traversal  
✅ **2.4.6 Headings and Labels**: Descriptive labels for all components  
✅ **2.4.7 Focus Visible**: Clear focus indicators  
✅ **4.1.2 Name, Role, Value**: Proper semantic roles and states  
✅ **4.1.3 Status Messages**: Live regions for dynamic content  

## Troubleshooting

### Screen Readers Not Announcing

1. Verify Semantics widget is present
2. Check `label` property is set
3. Ensure widget is focusable
4. Test in web browser with accessibility tree inspector

### Automation Tests Can't Find Elements

1. Verify `testId` is generated correctly
2. Check ValueKey is applied to widget
3. Use browser DevTools to inspect element attributes
4. Ensure test ID follows naming convention

### Keyboard Navigation Not Working

1. Check Focus widget is present
2. Verify `onKeyEvent` handler is implemented
3. Test focus order with Tab key
4. Ensure disabled state prevents interaction

## Resources

- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Playwright Testing](https://playwright.dev/)
- [Flutter Semantics](https://api.flutter.dev/flutter/widgets/Semantics-class.html)

## Support

For accessibility issues or questions:
1. Check this documentation first
2. Review component implementation in `/lib/widgets/`
3. Run accessibility tests: `flutter test test/widgets/atoms/buttons/accessibility_test.dart`
4. Create an issue in the project repository with `[a11y]` prefix

