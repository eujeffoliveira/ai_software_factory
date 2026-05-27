# Skill: wireframe-spec-skill
## Agente09_UxUiDesigner

---

## Purpose

Produces structural ASCII wireframes for every primary screen identified in a UX Flow. Each wireframe shows layout hierarchy, component placement, and content structure for both desktop (lg: and above) and mobile (< sm:) breakpoints. Wireframes are structural only — no colors, fonts, or visual styling.

---

## When to Use

- `UX_Flow.md` is complete and identifies which screens need to be wireframed
- A new screen is being added to an existing feature
- A screen redesign requires the layout to be re-specified

**Do NOT trigger when:**
- `UX_Flow.md` is not yet complete — wireframes must follow the flow, not precede it (DR004)
- The screen is a pure redirect, confirmation email, or background process with no layout
- A wireframe for this screen already exists and has been approved without changes

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `UX_Flow.md` | Yes | Identifies which screens to wireframe and their step context |
| `Architecture.md` | Yes | Route structure, component names, data shape |
| Screen list from UX Flow output | Yes | `screens_identified` array from ux-flow-design-skill output |
| `context_view.md §4` | Auto | Wireframe syntax and ASCII conventions (local knowledge) |

Schema: `input.schema.json`

---

## Outputs

| Output | Description |
|--------|-------------|
| `Wireframes.md` | ASCII structural wireframes for all in-scope screens, both desktop and mobile layouts |
| Component inventory | Named components per screen (for cross-reference with UI_Spec.md) |

Schema: `output.schema.json`

---

## Procedure

1. **Enumerate screens from UX_Flow.md.** Extract every screen URL referenced in happy path, error paths, and edge cases. Group by route (the same route may appear in multiple flow steps).

2. **Classify each screen by layout type.** Full page, modal, bottom sheet, or inline component. This determines the wireframe structure.

3. **Start with mobile layout (mobile-first).** For each screen, sketch the mobile layout first. Mobile constraints: single column, stacked elements, thumb-reachable CTAs, hamburger navigation. This is the default — desktop enhancements come after.

4. **Then produce desktop layout.** Show what additional elements appear at `lg:` breakpoint: sidebar, multi-column grid, expanded navigation, inline actions instead of overflow menus.

5. **Use ASCII box drawing syntax.** Follow `context_view.md §4` exactly. Use `┌─┐ / └─┘ / ├─┤ / │` for containers, `[Component Name]` for named elements, `(repeat × N)` for repeated items.

6. **Name every component.** Component names in the wireframe must match Architecture.md component names or be new component proposals with explicit justification. Sufficient justification examples: "novel UX pattern not covered by any existing component" (e.g., a multi-step wizard for an onboarding flow), "must encapsulate feature-specific state not appropriate in a shared component". Insufficient: "more convenient", "similar but slightly different" — in those cases reuse the existing component with variant props instead.

7. **Write the component inventory.** Below each wireframe, list every named component. This becomes the input for `ui-state-design-skill`.

8. **Annotate states.** Below each wireframe, add a States section with four rows: Loading (skeleton description), Error, Empty, Populated. The populated state is what the wireframe shows. Full state specs go in Screen_States.md via `ui-state-design-skill`. Skeleton description format: prose text describing which content areas are replaced by skeleton blocks, using the pattern `"[area name]: [number] skeleton blocks of [approximate size]"` (e.g., `"stats row: 4 skeleton blocks of card size"`, `"table body: 5 skeleton rows"`). ASCII art is optional but prose description is mandatory.

9. **Add mobile-specific behavior notes.** Document anything that differs on mobile: hamburger behavior, bottom sheet modal, swipe gestures, load-more vs pagination.

10. **Build the Wireframe Index.** At the bottom of Wireframes.md, add a summary table: SCREEN-NNN ID, name, route, mobile present (Y/N), desktop present (Y/N), UX flow steps.

11. **Run `checklists/wireframe_quality_checklist.md`.** Confirm all items pass before delivering.

---

## Wireframe Content Rules

**Always include:**
- Page URL at the top of each screen section
- Layout type (full-page / modal / drawer / inline)
- Desktop layout (lg: and above)
- Mobile layout (< sm:)
- Named components in brackets: `[ComponentName]`
- Repeated elements with `(repeat × N)` annotation
- State annotations table below each wireframe

**Never include:**
- Colors or color names in the wireframe
- Font specifications
- CSS class names (those go in UI_Spec.md)
- Specific pixel dimensions unless critical for structural understanding
- Decorative elements (shadows, gradients, borders for aesthetics)

---

## Quality Gate Reference

Wireframes are evaluated at Design Review. Blocking conditions:
- Missing mobile layout for any primary screen (`RETURNED_FOR_REVISION`)
- Components not named (`RETURNED_FOR_REVISION`)
- States not annotated for any screen (`BLOCKED_MISSING_STATES`)

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente09_UxUiDesigner/knowledge/principles.md` — P12 (mobile-first), P4 (proximity), P5 (convention)
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR004 (flow before wireframe), DR010 (mobile CTAs)
- `Agente09_UxUiDesigner/knowledge/heuristics.md` — H1 (5-second rule for hierarchy), H2 (familiar patterns)
- `Agente09_UxUiDesigner/context_view.md §4` — wireframe ASCII conventions
- `Agente09_UxUiDesigner/checklists/wireframe_quality_checklist.md`
- `Agente09_UxUiDesigner/templates/Wireframes.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
