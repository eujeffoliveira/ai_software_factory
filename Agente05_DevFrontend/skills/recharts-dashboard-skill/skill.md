# Skill: recharts-dashboard-skill

## Purpose

Implements Recharts chart components. Ensures `ResponsiveContainer` wraps every chart, proper TypeScript interfaces for chart data derived from the API contract, empty state handling, accessible wrappers, and design token colors.

## When to Use

- Any task requiring a chart or data visualization component
- Line charts, bar charts, area charts, pie charts, composed charts
- Dashboard metrics sections with visual data

## Inputs

| Field | Required | Description |
|-------|----------|-------------|
| `chart_type` | Yes | LineChart, BarChart, AreaChart, PieChart, ComposedChart |
| `data_type_definition` | Yes | From API_Contract.json |
| `title` | Yes | Accessible chart title |
| `height_px` | No | Chart height in pixels (default: 300) |
| `file_path` | Yes | Target path |

## Outputs

- Client Component TSX with Recharts implementation
- `ResponsiveContainer` wrapper (mandatory)
- Empty state for the no-data case
- Accessible `role="img"` + `aria-label` wrapper
- TypeScript interface for chart data derived from contract
- Screen-reader accessible `<table class="sr-only">` alternative

## Constraints

- **`ResponsiveContainer` is MANDATORY** — charts without it render at 0×0 (DR013)
- **Parent container must have explicit height** — use `h-[Npx]` Tailwind class
- **Empty data MUST render EmptyState** — not a blank chart (DR009)
- **Colors MUST use CSS variables** — `stroke="var(--primary-color)"` (DR012)
- **Chart MUST be Client Component** — Recharts requires browser APIs (DR005)
- **Accessible data table** in `sr-only` for complex charts (H15)

## Knowledge Access Policy

This skill reads ONLY from:
- `Agente05_DevFrontend/context_view.md` — § 7 Recharts Pattern
- `Agente05_DevFrontend/knowledge/heuristics.md` — H5, H15
- `Agente05_DevFrontend/knowledge/principles.md` — P6
- `Agente05_DevFrontend/knowledge/decision_rules.md` — DR005, DR009, DR013
- `Agente05_DevFrontend/knowledge/knowledge_cards.md` — Card 006
- `Agente05_DevFrontend/templates/Recharts_Component_Template.tsx`

**BLOCKED at runtime:** `context/`, `lib/`, any external source.
