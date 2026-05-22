# Receita: Criar uma Web App

## Objetivo

Criar uma aplicação web completa do zero usando o arquétipo `web_app` da fábrica, passando por todos os gates do pipeline de desenvolvimento: classificação, requisitos, arquitetura, planejamento, implementação, testes, segurança e deploy.

## Quando usar

- Novo projeto com interface de usuário (portal interno, SaaS, dashboard, backoffice)
- Qualquer aplicação que precise de autenticação, banco de dados relacional e deploy contínuo
- Quando a stack Next.js 16 + Supabase + Vercel é adequada ao contexto

> **Não use esta receita** para scripts de automação, pipelines de dados ou servidores MCP — veja as receitas específicas para esses arquétipos.

## Agentes envolvidos

| Agente | Papel nesta receita |
|--------|---------------------|
| `@techlead` | Classificação Gate A0, orquestração, aprovação de gates |
| `@po` | Redação do PRD com requisitos, critérios de aceite, métricas |
| `@architect` | Architecture.md, ADRs para desvios do Golden Model |
| `@engineer` | Execution Plan: decomposição em tasks, estimativas |
| `@devbackend` | Implementação de APIs, migrações Prisma, Server Actions |
| `@devfrontend` | Implementação de páginas, componentes React, integração Recharts |
| `@uxui` | Design Spec: wireframes, paleta, tokens de design |
| `@qa` | Plano de testes, testes Vitest e Playwright |
| `@devsecops` | Auditoria de segurança, revisão de secrets, OWASP Top 10 |
| `@devops` | Pipeline de deploy Vercel, preview por PR, aprovação de produção |

## Fluxo de execução

### Etapa 1 — Classificação do arquétipo (Gate A0)

```
@techlead Classifique o arquétipo: portal interno de gestão de tarefas com
autenticação Google, dashboard com métricas e exportação de relatórios CSV
semanais. Usuários são funcionários internos da empresa.
```

Resultado esperado: `A0_APPROVED` com arquétipo `web_app` e referência ao
Golden Model `standards/golden-model-web-app.md`.

---

### Etapa 2 — Requisitos (Gate 1)

```
@po Escreva o PRD para um portal de gestão de tarefas interno. Requisitos:
- Autenticação via Google OAuth (NextAuth v5)
- CRUD de tarefas com título, descrição, responsável, prazo e status
- Dashboard com métricas: tarefas abertas, concluídas, atrasadas por usuário
- Exportação de relatório CSV semanal (Vercel Cron)
- Roles: admin (pode ver todas as tarefas) e membro (só as próprias)
Inclua critérios de aceite mensuráveis para cada feature.
```

Resultado esperado: `PRD.md` com user stories, critérios de aceite, métricas
de sucesso e non-goals explícitos.

---

### Etapa 3 — Arquitetura (Gate 2)

```
@architect Projete a arquitetura para o portal de gestão de tarefas aprovado
no PRD. Use o Golden Model web_app (Next.js 16 App Router, Supabase/PostgreSQL,
Prisma 7, NextAuth v5, Vercel). Entregue: Architecture.md com diagrama de
componentes, modelo de dados Prisma, decisões de roteamento Next.js e lista de
ADRs necessários para qualquer desvio do Golden Model.
```

Resultado esperado: `Architecture.md` + eventuais `ADR-001.md`, `ADR-002.md`.
Gate 2 é bloqueado enquanto ADRs pendentes não forem aprovados.

---

### Etapa 4 — Planejamento (Gate 3)

```
@engineer Decomponha o PRD aprovado em tasks implementáveis. Para cada task:
- ID único (TASK-001, TASK-002...)
- Descrição clara e critério de done
- Estimativa em story points (1, 2, 3, 5, 8)
- Dependências entre tasks
- Responsável sugerido (backend / frontend)
Organize em sprints de 2 semanas.
```

Resultado esperado: `Execution_Plan.json` ou `Execution_Plan.md` com backlog
completo e roadmap de sprints.

---

