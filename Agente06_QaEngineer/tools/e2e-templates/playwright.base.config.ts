/**
 * Playwright Base Configuration Template
 *
 * Uso:
 *   import { baseConfig } from './playwright.base.config';
 *   export default defineConfig({ ...baseConfig, baseURL: 'https://...' });
 *
 * CUSTOMIZAR: override baseURL, adicionar browsers, ajustar timeouts
 *
 * Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/shared/templates/e2e
 */
import { defineConfig, devices } from '@playwright/test';
import path from 'path';

const AUTH_FILE = path.join(__dirname, '../../../.auth/user.json');

export const baseConfig = defineConfig({
  testDir: './tests/e2e',
  timeout: 60_000,
  expect: { timeout: 10_000 },

  // Execucao paralela; CI usa 1 worker para evitar flakiness
  fullyParallel: true,
  workers: process.env.CI ? 1 : undefined,
  retries: process.env.CI ? 2 : 0,

  // Reports: HTML sempre + GitHub actions em CI
  reporter: process.env.CI
    ? [
        ['github'],
        ['html', { outputFolder: 'playwright-report', open: 'never' }],
      ]
    : [['html', { open: 'on-failure' }]],

  use: {
    viewport: { width: 1280, height: 720 },
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    // CUSTOMIZAR: adicionar baseURL do projeto
    // baseURL: process.env.BASE_URL ?? 'http://localhost:3000',
  },

  projects: [
    // Setup: cria .auth/user.json com sessao autenticada
    {
      name: 'setup',
      testMatch: /auth-setup\.ts/,
    },

    // Chromium: testes principais com autenticacao
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        storageState: AUTH_FILE,
      },
      dependencies: ['setup'],
      testIgnore: /smoke\.spec\.ts/,
    },

    // Smoke: verificacao pos-deploy sem autenticacao
    {
      name: 'smoke',
      use: { ...devices['Desktop Chrome'] },
      testMatch: /smoke\.spec\.ts/,
      timeout: 30_000,
    },

    // CUSTOMIZAR: adicionar outros browsers se necessario
    // { name: 'firefox', use: { ...devices['Desktop Firefox'], storageState: AUTH_FILE }, dependencies: ['setup'] },
    // { name: 'mobile', use: { ...devices['iPhone 13'], storageState: AUTH_FILE }, dependencies: ['setup'] },
  ],
});

export default baseConfig;
