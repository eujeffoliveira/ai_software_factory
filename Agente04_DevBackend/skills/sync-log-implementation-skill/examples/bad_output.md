# Bad Output Example — sync-log-implementation-skill

```typescript
try {
  const startedAt = Date.now()  // WRONG: inside try — durationMs always small if try fails fast
  const result = await dailyDataSync()
  await syncLog({  // WRONG: only in try — never records failed executions (FM-08)
    job: "daily-data-sync",
    executedAt: new Date(),
    durationMs: Date.now() - startedAt,
    status: "success",  // WRONG: hardcoded — always says success even on failure
    counts: result.counts,
  })
} catch (error) {
  // syncLog NOT called here — failed executions are invisible
  console.error("job failed")
}
```

| Violation | Impact | Fix |
|-----------|--------|-----|
| `startedAt` inside `try` | Wrong duration if try fails fast | Move before `try` |
| `syncLog` only in `try` | Failed executions not recorded | Move to `finally` |
| `status: "success"` hardcoded | Always reports success | Track via variable, update in catch |
| No `errorMsg` | Failures provide no diagnostic info | Populate in catch block |
