# Bug Report

**Date:** 2026-05-17

## Bug: Test Failed

The createTask test is failing. Please fix it.

The error says something about unauthorized but I'm not sure if it's the test or the code.

**Severity:** Medium maybe?

---

# Why This Bug Report Is BAD

> This section explains every violation in the example above for learning purposes.

### Critical problems that make this bug report useless:

1. **No Bug ID** — Cannot be referenced in the QA Report, cannot be tracked across cycles, cannot be confirmed as fixed in the regression analysis. A bug without an ID is untrackable.

2. **No severity classification** — "Medium maybe?" is not a classification. The severity determines the gate response. A CRITICAL bug (auth bypass) classified as "medium maybe" would result in the gate issuing RETURNED_FOR_REVISION instead of BLOCKED_CRITICAL_RISK — allowing a security vulnerability to proceed. The failure severity checklist must be applied.

3. **"Please fix it"** — Not actionable. What needs to be fixed? Where? Which line? What is the correct behavior? A developer reading this bug report has no idea where to look or what to change.

4. **"I'm not sure if it's the test or the code"** — The QA engineer's job is to determine this. "Not sure" is not an appropriate output. If the test is wrong, that is a test quality issue (RETURNED_FOR_REVISION). If the code is wrong, that is a functional bug (BLOCKED_QA_FAILURE or BLOCKED_CRITICAL_RISK). These lead to very different responses.

5. **No reproduction steps** — "The test is failing" without steps to reproduce means the developer cannot verify the fix. Reproduction steps must be precise enough that a developer can follow them and observe the defect.

6. **No expected vs. actual behavior** — Without knowing what should happen and what actually happens, the developer cannot confirm that their fix addresses the right problem.

7. **No file reference** — "The createTask test" — which file? `createTask.test.ts`, `createTask.spec.ts`, unit test, E2E test? Which test case within the file? The exact file path and test name are required.

8. **No acceptance criterion reference** — Which AC-NNN does this failure violate? Without this link, the bug cannot be traced to a requirement, and the QA coverage table cannot be completed.

9. **No regression test requirement** — The report doesn't mention whether a regression test is needed. For a CRITICAL security bug, a regression test is mandatory. Without this instruction, the developer may fix the code but not add a test, and the same bug can recur in a future refactoring.

10. **No recommendation** — "Please fix it" tells the developer nothing about HOW to fix it. A good bug report includes the specific fix approach, the relevant pattern from context_view.md, and where in the code to apply it.

### The cascade effect of a bad bug report:

- Developer doesn't know what to fix → guesses → may "fix" the wrong thing
- Developer fixes the symptom, not the root cause → passes the specific failing test but the vulnerability persists in a different form
- Regression test is not added → bug reappears in the next sprint
- QA cannot confirm the fix because there are no clear resolution criteria
- Gate 4 resubmission is reviewed again without clear criteria → wasted evaluation cycle

### What the correct report should say:

See `good_bug_report.md` for a complete, actionable bug report for the same scenario. Key differences:
- Precise bug ID (BUG-001)
- Severity classified as CRITICAL with rationale (auth bypass)
- Specific file and line number
- Exact reproduction steps (including the test that failed and what it returned)
- Expected behavior from the acceptance criterion
- Actual behavior (the defect)
- Specific fix recommendation with code example
- Explicit regression test requirement with suggested test name and structure
