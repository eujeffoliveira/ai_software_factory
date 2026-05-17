# cron-job-implementation-skill

## Purpose

Implements a complete Vercel Cron job: a thin route handler with `guardCron()` as first call, job business logic in `lib/jobs/[job-name].ts`, `syncLog()` in `finally` block, and an idempotency mechanism.

## When to Use

- Any scheduled or automated background job
- Data synchronization from external sources
- Cleanup jobs (expired sessions, old records)
- Batch notification dispatch
- Any task with type `cron-job` in the atomic task block

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `job_name` | Task spec | Yes |
| `schedule` | Task spec (cron expression) | Yes |
| `idempotency_mechanism` | Task spec | Yes |
| `operations` | Task spec | Yes |

## Outputs

- Route file: `app/api/cron/[job-name]/route.ts`
- Job logic file: `lib/jobs/[job-name].ts`
- `vercel.json` cron entry (or note to add it)

## Procedure

1. **Create route file** — `guardCron(req)` as ABSOLUTE FIRST call
2. **Add** `export const dynamic = "force-dynamic"`
3. **Capture start time** before `try` block
4. **Create try/catch/finally** — job in try, error handling in catch, `syncLog()` in finally
5. **Create job function** in `lib/jobs/[job-name].ts`
6. **Implement idempotency** — upsert or existence check in job function
7. **Return** `Response.json({ ok: status !== "error" })`

## Quality Gate

Gate 4 checks: `checklists/cron_idempotency_checklist.md`, `checklists/sync_log_checklist.md`

## Failure Modes

- FM-09: `guardCron()` not first call
- FM-08: `syncLog()` not in finally
- FM-12: Non-idempotent job (uses `create` instead of `upsert`)
- FM-11: External API inside transaction

## RAG Collections Permitted

- `backend_engineering`
- `data_intensive_applications`

## Architecture Compliance

- Route MUST be at `app/api/cron/[job-name]/route.ts`
- `guardCron(req)` MUST be the absolute first statement
- `syncLog()` MUST be in `finally`
- Job MUST be idempotent

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente04_DevBackend/knowledge/`, `Agente04_DevBackend/context_view.md`, and project input artifacts.
