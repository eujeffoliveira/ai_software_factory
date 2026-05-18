# Good Rollback Plan Example

This example demonstrates a complete, production-ready Rollback_Plan.md that satisfies Gate 6 requirements.

---

# Rollback Plan
## Feature: User Dashboard with Project Management (v1.2.0)
## Prepared: 2026-05-17
## Companion to: Deployment_Plan.md (Project Dashboard App — 2026-05-18)

> Rollback procedure verified in staging on 2026-05-16.

---

## Rollback Trigger Conditions

| # | Condition | Threshold | Action |
|---|-----------|-----------|--------|
| 1 | Healthcheck consecutive failures | 3 failures within 5-minute window | Rollback immediately |
| 2 | Error rate sustained above threshold | > 5% HTTP 5xx for 10 consecutive minutes | Rollback immediately |
| 3 | Primary feature smoke test failure | Reproducible failure (fails on retry) | Rollback immediately |
| 4 | Manual trigger | Tech Lead or on-call decision | Rollback immediately |

**Monitoring window:** 5 minutes post-deploy (healthcheck), 10 minutes post-deploy (error rate)

---

## Rollback Procedure

### Step 1: Declare Rollback Intent
1. Record exact time: [timestamp when triggered]
2. Record trigger condition and metrics (e.g., "Healthcheck check #7 and #8 and #9 all returned 503")
3. Notify Tech Lead in `#project-incidents` Slack channel within 5 minutes
   - Message: "Rollback initiated at [time] due to [condition]. Estimated service restoration: [time + 8 minutes]"
4. Do NOT attempt to fix or investigate before rolling back — restore service first

### Step 2: Application Rollback (~3–5 minutes)
1. Navigate to: Vercel Dashboard → Project Dashboard App → Deployments tab
2. Locate deployment labeled **"v1.1.0 — 2026-05-10"** (last known-good)
   - Target deployment ID: `dpl_abc123def456`
   - This was the deployment running before v1.2.0 was deployed
3. Click ⋯ menu on the `dpl_abc123def456` deployment
4. Select **"Promote to Production"**
5. Watch Vercel dashboard for status change from "Building" → "Ready"
6. Record completion time

### Step 3: Verify Application Rollback
1. `curl -s https://app.example.com/api/healthcheck | jq .`
   - Expected: `{"status": "ok", "timestamp": "...", "version": "1.1.0"}`
2. Verify `version` field shows `"1.1.0"` (pre-deploy version) — confirms the rollback is active
3. `curl -s -o /dev/null -w "%{http_code}" https://app.example.com/`
   - Expected: 200

### Step 4: Database Rollback (migration `20260515_add_project_status`)

This release added a `status` column to the `projects` table. The application at v1.1.0 does not reference this column, so the column's existence does not cause runtime errors.

**Decision:** Do not apply forward-fix migration immediately unless data integrity requires it. The v1.1.0 application code is backward-compatible with the new schema (it ignores the `status` column).

**Forward-fix migration (prepared, in source control):**
```sql
-- File: prisma/migrations/20260518000000_remove_project_status/migration.sql
ALTER TABLE projects DROP COLUMN IF EXISTS status;
```

**When to apply:** Only if v1.2.0 is not re-deployed within 48 hours (to keep schema in sync with migration history). Decision: Tech Lead.

**Estimated DB rollback time (if applied):** ~2 seconds (42K rows, simple DROP COLUMN)

### Step 5: Post-Rollback Validation
1. `curl -s https://app.example.com/api/healthcheck` → `{"status": "ok", "version": "1.1.0"}`
2. Navigate to https://app.example.com → page loads without errors
3. Navigate to https://app.example.com/dashboard (unauthenticated) → redirects to /auth/signin
4. Check error rate in Sentry: confirm return to baseline (< 1%)
5. Check audit_log in Vercel function logs: confirm entries appearing normally

### Step 6: Notify Tech Lead of Completion
- Message: "Rollback complete at [time]. MTTR: [X] minutes. Service restored. v1.1.0 is now production. Postmortem [required / not required]."

---

## Rollback Owner

**Primary:** Tech Lead (on-call) — makes the rollback decision
**Backup:** Engineering lead — executes if Tech Lead is unreachable

Both have Vercel dashboard access.

---

## Estimated Rollback Time

| Component | Time Estimate |
|-----------|--------------|
| Application rollback (Vercel promote) | ~3–5 minutes |
| Database rollback (if applied) | ~2 minutes |
| Post-rollback validation (smoke tests) | ~5 minutes |
| **Total estimated MTTR** | **~8–12 minutes** (without DB) / **~15 minutes** (with DB) |

---

## Rollback Verification Checklist

- [x] Vercel dashboard shows `dpl_abc123def456` as Production deployment — verified 2026-05-16
- [ ] (during rollback) Healthcheck returns 200 with `version: "1.1.0"`
- [ ] (during rollback) All 4 smoke tests passing
- [ ] (during rollback) Error rate returned to baseline
- [ ] (during rollback) Tech Lead notified with MTTR
- [ ] (during rollback) Gate 7 updated to BLOCKED_SLO_VIOLATION

---

## Rollback Procedure Verification

**Tested in staging:** YES — 2026-05-16
**What was tested:**
1. `vercel --prod` deployed v1.2.0 to staging environment
2. Confirmed `version: "1.2.0"` in healthcheck response
3. Used Vercel dashboard to promote previous staging deployment (v1.1.0 equivalent)
4. Confirmed rollback completed in 2 minutes 47 seconds
5. Confirmed `version: "1.1.0"` in healthcheck response after rollback
6. All 4 smoke tests passed after rollback

---

**WHY THIS IS A GOOD EXAMPLE:**
- Rollback trigger conditions are specific and measurable (not vague)
- Application rollback steps include the exact Vercel deployment ID to target
- Database rollback is analyzed with a clear judgment: "v1.1.0 is backward-compatible with the new schema, so immediate DB rollback is not required"
- Forward-fix migration SQL is shown explicitly
- MTTR estimate is specific (8–12 minutes) and broken down by component
- Rollback procedure was actually tested in staging with specific results documented
- Tech Lead notification is scripted (not just "notify Tech Lead")
