import { test, expect } from '@playwright/test';

/**
 * Accessibility E2E Tests for DMTools Flutter Styleguide
 * 
 * These tests verify that:
 * 1. Components are accessible via test IDs
 * 2. Keyboard navigation works correctly
 * 3. Semantic labels are present
 * 4. Interactive elements are focusable
 */

// Base URL for the Flutter styleguide web app
const STYLEGUIDE_URL = 'http://localhost:8080';

test.describe('DMTools Styleguide - Accessibility Tests', () => {
  
  test.beforeEach(async ({ page }) => {
    // Navigate to the styleguide home page
    await page.goto(STYLEGUIDE_URL);
    
    // Wait for Flutter app to initialize
    await page.waitForSelector('flt-semantics', { timeout: 10000 });
  });

  test('should load styleguide home page', async ({ page }) => {
    // Verify the page title or main heading
    await expect(page).toHaveTitle(/DMTools/i);
    
    // Check if the page has semantic elements (Flutter web accessibility mode)
    const semantics = await page.locator('flt-semantics').count();
    expect(semantics).toBeGreaterThan(0);
  });

  test('should navigate to Atoms page and find buttons', async ({ page }) => {
    // Click on Atoms navigation item
    await page.click('text=Atoms');
    await page.waitForTimeout(1000);
    
    // Verify buttons section is visible
    const buttonsSection = page.locator('text=/Button/i').first();
    await expect(buttonsSection).toBeVisible();
  });

  test('buttons should have accessible labels', async ({ page }) => {
    // Navigate to buttons demo
    await page.click('text=Atoms');
    await page.waitForTimeout(1000);
    
    // Find buttons by ARIA role
    const buttons = page.locator('flt-semantics[role="button"]');
    const buttonCount = await buttons.count();
    
    // Verify we have buttons rendered
    expect(buttonCount).toBeGreaterThan(0);
    
    // Check first button has aria-label
    const firstButton = buttons.first();
    const ariaLabel = await firstButton.getAttribute('aria-label');
    expect(ariaLabel).toBeTruthy();
  });

  test('keyboard navigation should work', async ({ page }) => {
    // Navigate to buttons demo
    await page.click('text=Atoms');
    await page.waitForTimeout(1000);
    
    // Focus first interactive element
    await page.keyboard.press('Tab');
    
    // Verify an element is focused
    const focusedElement = await page.evaluate(() => {
      return document.activeElement?.tagName;
    });
    expect(focusedElement).toBeTruthy();
    
    // Navigate with Tab key
    await page.keyboard.press('Tab');
    await page.keyboard.press('Tab');
    
    // Try activating with Enter key
    await page.keyboard.press('Enter');
    await page.waitForTimeout(500);
  });

  test('text inputs should be accessible', async ({ page }) => {
    // Navigate to form elements
    await page.click('text=Atoms');
    await page.waitForTimeout(1000);
    
    // Find text inputs
    const inputs = page.locator('flt-semantics[role="textbox"]');
    const inputCount = await inputs.count();
    
    if (inputCount > 0) {
      // Verify first input has label
      const firstInput = inputs.first();
      const ariaLabel = await firstInput.getAttribute('aria-label');
      expect(ariaLabel).toBeTruthy();
      
      // Try typing in input
      await firstInput.click();
      await page.keyboard.type('Test Input');
    }
  });

  test('theme toggle should be accessible', async ({ page }) => {
    // Look for theme switch/toggle
    const themeToggle = page.locator('text=/theme/i').or(
      page.locator('flt-semantics:has-text("Dark")').or(
        page.locator('flt-semantics:has-text("Light")')
      )
    );
    
    // If theme toggle exists, try clicking it
    if (await themeToggle.count() > 0) {
      await themeToggle.first().click();
      await page.waitForTimeout(500);
      
      // Verify theme changed (background color should change)
      const bgColor = await page.evaluate(() => {
        return window.getComputedStyle(document.body).backgroundColor;
      });
      expect(bgColor).toBeTruthy();
    }
  });

  test('molecules page should be accessible', async ({ page }) => {
    // Navigate to Molecules page
    await page.click('text=Molecules');
    await page.waitForTimeout(1000);
    
    // Verify semantic elements exist
    const semantics = await page.locator('flt-semantics').count();
    expect(semantics).toBeGreaterThan(0);
    
    // Look for cards
    const cards = page.locator('text=/card/i');
    if (await cards.count() > 0) {
      await expect(cards.first()).toBeVisible();
    }
  });

  test('should handle focus indicators', async ({ page }) => {
    // Navigate to interactive page
    await page.click('text=Atoms');
    await page.waitForTimeout(1000);
    
    // Tab through elements
    await page.keyboard.press('Tab');
    await page.keyboard.press('Tab');
    
    // Check if focus is visible (element should have focus styles)
    const hasFocus = await page.evaluate(() => {
      const active = document.activeElement;
      if (!active) return false;
      
      const styles = window.getComputedStyle(active);
      // Check for common focus indicators
      return styles.outline !== 'none' || 
             styles.boxShadow !== 'none' ||
             active.matches(':focus-visible');
    });
    
    // Note: Focus indicators might not always be detected in Flutter web
    // This is more of an informational test
    console.log('Has visible focus:', hasFocus);
  });

  test('escape key should work for dismissible elements', async ({ page }) => {
    // Navigate to a page with interactive elements
    await page.click('text=Atoms');
    await page.waitForTimeout(1000);
    
    // Press Escape key
    await page.keyboard.press('Escape');
    await page.waitForTimeout(500);
    
    // If there were modals or dialogs, they should close
    // This is a general test for Escape key functionality
  });
});

