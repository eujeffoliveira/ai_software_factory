# Agente07_DevSecOps — Decision Rules

> If-then rules for security classification and gate decisions. These rules are authoritative — apply them mechanically. Reference the rule ID in every finding and gate decision.

---

## DR001 — Hardcoded Secret in Source Code → CRITICAL Block

**Condition:** Any string literal in source code matches a secret pattern:
- API keys: `sk-`, `xai-`, `ghp_`, `glpat-`, `AKIA`, `ya29.`
- Generic patterns: strings 20+ characters matching `[A-Za-z0-9+/=_-]{20,}` in assignment to variables named `key`, `secret`, `password`, `token`, `credential`
- Infrastructure: connection strings matching `postgres://`, `mysql://`, `mongodb+srv://`
- Auth: `NEXTAUTH_SECRET`, `JWT_SECRET` assigned a string literal
- OAuth: `client_secret`, `clientSecret` assigned a string literal
- Any `.env.local`, `.env.production` file tracked in git

**Action:**
1. Classify finding as CRITICAL
2. Issue gate status `BLOCKED_SECRET_EXPOSED`
3. Escalate to Tech Lead immediately — secret rotation is required
4. Do not proceed to APPROVED until: secret is removed from code, moved to `lib/env.ts`, and the secret has been rotated in the provider

**Source:** P6, FM-01

---

## DR002 — Auth Check Missing Before Business Logic → CRITICAL Block

**Condition:** A Server Action (`/features/*/actions/*.ts`) or Route Handler (`/app/api/**/route.ts`) contains database operations, business logic function calls, or external API calls before `const session = await auth()` followed by a session guard (`if (!session) ...`).

**Action:**
1. Classify finding as CRITICAL
2. Issue gate status `BLOCKED_AUTH_BYPASS`
3. Escalate to Tech Lead
4. Return to Agente04_DevBackend with Remediation_Guide.md showing the correct pattern
5. Re-audit before any APPROVED

**Source:** P11, FM-02, H1

---

## DR003 — Raw SQL String Concatenation → CRITICAL Block

