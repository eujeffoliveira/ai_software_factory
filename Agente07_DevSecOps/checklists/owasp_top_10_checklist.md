# OWASP Top 10 (2021) Checklist

> Run this checklist on every Gate 5 evaluation. All 10 categories must be reviewed. Each check must show evidence (pass or fail with specific file references).

## Runtime Knowledge Policy

Read from `Agente07_DevSecOps/knowledge/decision_rules.md` and `Agente07_DevSecOps/knowledge/knowledge_cards.md` before executing this checklist. Do NOT access `context/` or `lib/` at runtime.

---

## A01 — Broken Access Control

- [ ] **Auth check first**: Every Server Action and Route Handler has `const session = await auth()` as the FIRST operation
- [ ] **Session guard**: Every protected route returns 401 immediately if `!session`
- [ ] **Ownership check**: Every Prisma query on user-owned data includes `userId: session.user.id` in the `where` clause
- [ ] **No IDOR**: No route retrieves records by ID without scoping to the session user
- [ ] **userId source**: `userId` / `actorId` / `ownerId` are sourced from `session.user.id`, never from request body or URL params
- [ ] **Cron auth**: Every cron Route Handler calls `guardCron(request)` as its FIRST operation
- [ ] **No role escalation from client**: Roles and permissions are never accepted from client-supplied input

**Status:** ✅ PASS / ❌ FAIL
**Evidence:** [File paths and line numbers reviewed; specific findings if FAIL]

---

## A02 — Cryptographic Failures

- [ ] **Secrets in code**: No hardcoded API keys, JWT secrets, database URLs, OAuth secrets, or passwords in source code
- [ ] **Env var pattern**: All secrets accessed via `lib/env.ts` — no `process.env.SECRET_NAME` outside this file
- [ ] **HTTPS enforced**: Application deployed on Vercel — HTTPS enforced at platform level
- [ ] **Sensitive data not stored plaintext**: Passwords not stored (handled by OAuth); sensitive fields not in plaintext if stored
- [ ] **No sensitive data in URLs**: Tokens, passwords, or session data not in URL parameters or logged URLs

**Status:** ✅ PASS / ❌ FAIL
**Evidence:** [File paths reviewed; specific findings if FAIL]

---

## A03 — Injection

- [ ] **No raw SQL concatenation**: No `$queryRawUnsafe` or `$executeRawUnsafe` with user input
- [ ] **Prisma parameterized**: All database queries use Prisma's standard API or safe `$queryRaw` tagged template
- [ ] **Zod validation**: All user input validated by Zod schema before reaching business logic or DAL
- [ ] **No eval/dynamic execution**: No `eval()`, `new Function()`, or dynamic code execution with user input
- [ ] **No template injection**: No user-supplied content in server-side template rendering without escaping

**Status:** ✅ PASS / ❌ FAIL
**Evidence:** [File paths reviewed; specific findings if FAIL]

---

## A04 — Insecure Design

- [ ] **Threat model exists**: For features with auth/authz/data, `Threat_Model.md` exists and is current
- [ ] **All STRIDE categories covered**: Threat model covers S, T, R, I, D, E
- [ ] **Trust boundaries defined**: Trust boundaries documented in threat model
- [ ] **Business logic not in route handlers**: Business logic lives in `features/[domain]/`, not in `app/api/*/route.ts`
- [ ] **Security requirements defined**: PRD or Architecture.md documents auth and data sensitivity requirements

**Status:** ✅ PASS / ❌ FAIL
**Evidence:** [Threat_Model.md status; specific findings if FAIL]

---

## A05 — Security Misconfiguration

- [ ] **No default credentials**: No default admin passwords or generic service credentials in use
- [ ] **Debug mode**: No debug logging or stack traces exposed to production clients
- [ ] **guardCron() pattern**: All cron routes protected; no business routes accidentally public
- [ ] **No sensitive headers**: No server version strings or internal headers exposed in responses
- [ ] **Environment separation**: Dev/staging/prod use separate secrets and connection strings

**Status:** ✅ PASS / ❌ FAIL
**Evidence:** [Specific configurations reviewed; findings if FAIL]

---

## A06 — Vulnerable Components

