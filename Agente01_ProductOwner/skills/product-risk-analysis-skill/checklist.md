# Product Risk Analysis Skill — Checklist

## Before Execution
- [ ] PRD draft and open questions list are available for analysis
- [ ] Risk categories are understood: scope, business, user, data, regulatory, integration

## During Execution
- [ ] Each risk signal from PRD scan produces a formally stated risk (not just a note)
- [ ] Technical implementation risks are moved to technical_risks_excluded — not created as PRISK
- [ ] Impact and probability are justified — not assigned arbitrarily
- [ ] HIGH-impact risks have concrete, actionable mitigations

## Output Validation
- [ ] All PRISK-NNN IDs follow convention and are sequential
- [ ] No risk uses technical implementation language in the description (no ORM, no database, no framework)
- [ ] Every HIGH-impact risk has a mitigation with at least 10 characters
- [ ] HIGH×HIGH risks have a contingency plan
- [ ] technical_risks_excluded documents any technical signals found (even if empty)

## Runtime Knowledge Policy
- [ ] Skill reads only from `Agente01_ProductOwner/` and project inputs — never from `context/`, `lib/`, or raw books
