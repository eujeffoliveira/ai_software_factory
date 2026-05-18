# Bad Output — incident-runbook-skill

**Go-Live Ready:** YES ❌ WRONG — only 2 of 5 runbooks produced

**Runbooks:**
- RUNBOOK-001: "If the app breaks, check Vercel logs" (1 line — not a runbook)
- RUNBOOK-002: Database issue — restart the DB (oversimplified, no triage steps)

**Missing:** RUNBOOK-003 (auth), RUNBOOK-004 (cron), RUNBOOK-005 (deploy failure)

**WHAT IS WRONG:**
- "Check Vercel logs" is not a runbook — symptoms, triage steps, resolution, escalation all required
- go_live_ready: true when only 2/5 runbooks are done is incorrect
- Missing 3 runbooks means the team will improvise during auth/cron/deploy incidents
- No estimated MTTR per runbook — team cannot communicate restoration timeline to users
