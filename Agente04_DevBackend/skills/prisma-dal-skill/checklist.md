# prisma-dal-skill — Execution Checklist

---

## Implementation Checks

- [ ] File is at `lib/db/[model].dal.ts`
- [ ] `import { prisma } from "@/lib/db/prisma"` — only prisma source
- [ ] `import type { [Model], Prisma } from "@prisma/client"` — Prisma generated types
- [ ] Exported as named const: `export const [model]Dal = { ... }`
- [ ] NOT default export, NOT individual function exports

## Operations

- [ ] Each required operation implemented
- [ ] All parameters typed with Prisma types (never `any`)
- [ ] Return types declared (e.g., `Promise<Task | null>`)
- [ ] `upsert` method present (for idempotency when needed)
- [ ] `findMany` includes `orderBy` with sensible default
- [ ] `findMany` accepts optional `skip`/`take` for pagination

## SQL Safety

- [ ] No `prisma.$queryRaw` with string concatenation
- [ ] No `prisma.$queryRawUnsafe` at all
- [ ] No template literal SQL interpolation
- [ ] All queries use Prisma `where`, `data`, `orderBy` objects

## Runtime Knowledge Policy

Use only local artifacts: this checklist, `context_view.md §6`, `examples/good_prisma_dal.ts`, `knowledge/decision_rules.md` (DR013).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
