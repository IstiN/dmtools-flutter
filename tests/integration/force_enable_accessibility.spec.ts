import { test, expect } from '@playwright/test';

/**
 * Force enable accessibility by directly clicking the element via JavaScript
 */
test.describe('Force Enable Accessibility', () => {
  test('should force click Enable Accessibility button via JavaScript', async ({ page }) => {
    await page.goto('http://localhost:8080');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(3000);
    
    console.log('\n📊 Step 1: Check initial accessibility tree...');
    let snapshot = await page.accessibility.snapshot();
    console.log(`Initial tree has ${JSON.stringify(snapshot).length} characters`);
    
    // Find the enable accessibility button in DOM
    console.log('\n🔘 Step 2: Force clicking "Enable accessibility" button via JavaScript...');
    const clicked = await page.evaluate(() => {
      const button = document.querySelector('flt-semantics-placeholder[aria-label="Enable accessibility"]');
      if (button) {
        console.log('Found button, clicking...');
        (button as HTMLElement).click();
        return true;
      }
      return false;
    });
    
    console.log(`JavaScript click result: ${clicked}`);
    
    if (clicked) {
      // Wait for semantics to populate
      console.log('⏳ Waiting for semantic tree to populate...');
      await page.waitForTimeout(3000);
      
      console.log('\n📊 Step 3: Check accessibility tree AFTER enabling...');
      snapshot = await page.accessibility.snapshot();
      
      // Pretty print the tree
      function printTree(node: any, indent = 0, maxDepth = 5) {
        if (!node || indent > maxDepth) return;
        
        const prefix = '  '.repeat(indent);
        const name = node.name || '(no name)';
        const role = node.role || '(no role)';
        console.log(`${prefix}${role}: "${name}"`);
        
        if (node.children && indent < maxDepth) {
          for (const child of node.children.slice(0, 20)) { // Limit to first 20 children
            printTree(child, indent + 1, maxDepth);
          }
          if (node.children.length > 20) {
            console.log(`${prefix}  ... and ${node.children.length - 20} more children`);
          }
        }
      }
      
      console.log('\n=== ACCESSIBILITY TREE AFTER ENABLING ===');
      printTree(snapshot);
      console.log('========================================\n');
      
      // Search for elements
      function findInTree(node: any, searchTerm: string, results: any[] = [], maxResults = 50): any[] {
        if (!node || results.length >= maxResults) return results;
        
        if (node.name?.toLowerCase().includes(searchTerm.toLowerCase())) {
          results.push(node);
        }
        
        if (node.children) {
          for (const child of node.children) {
            if (results.length >= maxResults) break;
            findInTree(child, searchTerm, results, maxResults);
          }
        }
        
        return results;
      }
      
      console.log('🔍 Step 4: Searching for UI elements...\n');
      
      const searches = ['demo', 'get started', 'AI Jobs', 'Integrations', 'Chat', 'MCP'];
      for (const term of searches) {
        const elements = findInTree(snapshot, term);
        if (elements.length > 0) {
          console.log(`✅ Found ${elements.length} element(s) containing "${term}":`);
          elements.slice(0, 3).forEach(el => {
            console.log(`   - Role: ${el.role}, Name: "${el.name}"`);
          });
        } else {
          console.log(`❌ No elements found for "${term}"`);
        }
      }
      
      // Try to interact with Demo button
      console.log('\n🖱️  Step 5: Attempting to click Demo button...');
      
      const demoButton = page.getByRole('button', { name: /demo/i });
      const demoCount = await demoButton.count();
      console.log(`getByRole found ${demoCount} Demo button(s)`);
      
      if (demoCount > 0) {
        try {
          await demoButton.first().click({ timeout: 5000 });
          console.log('✅ Successfully clicked Demo button via getByRole!');
          
          await page.waitForTimeout(2000);
          
          // Check if we navigated
          const url = page.url();
          console.log(`📍 Current URL: ${url}`);
          
          // Get new accessibility tree
          console.log('\n🧭 Checking for navigation menu...');
          const navSnapshot = await page.accessibility.snapshot();
          
          const navItems = findInTree(navSnapshot, 'navigation');
          const aiJobs = findInTree(navSnapshot, 'AI Jobs');
          
          console.log(`Found ${navItems.length} navigation element(s)`);
          console.log(`Found ${aiJobs.length} "AI Jobs" element(s)`);
          
          if (aiJobs.length > 0) {
            console.log('\n🎉 SUCCESS! Demo mode activated and menu is accessible!');
            
            // Try clicking a menu item
            const aiJobsButton = page.getByRole('button', { name: /AI Jobs/i });
            if (await aiJobsButton.count() > 0) {
              console.log('\n🖱️  Clicking AI Jobs menu item...');
              await aiJobsButton.first().click({ timeout: 5000 });
              await page.waitForTimeout(1000);
              console.log(`✅ Clicked AI Jobs, URL: ${page.url()}`);
            }
          }
        } catch (e: any) {
          console.log(`❌ Could not click Demo button: ${e.message}`);
        }
      } else {
        // Try to find it manually in the tree and click via coordinates
        const demoElements = findInTree(snapshot, 'demo');
        if (demoElements.length > 0) {
          console.log('\n⚠️  Demo button found in tree but not via getByRole');
          console.log('Attempting to click via JavaScript...');
          
          // Try to find and click the button element
          const jsClicked = await page.evaluate(() => {
            // Find all elements with "demo" in aria-label or text
            const elements = Array.from(document.querySelectorAll('[aria-label*="emo"], [aria-label*="Demo"]'));
            for (const el of elements) {
              console.log('Found element with aria-label:', (el as HTMLElement).getAttribute('aria-label'));
              (el as HTMLElement).click();
              return true;
            }
            return false;
          });
          
          if (jsClicked) {
            console.log('✅ Clicked Demo via JavaScript!');
            await page.waitForTimeout(2000);
            console.log(`📍 URL: ${page.url()}`);
          }
        }
      }
      
      expect(snapshot).not.toBeNull();
    } else {
      console.log('❌ Could not find Enable accessibility button');
      expect(clicked).toBe(true);
    }
  });
});

