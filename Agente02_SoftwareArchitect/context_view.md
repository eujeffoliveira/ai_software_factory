# Context View — Agente02_SoftwareArchitect

_Compiled build-time from reference_architecture_generico.md and integrantes.md._  
_Runtime: read-only. Do not modify after build without regenerating from sources._

---

## 1. Golden Model — Mandatory Technical Standard

### 1.1. Hierarchy of Authority

When there is a conflict between sources, follow this order:

```
1. Explicit instruction from the human operator
2. Approved ADR for the current project
3. This context_view (compiled from reference architecture)
4. Project-specific documentation (CLAUDE.md)
5. Theoretical knowledge from RAG (knowledge/)
6. General model knowledge
```

### 1.2. Golden Path Stack (non-negotiable)

| Component | Standard |
|-----------|----------|
| Framework | Next.js 16 — App Router only |
| Proxy | `proxy.ts` — mandatory in all Next.js 16 projects |
| Frontend | React 19 + TypeScript 5 |
| Styling | Tailwind CSS v4 (`@theme` in globals.css) |
| Database | PostgreSQL on Supabase |
| ORM | Prisma 7 with PrismaPg adapter |
| Migrations (local) | `prisma db push` — allowed only for local/sandbox |
| Migrations (staging/prod) | `prisma migrate deploy` — mandatory |
| Deploy | Vercel |
| Cron | Vercel Cron |
| Auth | NextAuth v5 + Google OAuth |
| Validation | Zod at all system boundaries |
| Unit tests | Vitest |
| E2E tests | Playwright |
| Charts | Recharts v3 |
| Email | Nodemailer + AWS SES |
| Env vars | `lib/env.ts` only — never `process.env` scattered |

### 1.3. What Requires an ADR

Any deviation from the Golden Path requires an ADR **before** implementation:

- Separate backend repository
- Dedicated worker or queue service
- Database other than PostgreSQL
- ORM other than Prisma
- Deploy platform other than Vercel
- Supabase CLI as primary migration tool
- Auth provider other than Google OAuth
- Charts library other than Recharts
- Distributed architecture
- Python/FastAPI microservice
- Data pipeline or AI/embeddings service
- Persistent runtime for heavy integrations
- Mixing Prisma Migrate and Supabase CLI

---

## 2. Architectural Principles

**P1 — Simplicity before abstraction**  
Prefer the simplest solution that solves the real problem. Generalize only when repetition is real and clear.

**P2 — Security by default**  
Default configuration must be secure. Any access relaxation must be explicit, justified, and documented.

**P3 — Auditability**  
Every significant human action or automated job must be traceable via `audit_log` or `sync_log`.

**P4 — AI compatibility**  
Code, structure, and documentation must be readable by AI agents. Explicit types, descriptive names, small functions, clear contracts, well-separated layers.

**P5 — Progressive scalability**  
Start simple. Scale only when evidence demands it. Exceptions for large-scale workloads must be documented in ADR.

**P6 — Fail early and clearly**  
Invalid configs, missing env vars, broken contracts, and inconsistent schemas must fail at boot/build/CI — not silently in production.

**P7 — Zero secrets in code**  
No credentials, tokens, keys, or sensitive values in source code. Secrets live in environment variables, validated by `lib/env.ts`.

**P8 — Minimal context per agent**  
Specialist agents receive only the context necessary for their role. Excess context increases hallucination, cost, and scope confusion.

---

## 3. Rule Levels

### Mandatory (blocks gate/merge/deploy)
- TypeScript strict mode
- No secrets in code
- Environment variables via `lib/env.ts`
- Input validation at system boundaries (Zod)
- Server-side authorization before privileged reads or mutations
- Structured JSON logs
- `audit_log` for sensitive human actions
- `sync_log` for automated jobs
- Automated tests for new or critical business rules
- CI/CD with typecheck, lint, tests, and build
- Versioned migrations in staging and production
- Idempotent jobs
- `proxy.ts` in Next.js 16 projects
- Never expose stack trace to client
- Never concatenate raw SQL
- Never import library absent from `package.json`

