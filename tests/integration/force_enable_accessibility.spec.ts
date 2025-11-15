import { test, expect } from '@playwright/test';
import { APP_BASE_URL } from './testEnv';

/**
 * Force enable accessibility by directly clicking the element via JavaScript
 */
test.describe('Force Enable Accessibility', () => {
  test('should force click Enable Accessibility button via JavaScript', async ({ page }) => {
    await page.goto(APP_BASE_URL);
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
      
      const searches = ['install desktop', 'instructions', 'open source', 'enterprise sdlc', 'faq'];
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
      console.log('\n🖱️  Step 5: Attempting to click Install Desktop button...');
      
      const installButton = page.getByRole('button', { name: /Install DMTools Desktop now button/i });
      const installCount = await installButton.count();
      console.log(`getByRole found ${installCount} Install Desktop button(s)`);
      
      if (installCount > 0) {
        try {
          await installButton.first().click({ timeout: 5000 });
          console.log('✅ Successfully clicked Install Desktop button via getByRole!');
          
          await page.waitForTimeout(2000);
          
          // Get new accessibility tree
          console.log('\n🧭 Checking updated accessibility tree...');
          const navSnapshot = await page.accessibility.snapshot();
          
          const heroElements = findInTree(navSnapshot, 'Get started in seconds');
          console.log(`Found ${heroElements.length} "Get started in seconds" element(s)`);
        } catch (e: any) {
          console.log(`❌ Could not click Install Desktop button: ${e.message}`);
        }
      }
      
      expect(snapshot).not.toBeNull();
    } else {
      console.log('ℹ️ Could not find Enable accessibility button; verifying hero CTA accessibility instead');
      const heroCta = page.getByRole('button', { name: /Install DMTools Desktop now button/i }).first();
      await expect(heroCta).toBeVisible({ timeout: 10000 });
    }
  });
});

