# Skill: tailwind-v4-design-system-skill

## Purpose

Applies design tokens and Tailwind CSS v4 classes to components. Removes hardcoded colors, inline styles, and non-token Tailwind colors, replacing them with the correct token-based equivalents. Also the first step of `design-token-compliance-skill`.

## When to Use

- After implementing any component (as a final styling pass)
- When reviewing a component for design system compliance
- When migrating existing inline styles to Tailwind

## Inputs

| Field | Required | Description |
|-------|----------|-------------|
| `component_files` | Yes | Array of TSX file paths to review/update |
| `design_token_map` | Yes | From `context_view.md` § 12 |

## Outputs

- Updated TSX file(s) with token-based Tailwind classes
- List of changes made (what replaced, why)
- Compliance status per file

## Constraints

- **Blocked patterns:** `style={{}}`, `#hex`, `rgb()`, Tailwind palette colors (`bg-blue-500`)
- **Required patterns:** `bg-[var(--primary-color)]`, `text-[var(--text-foreground)]`, `border-[var(--border)]`
- **Exception:** `h-[Npx]` for Recharts wrapper height (ResponsiveContainer requires explicit parent height — document the exception)

## Execution Steps

1. Scan all files for inline `style={{}}` props → replace with Tailwind equivalent
2. Scan for hardcoded hex/rgb colors → replace with design token equivalent
3. Scan for Tailwind palette colors → replace with token equivalent
4. Scan for CSS modules / styled-components imports → flag for removal
5. Verify all chart colors use CSS variables (`stroke="var(--primary-color)"`)
6. Apply responsive classes if missing (P11)
7. Confirm dark mode compatibility (tokens handle it automatically)

## Knowledge Access Policy

This skill reads ONLY from:
- `Agente05_DevFrontend/context_view.md` — § 3 Tailwind v4 Patterns, § 12 Design Token Reference
- `Agente05_DevFrontend/knowledge/principles.md` — P3, P11
- `Agente05_DevFrontend/knowledge/decision_rules.md` — DR011, DR012
- `Agente05_DevFrontend/knowledge/knowledge_cards.md` — Card 003

**BLOCKED at runtime:** `context/`, `lib/`, any external source.
