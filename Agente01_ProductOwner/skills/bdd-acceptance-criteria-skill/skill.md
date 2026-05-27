# BDD Acceptance Criteria Skill

## Purpose
Create testable, Gherkin-formatted acceptance criteria for each user story, covering the full scenario space: happy path, edge cases, and negative scenarios.

## When to Use
- When user stories are defined and validated (INVEST-compliant) and acceptance criteria need to be written before PRD assembly.
- When an existing acceptance criterion is rejected during Gate 1 review for being vague or non-testable.

## Inputs
- `user_stories[]` — list of INVEST-validated user stories from `User_Story_Map.md`
- `scenario_type` — one of: `all` (default), `happy_path`, `edge_case`, `negative` (for targeted revision)
- `business_rules[]` (optional) — confirmed business rules (BR-NNN) that constrain story behavior
- `nfr_metrics[]` (optional) — relevant NFR metrics that acceptance criteria must reference

## Outputs
- `Acceptance_Criteria.md` — Gherkin-formatted acceptance criteria using `templates/Acceptance_Criteria.md` format

## Constraints
- Every criterion must use Given/When/Then format — no prose descriptions
- Every Then clause must be deterministic and **observable**: the outcome must be verifiable without access to internal system state. Observable means: visible in the UI, present in the API response, or a side-effect queryable via a public interface (e.g., database state confirmed via API, log entry confirmed via monitoring dashboard). Internal state changes (e.g., "the record was saved to the DB") are not observable unless confirmed through an external check.
- Forbidden terms in Then clauses: "fast", "easy", "correctly", "properly", "intuitively", "seamlessly", "user-friendly"
- Performance thresholds must be expressed as measurable metrics (e.g., "≤ 2 seconds", "within 60 seconds")
- Error messages in negative scenarios must be specific (exact text or format specified)
- Criteria must not reference implementation details (no database operations, no API internals, no library names)

## Step-by-Step Procedure

1. **For each user story,** identify:
   - The primary success path (what happens when everything goes right) → Happy Path [HP]
   - Boundary or unusual conditions (valid but non-standard inputs) → Edge Case [EC]
   - Failure conditions (invalid input, unauthorized action, system state prevents action) → Negative Scenario [NS]

2. **Write the Happy Path scenario first.** Establish the Given context (who is the user, what is the initial system state?), the When action (what does the user do, as a single atomic step or short sequence), and the Then outcome (what does the user observe as a result?).

3. **Check the Then clauses against the forbidden terms list.** Replace any vague term with a measurable equivalent.

4. **Write Edge Case scenarios.** Consider: boundary values (e.g., the last item, the minimum/maximum value), concurrent actions (e.g., two users acting simultaneously), optional fields, empty results.

5. **Write Negative Scenarios.** Consider: missing required fields, unauthorized access, actions that business rules prohibit, system states that prevent the action.

6. **Cross-reference with business rules.** If a business rule (BR-NNN) constrains a story, at least one negative scenario must test the rule's enforcement.

7. **Cross-reference with NFRs.** If a performance NFR applies to this story, include the metric in the relevant Then clause (e.g., "And the page loads in ≤ 2 seconds").

8. **Run `checklists/bdd_acceptance_checklist.md`.** Verify format, coverage, testability, and content quality for all criteria. If any checklist item fails, return to the relevant step and fix the criterion before proceeding. Do not declare the output complete until all checklist items pass.

9. **Assign AC-NNN-NN IDs** and write the coverage summary table.

## Knowledge Access Policy

**Allowed at runtime:**
- `Agente01_ProductOwner/knowledge/`
- `Agente01_ProductOwner/templates/`
- `Agente01_ProductOwner/checklists/`
- Project inputs provided by Tech Lead

**Blocked at runtime:**
- `context/`, `lib/`, raw PDFs, global documents