**Condition:** Source code contains any of:
- `prisma.$queryRawUnsafe(` with string interpolation or concatenation
- `prisma.$executeRawUnsafe(` with string interpolation or concatenation
- Template literal `` prisma.$queryRaw`...${variable}...` `` (safe only if Prisma template tag is used correctly — verify the tag is Prisma's `sql` template)
- Any other pattern where user-controlled input is concatenated into a SQL string

**Action:**
1. Classify finding as CRITICAL
2. Issue gate status `BLOCKED_CRITICAL_RISK`
3. Return to Agente04_DevBackend with explicit remediation: use Prisma's parameterized API or Prisma's `sql` tagged template literal
4. Re-audit the full DAL layer before any APPROVED

**Source:** P5, FM-04, OWASP A03

---

## DR004 — Stack Trace or Error Details Exposed to Client → HIGH Finding

**Condition:** A `catch` block returns, serializes, or sends to the client any of:
- `error.message` directly in a response body
- `error.stack`
- The full error object (JSON serialized)
- Internal file paths, line numbers, or database query text

**Action:**
1. Classify finding as HIGH
2. Include in OWASP A09 failure row
3. Return for revision with guidance: use generic error messages in responses (`{ error: "An internal error occurred" }`) and log details internally
4. Do not issue APPROVED with unresolved HIGH findings

**Source:** P4, FM-05, OWASP A09

---

## DR005 — PII in audit_log or sync_log Fields → HIGH Finding, Privacy Violation

**Condition:** Any `audit_log` or `sync_log` entry contains:
- Raw user input values (names, email addresses, addresses)
- Form field values that may contain PII
- Passwords, tokens, or credentials in any field
- Full JSON blobs of user-provided data in `metadata`
- `actorEmail` sourced from request body or user input (must come from `session.user.email`)

**Action:**
1. Classify finding as HIGH
2. Issue gate status `BLOCKED_PRIVACY_VIOLATION`
3. Escalate to Tech Lead if PII may already be in production logs
4. Return for revision with specific guidance on which log fields contain PII and what safe alternatives look like

**Source:** P7, P8, FM-06

---

## DR006 — Dependency with CVSS ≥ 9.0 → CRITICAL Block

**Condition:** `npm audit` or CVE database lookup identifies a dependency in `package.json` with a CVSS base score ≥ 9.0.

**Action:**
1. Classify finding as CRITICAL
2. Issue gate status `BLOCKED_CRITICAL_RISK`
3. Escalate to Tech Lead
4. The Dev agent must upgrade to a patched version. If no patched version exists, Tech Lead must decide on removal, alternative, or human-approved risk acceptance with a defined remediation timeline
5. Re-run dependency scan after upgrade

**Source:** P10, FM-07, OWASP A06

---

## DR007 — Dependency with CVSS 7.0–8.9 → HIGH Finding

**Condition:** `npm audit` or CVE database lookup identifies a dependency in `package.json` with a CVSS base score between 7.0 and 8.9.

**Action:**
1. Classify finding as HIGH
2. Include in dependency review section of Security_Audit.md
3. Must be remediated before `APPROVED` — this blocks the gate
4. Exception: if human approves the risk in writing with a defined remediation timeline, may proceed to APPROVED with the risk documented

**Source:** P10, OWASP A06

---

## DR008 — process.env Used Outside lib/env.ts → MEDIUM Finding

**Condition:** Source code outside of `lib/env.ts` contains `process.env.VARIABLE_NAME` where VARIABLE_NAME is a non-standard or sensitive variable. (Exception: `process.env.NODE_ENV` is acceptable in limited framework context.)

**Action:**
1. Classify as MEDIUM (HIGH if the variable is security-sensitive: API keys, secrets, database URLs)
2. Include in OWASP A05 (Security Misconfiguration) review
3. Return for revision: all env var access must go through `lib/env.ts`
4. MEDIUM findings may proceed to APPROVED with the finding tracked for remediation

**Source:** P6, H5

---

## DR009 — Threat Model Missing for Feature with Auth/Data → Gate 5 Blocked

**Condition:** A feature involves any of: `auth()` calls, role-based access control, handling of CONFIDENTIAL or RESTRICTED data, external API integrations with user data, or cron jobs that process user records — AND no `Threat_Model.md` exists or the existing threat model does not cover all six STRIDE categories.

**Action:**
1. Issue gate status `BLOCKED_CRITICAL_RISK` (threat model is a gate entry requirement for these features)
2. Run `threat-modeling-skill` to produce the missing `Threat_Model.md` if sufficient information exists
3. If insufficient architecture information is available, issue `BLOCKED_PENDING_HUMAN` and escalate
4. After Threat_Model.md is complete, continue with the Gate 5 evaluation

**Source:** P1, P9, FM-08

---

## DR010 — IDOR: User Can Access Another User's Resources → CRITICAL Block

**Condition:** A Prisma query retrieves, updates, or deletes a record by ID (`recordId`) taken from user input without including `userId: session.user.id` in the `where` clause. This applies to: `findUnique`, `findFirst`, `update`, `delete`, and `deleteMany` on user-owned entities.

**Action:**
1. Classify finding as CRITICAL
2. Issue gate status `BLOCKED_AUTH_BYPASS`
3. Escalate to Tech Lead
4. Return to Agente04_DevBackend with Remediation_Guide.md showing the ownership-scoped query pattern
5. Verify the fix includes `userId: session.user.id` in the Prisma query's `where` clause
6. Re-audit all affected routes

**Source:** P2, P11, FM-03, H3

---

## DR011 — userId/actorId Taken from Request Body → CRITICAL Block

**Condition:** A Server Action or Route Handler extracts `userId`, `actorId`, `ownerId`, `authorId`, `creatorId`, or any field representing user identity from: `request.json()`, URL parameters, query parameters, or any client-supplied source. The session object (`session.user.id`) is the ONLY valid source for user identity.

**Action:**
1. Classify finding as CRITICAL
2. Issue gate status `BLOCKED_AUTH_BYPASS`
3. Escalate to Tech Lead
4. Return for revision: remove identity fields from Zod input schema; source from `session.user.id`
5. Scan the entire feature for the same pattern — it is likely present in multiple places if found once

**Source:** P11, FM-10, H2

---

## DR012 — LGPD/GDPR-Regulated Data Handling Decision Needed → Escalate Immediately

**Condition:** Any of the following are encountered:
- Feature collects, stores, or processes data regulated by LGPD, GDPR, HIPAA, or other data protection laws
- Feature shares user data with third parties without documented data processing agreement
- Feature enables cross-border data transfer (user in one jurisdiction, storage in another)
- Feature lacks documented legal basis for PII collection
- RESTRICTED data handling is required without prior human sign-off

**Action:**
1. Issue gate status `BLOCKED_PENDING_HUMAN`
2. Escalate to Tech Lead immediately — do not attempt to resolve the compliance question independently
3. Document the specific regulatory trigger (which law, which data element, which processing activity)
4. Pipeline pauses until a human with authority to make compliance decisions provides written approval
5. Resume evaluation after human decision is received and documented

**Source:** P8, P12, FM-09

---

## DR013 — All OWASP Categories Pass, No Unresolved CRITICAL or HIGH Findings, Threat Model Complete → APPROVED

**Condition:** ALL of the following are simultaneously true:
- All 10 OWASP Top 10 (2021) categories reviewed with PASS result and evidence
- Zero CRITICAL findings (unresolved)
- Zero HIGH findings (unresolved or without documented human risk acceptance)
- Secrets scan: CLEAN
- Auth/authz review: all routes verified
- Threat_Model.md: exists and covers all 6 STRIDE categories for auth/data features
- Privacy review: COMPLIANT (or NOT_APPLICABLE for features without PII)
- Dependency scan: no CVSS ≥ 7.0 unresolved findings
- Logging privacy: no PII in log fields
- Data classification: complete

**Action:**
1. Issue gate status `APPROVED`
2. Assemble Handoff Package with `gate_ready: true`
3. Route to Agente08_DevOps

**Source:** All principles, Gate 5 exit criteria

---

## DR014 — Remediation Guidance Must Include Specific Location and Pattern

**Condition:** Any finding of CRITICAL, HIGH, or MEDIUM severity is documented in the Security_Audit.md or Remediation_Guide.md.

**Action:**
1. Include in the finding: the exact file path and line number (e.g., `app/api/users/[id]/route.ts:42`)
2. Include: the exact code pattern that is wrong (quoted from the source)
3. Include: the exact correct pattern that should replace it (concrete code example)
4. Include: the decision rule that triggered the finding (e.g., DR002)
5. Findings without specific location and remediation guidance are incomplete and must be revised before issuing the gate decision

**Source:** FM-12 (self-failure avoidance)

---

## DR015 — Same Vulnerability in 3+ Locations → Systemic Issue, Flag for Architecture Review

**Condition:** The same class of vulnerability (e.g., missing auth check, IDOR pattern, `process.env` usage, PII in logs) is found in three or more distinct files or functions in the same review cycle.

**Action:**
1. Classify each instance individually (do not reduce severity because the pattern is common)
2. Add a systemic finding note to the Security_Audit.md executive summary: "Systemic pattern detected — [pattern] found in [N] locations, indicating a process or architecture gap"
3. Escalate to Tech Lead for process review — this agent identifies the pattern but does not redesign the architecture
4. In the Remediation_Guide.md, add a systemic recommendation section advising the Dev agents to search for the pattern everywhere, not just in the cited locations
5. On the next evaluation cycle, verify the pattern has been eliminated globally

**Source:** H15, escalation policy

---

## Archetype Classification Rules

DR-CLASS-001: Before applying any Golden Model, classify the project using the Project Archetype Matrix in `standards/project-classification.md`. The archetype determines which Golden Model applies.

DR-CLASS-002: Choosing the correct archetype is NOT a deviation from the Golden Model. No ADR is required for archetype selection. ADRs are only required for deviations *within* a chosen archetype.

DR-CLASS-003: `web_app` archetype → apply `standards/golden-model-web-app.md` (Next.js 16 stack). This is the default for user-facing applications.

DR-CLASS-004: `automation_script` archetype → apply `standards/golden-model-python-automation.md` (Python 3.12+ + uv + Typer + Pydantic v2 + structlog). Use when the project is a batch job, ETL step, data sync, maintenance script, or CLI operational tool.

DR-CLASS-005: When the archetype is ambiguous or the project combines multiple types, trigger Gate A0 (`standards/project-classification.md`) before proceeding. Gate A0 output is a JSON classification that all subsequent agents consume.
