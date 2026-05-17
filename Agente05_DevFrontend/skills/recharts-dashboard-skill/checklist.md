# Recharts Dashboard — Checklist

## Pre-Execution
- [ ] Data type definition from API_Contract.json obtained
- [ ] Chart type selected from the approved list

## Implementation
- [ ] `"use client"` with DR005 justification comment
- [ ] TypeScript interface derived from contract (no invented fields)
- [ ] Empty data check BEFORE rendering chart (returns EmptyState)

## Chart Architecture
- [ ] `ResponsiveContainer width="100%" height="100%"` wraps the chart
- [ ] Parent container has explicit height (h-[Npx] Tailwind class)
- [ ] Chart wrapper has `role="img"` and `aria-label`

## Colors and Styling
- [ ] `stroke="var(--primary-color)"` or `fill="var(--primary-color)"` for data series
- [ ] `stroke="var(--border)"` for CartesianGrid
- [ ] `fill="var(--muted-foreground)"` for axis ticks
- [ ] No hardcoded hex colors

## Accessibility
- [ ] `<table class="sr-only">` data alternative included
- [ ] Tooltip is visual-only enhancement (not sole data access method)

## Runtime Knowledge Policy
- [ ] Recharts pattern from `context_view.md` § 7 used
- [ ] Card 006 from `knowledge/knowledge_cards.md` referenced for chart type selection
