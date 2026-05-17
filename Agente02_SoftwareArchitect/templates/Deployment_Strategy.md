# Deployment Strategy — [Project Name]

**Version:** 1.0  
**Date:** YYYY-MM-DD  
**Architect:** Agente02_SoftwareArchitect

---

## 1. Environments

| Environment | Purpose | Platform | URL Pattern |
|-------------|---------|----------|-------------|
| Local | Development | Next.js dev server | http://localhost:3000 |
| Preview | Branch validation | Vercel Preview | *.vercel.app |
| Staging | Pre-production validation | Vercel | [project]-staging.vercel.app |
| Production | Live users | Vercel | [project].vercel.app or custom domain |

**Secret isolation:** Each environment has independent secrets. Secrets are NEVER shared between staging and production.

---

## 2. CI/CD Pipeline

### Mandatory steps (every branch/PR):
```
npm ci
npm run typecheck      # tsc --noEmit
npm run lint           # ESLint
npm run test           # Vitest
npm run build          # Next.js build
```

### Staging deploy (additional):
```
prisma migrate deploy  # Run pending migrations
```

### Production deploy (additional):
```
prisma migrate deploy  # Run pending migrations
# Manual: human approval required (Gate 6)
```

---

## 3. Migration Policy

**Source of truth:** Prisma schema + Prisma migrations (not Supabase Dashboard or Supabase CLI)

| Environment | Command | Notes |
|-------------|---------|-------|
| Local | `prisma db push` | Allowed for development only |
| Preview | `prisma migrate deploy` | Via CI/CD |
| Staging | `prisma migrate deploy` | Via CI/CD — mandatory |
| Production | `prisma migrate deploy` | Via CI/CD — mandatory — NEVER `db push` |

**Prohibited commands in staging/production:**
- `prisma db push`
- `prisma migrate dev`
- Direct SQL via Supabase Dashboard (without ADR)

### Pending Migrations

| Migration | Description | Risk Classification | Execution Plan |
|-----------|-------------|---------------------|----------------|
| [migration-name] | [Description] | reversible \| compatible \| irreversible \| destructive | [Plan] |

---

## 4. Cron Jobs

| Job Name | Schedule | Endpoint | Guard | Idempotent |
|----------|----------|----------|-------|------------|
| [job-name] | `0 */6 * * *` (every 6h) | `/api/cron/[job]` | `guardCron()` | Yes |

**vercel.json cron configuration:**
```json
{
  "crons": [
    {
      "path": "/api/cron/[job-name]",
      "schedule": "0 */6 * * *"
    }
  ]
}
```

---

## 5. Rollback Plan

### Trigger Conditions

Roll back when any of the following occur:
- `GET /api/health` returns non-200 for more than 2 minutes after deploy
- APM shows error rate > [X]% for more than [N] minutes
- [Critical business metric] degrades by more than [threshold]
- User-reported critical feature failure is confirmed

### Rollback Steps

1. **Initiate:** Responsible person confirms rollback trigger condition is met.
2. **Application rollback:** Revert Vercel deployment to previous release (Vercel dashboard → Deployments → Redeploy previous).
3. **Database rollback (if migration applied):**
   - If migration is **reversible:** Run reverse migration SQL.
   - If migration is **irreversible or destructive:** Restore from pre-deploy backup.
4. **Validate:** Run post-deploy validation checklist.
5. **Communicate:** Notify stakeholders via [channel].

**Responsible:** [Tech Lead / designated team member]  
**Maximum decision time:** [15 minutes] from trigger confirmation

### Database Impact of Pending Migrations

| Migration | Reversible? | Rollback Plan |
|-----------|-------------|---------------|
| [migration] | Yes/No | [Steps or "Restore backup"] |

### Post-Rollback Validation

- [ ] `GET /api/health` returns `{ "status": "ok" }`
- [ ] Login flow works
- [ ] [Primary critical flow] works
- [ ] No error spike in APM
- [ ] sync_log shows job execution resumed normally

---

## 6. Healthcheck Specification

**Endpoint:** `GET /api/health`  
**Auth:** None required  
**Validation:**
- Application process responds (HTTP 200)
- Database responds to `SELECT 1`
- Response time < 2 seconds

---

## 7. Smoke Test Post-Deploy

After every staging and production deploy, verify:

1. `GET /api/health` → `{ "status": "ok", "db": "ok" }`
2. Login with Google OAuth completes successfully
3. [Primary critical user flow] completes end-to-end
4. Latest cron job executed without error (check sync_log)
5. APM shows no error spike (15-minute observation window for critical deploys)
