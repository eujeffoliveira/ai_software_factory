# Agente08_DevOps — Context View

This document is the compiled operational context for Agente08_DevOps. It replaces `context/` at runtime and contains everything the agent needs to plan, execute, and validate deployments without accessing global context files.

---

## 1. Pipeline Position

```
Gate 4 (QA) → Agente06_QaEngineer
Gate 5 (Security) → Agente07_DevSecOps
                           ↓
                    [APPROVED Security_Audit.md]
                           ↓
              Agente08_DevOps ← YOU ARE HERE
                           ↓
                Gate 6: Deployment Plan + Rollback Plan
                [READY_FOR_HUMAN_APPROVAL]
                           ↓
                    Human approves
                           ↓
                Gate 7: Execute + Post-Deploy Report
                [APPROVED | RETURNED | BLOCKED_SLO]
                           ↓
                  Agente00_TechLead (project close)
```

Agente08_DevOps receives: Security_Audit.md (Gate 5 APPROVED) + full implementation package
Agente08_DevOps produces: Deployment_Plan.md + Rollback_Plan.md (Gate 6) → Post_Deploy_Report.md (Gate 7)

---

## 2. Vercel Deployment — Golden Path

### Deployment target
- **Primary platform**: Vercel (Golden Path — no ADR needed)
- **Alternative platforms**: Docker, Kubernetes, AWS ECS → ADR required before DevOps proceeds
- **Staging**: Every PR gets a Vercel Preview Deployment automatically (GitHub integration)
- **Production**: `vercel --prod` after human approval at Gate 6

### Vercel CLI commands
```bash
# Deploy to production (requires human approval first)
vercel --prod

# Deploy to preview (staging)
vercel

# List recent deployments
vercel ls

# Rollback: use Vercel dashboard UI → Project → Deployments → [select previous] → Promote to Production
```

### vercel.json — Cron configuration
```json
{
  "crons": [
    {
      "path": "/api/cron/job-name",
      "schedule": "0 */6 * * *"
    }
  ]
}
```

### guardCron() — mandatory first call in every cron route handler
```typescript
// app/api/cron/job-name/route.ts
import { guardCron } from "@/lib/cron-guard"

export async function GET(request: Request) {
  guardCron(request)  // MUST be the FIRST call — validates Vercel cron secret header
  // ... job logic
}
```

---

## 3. CI/CD Pipeline (GitHub Actions)

### Required pipeline structure
```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Install dependencies
        run: npm ci

      - name: TypeScript typecheck
        run: npx tsc --noEmit

      - name: ESLint
        run: npx eslint .

      - name: Vitest unit tests
        run: npx vitest run

      - name: Next.js build
        run: npx next build

      - name: Playwright E2E (staging only)
        run: npx playwright test
        if: github.ref == 'refs/heads/main'
```

### Gate 6 prerequisite
All pipeline steps must be GREEN on the target commit before Gate 6 can issue `READY_FOR_HUMAN_APPROVAL`. A single failing step triggers `BLOCKED_CI_FAILURE`.

---

## 4. Environment Variables

### Centralization rule
All environment variables are accessed exclusively via `lib/env.ts` using Zod validation:

```typescript
import { z } from "zod"

const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  NEXTAUTH_SECRET: z.string().min(32),
  NEXTAUTH_URL: z.string().url(),
  GOOGLE_CLIENT_ID: z.string().min(10),
  GOOGLE_CLIENT_SECRET: z.string().min(10),
  NEXT_PUBLIC_APP_URL: z.string().url(),
  // Add domain-specific env vars here
})

export const env = envSchema.parse(process.env)
```

If `lib/env.ts` does not exist or uses scattered `process.env`, return to Agente04_DevBackend before deploying.

### Environment variable locations
| Environment | Location | Rule |
|-------------|----------|------|
| Local dev | `.env.local` (gitignored) | Developer manages locally |
| Staging | Vercel dashboard → Project → Settings → Environment Variables (Preview) | Distinct from production |
| Production | Vercel dashboard → Project → Settings → Environment Variables (Production) | Distinct from staging |

### Critical rule: no secret sharing
`DATABASE_URL`, `NEXTAUTH_SECRET`, OAuth credentials, and all API keys must have **distinct values** in staging and production. The same value appearing in both environments is a CRITICAL finding → escalate to Agente07_DevSecOps immediately.