- [ ] **npm audit**: `npm audit` run — results reviewed
- [ ] **CVSS ≥ 9.0**: No unresolved CVSS ≥ 9.0 findings in dependencies
- [ ] **CVSS 7.0–8.9**: No unresolved CVSS 7.0–8.9 findings (or risk formally accepted by human)
- [ ] **CVSS 4.0–6.9**: MEDIUM findings tracked in remediation backlog
- [ ] **No unmaintained packages**: No production dependencies with abandoned/archived repositories
- [ ] **Lock file present**: `package-lock.json` present and committed

**Status:** ✅ PASS / ❌ FAIL
**Evidence:** [npm audit output summary; CVSS scores for any findings]

---

## A07 — Identification and Authentication Failures

- [ ] **NextAuth v5**: Authentication implemented via NextAuth v5 — not custom session management
- [ ] **Google OAuth**: Authentication uses Google OAuth — no custom password storage
- [ ] **Session not trusted from client**: Session data comes from `await auth()`, never from client-supplied cookies or headers directly
- [ ] **No session fixation**: Session regenerated after login (handled by NextAuth)
- [ ] **NEXTAUTH_SECRET**: `NEXTAUTH_SECRET` set via environment variable and not hardcoded

**Status:** ✅ PASS / ❌ FAIL
**Evidence:** [Auth implementation files reviewed; findings if FAIL]

---

## A08 — Software and Data Integrity Failures

- [ ] **Deployment integrity**: Application deployed via Vercel — build artifacts are verified
- [ ] **No untrusted CDN scripts**: No `<script src>` from unverified CDN without Subresource Integrity (SRI)
- [ ] **Migration safety**: Database migrations use `prisma migrate deploy` — never `prisma db push` in staging/prod
- [ ] **No deserialization of untrusted data**: No `JSON.parse()` of user-supplied strings passed directly to business logic without Zod validation

**Status:** ✅ PASS / ❌ FAIL
**Evidence:** [Deployment configuration; script tags reviewed; migration commands]

---

## A09 — Security Logging and Monitoring Failures

- [ ] **audit_log present**: All sensitive human-initiated actions logged via `audit_log`
- [ ] **sync_log present**: All automated cron job results logged via `sync_log`
- [ ] **No PII in logs**: No raw email addresses, names, passwords, or tokens in any log field
- [ ] **actorEmail from session**: `actorEmail` in audit_log sourced from `session.user.email`, never from request
- [ ] **Stack traces not logged to client**: Error responses use generic messages; details logged internally
- [ ] **Log structure correct**: Logs follow structured JSON format — not plain text or interpolated strings

**Status:** ✅ PASS / ❌ FAIL
**Evidence:** [audit_log call sites reviewed; log field values examined; findings if FAIL]

---

## A10 — Server-Side Request Forgery (SSRF)

- [ ] **No user-controlled URLs in fetch()**: No user-supplied URL directly passed to `fetch()` without allowlist validation
- [ ] **External API endpoints hardcoded**: External API base URLs sourced from `lib/env.ts`, not user input
- [ ] **Redirect validation**: If feature redirects users, destination URL is validated against an allowlist
- [ ] **No internal service access from user input**: User input cannot cause the server to make requests to internal services or metadata endpoints

**Status:** ✅ PASS / ❌ FAIL
**Evidence:** [fetch() call sites reviewed; URL sources examined; findings if FAIL]

---

## OWASP Review Summary

| Category | Status | Finding IDs |
|----------|--------|------------|
| A01 Broken Access Control | ✅ PASS / ❌ FAIL | |
| A02 Cryptographic Failures | ✅ PASS / ❌ FAIL | |
| A03 Injection | ✅ PASS / ❌ FAIL | |
| A04 Insecure Design | ✅ PASS / ❌ FAIL | |
| A05 Security Misconfiguration | ✅ PASS / ❌ FAIL | |
| A06 Vulnerable Components | ✅ PASS / ❌ FAIL | |
| A07 Authentication Failures | ✅ PASS / ❌ FAIL | |
| A08 Software & Data Integrity Failures | ✅ PASS / ❌ FAIL | |
| A09 Security Logging Failures | ✅ PASS / ❌ FAIL | |
| A10 SSRF | ✅ PASS / ❌ FAIL | |

**Total categories reviewed:** [N]/10
**Total categories passed:** [N]/10
**Total categories failed:** [N]/10

> Gate 5 cannot be APPROVED if any category is not reviewed or if any category FAIL has an unresolved CRITICAL or HIGH finding.
