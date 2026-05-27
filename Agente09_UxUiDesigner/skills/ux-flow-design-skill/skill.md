# Skill: ux-flow-design-skill
## Agente09_UxUiDesigner

---

## Purpose

Maps complete user journeys for a feature from PRD acceptance criteria. Produces `UX_Flow.md` — a structured document covering actors, entry points, happy path steps, error paths, decision points, and edge cases. The flow drives which screens get wireframed.

---

## When to Use

- A new feature is being designed and the user journeys must be mapped before wireframing
- An existing feature is being redesigned and the full journey needs re-evaluation
- The Tech Lead activates Agente09 and designates specific features for design
- A PRD change adds or modifies user-facing acceptance criteria

**Do NOT trigger when:**
- The feature is backend-only with no user-facing screens
- A UX Flow already exists and is confirmed correct for the current design scope
- The feature involves only a static page with no user interaction (no decision points, no async data)

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `PRD.md` | Yes | Source of truth for user stories and acceptance criteria |
| `Architecture.md` | Yes | Route structure, API contracts, data models |
| `API_Contract.json` | Recommended | To verify that API endpoints referenced in flow steps actually exist |
| Design briefing | Yes | Scoped feature list from Agente00_TechLead |

Schema: `input.schema.json`

---

## Outputs

| Output | Description |
|--------|-------------|
| `UX_Flow.md` | Complete user journey document following the flow template |
| Escalation list | Any ambiguous PRD criteria that could not be designed without a product decision |

Schema: `output.schema.json`

---

## Procedure

1. **Identify all features in scope.** Read the design briefing from Tech Lead. List every user story that has a user-facing screen. Confirm they all passed Gate 1.

2. **For each feature, identify actors.** Who is the primary actor? What do they want to accomplish? Are there secondary actors (admin viewing, system triggering)?

3. **Map entry points.** How does a user arrive at this flow? Direct navigation? Notification link? Redirect after another action?

4. **Map the happy path.** Walk through the flow step by step from entry to successful completion. For each step: actor, action, screen (URL), state (loading/populated/empty), outcome. Annotate auth-required steps, loading states, and decision points.

5. **Map error paths.** Systematically ask: "What if the user is not authenticated?", "What if the primary data load fails?", "What if a form submission fails?", "What if the user lacks permission?" Each answer with a distinct trigger condition becomes a separate error path. Path counting: `unauthenticated` and `unauthorized (lacks permission)` are two distinct paths even though both end at an error screen. Multiple form field validation errors are one path ("form validation failed"). Minimum 2 distinct error paths per flow.

6. **Map edge cases.** Ask: "What if the data set is empty?", "What if the dataset is very large?", "What if the user has read-only access?", "What if a required dependency (e.g., no projects for a task) is missing?"

7. **Mark decision points.** For each step in the happy path where the flow branches, add a `[DECISION: condition → Path A | Path B]` annotation.

8. **Verify API data.** For each step that references API data, confirm the endpoint and data fields exist in `API_Contract.json` (DR015). If a flow step requires an endpoint that does not exist in the contract: add it to the escalation list as `ESC-NNN: missing API endpoint — <method> <path> required for flow step <N>` and notify Tech Lead; do NOT design the flow step as if the endpoint exists.

9. **Build the traceability table.** For each PRD acceptance criterion, identify which flow step covers it. Report any uncovered criteria.

10. **Escalate ambiguities.** For any PRD criterion that cannot be designed without making a product decision, stop and create an escalation (ESC-NNN) for Tech Lead. Do not design around the ambiguity.

11. **Verify escalations before delivery.** If any escalations (ESC-NNN) are open, the UX Flow is NOT complete. Confirm each escalation has either been resolved (product decision received) or explicitly acknowledged as a blocker by Tech Lead. Do not deliver the flow with unacknowledged escalations.

12. **Run `checklists/ux_flow_checklist.md`.** Confirm all items pass before delivering.

---

## Quality Gate Reference

The UX Flow is evaluated as part of Design Review (pre-condition for Gate 3). The Tech Lead validates:
- All PRD features are covered
- At least 2 error paths per flow
- Decision points have both branches documented
- Traceability table is complete

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR004, DR005, DR015 (flow before wireframe; ambiguous AC escalation; API data verification)
- `Agente09_UxUiDesigner/knowledge/principles.md` — P4 (progressive disclosure in flows), P9 (feedback confirmation), P10 (error prevention)
- `Agente09_UxUiDesigner/context_view.md §3` — UX Flow conventions, annotation syntax
- `Agente09_UxUiDesigner/checklists/ux_flow_checklist.md`
- `Agente09_UxUiDesigner/templates/UX_Flow.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