### Etapa 5 — Design (paralelo ao Gate 3)

```
@uxui Crie a Design Spec para o portal de gestão de tarefas. Inclua:
- Wireframes de baixa fidelidade: tela de login, dashboard, lista de tarefas,
  formulário de criação/edição
- Paleta de cores e tokens de tipografia
- Componentes Tailwind CSS reutilizáveis (Card, Badge de status, Modal)
- Guia de acessibilidade: contraste mínimo 4.5:1, navegação por teclado
```

Resultado esperado: `Design_Spec.md` com wireframes em ASCII ou descrição
detalhada, tokens de design e especificações de componentes.

---

### Etapa 6 — Implementação Backend (Gate 3 → desenvolvimento)

```
@devbackend Implemente as seguintes rotas da API de tarefas seguindo o
Golden Model web_app:

1. POST /api/tasks — criar tarefa (validação Zod, persistência Prisma)
2. GET /api/tasks — listar tarefas do usuário autenticado (com paginação)
3. PATCH /api/tasks/[id] — atualizar status/campos (verificar ownership)
4. DELETE /api/tasks/[id] — excluir tarefa (soft delete, apenas owner ou admin)

Requisitos obrigatórios:
- Validação de schema com Zod em todas as rotas
- Autorização por usuário: role admin vê tudo, membro vê só as próprias
- Logs estruturados JSON em audit_log para todas as mutações
- Migração Prisma para o modelo Task (nunca prisma db push em staging/prod)
```

```
@devbackend Implemente o Vercel Cron para geração do relatório CSV semanal:
- Rota: /api/cron/weekly-report (protegida por CRON_SECRET)
- Busca tarefas da semana anterior por usuário
- Gera CSV em memória e envia por email via Resend
- Registra execução em sync_log
```

---

### Etapa 7 — Implementação Frontend

```
@devfrontend Implemente as seguintes páginas do portal de tarefas:

1. /dashboard — cards de métricas (abertas/concluídas/atrasadas) + gráfico de
   barras Recharts v3 com progresso por usuário
2. /tasks — lista paginada de tarefas com filtros de status e responsável
3. /tasks/new — formulário de criação com validação client-side (react-hook-form + Zod)
4. /tasks/[id] — detalhe/edição da tarefa

Requisitos:
- Server Components para listagem e métricas (sem SWR aqui)
- Client Components apenas para formulários interativos e o gráfico Recharts
- Tailwind CSS v4 com tokens do Design Spec
- Loading skeletons e estados de erro para todas as páginas
```

---

### Etapa 8 — Testes (Gate 4)

```
@qa Crie o plano de testes completo para o portal de gestão de tarefas:

Unitários (Vitest):
- Server Actions: createTask, updateTask, deleteTask
- Funções de autorização: canUserAccessTask(userId, taskId)
- Gerador de CSV do relatório semanal

E2E (Playwright):
- Fluxo completo: login Google → criar tarefa → editar → concluir → exportar CSV
- Controle de acesso: membro não consegue ver tarefas de outros usuários
- Cron: simular chamada ao endpoint /api/cron/weekly-report com CRON_SECRET válido

Cobertura mínima: 80% das funções críticas.
```

```
@qa Implemente os testes E2E Playwright para o fluxo principal. Use
fixtures para mock do NextAuth e do banco Prisma em modo de teste.
Inclua screenshot em caso de falha.
```

---

### Etapa 9 — Segurança (Gate 5)

```
@devsecops Revise a implementação do portal de gestão de tarefas com foco em:
1. Autorização por usuário nas rotas da API (IDOR: usuário A não pode
   acessar/modificar tarefas do usuário B)
2. Validação de inputs: Zod está sendo aplicado antes de qualquer query Prisma?
3. Secrets: NEXTAUTH_SECRET, DATABASE_URL e CRON_SECRET estão apenas em
   variáveis de ambiente? Nunca em código ou logs?
4. Headers HTTP de segurança no next.config.ts
5. Dependências vulneráveis: rode npm audit e liste findings HIGH/CRITICAL
```

