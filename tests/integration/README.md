# Playwright Integration Tests

## 🎉 WORKING SOLUTION - Accessibility Tree Access

**Good news!** All Flutter elements are now accessible to Playwright and Browser MCP via the **Accessibility Tree API**.

### Quick Start

```bash
# 1. Start the app (auto renderer - works with both canvas and HTML!)
flutter run -d chrome --web-port=8080

# 2. Run the complete working test
npx playwright test tests/integration/complete_demo_flow.spec.ts
```

**Result:** ✅ All tests pass! Demo flow fully automated!

### How It Works

Flutter web exposes elements through the **accessibility tree** (not DOM). After auto-enabling accessibility (happens automatically on page load), you can access all elements via:

```typescript
// Access any button by role and name
await page.getByRole('button', { name: /demo/i }).click();
await page.getByRole('button', { name: 'AI Jobs' }).click();

// Get full accessibility tree
const tree = await page.accessibility.snapshot();
```

**See:** `ACCESSIBILITY_SOLUTION.md` for complete documentation

---

## Overview

This directory contains Playwright end-to-end tests for verifying accessibility features in:
1. DMTools Flutter Styleguide web application
2. DMTools Main Application (demo mode flow)

## Prerequisites

1. **Node.js** (v18 or higher)
2. **Playwright** installed
3. **Flutter Styleguide** running locally on port 8080

## Installation

```bash
# Install Playwright
npm install -D @playwright/test

# Install browsers
npx playwright install
```

## Running the Tests

### 1. Start the Flutter Styleguide

```bash
cd flutter_styleguide
flutter run -d chrome --web-port=8080 --web-experimental-hot-reload
```

### 2. Run Playwright Tests

**Note:** The Playwright config (`playwright.config.ts`) is located in the `tests/integration/` directory. You can run tests in two ways:

**Option 1: From project root (recommended for CI)**
```bash
# Run all tests
npx playwright test --config=tests/integration/playwright.config.ts

# Run specific test
npx playwright test --config=tests/integration/playwright.config.ts accessibility.spec.ts

# Run in headed mode
npx playwright test --config=tests/integration/playwright.config.ts --headed
```

**Option 2: From tests/integration directory (recommended for local development)**
```bash
cd tests/integration

# Run all tests (config auto-discovers)
npx playwright test

# Run specific test
npx playwright test accessibility.spec.ts

# Run in headed mode
npx playwright test --headed

# Run in debug mode
npx playwright test --debug

# Run specific test by name
npx playwright test -g "should load styleguide"
```

#### For Styleguide Tests

```bash
# From project root
npx playwright test --config=tests/integration/playwright.config.ts accessibility.spec.ts

# Or from tests/integration directory
cd tests/integration
npx playwright test accessibility.spec.ts
```

#### For Main App Tests

```bash
# First, start the main app
flutter run -d chrome --web-port=8080 --web-experimental-hot-reload

# Then run tests (from project root)
npx playwright test --config=tests/integration/playwright.config.ts main_app_demo.spec.ts

# Or from tests/integration directory
cd tests/integration
npx playwright test main_app_demo.spec.ts
```

## Test Coverage

### Styleguide Accessibility Tests (`accessibility.spec.ts`)

1. **Page Load**: Verifies styleguide loads with semantic elements
2. **Navigation**: Tests navigation between Atoms, Molecules, Organisms
3. **Buttons**: Checks button accessibility labels and interactivity
4. **Keyboard Navigation**: Verifies Tab, Enter, Space, Escape keys work
5. **Form Inputs**: Tests text input accessibility and typing
6. **Theme Toggle**: Verifies theme switching is accessible
7. **Focus Indicators**: Checks visible focus states
8. **Screen Reader Simulation**: Validates ARIA attributes and semantic tree

### Main App Demo Mode Tests (`main_app_demo.spec.ts`)

1. **Landing Page Load**: Verifies main app landing page loads correctly
2. **Demo Button Click**: Tests entering demo mode
3. **Navigation Menu Display**: Checks all menu items are visible in demo mode
4. **Menu Navigation**: Tests clicking through each menu item (AI Jobs, Integrations, Chat, MCP)
5. **Accessibility Labels**: Verifies semantic labels on menu items
6. **Keyboard Navigation**: Tests keyboard interaction with menu items
7. **Theme Toggle**: Checks theme toggle button accessibility

