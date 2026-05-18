# Agente08_DevOps — Knowledge Cards

Reference cards for key DevOps concepts. Use at runtime when an operational decision requires conceptual grounding.

---

## Card 001 — DORA Metrics

**What they are:** Four metrics developed by the DevOps Research and Assessment program (DORA) to measure software delivery performance.

| Metric | Definition | Elite | High | Medium | Low |
|--------|------------|-------|------|--------|-----|
| Deployment Frequency | How often code deploys to production | On-demand (multiple/day) | Weekly | Monthly | Every 6 months |
| Lead Time for Changes | Commit to production time | < 1 hour | 1 day – 1 week | 1 week – 1 month | > 1 month |
| Change Failure Rate | % of deploys causing incidents | < 5% | 5–10% | 11–15% | > 15% |
| Mean Time to Recovery (MTTR) | Time to restore after incident | < 1 hour | < 1 day | < 1 week | > 1 week |

**Golden Path targets:** Deployment Frequency weekly, Lead Time < 1 day, Change Failure Rate < 15%, MTTR < 1 hour.

**Source:** The DevOps Handbook – Kim et al.

---

## Card 002 — Vercel Deployment Architecture

**Preview vs. Production deployments:**
- Every push to any branch → Vercel Preview Deployment (unique URL, isolation from production)
- `vercel --prod` → Production Deployment (live on production domain)
- Vercel GitHub integration: PR = Preview, merge to main = can trigger production (with human approval in this framework)

**Key configuration files:**
- `vercel.json` — project configuration: cron schedules, rewrites, headers, build settings
- `.vercelignore` — files excluded from deployment bundle

**Environment variable scopes in Vercel dashboard:**
- Production — only visible to production deployments
- Preview — visible to preview deployments (staging)
- Development — visible to local `vercel dev` sessions

**Rollback mechanism:** Vercel keeps all previous deployments. "Promote to Production" on any previous deployment is an instant rollback (~2–3 minutes).

---

## Card 003 — Prisma Migration Workflow

**Local development (safe to experiment):**
```bash
# Create and apply migration (modifies schema + creates migration file)
prisma migrate dev --name add-user-status

# Reset database and re-apply all migrations (data loss — local only)
prisma migrate reset
```

**Staging and production (never experiment):**
```bash
# Apply pending migration files only — never creates new ones
prisma migrate deploy

# Check migration status
prisma migrate status

# FORBIDDEN in staging/production
prisma db push  # bypasses migration history
```

**Migration file structure:**
```
prisma/migrations/
  20240101120000_add_user_status/
    migration.sql
  20240105090000_add_project_table/
    migration.sql
```

**Forward-fix rollback strategy:**
```sql
-- If 20240101120000_add_user_status added a column and must be undone:
-- Create new migration: 20240110000000_remove_user_status
ALTER TABLE users DROP COLUMN status;
```

---

## Card 004 — Healthcheck Endpoint Specification

**Endpoint:** `GET /api/healthcheck` (no authentication required)

**Expected response (200 OK):**
```json
{
  "status": "ok",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "version": "1.0.0"
}
```

**Error response (503 Service Unavailable):**
```json
{
  "status": "error",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

**DB check implementation:**
```typescript
await prisma.$queryRaw`SELECT 1`
```

**Post-deploy monitoring:**
- Interval: every 30 seconds
- Duration: 5 minutes (10 total checks)
- Failure threshold: 3 consecutive failures → rollback trigger
- Max acceptable response time: 2000ms

---

## Card 005 — Environment Variable Management Pattern

**`lib/env.ts` — the single source of truth:**
```typescript
import { z } from "zod"

const envSchema = z.object({
  // Database
  DATABASE_URL: z.string().url(),
  // Auth
  NEXTAUTH_SECRET: z.string().min(32),
  NEXTAUTH_URL: z.string().url(),
  GOOGLE_CLIENT_ID: z.string().min(10),
  GOOGLE_CLIENT_SECRET: z.string().min(10),
  // App
  NEXT_PUBLIC_APP_URL: z.string().url(),
})

