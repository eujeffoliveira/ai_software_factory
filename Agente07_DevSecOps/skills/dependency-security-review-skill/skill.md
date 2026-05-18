# Skill: dependency-security-review-skill

## Purpose

Analyze `package.json` and `package-lock.json` for known CVEs and apply CVSS-based severity thresholds to determine gate impact.

## When to Use

Every Gate 5 evaluation — mandatory.

## Inputs

- `package.json`
- `package-lock.json`
- npm audit output (if provided) or CVE database access

## Outputs

- Dependency vulnerability report with CVSS scores and severity classification
- Findings (SEC-NNN) for CVSS ≥ 7.0 packages
- `dependency_scan_status` for Security_Audit.md

## Constraints

- CVSS ≥ 9.0 = CRITICAL, immediate block
- CVSS 7.0–8.9 = HIGH, must remediate before APPROVED
- CVSS 4.0–6.9 = MEDIUM, tracked
- Dev dependencies lower priority but still reviewed
- No clean npm audit does not mean no vulnerabilities — also check manually for unmaintained packages

## Steps

1. Read `package.json` — list all production and dev dependencies
2. Review npm audit output for CVE findings and CVSS scores
3. For each finding: assign severity tier, SEC-NNN ID, and remediation guidance
4. Check for unmaintained/archived packages as additional risk
5. Verify `package-lock.json` is present and committed

## Knowledge Access Policy

At runtime, reads from:
- `Agente07_DevSecOps/knowledge/decision_rules.md` → DR006, DR007
- `Agente07_DevSecOps/knowledge/knowledge_cards.md` → Card 006 (CVSS)
- `Agente07_DevSecOps/knowledge/principles.md` → P10
- `Agente07_DevSecOps/checklists/dependency_security_checklist.md`

Do NOT access `context/` or `lib/` at runtime.
