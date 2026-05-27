# Receita: Gerar Plano de Testes

## Objetivo

Criar um plano de testes completo para um módulo, feature ou projeto — cobrindo testes unitários (Vitest), testes de integração e testes E2E (Playwright) — e implementar os testes com cobertura mínima que satisfaça o Gate 4 da fábrica.

## Quando usar

- Antes de entregar qualquer feature que precisará passar pelo Gate 4 (QA Gate)
- Quando você assumiu um módulo sem testes e precisa adicionar cobertura
- Quando um bug foi encontrado em produção e você precisa garantir que não voltará
- Quando uma auditoria de segurança (`@devsecops`) solicitou casos de teste de segurança específicos

> Esta receita se concentra no arquétipo `web_app` com Vitest + Playwright,
> mas os mesmos princípios se aplicam a `automation_script` (pytest) e
> `data_pipeline` (pytest + pandera).

## Agentes envolvidos

| Agente | Papel nesta receita |
|--------|---------------------|
| `@qa` | Redação do plano, implementação dos testes, geração do relatório |
| `@techlead` | Validação do Gate 4, aprovação do QA_Report.md |
| `@devsecops` | (opcional) Casos de teste de segurança para módulos sensíveis |
| `@devbackend` | (opcional) Revisão dos mocks e fixtures de integração |

## Fluxo de execução

### Etapa 1 — Definir escopo e estratégia

```
@qa Crie o plano de testes para o módulo de pagamentos do portal de gestão.
O módulo inclui:
- Server Actions: createPayment, refundPayment, getPaymentStatus
- Rotas de API: POST /api/payments, GET /api/payments/[id], POST /api/payments/[id]/refund
- Fluxo de UI: formulário de pagamento → confirmação → recibo

Entregue:
1. Estratégia de testes: qual tipo de teste cobre cada cenário
2. Lista completa de casos de teste (happy path + edge cases + casos negativos)
3. Estimativa de cobertura esperada após implementação
4. Dependências externas que precisam de mock (Stripe, banco de dados, NextAuth)
```

---

### Etapa 2 — Testes unitários (Vitest)

```
@qa Implemente os testes unitários Vitest para as Server Actions do módulo
de pagamentos:

createPayment:
- Pagamento válido → retorna { success: true, paymentId: "..." }
- Valor negativo → lança ValidationError ("amount must be positive")
- Usuário não autenticado → lança AuthError
- Banco de dados indisponível → lança DatabaseError (não expõe detalhes internos)

refundPayment:
- Reembolso válido → retorna { success: true, refundId: "..." }
- Pagamento já reembolsado → lança ConflictError ("already refunded")
- Usuário tentando reembolsar pagamento de outro → lança ForbiddenError

getPaymentStatus:
- ID válido do próprio usuário → retorna status completo
- ID de outro usuário → lança ForbiddenError (não retorna 404 — evita enumeração)
- ID inexistente → retorna null

Mocks obrigatórios: vi.mock para o cliente Prisma, vi.mock para NextAuth getServerSession.
Use describe/it blocks com nomes que explicam o comportamento esperado.
```

---

### Etapa 3 — Testes de integração

```
@qa Implemente os testes de integração para as rotas da API de pagamentos.
Use supertest ou fetch direto com servidor Next.js em modo de teste.

POST /api/payments:
- Body válido + usuário autenticado → 201 Created com paymentId
- Body inválido (Zod error) → 422 Unprocessable Entity com lista de erros
- Sem autenticação → 401 Unauthorized
- Idempotência: mesma requisição enviada 2x → segundo retorna 409 Conflict

GET /api/payments/[id]:
- ID válido do próprio usuário → 200 com dados completos
- ID de outro usuário → 403 Forbidden (não 404)
- ID inexistente → 404 Not Found

POST /api/payments/[id]/refund:
- Reembolso válido → 200 com refundId
- Pagamento já reembolsado → 409 Conflict com mensagem clara

Mock: use um banco SQLite em memória (Prisma + SQLite) para os testes de integração,
não o banco de produção/staging.
```

---

### Etapa 4 — Testes E2E (Playwright)

```
@qa Implemente os testes E2E Playwright para os fluxos principais do módulo
de pagamentos:

Fixture de autenticação (fixture.ts):
- Mock do NextAuth para simular usuário autenticado sem passar pelo fluxo Google OAuth
- Dois usuários disponíveis: userA (cliente) e userAdminB (admin)

Fluxo 1 — Pagamento bem-sucedido:
test('happy path: pagamento com cartão válido', async ({ page }) => {
  // Login como userA
  // Navegar para /payments/new
  // Preencher formulário (número de cartão, vencimento, CVV)
  // Clicar em "Pagar"
  // Verificar: redirecionou para /payments/[id] com status "approved"
  // Verificar: email de confirmação foi "enviado" (mock do serviço de email)
})

Fluxo 2 — Cartão recusado:
test('cartão recusado exibe mensagem de erro clara', async ({ page }) => {
  // Usar número de cartão de teste que simula recusa (ex: 4000000000000002)
  // Verificar: mensagem de erro visível sem expor detalhes técnicos
  // Verificar: formulário continua disponível para nova tentativa
  // Verificar: nenhum registro criado no banco (idempotência)
})

Fluxo 3 — Timeout de rede:
test('timeout de rede exibe feedback ao usuário', async ({ page }) => {
  // Interceptar requisição Stripe e causar timeout com page.route()
  // Verificar: spinner desaparece após timeout
  // Verificar: mensagem "Tente novamente" visível
  // Verificar: botão de retry funciona
})

Fluxo 4 — Reembolso:
test('admin pode reembolsar pagamento', async ({ page }) => {
  // Login como userAdminB
  // Navegar para /payments/[id de pagamento existente]
  // Clicar em "Reembolsar"
  // Confirmar no modal
  // Verificar: status mudou para "refunded"
})

Fluxo 5 — Controle de acesso:
test('usuário não consegue ver pagamento de outro usuário', async ({ page }) => {
  // Login como userA
  // Tentar acessar /payments/[id de pagamento do userB]
  // Verificar: redirecionado para /403 ou /payments (não exibe dados do userB)
})
```

