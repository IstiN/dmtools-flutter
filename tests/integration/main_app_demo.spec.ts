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
    // Wait for Flutter to initialize
    await page.waitForTimeout(3000);
    
    // Check that the landing page title is visible via accessibility tree
    // Use getByText for text content (text is not a role in accessibility tree)
    const welcomeText = page.getByText(/Welcome to DMTools/i);
    await expect(welcomeText.first()).toBeVisible({ timeout: 10000 });
    
    // Check that primary action button is visible via accessibility tree
    const getStartedButton = page.getByRole('button', { name: /get started/i });
    await expect(getStartedButton.first()).toBeVisible();
    
    // Check that demo button is visible via accessibility tree
    const demoButton = page.getByRole('button', { name: /demo/i });
    await expect(demoButton.first()).toBeVisible();
  });

  test('should enter demo mode when clicking Demo button', async ({ page }) => {
    // Wait for Flutter to initialize
    await page.waitForTimeout(3000);
    
    // Find and click the Demo button via accessibility tree
    const demoButton = page.getByRole('button', { name: /demo/i }).first();
    
    await expect(demoButton).toBeVisible({ timeout: 10000 });
    await demoButton.click();
    
    // Wait for navigation to complete and home screen to load
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    
    // Check that at least one navigation item is visible via accessibility tree
    const firstMenuItem = page.getByRole('button', { name: /ai jobs/i });
    await expect(firstMenuItem.first()).toBeVisible({ timeout: 10000 });
  });

  test('should display all navigation menu items in demo mode', async ({ page }) => {
    // Wait for Flutter to initialize
    await page.waitForTimeout(3000);
    
    // Enter demo mode via accessibility tree
    const demoButton = page.getByRole('button', { name: /demo/i }).first();
    await demoButton.click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    
    // Check that each navigation item is visible via accessibility tree
    for (const item of menuItems) {
      const menuItem = page.getByRole('button', { name: new RegExp(item.label, 'i') });
      await expect(menuItem.first()).toBeVisible({ timeout: 5000 });
    }
  });

  test('should navigate through all menu items', async ({ page }) => {
    // Wait for Flutter to initialize
    await page.waitForTimeout(3000);
    
    // Enter demo mode via accessibility tree
    const demoButton = page.getByRole('button', { name: /demo/i }).first();
    await demoButton.click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    
    // Click on each menu item and verify navigation
    for (const item of menuItems) {
      console.log(`Testing navigation to: ${item.label}`);
      
      // Find and click the menu item via accessibility tree
      const menuItem = page.getByRole('button', { name: new RegExp(item.label, 'i') }).first();
      
      await expect(menuItem).toBeVisible({ timeout: 5000 });
      await menuItem.click();
      
      // Wait for the page to load
      await page.waitForLoadState('networkidle');
      await page.waitForTimeout(1000);
      
      // Verify URL changed (indicates successful navigation)
      const expectedPath = item.label.toLowerCase().replace(' ', '-');
      await expect(page).toHaveURL(new RegExp(`/${expectedPath}`, 'i'), { timeout: 5000 });
      
      console.log(`Successfully navigated to: ${item.label}`);
    }
  });

  test('should maintain accessibility labels on menu items', async ({ page }) => {
    // Wait for Flutter to initialize
    await page.waitForTimeout(3000);
    
    // Enter demo mode via accessibility tree
    const demoButton = page.getByRole('button', { name: /demo/i }).first();
    await demoButton.click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    
    // Check semantic labels for each menu item via accessibility tree
    for (const item of menuItems) {
      const menuItem = page.getByRole('button', { name: new RegExp(item.label, 'i') }).first();
      
      // Menu items should be visible and accessible
      await expect(menuItem).toBeVisible({ timeout: 5000 });
      
      // Verify the button has accessible name (via accessibility tree)
      const name = await menuItem.textContent();
      expect(name?.toLowerCase()).toContain(item.label.toLowerCase());
      
      console.log(`${item.label} is accessible with name: ${name}`);
    }
  });

  test('should handle keyboard navigation on menu items', async ({ page }) => {
    // Wait for Flutter to initialize
    await page.waitForTimeout(3000);
    
    // Enter demo mode via accessibility tree
    const demoButton = page.getByRole('button', { name: /demo/i }).first();
    await demoButton.click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    
    // Focus on the first menu item via accessibility tree
    const firstMenuItem = page.getByRole('button', { name: new RegExp(menuItems[0].label, 'i') }).first();
    
    await expect(firstMenuItem).toBeVisible({ timeout: 5000 });
    
    // Focus the element
    await firstMenuItem.focus();
    
    // Press Enter to activate
    await page.keyboard.press('Enter');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(500);
    
    // Verify URL changed (indicates successful navigation)
    const expectedPath = menuItems[0].label.toLowerCase().replace(' ', '-');
    await expect(page).toHaveURL(new RegExp(`/${expectedPath}`, 'i'));
    
    console.log('Keyboard navigation test passed');
  });

  test('should display theme toggle in header', async ({ page }) => {
    // Wait for Flutter to initialize
    await page.waitForTimeout(3000);
    
    // Enter demo mode via accessibility tree
    const demoButton = page.getByRole('button', { name: /demo/i }).first();
    await demoButton.click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    
    // Look for theme toggle button via accessibility tree
    const themeToggle = page.getByRole('button', { name: /toggle theme|switch to.*mode/i });
    
    // The theme toggle should be visible
    await expect(themeToggle.first()).toBeVisible({ timeout: 5000 });
    
    console.log('Theme toggle found');
  });
});

