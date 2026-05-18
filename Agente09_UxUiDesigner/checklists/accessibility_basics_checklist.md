# Accessibility Basics Checklist
## Agente09_UxUiDesigner
## WCAG 2.1 AA — Apply to every UI_Spec.md before submission

---

## Purpose

This checklist verifies that the design specification meets WCAG 2.1 Level AA requirements. Accessibility is designed in from the beginning — this checklist is not a retrofit audit. Items marked FAIL block `READY_FOR_FRONTEND`.

---

## Section 1: Color and Contrast (WCAG 1.4.3, 1.4.11)

- [ ] **Normal text contrast ≥ 4.5:1** — all text using `text-foreground` on `bg-background` meets this ratio (verify at instantiation when token values are set)
- [ ] **Large text contrast ≥ 3:1** — text ≥ 18pt or ≥ 14pt bold; headings typically meet this threshold
- [ ] **Interactive element contrast ≥ 3:1** — buttons, links, and form controls against adjacent colors
- [ ] **Design note in spec**: "Token contrast ratios must be verified at instantiation. If `text-foreground` on `bg-background` fails 4.5:1, escalate to Tech Lead for token value update (DR013)."

---

## Section 2: Use of Color (WCAG 1.4.1)

- [ ] **Every status indicator uses color + secondary indicator** — green dot + "Active" label, not just green dot
- [ ] **Every error state uses icon + text** — not just red border
- [ ] **Every warning state uses icon + text** — not just amber background
- [ ] **Required field markers use text ("Required") or `*` + tooltip** — not just a different color

---

## Section 3: Images and Icons (WCAG 1.1.1)

- [ ] **All informative images have `alt` text** — describes what the image communicates
- [ ] **All decorative images have `alt=""`** (empty string — not omitted; not `alt="decorative"`)
- [ ] **Functional icons (buttons with icon only) have `aria-label`** on the button element
- [ ] **Icon-only buttons with text labels have `aria-hidden="true"` on the icon** to prevent screen reader repetition
- [ ] **All `next/image` instances have explicit `width` and `height`** specified in the design (DR009)

---

## Section 4: Form Accessibility (WCAG 1.3.1, 3.3.1, 3.3.2)

- [ ] **Every input has a visible label** — not just placeholder text
- [ ] **Label is programmatically associated** — `htmlFor`/`id` pair or `aria-labelledby`
- [ ] **Placeholder is supplementary only** — not the primary label
- [ ] **Required fields marked `aria-required="true"`** AND visually (asterisk with visible legend or "Required" text)
- [ ] **Error messages are specific and actionable** — "Enter a valid email address (e.g., name@example.com)" not just "Invalid"
- [ ] **Error messages linked via `aria-describedby`** — the error text element is linked to the input that caused it
- [ ] **Form groups have `fieldset` and `legend`** for grouped radio/checkbox inputs

---

## Section 5: Keyboard Navigation (WCAG 2.1.1, 2.4.3, 2.4.7)

- [ ] **All interactive elements reachable by Tab key** — no mouse-only interactions
- [ ] **Tab order follows visual reading order** (left-to-right, top-to-bottom) — no unexpected focus jumps
- [ ] **No keyboard traps** — except modal dialogs which intentionally trap focus (and release on Esc)
- [ ] **Focus indicator is visible** — do not specify `outline: none` without providing a better focus ring
- [ ] **Modal dialogs specify focus management** — focus moves to dialog on open; returns to trigger on close
- [ ] **Dropdown menus specify keyboard behavior** — Arrow keys navigate, Enter selects, Esc closes
- [ ] **Focus order documented in Accessibility section** of each UI_Spec component

---

## Section 6: Screen Reader Support (WCAG 4.1.2, 1.3.1)

- [ ] **ARIA roles used for custom components** — `role="list"` on lists, `role="listitem"` on items, `role="dialog"` on modals
- [ ] **`aria-expanded` used for expandable elements** — accordions, dropdowns, navigation
- [ ] **`aria-selected` or `aria-checked` used for selectable elements** — tabs, checkboxes, radio buttons
- [ ] **`aria-live="polite"` used for dynamic content updates** — search result count changes, async notifications
- [ ] **`aria-live="assertive"` used for critical alerts only** — errors, session expiry warnings
- [ ] **`role="alert"` on error messages** — ensures screen readers announce errors immediately
- [ ] **`role="status"` on loading states** — non-interruptive announcement that loading is in progress
- [ ] **Heading hierarchy is logical** — h1 (page title) → h2 (sections) → h3 (subsections); no skipped levels

---

## Section 7: Focus Management in Dynamic Interactions

- [ ] **Modal opens → focus moves to modal** — first focusable element or modal heading
- [ ] **Modal closes → focus returns to the trigger element** that opened the modal
- [ ] **Inline validation → focus stays on the field** — do not move focus to the error message
- [ ] **Toast notifications → do not steal focus** — use `aria-live="polite"` region
- [ ] **After delete → focus moves to next item** or list container (not lost entirely)
- [ ] **After navigation → focus moves to main content** or page heading (skip-to-main link for keyboard users)

---

## Section 8: Responsive Accessibility

- [ ] **Touch targets ≥ 44×44px on mobile** — `min-h-[44px]` on all interactive elements
- [ ] **Text readable at 200% zoom** without horizontal scroll (content reflows)
- [ ] **Pinch-to-zoom not disabled** — `user-scalable=no` must not be in the design spec

---

## Accessibility Issues Log

_Record any accessibility issues found and their resolution:_

| ID | SC | Issue | Component | Severity | Resolution |
|----|-----|-------|-----------|----------|------------|
| A-001 | 1.4.1 | [Issue] | [Component] | critical/high | [Fixed / Escalated] |

---

## Verdict

- [ ] **PASS** — All WCAG AA criteria addressed in the spec; no blocking issues
- [ ] **FAIL** — One or more WCAG AA violations found; blocks `READY_FOR_FRONTEND`

_For contrast failures: do not hardcode a custom color — escalate to Tech Lead for design token update (DR013)._

---

## Runtime Knowledge Policy

This checklist accesses only local distilled knowledge at runtime:
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR006, DR013
- `Agente09_UxUiDesigner/knowledge/principles.md` — P8 (Accessibility is not an add-on)
- `Agente09_UxUiDesigner/knowledge/knowledge_cards.md` — Card 006 (WCAG AA Quick Reference)
- `Agente09_UxUiDesigner/context_view.md §8` — WCAG 2.1 AA requirements

**Never reads at runtime**: `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
