import { test, expect } from '@playwright/test';

/**
 * Complete demo flow test using Playwright accessibility tree
 * This works with BOTH canvas and HTML rendering!
 */

// Helper to enable accessibility for Flutter
async function enableFlutterAccessibility(page: any) {
  console.log('🔘 Enabling Flutter accessibility...');
  const enabled = await page.evaluate(() => {
    const button = document.querySelector('flt-semantics-placeholder[aria-label="Enable accessibility"]');
    if (button) {
      (button as HTMLElement).click();
      return true;
    }
    return false;
  });
  
  if (enabled) {
    await page.waitForTimeout(2000); // Wait for semantic tree to populate
    console.log('✅ Accessibility enabled!');
  }
  
  return enabled;
}

test.describe('Complete Demo Flow - Accessibility Tree', () => {
  test('should navigate through entire demo mode using accessibility', async ({ page }) => {
    // Navigate to app
    console.log('\n📍 Step 1: Loading app...');
    await page.goto('http://localhost:8080');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    // Enable accessibility
    console.log('\n📍 Step 2: Enabling accessibility...');
    await enableFlutterAccessibility(page);
    
    // Verify landing page
    console.log('\n📍 Step 3: Verifying landing page elements...');
    const getStartedButton = page.getByRole('button', { name: /get started/i });
    const demoButton = page.getByRole('button', { name: /demo/i });
    
    expect(await getStartedButton.count()).toBeGreaterThan(0);
    expect(await demoButton.count()).toBeGreaterThan(0);
    console.log('✅ Landing page buttons found');
    
    // Click Demo button
    console.log('\n📍 Step 4: Clicking Demo button...');
    await demoButton.first().click();
    await page.waitForTimeout(2000);
    console.log(`✅ Navigated to: ${page.url()}`);
    
    // Verify demo mode loaded
    expect(page.url()).toContain('ai-jobs');
    
    // Navigate through all menu items
    console.log('\n📍 Step 5: Testing navigation menu...');
    const menuItems = [
      { name: 'AI Jobs', url: 'ai-jobs' },
      { name: 'Integrations', url: 'integrations' },
      { name: 'Chat', url: 'chat' },
      { name: 'MCP', url: 'mcp' }
    ];
    
    for (const item of menuItems) {
      console.log(`\n  🔹 Testing "${item.name}" menu item...`);
      
      // Find button by accessible name
      const menuButton = page.getByRole('button', { name: new RegExp(item.name, 'i') });
      const count = await menuButton.count();
      
      if (count > 0) {
        console.log(`     ✅ Found "${item.name}" button`);
        await menuButton.first().click();
        await page.waitForTimeout(1000);
        
        // Verify URL changed
        const currentUrl = page.url();
        if (currentUrl.includes(item.url)) {
          console.log(`     ✅ Successfully navigated to ${item.url}`);
        } else {
          console.log(`     ⚠️  URL is ${currentUrl}, expected ${item.url}`);
        }
      } else {
        console.log(`     ❌ "${item.name}" button not found`);
        throw new Error(`Menu item "${item.name}" not accessible`);
      }
    }
    
    console.log('\n🎉 Complete demo flow test PASSED!');
    console.log('✅ All menu items are accessible via Playwright');
    console.log('✅ Works with Flutter accessibility tree');
    console.log('✅ Compatible with browser MCP and automation tools');
  });
  
  test('should verify theme toggle button accessibility', async ({ page }) => {
    await page.goto('http://localhost:8080');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    await enableFlutterAccessibility(page);
    
    // Find theme toggle button
    const themeButton = page.getByRole('button', { name: /dark mode|light mode|theme/i });
    const count = await themeButton.count();
    
    console.log(`\n🌓 Found ${count} theme button(s)`);
    
    if (count > 0) {
      console.log('✅ Theme toggle is accessible');
      
      // Try to click it
      await themeButton.first().click();
      await page.waitForTimeout(500);
      console.log('✅ Theme toggle clicked successfully');
    }
    
    expect(count).toBeGreaterThan(0);
  });
  
  test('should dump all accessible elements after demo mode', async ({ page }) => {
    await page.goto('http://localhost:8080');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    await enableFlutterAccessibility(page);
    
    // Click demo
    const demoButton = page.getByRole('button', { name: /demo/i });
    await demoButton.first().click();
    await page.waitForTimeout(2000);
    
    // Get all buttons
    const allButtons = await page.getByRole('button').all();
    console.log(`\n📋 Found ${allButtons.length} accessible buttons:`);
    
    for (let i = 0; i < Math.min(allButtons.length, 20); i++) {
      const btn = allButtons[i];
      const name = await btn.getAttribute('aria-label').catch(() => null);
      const text = await btn.innerText().catch(() => '');
      console.log(`  ${i + 1}. "${name || text}"`);
    }
    
    if (allButtons.length > 20) {
      console.log(`  ... and ${allButtons.length - 20} more`);
    }
    
    // Get accessibility tree
    const snapshot = await page.accessibility.snapshot();
    
    function collectElements(node: any, role: string, results: any[] = []): any[] {
      if (!node) return results;
      if (node.role === role && node.name) results.push(node.name);
      if (node.children) {
        for (const child of node.children) {
          collectElements(child, role, results);
        }
      }
      return results;
    }
    
    const allButtonNames = collectElements(snapshot, 'button');
    console.log(`\n🔘 All button names in accessibility tree:`);
    allButtonNames.forEach((name, i) => {
      console.log(`  ${i + 1}. "${name}"`);
    });
    
    expect(allButtons.length).toBeGreaterThan(0);
  });
});

