# BDD Acceptance Criteria Checklist

Use this checklist to verify that every acceptance criterion in the PRD is properly formed, testable, and written in valid Gherkin format.

---

## Format Verification

- [ ] Every acceptance criterion has a `Given` clause (precondition / initial context)
- [ ] Every acceptance criterion has a `When` clause (the action or event)
- [ ] Every acceptance criterion has a `Then` clause (the expected observable outcome)
- [ ] `And` clauses are used only to extend `Given`, `When`, or `Then` — not to introduce new scenario branches
- [ ] Each scenario is named with a descriptive title (not just "Scenario 1")
- [ ] Criterion IDs follow convention AC-[STORY]-[SEQ] (e.g., AC-001-01)
- [ ] Scenario type is labeled: [HP] Happy Path, [EC] Edge Case, [NS] Negative Scenario

---

## Scenario Coverage

- [ ] Every MUST user story has at least one happy path scenario [HP]
- [ ] Every MUST user story has at least one negative scenario [NS]
- [ ] MUST stories with boundary conditions have at least one edge case scenario [EC]
- [ ] SHOULD stories have at least one happy path scenario
- [ ] No story has only happy path — at least one failure mode is covered
- [ ] Scenarios are not duplicates of each other (each covers a distinct condition)

---

## Testability

- [ ] `Then` clauses describe observable, deterministic outcomes — not feelings or impressions
- [ ] No `Then` clause uses ambiguous terms: "fast", "easy", "clearly", "properly", "correctly", "seamlessly", "intuitively"
- [ ] Performance thresholds are expressed as concrete metrics (e.g., "response is returned in ≤ 2 seconds")
- [ ] Error messages in negative scenarios are specific (exact message text or format specified)
- [ ] `Given` clauses describe a system state that can be set up in a test environment
- [ ] `When` clauses describe a single, specific action (not a sequence of multiple actions in one clause)
- [ ] Boolean outcomes are unambiguous (e.g., "the system displays a success notification" not "the system confirms")

---

## Content Quality

- [ ] No criterion describes implementation details (no references to specific UI frameworks, database operations, or API calls)
- [ ] `Given` clauses do not assume data that would require test setup knowledge not described in the PRD
- [ ] Criteria are consistent with the corresponding user story's stated benefit
- [ ] Negative scenario describes both the rejection and the user-visible feedback
- [ ] Edge cases reflect real business edge conditions — not arbitrary technical boundaries

---

## Pre-Approval Verification

- [ ] All criteria reviewed against `checklists/invest_checklist.md` testability section
- [ ] Any criterion with a performance threshold is validated against NFR-PERF section
- [ ] Criteria for stories involving PII or sensitive data include privacy-relevant conditions in Given or Then
- [ ] No acceptance criterion has been left blank or marked "TBD"

---

**Acceptance criteria package is ready when:** All items above are checked. Any unchecked item is a defect that must be resolved before Gate 1.
