# Gate 2 — Architecture Review

_BAD EXAMPLE — Multiple violations. Do not use as a model._

**Violations:**
- Status code is non-standard ("OK" is not valid)
- Validation results are absent — no item-by-item check
- Rationale is vague and non-specific
- Architecture deviates from Golden Path (separate Express backend) with no ADR mentioned
- Required actions are absent despite issues detected
- Next agent is not specified
- State Ledger update is not mentioned
- No ADR requested for Golden Path deviation

---

## Status

**`OK`** ← INVALID STATUS CODE

---

## Decision Rationale

The architecture looks fine. The team decided to use Express for the backend because they're familiar with it. The database is MongoDB instead of PostgreSQL because it's flexible. No major issues found. Looks good to proceed.

---

## Required Actions

*None listed.*

---

## Next Step

*Not specified.*

---

_Note: This is a bad example. The correct response would have:_
- _Used a valid status code (NEEDS_REVISION or REJECTED_RISK_TOO_HIGH)_
- _Itemized every validation criterion with PASS/FAIL_
- _Flagged Express backend as a Golden Path deviation requiring ADR_
- _Flagged MongoDB as a Golden Path deviation requiring ADR_
- _Blocked the gate until ADRs are created_
- _Provided a specific correction list_
- _Specified the next agent and action_
- _Updated the State Ledger_