> Gate 5 somente pode ser aprovado pelo `@devsecops`. Findings CRITICAL sem
> mitigação bloqueiam o gate — o `@techlead` não pode fazer override.

---

### Etapa 10 — Deploy (Gate 6)

```
@devops Configure o pipeline de deploy para Vercel:
1. Preview automático para cada Pull Request (branch preview)
2. Deploy de staging ao merge na branch develop
3. Deploy de production: trigger manual com aprovação explícita (nunca automático)
4. Variáveis de ambiente: DATABASE_URL, NEXTAUTH_SECRET, GOOGLE_CLIENT_ID,
   GOOGLE_CLIENT_SECRET, CRON_SECRET — configuradas no Vercel Dashboard
5. Plano de rollback: como reverter para o deploy anterior em menos de 5 minutos
```

> Gate 6 requer plano de rollback documentado e aprovação humana explícita.
> Nenhuma exceção.

## Artefatos esperados

- `PRD.md` — Product Requirements Document com user stories e critérios de aceite
- `Architecture.md` — diagrama de componentes, modelo de dados, decisões técnicas
- `ADR-001.md` (e subsequentes) — registros de decisão para desvios do Golden Model
- `Execution_Plan.md` — backlog com tasks, estimativas e sprints
- `Design_Spec.md` — wireframes, tokens de design, especificação de componentes
- Pull Requests de backend (APIs + migrações Prisma)
- Pull Requests de frontend (páginas + componentes)
- `QA_Report.md` — plano de testes, resultados, cobertura
- Arquivos de teste: `*.test.ts` (Vitest) e `*.spec.ts` (Playwright)
- `Security_Audit.md` — findings OWASP, severidade, status de mitigação
- `Deployment_Plan.md` — configuração Vercel, variáveis de ambiente, plano de rollback

## Gates envolvidos

| Gate | Responsável | Critério de aprovação |
|------|-------------|----------------------|
| A0 | `@techlead` | Arquétipo classificado como `web_app` |
| 1 | `@techlead` + `@po` | PRD aprovado com critérios de aceite mensuráveis |
| 2 | `@techlead` + `@architect` | Architecture.md aprovada; ADRs pendentes resolvidos |
| 3 | `@techlead` + `@engineer` | Execution Plan aprovado; Design Spec entregue |
| 4 | `@qa` | QA_Report.md entregue; cobertura ≥ 80%; zero testes E2E falhando |
| 5 | `@devsecops` | Security_Audit.md sem findings CRITICAL sem mitigação |
| 6 | `@devops` + humano | Deployment_Plan.md + plano de rollback + aprovação manual |

## Comandos de validação

```powershell
# Verificar saúde geral da fábrica e dependências
.\doctor.ps1

# Verificar que o MCP Knowledge Search está respondendo
.\test-mcp.ps1

# Verificar que os agentes têm as skills necessárias para esta receita
# (execute dentro de uma sessão Claude Code)
# @techlead knowledge_stats()
# @architect search_knowledge("Golden Model web_app")
# @qa search_knowledge("Playwright E2E")
# @devsecops search_knowledge("OWASP Top 10")
```

```powershell
# Após implementação: rodar testes localmente
npx vitest run
npx playwright test

# Verificar dependências vulneráveis
npm audit --audit-level=high
```

## Próximos passos

Após concluir esta receita com Gate 6 aprovado:

1. **Monitoramento**: configurar alertas de erro no Vercel (ou Sentry) para o ambiente de produção
2. **Performance**: `@architect` revisar Core Web Vitals após primeiro deploy em produção
3. **Iteração**: para novas features, reiniciar a partir do Gate 1 (`@po` escreve PRD incremental)
4. **Manutenção de dependências**: rodar `npm audit` semanalmente; `@devsecops` revisar findings
5. **Conhecimento**: se a implementação revelou padrões úteis não cobertos pelos agentes, use a receita `adicionar-novo-conhecimento.md` para incorporá-los
