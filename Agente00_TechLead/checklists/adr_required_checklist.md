# ADR Required Checklist

Run this checklist when reviewing architecture or any technical decision. If any item is checked, an ADR is required before proceeding.

---

## Technology Stack Deviations

- [ ] Using a framework other than Next.js 16
- [ ] Using pages/ router instead of App Router
- [ ] Using middleware.ts instead of proxy.ts in Next.js 16
- [ ] Using React version below 19
- [ ] Using a database other than PostgreSQL
- [ ] Using a cloud database provider other than Supabase
- [ ] Using an ORM other than Prisma
- [ ] Using a deploy platform other than Vercel
- [ ] Using a cron solution other than Vercel Cron
- [ ] Using an auth provider other than Google OAuth
- [ ] Using an auth library other than NextAuth v5
- [ ] Using a CSS framework other than Tailwind CSS v4
- [ ] Using a chart library other than Recharts v3
- [ ] Using a test framework other than Vitest (unit/integration) or Playwright (E2E)

---

## Architecture Pattern Deviations

- [ ] Separating frontend and backend into different repositories
- [ ] Adding a standalone backend service (FastAPI, Express, NestJS, etc.)
- [ ] Adding a dedicated worker process
- [ ] Adding a message queue or async task system
- [ ] Using RLS universally without conditional policy
- [ ] Using Supabase CLI as migration source instead of Prisma Migrate
- [ ] Mixing Prisma Migrate and Supabase CLI without explicit policy
- [ ] Adding Docker or Kubernetes configuration
- [ ] Using edge functions or edge middleware beyond proxy.ts
- [ ] Adding a separate service for AI/embeddings/NLP

---

## Irreversible Decisions

- [ ] Destructive database migration (DROP COLUMN, DROP TABLE, RENAME COLUMN)
- [ ] Changing authentication mechanism
- [ ] Changing authorization model
- [ ] Introducing a new paid external service
- [ ] Changing deploy environment or configuration
- [ ] Adding or changing data retention policies

---

## Risk-Level Decisions

- [ ] Accepting a known security trade-off
- [ ] Accepting a known data protection compliance gap temporarily
- [ ] Introducing a dependency with known CVEs
- [ ] Increasing operational cost significantly

---

## Rule

**If any box is checked → ADR is required before the gate can be approved.**

Send `ADR_Request.md` to Agente02_SoftwareArchitect and block the relevant gate until the ADR is approved.
