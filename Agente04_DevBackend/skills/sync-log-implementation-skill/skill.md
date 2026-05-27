# sync-log-implementation-skill

## Purpose

Adds `syncLog()` entries for automated job executions. Every cron job execution — successful or failed — must be recorded with duration, status, and counts in the `finally` block.

## When to Use

- Every cron route handler implementation
- Any background job or bulk data processing function
- After implementing a cron job with `cron-job-implementation-skill`

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `job_name` | Task spec — must match `vercel.json` cron key | Yes |
| `tracked_counts` | Task spec — what to count (processed, created, etc.) | Yes |

## Outputs

- `syncLog({ job, executedAt, durationMs, status, counts, errorMsg })` call in `finally` block
- `startedAt = Date.now()` captured before `try`
- `status` variable tracking success/error/partial

## Procedure

1. Declare `const startedAt = Date.now()` BEFORE the `try` block
2. Declare `status`, `counts`, `errorMsg` variables (initialize `status = "success"`, `errorMsg = undefined`)
3. Set `status = "error"` and `errorMsg = error.message` in `catch` block
4. Place `syncLog(...)` in `finally` block

## Quality Gate

Gate 4 checks: `checklists/sync_log_checklist.md`

## Failure Modes

- FM-08: `syncLog()` only in `try` — misses error recording
- `startedAt` inside `try` — wrong duration
- `status` hardcoded as `"success"` — lies about errors

## RAG Collections Permitted

- `backend_engineering`
- `architecture_reference_backend_view`

## Architecture Compliance

- MUST be in `finally` block
- `startedAt` MUST be before `try`
- `status` MUST reflect actual outcome

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente04_DevBackend/knowledge/`, `Agente04_DevBackend/context_view.md`, and project input artifacts.
