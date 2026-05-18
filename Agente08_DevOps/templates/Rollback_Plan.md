# Rollback Plan
## Feature: [Feature / Release Name]
## Prepared: [YYYY-MM-DD]
## Companion to: Deployment_Plan.md ([Project Name] — [Date])

> This plan must be complete before Gate 6 can issue `READY_FOR_HUMAN_APPROVAL`.
> The rollback procedure must be verified in staging before production deployment.

---

## Rollback Trigger Conditions

Rollback is initiated when **any one** of these conditions is met:

| # | Condition | Threshold | Action |
|---|-----------|-----------|--------|
| 1 | Healthcheck consecutive failures | 3 failures in 5-minute window | Rollback immediately |
| 2 | Error rate | > 5% sustained for 10 minutes | Rollback immediately |
| 3 | Primary feature smoke test failure | Reproducible failure (not flaky) | Rollback immediately |
| 4 | Manual trigger | Tech Lead or on-call engineer decision | Rollback immediately |

**Monitoring window:** 5 minutes post-deploy for healthcheck; 10 minutes for error rate
**Who monitors:** Agente08_DevOps during Gate 7 phase

---

## Rollback Procedure

### Step 1: Declare Rollback Intent
1. Note the exact time rollback was triggered
2. Record which trigger condition was met and the specific metrics
3. Notify Tech Lead immediately (channel: [project_incident_channel])
4. Do NOT attempt to fix the issue before rolling back — rollback first, investigate second

### Step 2: Application Rollback (~5 minutes)

1. Open Vercel Dashboard → [Project Name] → Deployments tab
2. Locate the previous successful production deployment
   - Last known-good deployment ID: **[deployment_id_from_gate_6_verification]**
   - Look for the deployment immediately before the current release
3. Click the three-dot menu (⋯) on the last known-good deployment
4. Select **"Promote to Production"**
5. Wait 2–3 minutes for the deployment to complete
6. Verify deployment status shows "Ready" in Vercel dashboard

### Step 3: Verify Application Rollback
1. `curl -s [production_url]/api/healthcheck | jq .` → should return `{"status": "ok", ...}`
2. Navigate to [production_url] → page should load without errors
3. Verify the release version is no longer the rolled-back version (check `version` field in healthcheck)

### Step 4: Database Rollback (if migrations were applied)

**NOTE: Database rollback uses forward-fix migration — not backward migration.**

**Has this release applied destructive migrations?** [ ] YES → follow steps below / [ ] NO → skip to Step 5

If YES:
1. Assess whether the forward-fix migration is needed immediately
   - If data was not yet written to the dropped/altered column: forward-fix can wait
   - If application errors depend on the reverted column: apply forward-fix immediately
2. Apply forward-fix migration:
   ```bash
   npx prisma migrate deploy
   ```
   _(The forward-fix migration file must already be in `prisma/migrations/` — prepared during Gate 6)_
3. Verify: `npx prisma migrate status` shows all migrations applied including the forward-fix
4. Estimated duration: **[X minutes]**

**Forward-fix migration description:**
> [Describe what the forward-fix migration does — e.g., "Adds back the `status` column to `users` table with default value 'active'"]

### Step 5: Post-Rollback Validation
1. **Healthcheck:** `GET /api/healthcheck` → HTTP 200 with `{"status": "ok"}`
2. **Smoke Test 1:** `GET [production_url]` → HTTP 200
3. **Smoke Test 2:** Navigate to `/dashboard` without auth → redirects to `/auth/signin`
4. **Smoke Test 3:** Authenticate and access primary feature → works as expected
5. **Error rate:** Confirm error rate returns to pre-deploy baseline (< 1%)
6. **Notify Tech Lead:** Rollback complete, service restored

### Step 6: Incident Documentation
1. Record rollback completion time
2. Calculate MTTR (time from deploy to service restoration)
3. Trigger postmortem if MTTR > 1 hour
4. Update Gate 7 report with `BLOCKED_SLO_VIOLATION` status and rollback timeline

---

## Rollback Owner

**Primary:** [Tech Lead (on-call)] — makes the rollback decision, executes or delegates
**Secondary:** [Engineering lead / DevOps engineer (human)]

If rollback takes > 15 minutes or database rollback is needed: escalate to Tech Lead immediately.

---

## Estimated Rollback Time

| Component | Time Estimate |
|-----------|--------------|
| Application rollback (Vercel promote) | ~3–5 minutes |
| Database rollback (forward-fix migration) | [N/A — no destructive migrations] OR [~X minutes] |
| Post-rollback validation (smoke tests) | ~5 minutes |
| **Total estimated MTTR** | **~[8–10] minutes** (app only) / **~[X] minutes** (with DB) |

---

## Rollback Verification Checklist

After rollback is complete, confirm all of the following:

- [ ] Vercel dashboard shows previous deployment as "Production"
- [ ] `GET /api/healthcheck` returns HTTP 200 with `{"status": "ok"}`
- [ ] All 4 smoke tests passing against production
- [ ] Error rate returned to baseline (< 1%)
- [ ] Tech Lead notified with: rollback reason, trigger time, completion time, MTTR
- [ ] Gate 7 report updated with `BLOCKED_SLO_VIOLATION` status
- [ ] Postmortem triggered if MTTR > 1 hour

---

## Rollback Procedure Verification

**Has this rollback procedure been tested in staging?**
- [ ] YES — verified [YYYY-MM-DD]: [what was tested and confirmed]
- [ ] NO — BLOCKS Gate 6 (DR001: rollback must be tested before production deployment)
