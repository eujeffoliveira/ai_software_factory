# Agente07_DevSecOps — Failure Modes

> Documented failure modes with symptoms, root causes, and corrective actions. Review this file when a security evaluation produces unexpected or ambiguous results.

---

## FM-01 — Hardcoded Secret in Source Code

**Severity:** CRITICAL
**Status Code:** `BLOCKED_SECRET_EXPOSED`

**Symptom:** A credential, API key, JWT secret, database URL, OAuth client secret, or password is found as a literal string in source code (TypeScript, JSON config, shell script, or any tracked file).

**Root Cause:** Developer bypassed `lib/env.ts` pattern, likely for convenience during testing or local development. The secret was committed without `.gitignore` protection.

**Impact:** Full compromise of the exposed credential. If the secret is in version control history, rotation alone is insufficient — the history must be scrubbed.

**Corrective Action:**
1. Issue `BLOCKED_SECRET_EXPOSED` immediately.
2. Escalate to Tech Lead — secret rotation is required even if the repo is private.
3. The Dev agent must: (a) remove the hardcoded value, (b) add the variable to `lib/env.ts`, (c) ensure `.env` is in `.gitignore`.
4. After fix, re-audit before issuing any APPROVED.
5. Advise Tech Lead to rotate the exposed secret even if the codebase change is made — the secret may already be logged or cached.

---

## FM-02 — Missing Auth Check in Server Action or Route Handler

**Severity:** CRITICAL
**Status Code:** `BLOCKED_AUTH_BYPASS`

**Symptom:** A Server Action or Route Handler reaches database queries, business logic, or external API calls without first calling `const session = await auth()` and verifying the session.

**Root Cause:** Developer added business logic before the auth check, or assumed auth was handled at a higher layer (e.g., a layout component or middleware). In Next.js App Router, each Server Action and Route Handler must independently verify auth.

**Impact:** Any unauthenticated request can execute protected business logic. Depending on the operation, this can result in data exposure, data mutation, or privilege escalation.

**Corrective Action:**
1. Issue `BLOCKED_AUTH_BYPASS` immediately.
2. Escalate to Tech Lead.
3. The Dev agent must move `const session = await auth()` to be the absolute first operation, followed immediately by `if (!session) return { error: "Unauthorized" }`.
4. Re-audit the fixed route before any APPROVED.

---

## FM-03 — IDOR — User Can Access Another User's Data

**Severity:** CRITICAL
**Status Code:** `BLOCKED_AUTH_BYPASS`

**Symptom:** A query retrieves a record by ID (from the URL or request body) without including an ownership check (e.g., `userId: session.user.id` in the Prisma `where` clause). This allows authenticated user A to access user B's data by guessing a valid record ID.

**Root Cause:** The developer performed authentication (verified the user is logged in) but not authorization (verified the user owns the requested resource). This is the most common auth mistake: treating authentication as sufficient.

**Impact:** Full data exposure for all records in the affected table to any authenticated user. Depending on the data, this can be a reportable privacy breach.

**Corrective Action:**
1. Issue `BLOCKED_AUTH_BYPASS`.
2. The Dev agent must add `userId: session.user.id` to every Prisma query that retrieves, updates, or deletes a user-owned resource.
3. Do not fix IDOR by checking after retrieval — the ownership check must be part of the database query to prevent unnecessary data loading.
4. Re-audit all affected routes before APPROVED.

---

## FM-04 — SQL Injection via Raw SQL String Concatenation

**Severity:** CRITICAL
**Status Code:** `BLOCKED_CRITICAL_RISK`

**Symptom:** A `prisma.$queryRawUnsafe()` or `prisma.$executeRawUnsafe()` call uses string interpolation or concatenation with user-controlled input. Alternatively, `prisma.$queryRaw` is used with template literals that incorporate variables unsafely.

**Root Cause:** Developer needed a complex query that Prisma's standard API doesn't easily support and reached for raw SQL without understanding the injection risk. Alternatively, the developer was unfamiliar with Prisma's parameterization safety guarantees.

**Impact:** SQL injection — attacker can execute arbitrary SQL against the database, extract all data, modify records, or drop tables.

