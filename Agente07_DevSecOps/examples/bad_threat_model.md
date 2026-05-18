# Bad Example — Threat Model

> This is an example of a POOR-QUALITY threat model. Notice: incomplete STRIDE coverage, vague threats, no mitigations, no trust boundaries, no assets. Do NOT accept or produce threat models like this.

---

# Threat Model

## Feature: Task Management
## Date: 2026-05-17

---

## System Overview

This feature lets users manage their tasks. It's a standard CRUD feature using Next.js and Prisma.

---

## Threats

### Spoofing
- Someone might pretend to be another user

### Information Disclosure
- Data might be leaked somehow

---

## Security Notes

- We use NextAuth so authentication is handled
- Prisma protects against SQL injection
- The code follows best practices

---

> ## WHY THIS IS WRONG — ANNOTATED PROBLEMS

> **Problem 1: Only 2 of 6 STRIDE categories covered.**
> Tampering, Repudiation, Denial of Service, and Elevation of Privilege are completely missing. DR009 requires all six categories. A threat model missing four categories blocks Gate 5.

> **Problem 2: "Someone might pretend to be another user" is not a threat analysis.**
> A valid threat specifies: the threat ID, the specific attack vector, the component it targets, likelihood, impact, mitigation, and mitigation status. "Someone might pretend to be another user" is a threat category, not an analyzed threat.

> **Problem 3: No trust boundaries defined.**
> Trust boundaries are the most important structural element of a threat model — they identify where data crosses from untrusted to trusted domains and what validation is needed at each crossing. Absence of trust boundaries means the threat analysis has no structural basis.

> **Problem 4: No assets identified.**
> Without knowing what is being protected, threats cannot be properly assessed for impact. What data is at risk? What functionality could be abused? Not specified.

> **Problem 5: "We use NextAuth so authentication is handled" is a false mitigation.**
> Using NextAuth does not mean authentication is handled. NextAuth provides the framework; the developer must call `await auth()` in every Server Action and Route Handler. The threat model should verify this is done, not assume it because a library is installed.

> **Problem 6: "Prisma protects against SQL injection" is partially false.**
> Prisma's standard API is parameterized. But `$queryRawUnsafe` is not. The mitigation should verify which patterns are used, not assert that the library handles everything.

> **Problem 7: No specific mitigations with code patterns.**
> A threat model mitigation should reference the specific code that implements the mitigation (file path, function name, pattern). "The code follows best practices" is not a mitigation — it is an assertion without evidence.

> **Problem 8: No IDOR threat analyzed.**
> IDOR (Insecure Direct Object Reference) is the most common access control vulnerability in CRUD features. It should appear under Elevation of Privilege (attacker accesses another user's tasks) and Information Disclosure (attacker reads another user's data). Both are missing.

> **Problem 9: No repudiation threats.**
> A task creation/deletion feature has obvious repudiation threats: "I didn't delete that task." Without audit_log coverage verified in the threat model, there is no assurance that sensitive operations are logged.

> **Correct outcome:** This threat model should be rejected as INCOMPLETE. `threat-modeling-skill` should produce a proper threat model before Gate 5 evaluation continues. Gate 5 is blocked (BLOCKED_CRITICAL_RISK — missing threat model for auth/data feature) until a complete STRIDE analysis is produced.
