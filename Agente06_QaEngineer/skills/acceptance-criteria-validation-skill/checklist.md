# acceptance-criteria-validation-skill — Execution Checklist

## Parsing

- [ ] All AC-NNN criteria enumerated from PRD
- [ ] Each criterion has Given, When, and at least one Then clause
- [ ] All Then clauses are measurable (have observable outcomes)
- [ ] Ambiguous criteria identified and flagged for escalation

## Mapping

- [ ] Each Then clause mapped to a specific test file and test case name
- [ ] Test file actually exists in the submitted test files
- [ ] Test case name found within the test file
- [ ] Test is not skipped (`it.skip` or `test.skip`)

## Verification

- [ ] Each mapped test is confirmed PASSING (not in the failure list)
- [ ] Criteria with all Then clauses PASSED → marked as PASSED
- [ ] Criteria with any NO_TEST Then clause → marked as NO_TEST
- [ ] Criteria with any FAILED test → marked as FAILED

## Report

- [ ] Acceptance Validation Report produced using template
- [ ] Summary counts: `passed + failed + no_test + ambiguous == total_criteria`
- [ ] NO_TEST criteria → `BLOCKED_MISSING_TESTS` flagged
- [ ] AMBIGUOUS criteria → escalation initiated, `BLOCKED_MISSING_ACCEPTANCE_CRITERIA` flagged

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 4 (Acceptance Criterion Mapping), `knowledge/decision_rules.md` (DR003, DR009), `checklists/acceptance_criteria_checklist.md`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
