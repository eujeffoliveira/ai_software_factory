# Usability Review Checklist
## Agente09_UxUiDesigner
## Apply after design package is complete, before submission

---

## Purpose

This checklist supports `usability-review-skill`. It evaluates the complete design package (UX_Flow.md + Wireframes.md + UI_Spec.md) against established usability principles. It must be completed and signed off before the Handoff Package is submitted.

---

## Section 1: First Impression (H1 — 5-Second Rule)

For each screen, verify the following by reviewing its wireframe cold (without context):

- [ ] Page purpose is communicated by the title and primary content within 5 seconds
- [ ] Primary action is immediately identifiable — visually dominant over secondary actions
- [ ] Content hierarchy is clear — users can scan to find what they need without reading everything
- [ ] No screen presents the user with more than 3 competing primary actions simultaneously

---

## Section 2: Cognitive Load (P1, P3 — Hick's Law, Miller's Law)

- [ ] Navigation has ≤ 7 items (ideally 5) at each level
- [ ] Forms group related fields (≤ 6 per group) with logical section headings
- [ ] Complex workflows use progressive disclosure — not everything on one screen
- [ ] Tables limit visible columns to the 5–7 most important; others accessible via expansion
- [ ] No screen presents more than 3 actions of equal visual weight simultaneously

---

## Section 3: Familiarity and Conventions (P5 — Convention over Novelty, H2)

- [ ] Search is represented by a magnifying glass icon
- [ ] Navigation on mobile uses hamburger (☰) or bottom tab bar
- [ ] Destructive actions are visually distinct (use `destructive` token) and positioned away from safe actions
- [ ] Close/dismiss uses × icon
- [ ] Settings uses gear icon
- [ ] No non-standard icon meanings introduced without explicit justification
- [ ] No new navigation pattern introduced without explicit justification

---

## Section 4: Progressive Disclosure (P6, Card 005)

- [ ] Advanced options are hidden by default and revealed on explicit user request
- [ ] Bulk actions appear only after item selection (not always visible)
- [ ] Multi-step flows use wizard pattern with step indicator if > 3 steps
- [ ] Long content uses "Show more" / "Read more" rather than presenting everything upfront
- [ ] Contextual actions (edit, delete, etc.) are accessible but not cluttering the primary view

---

## Section 5: Feedback and Confirmation (P9 — Feedback Confirms Action)

- [ ] Every form submission shows loading state (button or page-level) while processing
- [ ] Every successful mutation shows a success indicator (toast, confirmation message, or redirect with visual confirmation)
- [ ] Every failed mutation shows an error message near the point of failure
- [ ] Current navigation item is visually marked as active
- [ ] All async operations > 2 seconds have an active loading indicator

---

## Section 6: Error Prevention (P10 — Error Prevention over Error Messages, H15)

- [ ] Destructive actions (delete, archive, deactivate) have confirmation dialogs
- [ ] Hard deletes (irreversible) explicitly state "This cannot be undone"
- [ ] Mass operations have confirmation with count: "Delete 3 items? This cannot be undone."
- [ ] Form validation fires on blur — users are informed of errors before submit
- [ ] Constrained inputs use dropdowns/selects/date pickers rather than free text
- [ ] Character limit counters visible for text fields with limits

---

## Section 7: Visual Proximity and Grouping (P4 — Gestalt Proximity)

- [ ] Form labels are immediately above their input (≤ 8px gap) — not separated
- [ ] Submit button is at the bottom of the form, adjacent to the last field
- [ ] Cancel and Save are in the same row/zone — not on opposite sides
- [ ] Action buttons are within or adjacent to the card/section they affect
- [ ] Error messages are directly below the field that caused them

---

## Section 8: Fit and Reachability (P2 — Fitts's Law, H10)

- [ ] All interactive elements have ≥ 44×44px touch target on mobile
- [ ] Primary CTA is at thumb-reachable position on mobile (bottom half of screen)
- [ ] Destructive actions are NOT adjacent to primary safe actions at same visual weight
- [ ] Icon-only buttons have tooltips on hover and `aria-label` for screen readers
- [ ] Navigation is reachable without excessive scrolling

---

## Section 9: Empty State Quality (H6, Card 009)

- [ ] Every list screen has an empty state designed (not just a blank page)
- [ ] Empty states have: icon + specific heading + explanatory body + CTA (when appropriate)
- [ ] Empty state headings are specific: "No tasks yet" not "No data found"
- [ ] Empty states for search/filter correctly suggest clearing the search/filter (not "create new item")
- [ ] Empty state CTAs are only present when the user can take action to fill the state

---

## Section 10: Error Message Quality (H9, Card 008)

- [ ] All error messages follow the formula: "[What went wrong in plain language]. [What to do next]."
- [ ] No error message exposes technical details (HTTP codes, stack traces, function names)
- [ ] Error messages are specific — not just "An error occurred"
- [ ] Error messages include a recovery action when one is available

---

## Section 11: Mobile Usability (P12, DR010)

- [ ] Mobile wireframes exist for all primary screens
- [ ] No horizontal scroll required for any primary action on mobile
- [ ] Bottom sheet used for modals on mobile (not centered overlay)
- [ ] Touch targets ≥ 44×44px confirmed on all interactive elements
- [ ] Primary actions reachable by thumb (bottom half of screen, full-width or bottom sticky)

---

## Usability Issues Log

_Record any issues found. Critical and high issues must be resolved before submission._

| ID | Issue Description | Screen | Principle Violated | Severity | Resolution |
|----|------------------|--------|--------------------|----------|------------|
| U-001 | [Issue] | [Screen] | [P1 / H2 / etc.] | critical/high/medium/low | [Fixed / Deferred / Escalated] |

---

## Overall Verdict

- [ ] **PASS** — All sections clear; no critical or high issues unresolved
- [ ] **PASS WITH NOTES** — Medium/low issues logged and deferred to backlog
- [ ] **FAIL** — One or more critical or high issues unresolved; cannot submit

---

## Runtime Knowledge Policy

This checklist accesses only local distilled knowledge at runtime:
- `Agente09_UxUiDesigner/knowledge/principles.md` — P1–P12
- `Agente09_UxUiDesigner/knowledge/heuristics.md` — H1–H15
- `Agente09_UxUiDesigner/knowledge/knowledge_cards.md` — Cards 001–012
- `Agente09_UxUiDesigner/context_view.md §7, §8` — screen states, WCAG

**Never reads at runtime**: `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
