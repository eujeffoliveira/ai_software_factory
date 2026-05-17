# structured-logging-skill — Execution Checklist

---

## Log Format

- [ ] All log calls use structured objects: `console.error("[location]:", { error, field1, field2 })`
- [ ] No string concatenation: not `"Error: " + error.message`, not template literals
- [ ] Location prefix present: `"[functionName]"` or `"[GET /api/resource]"`
- [ ] `error` object included in error-level logs

## Context

- [ ] `userId` or actor identifier included where available
- [ ] `entityId` included for operations on specific records
- [ ] No passwords, tokens, API keys, or full credit card numbers in any log
- [ ] Context is sufficient to reproduce the issue without accessing production DB

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md §11`, `knowledge/heuristics.md` (H7), `knowledge/principles.md` (P8).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
