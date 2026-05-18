# UX Flow Checklist
## Agente09_UxUiDesigner
## Apply before finalizing UX_Flow.md

---

## Pre-Execution Checks

- [ ] `PRD.md` is available and Gate 1 is confirmed approved
- [ ] `Architecture.md` is available and Gate 2 is confirmed approved
- [ ] Feature scope has been identified in PRD — user stories and acceptance criteria located
- [ ] All actor roles are identified from the PRD

---

## Completeness Checks

- [ ] **All features from PRD are covered** — every user story that requires a user-facing screen has a corresponding flow section
- [ ] **All actors are documented** — primary actor defined with role and goal; secondary actors listed if applicable
- [ ] **All entry points are documented** — every URL or app state where this flow can begin
- [ ] **Happy path has at minimum 3 steps** — flows shorter than 3 steps may be incomplete
- [ ] **Every step has all 5 required fields**: actor, action, screen, state, outcome

---

## Error Paths Checks

- [ ] **Authentication error path is documented** — what happens if the user is not authenticated (applies to any `[AUTH REQUIRED]` step)
- [ ] **Data load failure path is documented** — what happens when the primary API call fails
- [ ] **Validation error path is documented** — if any step involves form submission, what happens on validation failure
- [ ] **Server error path is documented** — what happens when a mutation (POST/PUT/DELETE) returns an error
- [ ] **Permission denied path is documented** — if the feature has authorization requirements
- [ ] **At least 2 error paths present** per flow (minimum requirement)

---

## Edge Cases Checks

- [ ] **Empty state edge case documented** — what happens when the data set is zero items
- [ ] **Large data set edge case considered** — pagination or load-more pattern noted
- [ ] **Read-only access edge case documented** — if some users have limited permissions, what changes in the flow
- [ ] **Browser back navigation considered** — what happens if user hits back mid-flow; is state preserved?

---

## Decision Points Checks

- [ ] **All `[DECISION: ...]` annotations have both branches documented** — no one-sided decision points
- [ ] **Decision point conditions are unambiguous** — no vague conditions like "if appropriate" or "if needed"
- [ ] **Auth decision points map to authentication error path** — `[AUTH REQUIRED]` steps link to the auth error path

---

## Annotations Checks

- [ ] **`[AUTH REQUIRED]` applied to all steps that require an active session**
- [ ] **`[LOADING]` applied to steps where async data fetch is in progress**
- [ ] **`[EMPTY]` applied to steps where the screen shows an empty state**
- [ ] **`[ERROR: type]` applied to error path steps** with a specific error type named
- [ ] **`[PERMISSION: role]` applied to steps requiring specific authorization**

---

## PRD Traceability

- [ ] **Every PRD acceptance criterion has a corresponding flow step** — traceability table at end of UX_Flow.md is complete
- [ ] **No flow step covers a feature not in the PRD** — zero scope creep

---

## API Data Verification (DR015)

- [ ] **Every data field referenced in flow steps exists in `API_Contract.json` or `Architecture.md` schema** — no invented data fields
- [ ] **API endpoints referenced in flow outcomes exist in `API_Contract.json`** — no invented endpoints

---

## Runtime Knowledge Policy

This checklist accesses only local distilled knowledge at runtime:
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR004, DR005, DR015
- `Agente09_UxUiDesigner/context_view.md §3` — UX Flow conventions and annotation syntax
- `Agente09_UxUiDesigner/templates/UX_Flow.md` — template reference

**Never reads at runtime**: `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
