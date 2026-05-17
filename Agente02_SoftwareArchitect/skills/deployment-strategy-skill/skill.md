# deployment-strategy-skill

## Purpose

Define the complete deployment strategy for the system: environments, migration execution commands, Vercel Cron job configuration with `guardCron()` safety wrapper, rollback plan, and post-deployment smoke test criteria. The output (`Deployment_Strategy.md`) is a prerequisite for Gate 6 — no deployment proceeds without an approved rollback plan.

## When to Use

- After `Architecture.md`, `Prisma_Schema_Proposal.prisma`, and `API_Contract.json` are drafted
- When a new cron job or migration is introduced to the system
- When DevOps or the Tech Lead raises a deployment concern
- When Gate 6 is blocked because the rollback plan is missing

## Inputs

- `Architecture.md` — components, cron jobs, integrations, and their deployment dependencies
- `Prisma_Schema_Proposal.prisma` — migration needs (from `database-modeling-skill` output)
- `migration_risk_analysis` — risk classification and phased plan from `migration-risk-analysis-skill`
- `context_view_path` — `Agente02_SoftwareArchitect/context_view.md` (§11 Deployment, §1.2 Golden Path)
- `templates/Deployment_Strategy.md` — base template

## Outputs

- `Deployment_Strategy.md` — primary output; environments, migration commands, cron config, rollback plan, smoke tests
- Rollback plan section (extracted as input for Gate 6 pre-requisite check by Agente00)

## Procedure

1. **Define deployment environments** — document each environment:
   
   | Environment | Purpose | Database | Migration command | Deploy trigger |
   |-------------|---------|----------|------------------|---------------|
   | Local (sandbox) | Developer iteration | Local PostgreSQL / Supabase local | `prisma db push` | Manual |
   | Staging | Integration testing + pre-prod validation | Supabase staging project | `prisma migrate deploy` | PR merged to `main` |
   | Production | Live | Supabase production project | `prisma migrate deploy` | Manual approval + deploy button |

   CRITICAL: `prisma db push` is **only** for local/sandbox. Never staging or production.

2. **Define migration execution plan** — for each environment:
   - State the exact command: `npx prisma migrate deploy`
   - State when it runs: before the application starts (Vercel build step) or as a one-time script
   - State who is responsible for running it in production: human operator or automated deploy step
   - Reference the migration risk classification from `migration-risk-analysis-skill`

3. **Configure Vercel Cron jobs** — for each cron job in `Architecture.md`:
   - Define the schedule in `vercel.json`: `"crons": [{ "path": "/api/cron/job-name", "schedule": "0 2 * * *" }]`
   - Define the route handler in `app/api/cron/job-name/route.ts` (thin shell only)
   - **Mandatory: all cron route handlers must call `guardCron(request)` before executing**
   
   The `guardCron()` function validates:
   - The `Authorization: Bearer {CRON_SECRET}` header matches the `CRON_SECRET` env var
   - If the check fails: return `401 Unauthorized` immediately, log `sync_log` event with `error: "unauthorized_cron_attempt"`
   
   Template:
   ```typescript
   // app/api/cron/nightly-score-sync/route.ts
   import { guardCron } from '@/lib/cron'
   import { runNightlyScoringSync } from '@/lib/jobs/nightly-score-sync'
   
   export async function GET(request: Request) {
     const guard = await guardCron(request)
     if (!guard.ok) return guard.response
     
     await runNightlyScoringSync()
     return Response.json({ ok: true })
   }
   ```

4. **Define rollback plan** — mandatory for Gate 6. For each deployment:
   - **Application rollback:** Vercel "Instant Rollback" button reverts to previous deployment. State the SLA: rollback must complete in < 5 minutes.
   - **Database rollback:** Based on migration risk classification:
     - REVERSIBLE: include the rollback SQL or Prisma migration command
     - COMPATIBLE: include the inverse migration command
     - IRREVERSIBLE/DESTRUCTIVE: reference the phased plan from `migration-risk-analysis-skill`; state backup location and restoration procedure
   - State who authorizes a rollback: human operator (Tech Lead or designated DevOps)

5. **Define post-deployment smoke tests** — at minimum:
   - `GET /api/health` returns `200 { "status": "ok" }` and `checks.db === "ok"`
   - Authentication flow: sign-in with Google OAuth completes successfully
   - One critical read: the most frequently accessed read endpoint returns expected data
   - One critical write: a key mutation endpoint (e.g., creating a record) completes without error
   - All cron jobs report healthy in Vercel dashboard (no 401 or 5xx on first scheduled run)

6. **Feature flags and staged rollout** — if PRD requires staged rollout:
   - Document the rollout percentage: 10% → 50% → 100%
   - Document the monitoring period between stages
   - State the rollback trigger condition: if error rate > threshold between stages, rollback

7. **Environment variables checklist** — list every env var required per environment and confirm:
   - `lib/env.ts` validates all required vars at startup
   - Staging vars are not reused in production
   - `CRON_SECRET` is set per environment and different per environment

8. **Populate `Deployment_Strategy.md`** using the template structure.

## Quality Gate

`Deployment_Strategy.md` passes this skill's quality check when:
- Three environments defined: local, staging, production with distinct migration commands
- `prisma migrate deploy` used for staging and production (never `prisma db push`)
- Every cron job in Architecture.md has a `vercel.json` entry and `guardCron()` call
- Rollback plan exists and is actionable (not "we'll figure it out")
- Post-deployment smoke tests defined (at minimum: /api/health + auth + 1 read + 1 write)
- All env vars listed with `lib/env.ts` validation confirmed

## Failure Modes

- **Wrong migration command:** `prisma db push` specified for staging/prod → hard block; Gate 6 requires `prisma migrate deploy`
- **Missing rollback:** Deploy strategy without a rollback plan → Gate 6 is explicitly blocked until rollback plan exists
- **Missing `guardCron()`:** Cron route handler without authorization guard → unauthenticated callers can trigger jobs; this is a security gap
- **Empty smoke tests:** "Test in staging before prod" is not a smoke test → define specific endpoints and expected outcomes
- **Missing `CRON_SECRET`:** Cron jobs configured without `CRON_SECRET` env var → `guardCron()` has nothing to validate against

## RAG Policy

Authorized collections at runtime:
- `architecture_reference_full` (context_view.md §11 Deployment, §1.2 Golden Path)

Blocked at runtime: `context/`, `lib/`, raw PDFs

## Architecture Compliance

This skill's output enforces:
- `context_view.md §11` — Deployment policy
- `context_view.md §1.2` — `prisma migrate deploy` for staging/prod
- `checklists/deployment_strategy_checklist.md`

Gate 6 requires both a rollback plan and explicit human approval — this skill produces the rollback plan artifact.

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:
- its local files (`skill.md`, schemas, checklist, examples)
- `Agente02_SoftwareArchitect/knowledge/`
- `Agente02_SoftwareArchitect/context_view.md`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
