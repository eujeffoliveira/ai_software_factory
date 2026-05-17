# Zod Validation Checklist

**When to run:** For every input boundary in the implementation (Server Actions, Route Handlers, env vars, external API responses).  
**Purpose:** Prevent FM-02 (missing validation) and ensure trust boundary enforcement.

---

## Schema Definition

- [ ] Schema is defined at MODULE LEVEL — not inside the function body
  - Correct: `const InputSchema = z.object({ ... })` at the top of the file
  - Wrong: `const schema = z.object({ ... })` inside the function
- [ ] Schema variable name follows convention: `[Context][Entity]Schema` (e.g., `CreateTaskSchema`, `TaskQuerySchema`)
- [ ] TypeScript type inferred with `z.infer`: `type Input = z.infer<typeof InputSchema>`
- [ ] Types are NOT written manually (no `interface Input { ... }` alongside a Zod schema for the same shape)

## Field Constraints

- [ ] String fields have `.min()` and `.max()` where applicable
- [ ] Required string fields have `.min(1)` (prevents empty string)
- [ ] Number fields have appropriate `.min()` and `.max()` bounds
- [ ] Integer fields have `.int()` where applicable
- [ ] Enum fields use `z.enum([...])` with all valid values listed
- [ ] UUID fields use `z.string().uuid()`
- [ ] Date fields use `z.string().datetime()` or `z.coerce.date()`
- [ ] Optional fields use `.optional()` — not `z.union([z.string(), z.undefined()])`
- [ ] Constraints match `API_Contract.json` specifications exactly

## Usage in Server Actions

- [ ] `.parse()` called on raw input before use: `const input = InputSchema.parse(rawInput)`
- [ ] The raw parameter is typed as `unknown`: `rawInput: unknown`
- [ ] `.parse()` is NOT inside a separate try/catch (let the outer catch handle ZodError)

## Usage in Route Handlers

- [ ] `.safeParse()` called on query params or body: `const result = Schema.safeParse(data)`
- [ ] Result checked before use: `if (!result.success) { return 400 response }`
- [ ] 400 response returns `{ error: "Invalid parameters" }` — not `result.error.format()` (do not expose internal field names in production)
- [ ] Query params parsed with `Object.fromEntries(searchParams)` before `.safeParse()`
- [ ] Body parsed with `await req.json()` before `.safeParse()`

## Environment Variables

- [ ] `lib/env.ts` exists with a Zod schema for all env vars
- [ ] `z.object({...}).parse(process.env)` used in `lib/env.ts`
- [ ] No `process.env.VAR_NAME` anywhere except `lib/env.ts`
- [ ] Env vars with sensitive defaults use `.min()` constraints (e.g., secrets must be ≥ 32 chars)

## External API Responses

- [ ] Response schema defined for every external API endpoint
- [ ] `Schema.parse(await response.json())` called after `response.json()`
- [ ] Schema is strict enough to catch unexpected shape changes from the external API

---

## Common Mistakes

| Mistake | Correct Pattern |
|---------|----------------|
| `const data = await req.json() as InputType` | `const parsed = InputSchema.safeParse(await req.json())` |
| `z.object({ name: z.string() })` with no constraints | `z.string().min(1).max(255)` |
| Schema defined inside function | Schema at module level |
| `interface Input` written manually alongside Zod schema | `type Input = z.infer<typeof InputSchema>` |
| `process.env.API_KEY` in integration client | `import { env } from "@/lib/env"; env.API_KEY` |

---

## Runtime Knowledge Policy

This checklist is part of the agent's local runtime knowledge.  
Do NOT consult `context/`, `lib/`, or global architecture documents.  
All required patterns are in `context_view.md §7`, `templates/Zod_Schema_Template.ts`, and `knowledge/decision_rules.md` (DR001).
