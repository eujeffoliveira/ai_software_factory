# Bad Output Example — cron-job-implementation-skill

```typescript
// app/api/cron/daily-sync/route.ts — 3 violations
import { dailySync } from "@/lib/jobs/daily-sync"
import { syncLog } from "@/lib/sync"
import { guardCron } from "@/lib/jobs/guardCron"

export async function GET(req: Request) {
  const startedAt = Date.now()  // VIOLATION: code before guardCron (FM-09)
  
  guardCron(req)  // WRONG POSITION — must be FIRST

  try {
    await dailySync()
    await syncLog({ job: "daily-sync", status: "success",  // VIOLATION: only in try, not finally (FM-08)
      executedAt: new Date(), durationMs: Date.now() - startedAt, counts: {} })
    return Response.json({ ok: true })
  } catch (error) {
    // syncLog NOT called here — failed executions are invisible in logs
    return Response.json({ ok: false })
  }
}

// lib/jobs/daily-sync.ts
import { prisma } from "@/lib/db/prisma"
export async function dailySync() {
  const items = await fetchItems()
  for (const item of items) {
    await prisma.item.create({ data: { externalId: item.id, name: item.name } })
    // VIOLATION: non-idempotent — creates duplicates on retry (FM-12)
  }
}
```

| Violation | FM | Fix |
|-----------|-----|-----|
| Code before guardCron | FM-09 | `guardCron(req)` must be absolute first line |
| syncLog only in try | FM-08 | Move syncLog to `finally` block |
| bare `create` in job | FM-12 | Replace with `upsert({ where: { externalId }, create, update })` |
