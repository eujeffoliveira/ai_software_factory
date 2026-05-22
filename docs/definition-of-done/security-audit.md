# Definition of Done — Security_Audit.md

## Overview

The Security Audit is a mandatory review conducted by the DevSecOps agent before any deployment. It verifies that the system is protected against the most common and impactful attack categories, that dependencies are free of known vulnerabilities, that no secrets are exposed in the codebase, and that data privacy requirements are met. Gate 5 cannot be bypassed or overridden by the Tech Lead — a security violation blocks the pipeline until resolved.

## Owner Agent

- **Primary:** `@devsecops` (Agente07_DevSecOps)
- **Gate:** Gate 5 — Security Audit (incontornavel — cannot be overridden)

## Required Fields / Sections

### OWASP Top 10 Checklist
Each category must be evaluated with a finding status: `PASS`, `FAIL`, or `N/A` (with justification for N/A).

- [ ] **A01 — Broken Access Control:** Every endpoint verifies authentication AND resource-level authorization. IDOR prevention confirmed. 403 returned for unauthorized resource access, 404 used to avoid confirming resource existence to unauthorized callers.
- [ ] **A02 — Cryptographic Failures:** Sensitive data (passwords, tokens, PII) is not stored in plaintext. HTTPS enforced. Weak algorithms (MD5, SHA1 for security purposes) are absent.
- [ ] **A03 — Injection:** No SQL string concatenation. All Prisma queries use parameterized API. Raw SQL (if present) uses `Prisma.sql` template tag only. No template literal interpolation in queries.
- [ ] **A04 — Insecure Design:** No business logic in Route Handlers. Auth check is first in every handler. No sensitive operations reachable without auth.
- [ ] **A05 — Security Misconfiguration:** No debug mode in production configuration. No stack traces or internal errors exposed to clients. No default credentials. Security headers configured.
- [ ] **A06 — Vulnerable and Outdated Components:** Dependency scan completed (see Dependency Scan section). No known `critical` or `high` CVEs in production dependencies.
- [ ] **A07 — Authentication and Identification Failures:** Session management reviewed. Token expiry configured. No credentials accepted in query parameters or URL paths.
- [ ] **A08 — Software and Data Integrity Failures:** CI/CD pipeline does not allow unsigned or unverified artifact deployment. Dependency lock file (`package-lock.json` or `yarn.lock`) is committed.
- [ ] **A09 — Security Logging and Monitoring Failures:** `audit_log` records all sensitive human actions. `sync_log` records all automated job executions. No sensitive data (passwords, raw tokens) written to logs.
- [ ] **A10 — Server-Side Request Forgery (SSRF):** Any user-controlled URL input is validated against an allowlist before making outbound requests. External integration clients have timeout configured.

### Threat Model
- [ ] Threat model document exists (STRIDE or equivalent)
- [ ] Data flow diagram identifies all trust boundaries
- [ ] Each identified threat has: description, likelihood (Low/Medium/High), impact (Low/Medium/High), and mitigation
- [ ] All `High` likelihood AND `High` impact threats have confirmed mitigations implemented
- [ ] Threats with mitigations that are deferred have a documented rationale and acceptance by the Tech Lead

### Dependency Scan
- [ ] Dependency scan tool run and results attached (e.g., `npm audit`, `Snyk`, `OWASP Dependency Check`)
- [ ] Zero `critical` severity CVEs in production dependencies (`dependencies` in `package.json`)
- [ ] Zero `high` severity CVEs in production dependencies
- [ ] Any `medium` CVE has a documented resolution plan with a timeline
- [ ] Dev-only dependencies (`devDependencies`) scanned separately; `critical` CVEs in dev deps are noted but do not block Gate 5 if not in the production bundle
- [ ] Scan date is within 7 days of submission

### Secrets Scan
- [ ] Secrets scan tool run across entire codebase and git history (e.g., `git-secrets`, `truffleHog`, `gitleaks`)
- [ ] Zero secrets (API keys, passwords, tokens, connection strings) found in source files
- [ ] Zero secrets found in git commit history
- [ ] `.gitignore` excludes `.env`, `.env.local`, `.env.*` files
- [ ] All secrets are managed through the environment variable system (`lib/env.ts` or equivalent)
- [ ] `lib/env.ts` uses Zod schema to validate all secrets at startup

### Authentication and Authorization Review
- [ ] Every route that modifies data verifies the session before any other operation
- [ ] Every route that reads user-specific data verifies resource ownership
- [ ] Session tokens are not transmitted in URL query parameters
- [ ] Password hashing uses a strong algorithm (bcrypt, argon2) if passwords are stored
- [ ] OAuth state parameter is validated (CSRF protection for OAuth flows)
- [ ] Token refresh logic is reviewed if applicable
- [ ] Role-based access control (RBAC) is implemented correctly if multiple roles exist

### Data Privacy Review (LGPD / GDPR)
- [ ] All personal data fields are identified in the schema
- [ ] Legal basis for processing each category of personal data is stated
- [ ] Data retention policy is defined and implemented (or explicitly deferred with justification)
- [ ] Users can access their own data (right of access)
- [ ] Users can request deletion of their data (right to erasure) — or the limitation is documented
- [ ] Personal data is not logged in plaintext in `audit_log` or `sync_log` (emails/names in metadata is acceptable; passwords, CPF, financial data is not)
- [ ] Data transfers outside Brazil/EU are documented if applicable

