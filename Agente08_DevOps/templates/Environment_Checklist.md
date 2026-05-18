# Environment Checklist
## Produced by: environment-validation-skill
## Gate 6 Pre-Deploy Check

**Project:** [Project Name]
**Checked at:** [ISO-8601 timestamp]
**`lib/env.ts` schema path:** `lib/env.ts`

---

## Variables Defined in `lib/env.ts` Schema

| Variable Name | Type (Zod) | Required |
|---------------|-----------|---------|
| `DATABASE_URL` | `z.string().url()` | Yes |
| `NEXTAUTH_SECRET` | `z.string().min(32)` | Yes |
| `NEXTAUTH_URL` | `z.string().url()` | Yes |
| `GOOGLE_CLIENT_ID` | `z.string().min(10)` | Yes |
| `GOOGLE_CLIENT_SECRET` | `z.string().min(10)` | Yes |
| `NEXT_PUBLIC_APP_URL` | `z.string().url()` | Yes |
| [additional variables] | [type] | [Yes/No] |

---

## Staging Environment Validation (Vercel Preview)

| Variable | Present | Type Valid | Notes |
|----------|---------|-----------|-------|
| `DATABASE_URL` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |
| `NEXTAUTH_SECRET` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |
| `NEXTAUTH_URL` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |
| `GOOGLE_CLIENT_ID` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |
| `GOOGLE_CLIENT_SECRET` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |
| `NEXT_PUBLIC_APP_URL` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |

**Staging result:** [ ] ALL PRESENT AND VALID / [ ] MISSING: [list missing variables]

---

## Production Environment Validation (Vercel Production)

| Variable | Present | Type Valid | Notes |
|----------|---------|-----------|-------|
| `DATABASE_URL` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |
| `NEXTAUTH_SECRET` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |
| `NEXTAUTH_URL` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |
| `GOOGLE_CLIENT_ID` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |
| `GOOGLE_CLIENT_SECRET` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |
| `NEXT_PUBLIC_APP_URL` | [ ] YES / [ ] NO | [ ] YES / [ ] NO | |

**Production result:** [ ] ALL PRESENT AND VALID / [ ] MISSING: [list missing variables]

---

## Environment Isolation Check

**Critical: staging and production must NOT share secret values.**

| Variable | Isolated (distinct values) | Notes |
|----------|---------------------------|-------|
| `DATABASE_URL` | [ ] YES / [ ] SHARED (CRITICAL) | |
| `NEXTAUTH_SECRET` | [ ] YES / [ ] SHARED (CRITICAL) | |
| `GOOGLE_CLIENT_ID` | [ ] YES / [ ] SHARED (CRITICAL) | |
| `GOOGLE_CLIENT_SECRET` | [ ] YES / [ ] SHARED (CRITICAL) | |
| [other secrets] | [ ] YES / [ ] SHARED (CRITICAL) | |

**Isolation result:** [ ] PASS — all secrets are distinct / [ ] CRITICAL FAIL — escalate to Agente07_DevSecOps immediately

---

## Scattered `process.env` Check

**All environment variable access must go through `lib/env.ts`.**

| File | Variable | Status |
|------|----------|--------|
| [file_path] | [VARIABLE_NAME] | [ ] VIOLATION FOUND / [ ] CLEAN |

**Scattered env check result:** [ ] CLEAN — all access via `lib/env.ts` / [ ] VIOLATIONS FOUND — return to Agente04_DevBackend

---

## Overall Environment Validation Status

| Check | Result |
|-------|--------|
| Staging: all variables present | [ ] PASS / [ ] FAIL |
| Production: all variables present | [ ] PASS / [ ] FAIL |
| Environment isolation (no shared secrets) | [ ] PASS / [ ] CRITICAL_FAIL |
| No scattered `process.env` usage | [ ] PASS / [ ] FAIL |

**Overall result:** [ ] **PASS** — environment is ready for deployment / [ ] **FAIL** — see failures above

**Gate 6 impact:** [ ] No blocking issues / [ ] BLOCKS Gate 6 — [describe blocking issue]
