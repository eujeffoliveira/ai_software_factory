# architecture-design-skill

## Purpose

Transform an approved PRD into a coherent `Architecture.md` document that describes all system components, layers, data flows, integration points, and technology decisions — all traceable to PRD requirements and compliant with the Golden Model.

## When to Use

- Immediately after receiving an approved `PRD.md` from the Tech Lead
- When the architecture must be revised after Gate 2 rejection
- When a structural change is approved by the Tech Lead

## Inputs

- `PRD.md` (approved, from Agente01_ProductOwner)
- `Open_Questions.md` (from Agente01)
- `Agente02_SoftwareArchitect/context_view.md` (Golden Model reference)
- `Agente02_SoftwareArchitect/knowledge/principles.md`
- `Agente02_SoftwareArchitect/knowledge/decision_rules.md`
- Existing ADRs (if any)

## Outputs

- `Architecture.md` — primary architecture document
- Draft `Architecture_Decisions.md` — log of decisions made

## Procedure

1. **Read PRD completely** — extract: functional requirements, non-functional requirements, out-of-scope items, data involved.

2. **Map NFRs to architecture characteristics** — for each NFR, identify which architecture characteristic it requires (scalability, availability, maintainability, security, testability).

3. **Select architecture style** — invoke DR002: for standard SaaS with no high-concurrency NFRs, select fullstack-monorepo. For workloads requiring dedicated compute, propose a service via ADR.

4. **List system components** — for each PRD use case, identify the components that apply: server component, server action, route handler, DAL function, and/or job. Not every use case requires all five — omit a component type only when the use case genuinely does not need it, and note the reason.

5. **Document data flows** — draw explicit paths for: stable reads, mutations, cron jobs, polling (if applicable), integrations.

6. **Select technology stack** — apply Golden Path (context_view.md §1.2). Flag any deviation for ADR.

7. **Identify integration points** — list all external services, their purpose, and location (lib/integrations/).

8. **Apply architecture principles** — check each component against P1–P11 in `knowledge/principles.md`.

9. **Build PRD traceability matrix** — every NFR must map to an architectural decision; every architectural component must trace to a PRD requirement.

10. **Document assumptions and open questions** — be explicit about what was assumed vs. what requires clarification.

11. **Populate Architecture.md using `templates/Architecture.md`** — fill all sections.

## Quality Gate

Architecture.md passes skill quality when:
- Every PRD functional requirement maps to at least one component
- Every PRD non-functional requirement maps to at least one architectural decision
- No component exists without PRD justification
- All mandatory layers are present (proxy.ts, auth.ts, lib/env.ts, /api/health, lib/db/)
- No anti-patterns from context_view.md §12

## Failure Modes

- **Over-engineering:** Adding components the PRD doesn't require → Remove; apply P1 (simplicity first) and P2 (use cases define architecture)
- **Missing data flows:** Omitting a critical path → Re-read PRD acceptance criteria; add missing flows
- **PRD drift:** Architecture addresses features not in the PRD → Remove; focus on PRD scope

## RAG Policy

Allowed collections at runtime:
- `architecture_reference_full` (context_view.md)
- `clean_architecture` (knowledge/principles.md, knowledge/knowledge_cards.md)
- `domain_driven_design` (knowledge/knowledge_cards.md)
- `software_architecture_fundamentals` (knowledge/knowledge_cards.md)

Blocked at runtime: `context/`, `lib/`, raw PDFs

## Architecture Compliance

This skill's output (`Architecture.md`) must comply with:
- context_view.md §3.1 (Mandatory Layers)
- context_view.md §3.2 (Route Handler Rule)
- context_view.md §12 (Anti-Patterns)
- `checklists/architecture_quality_checklist.md`

## Knowledge Access Policy

Runtime reads: `Agente02_SoftwareArchitect/knowledge/` only.  
Build-time sources (blocked at runtime): `context/`, `lib/`, raw PDFs.
