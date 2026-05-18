# Dependency Security Review Skill — Execution Checklist

## Runtime Knowledge Policy
Read `Agente07_DevSecOps/checklists/dependency_security_checklist.md` and `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 006 — CVSS) before executing. Do NOT access `context/` or `lib/`.

## Pre-execution
- [ ] package.json available and read
- [ ] package-lock.json presence verified
- [ ] npm audit output available or CVE lookup performed

## Vulnerability Assessment
- [ ] All production dependencies reviewed
- [ ] All dev dependencies reviewed
- [ ] CVSS scores assigned for each finding
- [ ] CVSS ≥ 9.0 → CRITICAL (DR006) → BLOCKED_CRITICAL_RISK
- [ ] CVSS 7.0–8.9 → HIGH (DR007) → must remediate before APPROVED
- [ ] CVSS 4.0–6.9 → MEDIUM → track
- [ ] Unmaintained/archived packages flagged

## Output
- [ ] status: CLEAN if no CVSS ≥ 7.0 unresolved in production deps
- [ ] status: CRITICAL_CVE_FOUND if CVSS ≥ 9.0 found
- [ ] status: HIGH_CVE_FOUND if CVSS 7.0–8.9 found (no CRITICAL)
- [ ] vulnerabilities array populated for all findings
- [ ] Each finding has: package, version, CVE, CVSS, severity, decision_rule, remediation
