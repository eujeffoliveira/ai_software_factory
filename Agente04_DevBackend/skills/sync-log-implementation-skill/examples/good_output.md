# Good Output Example — sync-log-implementation-skill

```typescript
// startedAt BEFORE try — correct duration
const startedAt = Date.now()
let status: "success" | "error" | "partial" = "success"
let counts: Record<string, number> = {}
let errorMsg: string | undefined

try {
  const result = await dailyDataSync()
  counts = result.counts
} catch (error) {
  console.error("[cron/daily-data-sync] failed:", { error })
  status = "error"
  errorMsg = error instanceof Error ? error.message : "Unknown error"
} finally {
  // finally runs whether try succeeded or catch ran — always records
  await syncLog({
    job: "daily-data-sync",
    executedAt: new Date(),
    durationMs: Date.now() - startedAt,
    status,
    counts,
    errorMsg,
  })
}
```

**Why correct:** `startedAt` before `try`, `syncLog` in `finally`, `status` updated in `catch`, `errorMsg` only set on error.
