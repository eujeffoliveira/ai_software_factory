# State Ledger Update Checklist

Run this checklist every time the State Ledger is updated to ensure consistency.

---

## Trigger Events (update after each)

- [ ] Project initialized
- [ ] Gate decision issued
- [ ] Agent handoff completed
- [ ] ADR created or approved
- [ ] Risk registered
- [ ] Human escalation sent
- [ ] Human decision received
- [ ] Blocker registered
- [ ] Blocker resolved
- [ ] Incident opened
- [ ] Incident resolved

---

## Fields to Verify After Update

- [ ] `current_phase` reflects the actual current phase
- [ ] `current_agent` reflects who is actively working
- [ ] `next_agent` reflects the correct next action
- [ ] `updated_at` is set to current timestamp
- [ ] `approved_artifacts` reflects what has been approved at each gate
- [ ] `next_action` is specific and actionable (not vague)

---

## Arrays to Check

- [ ] `open_questions` — all new questions added, resolved ones marked
- [ ] `decisions` — all gate decisions and major choices recorded
- [ ] `adrs` — all ADRs registered with current status
- [ ] `risks` — all new risks added with correct severity and status
- [ ] `blocked_tasks` — all current blocks listed; resolved blocks removed or marked
- [ ] `human_approvals_required` — pending approvals listed; resolved ones updated with decision
- [ ] `gate_history` — every gate decision appended

---

## Consistency Checks

- [ ] `current_phase` is consistent with `approved_artifacts` (e.g., if PRD is approved, phase should be at least "architecture")
- [ ] `next_agent` is consistent with `current_phase` and gate history
- [ ] All CRITICAL risks are also in `human_approvals_required` or have escalation note
- [ ] All `adrs` with status "Proposed" have a corresponding pending action

---

## After Update

- [ ] State Ledger reflects reality — not a desired future state
- [ ] `next_action` is the literal next step, not a summary