### Findings Summary
- [ ] All findings are numbered (`SEC-001`, `SEC-002`, ...)
- [ ] Each finding has: category, severity (Critical/High/Medium/Low/Informational), description, affected file/endpoint, recommended remediation
- [ ] Zero `Critical` findings open at submission
- [ ] Zero `High` findings open at submission
- [ ] All `Medium` findings have a resolution plan with an owner and deadline
- [ ] `Low` and `Informational` findings are logged and acknowledged

### Handoff Package
- [ ] `required_next_agent` set to `"Agente08_DevOps"`
- [ ] `gate_ready` set to `true`
- [ ] `owasp_pass_count`, `owasp_fail_count`, `owasp_na_count` populated
- [ ] `open_findings` list contains only `medium`, `low`, and `informational` items
- [ ] `dependency_scan_date` populated (within 7 days)
- [ ] `secrets_scan_clean` set to `true`

## Acceptance Criteria

| Criterion | How to verify |
|-----------|---------------|
| OWASP A01 passes | Read auth review section; confirm resource-level ownership check is confirmed in all mutation endpoints |
| OWASP A03 passes | Run `sql-safety-review-skill` or equivalent; confirm no raw SQL string concatenation |
| Zero critical CVEs in prod deps | Read dependency scan results; filter by `severity: critical` and `location: dependencies`; count must be zero |
| Secrets scan clean | Read secrets scan results; finding count must be zero |
| No critical or high findings open | Read findings summary; count of open critical and high findings must be zero |
| Threat model exists | File or section exists; contains at least one trust boundary and one documented threat with mitigation |
| Data privacy review complete | LGPD/GDPR section exists; all personal data fields are named |
| Dependency scan within 7 days | Check `dependency_scan_date`; must be within 7 calendar days of Gate 5 submission |

## Related Gates

- **Prerequisite:** Gate 4 approved (QA_Report.md must be approved before security audit)
- **This gate:** Gate 5 — Security Audit (evaluated by Agente07_DevSecOps; incontornavel — Tech Lead cannot override)
- **Unblocks:** Gate 6 — Deploy Review (Agente08_DevOps)

## Gate 5 Status Codes

| Code | Meaning |
|------|---------|
| `APPROVED` | All security criteria met; pipeline advances to Gate 6 |
| `BLOCKED_CRITICAL_VULNERABILITY` | Critical or high severity finding exists; implementation must fix before resubmission |
| `BLOCKED_SECRETS_EXPOSED` | Secrets found in codebase or git history; must be rotated and removed before resubmission |
| `RETURNED_FOR_REVISION` | Security gaps found that are not critical but require remediation |

**Note:** Gate 5 cannot be bypassed by the Tech Lead under any circumstances. `BLOCKED_CRITICAL_VULNERABILITY` and `BLOCKED_SECRETS_EXPOSED` statuses require remediation before the pipeline can advance. There are no exceptions.

## Failure Examples

- **FAIL:** A Route Handler reads a task by ID without checking `task.userId === session.user.id`. Any authenticated user can read any other user's task. This is an A01 violation.
- **FAIL:** The dependency scan shows `critical` CVE in `lodash` which is in `dependencies` (not devDependencies). Gate 5 is blocked.
- **FAIL:** `gitleaks` finds an AWS access key in a commit from 3 weeks ago. Even though the key has been rotated, the finding must be documented and the git history must be cleaned (or the risk accepted by the Tech Lead in writing).
- **FAIL:** `lib/env.ts` exists but `STRIPE_SECRET_KEY` is accessed as `process.env.STRIPE_SECRET_KEY` directly in `lib/integrations/stripe.client.ts`. This is both a missing Zod validation and a potential secret exposure if env is misconfigured.
- **FAIL:** The LGPD section says "we collect email addresses" but does not state the legal basis for processing or the retention policy.
- **FAIL:** The threat model was last run 30 days ago and the dependency scan was not re-run before Gate 5 submission. The scan is more than 7 days old.

## When to Block

Issue `BLOCKED_SECRETS_EXPOSED` immediately when any secret is found in source files or git history. Pipeline is frozen until secrets are rotated, history is cleaned or the risk is formally accepted, and the scan runs clean.

Issue `BLOCKED_CRITICAL_VULNERABILITY` when:
- Any OWASP A01–A10 category has a `FAIL` status
- Any `critical` or `high` CVE exists in production dependencies
- Any `Critical` or `High` finding remains open in the findings summary

Return `RETURNED_FOR_REVISION` when:
- The threat model is absent or has no documented mitigations for High/High threats
- The data privacy review is incomplete for a system that handles personal data
- The dependency scan is older than 7 days
- Any OWASP category is left blank without a `PASS` / `FAIL` / `N/A` status

Issue `APPROVED` only when every checkbox is checked, all OWASP categories have a passing or N/A status, zero critical/high findings remain open, the secrets scan is clean, and the dependency scan is current.
