import { test, expect } from '@playwright/test';
import { APP_BASE_URL } from './testEnv';

const APP_URL = APP_BASE_URL;

const HERO_BUTTON_LABELS = [
  'View installation instructions button',
  'Install DMTools Desktop now button',
  'View open source repository button',
];

/**
 * Test clicking the "Enable accessibility" button to expose Flutter's semantic tree
 */
test.describe('Enable Accessibility and Access Elements', () => {
  test('should click Enable Accessibility button and access hero CTAs', async ({ page }) => {
    await page.goto(APP_URL);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    console.log('\n📊 Step 1: Check initial accessibility tree...');
    let snapshot = await page.accessibility.snapshot();
    console.log('Initial tree:', JSON.stringify(snapshot, null, 2));
    
    // Find and click the "Enable accessibility" button
    console.log('\n🔘 Step 2: Looking for "Enable accessibility" button...');
    const enableButton = page.getByRole('button', { name: 'Enable accessibility' });
    const count = await enableButton.count();
    console.log(`Found ${count} "Enable accessibility" button(s)`);
    
    if (count > 0) {
      console.log('✅ Clicking "Enable accessibility" button...');
      await enableButton.click();
      
      // Wait for semantics to populate
      await page.waitForTimeout(2000);
      
      console.log('\n📊 Step 3: Check accessibility tree AFTER enabling...');
      snapshot = await page.accessibility.snapshot();
      
      // Pretty print the tree
      function printTree(node: any, indent = 0) {
        if (!node) return;
        
        const prefix = '  '.repeat(indent);
        const name = node.name || '(no name)';
        const role = node.role || '(no role)';
        console.log(`${prefix}${role}: "${name}"`);
        
        if (node.children) {
          for (const child of node.children) {
            printTree(child, indent + 1);
          }
        }
      }
      
      console.log('\n=== ACCESSIBILITY TREE AFTER ENABLING ===');
      printTree(snapshot);
      console.log('========================================\n');
      
      // Now look for hero CTA buttons
      console.log('🔍 Step 4: Searching for hero CTA buttons...');
      
      function findInTree(node: any, searchTerm: string, results: any[] = []): any[] {
        if (!node) return results;
        
        if (node.name?.toLowerCase().includes(searchTerm.toLowerCase())) {
          results.push(node);
        }
        
        if (node.children) {
          for (const child of node.children) {
            findInTree(child, searchTerm, results);
          }
        }
        
        return results;
      }
      
      for (const label of HERO_BUTTON_LABELS) {
        const matches = findInTree(snapshot, label.replace(/button/i, '').trim());
        console.log(`Found ${matches.length} element(s) containing "${label}":`);
        matches.forEach(el => {
          console.log(`  - Role: ${el.role}, Name: "${el.name}"`);
        });
      }
      
      for (const label of HERO_BUTTON_LABELS) {
        const button = page.getByRole('button', { name: new RegExp(label, 'i') });
        const buttonCount = await button.count();
        console.log(`getByRole found ${buttonCount} "${label}" button(s)`);
        expect(buttonCount).toBeGreaterThan(0);
      }
      
      expect(snapshot).not.toBeNull();
    } else {
      console.log('ℹ️ Enable accessibility button not found; semantics likely auto-enabled');
      for (const label of HERO_BUTTON_LABELS) {
        const button = page.getByRole('button', { name: new RegExp(label, 'i') });
        await expect(button.first()).toBeVisible({ timeout: 10000 });
      }
    }
  });
  
  test('should navigate hero sections after enabling accessibility', async ({ page }) => {
    await page.goto(APP_URL);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    // Enable accessibility
    const enableButton = page.getByRole('button', { name: 'Enable accessibility' });
    if (await enableButton.count() > 0) {
      await enableButton.click();
      await page.waitForTimeout(2000);
    }
    
    const heroHeading = page.getByText(/Built to help you ship/i);
    await expect(heroHeading.first()).toBeVisible({ timeout: 10000 });
    
    const ctaHeading = page.getByText(/Get started in seconds/i);
    await ctaHeading.scrollIntoViewIfNeeded();
    await expect(ctaHeading.first()).toBeVisible({ timeout: 10000 });
    
    for (const label of HERO_BUTTON_LABELS) {
      const button = page.getByRole('button', { name: new RegExp(label, 'i') }).first();
      await expect(button).toBeVisible({ timeout: 10000 });
      await button.scrollIntoViewIfNeeded();
    }
    
    console.log('\n🎉 Hero sections verified via accessibility tree!');
  });
});

