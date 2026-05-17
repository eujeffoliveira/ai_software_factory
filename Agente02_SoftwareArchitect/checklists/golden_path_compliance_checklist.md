# Golden Path Compliance Checklist

_Run `golden-path-compliance-skill` using this checklist before Gate 2 submission._

---

## Framework

- [ ] Framework: Next.js 16 ✅ OR ADR required for alternative
- [ ] Router: App Router only (no pages/ directory) ✅ OR ADR required
- [ ] Proxy: proxy.ts present (not middleware.ts) ✅ OR ADR required

## Frontend

- [ ] Frontend library: React 19 ✅ OR ADR required
- [ ] Language: TypeScript 5 strict ✅ OR ADR required
- [ ] Styling: Tailwind CSS v4 with @theme ✅ OR ADR required
- [ ] Design tokens: Using generic primary-color/secondary-color variables ✅ OR documented deviation
- [ ] Charts: Recharts v3 ✅ OR ADR required if charts are needed

## Database

- [ ] Database: PostgreSQL on Supabase ✅ OR ADR required for alternative DB
- [ ] ORM: Prisma 7 with PrismaPg adapter ✅ OR ADR required for alternative ORM
- [ ] Migrations: prisma migrate deploy in staging/prod ✅ OR ADR required if mixing tools
- [ ] No prisma db push in staging/production ✅

## Authentication

- [ ] Auth library: NextAuth v5 ✅ OR ADR required
- [ ] Provider: Google OAuth ✅ OR ADR required for additional/alternative provider
- [ ] User status model: pending/approved/rejected ✅

## Deploy

- [ ] Platform: Vercel ✅ OR ADR required for alternative platform
- [ ] Cron: Vercel Cron ✅ OR ADR required for dedicated queue/worker

## Validation

- [ ] Input validation: Zod at all system boundaries ✅

## Tests

- [ ] Unit tests: Vitest ✅ OR ADR required
- [ ] E2E tests: Playwright ✅ OR ADR required

## Email

- [ ] Email: Nodemailer ✅ OR ADR required (if email is in scope)

## Mandatory Patterns

- [ ] lib/env.ts for all environment variables ✅
- [ ] guardCron() in all cron routes ✅
- [ ] audit_log for sensitive human actions ✅
- [ ] sync_log for all automated jobs ✅
- [ ] Structured JSON logs ✅
- [ ] Idempotent job design ✅

## ADR Summary

For every "ADR required" item above, confirm:

- [ ] ADR-NNN has been created for each deviation
- [ ] ADR status is minimum PROPOSED
- [ ] ADR is referenced in Architecture_Decisions.md
- [ ] Gate 2 status is set to BLOCKED_PENDING_ADR if any ADR is REQUIRED_NOT_YET_WRITTEN
