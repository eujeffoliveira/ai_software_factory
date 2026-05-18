# Privacy Review Skill — Execution Checklist

## Runtime Knowledge Policy
Read `Agente07_DevSecOps/checklists/privacy_compliance_checklist.md` and `Agente07_DevSecOps/knowledge/principles.md` (P8) before executing. Do NOT access `context/` or `lib/`.

## Pre-execution
- [ ] data-classification-skill output received
- [ ] highest_data_tier known
- [ ] If RESTRICTED: issue BLOCKED_PENDING_HUMAN immediately — stop here

## Legal Basis
- [ ] Processing activity identified for each CONFIDENTIAL entity
- [ ] Legal basis type identified (CONSENT/CONTRACT/LEGAL_OBLIGATION/LEGITIMATE_INTEREST)
- [ ] Legal basis documented in PRD, ToS, or privacy notice (specific section cited)

## Data Minimization
- [ ] Zod input schema reviewed — only necessary fields included
- [ ] .strict() or equivalent used on PII-containing schemas
- [ ] No fields collected "just in case"

## Consent (if basis = CONSENT)
- [ ] Consent mechanism implemented and accessible
- [ ] Consent recorded in database with timestamp and version
- [ ] Consent withdrawal mechanism exists

## Deletion Support
- [ ] CASCADE DELETE configured in Prisma schema for user-owned tables
- [ ] Alternative: anonymization on deletion verified in code
- [ ] audit_log intentional retention documented in privacy notice

## Third-Party Sharing
- [ ] All third parties receiving CONFIDENTIAL data listed
- [ ] DPA in place for each (or explicitly N/A)

## Output
- [ ] Privacy_Assessment.md produced following template
- [ ] overall_status: COMPLIANT only if all checks pass
- [ ] findings array populated for any FAIL results
- [ ] human_escalation_required: true if RESTRICTED data found
