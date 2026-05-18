# Security Audit Report Skill — Execution Checklist

## Runtime Knowledge Policy
Read `Agente07_DevSecOps/quality_gate.md` (exit criteria, status codes) and `Agente07_DevSecOps/knowledge/decision_rules.md` (DR013) before executing. Do NOT access `context/` or `lib/`.

## Pre-aggregation
- [ ] All parallel skills completed (secrets, authz, dependency, logging, owasp)
- [ ] threat-modeling-skill completed (if required)
- [ ] privacy-review-skill completed (if CONFIDENTIAL/RESTRICTED data)
- [ ] data-classification-skill completed

## Finding Aggregation
- [ ] All findings from all skills collected into unified list
- [ ] Findings classified into CRITICAL/HIGH/MEDIUM/LOW buckets
- [ ] No findings lost in aggregation (total should equal sum from all skills)

## Gate Status Determination
- [ ] If any CRITICAL: gate is blocked (determine specific code by priority)
- [ ] If no CRITICAL but unresolved HIGH: gate is blocked
- [ ] If only MEDIUM/LOW: RETURNED_FOR_REVISION or APPROVED based on other criteria
- [ ] Priority order applied: BLOCKED_SECRET_EXPOSED = BLOCKED_AUTH_BYPASS > BLOCKED_CRITICAL_RISK > BLOCKED_PRIVACY_VIOLATION > BLOCKED_PENDING_HUMAN > RETURNED_FOR_REVISION

## OWASP Table
- [ ] Exactly 10 rows present
- [ ] Every category has evidence notes
- [ ] Every FAIL has finding_id reference

## Security_Audit.md
- [ ] All mandatory sections present (per template)
- [ ] Gate decision is from authorized list
- [ ] Executive summary is 1-2 sentences with specific rationale
- [ ] Secrets scan section complete
- [ ] Auth/authz review section complete
- [ ] Privacy assessment summary complete
- [ ] Threat model status complete
- [ ] Dependency review section complete
- [ ] Gate 5 sign-off checklist completed

## Handoff Package
- [ ] gate_decision matches Security_Audit.md
- [ ] gate_ready: true ONLY if gate_decision is APPROVED
- [ ] required_next_agent: Agente08_DevOps (if APPROVED) or Dev agent (if BLOCKED)
- [ ] Follows handoff_schema.json structure

## Post-report
- [ ] If BLOCKED or RETURNED: remediation_guide_required: true
- [ ] If CRITICAL: escalation to Tech Lead confirmed
