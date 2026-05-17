# Skill: responsive-layout-skill

## Purpose

Implements responsive layouts using Tailwind CSS v4 breakpoints. Ensures mobile-first design, correct grid/flex usage, and consistent spacing at all screen sizes.

## When to Use

- Any page layout or section component that must adapt across viewports
- Dashboard grids with stat cards and chart panels
- Sidebar + main content layouts
- Navigation components

## Inputs

| Field | Required | Description |
|-------|----------|-------------|
| `layout_spec` | Yes | From `schemas/responsive_layout.schema.json` |
| `component_list` | Yes | Components that will live inside the layout |

## Outputs

- TSX layout component with mobile-first Tailwind classes
- Grid or flex container with responsive breakpoints
- Container with max-width and padding

## Constraints

- **Default (no prefix) classes define mobile layout** — always (DR020, P11)
- **`sm:`, `md:`, `lg:` add enhancements** — not the baseline
- **No fixed pixel widths** without responsive override
- **No `lg:grid-cols-3` without `grid-cols-1` default**
- **Tables on mobile** must have `overflow-x-auto` wrapper

## Common Patterns

| Pattern | Tailwind Classes |
|---------|-----------------|
| Stats grid | `grid grid-cols-2 lg:grid-cols-4 gap-4` |
| Card grid | `grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4` |
| Sidebar | `flex flex-col lg:flex-row gap-6` |
| Container | `container mx-auto px-4 sm:px-6 lg:px-8` |
| Hide mobile | `hidden sm:block` |

## Knowledge Access Policy

This skill reads ONLY from:
- `Agente05_DevFrontend/context_view.md` — § 14 Responsive Layout Patterns
- `Agente05_DevFrontend/knowledge/heuristics.md` — H7, H11
- `Agente05_DevFrontend/knowledge/principles.md` — P11
- `Agente05_DevFrontend/knowledge/decision_rules.md` — DR020
- `Agente05_DevFrontend/knowledge/knowledge_cards.md` — Card 012

**BLOCKED at runtime:** `context/`, `lib/`, any external source.