**Corrective Action:**
1. Issue `BLOCKED_CRITICAL_RISK`.
2. The Dev agent must replace unsafe raw queries with Prisma's parameterized API or, if raw SQL is truly required, use the tagged template literal form: `` prisma.$queryRaw`SELECT * FROM "User" WHERE id = ${userId}` `` (Prisma auto-parameterizes tagged template literals).
3. If the complex query truly cannot be expressed without raw SQL, it requires an ADR and Tech Lead approval before proceeding.

---

## FM-05 — Stack Trace Exposed to Client

**Severity:** HIGH
**Finding Type:** Information Disclosure (OWASP A09)

**Symptom:** A `catch` block returns `error.message`, `error.stack`, or the full error object in the API response body. The client receives internal implementation details such as Prisma query paths, database structure, file paths, or dependency version information.

**Root Cause:** Developer used a debug-friendly error response that reveals internal state. Often copied from development environment patterns.

**Impact:** Attackers can use stack traces to fingerprint the technology stack, identify vulnerable library versions, understand database structure, and discover code paths for targeted attacks.

**Corrective Action:**
1. Record as HIGH finding.
2. Return with guidance: catch blocks must return generic messages (e.g., `{ error: "An internal error occurred" }`) and log the actual error internally using `console.error` with a structured log entry.
3. Never serialize the full Error object into a response.
4. After fix, confirm the response no longer contains internals.

---

## FM-06 — PII in Log Fields

**Severity:** HIGH
**Status Code:** `BLOCKED_PRIVACY_VIOLATION`

**Symptom:** An `audit_log` or `sync_log` entry contains raw personally identifiable information: email addresses in a metadata value, names, phone numbers, raw form field values including passwords, or full JSON blobs of user input.

**Root Cause:** Developer logged the raw request body or user input object for debugging, not realizing that this creates a persistent privacy record. Alternatively, the developer misunderstood which fields were safe to include in `audit_log`.

**Impact:** PII is stored in system logs, creating a privacy compliance obligation (LGPD/GDPR right to erasure) that the log system may not support. If logs are shipped to a third party, this creates a data sharing issue.

**Corrective Action:**
1. Issue `BLOCKED_PRIVACY_VIOLATION`.
2. Escalate if the PII may have already been written to production logs.
3. The Dev agent must replace raw PII values with safe identifiers (IDs, field names, action types). The `metadata` field should contain structural information, not value data.
4. If logs have already been written with PII, advise Tech Lead to purge the affected log entries from production.

---

## FM-07 — Critical Dependency Vulnerability (CVSS ≥ 9.0)

**Severity:** CRITICAL
**Status Code:** `BLOCKED_CRITICAL_RISK`

**Symptom:** A package in `package.json` has a known CVE with a CVSS base score of 9.0 or higher. This is typically identified through `npm audit` output or a CVE database lookup.

**Root Cause:** The dependency was added before the CVE was discovered, or the project has not been updated since the CVE was published. Automated dependency update tooling (Dependabot, Renovate) may not have been configured.

**Impact:** Depends on the specific CVE. At CVSS 9.0+, the impact is typically remote code execution, authentication bypass, or complete system compromise via the affected package.

**Corrective Action:**
1. Issue `BLOCKED_CRITICAL_RISK`.
2. The Dev agent must upgrade the vulnerable package to a patched version.
3. If no patched version exists, Tech Lead must decide: (a) remove the package and implement functionality differently, (b) find an alternative package, (c) accept the risk with documented human approval (rare — only for temporary mitigations with a defined timeline).
4. Re-run dependency scan after upgrade to confirm the CVE is resolved.

---

## FM-08 — Threat Model Missing for Auth or Data Feature

**Severity:** CRITICAL
**Status Code:** `BLOCKED_CRITICAL_RISK`

**Symptom:** A feature that involves authentication, authorization, or handling of CONFIDENTIAL/RESTRICTED data does not have a corresponding `Threat_Model.md`. Alternatively, an existing `Threat_Model.md` does not cover all six STRIDE categories.

**Root Cause:** The threat model was skipped as a "paper exercise" or never formally produced. The threat modeling requirement may not have been communicated clearly during planning.

**Impact:** Without a threat model, security risks are identified reactively (after an incident) rather than proactively. Features with unmodeled threats are more likely to have auth bypass, IDOR, and information disclosure vulnerabilities.

**Corrective Action:**
1. Issue a gate block.
2. Run `threat-modeling-skill` to produce the missing `Threat_Model.md` based on available architecture information.
3. If insufficient information is available to produce a threat model (missing architecture docs), issue `BLOCKED_PENDING_HUMAN` and escalate.
4. After threat model is produced and validated, continue with the remaining Gate 5 evaluation.

