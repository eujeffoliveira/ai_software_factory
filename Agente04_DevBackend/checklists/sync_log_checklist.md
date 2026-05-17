# Sync Log Checklist

**When to run:** For every cron job route implemented.  
**Purpose:** Ensure every automated job execution is recorded — including failures.

---

## Coverage

- [ ] Every cron route calls `syncLog()` — no exceptions
- [ ] `syncLog()` is in the `finally` block — not only in the `try` block
- [ ] `syncLog()` records even when the job throws an exception

## Timing

- [ ] `const startedAt = Date.now()` captured BEFORE the `try` block starts
- [ ] `durationMs: Date.now() - startedAt` computed in the `finally` block
- [ ] `startedAt` is defined before the first `try` statement — not inside `try`

## Status Tracking

- [ ] `status` variable initialized to `"success"` before `try`
- [ ] `status` set to `"error"` in the `catch` block when job fails
- [ ] `status` set to `"partial"` when some items succeed and some fail (where applicable)
- [ ] `status` is one of: `"success"` | `"error"` | `"partial"` — no other values

## Counts Object

- [ ] `counts` variable initialized to `{}` before `try`
- [ ] `counts` populated from job result in `try` block: `counts = result.counts ?? {}`
- [ ] `counts` fields reflect meaningful operational metrics:
  - `processed` — total records examined
  - `created` — new records created
  - `updated` — existing records updated
  - `deleted` — records removed
  - `failed` — records that failed to process
  - `skipped` — records skipped (already up-to-date or out of scope)
- [ ] Count field names match what the monitoring team expects (consistent with previous runs)

## Error Message

- [ ] `errorMsg` initialized to `undefined`
- [ ] `errorMsg` populated in `catch` block: `errorMsg = error instanceof Error ? error.message : "Unknown error"`
- [ ] `errorMsg` is `undefined` when `status` is `"success"` (no false error reports)

## Job Name

- [ ] `job` field value matches the cron key in `vercel.json`
- [ ] `job` field value is kebab-case (e.g., `"daily-data-sync"`)
- [ ] `job` field value is the same every run (no dynamic values)

## SyncLog Function Signature Reference

```typescript
// startedAt MUST be before try
const startedAt = Date.now()
let status: "success" | "error" | "partial" = "success"
let counts: Record<string, number> = {}
let errorMsg: string | undefined

try {
  const result = await jobFunction()
  counts = result.counts ?? {}
} catch (error) {
  console.error("[job-name] failed:", { error })
  status = "error"
  errorMsg = error instanceof Error ? error.message : "Unknown error"
} finally {
  // finally runs whether try succeeded or catch ran
  await syncLog({
    job: "job-name",           // matches vercel.json
    executedAt: new Date(),
    durationMs: Date.now() - startedAt,
    status,
    counts,
    errorMsg,
  })
}
```

---

## Runtime Knowledge Policy

This checklist is part of the agent's local runtime knowledge.  
Do NOT consult `context/`, `lib/`, or global architecture documents.  
All required patterns are in `context_view.md §8`, `knowledge/decision_rules.md` (DR005), and `knowledge/knowledge_cards.md` (Card 005).
