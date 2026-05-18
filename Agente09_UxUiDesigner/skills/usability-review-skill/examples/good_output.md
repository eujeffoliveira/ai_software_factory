# Good Output — usability-review-skill

## Example: Task Management Design Review

**Feature**: Task Management
**Verdict**: PASS WITH NOTES

---

## Issues Found

| ID | Description | Screen | Principle | Severity | Action |
|----|-------------|--------|-----------|----------|--------|
| U-001 | Create Task modal had 5 primary buttons visible (Create, Cancel, Save Draft, Preview, Reset). Exceeds 3 primary actions per screen. | SCREEN-002 | P1 (Hick's Law) | high | fixed: removed "Preview" and "Reset" — not in PRD scope; "Save Draft" moved to "Advanced options ▼" |
| U-002 | Task card action menu (···) used icon only with no visible label on desktop where space was available for at least a hover tooltip. | SCREEN-001 | H13 (icon labels on first use) | medium | fixed: added tooltip "Task actions" on hover; kept icon-only since (···) is near-universal convention |
| U-003 | "Load More" button on mobile did not show count — "Load More" with no context. | SCREEN-001 (mobile) | P9 (feedback confirms action) | medium | fixed: changed to "Load More Tasks (27 remaining)" to communicate what happens |
| U-004 | Character counter on Description field showed "0/500" but only appeared after the user started typing, not on initial focus. | SCREEN-002 | H4 (design from error state first) | low | deferred: low impact — show counter on focus (not only on input); added to backlog |

## Sections Review

| Section | Status |
|---------|--------|
| 1: Cognitive Load | PASS (after U-001 fix) |
| 2: Navigation Clarity | PASS |
| 3: Form Usability | PASS (after U-003 fix) |
| 4: Error Prevention | PASS |
| 5: Visual Hierarchy | PASS |
| 6: Mobile Usability | PASS |
| 7: Feedback and Status | PASS (after U-002 fix) |
| 8: Component Reuse | PASS |

## Overall Verdict: PASS WITH NOTES

Critical issues: 0
High issues: 0 (1 found, 1 fixed)
Medium issues: 1 deferred (U-004 — low impact, backlog)
Low issues: 1 deferred

**ready_for_handoff: true** — design package cleared for Handoff Package assembly.

---

## Why This is a Good Example:
# 1. Specific issues found — not just "looks good"
# 2. Each issue references the principle violated
# 3. Fixed issues show exactly what changed
# 4. Deferred issues are medium/low only — none are critical or high
# 5. Verdict correctly reflects issue resolution
# 6. ready_for_handoff is only true after critical/high are resolved