export const env = envSchema.parse(process.env)
```

**Why this pattern:**
- Fails fast at startup if any required env var is missing (Zod throws at parse time)
- Type-safe — `env.DATABASE_URL` is always `string`, never `string | undefined`
- Single place to audit all env var requirements
- Prevents scattered `process.env` calls

**Environments and their variable stores:**
| Env | Store | Rule |
|-----|-------|------|
| Local | `.env.local` (gitignored) | Developer maintains |
| Staging | Vercel dashboard (Preview scope) | Distinct values from production |
| Production | Vercel dashboard (Production scope) | Distinct values from staging |

---

## Card 006 — Smoke Test Suite Pattern

**Minimum 4 smoke tests (Playwright):**

| # | Test Name | What it validates | Failure = |
|---|-----------|------------------|-----------|
| 1 | App loads | GET / returns 200, not error page | Rollback |
| 2 | Auth redirect | Unauthenticated → /auth/signin | Rollback |
| 3 | Primary feature | Authenticated user can use core feature | Rollback |
| 4 | Healthcheck | GET /api/healthcheck returns 200 + ok | Rollback |

**When smoke tests are run:**
- In staging: as part of Gate 6 pre-deploy validation
- In production: immediately after every deployment (Gate 7)
- After rollback: to confirm rollback success

**Flaky test handling:** A single smoke test failure followed by immediate PASS on retry is considered flaky (not a rollback trigger). Two consecutive failures on the same test = rollback trigger.

---

## Card 007 — Vercel Cron Job Pattern

**`vercel.json` configuration:**
```json
{
  "crons": [
    {
      "path": "/api/cron/sync-data",
      "schedule": "0 */6 * * *"
    }
  ]
}
```

**Route handler pattern:**
```typescript
// app/api/cron/sync-data/route.ts
import { guardCron } from "@/lib/cron-guard"
import { syncLog } from "@/lib/sync-log"
import { runSyncJob } from "@/lib/jobs/sync-data"

