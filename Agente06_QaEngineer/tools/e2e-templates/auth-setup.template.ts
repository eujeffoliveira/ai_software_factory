/**
 * Auth Setup Template — Playwright
 *
 * Cria estado de autenticacao persistente para reutilizacao nos testes E2E.
 * Deve ser importado como setup project no playwright.config.ts.
 *
 * CUSTOMIZAR:
 * - URL de login
 * - Seletores de email/senha
 * - Variaveis de ambiente
 * - Pattern de URL apos login bem-sucedido
 *
 * Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/shared/templates/e2e
 */
import { test as setup, expect } from '@playwright/test';
import path from 'path';

// Arquivo de state — excluido do git via .gitignore
export const AUTH_FILE = path.join(__dirname, '../../../.auth/user.json');

setup('authenticate', async ({ page }) => {
  // CUSTOMIZAR: atualizar para o seu URL de login
  await page.goto('/login');

  // Aguardar formulario carregar
  await page.waitForLoadState('networkidle');

  // CUSTOMIZAR: atualizar seletores conforme o seu formulario
  await page.getByLabel(/email/i).fill(
    process.env.TEST_USER_EMAIL ?? 'test@example.com'
  );
  await page.getByLabel(/password|senha/i).fill(
    process.env.TEST_USER_PASSWORD ?? 'test-password'
  );

  // CUSTOMIZAR: atualizar seletor do botao de login
  await page.getByRole('button', { name: /login|entrar|sign in/i }).click();

  // Aguardar navegacao bem-sucedida com timeout de 15s
  // CUSTOMIZAR: atualizar para o pattern da URL pos-login
  await page.waitForURL(/\/(dashboard|home|app|overview)/, { timeout: 15000 });

  // Verificar que nao estamos mais na pagina de login/auth
  await expect(page).not.toHaveURL(/\/(login|auth|signin)/);

  // Persistir estado da sessao para reutilizacao
  await page.context().storageState({ path: AUTH_FILE });
});
