# Acceptance Criteria Validation Checklist

> Use when running `acceptance-criteria-validation-skill`. Maps PRD acceptance criteria to test cases.

---

## Pre-Validation

- [ ] PRD document received and accessible
- [ ] All acceptance criteria are numbered (AC-001, AC-002, etc.)
- [ ] Every criterion follows Given/When/Then format (or has been escalated for clarification)
- [ ] The feature scope is clear — no criteria reference features not in this sprint

---

## For Each Acceptance Criterion (AC-NNN)

Repeat this block for every criterion in the PRD:

### Parse the Criterion

- [ ] `Given` clause identifies: who the user is (authenticated/unauthenticated, role if applicable)
- [ ] `When` clause identifies: the specific action taken (form submit, button click, API call, etc.)
- [ ] `Then` clauses are countable and each maps to a measurable, observable outcome

### Check for Ambiguity

Before proceeding, verify the criterion is testable:

- [ ] No vague verbs: "works correctly," "handles properly," "behaves appropriately" — if present, escalate
- [ ] Every `Then` clause has a measurable outcome (a value, a state, a navigation, a visible element)
- [ ] The condition in `Given` is reproducible in a test environment
- [ ] If AMBIGUOUS: mark as AMBIGUOUS in AV report, escalate to Agente01 via Tech Lead, stop

### Map to Tests

- [ ] For each `Then` clause, identify: which test file covers it, which test case name
- [ ] If Vitest: the assertion maps to a specific `expect()` statement
- [ ] If Playwright: the assertion maps to an `await expect(page...)` statement
- [ ] Multiple `Then` clauses may share one test or have separate tests — both are valid
- [ ] If NO_TEST: flag for `BLOCKED_MISSING_TESTS`

### Verify Test Passes

- [ ] The identified test is in the submitted test files (not missing)
- [ ] The test runs successfully (not failing, not skipped)
- [ ] The assertion actually validates the `Then` clause (not a trivial or empty assertion)

---

## Summary Validation

- [ ] All AC-NNN criteria mapped and documented in Acceptance Validation Report
- [ ] `passed + failed + no_test + ambiguous == total_criteria`
- [ ] Any NO_TEST criteria → `BLOCKED_MISSING_TESTS` to be issued
- [ ] Any AMBIGUOUS criteria → escalation initiated, `BLOCKED_MISSING_ACCEPTANCE_CRITERIA` if unresolved
- [ ] Any FAILED criteria → bug classified by severity, bug report produced

---

## Escalation Triggers

Escalate to Agente01_ProductOwner via Tech Lead when:
- Any `Then` clause uses "should work correctly" or equivalent vague language
- The `Given` clause is impossible to reproduce in tests (requires real external service with side effects)
- Two criteria appear to contradict each other
- An acceptance criterion refers to a feature or entity not defined in the PRD

---

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 4 (Acceptance Criterion Mapping), `knowledge/decision_rules.md` (DR003, DR009), `templates/Acceptance_Validation_Report.md`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
