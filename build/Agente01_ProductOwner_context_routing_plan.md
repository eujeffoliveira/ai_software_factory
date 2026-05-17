# Agente01_ProductOwner — Context Routing Plan

**Build Date:** 2026-05-17

---

## Sources Read at Build-Time

| Source | Status | Used For |
|--------|--------|----------|
| `context/manual_arquitetura_componentes_generico.md` | PROCESSED | Agent structure, artifact contracts, gate definitions, skill types, RAG policy |
| `context/integrantes.md` | PROCESSED_WITH_ABSTRACTION | Agent role definition, responsibilities, inputs/outputs, limits — corporate references abstracted |
| `context/reference_architecture_generico.md` | PROCESSED_PARTIAL | NFR constraints only (performance, security, availability targets) — tech stack details excluded |
| `context/base_teorica.md` | PROCESSED | Knowledge base mapping for Agent 01 (Wiegers, Cockburn, Patton, Cohn) |
| `lib/ProductOwner/` | DISTILLED | 5 books processed into knowledge/ artifacts |

> `context/integrantes_generico.md` not found — used `context/integrantes.md` with white-label abstraction. No functional impact.

---

## What Was Extracted for `context_view.md`

### Included
- Product Owner role definition in the factory pipeline
- Relationship with Tech Lead (receives briefings, returns Handoff Package)
- Relationship with Software Architect (next agent after Gate 1 approval)
- Relationship with QA Engineer (validates acceptance criteria at Gate 4)
- Gate 1 — PRD Approval: criteria, status codes, who decides
- PRD mandatory structure (all 15 sections)
- User story format (INVEST) and INVEST criteria
- BDD/Gherkin format for acceptance criteria
- Functional requirements definition
- Non-functional requirements — 10 categories with examples
- Scope boundary — in-scope and out-of-scope conventions
- Open questions — OQ-NNN format and criticality classification
- Business rules — BR-NNN format and traceability requirements
- Data requirements — high-level only, no schema
- Product risks — PRISK-NNN format and risk categories
- Human escalation policy (always via Tech Lead)
- Runtime isolation policy

### Excluded (not compiled into context_view.md)
- Prisma ORM and migration details (tech implementation — Architect's domain)
- Route Handlers, Server Actions, Server Components patterns (development details)
- Vercel deployment configuration (DevOps domain)
- NextAuth and Google OAuth setup (technical implementation)
- Database schema conventions (Architect's domain)
- Cron job patterns (DevOps domain)
- Frontend component library details (Frontend Dev domain)
- CI/CD pipeline specifics (DevOps domain)
- Security audit procedures (DevSecOps domain)

---

## What Was Compiled into `knowledge/`

| Source | Knowledge Artifacts |
|--------|-------------------|
| Software Requirements (Wiegers) | principles.md (P2, P3, P6, P7), heuristics.md (H1-H4, H9-H12), decision_rules.md (DR001-DR010, DR026-DR030) |
| Writing Effective Use Cases (Cockburn) | knowledge_cards.md (Card 010), skills/requirements-interview-skill, checklists/prd_quality_checklist.md |
| User Stories Applied (Cohn) | principles.md (P1), knowledge_cards.md (Card 001), skills/user-story-mapping-skill, checklists/invest_checklist.md |
| Agile Software Requirements (Leffingwell) | heuristics.md (H5-H8), skills/non-functional-requirements-skill, knowledge_cards.md (Card 005) |
| Mastering the Requirements Process (Robertson) | decision_rules.md (DR011-DR025), checklists/gate_1_prd_approval_checklist.md |

---

## Routing Decision: What the Product Owner Knows About Tech

The Product Owner knows the tech stack **as organizational constraints only**:

| Constraint | How PO Sees It |
|-----------|----------------|
| Next.js 16 / React 19 | "The organization's web framework — PO does not choose this" |
| Supabase/PostgreSQL | "The organization's database platform — PO specifies data requirements, not schema" |
| NextAuth v5 | "Authentication is handled by the platform — PO specifies auth UX requirements" |
| Vercel | "The organization's deployment platform — PO specifies availability NFRs" |
| Zod | "Validation is handled by the platform — PO specifies data validation rules as business requirements" |
| LGPD/GDPR | "Data protection compliance is a mandatory NFR category" |

The PO does NOT receive: ORM queries, migration commands, Route Handler patterns, Server Action signatures, deployment configurations, or infrastructure specifications.