---

### Etapa 5 — Casos de teste de segurança

```
@devsecops Adicione casos de teste de segurança para o módulo de pagamentos:

1. Injeção no formulário:
   - Campo "cardholderName" com payload: <script>alert(1)</script>
   → Verificar: valor não é executado, aparece como texto literal

2. Manipulação de valor:
   - Interceptar requisição POST /api/payments e alterar "amount" para -1
   → Verificar: API retorna 422, não processa pagamento com valor negativo

3. IDOR (acesso a recurso de outro usuário):
   - Login como userA, tentar GET /api/payments/[ID pertence ao userB]
   → Verificar: resposta 403, não 200 com dados do userB

4. Replay de pagamento:
   - Enviar a mesma requisição de criação de pagamento 3 vezes rapidamente
   → Verificar: apenas 1 pagamento criado (idempotência via chave de idempotência)

5. Header de autorização manipulado:
   - Requisição com Bearer token expirado
   → Verificar: 401 Unauthorized

Esses testes podem ser implementados como testes de integração Vitest ou
como interceptação de requisição em Playwright (use page.route()).
```

---

### Etapa 6 — Geração do relatório (Gate 4)

```
@qa Gere o QA_Report.md para o módulo de pagamentos com:

1. Resumo executivo: total de casos, passando/falhando, cobertura
2. Matriz de rastreabilidade: cada requisito do PRD → caso de teste correspondente
3. Cobertura de código: resultado do coverage report (npx vitest run --coverage)
4. Fluxos E2E: status de cada fluxo Playwright (passed/failed/skipped)
5. Casos de segurança: resultado dos casos solicitados pelo @devsecops
6. Issues encontradas durante os testes (bugs descobertos, não planejados)
7. Decisão de gate: APPROVED / BLOCKED_PENDING_FIX com justificativa

O QA_Report.md é obrigatório para aprovação do Gate 4.
```

---

### Etapa 7 — Revisão e aprovação do Gate 4

```
@techlead Revise o QA_Report.md do módulo de pagamentos e decida o status do Gate 4:

Critérios obrigatórios para APPROVED:
- Cobertura de código ≥ 80% nos módulos críticos (Server Actions, funções de cálculo)
- Zero testes E2E falhando para os fluxos principais (happy path + fluxos críticos)
- Todos os casos de teste de segurança passando
- Issues encontradas: nenhuma classificada como P1 sem mitigação documentada

Se BLOCKED_PENDING_FIX: listar exatamente o que precisa ser corrigido antes
de reabrir o gate.
```

## Artefatos esperados

- `QA_Report.md` — plano, resultados, cobertura, rastreabilidade, decisão de gate
- `tests/unit/payments.test.ts` — testes unitários Vitest (Server Actions)
- `tests/integration/payments.api.test.ts` — testes de integração das rotas
- `tests/e2e/payments.spec.ts` — testes E2E Playwright
- `tests/fixtures/auth.fixture.ts` — fixture de autenticação para Playwright
- Coverage report HTML (gerado por Vitest coverage)

## Gates envolvidos

| Gate | Responsável | Critério de aprovação |
|------|-------------|----------------------|
| 4 | `@qa` + `@techlead` | QA_Report.md entregue; cobertura ≥ 80%; zero E2E falhando; casos de segurança passando |

> Gate 4 não pode ser pulado mesmo em entregas de emergência.
> Gate 5 (Segurança) frequentemente é desbloqueado após Gate 4 — os casos de
> teste de segurança do `@devsecops` são input para ambos os gates.

## Comandos de validação

```powershell
# Saúde da fábrica
.\doctor.ps1

# Verificar que @qa tem conhecimento sobre Playwright e Vitest
.\test-mcp.ps1
```

```bash
# Executar testes unitários e de integração com cobertura
npx vitest run --coverage

# Executar testes E2E Playwright (modo headless)
npx playwright test

# Executar apenas um arquivo E2E específico
npx playwright test tests/e2e/payments.spec.ts

# Executar com UI do Playwright (debug visual)
npx playwright test --ui

# Ver relatório de cobertura HTML
npx vitest run --coverage --reporter=html
# Abrir: coverage/index.html
```

```powershell
# Verificar que o relatório de cobertura foi gerado
Test-Path coverage/index.html

# Checar threshold de cobertura (falha se < 80%)
npx vitest run --coverage --coverage.thresholds.lines=80
```

## Próximos passos

Após Gate 4 aprovado:

1. **Gate 5 (Segurança)**: os casos de teste de segurança gerados pelo `@devsecops` já fornecem evidência para o Security Audit — compartilhe o QA_Report.md com o `@devsecops`
2. **Regressão automatizada**: configurar execução dos testes no CI (GitHub Actions) em cada PR
3. **Testes de performance**: se o módulo de pagamentos for crítico em volume, considerar testes de carga com k6 ou Artillery (não coberto por esta receita)
4. **Cobertura de mutação**: para módulos financeiros críticos, `@qa` pode usar Stryker (mutation testing) para validar a qualidade dos testes, não apenas a cobertura de linhas
5. **Bug encontrado?** Se um teste falhou revelando um bug real: abrir issue, corrigir no branch, re-rodar os testes, atualizar QA_Report.md antes de solicitar aprovação do Gate 4