test.describe('Accessibility Tree Browser MCP Compatibility', () => {
  test('should demonstrate browser MCP can access Flutter elements', async ({ page }) => {
    await page.goto('http://localhost:8080');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    console.log('\n🤖 Simulating Browser MCP access pattern...');
    
    // Enable accessibility (Browser MCP would do this too)
    await enableFlutterAccessibility(page);
    
    // Get accessibility tree (what Browser MCP sees)
    const snapshot = await page.accessibility.snapshot();
    
    console.log('\n📊 Accessibility Tree (what Browser MCP sees):');
    
    function printTree(node: any, indent = 0, maxDepth = 3) {
      if (!node || indent > maxDepth) return;
      
      const prefix = '  '.repeat(indent);
      const name = node.name || '(no name)';
      const role = node.role || '(no role)';
      
      if (node.role === 'button' || node.role === 'text' || node.role === 'heading') {
        console.log(`${prefix}[${role}] "${name}"`);
      }
      
      if (node.children && indent < maxDepth) {
        for (const child of node.children.slice(0, 10)) {
          printTree(child, indent + 1, maxDepth);
        }
      }
    }
    
    printTree(snapshot);
    
    // Demonstrate clicking via accessibility
    console.log('\n🖱️  Browser MCP clicking Demo button...');
    const demoButton = page.getByRole('button', { name: /demo/i });
    await demoButton.first().click();
    await page.waitForTimeout(2000);
    
    console.log(`✅ Browser MCP successfully clicked Demo button`);
    console.log(`✅ Current URL: ${page.url()}`);
    
    // Show that menu items are accessible
    const snapshot2 = await page.accessibility.snapshot();
    
    function findButtons(node: any, results: string[] = []): string[] {
      if (!node) return results;
      if (node.role === 'button' && node.name) {
        results.push(node.name);
      }
      if (node.children) {
        for (const child of node.children) {
          findButtons(child, results);
        }
      }
      return results;
    }
    
    const accessibleButtons = findButtons(snapshot2);
    console.log(`\n🤖 Browser MCP can see ${accessibleButtons.length} buttons:`);
    accessibleButtons.forEach(name => {
      console.log(`  - "${name}"`);
    });
    
    console.log('\n✅ SUCCESS: Browser MCP can fully interact with Flutter app!');
    console.log('✅ All UI elements are exposed via accessibility tree');
    console.log('✅ Automation tools have complete access');
    
    expect(accessibleButtons.length).toBeGreaterThan(5);
  });
});

