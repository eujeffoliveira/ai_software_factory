# Rollback Checklist
## Gate 7 — Rollback Execution

Use this checklist when a rollback trigger condition is met during post-deploy monitoring (Gate 7).

---

## Section 1 — Declare and Record

- [ ] **Record rollback decision time:** [ISO-8601 timestamp]
- [ ] **Record trigger condition:** which condition was met (healthcheck / error rate / smoke test / manual)
- [ ] **Record specific metrics at trigger:** (e.g., "3rd consecutive healthcheck failure at T+2m30s", "error rate 8.2% at T+12m")
- [ ] **Notify Tech Lead immediately** (target: within 5 minutes of trigger)
  - Channel: [project_incident_channel]
  - Message: "Rollback triggered at [time] due to [condition]. Estimated MTTR: [X] minutes."

---

## Section 2 — Application Rollback (target: ~5 minutes)

- [ ] **Open Vercel Dashboard** → [Project Name] → Deployments tab
- [ ] **Locate last known-good deployment**
  - Deployment ID from `Rollback_Plan.md`: [deployment_id]
  - Verify it is the deployment immediately before the current failing one
- [ ] **Click ⋯ menu on last known-good deployment**
- [ ] **Select "Promote to Production"**
- [ ] **Wait for deployment to reach "Ready" status** (2–3 minutes)
- [ ] **Record: rollback deployment completed at** [timestamp]

---

## Section 3 — Post-Application-Rollback Verification

- [ ] **Healthcheck returns 200:** `GET [production_url]/api/healthcheck` → HTTP 200 with `{"status": "ok"}`
- [ ] **Vercel dashboard confirms:** previous deployment is now "Production"
- [ ] **Application version confirmed:** `version` field in healthcheck matches the pre-deploy version

---

## Section 4 — Database Rollback (if migrations were applied)

**Were database migrations applied before the rollback was triggered?**
[ ] YES → proceed with database rollback steps
[ ] NO → skip to Section 5

- [ ] **Assess necessity:** Is the forward-fix migration needed immediately, or can it wait?
  - If application code at rolled-back version is incompatible with the new DB schema → apply immediately
  - If application works correctly despite the new DB schema → can wait and plan
- [ ] **Apply forward-fix migration:**
  ```bash
  npx prisma migrate deploy
  ```
- [ ] **Verify forward-fix applied:** `npx prisma migrate status` → all applied
- [ ] **Record: database forward-fix completed at** [timestamp]
- [ ] **Estimated DB rollback time from `Rollback_Plan.md`:** [X] minutes — [actual time] minutes

---

## Section 5 — Full Service Validation After Rollback

- [ ] **Smoke Test 1:** `GET [production_url]` → HTTP 200 ✓
- [ ] **Smoke Test 2:** `/dashboard` without auth → redirects to `/auth/signin` ✓
- [ ] **Smoke Test 3:** Authenticated primary feature → accessible and functional ✓
- [ ] **Smoke Test 4:** `GET /api/healthcheck` → 200 with `{"status": "ok"}` ✓
- [ ] **Error rate:** Confirm error rate returned to pre-deploy baseline (< 1%)
- [ ] **Monitoring confirmed:** structured logs flowing, error tracker receiving events

---

## Section 6 — Incident Documentation

- [ ] **Record rollback completion time:** [ISO-8601 timestamp]
- [ ] **Calculate MTTR:** [deploy_time] to [service_restored_time] = [X] minutes
- [ ] **Update `Post_Deploy_Report.md`** with rollback timeline and `BLOCKED_SLO_VIOLATION` status
- [ ] **Notify Tech Lead:** rollback complete, service restored, MTTR = [X] minutes
- [ ] **Trigger postmortem:** if MTTR > 1 hour (DR015)
- [ ] **Update incident runbook:** if this scenario had no runbook or runbook was insufficient

---

## Section 7 — Post-Incident Actions (within 24 hours)

- [ ] **Root cause analysis:** what caused the deployment failure?
- [ ] **Which Gate check should have caught this?** (Gate 4, Gate 5, staging smoke tests, etc.)
- [ ] **Process improvement identified:** what checklist item or gate criterion prevents recurrence?
- [ ] **Runbook updated:** if this was a novel failure mode, add runbook
- [ ] **DORA metrics updated:** record Change Failure Rate = YES for this deployment cycle

---

## Runtime Knowledge Policy

This checklist is consulted at runtime from `Agente08_DevOps/checklists/rollback_checklist.md`. Decision rules applied: DR006 (smoke test failure triggers rollback), DR007 (error rate triggers rollback), DR015 (MTTR > 1hr triggers runbook update). Rollback procedure details are in `Rollback_Plan.md` (companion document) and `context_view.md` Section 8.
