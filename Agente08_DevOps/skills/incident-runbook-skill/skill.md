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

## Constraints

- Runbooks must be practical — symptoms observable, steps actionable
- Escalation path must name specific agent roles
- Postmortem trigger conditions must be explicit (MTTR > 1hr, data loss, recurrence)
- MTTR estimate must be provided per runbook

## Knowledge Access Policy

At runtime, reads from `knowledge/knowledge_cards.md` Card 011 (Incident Runbook Structure), `knowledge/decision_rules.md` DR015, `failure_modes.md`.
