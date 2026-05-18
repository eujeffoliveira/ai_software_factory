# Skill: vercel-deployment-skill

## Purpose

Plan and document the Vercel production deployment configuration. Validates `vercel.json` cron setup, confirms `guardCron()` in all cron route handlers, documents exact deployment steps, and produces the Vercel-specific sections of `Deployment_Plan.md`. This skill prepares the deployment — it does not execute it (human approval required first).

## When to Use

- Every Gate 6 preparation cycle — always
- When `vercel.json` is modified or new cron routes are added
- When deployment platform questions arise

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `vercel.json` | Optional | Vercel project configuration file |
| Cron route handler files | When cron configured | All `app/api/cron/*/route.ts` files |
| Staging deployment URL | Required | Current staging URL for pre-deployment verification |
| Target commit SHA | Required | Git commit being deployed |

## Outputs

| Output | Description |
|--------|-------------|
| Vercel configuration validation | `vercel.json` check results, cron inventory |
| Deployment steps section | Steps 1–10 for `Deployment_Plan.md` |
| Cron job inventory | All cron routes with `guardCron()` verification status |

## Process

1. **Read `vercel.json`** — extract cron schedule entries, identify cron paths
2. **Locate cron route handlers** — find all `app/api/cron/*/route.ts` files
3. **Verify `guardCron()`** — confirm it is the FIRST function call in each handler
4. **Verify `syncLog()` in `finally`** — confirm each cron handler logs in `finally` block
5. **Verify Vercel project configuration** — confirm project exists, staging deployment active
6. **Check deployment platform** — if non-Vercel deployment requested without ADR → return `ADR_REQUIRED`
7. **Produce deployment steps** — ordered steps from staging verification through production deploy
8. **Document cron inventory** — list all cron routes, schedules, `guardCron()` status

## Constraints

- Production deployments require human approval — this skill prepares, does not execute
- `guardCron()` missing in any cron handler → flag as Gate 6 blocking issue (DR009)
- `vercel.json` cron paths must match actual `app/api/cron/*/route.ts` file locations
- Docker/K8s/AWS deployment requests → skill returns `ADR_REQUIRED` status without further processing
- No secrets should appear in `vercel.json` — env vars only in Vercel dashboard

## Knowledge Access Policy

At runtime, this skill reads from:
- `Agente08_DevOps/context_view.md` Section 2 (Vercel Deployment)
- `Agente08_DevOps/knowledge/knowledge_cards.md` Card 002 (Vercel Deployment Architecture), Card 007 (Vercel Cron Job Pattern)
- `Agente08_DevOps/knowledge/decision_rules.md` DR009 (missing guardCron), DR014 (non-Vercel without ADR)

Blocked at runtime: `context/`, `lib/`, `*.pdf`
