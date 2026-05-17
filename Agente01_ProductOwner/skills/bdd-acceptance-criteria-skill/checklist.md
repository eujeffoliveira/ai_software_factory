# BDD Acceptance Criteria Skill — Checklist

## Before Execution
- [ ] User stories are INVEST-validated before criteria are written
- [ ] Business rules (BR-NNN) relevant to each story have been identified
- [ ] NFR metrics relevant to each story have been identified (especially PERF)

## During Execution
- [ ] Every scenario uses Given/When/Then structure — no prose descriptions
- [ ] Then clauses are checked against the forbidden terms list: fast, easy, correctly, properly, intuitively, seamlessly, user-friendly, smooth, appropriate
- [ ] Each forbidden term found is replaced with a measurable equivalent
- [ ] Business rules that apply to a story have at least one corresponding negative scenario testing the rule enforcement
- [ ] NFR metrics referenced in the Then clause use the exact metric value from Non_Functional_Requirements.md

## Output Validation
- [ ] Every MUST story has at least 1 HP and 1 NS scenario
- [ ] Every MUST story with a boundary condition has at least 1 EC scenario
- [ ] No criterion has an empty Given, When, or Then clause
- [ ] No criterion uses implementation details (no database operations, API calls, library names)
- [ ] Criterion IDs follow AC-NNN-NN convention with sequential numbering
- [ ] bdd_checklist_passed is true — all bdd_acceptance_checklist.md items pass

## Runtime Knowledge Policy
- [ ] Skill reads only from `Agente01_ProductOwner/` and project inputs — never from `context/`, `lib/`, or raw books
- [ ] Gherkin format applied from knowledge in `knowledge/heuristics.md` — not from external references
