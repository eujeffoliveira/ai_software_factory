# Agente07_DevSecOps — Decision Heuristics

> Fast decision shortcuts derived from patterns observed in security reviews. Use these when encountering ambiguous situations. When a heuristic conflicts with a decision rule (DR), the decision rule takes precedence.

---

## H1 — "Auth Check Last" Is Always a Bug

If `auth()` appears anywhere other than the absolute first operation in a Server Action or Route Handler, it is a bug — regardless of what the developer comments say. The comment "auth is checked above" in a called function does not count. Each function must independently verify auth.

**Quick test:** Scroll to the top of the function body. Is `const session = await auth()` the first line? If not, flag it.

---

## H2 — If the Input Can Contain a User ID, It Shouldn't

Server Actions and Route Handlers should never accept `userId`, `ownerId`, `actorId`, or any identity field in their input. If you see these in a Zod input schema, the developer is trusting the client to report its own identity. Remove them from the schema and source from `session.user.id` instead.

**Quick test:** Open the Zod schema for the action's input. Does it have any field that ends in `Id` that represents a user identity? Flag it as CRITICAL.

---

## H3 — A Prisma Query Without `userId` in the `where` Clause Is Suspicious

When a Prisma query fetches user-owned data by record ID alone (`{ where: { id: recordId } }`), ask: is this an admin operation with documented privilege, or is this IDOR? The absence of `userId: session.user.id` in the where clause is the tell. The burden of proof is on the developer to show why ownership is not required.

**Quick test:** Find every `prisma.*.findUnique` and `prisma.*.findFirst` call. Is `userId: session.user.id` in the `where` clause? If not, why not?

---

## H4 — String Literals That Look Like Secrets Should Be Flagged Immediately

Strings matching patterns like `sk-`, `xai-`, `Bearer `, `postgres://`, `mysql://`, `ghp_`, `glpat-`, or strings that are 32+ random-looking characters in a source file are presumed secrets until proven otherwise. The proof is that the string is clearly a placeholder or mock value (e.g., `"<YOUR_API_KEY>"` or `"test-value"`).

**Quick test:** Scan for quote-enclosed strings longer than 20 characters that contain a mix of letters, numbers, and symbols. Any match should be inspected closely.

---

## H5 — `process.env` Outside `lib/env.ts` Is a Finding

Every `process.env` access outside of `lib/env.ts` is at minimum a MEDIUM finding. If the accessed variable is security-sensitive (API keys, secrets, database URLs), it is HIGH. There is no exception to routing env vars through `lib/env.ts`.

**Quick test:** Search for `process.env.` in the codebase excluding `lib/env.ts`. Any matches are findings.

---

## H6 — `catch (error) { return { error: error.message } }` Is Always Wrong

Returning `error.message` exposes internal system information. Even if `error.message` seems benign in local testing, in production it can expose database error messages (with table names, column names, query structure), file paths, library version strings, or other sensitive internals.

**Quick test:** Search for `error.message` in route handlers and Server Actions. If it appears in a return value, it is a HIGH finding.

---

## H7 — `metadata:` Fields in audit_log Are a Privacy Risk Until Proven Safe

The `metadata` JSON field in `audit_log` is often used as a catch-all for "extra data." Developers sometimes include raw user input, form field values, or full request bodies in `metadata`. Each key-value pair in `metadata` must be individually justified as non-PII.

**Quick test:** Find every `audit_log.create()` call. Inspect the `metadata` object. Is each value a safe identifier (ID, action name, entity type) or could it contain user-provided text or PII?

---

## H8 — Dependencies Updated Less Than 6 Months Ago Are Lower Risk, Older Are Higher Risk

When evaluating dependencies without a full CVE lookup, age is a rough proxy for risk. A dependency last updated 3 years ago has had 3 years to accumulate CVEs. A recently updated dependency (last 6 months) has likely had known CVEs patched. This is a triage heuristic — always do the actual CVE lookup for HIGH and CRITICAL candidates.

**Quick test:** For packages where a CVE scan is not possible, flag packages in `package.json` that have major version numbers significantly behind the current stable version.

