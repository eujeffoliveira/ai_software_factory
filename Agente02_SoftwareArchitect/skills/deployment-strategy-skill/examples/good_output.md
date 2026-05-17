# Good Output — deployment-strategy-skill

## Scenario

Job board SaaS. Architecture.md has 1 cron job: nightly score sync at 2am UTC. Migration risk: REVERSIBLE (only new tables and columns added). PRD NFR: 99.5% uptime.

## Deployment_Strategy.md (excerpt)

---

## Environments

| Environment | Database | Migration command | Deploy trigger |
|-------------|----------|------------------|---------------|
| Local (sandbox) | Supabase local (`supabase start`) | `prisma db push` | Manual: `npx prisma db push` |
| Staging | Supabase staging project | `prisma migrate deploy` | Automatic: on PR merge to `main` |
| Production | Supabase production project | `prisma migrate deploy` | Manual: Vercel deploy button + human approval |

**IMPORTANT:** `prisma db push` is strictly for local development. It is never run in staging or production.

---

## Migration Execution

Migration command for staging and production: `npx prisma migrate deploy`

Execution timing: Migration runs as a Vercel build step before the application container starts:

```json
// package.json build script
{
  "scripts": {
    "build": "prisma migrate deploy && next build"
  }
}
```

Migration risk for this deployment: **REVERSIBLE** (new tables only — see RISK-011, RISK-012 in Risk_Register.md)

Rollback SQL for migration reversal:
```sql
DROP TABLE IF EXISTS job_applications;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS companies;
```

---

## Vercel Cron Configuration

```json
// vercel.json
{
  "crons": [
    {
      "path": "/api/cron/nightly-score-sync",
      "schedule": "0 2 * * *"
    }
  ]
}
```

### Cron route handler

```typescript
// app/api/cron/nightly-score-sync/route.ts
import { guardCron } from '@/lib/cron'
import { runNightlyScoringSync } from '@/lib/jobs/nightly-score-sync'

export async function GET(request: Request) {
  const guard = await guardCron(request)
  if (!guard.ok) return guard.response  // returns 401 with sync_log error event

  await runNightlyScoringSync()
  return Response.json({ ok: true })
}
```

`guardCron()` validates `Authorization: Bearer {CRON_SECRET}`. If the header is missing or invalid, it returns `401` and logs an `unauthorized_cron_attempt` sync_log event.

---

## Rollback Plan

### Application rollback
- Method: **Vercel Instant Rollback**
- RTO: < 5 minutes
- Trigger condition: error rate > 5% on any critical endpoint for > 2 consecutive minutes
- Authorization: Tech Lead or designated DevOps only

### Database rollback
- Migration risk: REVERSIBLE — rollback SQL included above
- No data loss on rollback (only new tables dropped)
- No backup restoration required for this migration

---

## Post-Deployment Smoke Tests

| Test | Endpoint | Expected outcome |
|------|----------|-----------------|
| Health check | GET /api/health | `200 { "status": "ok", "checks": { "db": "ok" } }` |
| Auth flow | POST /api/auth/signin | Google OAuth redirect completes, session cookie set |
| List jobs | GET /api/jobs | `200` with paginated response, `total >= 0` |
| Create job | POST /api/jobs (RECRUITER session) | `201` with Job object |
| Cron health | GET /api/cron/nightly-score-sync (with CRON_SECRET header) | `200 { "ok": true }` |

---

## Environment Variables

| Var | Local | Staging | Production | Validated by lib/env.ts |
|-----|-------|---------|------------|------------------------|
| DATABASE_URL | ✓ | ✓ | ✓ | Yes |
| DIRECT_URL | ✓ | ✓ | ✓ | Yes |
| NEXTAUTH_SECRET | ✓ | ✓ | ✓ (different) | Yes |
| NEXTAUTH_URL | ✓ | ✓ | ✓ | Yes |
| GOOGLE_CLIENT_ID | ✓ | ✓ | ✓ | Yes |
| GOOGLE_CLIENT_SECRET | ✓ | ✓ | ✓ | Yes |
| CRON_SECRET | ✓ | ✓ (different) | ✓ (different) | Yes |

---

## Why this is a good output

- Three environments defined with distinct migration commands
- `prisma db push` correctly limited to local only; staging and production use `prisma migrate deploy`
- `guardCron()` call shown in the cron route handler with explanation of what it validates
- `CRON_SECRET` listed per environment, confirmed different per environment
- Rollback plan is actionable: Vercel Instant Rollback with 5-minute RTO, rollback SQL included
- 5 smoke tests defined covering: health, auth, read, write, and cron
- All env vars documented with `lib/env.ts` validation confirmed
- `gate_6_prerequisites_met: true`
