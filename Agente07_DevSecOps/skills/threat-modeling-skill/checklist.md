# Threat Modeling Skill — Execution Checklist

## Runtime Knowledge Policy
Read `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 001 — STRIDE) and `Agente07_DevSecOps/knowledge/decision_rules.md` (DR009) before executing. Do NOT access `context/` or `lib/`.

## Pre-execution
- [ ] Feature name and scope identified
- [ ] Architecture.md, API_Contract.json, and prisma/schema.prisma are available
- [ ] Implementation files are available for mitigation verification

## Trust Boundaries
- [ ] All trust boundary crossings identified (browser→server, server→DB, external APIs, cron)
- [ ] Each boundary documented with: what crosses it, validation required

## Assets
- [ ] All data entities listed
- [ ] Each entity classified (PUBLIC/INTERNAL/CONFIDENTIAL/RESTRICTED)
- [ ] Why each asset is worth protecting is documented

## STRIDE Coverage — all 6 categories must be checked
- [ ] Spoofing — auth bypass, session forgery threats documented
- [ ] Tampering — injection, input manipulation threats documented
- [ ] Repudiation — missing audit log threats documented
- [ ] Information Disclosure — IDOR, PII leakage, stack trace threats documented
- [ ] Denial of Service — unbounded queries, large payloads threats documented
- [ ] Elevation of Privilege — IDOR, userId from request, role escalation threats documented

## For Each Threat
- [ ] Specific attack vector identified (not just category)
- [ ] Specific component targeted named
- [ ] Likelihood assessed (LOW/MEDIUM/HIGH)
- [ ] Impact assessed (LOW/MEDIUM/HIGH/CRITICAL)
- [ ] Mitigation references actual code (file path or function)
- [ ] Mitigation status is IMPLEMENTED/PARTIAL/MISSING (not assumed)

## Open Threats
- [ ] All MISSING mitigations listed as open threats
- [ ] Each open threat has a disposition (ACCEPTED/ESCALATED/DEFERRED/PLANNED)
- [ ] CRITICAL/HIGH open threats escalated to Tech Lead

## Output
- [ ] Threat_Model.md produced following templates/Threat_Model.md
- [ ] findings_for_gate_5 populated for MISSING HIGH/CRITICAL mitigations
- [ ] stride_coverage_complete: true only if all 6 categories have at least one analyzed threat
