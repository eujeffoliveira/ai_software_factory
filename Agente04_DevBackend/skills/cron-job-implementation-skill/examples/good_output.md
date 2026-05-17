# Good Output Example — cron-job-implementation-skill

```typescript
// app/api/cron/daily-data-sync/route.ts
import { guardCron } from "@/lib/jobs/guardCron"
import { dailyDataSync } from "@/lib/jobs/daily-data-sync"
import { syncLog } from "@/lib/sync"

export const dynamic = "force-dynamic"

export async function GET(req: Request): Promise<Response> {
  guardCron(req)  // FIRST — no code before this

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
    await syncLog({ job: "daily-data-sync", executedAt: new Date(),
      durationMs: Date.now() - startedAt, status, counts, errorMsg })
  }

  return Response.json({ ok: status !== "error" })
}

// lib/jobs/daily-data-sync.ts
import { recordDal } from "@/lib/db/record.dal"
import { externalClient } from "@/lib/integrations/external.client"

export async function dailyDataSync() {
  const records = await externalClient.listRecords()
  let created = 0, updated = 0, failed = 0

  for (const record of records) {
    try {
      await recordDal.upsertByExternalId(record.id, 
        { externalId: record.id, name: record.name, syncedAt: new Date() },
        { name: record.name, syncedAt: new Date() }
      )
      record.isNew ? created++ : updated++
    } catch { failed++ }
  }

  return { counts: { processed: records.length, created, updated, failed } }
}
```

**Why correct:** guardCron first, syncLog in finally, upsert for idempotency, job isolated in lib/jobs/.
