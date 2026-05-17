# Handoff Validation Report

**From Agent:** {{SOURCE_AGENT}}
**Artifact:** {{ARTIFACT_NAME}}
**Gate:** Gate {{GATE_NUMBER}}
**Project:** {{PROJECT_NAME}}
**Validated by:** Agente00_TechLead
**Date:** {{DATE}}

---

## Handoff Package Validation

| Field | Present | Valid | Note |
|---|---|---|---|
| `artifact_produced` | YES / NO | YES / NO | {{note}} |
| `summary` | YES / NO | YES / NO | {{note}} |
| `assumptions` | YES / NO | YES / NO | {{note}} |
| `open_questions` | YES / NO | YES / NO | {{note}} |
| `risks` | YES / NO | YES / NO | {{note}} |
| `required_next_agent` | YES / NO | YES / NO | {{note}} |
| `validation_checklist` | YES / NO | YES / NO | {{note}} |

---

## Artifact Validation

| Criterion | Status | Note |
|---|---|---|
| {{criterion_1}} | PASS / FAIL | {{note}} |
| {{criterion_2}} | PASS / FAIL | {{note}} |
| {{criterion_3}} | PASS / FAIL | {{note}} |

---

## Issues Found

{{List specific issues. If none, write "None — handoff is complete and valid."}}

- [ ] {{issue_1}}
- [ ] {{issue_2}}

---

## Gate Recommendation

**Recommended status:** {{STATUS_CODE}}

**Rationale:** {{Brief explanation}}

---

## Action

- [ ] PROCEED — route to {{NextAgentID}}
- [ ] RETURN — send back to {{SourceAgentID}} with correction list
- [ ] ESCALATE — route to HUMAN or COUNCIL
