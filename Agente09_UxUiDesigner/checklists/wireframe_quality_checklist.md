# Wireframe Quality Checklist
## Agente09_UxUiDesigner
## Apply before finalizing Wireframes.md

---

## Pre-Execution Checks

- [ ] `UX_Flow.md` is complete — wireframes cannot precede the UX flow (DR004)
- [ ] All screens identified in the UX flow are listed for wireframing
- [ ] Wireframe syntax reference reviewed: `context_view.md §4`

---

## Coverage Checks

- [ ] **Every screen in the UX flow has a wireframe** — no screen from `UX_Flow.md` is missing
- [ ] **Every wireframe is listed in the Wireframe Index** at the bottom of `Wireframes.md`
- [ ] **Every screen has a SCREEN-NNN ID** matching the handoff schema format

---

## Layout Completeness

- [ ] **Desktop layout (lg: and above) present for every primary screen**
- [ ] **Mobile layout (< sm:) present for every primary screen** — never desktop-only
- [ ] **Tablet layout noted** where it meaningfully differs from both mobile and desktop
- [ ] **All layout zones labeled** — HEADER, SIDEBAR, MAIN CONTENT, FOOTER as applicable
- [ ] **ASCII box drawing is syntactically correct** — all boxes are closed (┌─┐ / └─┘ / ├─┤)

---

## Content Hierarchy

- [ ] **Page title is the most visually prominent element** in the wireframe
- [ ] **Primary action button is positioned correctly** — top-right on desktop, below title or sticky-bottom on mobile
- [ ] **Navigation is in expected position** — top of page on desktop, hamburger or bottom bar on mobile
- [ ] **Content hierarchy is clear** — heading > subheading > body > meta order is reflected in layout
- [ ] **Related elements are grouped** — form labels adjacent to inputs; action buttons adjacent to content they act on

---

## State Annotations

- [ ] **Loading state annotated** — skeleton description matches the populated layout structure
- [ ] **Error state annotated** — reference to full spec in `UI_Spec.md` or `Screen_States.md`
- [ ] **Empty state annotated** — reference to full spec in `UI_Spec.md` or `Screen_States.md`
- [ ] **Populated state** — the main wireframe represents this state explicitly

---

## Component Inventory

- [ ] **All components in the wireframe are named** — no unnamed boxes or "some component here"
- [ ] **Component names match Architecture.md** or are new components with documented justification
- [ ] **Component inventory section is present** below each wireframe
- [ ] **Repeating elements use `(repeat × N)` annotation** — not drawn individually

---

## Mobile-Specific Checks

- [ ] **Hamburger (☰) or bottom tab bar present** in mobile header
- [ ] **All primary actions reachable without horizontal scroll** — no overflow to the right
- [ ] **Modals are shown as bottom sheets on mobile** — not as centered overlays
- [ ] **Stacked layout used for form fields** — no two-column forms on mobile
- [ ] **Card tap areas are full-width** — not just the card title text

---

## Structural Integrity (Not Visual Design)

- [ ] **No colors specified** — wireframes use structural labels only, no color tokens
- [ ] **No fonts specified** — font hierarchy implied through [HEADING] / [Label] / [body text] labels, not font names
- [ ] **No decorative elements** — no borders just for aesthetics, no shadow specifications
- [ ] **No specific pixel dimensions** unless critically necessary for structural clarity

---

## Runtime Knowledge Policy

This checklist accesses only local distilled knowledge at runtime:
- `Agente09_UxUiDesigner/knowledge/principles.md` — P12 (mobile-first), P4 (proximity), P5 (conventions)
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR004 (flow before wireframe), DR010 (mobile primary actions)
- `Agente09_UxUiDesigner/context_view.md §4` — wireframe ASCII conventions and state annotations
- `Agente09_UxUiDesigner/templates/Wireframes.md` — template reference

**Never reads at runtime**: `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
