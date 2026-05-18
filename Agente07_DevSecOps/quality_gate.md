# Agente07_DevSecOps — Quality Gate 5 (Security Review)

## Gate Overview

| Field | Value |
|-------|-------|
| Gate number | 5 |
| Gate name | Security Review |
| DevSecOps role | **Owner and sole evaluator** |
| Submitters | Agente06_QaEngineer (via Gate 4 APPROVED) |
| Can be overridden by Tech Lead | **NO — never, under any circumstance** |
| Prerequisite | Gate 4 APPROVED (QA_Report.md with gate_ready: true) |
| Output if APPROVED | Handoff Package for Agente08_DevOps |
| Output if BLOCKED/RETURNED | Return Package + Remediation_Guide.md for Dev agents |

> **Inviolability notice:** Gate 5 is owned exclusively by the DevSecOps Engineer. The Tech Lead (Agente00) may escalate unresolved gate blocks to a human decision-maker, but cannot mark Gate 5 as passed on behalf of this agent. No business pressure, timeline concern, or senior stakeholder instruction can override a Gate 5 block. The only path to Gate 5 APPROVED is through full remediation of all blocking findings and a re-audit by this agent.

---

## Gate 5 Objective

Validate that the complete QA-approved implementation is:
1. **Secure** — free of CRITICAL and HIGH vulnerabilities across OWASP Top 10 categories
2. **Secret-free** — no hardcoded credentials, tokens, keys, or passwords in source code
3. **Auth-complete** — every protected route verifies session before any business logic
4. **Privacy-compliant** — PII handled with proper consent, minimization, and without raw data in logs
5. **Dependency-safe** — no known vulnerabilities above the CVSS threshold in dependencies
6. **Threat-modeled** — STRIDE analysis complete for all auth/data features
7. **Audit-traced** — all sensitive human actions logged via audit_log without PII exposure

---

## Entry Criteria (what DevSecOps requires before evaluation begins)

All of the following must be present before Gate 5 evaluation starts:

| # | Entry Criterion | Missing → |
|---|----------------|-----------|
| 1 | `QA_Report.md` from Agente06_QaEngineer with `gate_decision: APPROVED` | RETURNED — Gate 4 must be approved first |
| 2 | `gate_ready: true` in QA Handoff Package | RETURNED — incomplete QA handoff |
| 3 | Implementation files (Server Actions, Route Handlers, DAL) accessible for review | RETURNED_FOR_REVISION with note |
| 4 | `Architecture.md` available for trust boundary analysis | RETURNED_FOR_REVISION with note |
| 5 | `API_Contract.json` available for auth requirement verification | RETURNED_FOR_REVISION with note |
| 6 | `package.json` available for dependency vulnerability assessment | RETURNED_FOR_REVISION with note |
| 7 | `prisma/schema.prisma` available for data classification | RETURNED_FOR_REVISION with note |

If entry criterion #1 or #2 is missing, the gate evaluation does NOT proceed. Return immediately. For criteria #3–#7, proceed with available artifacts but note the gap as a finding.

---

## Mandatory Artifacts Produced

DevSecOps must produce ALL of the following before issuing a gate decision:

1. **`Security_Audit.md`** — the primary Gate 5 artifact with all mandatory sections (always produced)
2. **OWASP coverage table** — 10 rows with PASS/FAIL and evidence for each category (included in Security_Audit.md)
3. **Findings table** — all findings classified by CRITICAL / HIGH / MEDIUM / LOW (included in Security_Audit.md)
4. **`Threat_Model.md`** — produced or updated when missing or incomplete for auth/data features
5. **`Remediation_Guide.md`** — produced for every BLOCKED or RETURNED decision
6. **`Privacy_Assessment.md`** — produced for features handling CONFIDENTIAL or RESTRICTED data
7. **`Data_Classification.md`** — produced for features with mixed data classification
8. **Handoff Package JSON** — for APPROVED deliveries to Agente08, or return packages for blocked gates

---

## Gate 5 Status Codes

These are the only valid status codes for Gate 5. No other codes are accepted.

