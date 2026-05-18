# Skill: security-audit-report-skill

## Purpose

Aggregate all findings from parallel security skills and produce `Security_Audit.md` with the Gate 5 decision. This is always the final skill in every Gate 5 evaluation.

## When to Use

Always — the last step in every Gate 5 evaluation, after all other skills have completed.

## Inputs

- Results from all parallel skills: secret-scanning, authz-review, dependency-security-review, logging-privacy-review, owasp-review
- Results from: threat-modeling-skill, privacy-review-skill, data-classification-skill
- All findings (SEC-NNN) from all skills

## Outputs

- `Security_Audit.md` — the primary Gate 5 decision artifact
- Handoff Package JSON with `gate_decision` and `gate_ready` fields
- If BLOCKED/RETURNED: triggers `secure-code-remediation-skill`

## Constraints

- Gate status code must be from the authorized list in `quality_gate.md`
- Status code priority: BLOCKED_SECRET_EXPOSED = BLOCKED_AUTH_BYPASS > BLOCKED_CRITICAL_RISK > BLOCKED_PRIVACY_VIOLATION > BLOCKED_PENDING_HUMAN > RETURNED_FOR_REVISION
- APPROVED requires ALL exit criteria met (see `quality_gate.md`)
- Never issue APPROVED with unresolved CRITICAL or HIGH findings

## Steps

1. Aggregate all findings from all skills into CRITICAL/HIGH/MEDIUM/LOW buckets
2. Determine the appropriate gate status code based on findings and priority rules
3. Build the OWASP coverage table (10 rows, all with evidence)
4. Write the executive summary (1-2 sentences)
5. Produce `Security_Audit.md` following `templates/Security_Audit.md`
6. Produce Handoff Package JSON with correct schema
7. If BLOCKED or RETURNED: signal `secure-code-remediation-skill` to run

## Knowledge Access Policy

At runtime, reads from:
- `Agente07_DevSecOps/quality_gate.md` — gate status codes and exit criteria
- `Agente07_DevSecOps/handoff_schema.json` — Handoff Package structure
- `Agente07_DevSecOps/templates/Security_Audit.md`
- `Agente07_DevSecOps/schemas/security_audit.schema.json`
- `Agente07_DevSecOps/knowledge/decision_rules.md` → DR013 (APPROVED conditions)

Do NOT access `context/` or `lib/` at runtime.
