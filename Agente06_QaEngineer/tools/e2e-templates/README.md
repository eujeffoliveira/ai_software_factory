# E2E Testing Templates (Playwright)

Templates reutilizáveis para testes end-to-end com Playwright. Desenvolvidos a partir de padrões extraídos de produção.

**Migrado de:** [a-gusman-claude/shared/templates/e2e](https://github.com/eujeffoliveira/a-gusman-claude/tree/main/shared/templates/e2e)

## Arquivos disponíveis

| Arquivo | Propósito |
|---------|-----------|
| `base-page.template.ts` | Classe abstrata com helpers de navegação, espera e asserção |
| `base-fixture.template.ts` | Fixture que captura console errors, page errors, 5xx, network failures |
| `auth-setup.template.ts` | Setup de autenticação persistente (cria `.auth/user.json`) |
| `access-control.template.spec.ts` | **OBRIGATÓRIO** para toda rota protegida com ≥ 2 roles |
| `playwright.base.config.ts` | Config base com 3 projetos: setup, chromium, smoke |
| `smoke.template.spec.ts` | Suite de verificação mínima pós-deploy |

## Setup rápido

```bash
# 1. Instalar Playwright
npm install -D @playwright/test
npx playwright install chromium

# 2. Copiar templates para o projeto
cp tools/e2e-templates/*.ts tests/e2e/

# 3. Criar diretório de auth state (adicionar ao .gitignore)
mkdir -p .auth
echo ".auth/" >> .gitignore

# 4. Configurar variáveis de ambiente
echo "TEST_USER_EMAIL=test@example.com" >> .env.test
echo "TEST_USER_PASSWORD=test-password" >> .env.test
```

## Convenções

- Arquivos de spec E2E: `.spec.ts`
- Auth state: `.auth/user.json` (excluir do git)
- Trace ativo na primeira retry
- Screenshots automáticos em falha

## Integrar playwright.base.config.ts

```typescript
// playwright.config.ts do projeto
import { defineConfig } from '@playwright/test';
import { baseConfig } from './tests/e2e/playwright.base.config';

export default defineConfig({
  ...baseConfig,
  use: {
    ...baseConfig.use,
    baseURL: process.env.BASE_URL ?? 'http://localhost:3000',
  },
});
```

## Quando usar access-control.template.spec.ts

**OBRIGATÓRIO** quando:
- Rota tem restrição de acesso por role
- Projeto tem ≥ 2 tipos de usuário (ex: user + admin)
- Gate 4 (QA) não aprova sem cobertura de access control