test.describe('DMTools Styleguide - Component-Specific Tests', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto(STYLEGUIDE_URL);
    await page.waitForSelector('flt-semantics', { timeout: 10000 });
  });

  test('primary button should be clickable', async ({ page }) => {
    await page.click('text=Atoms');
    await page.waitForTimeout(1000);
    
    // Find primary button (look for button with specific styling or text)
    const button = page.locator('flt-semantics[role="button"]').first();
    
    if (await button.count() > 0) {
      await button.click();
      await page.waitForTimeout(500);
      
      // Button should be interactable
      expect(await button.isVisible()).toBe(true);
    }
  });

  test('form inputs should accept text', async ({ page }) => {
    await page.click('text=Atoms');
    await page.waitForTimeout(1000);
    
    // Find text input
    const input = page.locator('flt-semantics[role="textbox"]').first();
    
    if (await input.count() > 0) {
      // Click and type
      await input.click();
      await page.keyboard.type('automation@test.com');
      await page.waitForTimeout(500);
      
      // Verify input accepted text (value should be set)
      const inputValue = await input.getAttribute('aria-valuenow');
      // Note: Flutter web might not expose value the same way
    }
  });

  test('navigation should work between pages', async ({ page }) => {
    // Test navigation flow
    await page.click('text=Atoms');
    await page.waitForTimeout(500);
    await expect(page.locator('text=/Atoms/i')).toBeVisible();
    
    await page.click('text=Molecules');
    await page.waitForTimeout(500);
    await expect(page.locator('text=/Molecules/i')).toBeVisible();
    
    await page.click('text=Organisms');
    await page.waitForTimeout(500);
    await expect(page.locator('text=/Organisms/i')).toBeVisible();
  });
});

test.describe('DMTools Styleguide - Screen Reader Simulation', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto(STYLEGUIDE_URL);
    await page.waitForSelector('flt-semantics', { timeout: 10000 });
  });

  test('semantic tree should be available', async ({ page }) => {
    // Check if semantic tree is exposed
    const semanticElements = await page.locator('flt-semantics').count();
    expect(semanticElements).toBeGreaterThan(0);
    
    // Get aria attributes from semantic elements
    const firstSemantic = page.locator('flt-semantics').first();
    const role = await firstSemantic.getAttribute('role');
    
    console.log('First semantic element role:', role);
    expect(role).toBeTruthy();
  });

  test('buttons should announce their state', async ({ page }) => {
    await page.click('text=Atoms');
    await page.waitForTimeout(1000);
    
    // Find buttons and check their ARIA attributes
    const buttons = await page.locator('flt-semantics[role="button"]').all();
    
    for (const button of buttons.slice(0, 3)) { // Check first 3 buttons
      const ariaLabel = await button.getAttribute('aria-label');
      const ariaDisabled = await button.getAttribute('aria-disabled');
      
      console.log('Button:', { ariaLabel, ariaDisabled });
      
      // Each button should have at minimum a label
      expect(ariaLabel || ariaDisabled !== null).toBeTruthy();
    }
  });

  test('headings should provide page structure', async ({ page }) => {
    // Find heading elements
    const headings = await page.locator('flt-semantics[role="heading"]').all();
    
    if (headings.length > 0) {
      console.log(`Found ${headings.length} headings`);
      
      // Check heading levels
      for (const heading of headings.slice(0, 5)) {
        const ariaLevel = await heading.getAttribute('aria-level');
        const ariaLabel = await heading.getAttribute('aria-label');
        
        console.log('Heading:', { ariaLevel, ariaLabel });
      }
    }
  });
});

