# Human Escalation Skill — Checklist

## Trigger Verification
- [ ] Escalation reason matches a mandatory or recommended trigger
- [ ] Confirm this cannot be resolved autonomously by Council or ADR
- [ ] Urgency level appropriate to impact and timeline

## Options Composition
- [ ] At least 2 options provided (max 4)
- [ ] Each option has: label, description, pros (≥2), cons (≥1), risk level
- [ ] Options are meaningfully different — not minor variations of the same approach
- [ ] Options cover a reasonable range (conservative to aggressive)

## Tech Lead Recommendation
- [ ] Recommendation names a specific option (not "any option is fine")
- [ ] Rationale explains the recommendation — not just restates the option
- [ ] Tech Lead has a position — "I don't know" is not valid

## Escalation Request Content
- [ ] `context` explains the current project state and why human is needed now
- [ ] `decision_required` is a specific question (not "what should we do?")
- [ ] `impact_of_delay` quantifies what is blocked and for how long
- [ ] `blocking` section names the gate and unblock condition

## Pipeline Behavior
- [ ] `pipeline_halt = true` in output — this is non-negotiable
- [ ] No agent routing issued after escalation — pipeline is stopped
- [ ] State Ledger updated with `human_approvals_required` entry

## After Human Response
- [ ] Decision documented in State Ledger `decisions` array
- [ ] Gate unblocked if approved
- [ ] Affected agents notified of decision
- [ ] Relevant artifacts updated if human modified the proposal

## Runtime Knowledge Policy
- [ ] Skill does not depend on raw PDFs, raw books, `01-bibliografia/`, or `00-contexto/` at runtime.
