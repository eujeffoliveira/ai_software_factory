# Smoke Test — Web App End-to-End Flow

## Purpose

Verify the full web_app archetype flow from Gate A0 through Gate 2, confirming the factory produces the correct Golden Model stack (Next.js 16, Supabase, Prisma, etc.).

---

## Step 1 — Gate A0: Classification

**Prompt:**
```
@techlead classifique o arquétipo: um portal web onde compradores e fornecedores gerenciam contratos, com autenticação Google, dashboard de métricas, e notificações por email.
```

**Expected:**
- `project_archetype: "web_app"`
- `golden_model: "standards/golden-model-web-app.md"`
- Mentions: Next.js 16, React 19, TypeScript, Tailwind, NextAuth v5, Supabase, Prisma, Vercel

---

## Step 2 — Gate 1: PRD Check

**Prompt:**
```
@po escreva o PRD para este portal de contratos. Usuários: compradores e fornecedores. Funcionalidades: cadastro de contratos, notificações, dashboard.
```

**Expected:**
- User stories in INVEST format
- BDD/Gherkin criteria (Given/When/Then)
- Non-functional requirements (performance, availability)
- Out of scope explicitly defined
- NO technology choices (no mentions of Next.js, Prisma in PRD)

**Must NOT:** Architecture decisions in PRD, vague acceptance criteria

---

## Step 3 — Gate 2: Architecture

**Prompt:**
```
@architect proponha a arquitetura para o portal de contratos (arquétipo: web_app). Inclua API contract e DB schema.
```

**Expected stack:**
- Next.js 16 App Router — NEVER middleware.ts (use proxy.ts)
- React 19 + TypeScript 5 + Tailwind CSS v4
- NextAuth v5 + Google OAuth
- PostgreSQL via Supabase, Prisma 7 with PrismaPg adapter
- `prisma migrate deploy` (NEVER `prisma db push` in staging/prod)
- Vercel deployment + Vercel Cron for scheduled jobs
- Zod validation at all system boundaries
- Vitest (unit) + Playwright (E2E)
- Recharts v3 for dashboard
- Data fetching: Server Components → Server Actions → SWR (polling only)
- Env vars via `lib/env.ts` (NEVER scattered `process.env`)
- Structured JSON logs: `audit_log` + `sync_log`

**Must NOT:**
- `middleware.ts` for API routing (use `proxy.ts`)
- `prisma db push` in production
- Raw `process.env` calls outside lib/env.ts
- Custom auth instead of NextAuth

---

## Critical Invariants

1. **proxy.ts not middleware.ts** — this is a hard rule in the Golden Model
2. **prisma migrate deploy not db push** — db push is forbidden in staging/prod
3. **lib/env.ts** — all env vars must go through this central file
4. **NextAuth v5** — never custom JWT or session management

Any of these violations requires the Tech Lead to return Architecture for revision.
