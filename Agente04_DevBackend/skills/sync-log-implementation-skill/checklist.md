# sync-log-implementation-skill — Execution Checklist

---

## Timing

- [ ] `const startedAt = Date.now()` is BEFORE the `try` block
- [ ] `durationMs: Date.now() - startedAt` computed in `finally`

## syncLog Call

- [ ] `syncLog()` is in `finally` — not only in `try`
- [ ] `job` matches vercel.json cron key exactly (kebab-case)
- [ ] `status` variable is `"success"` by default, `"error"` in catch
- [ ] `errorMsg` is `undefined` when status is `"success"`
- [ ] `counts` populated from job result (not hardcoded zeros)

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md §8`, `checklists/sync_log_checklist.md`, `knowledge/decision_rules.md` (DR005).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
