# Golden Model — Web Application (`web_app`)

**Archetype:** `web_app`
**Applies to:** Fullstack web applications with browser UI, user authentication, database, and cloud deployment.
**Does NOT apply to:** Scripts, pipelines, CLI tools, MCP servers, workers, notebooks.

If your project is not a browser-facing web application, use the correct archetype from [project-classification.md](./project-classification.md).

---

## Stack Obrigatória

| Camada | Tecnologia |
|--------|-----------|
| Framework | Next.js 16 (App Router) |
| Frontend | React 19 + TypeScript 5 |
| Estilização | Tailwind CSS v4 |
| Autenticação | NextAuth v5 + Google OAuth |
| Backend (API) | Route Handlers no Next.js |
| Proxy/Middleware | `proxy.ts` — NUNCA `middleware.ts` no Next.js 16 |
| Banco de dados | PostgreSQL via Supabase |
| ORM | Prisma 7 com PrismaPg adapter |
| Migrations (prod) | `prisma migrate deploy` — NUNCA `db push` |
| Deploy | Vercel |
| Cron Jobs | Vercel Cron + `guardCron()` em toda rota cron |
| Validação | Zod em todas as fronteiras do sistema |
| Testes unitários | Vitest |
| Testes E2E | Playwright |
| Gráficos | Recharts v3 |
| Data Fetching | Server Components → Server Actions → SWR (polling) |
| Variáveis de ambiente | `lib/env.ts` centralizado |
| Logs | JSON estruturado (`audit_log`, `sync_log`) |

---

## Regras Obrigatórias

1. **`proxy.ts` nunca `middleware.ts`** — No Next.js 16, toda interceptação de request usa `proxy.ts`. `middleware.ts` está proibido.
2. **Route Handlers são thin** — Máximo ~30 linhas. Só: auth check, parse, validação, delegação para `features/`, retorno. Nunca lógica de negócio.
3. **Lógica de negócio em `features/[domain]/`** — Nunca em `route.ts`, nunca em `schema.prisma`.
4. **Zod em toda fronteira** — Inputs do usuário, variáveis de ambiente, respostas de APIs externas, payloads de webhook — tudo parseado com `.parse()` ou `.safeParse()`.
5. **Auth check é sempre o primeiro passo** — `const session = await auth()` → `if (!session) return 401`. Sem exceções.
6. **Prisma DAL** — Todo acesso ao banco via `lib/db/[model].dal.ts`. Nenhum import direto de `prisma` em features, actions ou routes.
7. **`audit_log` para ações humanas** — Qualquer Server Action que cria, atualiza ou deleta dados de usuário registra `auditLog()`.
8. **`sync_log` para jobs automatizados** — Todo cron registra `syncLog()` em bloco `finally`.
9. **Exceptions nunca expostas ao cliente** — `catch(error) { console.error(...); throw new Error("Generic") }`.
10. **Variáveis de ambiente via `lib/env.ts`** — Nenhum `process.env` espalhado fora deste arquivo.
11. **`prisma migrate deploy` em staging/prod** — Nunca `prisma db push` fora do desenvolvimento local.
12. **Jobs devem ser idempotentes** — Todo job recorrente tolera reexecução sem efeito duplicado.

---

## Antipadrões Críticos (bloqueiam Gate 5)

| Antipadrão | Risco |
|-----------|-------|
| SQL concatenado diretamente | SQL injection |
| Lógica de negócio em `route.ts` | Testabilidade zero, acoplamento |
| `process.env` fora de `lib/env.ts` | Config dispersa, erros em produção |
| Segredos hardcoded | Comprometimento de credenciais |
| `middleware.ts` no Next.js 16 | Comportamento indefinido |
| `prisma db push` em staging/prod | Perda de dados, migrações sem controle |
| Jobs sem idempotência | Duplicação de dados, efeitos colaterais |
| Deploy sem rollback documentado | Indisponibilidade sem saída |
| Stack traces expostos ao cliente | Vazamento de informação |

---

## Artefatos Obrigatórios por Gate

| Gate | Artefatos |
|------|-----------|
| Gate 1 | PRD.md |
| Gate 2 | Architecture.md, API_Contract.json, DB_Schema, Risk_Register |
| Gate 3 | Execution_Plan.json |
| Gate 4 | QA_Report.md |
| Gate 5 | Security_Audit.md |
| Gate 6 | Deployment_Plan.md + rollback plan + human approval |
| Gate 7 | Post-deploy health report |

---

## Quando ADR é Necessário

- Qualquer tecnologia não listada na stack obrigatória
- Usar Pages Router em vez de App Router
- Banco diferente de PostgreSQL/Supabase
- Auth diferente de NextAuth v5
- Deploy diferente de Vercel
- Usar `middleware.ts` (bloqueado — ADR não aprovado automaticamente)
