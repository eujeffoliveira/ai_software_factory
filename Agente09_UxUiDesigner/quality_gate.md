# Agente09_UxUiDesigner — Design Review (Quality Gate)

## Gate Overview

| Field | Value |
|-------|-------|
| Gate name | Design Review |
| Gate type | Pre-condition (not a numbered pipeline gate) |
| UX/UI Designer role | **Submitter** |
| Evaluator | Agente00_TechLead |
| Prerequisite | Gate 1 approved (PRD.md) + Gate 2 approved (Architecture.md) |
| Unlocks | Gate 3 — Agente03_SoftwareEngineer can create frontend atomic tasks |

---

## Context

The Design Review is not Gate 3 itself — it is a **pre-condition for Gate 3** (Execution Plan). Agente03_SoftwareEngineer cannot create frontend task specifications without an approved Design Package. The Tech Lead validates the Design Package before routing it to Agente05_DevFrontend.

When the Design Review passes, the status `READY_FOR_FRONTEND` is set and the Design Package is forwarded.

---

## Entry Criteria (Before Submitting)

All of the following must be true before submitting the Design Package for review:

1. `PRD.md` available and Gate 1 approved
2. `Architecture.md` available and Gate 2 approved
3. `UX_Flow.md` produced — all features from PRD mapped, including error paths and edge cases
4. `Wireframes.md` produced — mobile AND desktop layouts for all primary screens
5. `UI_Spec.md` produced — all 4 states for every async component
6. `checklists/ux_flow_checklist.md` — completed and all items confirmed
7. `checklists/wireframe_quality_checklist.md` — completed and all items confirmed
8. `checklists/ui_spec_checklist.md` — completed and all items confirmed
9. `checklists/accessibility_basics_checklist.md` — completed and all items confirmed
10. `checklists/design_system_application_checklist.md` — completed and all items confirmed
11. `checklists/usability_checklist.md` — completed and all items confirmed
12. No blocking open questions in the Handoff Package
13. Handoff Package produced with `gate_ready: true`

---

## What the Tech Lead Evaluates

### Completeness
- [ ] All features in PRD.md are covered by the UX Flow
- [ ] All screens identified in the UX Flow have wireframes
- [ ] All async components in Wireframes.md have all 4 states in UI_Spec.md
- [ ] No screen exists in Wireframes.md without a corresponding UI_Spec.md section

### Implementability
- [ ] Every UI_Spec component has a TypeScript props interface
- [ ] Every component state has exact copy text (no placeholder text like "[message here]")
- [ ] All images specify dimensions and alt text for `next/image`
- [ ] All form fields specify label, placeholder, validation rule, and error message
- [ ] All interactive elements specify default, hover, active, and disabled states
- [ ] All charts specify Recharts type, data shape, axis labels, and empty state

### Design System Compliance
- [ ] Zero hardcoded hex values in any artifact
- [ ] All visual properties mapped to generic design tokens
- [ ] No org-specific token names used
- [ ] No new UI components proposed without documented justification

### Accessibility
- [ ] All interactive elements have ARIA labels specified
- [ ] Focus order specified for every screen
- [ ] Color not used as the sole status indicator for any state
- [ ] All form inputs have associated visible labels

### PRD Traceability
- [ ] Every design element traces to a PRD acceptance criterion
- [ ] No design adds features not in the PRD
- [ ] No PRD requirement is missing from the design

---

## Status Codes

| Code | Meaning | UX/UI Designer Action |
|------|---------|----------------------|
| `READY_FOR_FRONTEND` | Design Package approved — all criteria met | Handoff to Agente05_DevFrontend proceeds |
| `RETURNED_FOR_REVISION` | Design issues found — specific items cited | Fix the cited issues; re-run self-review checklists; resubmit |
| `BLOCKED_MISSING_STATES` | One or more async components are missing a loading, error, or empty state | Add the missing states for all identified components; resubmit |
| `BLOCKED_ACCESSIBILITY_VIOLATION` | WCAG AA violation found in the spec (hardcoded failing contrast, missing ARIA, color-only status) | Resolve the accessibility issue; if design token values are at fault, escalate to Tech Lead |
| `BLOCKED_PRD_MISMATCH` | Design adds scope not in PRD, removes PRD scope, or misinterprets requirements | Align design to PRD; if scope question must be resolved, escalate to Agente01 via Tech Lead |

---

## Blocking Conditions

The following conditions automatically block `READY_FOR_FRONTEND`:

1. **Missing screen state** — any async component without all 4 states
2. **Mobile wireframe missing** — any primary screen without a mobile layout
3. **Hardcoded color value** — any hex code or org-specific token in any artifact
4. **WCAG AA color contrast violation** — any specified combination that fails the 4.5:1 or 3:1 ratio
5. **Design not traceable to PRD** — any screen or component with no corresponding PRD requirement
6. **Vague specification** — any component state with placeholder copy ("message here"), generic spinner ("show spinner"), or unspecified dimensions
7. **ARIA missing from interactive elements** — any button, link, or custom control without an ARIA label spec

---

## When to Escalate BEFORE Submitting

Do not submit if any of the following are unresolved:

| Situation | Action |
|-----------|--------|
| PRD requirement is ambiguous — designing it requires making a product decision | Escalate to Agente00_TechLead |
| Architecture constraint prevents fulfilling a design requirement | Escalate to Agente00_TechLead |
| New design token needed (not in generic token set) | Escalate to Agente00_TechLead |
| Design token value fails WCAG AA contrast with current defaults | Escalate to Agente00_TechLead |
| Feature scope in PRD is unclear or contradictory | Escalate to Agente00_TechLead |
| Required UI component not available in design system | Escalate to Agente00_TechLead |

Submitting with unresolved blockers results in `RETURNED_FOR_REVISION` and wastes the review cycle.
