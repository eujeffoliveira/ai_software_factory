# deployment-strategy-skill Checklist

## Pre-execution
- [ ] `Architecture.md` available with cron jobs enumerated
- [ ] `Prisma_Schema_Proposal.prisma` available (for migration needs)
- [ ] Migration risk analysis completed (risk levels and phased plans known)
- [ ] `CRON_SECRET` env var existence confirmed in project environment setup
- [ ] Rollback RTO confirmed with Tech Lead (default: 5 minutes via Vercel Instant Rollback)

## During execution

### Environments
- [ ] Three environments defined: local, staging, production
- [ ] Local: `prisma db push` — confirmed local/sandbox only
- [ ] Staging: `prisma migrate deploy` — confirmed
- [ ] Production: `prisma migrate deploy` — confirmed
- [ ] Staging and production have distinct Supabase projects (not shared)
- [ ] Deploy triggers defined: staging (PR merge to main), production (manual approval)

### Migration commands
- [ ] `migration_command_valid: true` — `prisma db push` appears ONLY for local environment
- [ ] Production migration execution: pre-deploy build step OR manual operator command — state which
- [ ] Migration ordering confirmed: migrations run before application starts

### Cron jobs
- [ ] Every cron job in Architecture.md has a `vercel.json` entry with path and schedule
- [ ] Every cron job route handler is documented as a thin shell (no business logic in route.ts)
- [ ] `guardCron(request)` documented as mandatory for every cron route handler
- [ ] `CRON_SECRET` env var listed in environment variables section
- [ ] `CRON_SECRET` confirmed to be different per environment

### Rollback plan
- [ ] Application rollback: Vercel Instant Rollback documented with RTO (< 5 minutes)
- [ ] Database rollback: per migration risk level:
  - [ ] REVERSIBLE: rollback SQL or prisma command included
  - [ ] COMPATIBLE: inverse migration command included
  - [ ] IRREVERSIBLE/DESTRUCTIVE: phased plan reference + backup restoration procedure
- [ ] Rollback authorization: human operator named (Tech Lead or designated DevOps)

### Smoke tests
- [ ] `GET /api/health` → `200 { "status": "ok", "checks": { "db": "ok" } }`
- [ ] Authentication flow: Google OAuth sign-in completes
- [ ] At least 1 critical read endpoint test defined
- [ ] At least 1 critical write endpoint test defined
- [ ] Cron job health check: first scheduled run returns `200` (not `401`)

### Environment variables
- [ ] All required env vars listed per environment
- [ ] `lib/env.ts` Zod validation confirmed for all vars
- [ ] Staging vars confirmed as different from production vars (no cross-environment sharing)

## Post-execution
- [ ] `Deployment_Strategy.md` written to project artifacts folder
- [ ] `migration_command_valid: true`
- [ ] `rollback_plan_present: true`
- [ ] `smoke_tests_defined: true`
- [ ] `gate_6_prerequisites_met: true`
- [ ] Rollback plan section available for Agente00 Gate 6 pre-requisite check

## Runtime Knowledge Policy
- [ ] Skill does not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime
- [ ] Consult: `Agente02_SoftwareArchitect/knowledge/`, `Agente02_SoftwareArchitect/context_view.md`, and project artifacts as input only
