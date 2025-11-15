import { test, expect, Page } from '@playwright/test';
import { APP_BASE_URL } from './testEnv';

const HERO_BUTTON_LABELS = [
  'View installation instructions button',
  'Install DMTools Desktop now button',
  'View open source repository button',
];

const TERMINAL_COMMANDS = [
  'dmtools run business_analysis_agent',
  'dmtools run refinement_agent',
  'dmtools run solution_architecture_agent',
];

const CTA_BANNER_LABELS = [
  'View installation instructions button',
  'Install DMTools Desktop now button',
  'View open source repository button',
];

const INTEGRATION_HEADINGS = [
  'Project Management',
  'Code Base',
  'Collaboration & Communication',
  'AI Services',
];

async function navigateToLandingPage(page: Page) {
  await page.goto(APP_BASE_URL);
  await page.waitForLoadState('networkidle');
  await page.waitForSelector('flt-semantics', { timeout: 15000 });
}

test.describe('Main App - Landing Page Experience', () => {
  test.beforeEach(async ({ page }) => {
    await navigateToLandingPage(page);
  });

  test('should render hero question and CTA buttons', async ({ page }) => {
    const heroQuestion = page.getByText(/Is it easier to train/i).first();
    await expect(heroQuestion).toBeVisible({ timeout: 10000 });

    for (const label of HERO_BUTTON_LABELS) {
      const button = page.getByRole('button', { name: new RegExp(label, 'i') });
      await expect(button.first()).toBeVisible({ timeout: 10000 });
    }
  });

  test('should expose terminal simulation commands and CLI snippet', async ({ page }) => {
    for (const command of TERMINAL_COMMANDS) {
      const commandLocator = page.getByText(new RegExp(command, 'i')).first();
      await expect(commandLocator).toBeVisible({ timeout: 10000 });
    }

    const copyButton = page.getByRole('button', { name: /Copy/i }).first();
    await expect(copyButton).toBeVisible({ timeout: 10000 });
  });

  test('should display CTA banner actions for installs and docs', async ({ page }) => {
    const bannerHeading = page.getByText(/Get started in seconds/i).first();
    await bannerHeading.scrollIntoViewIfNeeded();
    await expect(bannerHeading).toBeVisible({ timeout: 10000 });

    for (const label of CTA_BANNER_LABELS) {
      const button = page.getByRole('button', { name: new RegExp(label, 'i') }).first();
      await button.scrollIntoViewIfNeeded();
      await expect(button).toBeVisible({ timeout: 10000 });
    }
  });

  test('should list integration categories with accessible headings', async ({ page }) => {
    const integrationsHeading = page.getByText(/Available Integrations/i).first();
    await integrationsHeading.scrollIntoViewIfNeeded();
    await expect(integrationsHeading).toBeVisible({ timeout: 10000 });

    for (const heading of INTEGRATION_HEADINGS) {
      const headingLocator = page.getByText(new RegExp(`^${heading}$`, 'i')).first();
      await headingLocator.scrollIntoViewIfNeeded();
      await expect(headingLocator).toBeVisible({ timeout: 10000 });
    }
  });

  test('should display rivers section and FAQ accordion content', async ({ page }) => {
    const riversHeading = page.getByText(/Built for every enterprise SDLC/i).first();
    await riversHeading.scrollIntoViewIfNeeded();
    await expect(riversHeading).toBeVisible({ timeout: 10000 });

    const faqHeading = page.getByText(/Frequently asked questions/i).first();
    await faqHeading.scrollIntoViewIfNeeded();
    await expect(faqHeading).toBeVisible({ timeout: 10000 });

    const faqQuestion = page.getByText('Who can access DMTools?').first();
    await faqQuestion.scrollIntoViewIfNeeded();
    await faqQuestion.click();

    const faqAnswer = page.getByText(/DMTools is open source and available to all people/i).first();
    await expect(faqAnswer).toBeVisible({ timeout: 10000 });
  });
});

