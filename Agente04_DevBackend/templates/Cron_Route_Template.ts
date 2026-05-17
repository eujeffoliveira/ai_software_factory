// TEMPLATE: Replace all [PLACEHOLDER] values with your implementation.
// File location: app/api/cron/[job-name]/route.ts
//
// CRITICAL RULES for cron routes:
// 1. guardCron(req) MUST be the ABSOLUTE FIRST call in the function body
// 2. syncLog() MUST be in the finally block — records execution even on failure
// 3. export const dynamic = "force-dynamic" prevents Vercel from caching the route
// 4. Job logic must be idempotent (safe to run multiple times with same result)

import { guardCron } from "@/lib/jobs/guardCron"
import { [jobName] } from "@/lib/jobs/[job-name]"
import { syncLog } from "@/lib/sync"

// Prevent route caching — required for cron routes
export const dynamic = "force-dynamic"

export async function GET(req: Request): Promise<Response> {
  // ── guardCron MUST BE THE VERY FIRST CALL ─────────────────────────────────
  // Validates: Authorization header contains CRON_SECRET, request is from Vercel.
  // If validation fails, throws immediately — no job execution.
  // NO code before this line. Not variable declarations. Not logging. Nothing.
  guardCron(req)

  // Capture start time BEFORE the try block — needed for accurate durationMs
  const startedAt = Date.now()
  let status: "success" | "error" | "partial" = "success"
  let counts: Record<string, number> = {}
  let errorMsg: string | undefined

  try {
    // Delegate to job function in lib/jobs/[job-name].ts
    // The job function must be idempotent — using upsert or existence checks
    const result = await [jobName]()
    counts = result.counts ?? {}
  } catch (error) {
    // Log the real error internally for operators
    console.error("[cron/[job-name]] job failed:", { error })
    status = "error"
    errorMsg = error instanceof Error ? error.message : "Unknown error"
  } finally {
    // ── syncLog MUST be in finally ───────────────────────────────────────────
    // finally runs whether the job succeeded or failed.
    // This guarantees every execution is recorded in the sync log.
    await syncLog({
      job: "[job-name]",           // matches vercel.json cron key
      executedAt: new Date(),
      durationMs: Date.now() - startedAt,
      status,                      // "success" | "error" | "partial"
      counts,                      // e.g. { processed: 100, created: 23, failed: 0 }
      errorMsg,                    // undefined when status is "success"
    })
  }

  // Return ok: false on error so monitoring tools can detect failures
  return Response.json({ ok: status !== "error" })
}

// ── vercel.json entry (add to your project's vercel.json) ────────────────────
// {
//   "crons": [
//     {
//       "path": "/api/cron/[job-name]",
//       "schedule": "0 0 * * *"    ← replace with your cron expression
//     }
//   ]
// }
