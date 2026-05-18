# Skill: privacy-review-skill

## Purpose

Assess privacy compliance for features handling CONFIDENTIAL or RESTRICTED data. Evaluates legal basis, data minimization, consent, deletion support, third-party sharing, and data subject rights. Produces `Privacy_Assessment.md`.

## When to Use

- After `data-classification-skill` identifies CONFIDENTIAL or RESTRICTED data
- Whenever a feature collects, stores, or processes user PII
- Whenever third-party data sharing is involved
- Whenever LGPD/GDPR obligations may apply

## Inputs

- Data classification results from `data-classification-skill`
- `prisma/schema.prisma` — for cascade delete verification
- PRD — for legal basis and consent documentation references
- Implementation files — for consent mechanism verification
- Logging audit results from `logging-privacy-review-skill`

## Outputs

- `Privacy_Assessment.md` following `templates/Privacy_Assessment.md`
- Findings for Gate 5 (SEC-NNN with BLOCKED_PRIVACY_VIOLATION or BLOCKED_PENDING_HUMAN)

## Constraints

- RESTRICTED data → `BLOCKED_PENDING_HUMAN` immediately — do not assess compliance unilaterally
- COMPLIANT status requires evidence for each assessment area — not general assertions
- Legal basis must be documented with specific reference (PRD section, ToS section)
- Deletion support must be verified in Prisma schema — not assumed

## Steps

1. Read data classification results — identify all CONFIDENTIAL and RESTRICTED entities
2. If RESTRICTED: issue `BLOCKED_PENDING_HUMAN`, escalate, stop assessment
3. For each CONFIDENTIAL entity: assess legal basis, minimization, consent, deletion, third-party
4. Verify audit_log entries do not contain raw PII values
5. Produce `Privacy_Assessment.md`

## Knowledge Access Policy

At runtime, reads from:
- `Agente07_DevSecOps/knowledge/principles.md` → P8, P12
- `Agente07_DevSecOps/knowledge/decision_rules.md` → DR005, DR012
- `Agente07_DevSecOps/knowledge/knowledge_cards.md` → Card 008, Card 009, Card 010
- `Agente07_DevSecOps/checklists/privacy_compliance_checklist.md`
- `Agente07_DevSecOps/templates/Privacy_Assessment.md`

Do NOT access `context/` or `lib/` at runtime.
