import { test, expect, Page } from '@playwright/test';
import { APP_BASE_URL } from './testEnv';

const APP_URL = APP_BASE_URL;

const HERO_BUTTON_LABELS = [
  'View installation instructions button',
  'Install DMTools Desktop now button',
  'View open source repository button',
];

async function enableFlutterAccessibility(page: Page) {
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
    await page.waitForTimeout(2000);
    console.log('✅ Accessibility enabled!');
  }

  return enabled;
}

test.describe('Landing Page Accessibility Tree', () => {
  test('should expose hero CTA buttons via accessibility tree', async ({ page }) => {
    console.log('\n📍 Loading landing page...');
    await page.goto(APP_URL);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    await enableFlutterAccessibility(page);

    const heroQuestion = page.getByText(/Is it easier to train/i).first();
    await expect(heroQuestion).toBeVisible({ timeout: 10000 });
    console.log('✅ Hero question detected');

    for (const label of HERO_BUTTON_LABELS) {
      const button = page.getByRole('button', { name: new RegExp(label, 'i') });
      const count = await button.count();
      console.log(`🔍 "${label}" → ${count} match(es)`);
      expect(count).toBeGreaterThan(0);
    }

    console.log('🎉 Hero CTA buttons are accessible!');
  });

  test('should verify theme toggle button accessibility', async ({ page }) => {
    await page.goto(APP_URL);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    await enableFlutterAccessibility(page);

    const themeButton = page.getByRole('button', { name: /dark mode|light mode|theme/i });
    const count = await themeButton.count();
    console.log(`\n🌓 Found ${count} theme toggle button(s)`);

    if (count > 0) {
      await themeButton.first().click();
      await page.waitForTimeout(500);
      console.log('✅ Theme toggle clicked successfully');
    }

    expect(count).toBeGreaterThan(0);
  });

  test('should dump hero accessible elements for debugging', async ({ page }) => {
    await page.goto(APP_URL);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);
    await enableFlutterAccessibility(page);

    const allButtons = await page.getByRole('button').all();
    console.log(`\n📋 Found ${allButtons.length} accessible buttons on landing page:`);

    for (let i = 0; i < Math.min(allButtons.length, 20); i++) {
      const btn = allButtons[i];
      const name = await btn.getAttribute('aria-label').catch(() => null);
      const text = await btn.innerText().catch(() => '');
      console.log(`  ${i + 1}. "${name || text}"`);
    }

    if (allButtons.length > 20) {
      console.log(`  ... and ${allButtons.length - 20} more`);
    }

    const snapshot = await page.accessibility.snapshot();
    const buttonNames: string[] = [];

    function collectButtons(node: any) {
      if (!node) return;
      if (node.role === 'button' && node.name) {
        buttonNames.push(node.name);
      }
      if (node.children) {
        for (const child of node.children) {
          collectButtons(child);
        }
      }
    }

    collectButtons(snapshot);
    console.log('\n🔘 Accessibility tree button names:');
    buttonNames.forEach((name, i) => console.log(`  ${i + 1}. "${name}"`));

    expect(allButtons.length).toBeGreaterThan(0);
  });
});

test.describe('Accessibility Tree Browser MCP Compatibility', () => {
  test('should demonstrate Browser MCP can click Install Desktop CTA', async ({ page }) => {
    await page.goto(APP_URL);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000);

    console.log('\n🤖 Simulating Browser MCP access pattern...');
    await enableFlutterAccessibility(page);

    const snapshot = await page.accessibility.snapshot();

    function printTree(node: any, indent = 0, maxDepth = 3) {
      if (!node || indent > maxDepth) return;
      const prefix = '  '.repeat(indent);
      const name = node.name || '(no name)';
      const role = node.role || '(no role)';
      if (['button', 'text', 'heading'].includes(role)) {
        console.log(`${prefix}[${role}] "${name}"`);
      }
      if (node.children && indent < maxDepth) {
        for (const child of node.children.slice(0, 10)) {
          printTree(child, indent + 1, maxDepth);
        }
      }
    }

    console.log('\n📊 Accessibility Tree (summary):');
    printTree(snapshot);

    const installButton = page.getByRole('button', { name: /Install DMTools Desktop now button/i });
    await expect(installButton.first()).toBeVisible({ timeout: 10000 });
    await installButton.first().click();
    await page.waitForTimeout(1000);
    console.log('✅ Browser MCP successfully clicked Install Desktop CTA');

    const snapshotAfterClick = await page.accessibility.snapshot();
    const buttonNames: string[] = [];

    function findButtons(node: any) {
      if (!node) return;
      if (node.role === 'button' && node.name) {
        buttonNames.push(node.name);
      }
      if (node.children) {
        for (const child of node.children) {
          findButtons(child);
        }
      }
    }

    findButtons(snapshotAfterClick);
    console.log(`\n🤖 Browser MCP can see ${buttonNames.length} buttons after click:`);
    buttonNames.forEach(name => console.log(`  - "${name}"`));

    expect(buttonNames.length).toBeGreaterThan(5);
  });
});

