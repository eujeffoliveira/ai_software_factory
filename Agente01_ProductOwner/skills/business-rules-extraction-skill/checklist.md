# Business Rules Extraction Skill — Checklist

## Before Execution
- [ ] All stakeholder statements have a source_role and source_session
- [ ] Existing Business_Rules.md reviewed to determine next available BR-NNN ID

## During Execution
- [ ] Each statement evaluated: is it a business constraint/policy (rule) or a technical decision?
- [ ] Technical decisions identified and routed to technical_decisions_found (not created as rules)
- [ ] Rules without sources are NOT confirmed — they become pending_rules with OQ-NNN

## Output Validation
- [ ] Every confirmed rule has a source with at minimum: role + session date
- [ ] Every pending rule has an associated OQ-NNN entry
- [ ] No confirmed rule contains technology decisions (no database, no framework, no pattern names)
- [ ] Rules checklist evaluated against `checklists/business_rules_checklist.md`
- [ ] At least one acceptance criteria negative scenario exists for each confirmed rule (cross-reference)

## Runtime Knowledge Policy
- [ ] Skill reads only from `Agente01_ProductOwner/` and project inputs — never from `context/`, `lib/`, or raw books
