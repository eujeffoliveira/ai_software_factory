# Skill: accessibility-check-skill

## Purpose

Audits React components for WCAG 2.1 Level AA compliance. Reviews ARIA attributes, keyboard navigation, focus management, color contrast, semantic HTML, and screen reader announcements. Produces an accessibility review report and corrected code snippets.

## When to Use

- Before every Gate 4 submission (mandatory for all interactive components)
- When implementing forms, modals, buttons, or any interactive UI element
- When implementing data tables, lists, or chart components
- When an existing component is flagged for accessibility in QA review

## Inputs

| Field | Required | Description |
|-------|----------|-------------|
| `files` | Yes | Array of component file paths to audit |
| `interaction_scenarios` | No | Optional list of interaction flows to verify |

## Outputs

Output conforms to `schemas/accessibility_review.schema.json`:
- List of issues by severity: CRITICAL, HIGH, MEDIUM, LOW
- Corrected code snippets for each issue
- `wcag_aa_compliant` boolean
- `gate_4_status` field

## Blocking Threshold

- No CRITICAL or HIGH issues → `gate_4_status: "PASS"`
- One or more CRITICAL or HIGH issues open → `gate_4_status: "BLOCKED_ACCESSIBILITY_FAILURE"`

## Common Issues Checked

| Category | Check |
|----------|-------|
| Text alternatives | `alt` on images, `aria-label` on icon buttons |
| Keyboard | Tab order, Enter/Space activation, focus trap in modals |
| Focus visibility | Visible `:focus` ring on all focusable elements |
| Color contrast | 4.5:1 normal text, 3:1 large text/UI |
| Semantic HTML | Landmark roles, heading hierarchy, list elements |
| Forms | `<label>` for inputs, `aria-describedby` for errors |
| ARIA | `aria-expanded`, `aria-selected`, `aria-live`, `role` |
| Dynamic content | `aria-live="polite"` for status, `role="alert"` for errors |

## Knowledge Access Policy

This skill reads ONLY from:
- `Agente05_DevFrontend/knowledge/heuristics.md` — H6, H14, H15
- `Agente05_DevFrontend/knowledge/knowledge_cards.md` — Card 009
- `Agente05_DevFrontend/context_view.md` — § 13 Accessibility Patterns
- `Agente05_DevFrontend/checklists/accessibility_checklist.md`
- `Agente05_DevFrontend/knowledge/principles.md` — P4

**BLOCKED at runtime:** `context/`, `lib/`, WCAG documentation, any external source.
