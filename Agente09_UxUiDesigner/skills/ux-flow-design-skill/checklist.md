# ux-flow-design-skill Execution Checklist
## Agente09_UxUiDesigner

---

## Pre-Execution

- [ ] PRD.md is available and Gate 1 status is confirmed APPROVED
- [ ] Architecture.md is available (Gate 2 confirmed)
- [ ] API_Contract.json is available (or absence is noted — DR015 verification will be limited)
- [ ] Design briefing from Agente00_TechLead specifies which features are in scope
- [ ] Feature scope is clearly identified in PRD.md (user story IDs located)

---

## During Execution

- [ ] All actors identified — primary actor has role + goal; secondary actors documented if present
- [ ] All entry points identified — every URL or app state where this flow can begin
- [ ] Happy path documented step by step — minimum 3 steps
- [ ] Every step has: actor, action, screen (URL), state, outcome
- [ ] `[AUTH REQUIRED]` applied to every step requiring an active session
- [ ] `[LOADING]` applied to every step where async data is being fetched
- [ ] `[DECISION: condition → A | B]` applied to every branching point
- [ ] Both branches of every decision point are documented

---

## Error Path Coverage

- [ ] Authentication error path documented (applies if any step is `[AUTH REQUIRED]`)
- [ ] Primary data load failure path documented
- [ ] Form submission failure path documented (applies if flow includes a form)
- [ ] Server mutation failure path documented (applies if flow includes POST/PUT/DELETE)
- [ ] Permission denied path documented (applies if feature has authorization requirements)
- [ ] Minimum 2 error paths present in the flow

---

## Edge Case Coverage

- [ ] Empty state edge case documented — what shows when the data set is zero items
- [ ] Large dataset edge case noted — pagination or load-more pattern
- [ ] Read-only access edge case documented — if applicable

---

## Data Verification (DR015)

- [ ] Every step referencing API data has been cross-checked against `API_Contract.json`
- [ ] All referenced endpoints exist in `API_Contract.json`
- [ ] All referenced data fields exist in the API response schema or Architecture.md Prisma model
- [ ] Any gaps are documented as escalations (ESC-NNN) in the output schema

---

## PRD Traceability

- [ ] Traceability table at the end of UX_Flow.md is complete
- [ ] Every PRD acceptance criterion in scope maps to at least one flow step
- [ ] No flow step covers a feature not in the PRD

---

## Post-Execution

- [ ] `checklists/ux_flow_checklist.md` completed — all items confirmed
- [ ] Output schema fields completed (screens_identified, error_paths_count, prd_coverage_complete)
- [ ] Escalations documented if any (ESC-NNN format)
- [ ] `ready_for_wireframing: true` confirmed (or escalations pending)

---

## Runtime Knowledge Policy

This skill checklist accesses only local distilled knowledge at runtime:
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR004, DR005, DR015
- `Agente09_UxUiDesigner/context_view.md §3` — UX Flow conventions and annotations
- `Agente09_UxUiDesigner/checklists/ux_flow_checklist.md`
- `Agente09_UxUiDesigner/templates/UX_Flow.md`
- Input artifacts: `PRD.md`, `Architecture.md`, `API_Contract.json`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
