# Skill: usability-review-skill
## Agente09_UxUiDesigner

---

## Purpose

Evaluates the complete design package (UX_Flow.md + Wireframes.md + UI_Spec.md) against established usability principles to identify friction points, cognitive overload, convention violations, and inconsistencies before handoff to Agente05_DevFrontend. Produces a signed-off `Usability_Checklist.md` and a list of findings with severity and resolution status.

---

## When to Use

- The full design package is complete (all three artifacts present)
- As the final review step before assembling the Handoff Package
- When a specific design decision has been questioned for usability impact
- When a returned design package needs re-review after corrections

**Do NOT trigger when:**
- Design artifacts are still incomplete — usability review requires the full package
- Only individual artifact reviews are needed (use artifact-specific checklists instead)

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `UX_Flow.md` | Yes | Complete user journey maps |
| `Wireframes.md` | Yes | Structural wireframes with mobile and desktop layouts |
| `UI_Spec.md` | Yes | Full component specification with all states |
| `Screen_States.md` | Yes | Detailed state specifications |

Schema: `input.schema.json`

---

## Outputs

| Output | Description |
|--------|-------------|
| `Usability_Checklist.md` (completed) | Self-review checklist with all sections signed off |
| Usability findings report | List of issues found, severity, action taken |
| Gate status | `READY_FOR_HANDOFF` or list of issues blocking handoff |

Schema: `output.schema.json`

---

## Procedure

1. **Review UX Flow for cognitive load issues.** Count primary navigation items, primary actions per screen, form fields per group. Apply Hick's Law: if more than 3 primary actions visible simultaneously, flag. **Primary action** = any CTA button, top-level navigation item, or affordance that initiates a state change (e.g., Submit, Delete, Create, Sign Out); secondary actions (inline help, tooltips, breadcrumbs) do not count. Apply Miller's Law: if more than 7 navigation items, flag.

2. **Review wireframes for hierarchy and familiarity.** Apply the 5-second rule (H1) to each wireframe: is the page purpose and primary action immediately apparent? Check navigation patterns against conventions (P5): is hamburger used on mobile? Are standard icon meanings preserved?

3. **Review wireframes for mobile usability.** Confirm all primary actions are reachable without horizontal scroll (DR010). Confirm touch targets appear adequate (P2). Confirm modals are shown as bottom sheets on mobile.

4. **Review UX Flow for complete error coverage.** Confirm minimum 2 distinct error paths per flow. An error path is distinct when it has a different trigger condition (e.g., "network unavailable" vs "validation failed" are two distinct paths; individual form field validation errors collectively count as one path — "form validation failed"). A flow where the only errors are form validation errors satisfies the minimum with 1 path; add a second path (e.g., server error, permission denied) if technically possible given the feature scope. Confirm both branches of every decision point are documented. Confirm empty state edge cases are present.

5. **Review UI_Spec for form quality.** Apply the form checklist (Card 011): visible labels, inline validation, specific error messages, character counters, required field markers, submit loading state.

6. **Review UI_Spec for error message quality.** Apply H9: every error message follows "[What went wrong]. [What to do next]." Check for technical error message exposure (HTTP codes, function names, stack traces).

7. **Review UI_Spec for feedback completeness.** Confirm every mutation has a success confirmation, every async operation has a loading state, every navigation has an active state.

8. **Review UI_Spec for progressive disclosure.** Confirm complex options are hidden until needed, bulk actions appear only after selection, wizard pattern for multi-step flows.

9. **Check for destructive action friction.** Verify that delete/archive actions have confirmation dialogs. Verify that irreversible actions state irreversibility. Verify that mass operations show count in confirmation.

10. **Classify all issues by severity.** Critical: blocks task completion. High: significant friction that will cause abandonment. Medium: notable but not blocking. Low: cosmetic.

11. **Determine resolution for each issue.** Fix: resolve before submission. Defer: add to backlog note. Escalate: requires Tech Lead involvement (scope or token issue).

12. **Update design artifacts** to fix critical and high issues before proceeding. This skill performs the modifications directly to `UI_Spec.md`, `Wireframes.md`, or `UX_Flow.md` as needed — it does not hand back a list for another agent to action. Medium and low issues are documented in the findings report with deferred status; the receiving agent (Agente05_DevFrontend) must acknowledge them in their implementation notes.

13. **Complete `checklists/usability_checklist.md`.** Sign off each section.

---

## Severity Definitions

| Severity | Definition | Resolution Policy |
|----------|-----------|-------------------|
| Critical | User cannot complete the primary task due to this issue | Must fix before submission |
| High | User will experience significant friction; abandonment likely | Must fix before submission |
| Medium | User notices the issue but can work around it | Should fix; deferral requires justification |
| Low | Cosmetic or minor — most users won't notice | Can defer to backlog |

---

## Common Issues to Watch For

- **Hick's Law violation**: Too many equally-weighted primary actions visible at once
- **No empty state** or generic "no data" empty state without guidance
- **Form validates on submit only** (not on blur)
- **Icon-only buttons** without labels (especially on desktop where space allows labels)
- **Destructive action without confirmation** dialog
- **Error message that exposes technical details** ("null is not an object")
- **Loading state is spinner without skeleton** (causes layout shift)
- **Mobile wireframe missing** for a primary screen

---

## Quality Gate Reference

`READY_FOR_FRONTEND` requires `Usability_Checklist.md` to be completed with `PASS` or `PASS_WITH_NOTES` verdict. `FAIL` verdict blocks submission.

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente09_UxUiDesigner/knowledge/principles.md` — P1–P12 (all principles applicable)
- `Agente09_UxUiDesigner/knowledge/heuristics.md` — H1–H15 (evaluation criteria)
- `Agente09_UxUiDesigner/knowledge/knowledge_cards.md` — Cards 001–012 (reference patterns)
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR001–DR015 (binding rules)
- `Agente09_UxUiDesigner/checklists/usability_checklist.md`
- `Agente09_UxUiDesigner/templates/Usability_Checklist.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
