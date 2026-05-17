# regression-analysis-skill — Execution Checklist

## Pre-check

- [ ] Previous QA Report available (QA-NNN-C[N-1])
- [ ] All BUG-NNN from previous cycle listed
- [ ] Evaluation cycle is >= 2

## Per Bug Verification

For each BUG-NNN from previous cycle:
- [ ] Code fix present in the resubmission (changed file contains the fix)
- [ ] Regression test present (test name references BUG-NNN or bug condition)
- [ ] Regression test is meaningful (has assertions, not `expect(true).toBe(true)`)
- [ ] Regression test would FAIL if the fix were reverted (mental model check)

## New Bug Detection

- [ ] Changes in the resubmission reviewed for unrelated regressions
- [ ] Any new failures classified by severity
- [ ] CRITICAL new bugs → immediate block

## Report

- [ ] Regression Report produced
- [ ] Verdict assigned: ALL_FIXED_WITH_REGRESSION_TESTS / PARTIAL_FIX_MISSING_TESTS / BUGS_NOT_FIXED / NEW_BUGS_INTRODUCED
- [ ] Verdict impacts Gate 4 decision

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 9 (Regression Test Requirement), `knowledge/decision_rules.md` (DR006), `templates/Regression_Report.md`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
