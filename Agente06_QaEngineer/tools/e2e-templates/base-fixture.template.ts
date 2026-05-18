/**
 * Base Test Fixture — Playwright
 *
 * Estende o test base com captura automatica de erros:
 * - Console errors
 * - Page errors (uncaught exceptions)
 * - Failed network requests
 * - HTTP 5xx server errors
 *
 * CUSTOMIZAR: adicionar erros benignos do projeto em BENIGN_ERRORS
 *
 * Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/shared/templates/e2e
 */
import { test as base, expect } from '@playwright/test';

// CUSTOMIZAR: adicionar patterns de erros benignos do projeto
const BENIGN_ERRORS = [
  /WebSocket connection/,
  /DevTools/,
  /service worker/i,
  /Failed to load resource: net::ERR_CONNECTION_REFUSED/,
  /ResizeObserver loop limit exceeded/,
];

interface CapturedErrors {
  console: string[];
  page: string[];
  network: string[];
  server: string[];
  assertNoErrors: () => void;
  assertNoCriticalErrors: () => void;
}

type TestFixtures = {
  capturedErrors: CapturedErrors;
};

export const test = base.extend<TestFixtures>({
  capturedErrors: async ({ page }, use) => {
    const errors: CapturedErrors = {
      console: [],
      page: [],
      network: [],
      server: [],
      assertNoErrors() {
        const all = [...this.console, ...this.page, ...this.network, ...this.server];
        expect(all, `Captured errors:\n${all.join('\n')}`).toHaveLength(0);
      },
      assertNoCriticalErrors() {
        const critical = [...this.page, ...this.server];
        expect(critical, `Critical errors:\n${critical.join('\n')}`).toHaveLength(0);
      },
    };

    page.on('console', (msg) => {
      if (msg.type() === 'error') {
        const text = msg.text();
        if (!BENIGN_ERRORS.some((r) => r.test(text))) {
          errors.console.push(`[CONSOLE ERROR] ${text}`);
        }
      }
    });

    page.on('pageerror', (err) => {
      errors.page.push(`[PAGE ERROR] ${err.message}`);
    });

    page.on('requestfailed', (request) => {
      const failure = request.failure()?.errorText ?? 'unknown';
      const url = request.url();
      if (!BENIGN_ERRORS.some((r) => r.test(failure))) {
        errors.network.push(`[NETWORK FAIL] ${url}: ${failure}`);
      }
    });

    page.on('response', (response) => {
      if (response.status() >= 500) {
        errors.server.push(`[5XX] ${response.status()} ${response.url()}`);
      }
    });

    await use(errors);
  },
});

export { expect };