### Golden Path (no justification needed)
All items in section 1.2 above.

### ADR Required
All items in section 1.3 above.

---

## 4. ADR Governance

### When to Create an ADR

Create an ADR before implementing when there is:
- A Golden Path deviation
- An irreversible or expensive-to-reverse decision
- A structural change
- A database migration risk
- A new critical external service
- A significant security decision
- Significant operational cost increase
- A new critical dependency
- A change in authentication/authorization
- A change in deployment pattern

### ADR Template

```md
# ADR-NNN — [Decision Title]

## Status
Proposed | Approved | Rejected | Superseded

## Date
YYYY-MM-DD

## Context
[Problem, constraint, or opportunity being addressed]

## Decision
[What was decided]

## Alternatives Considered
| Alternative | Pros | Cons |
|-------------|------|------|

## Consequences
[Technical, operational, financial, and maintenance impacts]

## Review Criteria
[When this decision should be re-evaluated]
```

### ADR Storage
```
docs/adr/ADR-NNN-kebab-case-title.md
```

---

## 5. Architecture Layers

### 5.1. Mandatory Layers

| Layer | Location | Responsibility |
|-------|----------|----------------|
| Proxy / Edge Guard | `proxy.ts` | Optimistic session check, cron protection |
| Auth Layer | `auth.ts` | NextAuth v5, providers, callbacks |
| Server Components | `app/**/page.tsx`, `layout.tsx` | Initial reads, server rendering, real auth validation |
| Client Components | `components/**/*.tsx` | Interactive UI, local state |
| Route Handlers | `app/api/**/route.ts` | Thin REST shells |
| Cron Routes | `app/api/cron/**/route.ts` | Scheduled job entry points |
| Server Actions | `actions/**/*.ts` | Authorized mutations |
| Data Access Layer | `lib/db/**/*.ts` | All database queries |
| Jobs | `lib/jobs/**/*.ts` | Collection/processing logic |
| Integrations | `lib/integrations/**` | External API clients |
| Validation | `lib/env.ts`, Zod schemas | Runtime validation |
| Types | `types/**/*.ts` | Global types and contracts |

### 5.2. Route Handler Rule

`route.ts` must be a thin shell. It may:
- Validate authentication
- Call `guardCron()`
- Validate input
- Call a function from `lib/`
- Return `NextResponse.json()`

It must NOT:
- Contain business logic
- Access the database directly
- Call external APIs directly
- Assemble queries
- Contain extensive domain logic

### 5.3. Standard Data Flows

**Stable read:**
```
Browser → proxy.ts → Server Component → lib/db → PostgreSQL
```

**Polling read:**
```
Browser → SWR → app/api/**/route.ts → lib/db → PostgreSQL
```

**Mutation:**
```
Browser → Server Action → auth() → authorization → lib/db → audit_log → revalidatePath()
```

**Cron job:**
```
Vercel Cron → app/api/cron/**/route.ts → guardCron() → lib/jobs → lib/db → sync_log
```

### 5.4. Standard Folder Structure

```
app/
  (protected)/
  api/
    cron/
    health/
    [resource]/
  login/
  pending-approval/
  layout.tsx
  globals.css

components/
  ui/
  layout/
  charts/
  domain/

actions/
  [domain].ts

features/
  [domain]/
    [domain].schema.ts
    [domain].service.ts
    [domain].repository.ts
    [domain].types.ts

lib/
  prisma.ts
  env.ts
  fmt.ts
  admin.ts
  email.ts
  db/
    sync-log.ts
    audit-log.ts
    [domain].ts
  jobs/
    cron-guard.ts
    concurrency.ts
  integrations/

types/
  next-auth.d.ts
  [domain].ts

prisma/
  schema.prisma
  migrations/

docs/
  adr/
  runbooks/
  architecture.md

tests/
  unit/
  integration/
  e2e/

proxy.ts
auth.ts
next.config.ts
prisma.config.ts
vercel.json
```

