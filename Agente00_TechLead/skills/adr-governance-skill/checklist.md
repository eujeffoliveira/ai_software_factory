# ADR Governance Skill — Checklist

## Deviation Detection
- [ ] Deviation clearly described — specific technology or pattern named
- [ ] Golden Model rule explicitly cited (not vague "not following standards")
- [ ] Source artifact identified
- [ ] Deviation category classified: technology / architecture_pattern / irreversible_decision
- [ ] Is this retroactive? (deviation already implemented) → escalate as CRITICAL

## ADR ID Assignment
- [ ] Count existing ADRs in State Ledger
- [ ] Assign next sequential ID: ADR-{NNN}
- [ ] No duplicate IDs

## Process Requirements by Category
- [ ] Technology deviation: Council deliberation mandatory before approval
- [ ] Architecture pattern deviation: Tech Lead review sufficient, Council recommended
- [ ] Irreversible decision: Council mandatory + human approval mandatory

## ADR Content (when reviewing a submitted ADR)
- [ ] Context explains WHY the deviation is needed (not just what)
- [ ] Decision states exactly what is changing from Golden Model
- [ ] At least 2 alternatives considered — each with reason why rejected
- [ ] Consequences section has both positive and negative consequences
- [ ] Approval section names the approver (not "TBD")

## Gate Block
- [ ] `gate_block_required = true` set for all technology deviations
- [ ] Gate status updated to BLOCKED_PENDING_ADR in State Ledger
- [ ] Resolution path is ordered and specific
- [ ] Submitting agent notified of what is needed to unblock

## Resolution
- [ ] ADR approved → gate unblocked, State Ledger updated
- [ ] ADR rejected → agent notified, must revert to Golden Model
- [ ] Superseded ADR → new ADR references old one

## Runtime Knowledge Policy
- [ ] Skill does not depend on raw PDFs, raw books, `lib/`, or `context/` at runtime.
