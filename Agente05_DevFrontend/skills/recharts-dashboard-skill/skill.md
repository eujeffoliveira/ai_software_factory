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

## Execution Steps

1. Confirm `chart_type` is one of the five supported types; if not, return an error — do not guess
2. Derive TypeScript interface for chart data from `data_type_definition` in `API_Contract.json`
3. Copy `Recharts_Component_Template.tsx`; add `"use client"` directive (DR005 — Recharts requires browser APIs)
4. Set parent container height: `h-[{height_px}px]` (default `h-[300px]`); note this exception is exempt from design-token-compliance checks
5. Wrap chart in `<ResponsiveContainer width="100%" height="100%">`
6. Map data series to chart components; use `stroke="var(--primary-color)"` (or other token CSS variables) for all colors — no hardcoded hex
7. Add empty state branch: if `data.length === 0`, render `<EmptyState>` instead of the chart
8. Add accessible wrapper: `role="img"` + `aria-label` with the `title` value
9. Add `<table className="sr-only">` with the same data as the chart for screen readers

## Knowledge Access Policy

This skill reads ONLY from:
- `Agente05_DevFrontend/context_view.md` — § 7 Recharts Pattern
- `Agente05_DevFrontend/knowledge/heuristics.md` — H5, H15
- `Agente05_DevFrontend/knowledge/principles.md` — P6
- `Agente05_DevFrontend/knowledge/decision_rules.md` — DR005, DR009, DR013
- `Agente05_DevFrontend/knowledge/knowledge_cards.md` — Card 006
- `Agente05_DevFrontend/templates/Recharts_Component_Template.tsx`

**BLOCKED at runtime:** `context/`, `lib/`, any external source.