---

## FM-09 — Privacy Violation — PII Collection Without Documented Justification

**Severity:** HIGH
**Status Code:** `BLOCKED_PRIVACY_VIOLATION` (escalates to `BLOCKED_PENDING_HUMAN` for RESTRICTED data)

**Symptom:** The feature collects, stores, or processes user PII (email, name, phone number, address, behavioral data) without documented consent, legal basis, or explicit justification in the PRD or Architecture.md.

**Root Cause:** PII collection was added without a privacy review. The developer implemented the feature as specified but the PRD did not flag the privacy obligations.

**Impact:** Regulatory non-compliance with LGPD/GDPR. Potential fines, mandatory breach notification, and reputational damage.

**Corrective Action:**
1. Issue `BLOCKED_PRIVACY_VIOLATION`.
2. Escalate to Tech Lead immediately for regulatory assessment.
3. The product owner (Agente01) must document the legal basis for PII collection.
4. If RESTRICTED data is involved, `BLOCKED_PENDING_HUMAN` — human must approve the data handling decision.
5. Do not APPROVE until legal basis is documented and technical controls (consent, minimization, deletion) are implemented.

---

## FM-10 — userId/actorId Taken from Request Body (Privilege Escalation Vector)

**Severity:** CRITICAL
**Status Code:** `BLOCKED_AUTH_BYPASS`

**Symptom:** A Server Action or Route Handler extracts `userId`, `actorId`, `ownerId`, or any user identity field from `request.json()`, request params, or URL parameters to determine what data to access or what action to authorize.

**Root Cause:** Developer trusted the client to report its own identity, not understanding that any client can send any value in a request body. The session object is the only trusted source of identity.

**Impact:** Any authenticated user can impersonate any other user by sending a different `userId` in the request body. This is a complete authorization bypass.

**Corrective Action:**
1. Issue `BLOCKED_AUTH_BYPASS` immediately.
2. The fix is straightforward: remove the `userId` from the input schema and always use `session.user.id` from the verified session object.
3. Update the Zod input schema to exclude user identity fields — these should never be client-supplied.
4. Re-audit the entire feature for similar patterns before resubmission.

---

## FM-11 — guardCron() Missing or Not First Call in Cron Route

**Severity:** CRITICAL
**Status Code:** `BLOCKED_AUTH_BYPASS`

**Symptom:** A cron job Route Handler (`/api/cron/*/route.ts`) executes business logic, database operations, or external API calls before calling `guardCron(request)`, or omits `guardCron()` entirely.

**Root Cause:** Developer treated cron routes like regular API routes. Cron routes are authenticated by the `guardCron()` function which validates the Vercel Cron secret header — without it, anyone can trigger the cron job via a direct HTTP request.

**Impact:** Unauthenticated users can trigger expensive, sensitive, or destructive background jobs at will.

**Corrective Action:**
1. Issue `BLOCKED_AUTH_BYPASS`.
2. The Dev agent must add `guardCron(request)` as the absolute first line of every cron route handler, before any other logic.
3. Confirm `guardCron()` validates the `Authorization` header against the cron secret from `lib/env.ts`.

---

## FM-12 — Security Audit Produced Without All 10 OWASP Categories Reviewed

**Severity:** HIGH (self-failure)
**Status Code:** Issue `RETURNED_FOR_REVISION` on the audit output and re-run

**Symptom:** The DevSecOps agent produces a `Security_Audit.md` with fewer than 10 OWASP categories in the coverage table, or marks a category as reviewed without providing evidence.

**Root Cause:** The `owasp-review-skill` was not fully executed, or the agent skipped categories it judged "not applicable" without documenting the rationale.

**Impact:** Incomplete security audit. A category skipped is a category not reviewed — any vulnerability in that category is undetected.

**Corrective Action:**
1. Do not issue any gate decision with an incomplete OWASP table.
2. Re-run `owasp-review-skill` for all missing categories.
3. If a category is genuinely not applicable (e.g., A10 SSRF in a feature with no outbound HTTP calls), document the rationale explicitly: "NOT_APPLICABLE — this feature makes no outbound HTTP requests."
4. All 10 rows must appear in the OWASP table before issuing any gate decision.
