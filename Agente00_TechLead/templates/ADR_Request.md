# ADR Request — {{REQUEST_ID}}

**To:** Agente02_SoftwareArchitect
**From:** Agente00_TechLead
**Date:** {{DATE}}
**Project:** {{PROJECT_NAME}}
**Urgency:** LOW / MEDIUM / HIGH / CRITICAL

---

## Deviation Identified

{{Describe specifically what Golden Path deviation was detected, where it was found, and by which agent or at which gate.}}

---

## Golden Path Rule Violated

**Standard:** {{e.g., "Deploy must use Vercel (reference_architecture §18.1)"}}
**Proposed deviation:** {{e.g., "Deploy on Railway.app"}}

---

## Decision Required

{{One clear question the ADR must answer. The Architect must address this in the ADR.}}

---

## Context

{{Additional context that will help the Architect write a well-informed ADR.}}

---

## Gate Blocked

**Gate {{N}} is blocked** until this ADR is created and approved by the Tech Lead.

---

## ADR Template Reference

Use `docs/adr/ADR-NNN-title.md` with the following structure:

```md
# ADR-NNN — Title

## Status
Proposed

## Date
YYYY-MM-DD

## Context
[Problem being solved]

## Decision
[Decision made]

## Alternatives Considered
| Alternative | Pros | Cons |
|---|---|---|

## Consequences
[Technical, operational, financial impacts]

## Review Criteria
[When to revisit this decision]
```

---

## Instructions

1. Create the ADR file at `docs/adr/ADR-NNN-title.md`.
2. Return the ADR to Tech Lead for validation.
3. Tech Lead will review, approve or request revision, and register in State Ledger.
4. Gate will resume after ADR approval.
