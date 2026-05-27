# Skill: ui-state-design-skill
## Agente09_UxUiDesigner

---

## Purpose

Explicitly designs all four states (loading, error, empty, populated) for every component or page that fetches asynchronous data. Produces the detailed component sections of `UI_Spec.md` and `Screen_States.md`. This skill is the primary mechanism for ensuring no screen state is left to developer interpretation.

---

## When to Use

- A wireframe has been produced for a component that fetches async data
- A page has a list, table, chart, data card, or any data-driven view
- Any component has a `Server Action`, `fetch()`, or `SWR` data dependency

**Do NOT trigger for:**
- Purely static components with no async data dependency (navigation menus, footers, static content pages)
- Modal or dialog components that receive all their data as props from parent (no independent data fetch)

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `Wireframes.md` | Yes | Structural layout to derive skeleton shape and component list from |
| `Architecture.md` | Yes | Prisma schema and data model for TypeScript interface derivation |
| `API_Contract.json` | Yes | API endpoint response schemas for TypeScript interface derivation |
| Component list from wireframes | Yes | Named components from wireframe component inventory |

Schema: `input.schema.json`

---

## Outputs

| Output | Description |
|--------|-------------|
| `UI_Spec.md` (component sections) | Full specification per component: TypeScript props interface, all 4 states, interactive elements, responsive behavior, accessibility |
| `Screen_States.md` | Dedicated state specification document with exact skeleton layouts, error copy, empty state variants |

Schema: `output.schema.json`

---

## Procedure

1. **Enumerate async components.** From Wireframes.md component inventory, identify every component that fetches data (Server Component with fetch, Client Component with SWR, any component receiving props from an API). Mark these — they all need all 4 states.

2. **Derive TypeScript props interface.** For each component, open `API_Contract.json` and find the corresponding endpoint response schema. Map every field to a TypeScript type. Use `string | null` for nullable fields. Verify every field exists in the contract (DR015). If a contract field has an unsupported type (e.g., a generic `object` with no schema, a raw binary blob, or a union type with no described variants): document the field as `unknown` in the interface and add a note in `implementation_notes` flagging it for the Dev agent to clarify before implementation; do NOT invent a type.

3. **Design the loading state.** The loading skeleton must mirror the populated state layout. Count the content items (cards, rows, widgets) and create skeleton blocks of matching dimensions. Specify `animate-pulse`, `bg-muted`, `role="status"`, `aria-label="Loading [content type]..."`. Do not use a generic spinner.

4. **Design the error state.** Follow the error state formula: (1) icon, (2) user-friendly heading, (3) body copy with what to do, (4) retry button, (5) `role="alert"`. Never expose technical error details. Use exact copy text.

5. **Design the empty state(s).** Determine if there are multiple empty state variants (new user / search empty / filter empty). For each variant: icon, heading, body copy, optional CTA. Follow the empty state copy formula. Specify exact copy text.

6. **Design the populated state.** Document the full layout by referencing the wireframe. Describe all interactive elements: buttons, dropdowns, checkboxes, action menus. Specify exact label text, ARIA labels, and design tokens.

7. **Build the Interactive Elements table.** For every interactive element: component type, all states (default, hover, active, disabled, loading if applicable), design token per state, ARIA label.

8. **Build the Responsive Behavior table.** Starting from mobile (default), describe what changes at `sm:`, `md:`, `lg:`, `xl:`. Be specific: "single column → two columns", "hamburger → inline nav", "load-more → numbered pagination".

9. **Write the Accessibility section.** Specify: numbered focus order, keyboard interactions (Enter, Esc, Arrow keys), screen reader announcements (`aria-live` regions, count updates), ARIA roles, image alt text policy.

10. **Document charts if applicable.** For any chart component, fill the full Recharts specification from `context_view.md §9`: component type, data interface, axis configuration, tooltip content, legend, color tokens, empty state. Chart specifications go in a dedicated `## Chart: [ComponentName]` subsection inside `UI_Spec.md` (not in a separate file) — one subsection per chart, directly following the component's Interactive Elements table.

11. **Run `checklists/ui_spec_checklist.md`.** Confirm all items pass before delivering.

---

## The 4 States — What Makes Each Complete

| State | Mandatory Elements |
|-------|-------------------|
| Loading | Skeleton matching populated layout, `animate-pulse`, `bg-muted`, `role="status"`, `aria-label` |
| Error | Icon, user-friendly heading, body copy with action, retry button, `role="alert"`, exact copy text |
| Empty | Icon, specific heading, body copy, optional CTA (only if user can take action), exact copy text |
| Populated | Full layout per wireframe, all interactive elements specified, design tokens, ARIA labels |

---

## Quality Gate Reference

Missing any state from any async component triggers `BLOCKED_MISSING_STATES`. Vague states (spinner, "error message", "empty") trigger `RETURNED_FOR_REVISION`.

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR001, DR002, DR006, DR007, DR008, DR009, DR012, DR015
- `Agente09_UxUiDesigner/knowledge/knowledge_cards.md` — Card 007 (Loading State Pattern), Card 008 (Error State Pattern), Card 009 (Empty State Pattern)
- `Agente09_UxUiDesigner/knowledge/principles.md` — P8 (accessibility in), P11 (design is specification)
- `Agente09_UxUiDesigner/context_view.md §5, §6, §7, §8, §9`
- `Agente09_UxUiDesigner/checklists/ui_spec_checklist.md`
- `Agente09_UxUiDesigner/templates/UI_Spec.md`, `templates/Screen_States.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
