# Bad Handoff Validation Report

_BAD EXAMPLE — Multiple violations. Do not use as a model._

**Violations:**
- Handoff package fields not validated individually
- Artifact validation is absent — no criterion-by-criterion check
- Gate recommendation given without evidence
- "Looks good" is not a valid validation
- Risks section not evaluated
- Open questions not checked
- No checklist verification
- Gate approved despite missing artifacts (API_Contract.json, DB_Schema)
- No specific next agent or action
- State Ledger update not mentioned

---

## Validation

The Product Owner submitted the PRD. It looks good. The document is complete enough. We can proceed to the next step.

The architecture is also ready-ish, so let's move to implementation.

---

## Gate Recommendation

**Recommended status:** APPROVED

The team has been working hard and we need to keep moving. The document covers the main features.

---

## Action

- [ ] PROCEED — continue

---

_What should have happened:_
- _Each handoff package field checked individually_
- _PRD validated criterion-by-criterion against `artifact_validation_checklist.md`_
- _Missing BDD criteria would have been caught_
- _Missing non-functional requirements would have been caught_
- _API_Contract.json absence (Gate 2 artifact) would have been flagged_
- _State Ledger update documented_
- _Specific next agent named_