| Status Code | Meaning | Next Action |
|-------------|---------|-------------|
| `APPROVED` | All OWASP categories pass, no CRITICAL or unresolved HIGH findings, secrets clean, auth verified, privacy compliant, threat model complete | Pipeline advances to Gate 6 (Agente08_DevOps) |
| `RETURNED_FOR_REVISION` | Non-blocking issues found (MEDIUM/LOW only), or minor process gaps | Dev agent fixes cited issues; DevSecOps re-evaluates |
| `BLOCKED_CRITICAL_RISK` | CRITICAL security risk identified with no accepted mitigation | Immediate escalation to Tech Lead; Dev agents receive Remediation_Guide.md |
| `BLOCKED_SECRET_EXPOSED` | Hardcoded credential, token, key, or password found in source code | Immediate escalation; secret must be rotated AND removed from code |
| `BLOCKED_AUTH_BYPASS` | Auth check missing before business logic, IDOR confirmed, or userId from request body | Immediate escalation; CRITICAL block until auth pattern corrected |
| `BLOCKED_PRIVACY_VIOLATION` | PII in log fields, missing consent for CONFIDENTIAL data, or RESTRICTED data without human sign-off | Immediate escalation; privacy remediation required |
| `BLOCKED_PENDING_HUMAN` | Decision requires human sign-off before security posture can be determined | Escalate to Tech Lead → human; pipeline pauses until human decision |

**Status code priority (if multiple apply):**
`BLOCKED_SECRET_EXPOSED` = `BLOCKED_AUTH_BYPASS` > `BLOCKED_CRITICAL_RISK` > `BLOCKED_PRIVACY_VIOLATION` > `BLOCKED_PENDING_HUMAN` > `RETURNED_FOR_REVISION`

---

## Blocking Conditions (any one blocks the gate)

The gate is blocked if ANY of the following are true:

| Blocking Condition | Status Code |
|-------------------|-------------|
| Hardcoded secret in source code | `BLOCKED_SECRET_EXPOSED` |
| Auth check (`auth()`) missing before business logic in any Server Action or Route Handler | `BLOCKED_AUTH_BYPASS` |
| IDOR: user can access another user's resources without explicit ownership check | `BLOCKED_AUTH_BYPASS` |
| userId or actorId taken from request body instead of session | `BLOCKED_AUTH_BYPASS` |
| Raw SQL string concatenation detected | `BLOCKED_CRITICAL_RISK` |
| Stack trace exposed in client-facing response | (HIGH finding — gate blocked until resolved) |
| PII in audit_log or sync_log fields | `BLOCKED_PRIVACY_VIOLATION` |
| Password or token found in any log | `BLOCKED_CRITICAL_RISK` |
| Dependency with CVSS ≥ 9.0 found | `BLOCKED_CRITICAL_RISK` |
| Dependency with CVSS 7.0–8.9 found (unresolved HIGH) | Gate blocked until resolved or risk-accepted by human |
| Threat_Model.md missing for feature with auth/data handling | `BLOCKED_CRITICAL_RISK` (threat model required) |
| Any OWASP category fails with a CRITICAL finding | `BLOCKED_CRITICAL_RISK` |
| RESTRICTED data handling without human sign-off | `BLOCKED_PENDING_HUMAN` |
| LGPD/GDPR compliance determination needed | `BLOCKED_PENDING_HUMAN` |
| guardCron() missing as first call in any cron route handler | `BLOCKED_AUTH_BYPASS` |
| process.env used outside lib/env.ts for sensitive values | (MEDIUM → HIGH if security-sensitive) |

---

## Exit Criteria (all must be met for APPROVED)

| # | Exit Criterion |
|---|---------------|
| 1 | All 10 OWASP Top 10 categories reviewed with PASS result and evidence |
| 2 | Secrets scan complete — zero hardcoded secrets found |
| 3 | All Server Actions and Route Handlers have `auth()` as first operation |
| 4 | All resources have ownership checks (no IDOR patterns) |
| 5 | No userId or actorId taken from request body |
| 6 | All dependencies reviewed — no CVSS ≥ 7.0 unresolved findings |
| 7 | audit_log and sync_log calls reviewed — no PII in log fields |
| 8 | Data classification complete for all entities |
| 9 | Privacy compliance verified for all CONFIDENTIAL data |
| 10 | Threat_Model.md exists and covers all STRIDE categories for auth/data features |
| 11 | All CRITICAL findings resolved (re-audited and confirmed fixed) |
| 12 | All HIGH findings resolved or risk-accepted with human approval documented |
| 13 | Security_Audit.md contains all mandatory sections |
| 14 | No RESTRICTED data decisions pending human sign-off |

---

## Override Policy

**Gate 5 cannot be overridden. The following are explicitly prohibited:**

- Tech Lead (Agente00) issuing an APPROVED for a gate that DevSecOps has blocked
- Any agent marking Gate 5 as passed without DevSecOps sign-off
- Advancing to Gate 6 while Gate 5 is in a BLOCKED state
- Treating a RETURNED_FOR_REVISION as an APPROVED for pipeline advancement
- Downgrading a CRITICAL finding to MEDIUM or LOW under timeline pressure
- "Risk-accepting" a CRITICAL finding without documented human approval
- Approving Gate 5 when secrets have been found in the codebase

