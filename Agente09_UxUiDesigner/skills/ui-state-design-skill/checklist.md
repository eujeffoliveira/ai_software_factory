# ui-state-design-skill Execution Checklist
## Agente09_UxUiDesigner

---

## Pre-Execution

- [ ] `Wireframes.md` is complete and component inventory is available
- [ ] `API_Contract.json` is available for TypeScript interface derivation
- [ ] `Architecture.md` Prisma schema is available for data model reference
- [ ] List of async components identified from wireframe component inventory

---

## Per Component — TypeScript Props Interface

- [ ] Interface is present as a TypeScript `interface` block (not prose description)
- [ ] Every field exists in `API_Contract.json` response schema or `Architecture.md` Prisma schema (DR015)
- [ ] Nullable fields typed as `string | null` (not just `string`)
- [ ] Dates typed as `string` in ISO 8601 format (not `Date` object — Server Components serialize dates as strings)
- [ ] Arrays typed as `Array<{...}>` with explicit item type
- [ ] Pagination props included if component is paginated (totalCount, currentPage, pageSize)
- [ ] Component type declared: Server Component or Client Component
- [ ] Client Component justification written if applicable

---

## Per Component — Loading State

- [ ] Skeleton layout described with specific dimensions (not "show spinner")
- [ ] Skeleton mirrors populated state layout — same number of content areas
- [ ] `animate-pulse` animation class specified
- [ ] `bg-muted` or appropriate token for skeleton block color (no hardcoded values)
- [ ] `role="status"` specified on loading container
- [ ] `aria-label="Loading [content type]..."` specified

---

## Per Component — Error State

- [ ] Icon specified — name from design system, size class, color token
- [ ] Heading is user-friendly — no HTTP codes, function names, or stack traces
- [ ] Body copy follows formula: "[What went wrong]. [What to do next]."
- [ ] Retry button specified — label, action (what it triggers), variant
- [ ] `role="alert"` specified on error container
- [ ] All copy text is exact final copy (no placeholder text)

---

## Per Component — Empty State

- [ ] Icon specified
- [ ] Heading text is specific and exact (not "[entity type] list is empty")
- [ ] Body copy text is exact and guides user to action
- [ ] CTA specified when user can populate the state — label, action/route, variant
- [ ] CTA omitted when user has read-only access (noted in spec)
- [ ] Multiple empty state variants documented if applicable (search/filter variants)

---

## Per Component — Populated State

- [ ] Layout described with reference to wireframe
- [ ] All interactive elements listed in Interactive Elements table
- [ ] Chart specification filled if applicable (DR012)

---

## Per Component — Interactive Elements Table

- [ ] Every interactive element has a row in the table
- [ ] Default state token specified (no hardcoded values)
- [ ] Hover state specified
- [ ] Active/pressed state specified
- [ ] Disabled state specified (if element can be disabled)
- [ ] Loading state specified (if element triggers async operation)
- [ ] ARIA label specified for every element

---

## Per Component — Responsive Behavior

- [ ] Table covers mobile (default) through lg: breakpoint minimum
- [ ] Mobile row is first (Tailwind mobile-first)
- [ ] Each row describes specific layout changes (not "becomes responsive")
- [ ] Navigation change at mobile breakpoint noted

---

## Per Component — Accessibility Section

- [ ] Focus order documented as numbered list
- [ ] Keyboard interactions documented (Enter, Esc, Arrow keys)
- [ ] Screen reader announcements documented (`aria-live` regions)
- [ ] ARIA roles documented (list, listitem, dialog, etc.)
- [ ] Color independence verified — no status communicated by color alone (DR006)
- [ ] Image alt text policy documented

---

## Global Checks

- [ ] Zero hardcoded hex values in entire UI_Spec.md
- [ ] Zero org-specific token names
- [ ] All copy text is final (no "[button label]" placeholders)
- [ ] All image dimensions specified for `next/image`
- [ ] `checklists/ui_spec_checklist.md` completed

---

## Runtime Knowledge Policy

This skill checklist accesses only local distilled knowledge at runtime:
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR001, DR002, DR006, DR007, DR008, DR009, DR012, DR015
- `Agente09_UxUiDesigner/knowledge/knowledge_cards.md` — Card 007, 008, 009
- `Agente09_UxUiDesigner/context_view.md §5, §6, §7, §8, §9`
- `Agente09_UxUiDesigner/checklists/ui_spec_checklist.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
