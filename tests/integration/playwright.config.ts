import { defineConfig, devices } from '@playwright/test';
import { APP_BASE_URL, STYLEGUIDE_BASE_URL, APP_PORT, STYLEGUIDE_PORT } from './testEnv';

/**
 * Playwright configuration for integration tests
 * See https://playwright.dev/docs/test-configuration.
 */
export default defineConfig({
  testDir: '.',
  
  /* Run tests in files in parallel */
  fullyParallel: true,
  
  /* Fail the build on CI if you accidentally left test.only in the source code. */
  forbidOnly: !!process.env.CI,
  
  /* Retry on CI only */
  retries: process.env.CI ? 2 : 0,
  
  /* Opt out of parallel tests on CI. */
  workers: process.env.CI ? 1 : undefined,
  
  /* Reporter to use. See https://playwright.dev/docs/test-reporters */
  reporter: process.env.CI ? 'html' : 'list',
  
  /* Shared settings for all the projects below. See https://playwright.dev/docs/api/class-testoptions. */
  use: {
    /* Base URL to use in actions like `await page.goto('/')`. */
    baseURL: APP_BASE_URL,
    
    /* Collect trace when retrying the failed test. See https://playwright.dev/docs/trace-viewer */
    trace: 'on-first-retry',
    
    /* Screenshot on failure */
    screenshot: 'only-on-failure',
    
    /* Video on failure */
    video: 'retain-on-failure',
  },

  /* Configure projects for major browsers */
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],

  /* Run your local dev server before starting the tests (only in local development) */
  webServer: process.env.CI
      ? undefined
      : [
          {
            command: `bash -lc "cd /Users/Uladzimir_Klyshevich/git/dmtools/dmtools-flutter/flutter_styleguide && flutter run -d web-server --web-port=${STYLEGUIDE_PORT} --web-experimental-hot-reload"`,
            url: STYLEGUIDE_BASE_URL,
            reuseExistingServer: true,
            timeout: 180 * 1000,
            stdout: 'ignore',
            stderr: 'pipe',
          },
          {
            command: `bash -lc "cd /Users/Uladzimir_Klyshevich/git/dmtools/dmtools-flutter && flutter run -d web-server --web-port=${APP_PORT} --web-experimental-hot-reload"`,
            url: APP_BASE_URL,
            reuseExistingServer: true,
            timeout: 180 * 1000,
            stdout: 'ignore',
            stderr: 'pipe',
          },
        ],
});

