# Skill: incident-runbook-skill

## Purpose

Produce incident runbooks for critical failure scenarios before go-live. Each runbook contains: symptoms, initial triage steps, resolution steps, escalation path, and postmortem trigger conditions. Must be updated when MTTR > 1 hour for any incident (DR015).

## When to Use

- Before first go-live (produces the initial runbook set — 5 runbooks required)
- After any incident where MTTR > 1 hour (update the relevant runbook)
- When new critical failure modes are identified

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Application architecture context | Required | What services and external dependencies exist |
| Previous incident data | When updating | Incident timeline and root cause for the specific runbook |

## Required Runbooks (minimum 5 for go-live)

1. RUNBOOK-001: Application 500 Errors Spike
2. RUNBOOK-002: Database Connectivity Failure
3. RUNBOOK-003: Authentication Failure (NextAuth/Google OAuth)
4. RUNBOOK-004: Cron Job Failure (missing sync_log, stuck jobs)
5. RUNBOOK-005: Deployment Failure and Rollback Execution

## Outputs

5+ runbook documents following `templates/Runbook_Template.md`

## Procedure

For each required runbook:
1. Identify observable symptoms (what a human sees in logs, alerts, or the UI — not internal state)
2. Write triage steps — ordered actions to diagnose the root cause (e.g., "Check Vercel function logs for status 500 in last 5 minutes")
3. Write resolution steps — ordered actions to restore service (reference specific Vercel dashboard paths, CLI commands, or rollback steps as applicable)
4. Define the escalation path: Level 1 = Agente08_DevOps automated checks → Level 2 = human DevOps on-call → Level 3 = human Tech Lead
5. State postmortem trigger: postmortem is required if MTTR > 1 hour from first alert, any data loss occurred, or the same runbook is triggered twice within 30 days
6. Estimate MTTR from symptom detection to service restoration based on resolution steps duration

## Constraints

- Runbooks must be practical — symptoms observable, steps actionable
- Escalation path must name specific agent roles
- Postmortem trigger conditions must be explicit (MTTR > 1hr, data loss, recurrence within 30 days)
- MTTR estimate must be provided per runbook

## Knowledge Access Policy

At runtime, reads from `knowledge/knowledge_cards.md` Card 011 (Incident Runbook Structure), `knowledge/decision_rules.md` DR015, `failure_modes.md`.
