# Skill: data-classification-skill

## Purpose

Classify all data entities handled by the feature into PUBLIC, INTERNAL, CONFIDENTIAL, or RESTRICTED tiers. This is the first skill run in every Gate 5 evaluation because the classification result drives the scope of all other reviews.

## When to Use

Step 2 of every Gate 5 evaluation — mandatory. Must complete before privacy-review-skill and before determining whether threat model is required.

## Inputs

- `Architecture.md` — system design and data flow
- `prisma/schema.prisma` — data models with all fields
- `API_Contract.json` — request/response shapes (what data is exposed)
- Implementation files — what fields are actually read, written, and returned

## Outputs

- `Data_Classification.md` following `templates/Data_Classification.md`
- `highest_tier` — the controlling tier for the whole review
- `restricted_human_signoff_required` — true if any RESTRICTED entities found
- `privacy_review_required` — true if CONFIDENTIAL or RESTRICTED

## Constraints

- Classify EVERY field that is used, not just every table
- The highest tier found controls the entire review — one RESTRICTED field = full RESTRICTED review
- RESTRICTED → `BLOCKED_PENDING_HUMAN` immediately, before any other assessment
- When in doubt between INTERNAL and CONFIDENTIAL, choose CONFIDENTIAL (more protective)

## Steps

1. Read Architecture.md and prisma/schema.prisma — list all data entities in the feature scope
2. For each entity: apply the classification criteria from `checklists/data_classification_checklist.md`
3. Identify PII fields within each entity
4. Identify regulatory obligations (LGPD, GDPR, HIPAA)
5. Determine the highest tier across all entities
6. If RESTRICTED: immediately issue `BLOCKED_PENDING_HUMAN` and escalate — stop other assessments
7. **Coverage verification**: cross-reference the classified fields list against all fields read or written in the implementation files (Server Actions, DAL, Route Handlers). Any field present in the implementation but absent from the classification is a coverage gap — classify it before continuing.
8. Produce `Data_Classification.md`

## Knowledge Access Policy

At runtime, reads from:
- `Agente07_DevSecOps/knowledge/knowledge_cards.md` → Card 009 (Data Classification Tiers)
- `Agente07_DevSecOps/knowledge/decision_rules.md` → DR012
- `Agente07_DevSecOps/checklists/data_classification_checklist.md`
- `Agente07_DevSecOps/templates/Data_Classification.md`

Do NOT access `context/` or `lib/` at runtime.
