# Regression Report — [Feature / Sprint Name]

**Report ID:** REG-[NNN]-C[cycle]  
**Previous QA Report:** QA-[NNN]-C[previous_cycle]  
**Evaluation Cycle:** [N] (resubmission after [BLOCKED/RETURNED] status)  
**Date:** YYYY-MM-DD  
**Evaluator:** Agente06_QaEngineer  

---

## Overview

This regression report documents the resolution status of every bug identified in the previous QA evaluation cycle (QA-[NNN]-C[previous_cycle]). It verifies that:
1. All reported bugs have been fixed
2. Each fix is accompanied by a regression test
3. No new bugs have been introduced in the resubmission

---

## Bug Resolution Status

| Bug ID | Previous Severity | Title | Fix Status | Regression Test File | Regression Test Name |
|--------|------------------|-------|-----------|---------------------|---------------------|
| BUG-001 | [SEVERITY] | [Title] | [STATUS] | `[test file]` | `[test name]` |
| BUG-002 | [SEVERITY] | [Title] | [STATUS] | `[test file]` | `[test name]` |

**Resolution Status Codes:**
- `FIXED_WITH_REGRESSION_TEST` — Bug fixed, regression test present and passing
- `FIXED_NO_REGRESSION_TEST` — Code fix present, but regression test missing → `RETURNED_FOR_REVISION`
- `NOT_FIXED` — Bug still present in the resubmission → maintains previous gate status
- `REGRESSED` — Was working, now broken again after changes → HIGH severity finding

---

## BUG-001 Regression Verification

**Previous status:** [CRITICAL / HIGH / MEDIUM / LOW]  
**Fix status:** [FIXED_WITH_REGRESSION_TEST / FIXED_NO_REGRESSION_TEST / NOT_FIXED / REGRESSED]

**Code change verified:**  
[Describe what code change was made to fix the bug. Reference the file and the change.]

**Regression test:**
```
File: [path/to/test.test.ts]
Test: [full test name]
Result: PASSING
```

**Test quality check:**  
[ ] The regression test fails when the fix is reverted  
[ ] The regression test name references BUG-[NNN]  
[ ] The test is meaningful (has assertions, not just `expect(true).toBe(true)`)  

---

## BUG-002 Regression Verification

[Same structure as BUG-001 for each bug from the previous cycle]

---

## New Bugs Found in This Resubmission

> Bugs that were not present in the previous QA cycle but were introduced by the fix or are newly discovered.

| Bug ID | Severity | Title | Component | Notes |
|--------|----------|-------|-----------|-------|
| BUG-[NNN] | [SEVERITY] | [Title] | [Component] | [Introduced by fix for BUG-[X] / Newly discovered] |

> If no new bugs: "No new bugs introduced in this resubmission."

---

## Regression Analysis Summary

| Metric | Count |
|--------|-------|
| Bugs from previous cycle | [N] |
| Fixed with regression test | [N] |
| Fixed — missing regression test | [N] |
| Not fixed | [N] |
| New bugs introduced | [N] |

**Verdict:** [ALL_FIXED_WITH_REGRESSION_TESTS / PARTIAL_FIX_MISSING_TESTS / BUGS_NOT_FIXED / NEW_BUGS_INTRODUCED]

---

## Impact on Gate 4 Decision

| Verdict | Gate 4 Implication |
|---------|-------------------|
| ALL_FIXED_WITH_REGRESSION_TESTS | Regression analysis passes — proceed to full QA evaluation |
| PARTIAL_FIX_MISSING_TESTS | `RETURNED_FOR_REVISION` — add missing regression tests, resubmit |
| BUGS_NOT_FIXED | Maintain previous block status — bugs still present |
| NEW_BUGS_INTRODUCED | Classify new bugs by severity — may trigger new block status |

**This regression analysis contributes to Gate 4 decision:** [APPROVED / RETURNED_FOR_REVISION / BLOCKED_*]

---

*Regression report produced by Agente06_QaEngineer. Part of the Gate 4 (QA Review) evaluation for resubmission cycle [N].*
