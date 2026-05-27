# Skill: frontend-error-state-skill

## Purpose

Implements `error.tsx` files for page routes and error boundary components for nested components. Ensures user-friendly messages (never `error.message`), a `reset()` button, and accessible markup.

## When to Use

- For every page route in the task scope (every `page.tsx` needs a companion `error.tsx`)
- For async components that wrap a data-dependent subtree
- When a form or mutation can produce an error state

## Inputs

| Field | Required | Description |
|-------|----------|-------------|
| `route_path` | Yes | The route folder path (e.g., `app/entities/`) |
| `error_message` | No | Optional custom user-facing message (generic default if not provided) |
| `recovery_strategy` | No | `reset` (try again) / `navigate_back` / `contact_support` |

## Outputs

- `error.tsx` file at the route folder
- Client Component (Next.js requirement)
- Generic user-friendly message (never `error.message`)
- `reset()` recovery button
- Internal logging (digest only, not message)
- Accessible `role="alert"` wrapper

## Constraints

- **`"use client"` is REQUIRED** — Next.js requires `error.tsx` to be Client Component (DR003)
- **`error.message` MUST NOT be shown to users** — information disclosure (FM-03)
- **`reset()` MUST be provided** as a recovery mechanism
- **`role="alert"` MUST be on the container** for screen readers

## Recovery Strategy Implementations

| Strategy | Implementation |
|----------|---------------|
| `reset` | Render a button with `onClick={reset}` — calls Next.js `reset()` prop to retry the failed render |
| `navigate_back` | Render a button using `useRouter().back()` — takes user to previous page; add `"use client"` import for `useRouter` |
| `contact_support` | Render a link to a support URL (sourced from env or task spec); do NOT hard-code the email address in JSX |

If `recovery_strategy` is not provided, default to `reset`.

## Execution Steps

1. Determine `recovery_strategy` (default: `reset` if not provided)
2. Copy `Error_State_Template.tsx` to `{route_path}/error.tsx`
3. Confirm `"use client"` is the first line
4. Set `role="alert"` on the root container
5. Use `error_message` if provided; otherwise use the generic default: `"Something went wrong. Please try again."`
6. Log `error.digest` (not `error.message`) internally with `console.error` for debugging
7. Implement the recovery button/link per the Recovery Strategy Implementations table above

## Knowledge Access Policy

This skill reads ONLY from:
- `Agente05_DevFrontend/context_view.md` — § 5 Error State Pattern
- `Agente05_DevFrontend/knowledge/decision_rules.md` — DR008
- `Agente05_DevFrontend/knowledge/principles.md` — P5
- `Agente05_DevFrontend/templates/Error_State_Template.tsx`

**BLOCKED at runtime:** `context/`, `lib/`, any external source.
