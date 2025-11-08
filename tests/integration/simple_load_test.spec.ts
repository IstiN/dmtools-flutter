import { test, expect } from '@playwright/test';

/**
 * Simple load test for Flutter Web App
 * Tests if the app loads without crashing
 */
test.describe('Simple App Load Test', () => {
  test('should load the app without crashing', async ({ page }) => {
    // Go to the page
    await page.goto('http://localhost:8080');
    
    // Wait for Flutter to initialize
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(5000); // Give Flutter more time to render
    
    // Take a screenshot to see what's rendered
    await page.screenshot({ path: 'test-results/app-loaded.png', fullPage: true });
    
    // Check if Flutter app loaded (look for Flutter-specific elements)
    const flutterView = page.locator('flt-glass-pane, flutter-view, [flt-renderer]');
    await expect(flutterView.first()).toBeVisible({ timeout: 10000 });
    
    console.log('✅ Flutter app loaded successfully!');
    
    // Check page title
    await expect(page).toHaveTitle('DMTools');
    
    console.log('✅ Page title is correct!');
  });
  
  test('should not show error messages', async ({ page }) => {
    await page.goto('http://localhost:8080');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    // Check console for errors
    const errors: string[] = [];
    page.on('pageerror', error => {
      errors.push(error.message);
    });
    
    await page.waitForTimeout(2000);
    
    // Filter out warnings (only check for actual errors)
    const actualErrors = errors.filter(e => 
      !e.includes('Warning') && 
      !e.includes('viewport') &&
      !e.includes('deprecated')
    );
    
    if (actualErrors.length > 0) {
      console.log('❌ Page errors found:', actualErrors);
    } else {
      console.log('✅ No critical errors in console!');
    }
    
    expect(actualErrors.length).toBe(0);
  });
});

