# Skill: swr-polling-skill

## Purpose

Implements a real-time polling Client Component using `useSWR`. Handles loading, error, and stale states. Configures the polling interval and revalidation strategy correctly.

## When to Use

- When `frontend-state-management-skill` returns `strategy: "swr_polling"`
- Status indicators that update without user interaction
- Metrics dashboards with auto-refresh
- Progress indicators for background jobs

## Inputs

| Field | Required | Description |
|-------|----------|-------------|
| `endpoint` | Yes | Must exist in `API_Contract.json` |
| `response_type` | Yes | TypeScript type from contract |
| `polling_interval_ms` | Yes | Must be ≥ 5000ms |
| `component_name` | Yes | PascalCase component name |
| `file_path` | Yes | Target path |

## Outputs

- Client Component TSX with `useSWR` implementation
- Proper loading state (skeleton or pulse indicator)
- Proper error state (inline, non-blocking)
- `refreshInterval` explicitly configured

## Constraints

- **`refreshInterval` is MANDATORY** — SWR without polling is FM-09
- **Endpoint MUST exist in API_Contract.json** — no invented routes (FM-07)
- **`revalidateOnFocus: false`** is recommended to avoid excessive revalidation
- **Loading and error states are MANDATORY** in SWR components (FM-02, FM-03)
- Polling interval < 5000ms requires explicit documented justification

## Knowledge Access Policy

This skill reads ONLY from:
- `Agente05_DevFrontend/context_view.md` — § 8 SWR Pattern
- `Agente05_DevFrontend/knowledge/principles.md` — P7
- `Agente05_DevFrontend/knowledge/decision_rules.md` — DR014, DR015
- `Agente05_DevFrontend/knowledge/knowledge_cards.md` — Card 007

**BLOCKED at runtime:** `context/`, `lib/`, any external source.
