# external-integration-client-skill — Execution Checklist

---

## Security

- [ ] API credentials from `lib/env.ts` — never hardcoded, never `process.env.X` directly
- [ ] No secrets in source code or comments

## Reliability

- [ ] `AbortSignal.timeout(TIMEOUT_MS)` on every fetch call
- [ ] TIMEOUT_MS is a named constant (not magic number `10000` inline)

## Response Validation

- [ ] Zod schema defined for every endpoint's response shape
- [ ] `Schema.parse(await response.json())` called before returning

## Error Handling

- [ ] Non-OK HTTP status throws typed error (`[Service]ApiError`)
- [ ] 429 throws rate limit error
- [ ] Error types exported for callers to handle specific cases

## Transaction Safety

- [ ] Client methods NOT called inside `prisma.$transaction` blocks (rule enforced by code review)

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md`, `templates/Integration_Client_Template.ts`, `knowledge/decision_rules.md` (DR006).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
