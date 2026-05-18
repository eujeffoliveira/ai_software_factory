# Bad Output — observability-setup-skill

**Overall Status:** ALL_CONFIGURED ❌ WRONG — error tracking is MISSING

| Component | Status |
|-----------|--------|
| audit_log | CONFIGURED |
| sync_log | not checked |
| Error tracking | assumed configured ❌ — not verified |
| Uptime monitoring | MISSING ❌ — but marked CONFIGURED |
| Performance | CONFIGURED |

**WHAT IS WRONG:**
- Missing error tracking = flying blind after deploy — must BLOCK Gate 6
- "Assumed configured" is not evidence — test event must be confirmed received
- Uptime monitoring marked CONFIGURED but is MISSING — this means downtime goes undetected
- sync_log not checked — if cron jobs exist, this must be verified
- overall_status ALL_CONFIGURED when there are gaps is incorrect and dangerous
