// TEMPLATE: Replace all [PLACEHOLDER] values with your implementation.
// File location: features/[domain]/schemas/[entity].schema.ts
//
// RULES for Zod schema files:
// 1. All schemas defined at MODULE LEVEL — never inline inside functions
// 2. TypeScript types always inferred with z.infer — never written manually
// 3. Constraints match API_Contract.json specifications exactly
// 4. Error messages are user-friendly where relevant
// 5. Env vars go in lib/env.ts — not here

import { z } from "zod"

// ── Create Schema ──────────────────────────────────────────────────────────────
// Validates input for creating a new [Entity].
export const Create[Entity]Schema = z.object({
  name: z.string().min(1, "Name is required").max(255, "Name is too long"),
  description: z.string().max(2000).optional(),
  // status: z.enum(["draft", "active", "archived"]).default("draft"),
  // priority: z.number().int().min(1).max(5).optional(),
  // dueDate: z.string().datetime().optional(),    // ISO 8601
  // tags: z.array(z.string().min(1)).max(10).optional(),
})

// ── Update Schema ──────────────────────────────────────────────────────────────
// All fields optional — caller provides only the fields to change.
// .partial() makes every field of Create[Entity]Schema optional.
export const Update[Entity]Schema = Create[Entity]Schema.partial()

// ── ID Schema ──────────────────────────────────────────────────────────────────
// Used for operations that only require an entity ID (delete, get by ID).
export const [Entity]IdSchema = z.object({
  id: z.string().uuid("[Entity] ID must be a valid UUID"),
})

// ── List/Query Schema ──────────────────────────────────────────────────────────
// Validates query parameters for list endpoints.
// z.coerce.number() converts string query params to numbers.
export const List[Entity]QuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  pageSize: z.coerce.number().int().min(1).max(100).default(20),
  // search: z.string().max(100).optional(),
  // status: z.enum(["draft", "active", "archived"]).optional(),
  // orderBy: z.enum(["createdAt", "updatedAt", "name"]).default("createdAt"),
  // order: z.enum(["asc", "desc"]).default("desc"),
})

// ── Type Inference ─────────────────────────────────────────────────────────────
// Always infer TypeScript types from Zod schemas — never write them manually.
// This ensures the types and schemas are always in sync.
export type Create[Entity]Input = z.infer<typeof Create[Entity]Schema>
export type Update[Entity]Input = z.infer<typeof Update[Entity]Schema>
export type [Entity]IdInput = z.infer<typeof [Entity]IdSchema>
export type List[Entity]Query = z.infer<typeof List[Entity]QuerySchema>