---

## 5. Prisma Migrations

### Allowed commands by environment
| Environment | Allowed command | Forbidden command |
|-------------|-----------------|-------------------|
| Local development | `prisma migrate dev` | — |
| Staging | `prisma migrate deploy` | `prisma db push` |
| Production | `prisma migrate deploy` | `prisma db push` |

### Why `prisma db push` is forbidden in staging/production
- Bypasses migration history — changes are applied without a migration file
- No audit trail of what changed and when
- Cannot be reliably replicated across environments
- Cannot be rolled forward via the migration mechanism

### Migration deployment checklist
Before running `prisma migrate deploy` in any non-local environment:
1. Verify migration file is committed and in source control
2. Verify migration is backward-compatible (no column drops in the same migration as new feature code)
3. Verify no data loss (no DROP without data migration first)
4. Estimate migration duration for large tables (> 1M rows requires online migration strategy)
5. Prepare forward-fix rollback migration (new migration that reverts the change if needed)
6. Obtain human sign-off for destructive operations (DROP COLUMN, DROP TABLE, data-truncating ALTER)

### Migration rollback strategy (forward-fix only)
```sql
-- Example: If migration added column `status VARCHAR(50) NOT NULL DEFAULT 'active'`
-- and we need to "roll back", we write a forward-fix migration:
ALTER TABLE users DROP COLUMN status;
```
Backward migrations (`prisma migrate revert`) are not used. Rollback = forward-fix migration applied via `prisma migrate deploy`.

---

## 6. Healthcheck Endpoint

### Specification
```typescript
// app/api/healthcheck/route.ts
import { prisma } from "@/lib/db"

export async function GET() {
  try {
    await prisma.$queryRaw`SELECT 1`
    return Response.json({
      status: "ok",
      timestamp: new Date().toISOString(),
      version: process.env.npm_package_version ?? "unknown"
    })
  } catch (error) {
    return Response.json(
      { status: "error", timestamp: new Date().toISOString() },
      { status: 503 }
    )
  }
}
```

### Monitoring rules
- No authentication required — public endpoint
- Must respond within 2 seconds
- Checks actual database connectivity
- Post-deploy monitoring: check every 30 seconds for 5 minutes
- **3 consecutive failures → trigger rollback and notify Tech Lead**

---

## 7. Smoke Tests

### Minimum required smoke tests (Playwright)
```typescript
// e2e/smoke.spec.ts
import { test, expect } from "@playwright/test"

test("smoke: app loads", async ({ page }) => {
  const response = await page.goto("/")
  expect(response?.status()).toBe(200)
})

test("smoke: unauthenticated redirects to signin", async ({ page }) => {
  await page.goto("/dashboard")
  await expect(page).toHaveURL(/\/auth\/signin/)
})

test("smoke: primary feature accessible when authenticated", async ({ page }) => {
  // Authenticate via fixture or test credentials
  await page.goto("/api/auth/signin")
  // ... auth flow
  await page.goto("/primary-feature-url")
  await expect(page.locator("[data-testid='primary-feature']")).toBeVisible()
})

test("smoke: API healthcheck returns 200", async ({ request }) => {
  const response = await request.get("/api/healthcheck")
  expect(response.status()).toBe(200)
  const body = await response.json()
  expect(body.status).toBe("ok")
})
```

All 4 smoke tests must pass before Gate 7 APPROVED is issued.

---

## 8. Rollback Strategy

### Application rollback (Vercel)
1. Navigate to Vercel Dashboard → Project → Deployments tab
2. Locate the last known-good deployment (before current release)
3. Click the three-dot menu → "Promote to Production"
4. Wait 2–3 minutes for deployment to complete
5. Verify healthcheck returns 200
6. Verify smoke tests pass

Estimated time: **~5 minutes**

### Database rollback (forward-fix only)
There is no backward migration. If a migration must be undone:
1. Write a new migration file that performs the inverse operation
2. Apply via `prisma migrate deploy`
3. Verify data integrity

