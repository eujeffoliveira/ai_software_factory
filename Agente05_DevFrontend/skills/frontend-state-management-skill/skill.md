# Skill: frontend-state-management-skill

## Purpose

Decides the correct state management strategy for a component or feature. Determines whether to use: Server Component (no state), local UI state (`useState`), Server Action for mutations, or SWR for polling. Prevents inappropriate state patterns.

## When to Use

- Whenever a component specification mentions "state", "real-time", or "live data"
- When deciding between SWR and a Server Component
- When a form or interaction needs to trigger a data change
- When state requirements are ambiguous

## Inputs

| Field | Required | Description |
|-------|----------|-------------|
| `state_requirement` | Yes | What data, how often it changes, what triggers changes |
| `component_context` | Yes | Where in the tree, what it renders |
| `polling_interval_ms` | No | If polling is specified, the required interval |

## Outputs

- State strategy: `none` / `local_ui_state` / `server_action` / `swr_polling`
- Rationale for the choice
- Implementation guidance (which template/hook/pattern)
- Warning if Server Component should be used instead of Client/SWR

## Decision Matrix

| Data changes when? | User does something? | Use |
|-------------------|---------------------|-----|
| Never (page load only) | No | Server Component |
| Only user actions (save, delete) | Yes | Server Action |
| Time-based polling (every N sec) | No | SWR with `refreshInterval` |
| Transient UI (modal open, tab) | Yes | `useState` in Client Component |

## Execution Steps

1. Parse `state_requirement` and `component_context`
2. Apply the Decision Matrix: find the row that matches when data changes and whether the user triggers it
3. If multiple rows match (e.g., data changes both on user action and on a timer), choose the higher-priority strategy: SWR polling > Server Action > local UI state
4. Confirm the choice doesn't conflict with the component being a Server Component — if it does, escalate to `server-component-selection-skill`
5. Return: `strategy`, `rationale` (1–2 sentences referencing the matched matrix row), `implementation_guidance` (template or hook name to use)

## Knowledge Access Policy

This skill reads ONLY from:
- `Agente05_DevFrontend/knowledge/heuristics.md` — H2, H12
- `Agente05_DevFrontend/knowledge/decision_rules.md` — DR001–DR006, DR014, DR017
- `Agente05_DevFrontend/context_view.md` — § 2 Client Component Pattern, § 8 SWR Pattern, § 9 Server Action Integration
- `Agente05_DevFrontend/knowledge/knowledge_cards.md` — Card 007, Card 010, Card 011

**BLOCKED at runtime:** `context/`, `lib/`, any external source.
