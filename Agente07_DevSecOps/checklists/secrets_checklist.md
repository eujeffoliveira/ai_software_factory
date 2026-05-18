# Secrets Scanning Checklist

> Run this checklist as part of every Gate 5 evaluation. Any hardcoded secret found = CRITICAL finding, BLOCKED_SECRET_EXPOSED, immediate escalation.

## Runtime Knowledge Policy

Read from `Agente07_DevSecOps/knowledge/decision_rules.md` (DR001) and `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 006) before executing. Do NOT access `context/` or `lib/` at runtime.

---

## Pre-scan Setup

- [ ] Identify all source files in scope (TypeScript, JavaScript, JSON config, shell scripts)
- [ ] Note any files excluded from review and justify why
- [ ] Do NOT exclude test files — secrets in test files are still CRITICAL

---

## Pattern 1: API Key Literals

Search for patterns in string literals:
- [ ] `sk-[A-Za-z0-9]{20,}` — OpenAI-style keys
- [ ] `xai-[A-Za-z0-9]{20,}` — xAI API keys
- [ ] `AKIA[A-Z0-9]{16}` — AWS access keys
- [ ] `ya29.[A-Za-z0-9_-]{68,}` — Google OAuth access tokens
- [ ] `ghp_[A-Za-z0-9]{36}` — GitHub personal access tokens
- [ ] `glpat-[A-Za-z0-9_-]{20}` — GitLab personal access tokens
- [ ] `AIza[A-Za-z0-9_-]{35}` — Google API keys
- [ ] Any string 32+ characters that is clearly an API key (mixed alphanumeric, no spaces)

**Result:** CLEAN / FOUND
**Location (if found):** [file:line]

---

## Pattern 2: Connection Strings and Database URLs

- [ ] `postgres://[^'"]+` — PostgreSQL connection strings
- [ ] `postgresql://[^'"]+` — PostgreSQL (alternate prefix)
- [ ] `mysql://[^'"]+` — MySQL connection strings
- [ ] `mongodb\+srv://[^'"]+` — MongoDB Atlas connection strings
- [ ] `redis://[^'"]+` — Redis connection strings
- [ ] `DATABASE_URL\s*=\s*["']` — DATABASE_URL assigned a literal value

**Result:** CLEAN / FOUND
**Location (if found):** [file:line]

---

## Pattern 3: Auth Secrets and Tokens

- [ ] `NEXTAUTH_SECRET\s*[=:]\s*["'][^"']+` — hardcoded NextAuth secret
- [ ] `JWT_SECRET\s*[=:]\s*["'][^"']+` — hardcoded JWT secret
- [ ] `client_secret\s*[=:]\s*["'][^"']+` — OAuth client secret
- [ ] `clientSecret\s*[=:]\s*["'][^"']+` — OAuth client secret (camelCase)
- [ ] `GOOGLE_CLIENT_SECRET\s*[=:]\s*["'][^"']+` — Google OAuth secret
- [ ] `Bearer [A-Za-z0-9._-]{20,}` — Bearer token hardcoded

**Result:** CLEAN / FOUND
**Location (if found):** [file:line]

---

## Pattern 4: Generic Credentials

- [ ] `password\s*[=:]\s*["'][^"']{4,}` — hardcoded password
- [ ] `passwd\s*[=:]\s*["'][^"']{4,}` — hardcoded password
- [ ] `api_key\s*[=:]\s*["'][^"']{4,}` — hardcoded API key
- [ ] `apiKey\s*[=:]\s*["'][^"']{4,}` — hardcoded API key (camelCase)
- [ ] `secret\s*[=:]\s*["'][A-Za-z0-9_-]{16,}` — generic secret value
- [ ] `token\s*[=:]\s*["'][A-Za-z0-9_-]{20,}` — hardcoded token
- [ ] `private_key\s*[=:]\s*["']-----BEGIN` — private key material

**Result:** CLEAN / FOUND
**Location (if found):** [file:line]

---

## Pattern 5: Environment Variable Usage Outside lib/env.ts

- [ ] Search for `process.env.` in all files except `lib/env.ts`
- [ ] Check each occurrence: is the accessed variable innocuous (`NODE_ENV`) or sensitive?
- [ ] Flag all security-sensitive `process.env` access outside `lib/env.ts` (MEDIUM or HIGH depending on variable)

**Result:** CLEAN / [N occurrences found]
**Locations (if found):** [file:line, file:line]
**Classification:** [MEDIUM for non-sensitive, HIGH for sensitive variables]

---

## Pattern 6: Committed .env Files

- [ ] Check if `.env`, `.env.local`, `.env.production`, `.env.staging` are in version control
- [ ] Verify `.gitignore` includes `.env*` (except `.env.example`)
- [ ] Check git history for any `.env` files that may have been committed and removed

**Result:** CLEAN / FOUND
**Location (if found):** [file path]

---

## Pattern 7: Commented-Out Secrets

- [ ] Search for patterns from Patterns 1-4 in code comments (`// ...` and `/* ... */`)
- [ ] Commented-out code with secrets is still a CRITICAL finding (secrets in version control history)

**Result:** CLEAN / FOUND
**Location (if found):** [file:line]

---

## Post-scan Actions

### If CLEAN:
- [ ] Document: "Secrets scan CLEAN — N files reviewed, no hardcoded secrets found"
- [ ] Mark `secrets_scan_status: CLEAN` in Security_Audit.md
- [ ] Continue with other Gate 5 checks

### If FOUND (any pattern):
- [ ] Classify as CRITICAL finding (DR001)
- [ ] Issue `BLOCKED_SECRET_EXPOSED`
- [ ] Escalate to Tech Lead immediately — secret rotation is required
- [ ] Document exact file:line and pattern type
- [ ] Include in Remediation_Guide.md with correct pattern (move to lib/env.ts)
- [ ] Note: changing the code is not sufficient — the secret may need rotation if it was committed to a repository (even private)

---

## Secrets Scan Summary

| Check Category | Files Reviewed | Result |
|---------------|---------------|--------|
| API key literals | [N] | CLEAN / FOUND |
| Connection strings | [N] | CLEAN / FOUND |
| Auth secrets and tokens | [N] | CLEAN / FOUND |
| Generic credentials | [N] | CLEAN / FOUND |
| process.env outside lib/env.ts | [N] | CLEAN / [N found] |
| .env files in version control | N/A | CLEAN / FOUND |
| Commented-out secrets | [N] | CLEAN / FOUND |

**Overall secrets scan status:** CLEAN / EXPOSED
