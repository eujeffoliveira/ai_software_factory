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

1. **Read `vercel.json`** — extract cron schedule entries, identify cron paths. If `vercel.json` is absent: generate a default configuration from the cron route handlers found (step 2) and flag the generated file in `Deployment_Plan.md` as "vercel.json was missing — generated defaults require human review before deploy"
2. **Locate cron route handlers** — find all `app/api/cron/*/route.ts` files
3. **Verify `guardCron()`** — confirm it is the FIRST function call in each handler. If missing: record as Gate 6 blocking finding with format `BLOCK: guardCron() missing in <file_path> — handler accepts unauthenticated requests`; do not continue verification for that route until fixed
4. **Verify `syncLog()` in `finally`** — confirm each cron handler logs in `finally` block
5. **Verify Vercel project configuration** — confirm project exists, staging deployment active
6. **Check deployment platform** — if non-Vercel deployment requested: verify an ADR exists in the project's ADR registry (typically `docs/adrs/` or referenced in the Handoff Package from Agente02) that explicitly approves the alternative platform. If no such ADR exists → return `ADR_REQUIRED` status without further processing
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