---

## H9 — "It's Only for Internal Use" Does Not Reduce Security Requirements

Developers sometimes argue that a route "is only accessible internally" or "only called from a cron job" as justification for missing auth checks. This reasoning is flawed: (a) internal routes are accessible from the network unless explicitly firewall-blocked, (b) an attacker who bypasses other defenses can reach "internal" routes, (c) the security perimeter assumption has historically failed.

**Applied rule:** Apply the same auth/authz requirements to all routes regardless of their stated audience. The only exception is if a route is actually not reachable via HTTP at all (a pure server-side function never exposed as a route).

---

## H10 — OWASP A01 (Broken Access Control) Is Where Most Real Vulnerabilities Live

In practice, A01 accounts for the highest percentage of real-world vulnerabilities. When time-pressured, if forced to prioritize, focus the most scrutiny on: missing auth checks, IDOR patterns, userId from request body, and resource-level authorization gaps. These are the findings that cause actual data breaches.

**Applied rule:** Never abbreviate the A01 review. The other OWASP categories can have shorter evidence notes if there are genuinely no applicable patterns. A01 requires thorough examination of every protected route.

---

## H11 — A Clean `npm audit` Is Necessary but Not Sufficient

`npm audit` checks for CVEs in the npm advisory database. It may miss: CVEs not yet in the npm database, vulnerabilities in packages not sourced from npm, configuration-level vulnerabilities, and logical vulnerabilities in business logic. Use `npm audit` as one data point in the dependency review, not the complete answer.

**Applied rule:** Supplement `npm audit` with a review of: (a) packages with large, complex codebases that have historically had CVEs, (b) packages that are no longer maintained (archived repo), (c) packages with unusual permission requests.

---

## H12 — Sensitive Operations Without `audit_log` Are a Repudiation Gap

Any action that: creates or modifies user data, changes access permissions, initiates a financial or regulated transaction, or deletes records — must have an `audit_log` entry. The absence of logging for these operations means an actor can perform them without a tamper-evident record.

**Applied rule:** Create a list of all sensitive operations in the reviewed feature. For each, verify there is an `audit_log` call. Missing logging for sensitive operations = MEDIUM finding. Missing logging for RESTRICTED data operations = HIGH finding.

---

## H13 — STRIDE's Repudiation and DoS Categories Are Usually Under-Analyzed

In practice, threat models tend to be thorough on Spoofing and Information Disclosure but thin on Repudiation and Denial of Service. When reviewing or producing a threat model:
- **Repudiation**: Every sensitive write operation is a repudiation threat. Is there logging? Is the log tamper-evident?
- **DoS**: Every external input is a potential DoS vector. Are there size limits on payloads? Are database queries bounded? Is there rate limiting?

**Applied rule:** When the Repudiation or DoS sections of a threat model say "N/A" or are empty, treat this as incomplete analysis, not as "these categories don't apply."

---

## H14 — Privacy Review Scope Is Determined by the Highest Classification Tier Found

If even one RESTRICTED data entity is involved in the feature, the entire privacy review operates at RESTRICTED tier requirements. You cannot have a feature that is "mostly INTERNAL" with a "tiny bit of RESTRICTED" — the highest tier controls the review.

**Applied rule:** Run `data-classification-skill` before `privacy-review-skill`. If any RESTRICTED entity is found, trigger `BLOCKED_PENDING_HUMAN` immediately and escalate — even if the code looks otherwise clean.

---

## H15 — Re-Audit After Fixes Must Cover All Affected Areas, Not Just Fixed Lines

When reviewing a resubmission after a BLOCKED gate, do not limit the re-audit to only the lines that were changed. Developers sometimes fix the reported issue in one place while the same pattern exists in adjacent code. Re-run all skills that found issues in the previous cycle, and verify the pattern is eliminated system-wide, not just in the cited location.

**Applied rule:** On every resubmission, check the finding in DR015 — if the same vulnerability was found in 3+ places in the previous cycle, flag for architecture review even if all instances are now fixed. The systemic pattern needs to be addressed at the process level.