---

## 6. Database — Prisma 7 and PostgreSQL

### Conventions
- Prisma uses `camelCase` field names
- Database uses `snake_case` column names
- Columns use `@map("snake_case")`
- Tables use `@@map("snake_case_plural")`

### Migration Policy

| Environment | Command |
|-------------|---------|
| Local | `prisma db push` permitted |
| Disposable sandbox | `prisma db push` permitted |
| Staging | `prisma migrate deploy` mandatory |
| Production | `prisma migrate deploy` via CI/CD mandatory |

**Never use `prisma db push` in staging or production.**  
**Never use `prisma migrate dev` on a database with real data.**

### Destructive Changes

Changes like DROP COLUMN, RENAME COLUMN, DROP TABLE, or incompatible type changes require a phased plan:
1. Compatibility phase
2. Migration phase
3. Cleanup phase

### Transaction Policy

`$transaction()` is allowed for:
- Short operations (2–4 statements)
- Low cardinality
- No external calls
- Real atomicity requirements

`$transaction()` is forbidden for:
- Large loops
- External API calls
- Long jobs
- Massive synchronizations

---

## 7. Validation with Zod

Validate ALL system boundaries:
- Environment variables (`lib/env.ts`)
- Query parameters
- Request bodies
- Server Actions inputs
- External API responses
- Job payloads
- Imported files

**`lib/env.ts` rules:**
- Missing mandatory variable fails at boot/build
- Secrets have minimum length validation
- URLs are validated
- Numbers use `z.coerce.number()`
- Feature flags use enum or boolean parser

---

## 8. Security and Authentication

### Auth Stack
- NextAuth v5 + Google OAuth
- Domain restriction via callbacks
- User status: `pending`, `approved`, `rejected`
- Role stored in database
- Sessions invalidated when user is rejected

### Authorization
- Always server-side
- Never trust UI-only checks
- Server Actions and privileged APIs must verify: `auth()`, role, status, specific permission

### Data Classification
Before modeling, classify data:
- Personal data (PII)
- Sensitive personal data
- Operational data
- Financial data
- Integration data

**Rules:**
- Never log PII in plain text
- Mask data when necessary
- Log sensitive access in `audit_log`
- Document retention policy
- Implement deletion when applicable
- Minimize collection

### Threat Modeling Questions (mandatory for every endpoint)
1. Who can call this endpoint?
2. What happens if an anonymous user calls it?
3. What happens if an authenticated user without permission calls it?
4. What sensitive data passes through here?
5. Is there risk of SQLi, XSS, SSRF, CSRF, or Broken Auth?

### Security Layers
```
proxy.ts
  → protected layout with auth()
  → Server Actions/API Routes with auth and authorization
```

---

## 9. Observability

### Structured Logs
Production logs must be JSON. Recommended fields:
```
timestamp, level, message, requestId, userId, route, job, durationMs, status, errorCode
```

**Never log:** tokens, cookies, secrets, complete sensitive payloads, full email, full name, sensitive PII.

### `sync_log` — Automated Jobs
```
job, executed_at, duration_ms, status, counts, error_msg
```

### `audit_log` — Human/Admin Actions
Mandatory events:
- Approve/reject user
- Change role
- Run manual job
- Export data
- Change configuration
- Change financial data
- Access sensitive data
- Change permissions

### APM
Acceptable tools: Sentry, Datadog, OpenTelemetry, Vercel Analytics.
Critical projects must define APM in ADR or deploy documentation.

---

## 10. Testing Strategy

| Layer | Tool |
|-------|------|
| Unit | Vitest |
| Integration | Vitest + test database |
| E2E | Playwright |
| Typecheck | `tsc --noEmit` |
| Lint | ESLint |
| Build | `next build` |

