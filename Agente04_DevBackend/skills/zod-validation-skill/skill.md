# zod-validation-skill

## Purpose

Creates Zod validation schemas for a feature's input boundaries. Every entry point into the system is a trust boundary — this skill places the adapter (Zod schema) at each port to validate incoming data before it's used.

## When to Use

- Before implementing any Server Action that receives user input
- Before implementing any Route Handler that parses query params or request body
- When adding a new entity to the system
- When the API contract defines new request schemas

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `entity_name` | Task spec / API contract | Yes |
| `fields` | API contract — request schema properties | Yes |
| `file_path` | Task spec | Yes |

## Outputs

- TypeScript file at `features/[domain]/schemas/[entity].schema.ts`
- `Create[Entity]Schema`, `Update[Entity]Schema`, `[Entity]IdSchema`, `List[Entity]QuerySchema`
- Inferred TypeScript types for all schemas

## Procedure

1. Define `Create[Entity]Schema` with all required and optional fields
2. Define `Update[Entity]Schema = Create[Entity]Schema.partial()`
3. Define `[Entity]IdSchema` for ID-only operations
4. Define `List[Entity]QuerySchema` with pagination and filter support
5. Export inferred types with `z.infer<typeof Schema>`

## Quality Gate

Gate 4 checks: `checklists/zod_validation_checklist.md`

## Failure Modes

- FM-02: Schema inline in function body — not module level
- No type inference — types written manually (diverge from schema)
- Constraints too loose — missing min/max allows invalid data

## RAG Collections Permitted

- `backend_engineering`
- `nodejs_patterns`

## Architecture Compliance

- Schema files at `features/[domain]/schemas/[entity].schema.ts`
- All schemas at module level
- Types inferred with `z.infer<typeof Schema>`
- Env vars validated in `lib/env.ts`

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only its local files, `Agente04_DevBackend/knowledge/`, `Agente04_DevBackend/context_view.md`, and project input artifacts.
