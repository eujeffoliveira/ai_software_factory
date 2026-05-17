# zod-validation-skill — Execution Checklist

---

## Schema Definition

- [ ] Schemas at MODULE LEVEL — not inside function bodies
- [ ] Variable names follow `[Context][Entity]Schema` convention
- [ ] Types inferred: `type Input = z.infer<typeof InputSchema>` — not manually written

## Field Constraints

- [ ] String fields have `.min(1)` for required, `.max(N)` for length limits
- [ ] Number fields have `.int()` where applicable and `.min()`, `.max()` bounds
- [ ] Enum fields use `z.enum([...])` not `z.string()` with runtime check
- [ ] Optional fields use `.optional()` — not `z.union([z.string(), z.undefined()])`
- [ ] Constraints match `API_Contract.json` specifications

## Usage Guidance

- [ ] Comment in the file indicating `.parse()` for Server Actions
- [ ] Comment in the file indicating `.safeParse()` for Route Handlers

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md §7`, `templates/Zod_Schema_Template.ts`, `knowledge/decision_rules.md` (DR001).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
