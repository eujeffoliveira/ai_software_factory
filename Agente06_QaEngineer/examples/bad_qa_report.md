# QA Report — Task Feature

**Date:** 2026-05-17  
**Reviewer:** QA

---

## Status: APPROVED

Tests pass. The implementation looks good. I reviewed the code and it seems correct.

---

## Testing Notes

- Ran the tests and they pass
- Checked the main functionality
- The create task feature works
- Delete also works

---

## Issues Found

None.

---

*Approved for Gate 5.*

---

# Why This QA Report Is BAD

> This section explains every violation in the example above for learning purposes.

### Critical problems that make this report invalid:

1. **No Report ID** — Cannot be traced to a specific evaluation cycle. Audit trail is broken.

2. **No evidence for APPROVED** — "Tests pass" without numbers. How many tests? What coverage? Which test framework? This is worthless as evidence. FM-09 (QA Report missing mandatory sections).

3. **No acceptance criteria coverage** — Not one AC-NNN is mentioned. We have no idea if the implementation actually meets any acceptance criterion. This is the most fundamental QA failure.

4. **No API contract validation** — There is no mention of API_Contract.json. None of the endpoints were validated for status codes, response shapes, auth behavior, or error format.

5. **No coverage numbers** — "Tests pass" ≠ coverage meets threshold. 80% minimum line coverage for new business logic is required. This report cannot tell us if that threshold was met.

6. **No accessibility regression** — No keyboard navigation check. No ARIA label check. No error announcement check. Primary flows are unverified for WCAG 2.1 AA compliance.

7. **No bug list** — "None" with no evidence. The correct absence-of-bugs statement requires verifying that all test cases pass, classifying all failures, and then concluding that no bugs remain. "Looks good" is not a bug absence.

8. **Missing 6 of 8 mandatory sections** — Gate decision and "testing notes" is not 8 sections. Missing: test summary, acceptance criteria coverage, API contract validation, accessibility regression, bug list, regression analysis (if resubmission), sign-off checklist.

9. **"The implementation looks good"** — QA does not eyeball code and assert correctness. QA runs tests, measures coverage, validates acceptance criteria, and issues a decision based on evidence. "Looks good" is a subjective assessment, not a QA report.

10. **No gate decision rationale** — Even if the status was APPROVED legitimately, there must be a rationale citing specific evidence. "Tests pass" is not a rationale — it is an assertion without proof.

### What the correct behavior is:

Before issuing APPROVED, the QA engineer must:
- Run `npx vitest run --coverage` and record the numbers
- Run `npx playwright test` and record the numbers
- Map every AC-NNN in the PRD to a test case
- Validate every endpoint in API_Contract.json
- Run accessibility checks on primary flows
- Classify any failures by severity
- Fill out all 8 mandatory sections of QA_Report.md
- Run the qa_quality_checklist.md sign-off checklist

Only after ALL of these steps can an evidence-based gate decision be issued.