### Test Priority Order
1. Critical Server Actions
2. Auth and authorization
3. `guardCron`
4. `lib/env.ts`
5. Zod schemas
6. Helpers and formatters
7. Critical DAL
8. Critical E2E flows

---

## 11. Deployment

### Environments
| Environment | Use |
|-------------|-----|
| Local | Development |
| Preview | Branches |
| Staging | Validation |
| Production | Real users |

**Never reuse secrets between environments.**

### CI/CD Pipeline (minimum)
```
npm ci
npm run typecheck
npm run lint
npm run test
npm run build
prisma migrate deploy (staging/production)
```

### Healthcheck
Every project must have `GET /api/health`.
Must validate: app responds, DB responds, version/commit when possible.

### Rollback Plan
Every production deploy must have a rollback plan defining:
- Rollback trigger condition
- Responsible person
- Steps
- Database impact
- Migration impact
- Post-rollback validation
- Communication plan
- Maximum decision time

### Migration Classification for Rollback
| Type | Policy |
|------|--------|
| Reversible | Can have automated or manual rollback |
| Compatible | Phase-based deploy |
| Irreversible | Requires explicit human approval |
| Destructive | Requires formal plan and backup |

---

## 12. Anti-Patterns (strictly forbidden)

| Anti-Pattern | Correct Alternative |
|--------------|---------------------|
| `npm audit fix --force` | Manual review / controlled PR |
| `prisma db push` in staging/prod | `prisma migrate deploy` |
| `prisma migrate dev` on real database | Reviewed migration |
| Raw concatenated SQL | Prisma template literal |
| Business logic in `route.ts` | `lib/`, service, or DAL |
| `process.env` scattered | `lib/env.ts` |
| Secret in code | Environment variable |
| Stack trace to client | Generic error message |
| Import library absent in `package.json` | Tech Lead approval |
| `for...of await` when parallelizable | `pMap`/`Promise.all` |
| `<img>` native tag | `<Image>` component |
| SWR without real need | Server Component |
| `middleware.ts` in Next.js 16 | `proxy.ts` |
| `tailwind.config.ts` for v4 theme | `@theme` in globals.css |
| Separate backend without ADR | Next.js monorepo |
| Universal RLS without decision | Conditional policy |
| Job without idempotency | upsert/checkpoint |
| API call inside transaction | Call before/after |
| Merge without test for new rule | Vitest/Playwright |
| Logs with PII | Mask/omit |

---

## 13. New Project Checklist (Architecture Responsibility)

### Structure
- [ ] Next.js 16 with App Router
- [ ] `proxy.ts` configured
- [ ] `auth.ts` configured
- [ ] `lib/env.ts` configured
- [ ] `lib/prisma.ts` with singleton and PrismaPg adapter
- [ ] `prisma.config.ts` with `dotenv.config()`
- [ ] `prisma/migrations/` initialized
- [ ] `docs/adr/` directory created
- [ ] `/api/health` endpoint defined

### Security
- [ ] Google OAuth with domain restriction
- [ ] User status model (pending/approved/rejected)
- [ ] Role in database
- [ ] `guardCron()` for cron routes
- [ ] No hardcoded secrets
- [ ] Server-side authorization
- [ ] Logs without PII

### Database
- [ ] Prisma schema with `@map` / `@@map`
- [ ] Versioned migrations
- [ ] `prisma migrate deploy` in CI
- [ ] Natural constraints for jobs (idempotency)
- [ ] `sync_log` table
- [ ] `audit_log` table

---

## 14. Agent Position in Pipeline

```
Agente01_ProductOwner
  → PRD.md [Gate 1 approved]
    → Agente02_SoftwareArchitect (THIS AGENT)
      → Architecture.md, API_Contract.json, DB Schema, ADRs, Strategies [Gate 2]
        → Agente03_SoftwareEngineer
```

**Collaborations:**
- Consults `Agente07_DevSecOps` for sensitive security decisions
- Consults `Agente08_DevOps` for complex deploy/operational decisions
- Escalates via `Agente00_TechLead` for human approvals
