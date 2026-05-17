# Skill: design-token-compliance-skill

## Purpose

Reviews one or more components for design token compliance. Finds hardcoded hex values, non-token Tailwind colors, inline styles, and CSS modules. Produces a compliance report with violations and corrections. This skill is the mandatory pre-submission review for all components.

## When to Use

- Before every Gate 4 submission (mandatory — run on all files in the PR)
- When reviewing a component during implementation (catch violations early)
- When onboarding a new design token into the system

## Inputs

| Field | Required | Description |
|-------|----------|-------------|
| `component_files` | Yes | Array of file paths to review |
| `token_map` | No | Optional override of default token map |

## Outputs

- Compliance report per file
- List of violations: file, line, type, severity
- Corrected code snippets
- `design_token_compliant` boolean
- Gate 4 status

## Violation Severity

| Type | Severity | Gate Impact |
|------|----------|------------|
| Inline `style={{}}` | CRITICAL | Blocks Gate 4 |
| Hardcoded hex color | CRITICAL | Blocks Gate 4 |
| Tailwind palette color | HIGH | Blocks Gate 4 |
| Missing responsive class | MEDIUM | RETURNED_FOR_REVISION |

## Knowledge Access Policy

This skill reads ONLY from:
- `Agente05_DevFrontend/context_view.md` — § 12 Design Token Reference
- `Agente05_DevFrontend/knowledge/principles.md` — P3
- `Agente05_DevFrontend/knowledge/decision_rules.md` — DR011, DR012
- `Agente05_DevFrontend/knowledge/knowledge_cards.md` — Card 003
- `Agente05_DevFrontend/checklists/design_system_checklist.md`

**BLOCKED at runtime:** `context/`, `lib/`, any external source.
