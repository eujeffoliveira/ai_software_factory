# Skill: nextjs-react-component-skill

## Purpose

Implements a complete, production-quality React component (Server or Client) from a component spec. Applies loading/error/empty states, accessibility attributes, TypeScript typing from the API contract, and Tailwind styling. This is the primary implementation skill.

## When to Use

- Any task requiring a new React component (page, layout, card, form, interactive widget)
- Modifying an existing component to add new behavior
- Converting a Client Component to a Server Component (or vice versa, with justification)

## Inputs

| Field | Required | Description |
|-------|----------|-------------|
| Component spec | Yes | From `schemas/component_spec.schema.json` |
| Selection decision | Yes | Output of `server-component-selection-skill` |
| API Contract reference | Conditional | Required for components that fetch or display data |
| Existing codebase files | Conditional | Required when modifying |

## Outputs

- TypeScript/TSX source file at the specified path
- Companion `loading.tsx` if async route (or Suspense wrapper)
- Companion `error.tsx` if page route
- Empty state branch if component renders a list/table

## Constraints

- Server Components: no `"use client"`, no hooks, no event handlers
- Client Components: `"use client"` first line, justification comment required
- All images: `<Image>` from `next/image` — no `<img>`
- All styling: Tailwind only — no inline styles
- All data: from API contract — no invented fields
- Business logic: in `features/[domain]/` — not in the component

## Execution Steps

1. Confirm selection decision from `server-component-selection-skill`
2. Read the relevant API contract section (verify endpoint and response shape)
3. Derive TypeScript interfaces from the contract (DR018)
4. Copy the appropriate template (`Server_Component_Template.tsx` or `Client_Component_Template.tsx`)
5. Implement the component following the template structure
6. Add empty state check for list/table components (DR009)
7. Create `loading.tsx` companion if async page route (DR007)
8. Create `error.tsx` companion if page route (DR008)
9. Apply Tailwind classes with design tokens (run `tailwind-v4-design-system-skill`)
10. Add accessibility attributes (run `accessibility-check-skill`)

## Knowledge Access Policy

This skill reads ONLY from:
- `Agente05_DevFrontend/context_view.md` — all 14 sections
- `Agente05_DevFrontend/knowledge/decision_rules.md` — DR006–DR020
- `Agente05_DevFrontend/knowledge/principles.md` — all principles
- `Agente05_DevFrontend/templates/` — all TSX templates
- `Agente05_DevFrontend/examples/` — good/bad component examples

**BLOCKED at runtime:** `context/`, `lib/`, any external source.
