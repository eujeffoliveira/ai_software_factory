# Agent Routing Skill — Checklist

## Before Routing
- [ ] Identify current phase from State Ledger
- [ ] Confirm gate status is final (not pending)
- [ ] Check routing table for canonical next agent
- [ ] Check for open ADRs that must be passed forward
- [ ] Check for conditions if status is APPROVED_WITH_CONDITIONS

## Agent Selection
- [ ] Next agent is a valid ID from the approved roster
- [ ] Target agent override (if used) validated against roster
- [ ] Routing rationale written and specific
- [ ] Next agent differs from current agent (unless legitimate re-route)

## Briefing Composition
- [ ] All required briefing fields populated (task, inputs, expected_outputs, constraints)
- [ ] Golden model reminders populated for target phase
- [ ] Open ADR IDs listed in `adrs_in_scope` if any exist
- [ ] Conditions from APPROVED_WITH_CONDITIONS included in `constraints`
- [ ] Escalation policy section present in briefing
- [ ] Open questions from State Ledger included if relevant

## State Ledger Update
- [ ] `next_agent` field updated
- [ ] `current_agent` set to "Agente00_TechLead" (routing is always done by Tech Lead)
- [ ] `next_action` is specific (not vague like "proceed")
- [ ] `current_phase` advanced if gate was approved

## Runtime Knowledge Policy
- [ ] Skill does not depend on raw PDFs, raw books, `lib/`, or `context/` at runtime.
