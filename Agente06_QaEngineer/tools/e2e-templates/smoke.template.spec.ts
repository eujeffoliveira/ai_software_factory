/**
 * Smoke Tests Template — Playwright
 *
 * Suite de verificacao minima pos-deploy.
 * Deve passar em qualquer ambiente apos deploy.
 *
 * CUSTOMIZAR:
 * - Adicionar erros benignos em KNOWN_BENIGN_ERRORS
 * - Atualizar seletores de login
 * - Definir rotas protegidas para testar redirect
 *
 * Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/shared/templates/e2e
 */
import { test, expect } from '@playwright/test';

// CUSTOMIZAR: adicionar mensagens de erro esperadas no projeto
const KNOWN_BENIGN_ERRORS = [
  /WebSocket/,
  /DevTools/,
  /service worker/i,
  /ResizeObserver loop/,
];

function isBenign(msg: string): boolean {
  return KNOWN_BENIGN_ERRORS.some((r) => r.test(msg));
}

test.describe('Health', () => {
  test('homepage loads without critical errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('pageerror', (e) => errors.push(e.message));
    page.on('console', (m) => {
      if (m.type() === 'error' && !isBenign(m.text())) {
        errors.push(m.text());
      }
    });

    const start = Date.now();
    const response = await page.goto('/');
    const loadTime = Date.now() - start;

    expect(response?.status(), 'Homepage returned error status').toBeLessThan(400);
    expect(loadTime, `Page load time: ${loadTime}ms`).toBeLessThan(5000);
    expect(errors, `JS errors: ${errors.join(', ')}`).toHaveLength(0);
  });

  test('CSS and JS assets load successfully', async ({ page }) => {
    const failures: string[] = [];
    page.on('requestfailed', (req) => {
      const url = req.url();
      if (/\.(css|js|woff2?)(\?|$)/.test(url)) {
        failures.push(`${url}: ${req.failure()?.errorText}`);
      }
    });
    await page.goto('/');
    expect(failures, `Asset failures: ${failures.join(', ')}`).toHaveLength(0);
  });
});

test.describe('Navigation', () => {
  test('login page is accessible and renders form', async ({ page }) => {
    // CUSTOMIZAR: atualizar para o seu URL de login
    const response = await page.goto('/login');
    expect(response?.status()).toBeLessThan(400);

    // CUSTOMIZAR: atualizar seletor para o input de email/usuario
    await expect(
      page
        .locator('input[type="email"], input[type="text"], input[name="email"]')
        .first()
    ).toBeVisible({ timeout: 10000 });
  });

  test('unauthenticated user redirected to auth flow', async ({ page }) => {
    // CUSTOMIZAR: atualizar para uma rota protegida do projeto
    await page.goto('/dashboard');
    await expect(page).toHaveURL(/\/(login|auth|signin)/, { timeout: 10000 });
  });
});

test.describe('Stability', () => {
  test('no 5xx server errors on homepage', async ({ page }) => {
    const serverErrors: number[] = [];
    page.on('response', (r) => {
      if (r.status() >= 500) serverErrors.push(r.status());
    });
    await page.goto('/');
    expect(serverErrors, `5xx errors: ${serverErrors.join(', ')}`).toHaveLength(0);
  });

  test('no broken images on homepage', async ({ page }) => {
    await page.goto('/');
    const brokenImages = await page.evaluate(() => {
      return Array.from(document.querySelectorAll<HTMLImageElement>('img'))
        .filter((img) => !img.complete || img.naturalWidth === 0)
        .map((img) => img.src);
    });
    expect(brokenImages, `Broken images: ${brokenImages.join(', ')}`).toHaveLength(0);
  });

  // CUSTOMIZAR: descomente se houver health endpoint
  // test('health endpoint returns 200', async ({ request }) => {
  //   const response = await request.get('/api/health');
  //   expect(response.status()).toBe(200);
  //   const body = await response.json();
  //   expect(body.status).toBe('ok');
  // });
});
