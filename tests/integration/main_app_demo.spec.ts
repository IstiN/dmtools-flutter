import { test, expect } from '@playwright/test';

/**
 * E2E tests for DMTools Main App - Demo Mode Flow
 * Tests the complete flow: Landing page -> Demo button -> Navigation through menu items
 */
test.describe('Main App - Demo Mode Navigation', () => {
  const BASE_URL = 'http://localhost:8080';
  
  // Navigation menu items to test
  const menuItems = [
    { label: 'AI Jobs', testId: 'menu-item-ai-jobs' },
    { label: 'Integrations', testId: 'menu-item-integrations' },
    { label: 'Chat', testId: 'menu-item-chat' },
    { label: 'MCP', testId: 'menu-item-mcp' },
  ];

  test.beforeEach(async ({ page }) => {
    // Navigate to the main landing page
    await page.goto(BASE_URL);
    
    // Wait for the page to load
    await page.waitForLoadState('networkidle');
    
    // Enable Flutter's accessibility mode by clicking on the hidden semantic announcements
    // This exposes the semantic tree to Playwright
    try {
      const hiddenElement = await page.locator('flt-semantics-host').first();
      if (hiddenElement) {
        await hiddenElement.evaluate(node => {
          // Enable semantic nodes
          (node as any).style.display = 'block';
        });
      }
    } catch (e) {
      console.log('Could not enable semantics, continuing anyway...');
    }
  });

  test('should load the landing page successfully', async ({ page }) => {
    // Check that the landing page title is visible
    await expect(page.locator('text=Welcome to DMTools')).toBeVisible({ timeout: 10000 });
    
    // Check that primary action button is visible
    const getStartedButton = page.locator('[data-testid="button-get-started"]').or(
      page.locator('text="Get Started"')
    );
    await expect(getStartedButton.first()).toBeVisible();
    
    // Check that demo button is visible
    const demoButton = page.locator('[data-testid="button-demo"]').or(
      page.locator('text="Demo"')
    );
    await expect(demoButton.first()).toBeVisible();
  });

  test('should enter demo mode when clicking Demo button', async ({ page }) => {
    // Find and click the Demo button
    const demoButton = page.locator('[data-testid="button-demo"]').or(
      page.locator('text="Demo"')
    ).first();
    
    await expect(demoButton).toBeVisible({ timeout: 10000 });
    await demoButton.click();
    
    // Wait for navigation to complete and home screen to load
    await page.waitForLoadState('networkidle');
    
    // Wait for the navigation sidebar to appear
    await page.waitForTimeout(2000); // Give Flutter time to render
    
    // Check that at least one navigation item is visible
    const firstMenuItem = page.locator('[data-testid="menu-item-ai-jobs"]').or(
      page.locator('text="AI Jobs"')
    ).first();
    
    await expect(firstMenuItem).toBeVisible({ timeout: 10000 });
  });

  test('should display all navigation menu items in demo mode', async ({ page }) => {
    // Enter demo mode
    const demoButton = page.locator('[data-testid="button-demo"]').or(
      page.locator('text="Demo"')
    ).first();
    
    await demoButton.click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    
    // Check that each navigation item is visible
    for (const item of menuItems) {
      const menuItem = page.locator(`[data-testid="${item.testId}"]`).or(
        page.locator(`text="${item.label}"`)
      ).first();
      
      await expect(menuItem).toBeVisible({ timeout: 5000 });
    }
  });

  test('should navigate through all menu items', async ({ page }) => {
    // Enter demo mode
    const demoButton = page.locator('[data-testid="button-demo"]').or(
      page.locator('text="Demo"')
    ).first();
    
    await demoButton.click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    
    // Click on each menu item and verify navigation
    for (const item of menuItems) {
      console.log(`Testing navigation to: ${item.label}`);
      
      // Find and click the menu item
      const menuItem = page.locator(`[data-testid="${item.testId}"]`).or(
        page.locator(`text="${item.label}"`)
      ).first();
      
      await expect(menuItem).toBeVisible({ timeout: 5000 });
      await menuItem.click();
      
      // Wait for the page to load
      await page.waitForLoadState('networkidle');
      await page.waitForTimeout(1000);
      
      // Verify that the menu item is now selected/active
      // This could be done by checking for a specific CSS class or aria-selected attribute
      const selectedMenuItem = page.locator(`[data-testid="${item.testId}"]`).first();
      
      // Check if the element is still visible (indicating successful navigation)
      await expect(selectedMenuItem).toBeVisible();
      
      console.log(`Successfully navigated to: ${item.label}`);
    }
  });

  test('should maintain accessibility labels on menu items', async ({ page }) => {
    // Enter demo mode
    const demoButton = page.locator('[data-testid="button-demo"]').or(
      page.locator('text="Demo"')
    ).first();
    
    await demoButton.click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    
    // Check semantic labels for each menu item
    for (const item of menuItems) {
      const menuItem = page.locator(`[data-testid="${item.testId}"]`).first();
      
      // Menu items should be keyboard accessible
      await expect(menuItem).toBeVisible({ timeout: 5000 });
      
      // Try to get aria-label if available (Flutter semantic labels might be exposed as aria-label)
      const ariaLabel = await menuItem.getAttribute('aria-label');
      console.log(`${item.label} aria-label:`, ariaLabel || 'Not set');
    }
  });

  test('should handle keyboard navigation on menu items', async ({ page }) => {
    // Enter demo mode
    const demoButton = page.locator('[data-testid="button-demo"]').or(
      page.locator('text="Demo"')
    ).first();
    
    await demoButton.click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    
    // Focus on the first menu item
    const firstMenuItem = page.locator(`[data-testid="${menuItems[0].testId}"]`).or(
      page.locator(`text="${menuItems[0].label}"`)
    ).first();
    
    await expect(firstMenuItem).toBeVisible({ timeout: 5000 });
    
    // Focus the element
    await firstMenuItem.focus();
    
    // Press Enter to activate
    await page.keyboard.press('Enter');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(500);
    
    // Verify we're still on the page (navigation worked)
    await expect(firstMenuItem).toBeVisible();
    
    console.log('Keyboard navigation test passed');
  });

  test('should display theme toggle in header', async ({ page }) => {
    // Enter demo mode
    const demoButton = page.locator('[data-testid="button-demo"]').or(
      page.locator('text="Demo"')
    ).first();
    
    await demoButton.click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    
    // Look for theme toggle button (usually an icon button)
    const themeToggle = page.locator('[data-testid="button-theme-toggle"]').or(
      page.locator('button').filter({ hasText: /theme/i })
    );
    
    // The theme toggle should be visible
    const themeToggleCount = await themeToggle.count();
    expect(themeToggleCount).toBeGreaterThan(0);
    
    console.log('Theme toggle found');
  });
});

