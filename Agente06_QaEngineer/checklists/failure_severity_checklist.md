# Failure Severity Classification Checklist

> Use when running `test-failure-classification-skill`. Classifies every test failure and defect by severity.

---

## Classification Decision Tree

For each failure or defect found, apply the following questions in order:

### Step 1: Is this a CRITICAL severity failure?

CRITICAL if ANY of the following are true:
- [ ] An endpoint or Server Action is accessible without authentication (auth bypass)
- [ ] A user can read or modify another user's data (IDOR vulnerability)
- [ ] User input reaches a SQL query via string interpolation (SQL injection possible)
- [ ] A stack trace, error class name, or DB table/column name is returned in an API response
- [ ] A session token, API key, or secret is logged or included in a response
- [ ] A data deletion operation has no confirmation, no rollback plan, and no recovery path
- [ ] Data can be corrupted silently (partial write with no transaction)

**If YES → CRITICAL → BLOCKED_CRITICAL_RISK + escalate to Tech Lead**

---

### Step 2: Is this a HIGH severity failure?

HIGH if the failure is not CRITICAL but ANY of the following are true:
- [ ] A primary feature is completely non-functional (user cannot complete their primary task)
- [ ] Login or logout does not work
- [ ] The main create/edit/delete operation fails with an unhandled error
- [ ] A required form field cannot be submitted (UI bug blocks user completely)
- [ ] An API endpoint returns 500 for a normal, valid request
- [ ] Keyboard navigation is broken for a primary user flow (cannot Tab through key interactions)
- [ ] Focus trap: user cannot escape a modal or dropdown with keyboard
- [ ] Missing ARIA label on a primary action button (screen reader users get no information)
- [ ] Error messages are not announced (primary flow errors silent to screen readers)

**If YES → HIGH → BLOCKED_QA_FAILURE (if primary flow) or RETURNED_FOR_REVISION (with strong recommendation)**

---

### Step 3: Is this a MEDIUM severity failure?

MEDIUM if the failure is not CRITICAL or HIGH but ANY of the following are true:
- [ ] Feature works but produces misleading or confusing output
- [ ] Error message is unhelpful or points the user in the wrong direction
- [ ] A secondary flow (not the primary user task) is broken but the main flow still works
- [ ] A form field accepts invalid input (no validation feedback) but the system handles it gracefully
- [ ] UI layout is broken in specific viewport or browser (not blocking feature use)
- [ ] Accessibility violation in a secondary flow (workaround exists)
- [ ] Pagination or sorting is off but the data is accessible via other means
- [ ] A Playwright test uses CSS selectors (selector policy violation — not a UX bug)
- [ ] Brittle test that breaks on refactoring (test design issue, not functional bug)

**If YES → MEDIUM → RETURNED_FOR_REVISION**

---

### Step 4: This is a LOW severity failure

LOW if none of the above apply:
- [ ] Cosmetic issues: misaligned element, wrong shade of color, typo in non-critical label
- [ ] Minor UX improvement opportunity (not a bug, but noted)
- [ ] Test naming convention not followed (e.g., `it("works")` instead of behavior-based name)
- [ ] Console warning present (non-functional, no user impact)

**LOW → Tracked in QA Report bug list, does not block gate**

---

## Bug Classification Form

For every defect classified, record:

```
Bug ID:     BUG-[NNN]
Severity:   [CRITICAL / HIGH / MEDIUM / LOW]
Title:      [Short precise title]
Component:  [Feature area]
File:       [path/to/file.ts]
AC violated: [AC-NNN / SECURITY / COVERAGE]
Responsible: [Agente04_DevBackend / Agente05_DevFrontend]
Gate impact: [BLOCKED_CRITICAL_RISK / BLOCKED_QA_FAILURE / RETURNED_FOR_REVISION / Tracked]
```

---

## Gate Impact by Severity

| Severity | Gate 4 Impact |
|----------|--------------|
| CRITICAL | `BLOCKED_CRITICAL_RISK` — immediate block + Tech Lead escalation |
| HIGH | `BLOCKED_QA_FAILURE` — block (primary flow) or `RETURNED_FOR_REVISION` (secondary) |
| MEDIUM | `RETURNED_FOR_REVISION` — must be fixed before next approved cycle |
| LOW | Tracked in QA Report — does not block gate |

---

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 8 (Bug Severity Matrix), `knowledge/decision_rules.md` (DR008, DR011, DR012), `failure_modes.md` (FM-05).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
