# Rubric — DevSecOps Engineer (@devsecops / Agente07)

## Scoring Guide

0 = Absent or completely wrong — the dimension is not addressed or the answer is incorrect
1 = Partial — present but incomplete, missing key elements, or partially wrong
2 = Correct but missing nuance — technically accurate but lacks depth, specificity, or edge case handling
3 = Excellent — complete, accurate, contextually appropriate, and demonstrates mastery of the rule

---

## Dimensions

### 1. OWASP Top 10 Completeness
**Weight:** HIGH

**Score 3:** Review covers all OWASP Top 10 categories relevant to the submission. For web APIs: A01 (Broken Access Control — ownership checks), A02 (Cryptographic Failures — secrets in env, no plaintext passwords), A03 (Injection — SQL injection, prompt injection), A04 (Insecure Design — missing rate limiting), A05 (Security Misconfiguration — default creds, error messages), A07 (Identification and Authentication — session management). Cites the specific OWASP category for each finding. Does not invent OWASP categories that do not exist.

**Score 2:** Five or more OWASP categories checked. Each finding linked to an OWASP category. But one or two relevant categories skipped for the submission type (e.g., A03 not checked for an API with user-supplied query params).

**Score 1:** OWASP mentioned. Two or three categories checked. Findings present but not all linked to specific OWASP categories. Review is incomplete but shows awareness of the framework.

**Score 0:** OWASP not mentioned. Or "OWASP" appears in the response but no specific categories are cited. Or findings are not classified by OWASP at all.

---

### 2. Threat Model Quality
**Weight:** HIGH

**Score 3:** Produces a threat model that identifies: (a) trust boundaries (where the system boundary is, what is inside vs. outside), (b) attack surfaces (all entry points that accept external input), (c) specific threats per attack surface with STRIDE classification or equivalent, (d) mitigations in place and missing. Goes beyond listing vulnerabilities to model how an attacker would chain them.

**Score 2:** Trust boundaries and attack surfaces identified. Specific threats listed. But STRIDE or equivalent classification absent. Threat chaining not considered.

**Score 1:** Attack surfaces identified. Generic threats listed (e.g., "someone could guess the user ID"). No trust boundary analysis. No classification framework applied.

**Score 0:** No threat model. Or "threat model" section is a single paragraph with no structure.

---

### 3. Secrets Policy
**Weight:** HIGH

**Score 3:** Verifies that no secrets (API keys, database URLs, private keys, session secrets) are hardcoded in source code, committed to the repository, or logged. Verifies env var access goes through lib/env.ts (not scattered process.env). Verifies .env files are gitignored. Flags any exposure of secrets as CRITICAL with BLOCKED_CRITICAL_RISK gate decision.

**Score 2:** Secrets policy checked. Env var pattern verified. .gitignore reviewed. But does not check for secrets in log output or does not verify the lib/env.ts pattern specifically.

**Score 1:** Checks for hardcoded credentials in source code. Does not check log output, .gitignore, or the env access pattern.

**Score 0:** Secrets policy not evaluated. Or states "secrets look fine" without evidence of checking.

---

### 4. LGPD Compliance
**Weight:** MEDIUM

**Score 3:** Reviews PII handling against Brazilian LGPD requirements: personal data is minimized (only collected if needed), encrypted at rest for sensitive fields, access-logged in audit_log, not exposed in error messages or logs, and subject to data retention policy. Identifies any PII that is stored but lacks access control or logging. Notes LGPD article relevance where applicable.

**Score 2:** PII fields identified. Some LGPD checks performed (minimization, logging). But encryption-at-rest not verified, or data retention policy not reviewed.

**Score 1:** LGPD mentioned. Personal data fields noted. No specific LGPD article references. Compliance review is surface-level.

**Score 0:** LGPD not mentioned when PII is present in the system. Or incorrectly states the system has no PII when it clearly handles user data (names, emails, etc.).

---

### 5. Gate 5 Block Correctness
**Weight:** HIGH

**Score 3:** Issues BLOCKED_CRITICAL_RISK correctly for CRITICAL findings (auth bypass, SQL injection, exposed secrets, IDOR). Issues BLOCKED_QA_FAILURE for HIGH findings (missing rate limiting on auth endpoints, weak input validation). Issues RETURNED_FOR_REVISION for MEDIUM findings (missing security headers, overly verbose error messages). Issues APPROVED when no findings at CRITICAL or HIGH severity. Does not approve when CRITICAL findings are present.

**Score 2:** Block/approve decision is correct. Severity classification is correct. But status code is not the exact authorized code (e.g., "blocked due to critical issue" instead of "BLOCKED_CRITICAL_RISK").

**Score 1:** Block decision correct for CRITICAL findings. But MEDIUM findings treated as CRITICAL (over-blocking), or HIGH findings treated as LOW (under-blocking).

**Score 0:** Issues APPROVED when CRITICAL vulnerabilities are present. Or blocks Gate 5 for LOW severity findings only. Shows systematic miscalibration of severity.

---

## Aggregate Score Interpretation

**Maximum score:** 15 (5 dimensions x 3)

| Total Score | Interpretation |
|-------------|----------------|
| 14–15 | Excellent — security review is thorough and gate decision is defensible |
| 11–13 | Good — minor gaps; security posture is well-evaluated |
| 7–10 | Acceptable — one HIGH dimension has gaps; worth another review pass |
| 4–6 | Poor — fundamental security review gaps; pipeline should not advance |
| 0–3 | Failing — security review is not adequate; CRITICAL vulnerabilities may pass undetected |

**Critical failures (override the score):** A score of 0 on Gate 5 Block Correctness when a CRITICAL vulnerability is present is the most severe evaluator failure — the agent approved code with a known security hole. This should be flagged immediately and treated as a system-level failure requiring prompt revision. A score of 0 on Secrets Policy means credentials could be committed to source control undetected, which has irreversible consequences.
