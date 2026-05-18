# Environment Validation Checklist
## Pre-Deploy — environment-validation-skill

Run this checklist as part of Gate 6 preparation. All items must pass before environment validation is complete.

---

## Section 1 — Identify Required Variables

- [ ] Locate `lib/env.ts` in the codebase
- [ ] Extract all variable names from the Zod schema (`z.object({...})`)
- [ ] Document each variable: name, Zod type constraint, whether it is required
- [ ] Confirm no `process.env` calls exist outside `lib/env.ts` (search codebase)

---

## Section 2 — Staging (Vercel Preview) Validation

For each variable in the Zod schema:
- [ ] **Present in Vercel dashboard (Preview scope)?** If NO → FAIL with variable name
- [ ] **Value format valid?** (URL, min-length, etc.) — assess by type
- [ ] **Value is not empty string?**
- [ ] **Value is not a placeholder?** (e.g., "your-secret-here", "REPLACE_ME")

**Staging result:** [ ] ALL PRESENT AND VALID / [ ] MISSING: [list]

---

## Section 3 — Production (Vercel Production) Validation

For each variable in the Zod schema:
- [ ] **Present in Vercel dashboard (Production scope)?** If NO → FAIL with variable name
- [ ] **Value format valid?**
- [ ] **Value is not empty string?**
- [ ] **Value is not a placeholder?**
- [ ] **Production DATABASE_URL points to production database** (not staging DB)
- [ ] **NEXTAUTH_URL is the production domain** (not staging domain)
- [ ] **NEXT_PUBLIC_APP_URL is the production domain** (not staging domain)

**Production result:** [ ] ALL PRESENT AND VALID / [ ] MISSING: [list]

---

## Section 4 — Environment Isolation (CRITICAL)

Secrets that MUST be distinct between staging and production:
- [ ] `DATABASE_URL` — distinct databases (staging DB vs. production DB)
- [ ] `NEXTAUTH_SECRET` — different JWT signing secrets
- [ ] `GOOGLE_CLIENT_SECRET` — separate OAuth applications
- [ ] `GOOGLE_CLIENT_ID` — separate OAuth applications
- [ ] Any external API keys — separate accounts or API key sets

**Method:** Compare by checking known environment-specific patterns (production domains, separate DB hostnames) — do NOT log or display the actual secret values.

**Isolation result:** [ ] PASS — all distinct / [ ] CRITICAL FAIL — [which variable is shared]

**If shared secret found:** STOP. Escalate to Agente07_DevSecOps. Do not deploy.

---

## Section 5 — `process.env` Audit

- [ ] Search codebase for `process.env.` (excluding `lib/env.ts` and `next.config.ts`)
- [ ] Any hit outside `lib/env.ts` is a violation
- [ ] Document violations with file path and variable name

**Violations found:** [ ] NONE — CLEAN / [ ] VIOLATIONS: [list file:line references]

**If violations found:** Return to Agente04_DevBackend with specific locations (DR003)

---

## Section 6 — New Variables in This Release

For any environment variable added in this release:
- [ ] Added to `lib/env.ts` Zod schema
- [ ] Added to staging Vercel dashboard
- [ ] Added to production Vercel dashboard
- [ ] Type validation matches the expected format
- [ ] `.env.example` updated (if project uses one)

---

## Summary

| Check | Result |
|-------|--------|
| Staging: all variables present and valid | [ ] PASS / [ ] FAIL |
| Production: all variables present and valid | [ ] PASS / [ ] FAIL |
| Environment isolation (no shared secrets) | [ ] PASS / [ ] CRITICAL_FAIL |
| No scattered `process.env` | [ ] PASS / [ ] FAIL |
| New variables added to all environments | [ ] PASS / [ ] N/A |

**Overall:** [ ] **PASS** — environment ready / [ ] **FAIL** — [blocking reason]

Produce `Environment_Checklist.md` from `templates/Environment_Checklist.md` with results.

---

## Runtime Knowledge Policy

This checklist is consulted at runtime from `Agente08_DevOps/checklists/env_validation_checklist.md`. Environment variable rules are in `context_view.md` Section 4. Decision rules applied: DR003 (scattered process.env), DR008 (shared secrets). Do not access `context/` or `lib/` to complete this checklist.