## Test Structure

```typescript
test.describe('Test Suite', () => {
  test.beforeEach(async ({ page }) => {
    // Setup before each test
    await page.goto(STYLEGUIDE_URL);
  });

  test('test name', async ({ page }) => {
    // Test implementation
  });
});
```

## Flutter Web Accessibility Mode

Flutter web exposes accessibility through the semantic tree when:
1. Screen reader is detected, OR
2. Manually enabled via browser console:

```javascript
// In browser DevTools Console:
document.querySelector('flt-glass-pane').click();
```

This creates `<flt-semantics>` elements with ARIA attributes that Playwright can access.

## Common Selectors

```typescript
// Semantic elements
page.locator('flt-semantics')

// Buttons
page.locator('flt-semantics[role="button"]')

// Text inputs
page.locator('flt-semantics[role="textbox"]')

// Headings
page.locator('flt-semantics[role="heading"]')

// By ARIA label
page.locator('[aria-label="Submit button"]')

// By text content
page.locator('text=Submit')
```

## Debugging Tips

### 1. View Semantic Tree

```typescript
test('debug semantic tree', async ({ page }) => {
  await page.goto('http://localhost:8080');
  
  // Get all semantic elements
  const semantics = await page.locator('flt-semantics').all();
  
  for (const el of semantics) {
    const role = await el.getAttribute('role');
    const label = await el.getAttribute('aria-label');
    console.log({ role, label });
  }
});
```

### 2. Take Screenshots

```typescript
await page.screenshot({ path: 'debug-screenshot.png' });
```

### 3. Pause Execution

```typescript
await page.pause(); // Opens Playwright Inspector
```

### 4. Check Element State

```typescript
const button = page.locator('flt-semantics[role="button"]').first();
console.log(await button.boundingBox());
console.log(await button.isVisible());
console.log(await button.isEnabled());
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Accessibility Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: |
          cd flutter_styleguide
          flutter pub get
          npm install
      
      - name: Install Playwright
        run: npx playwright install --with-deps
      
      - name: Start Flutter web app
        run: |
          cd flutter_styleguide
          flutter run -d web-server --web-port=8080 &
          sleep 30
      
      - name: Run Playwright tests
        run: npx playwright test tests/integration/
      
      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-report
          path: playwright-report/
```

## Troubleshooting

### Issue: Semantic elements not found

**Solution**: Ensure Flutter web accessibility mode is enabled:
```javascript
// Run in browser console
document.querySelector('flt-glass-pane')?.click();
```

### Issue: Tests timing out

**Solution**: Increase timeouts:
```typescript
test('my test', async ({ page }) => {
  await page.goto(URL, { timeout: 30000 });
  await page.waitForSelector('flt-semantics', { timeout: 15000 });
});
```

### Issue: Elements not interactable

**Solution**: Wait for stability:
```typescript
await page.waitForLoadState('networkidle');
await page.waitForTimeout(1000);
```

### Issue: Flutter app not loading

**Solution**: Check:
1. Flutter web server is running on correct port
2. No CORS issues in browser console
3. Build is up to date: `flutter clean && flutter pub get`

## Best Practices

1. **Always wait for semantic elements** before interacting
2. **Use descriptive test names** that explain what's being tested
3. **Test keyboard navigation** in addition to mouse clicks
4. **Verify ARIA attributes** not just visual elements
5. **Test both light and dark themes** if applicable
6. **Group related tests** in describe blocks
7. **Clean up after tests** (close modals, reset state)
8. **Use explicit waits** instead of arbitrary timeouts when possible

## Resources

- [Playwright Documentation](https://playwright.dev/)
- [Flutter Web Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [WebAIM](https://webaim.org/)

## Support

For issues or questions about accessibility testing:
1. Check this README
2. Review test implementation in `accessibility.spec.ts`
3. See main [ACCESSIBILITY.md](../../flutter_styleguide/ACCESSIBILITY.md)
4. Create an issue with `[e2e]` or `[a11y]` prefix

