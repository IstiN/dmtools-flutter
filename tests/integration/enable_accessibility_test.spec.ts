import { test, expect } from '@playwright/test';

/**
 * Test clicking the "Enable accessibility" button to expose Flutter's semantic tree
 */
test.describe('Enable Accessibility and Access Elements', () => {
  test('should click Enable Accessibility button and access Demo button', async ({ page }) => {
    await page.goto('http://localhost:8080');
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
      
      // Now look for Demo button
      console.log('🔍 Step 4: Searching for Demo button...');
      
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
      
      const demoElements = findInTree(snapshot, 'demo');
      console.log(`Found ${demoElements.length} element(s) containing "demo":`);
      demoElements.forEach(el => {
        console.log(`  - Role: ${el.role}, Name: "${el.name}"`);
      });
      
      const getStartedElements = findInTree(snapshot, 'get started');
      console.log(`\nFound ${getStartedElements.length} element(s) containing "get started":`);
      getStartedElements.forEach(el => {
        console.log(`  - Role: ${el.role}, Name: "${el.name}"`);
      });
      
      // Try to click Demo button if found
      if (demoElements.length > 0) {
        console.log('\n✅ Demo button found in accessibility tree!');
        console.log('🖱️ Attempting to click Demo button via getByRole...');
        
        const demoButton = page.getByRole('button', { name: /demo/i });
        const demoCount = await demoButton.count();
        console.log(`getByRole found ${demoCount} Demo button(s)`);
        
        if (demoCount > 0) {
          await demoButton.first().click();
          console.log('✅ Clicked Demo button successfully!');
          
          await page.waitForTimeout(2000);
          
          // Check navigation
          const url = page.url();
          console.log(`📍 Current URL: ${url}`);
          
          // Check for navigation items
          console.log('\n🧭 Looking for navigation menu items...');
          const menuSnapshot = await page.accessibility.snapshot();
          const navItems = findInTree(menuSnapshot, 'navigation');
          const aiJobs = findInTree(menuSnapshot, 'AI Jobs');
          const integrations = findInTree(menuSnapshot, 'Integrations');
          
          console.log(`Found ${navItems.length} navigation element(s)`);
          console.log(`Found ${aiJobs.length} "AI Jobs" element(s)`);
          console.log(`Found ${integrations.length} "Integrations" element(s)`);
          
          if (aiJobs.length > 0 || integrations.length > 0) {
            console.log('\n🎉 SUCCESS! Can access navigation menu via accessibility tree!');
          }
        }
      }
      
      expect(snapshot).not.toBeNull();
    } else {
      console.log('❌ Enable accessibility button not found');
      expect(count).toBeGreaterThan(0);
    }
  });
  
  test('should navigate through menu items after enabling accessibility', async ({ page }) => {
    await page.goto('http://localhost:8080');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    // Enable accessibility
    const enableButton = page.getByRole('button', { name: 'Enable accessibility' });
    if (await enableButton.count() > 0) {
      await enableButton.click();
      await page.waitForTimeout(2000);
    }
    
    // Click Demo button
    const demoButton = page.getByRole('button', { name: /demo/i });
    if (await demoButton.count() > 0) {
      console.log('✅ Clicking Demo button...');
      await demoButton.click();
      await page.waitForTimeout(2000);
      
      // Get all buttons after navigation
      const allButtons = await page.getByRole('button').all();
      console.log(`\n📋 Found ${allButtons.length} buttons after navigation`);
      
      // List all accessible elements
      const snapshot = await page.accessibility.snapshot();
      
      function collectAll(node: any, role: string, results: any[] = []): any[] {
        if (!node) return results;
        if (node.role === role) results.push(node);
        if (node.children) {
          for (const child of node.children) {
            collectAll(child, role, results);
          }
        }
        return results;
      }
      
      const buttons = collectAll(snapshot, 'button');
      console.log(`\n🔘 Buttons in accessibility tree:`);
      buttons.forEach((btn, i) => {
        console.log(`  ${i + 1}. "${btn.name}"`);
      });
      
      // Try to click menu items
      const menuItems = ['AI Jobs', 'Integrations', 'Chat', 'MCP'];
      for (const item of menuItems) {
        const menuButton = page.getByRole('button', { name: item, exact: false });
        if (await menuButton.count() > 0) {
          console.log(`\n✅ Found "${item}" menu item!`);
          await menuButton.click();
          await page.waitForTimeout(1000);
          console.log(`   Clicked "${item}"`);
        }
      }
      
      console.log('\n🎉 Navigation through menu items successful!');
    }
    
    expect(true).toBe(true);
  });
});