**Rollback trigger conditions:**
- Healthcheck fails 3 consecutive times in 5 minutes
- Error rate > 5% sustained over 10 minutes
- Smoke test failure on primary user flow after deploy
- Manual trigger by Tech Lead or on-call engineer

---

## 9. Observability Stack

### Structured logging
```typescript
// audit_log — for human-initiated actions
console.log(JSON.stringify({
  type: "audit_log",
  actorId: session.user.id,
  actorEmail: session.user.email,
  action: "CREATED_PROJECT",
  entityType: "project",
  entityId: project.id,
  metadata: { projectName: project.name },
  timestamp: new Date().toISOString()
}))

// sync_log — for automated/cron jobs
console.log(JSON.stringify({
  type: "sync_log",
  job: "sync-external-data",
  executedAt: new Date().toISOString(),
  durationMs: endTime - startTime,
  status: "success" | "error",
  counts: { processed: 100, created: 20, updated: 80, errors: 0 },
  errorMsg: null
}))
```

### Required before go-live
| Component | Tool | Status check |
|-----------|------|-------------|
| Structured logs | `console.log(JSON.stringify({...}))` | Verify `audit_log` and `sync_log` entries appear in Vercel logs |
| Error tracking | Sentry (or equivalent) | Verify test error appears in Sentry dashboard |
| Uptime monitoring | Better Uptime / UptimeRobot on `/api/healthcheck` | Verify monitor is active |
| Performance | Vercel Web Analytics | Verify Core Web Vitals collecting |

---

## 10. DORA Metrics

| Metric | Definition | Target (Golden Path) |
|--------|------------|---------------------|
| Deployment Frequency | How often code is deployed to production | Weekly |
| Lead Time for Changes | Time from commit to production | < 1 day |
| Change Failure Rate | % of deployments causing incidents | < 15% |
| Mean Time to Recovery (MTTR) | Time to restore service after incident | < 1 hour |

When MTTR > 1 hour or Change Failure Rate > 15% for two consecutive deploys: postmortem required + runbook update before next deploy.

---

## 11. Gate Status Codes Reference

### Gate 6 Status Codes
| Code | Meaning |
|------|---------|
| `READY_FOR_HUMAN_APPROVAL` | All pre-deploy checks pass; awaiting human approval to execute |
| `BLOCKED_NO_ROLLBACK_PLAN` | `Rollback_Plan.md` is missing or incomplete |
| `BLOCKED_MISSING_ARTIFACT` | Required artifact missing (Security_Audit.md, QA_Report.md, etc.) |
| `BLOCKED_CI_FAILURE` | CI/CD pipeline has failing checks on target commit |

### Gate 7 Status Codes
| Code | Meaning |
|------|---------|
| `APPROVED` | Healthcheck passing, smoke tests passing, error rate within threshold |
| `RETURNED_FOR_MONITORING` | Deploy succeeded but requires extended monitoring period |
| `BLOCKED_SLO_VIOLATION` | Healthcheck failures, error rate breach, or smoke test failure triggered rollback |

---

## 12. Agent Pipeline Map (full system reference)

| Agent | Role | Gate |
|-------|------|------|
| Agente00_TechLead | Orchestrates pipeline, approves ADRs, coordinates escalations | Gate 0 (kick-off) |
| Agente01_ProductOwner | Defines requirements, user stories, acceptance criteria | Gate 1 |
| Agente02_SoftwareArchitect | Architecture design, API contracts, schema design | Gate 2 |
| Agente03_SoftwareEngineer | Task decomposition, atomic task specifications | Gate 3 |
| Agente04_DevBackend | Server-side implementation (Server Actions, Route Handlers, DAL, cron) | → Gate 4 |
| Agente05_DevFrontend | Client-side implementation (React components, pages, hooks) | → Gate 4 |
| Agente06_QaEngineer | QA review — functional, regression, integration, performance | Gate 4 |
| Agente07_DevSecOps | Security audit — OWASP, STRIDE, secrets, auth/authz, privacy | Gate 5 |
| **Agente08_DevOps** | **Deployment planning, execution, post-deploy validation** | **Gates 6 & 7** |
| Agente09_DataEngineer | Data pipelines, analytics, ETL (if applicable) | Supporting |
| Agente10_AIEngineer | AI/ML integration, prompt engineering (if applicable) | Supporting |
