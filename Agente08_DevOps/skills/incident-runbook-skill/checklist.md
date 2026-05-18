# incident-runbook-skill Checklist

## Pre-Execution
- [ ] Action specified: create_initial_set or update_runbook
- [ ] For update: incident summary provided

## Execution (create_initial_set)
- [ ] RUNBOOK-001: Application 500 errors spike produced
- [ ] RUNBOOK-002: Database connectivity failure produced
- [ ] RUNBOOK-003: Authentication failure produced
- [ ] RUNBOOK-004: Cron job failure produced (if cron jobs exist)
- [ ] RUNBOOK-005: Deployment failure / rollback produced
- [ ] Each runbook: symptoms, triage steps, resolution, escalation, postmortem triggers all present

## Execution (update_runbook)
- [ ] Root cause documented in update_history
- [ ] Missing or incorrect steps identified and corrected
- [ ] Prevention section updated
- [ ] MTTR estimate updated

## Post-Execution
- [ ] `go_live_ready` set correctly (true only when all 5 runbooks complete)
- [ ] All runbooks follow `templates/Runbook_Template.md` structure

## Runtime Knowledge Policy
Read from `Agente08_DevOps/` only. Cards: 011. Rules: DR015. Reference: `failure_modes.md`.
