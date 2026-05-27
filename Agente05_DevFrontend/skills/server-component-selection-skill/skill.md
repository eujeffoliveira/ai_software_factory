# Skill: server-component-selection-skill

## Purpose

Determines whether a component should be implemented as a **Server Component** or **Client Component** before any code is written. Produces a typed decision with justification and template selection. This skill is the foundation for all component implementation — it must run before `nextjs-react-component-skill`.

## When to Use

- Before implementing ANY new React component
- When reviewing an existing component that may be unnecessarily marked `"use client"`
- When the component type is unclear from the task spec
- When refactoring a Client Component to check if it can be converted to a Server Component

## Inputs

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `component_name` | string | Yes | PascalCase component name |
| `component_requirements` | string[] | Yes | List of what the component needs to do |
| `uses_state` | boolean | No | Does it need useState or useReducer? |
| `uses_effects` | boolean | No | Does it need useEffect, useRef, etc.? |
| `uses_event_handlers` | boolean | No | Does it attach onClick, onChange, etc.? |
| `uses_browser_apis` | boolean | No | Does it access window, document, localStorage? |
| `uses_recharts` | boolean | No | Does it import from recharts? |
| `file_path` | string | Yes | Target file path |

Schema: `input.schema.json`

## Outputs

| Field | Type | Description |
|-------|------|-------------|
| `component_type` | "ServerComponent" \| "ClientComponent" | The decision |
| `justification` | string | 1–3 sentence explanation |
| `client_trigger` | DR001\|DR002\|DR003\|DR004\|DR005\|null | Which rule triggered CC decision |
| `recommended_template` | string | Template file to use |
| `companion_files_needed` | object | loading.tsx, error.tsx, empty state needed? |

Schema: `output.schema.json`

## Constraints

- **Server Component** is the default. The absence of client triggers means Server Component.
- **Client Component requires a documented trigger** — one of DR001–DR005. No other justifications.
- **"Might need interactivity later"** is NOT a valid justification.
- **"It's simpler as a Client Component"** is NOT a valid justification.
- The skill evaluates the COMPONENT, not the page. A page with one Client Component button still has most of its tree as Server Components.

## Execution Steps

1. Review the component requirements against the five trigger checks (DR001–DR005)
2. If ANY trigger is YES → Client Component decision with trigger documented
3. If ALL triggers are NO → Server Component decision
4. For Client Components: evaluate whether the boundary can be pushed deeper (smaller client subtree)
5. Select the appropriate template
6. Document companion file requirements (loading.tsx, error.tsx, empty state)
7. Return the decision record

## Decision Logic

```
IF uses_state OR uses_effects → CLIENT_COMPONENT (DR001 or DR002)
ELSE IF uses_event_handlers → CLIENT_COMPONENT (DR003)
ELSE IF uses_browser_apis → CLIENT_COMPONENT (DR004)
ELSE IF uses_recharts → CLIENT_COMPONENT (DR005)
ELSE → SERVER_COMPONENT (DR006 — read-only data, no triggers)
```

`client_trigger` is `null` for any Server Component decision (DR006 is a confirmation rule, not a trigger, and never appears in `client_trigger`).

## Knowledge Access Policy

This skill reads ONLY from:
- `Agente05_DevFrontend/knowledge/decision_rules.md` — DR001–DR006 (component type rules)
- `Agente05_DevFrontend/knowledge/heuristics.md` — H1 (four-question test)
- `Agente05_DevFrontend/knowledge/principles.md` — P1, P2 (Server/Client Component principles)
- `Agente05_DevFrontend/context_view.md` — §1 Server Component Pattern, §2 Client Component Pattern

**BLOCKED at runtime:** `context/`, `lib/`, any external source.
