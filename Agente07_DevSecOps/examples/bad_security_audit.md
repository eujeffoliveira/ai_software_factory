# Bad Example — Security Audit Report

> This is an example of a POOR-QUALITY security audit. Notice all the problems: no OWASP table, no specific file references, vague findings, APPROVED despite CRITICAL issues, no remediation guidance. Do NOT produce audits like this.

---

# Security Audit Report

## Gate 5 Decision: APPROVED

**Project:** Task Management App
**Feature/PR:** Profile update feature
**Audit Date:** 2026-05-17
**Audited by:** Agente07_DevSecOps

---

## Summary

Reviewed the code and security looks fine. The feature follows standard patterns and we didn't find any major issues. The code is clean and follows the project's architecture. Team is experienced and has been careful.

---

## Security Review

We checked the main files and everything seems in order. The authentication uses NextAuth which is a well-known library so it should be secure. The database uses Prisma which handles SQL injection automatically.

**General findings:**
- Code quality is good
- Auth seems to be in place
- No obvious security issues

---

## Approval

Based on the review, this feature is APPROVED for deployment.

---

> ## WHY THIS IS WRONG — ANNOTATED PROBLEMS

> **Problem 1: No OWASP table.**
> A compliant audit requires all 10 OWASP categories with PASS/FAIL and evidence. This audit has none. Unknown categories are not passed categories.

> **Problem 2: APPROVED despite CRITICAL finding not investigated.**
> The audit never checked `features/user-profile/actions/update-profile.action.ts` where the actual vulnerability exists: `const { userId } = await request.json()` (takes userId from request body — CRITICAL per DR011). "Auth seems to be in place" is not evidence.

> **Problem 3: No specific file paths or line numbers.**
> Every finding must reference the exact file and line. "Reviewed the main files" tells the reader nothing about what was actually reviewed.

> **Problem 4: "Prisma handles SQL injection automatically" is an assumption.**
> This may be true for standard Prisma calls but is false for `$queryRawUnsafe`. The audit should verify which call pattern is in use, not assume.

> **Problem 5: No secrets scan performed.**
> The audit makes no mention of scanning for hardcoded secrets. In this case, `features/user-profile/services/profile.service.ts` has `const PROFILE_SERVICE_KEY = "sk-prod-abc123xyz789..."` hardcoded — a CRITICAL finding that would be `BLOCKED_SECRET_EXPOSED`.

> **Problem 6: No dependency scan.**
> npm audit not mentioned. `xml2js@0.4.19` in package.json has CVSS 7.5 — a HIGH finding requiring remediation before APPROVED.

> **Problem 7: No privacy assessment.**
> The feature handles `User.email` and `User.displayName` (CONFIDENTIAL tier). No data classification performed. No privacy compliance check.

> **Problem 8: No threat model check.**
> Feature involves auth and user data — Threat_Model.md should be verified. Not mentioned.

> **Problem 9: Approval issued without evidence.**
> "Security looks fine" is not a valid gate decision rationale. Every APPROVED must cite: specific evidence for each OWASP category, specific file paths reviewed, secrets scan status, dependency scan results.

> **Problem 10: Missing escalation.**
> The hardcoded secret (sk-prod-abc123xyz789) found in the service file requires immediate escalation to Tech Lead for secret rotation. The CRITICAL finding was missed entirely.

> **Correct outcome:** This feature should have received `BLOCKED_SECRET_EXPOSED` (for the hardcoded API key) with immediate escalation, and a `Remediation_Guide.md` detailing: remove the hardcoded key, add to lib/env.ts, rotate the exposed key in the provider console.
