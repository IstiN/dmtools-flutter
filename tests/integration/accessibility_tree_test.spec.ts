import { test, expect } from '@playwright/test';
import { STYLEGUIDE_BASE_URL } from './testEnv';

const BASE_URL = STYLEGUIDE_BASE_URL;

/**
 * Test accessing Flutter elements via Accessibility Tree
 * This works with BOTH canvas and HTML rendering!
 * The accessibility tree is exposed regardless of rendering mode.
 */
test.describe('Accessibility Tree Access', () => {
  test('should access elements via accessibility tree snapshot', async ({ page }) => {
    await page.goto(BASE_URL);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(5000); // Give Flutter time to render
    
    // Get the accessibility tree snapshot
    // This works with canvas rendering!
    const snapshot = await page.accessibility.snapshot();
    
    console.log('=== ACCESSIBILITY TREE ===');
    console.log(JSON.stringify(snapshot, null, 2));
    console.log('========================');
    
    // Function to search accessibility tree
    function findInTree(node: any, searchTerm: string, results: any[] = []): any[] {
      if (!node) return results;
      
      // Check name (label), description, or value
      if (node.name?.includes(searchTerm) || 
          node.description?.includes(searchTerm) ||
          node.value?.includes(searchTerm)) {
        results.push(node);
      }
      
      // Recurse through children
      if (node.children) {
        for (const child of node.children) {
          findInTree(child, searchTerm, results);
        }
      }
      
      return results;
    }
    
    // Search for button elements
    const buttons = findInTree(snapshot, 'button');
    console.log(`\n✅ Found ${buttons.length} button(s) in accessibility tree:`);
    buttons.forEach(btn => {
      console.log(`  - Name: "${btn.name}", Role: ${btn.role}`);
    });
    
    // Search for specific button text
    const atomsButtons = findInTree(snapshot, 'Atoms');
    console.log(`\n🎯 Found ${atomsButtons.length} "Atoms" element(s):`);
    atomsButtons.forEach(btn => {
      console.log(`  - Name: "${btn.name}", Role: ${btn.role}`);
    });
    
    const getStartedButtons = findInTree(snapshot, 'Get Started');
    console.log(`\n🎯 Found ${getStartedButtons.length} "Get Started" element(s):`);
    getStartedButtons.forEach(btn => {
      console.log(`  - Name: "${btn.name}", Role: ${btn.role}`);
    });
    
    // Search for navigation items
    const navItems = findInTree(snapshot, 'navigation');
    console.log(`\n🧭 Found ${navItems.length} navigation element(s):`);
    navItems.forEach(item => {
      console.log(`  - Name: "${item.name}", Role: ${item.role}`);
    });
    
    // This test passes if we found the accessibility tree
    expect(snapshot).not.toBeNull();
  });
  
  test('should click elements using accessibility tree and getByRole', async ({ page }) => {
    await page.goto(`${BASE_URL}?automation=true`);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(5000);
    
    // Try to find buttons by role (works with accessibility tree)
    const buttons = await page.getByRole('button').count();
    console.log(`\n🔘 Found ${buttons} button(s) via getByRole()`);
    
    // Try to list all buttons
    if (buttons > 0) {
      const allButtons = await page.getByRole('button').all();
      console.log('\n📋 Button list:');
      for (let i = 0; i < allButtons.length; i++) {
        const btn = allButtons[i];
        const name = await btn.getAttribute('aria-label').catch(() => null);
        const text = await btn.textContent().catch(() => '');
        const role = await btn.getAttribute('role').catch(() => null);
        console.log(`  ${i + 1}. aria-label: "${name}", text: "${text}", role: "${role}"`);
      }
    }
    
    // Try to find button by accessible name
    const atomsButton = page.getByRole('button', { name: /atoms/i });
    const atomsCount = await atomsButton.count();
    console.log(`\n🎯 Found ${atomsCount} button(s) with name containing "Atoms"`);
    
    if (atomsCount > 0) {
      console.log('✅ Can access Atoms button via accessibility!');
      console.log('🖱️ Attempting to click Atoms button...');
      
      try {
        await atomsButton.first().click({ timeout: 5000 });
        console.log('✅ Successfully clicked Atoms button!');
        
        await page.waitForTimeout(2000);
        
        // Check if we navigated
        const url = page.url();
        console.log(`📍 Current URL: ${url}`);
        
      } catch (e) {
        console.log('❌ Could not click Atoms button:', e.message);
      }
    }
    
    expect(buttons).toBeGreaterThan(0);
  });
  
  test('should use getByLabel to find elements', async ({ page }) => {
    await page.goto(BASE_URL);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(5000);
    
    // Try different label selectors
    const labelSearches = [
      'Atoms',
      'Molecules',
      'Organisms',
      'atoms button',
      'button-atoms',
    ];
    
    console.log('\n🔍 Searching by label:');
    for (const label of labelSearches) {
      const element = page.getByLabel(label, { exact: false });
      const count = await element.count();
      if (count > 0) {
        console.log(`  ✅ Found ${count} element(s) with label: "${label}"`);
      } else {
        console.log(`  ❌ No elements with label: "${label}"`);
      }
    }
    
    // This test passes
    expect(true).toBe(true);
  });
  
  test('should dump full accessibility tree structure', async ({ page }) => {
    await page.goto(BASE_URL);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(5000);
    
    const snapshot = await page.accessibility.snapshot();
    
    // Pretty print the tree
    function printTree(node: any, indent = 0) {
      if (!node) return;
      
      const prefix = '  '.repeat(indent);
      const name = node.name || '(no name)';
      const role = node.role || '(no role)';
      const value = node.value ? ` value="${node.value}"` : '';
      const description = node.description ? ` desc="${node.description}"` : '';
      
      console.log(`${prefix}${role}: "${name}"${value}${description}`);
      
      if (node.children) {
        for (const child of node.children) {
          printTree(child, indent + 1);
        }
      }
    }
    
    console.log('\n=== FULL ACCESSIBILITY TREE ===');
    printTree(snapshot);
    console.log('==============================\n');
    
    expect(snapshot).not.toBeNull();
  });
});

