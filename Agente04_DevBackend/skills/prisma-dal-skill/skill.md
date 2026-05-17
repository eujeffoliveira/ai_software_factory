# prisma-dal-skill

## Purpose

Implements the Data Access Layer (DAL) for a Prisma model. All database operations for a given entity are centralized in `lib/db/[model].dal.ts` and exported as a named const object. This abstraction makes the codebase testable (mock the DAL, not Prisma) and refactorable (Prisma configuration changes in one place).

## When to Use

- Any task that creates or modifies CRUD operations for a Prisma model
- When a new entity is added to the schema
- When a new query type is needed (e.g., `findByExternalId`, `findWithFilter`)
- Before implementing a Server Action or service that needs DB access

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `model_name` | `prisma/schema.prisma` — model identifier (PascalCase) | Yes |
| `operations` | Task spec — which CRUD operations are needed | Yes |
| `file_path` | Task spec — `lib/db/[model].dal.ts` | Yes |
| `prisma_schema` | `prisma/schema.prisma` — field definitions and types | Yes |

## Outputs

- TypeScript file at `lib/db/[model].dal.ts`
- Named const export: `export const [model]Dal = { ... }`
- Typed methods using `Prisma.[Model]CreateInput`, `Prisma.[Model]UpdateInput`
- `upsert` method for cron job idempotency

## Procedure

1. **Import** `prisma` from `@/lib/db/prisma` and types from `@prisma/client`
2. **Define the named const object**: `export const [model]Dal = {`
3. **Implement each required operation** using Prisma parameterized API
4. **Type all parameters** using Prisma generated types (never `any`)
5. **Include `upsert`** for any model that may be needed by cron jobs
6. **Close the object** — no raw SQL anywhere

## Quality Gate

Gate 4 checks:
- `sql_safety_checklist.md` — no raw SQL, parameterized only
- `backend_quality_checklist.md` — DAL used for all DB access

## Failure Modes

| Mode | Symptom | Fix |
|------|---------|-----|
| FM-05 | Raw SQL concatenation | Replace with Prisma parameterized API |
| FM-12 | Missing upsert for cron jobs | Add `upsert` method with stable unique key |

## RAG Collections Permitted

- `backend_engineering`
- `data_intensive_applications`

## Architecture Compliance

- File MUST be in `lib/db/[model].dal.ts`
- MUST use `prisma` from `@/lib/db/prisma` only
- MUST NOT use raw SQL string concatenation
- MUST export as named const object

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:
- its local files (`skill.md`, schemas, checklist, examples)
- `Agente04_DevBackend/knowledge/`
- `Agente04_DevBackend/context_view.md`
- project artifacts provided as input
