/**
 * Access Control Tests Template — Playwright
 *
 * OBRIGATORIO para toda rota protegida com >= 2 roles.
 * Verifica que rotas protegidas respeitam permissoes.
 *
 * CUSTOMIZAR:
 * - Atualizar PROTECTED_ROUTES com as rotas do projeto
 * - Criar auth state files per role em .auth/
 * - Ajustar seletores CSS conforme necessario
 *
 * Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/shared/templates/e2e
 */
import { test, expect } from '@playwright/test';

// CUSTOMIZAR: definir rotas protegidas e suas regras de acesso
const PROTECTED_ROUTES = [
  { path: '/dashboard', roles: ['user', 'admin'] },
  { path: '/admin', roles: ['admin'] },
  { path: '/settings', roles: ['user', 'admin'] },
  { path: '/api/users', roles: ['admin'] },
];

test.describe('Unauthenticated access — redirect to login', () => {
  for (const route of PROTECTED_ROUTES) {
    test(`redirects unauthenticated user from ${route.path}`, async ({ page }) => {
      await page.goto(route.path);
      // CUSTOMIZAR: ajustar pattern para o seu path de login
      await expect(page).toHaveURL(/\/(login|auth|signin)/, { timeout: 10000 });
    });
  }
});

// CUSTOMIZAR: descomente e adapte os testes abaixo por role
// Requer arquivos de state separados por role criados via setup projects

// test.describe('Admin role — full access', () => {
//   test.use({ storageState: '.auth/admin.json' });
//
//   test('admin can access /admin dashboard', async ({ page }) => {
//     await page.goto('/admin');
//     await expect(page).not.toHaveURL(/\/(login|auth|signin)/);
//     await expect(page.getByRole('heading').first()).toBeVisible({ timeout: 10000 });
//   });
//
//   test('admin can access /settings', async ({ page }) => {
//     await page.goto('/settings');
//     await expect(page).not.toHaveURL(/\/(login|auth|signin)/);
//   });
// });

// test.describe('User role — restricted access', () => {
//   test.use({ storageState: '.auth/user.json' });
//
//   test('user can access /dashboard', async ({ page }) => {
//     await page.goto('/dashboard');
//     await expect(page).not.toHaveURL(/\/(login|auth|signin)/);
//   });
//
//   test('user CANNOT access /admin — redirected or 403', async ({ page }) => {
//     await page.goto('/admin');
//     const url = page.url();
//     const isForbidden =
//       /\/(login|auth|forbidden|403|unauthorized)/.test(url) ||
//       (await page.locator('[data-testid="forbidden"], [data-testid="error-403"]').isVisible());
//     expect(isForbidden, `Expected redirect or 403, got URL: ${url}`).toBeTruthy();
//   });
// });
