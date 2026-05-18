# Incident Runbook: [Scenario Name]
**Runbook ID:** RUNBOOK-[NNN]
**Severity:** [P1 — Service Down / P2 — Major Feature / P3 — Minor Feature]
**Last Updated:** [YYYY-MM-DD]

---

## Symptoms

Observable indicators that this runbook applies:

| Symptom | Where to Observe |
|---------|-----------------|
| [Specific observable symptom] | [Vercel function logs / Uptime monitor alert / Error tracker / User reports] |
| [Specific observable symptom] | [Where to see it] |

---

## Initial Triage (first 5 minutes)

**Goal:** Confirm the scenario and assess blast radius before acting.

| Step | Action | Tool / Location | Expected Finding |
|------|--------|-----------------|-----------------|
| 1 | Check healthcheck endpoint | `GET [production_url]/api/healthcheck` | HTTP status + response body |
| 2 | Check Vercel function logs | Vercel Dashboard → Project → Functions → [route] → Logs | Error messages, stack patterns |
| 3 | Check error rate in error tracker | [Sentry / equivalent] → Error frequency chart | Error count + type |
| 4 | Check uptime monitor | [Better Uptime / UptimeRobot] → Incidents | Downtime start time |
| 5 | [Scenario-specific check] | [Location] | [Expected finding] |

**Confirmed scenario?** If yes → proceed to Resolution. If no → consult other runbooks.

---

## Resolution Steps

**Target MTTR: [X] minutes**

| Step | Action | Command / UI Action | Verification | Est. Time |
|------|--------|---------------------|--------------|-----------|
| 1 | [First resolution action] | [Specific command or action] | [How to verify success] | [X min] |
| 2 | [Second resolution action] | [Specific command or action] | [How to verify success] | [X min] |
| 3 | [Third resolution action] | [Specific command or action] | [How to verify success] | [X min] |
| 4 | Verify service restored | Run all 4 smoke tests | 4/4 PASS | ~5 min |
| 5 | Confirm error rate normalized | Check error tracker | < 1% error rate | ~2 min |
| 6 | Notify Tech Lead of resolution | [project_incident_channel] | Acknowledgment received | ~1 min |

**If Step [N] fails:** [What to do if this step does not resolve the issue — next action or escalation]

---

## Escalation Path

If resolution steps do not restore service within [X] minutes:

| Level | Trigger | Contact | Channel |
|-------|---------|---------|---------|
| 1 | Resolution steps fail after [X] minutes | Agente00_TechLead (via human) | [project_incident_channel] |
| 2 | Data integrity concern identified | Database team + Agente00_TechLead | [project_escalation_channel] |
| 3 | Security concern identified | Agente07_DevSecOps + Agente00_TechLead | [project_escalation_channel] |

---

## Postmortem Trigger Conditions

A blameless postmortem is required if any of the following:

- [ ] MTTR > 1 hour
- [ ] Data loss occurred (any amount)
- [ ] This scenario recurred within 30 days
- [ ] > [N] users were affected
- [ ] [Scenario-specific condition]

---

## Prevention

### Process Improvements
- [What deployment process change prevents recurrence]
- [What monitoring improvement provides earlier detection]

### Code Improvements (for responsible Dev agent)
- [What code change reduces the likelihood or impact of this scenario]

### Monitoring Improvements
- [What additional alerting or observability catches this earlier]

---

## Estimated MTTR

| Scenario | Estimate |
|----------|---------|
| Best case (issue is obvious, simple fix) | [X] minutes |
| Typical case (following this runbook) | [X] minutes |
| Worst case (escalation required) | [X] minutes |

---

## Update History

| Date | Updated By | Reason |
|------|-----------|--------|
| [YYYY-MM-DD] | Agente08_DevOps v1.0.0 | Initial runbook created for go-live |
| [YYYY-MM-DD] | [Who] | [Reason — e.g., "Updated after MTTR > 1hr incident on YYYY-MM-DD"] |
