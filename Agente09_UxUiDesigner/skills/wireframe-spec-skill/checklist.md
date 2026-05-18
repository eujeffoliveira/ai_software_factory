# wireframe-spec-skill Execution Checklist
## Agente09_UxUiDesigner

---

## Pre-Execution

- [ ] `UX_Flow.md` is complete (`ready_for_wireframing: true` confirmed)
- [ ] Screen list from ux-flow-design-skill output is available (`screens_identified`)
- [ ] `Architecture.md` is available for component name reference
- [ ] Wireframe ASCII syntax reviewed: `context_view.md §4`

---

## During Execution (per screen)

- [ ] Mobile layout (< sm:) produced first — mobile-first approach
- [ ] Desktop layout (lg: and above) produced second — shows enhancements over mobile
- [ ] All ASCII boxes are syntactically closed (`┌─┐` / `└─┘`)
- [ ] All components are named in brackets: `[ComponentName]` — no unnamed boxes
- [ ] Repeated elements use `(repeat × N)` annotation
- [ ] SCREEN-NNN ID assigned to each screen

---

## Layout Correctness

- [ ] Page URL shown at top of each screen section
- [ ] Layout type declared (full-page / modal / bottom-sheet / drawer)
- [ ] Layout zones labeled in ALL CAPS: HEADER, MAIN CONTENT, SIDEBAR, FOOTER
- [ ] Navigation placement correct: top on desktop, hamburger/bottom-bar on mobile
- [ ] Primary action position correct: top-right on desktop, below title or sticky-bottom on mobile
- [ ] Modal shown as centered overlay on desktop, bottom sheet on mobile

---

## State Annotations

- [ ] States section present below each wireframe
- [ ] Loading state: skeleton description (not "spinner" — skeleton matching content layout)
- [ ] Error state: referenced to Screen_States.md or brief description
- [ ] Empty state: referenced to Screen_States.md or brief description
- [ ] Populated state: the wireframe shows this state (noted explicitly)

---

## Component Inventory

- [ ] Component inventory list present below each wireframe
- [ ] All component names match Architecture.md or are new proposals with justification
- [ ] No anonymous components ("some button here", "list component")

---

## Mobile-Specific Behavior Notes

- [ ] Hamburger or bottom tab bar behavior noted
- [ ] Bottom sheet pattern for modals documented
- [ ] Touch-specific behaviors noted (swipe to dismiss, drag handle)
- [ ] Load More vs Pagination difference noted

---

## Wireframe Index

- [ ] Index table at bottom of Wireframes.md: SCREEN-NNN, name, route, mobile, desktop, UX flow steps
- [ ] All wireframed screens are listed in the index

---

## Final Checks

- [ ] No colors specified in any wireframe
- [ ] No font specifications in any wireframe
- [ ] All primary screens have both mobile and desktop layouts
- [ ] `checklists/wireframe_quality_checklist.md` completed — all items confirmed

---

## Runtime Knowledge Policy

This skill checklist accesses only local distilled knowledge at runtime:
- `Agente09_UxUiDesigner/knowledge/principles.md` — P12 (mobile-first), P4 (proximity)
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR004, DR010
- `Agente09_UxUiDesigner/context_view.md §4` — wireframe ASCII conventions
- `Agente09_UxUiDesigner/checklists/wireframe_quality_checklist.md`
- `Agente09_UxUiDesigner/templates/Wireframes.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