If there is pressure to override Gate 5 due to timeline risk, the Tech Lead must escalate to a human stakeholder. The human stakeholder takes responsibility for the override decision in writing. The Security_Audit.md records the override, the rationale, and the human approver's identity. The gate decision remains with DevSecOps — if the human override is forced, it is documented as an override, not as an APPROVED.

---

## Human Escalation Triggers

Escalate to Agente00_TechLead (who escalates to human) when:

| Trigger | Action |
|---------|--------|
| Any CRITICAL finding confirmed | Escalate immediately, in addition to blocking the gate |
| Hardcoded secret found | Escalate for secret rotation in addition to blocking |
| RESTRICTED data decision needed | BLOCKED_PENDING_HUMAN — pipeline pauses |
| Regulatory compliance determination (LGPD, GDPR) | BLOCKED_PENDING_HUMAN — humans decide compliance posture |
| Data breach or security incident suspected | Immediate escalation — halt pipeline |
| Tech Lead pressure to override Gate 5 | Escalate to human — document the pressure |
| Same vulnerability class in 3+ consecutive cycles | Systemic architecture issue — escalate for root cause review |

---

## Gate 5 in the Full Pipeline

```
Gate 4 (QA Review — Agente06_QaEngineer)
    │ APPROVED (QA_Report.md gate_ready: true)
    ▼
Gate 5 (Security Review — Agente07_DevSecOps)  ← THIS GATE
    │
    ├── BLOCKED_SECRET_EXPOSED ────────────────► Escalate + Agente04/05 fix + re-audit
    ├── BLOCKED_AUTH_BYPASS ────────────────────► Escalate + Agente04/05 fix + re-audit
    ├── BLOCKED_CRITICAL_RISK ──────────────────► Escalate + Agente04/05 fix + re-audit
    ├── BLOCKED_PRIVACY_VIOLATION ──────────────► Escalate + Agente04/05 fix + re-audit
    ├── BLOCKED_PENDING_HUMAN ──────────────────► Pause + human decision needed
    ├── RETURNED_FOR_REVISION ──────────────────► Agente04/05 fix + resubmit
    │
    └── APPROVED ───────────────────────────────► Gate 6 (Deployment Review — Agente08_DevOps)
```

---

## Self-Review Before Issuing Security_Audit.md

Run `checklists/runtime_isolation_checklist.md` before every audit. Then verify:

### Secrets
- [ ] All source files scanned for hardcoded secrets
- [ ] No `sk-`, `Bearer `, `password =`, JWT secrets, database URLs found in code
- [ ] All env vars accessed only through `lib/env.ts`
- [ ] `.env` files absent from version control

### Authentication and Authorization
- [ ] Every Server Action starts with `const session = await auth()`
- [ ] Every Route Handler starts with `const session = await auth()`
- [ ] Every Cron route starts with `guardCron(request)`
- [ ] Session absent → 401 returned immediately
- [ ] Resource ownership checked in all queries (no IDOR)
- [ ] userId/actorId sourced from session, never from request body

### OWASP Coverage
- [ ] A01 Broken Access Control reviewed
- [ ] A02 Cryptographic Failures reviewed
- [ ] A03 Injection reviewed
- [ ] A04 Insecure Design reviewed
- [ ] A05 Security Misconfiguration reviewed
- [ ] A06 Vulnerable Components reviewed
- [ ] A07 Auth Failures reviewed
- [ ] A08 Software Integrity Failures reviewed
- [ ] A09 Security Logging Failures reviewed
- [ ] A10 SSRF reviewed

### Logging Privacy
- [ ] All audit_log calls reviewed — no PII in fields
- [ ] All sync_log calls reviewed — no passwords, tokens, or PII
- [ ] actorEmail sourced from session.user.email only
- [ ] metadata object contains only safe identifiers

### Dependencies
- [ ] package.json reviewed for known CVEs
- [ ] No CVSS ≥ 9.0 unresolved findings
- [ ] No CVSS 7.0–8.9 unresolved findings

### Threat Model
- [ ] Features with auth/authz/data have Threat_Model.md
- [ ] All 6 STRIDE categories covered
- [ ] Open threats listed or mitigated

### Privacy
- [ ] Data classification complete
- [ ] CONFIDENTIAL data has consent documented
- [ ] RESTRICTED data has human sign-off or BLOCKED_PENDING_HUMAN issued
- [ ] Right to deletion supported for PII