export async function GET(request: Request) {
  guardCron(request)  // MUST be first — validates Vercel cron secret
  
  const startTime = Date.now()
  let status = "success"
  let errorMsg = null
  let counts = {}
  
  try {
    counts = await runSyncJob()
  } catch (error) {
    status = "error"
    errorMsg = error instanceof Error ? error.message : "Unknown error"
  } finally {
    syncLog({
      job: "sync-data",
      executedAt: new Date().toISOString(),
      durationMs: Date.now() - startTime,
      status,
      counts,
      errorMsg
    })
  }
  
  return Response.json({ status })
}
```

**Common failure:** Missing `guardCron()` → Vercel rejects the request → no sync_log entry → job appears to silently not run.

---

## Card 008 — SLO/SLI/SLA Concepts

**SLI (Service Level Indicator):** A measurable metric of service behavior.
- Examples: error rate (% of 5xx responses), latency (P95 response time), availability (% of time healthcheck returns 200)

**SLO (Service Level Objective):** The target value for an SLI.
- Examples: error rate < 1%, P95 latency < 500ms, availability > 99.9%

**SLA (Service Level Agreement):** A contractual commitment to SLOs (usually customer-facing).
- Example: "99.9% uptime monthly, or 10% service credit"

**Error budget:** The amount of unreliability allowed by the SLO.
- 99.9% availability SLO = 0.1% error budget = ~8.7 hours of downtime per year, ~43 minutes per month

**Gate 7 thresholds (DevOps-specific SLOs):**
- Healthcheck: 100% availability in first 5 minutes post-deploy
- Error rate: < 5% in first 10 minutes post-deploy
- Smoke tests: 4/4 passing

---

## Card 009 — Rollback Decision Matrix

| Signal | Severity | Action | Timing |
|--------|----------|--------|--------|
| Healthcheck fails 3×/5min | CRITICAL | Rollback immediately | < 5 minutes |
| Error rate > 5% for 10 min | HIGH | Rollback | < 15 minutes |
| Primary feature smoke test fails | HIGH | Rollback | Immediately |
| Error rate 2–5% for 10 min | MEDIUM | RETURNED_FOR_MONITORING | 30 min watch |
| Minor performance degradation | LOW | Monitor + note in report | 30 min watch |
| App loads + auth works, primary feature slow | LOW | Monitor + note in report | 30 min watch |

**Vercel rollback steps:**
1. Vercel Dashboard → Project → Deployments
2. Find the last known-good deployment
3. Click ••• → Promote to Production
4. Wait ~2–3 minutes
5. Verify healthcheck returns 200
6. Run smoke tests to confirm

---

## Card 010 — Structured Logging Reference

**audit_log — for human-initiated actions:**
```json
{
  "type": "audit_log",
  "actorId": "user_123",
  "actorEmail": "user@example.com",
  "action": "CREATED_PROJECT",
  "entityType": "project",
  "entityId": "proj_456",
  "metadata": {
    "projectName": "My Project"
  },
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

**sync_log — for automated cron jobs:**
```json
{
  "type": "sync_log",
  "job": "sync-external-data",
  "executedAt": "2024-01-15T10:00:00.000Z",
  "durationMs": 1234,
  "status": "success",
  "counts": {
    "processed": 100,
    "created": 20,
    "updated": 80,
    "errors": 0
  },
  "errorMsg": null
}
```

**Verification in Vercel:** Functions tab → click on function → view logs → search for `"type": "audit_log"` or `"type": "sync_log"`.

---

## Card 011 — Incident Runbook Structure

Every runbook must contain these sections:

| Section | Content |
|---------|---------|
| **Title** | Incident scenario name (e.g., "Database Connectivity Failure") |
| **Severity** | P1 (service down) / P2 (major feature) / P3 (minor feature) |
| **Symptoms** | Observable indicators that trigger this runbook |
| **Initial Triage** | First 5 steps to assess scope and confirm the scenario |
| **Resolution Steps** | Ordered, actionable steps to restore service |
| **Escalation Path** | Who to contact if resolution steps fail (name + channel) |
| **Postmortem Trigger** | Conditions that require a postmortem (MTTR > 1hr, data loss, etc.) |
| **Prevention** | What process/code change prevents recurrence |

**Minimum required runbooks (before go-live):**
1. Application 500 errors spike
2. Database connectivity failure
3. Authentication failure (NextAuth/Google OAuth)
4. Cron job failure
5. Deployment failure / rollback execution

---

## Card 012 — Configuration Management Baseline

**Configuration items that must be version-controlled:**

| Item | Location | Format |
|------|----------|--------|
| Application code | Git repository | TypeScript/TSX |
| Database schema | `prisma/schema.prisma` | Prisma DSL |
| Migration history | `prisma/migrations/` | SQL files |
| CI/CD pipeline | `.github/workflows/` | YAML |
| Vercel cron config | `vercel.json` | JSON |
| Environment variable schema | `lib/env.ts` | TypeScript/Zod |
| Deployment documentation | `Deployment_Plan.md` | Markdown |
| Rollback procedure | `Rollback_Plan.md` | Markdown |

**Configuration items NOT in source control (secrets):**
| Item | Location |
|------|----------|
| `DATABASE_URL` | Vercel dashboard (per environment) |
| `NEXTAUTH_SECRET` | Vercel dashboard (per environment) |
| OAuth client secret | Vercel dashboard (per environment) |
| External API keys | Vercel dashboard (per environment) |

**Drift detection:** If Vercel environment variables do not match `lib/env.ts` Zod schema, the application will fail at startup (Zod throws). This is intentional — startup failure is better than silent misconfiguration.
