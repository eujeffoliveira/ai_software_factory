# Architecture Quality Checklist

_Run before submitting Architecture.md to Gate 2._

---

## Completeness

- [ ] Architecture.md has an Executive Summary (2-3 sentences)
- [ ] Architecture style is stated and justified
- [ ] All system components are listed with type, location, and responsibility
- [ ] All data flows are documented (stable read, mutation, cron, polling if applicable)
- [ ] Technology stack table is complete with versions
- [ ] Database schema summary is present (links to Prisma schema)
- [ ] Security architecture section is present (links to Security_Strategy.md)
- [ ] Observability section is present (links to Observability_Strategy.md)
- [ ] Testing section is present (links to Testing_Strategy.md)
- [ ] Deployment section is present (links to Deployment_Strategy.md)
- [ ] Architecture Decisions section is present (links to Architecture_Decisions.md)

## PRD Traceability

- [ ] Every PRD functional requirement maps to at least one architectural component
- [ ] Every PRD non-functional requirement maps to at least one architectural decision
- [ ] No architectural component exists without PRD justification
- [ ] "Out of scope" items from PRD are not included in the architecture

## Correctness

- [ ] proxy.ts is the entry point (not middleware.ts)
- [ ] App Router is used (no pages/ directory)
- [ ] auth.ts is present for NextAuth v5
- [ ] lib/env.ts is in the architecture
- [ ] lib/prisma.ts singleton is referenced
- [ ] Route Handlers (route.ts) are thin shells — business logic is in lib/
- [ ] Server Components are used for stable initial reads
- [ ] Server Actions are used for mutations
- [ ] SWR is present only if polling is genuinely required
- [ ] /api/health endpoint is defined
- [ ] guardCron() is specified for all cron routes
- [ ] audit_log is planned for sensitive human actions
- [ ] sync_log is planned for all automated jobs

## No Anti-Patterns

- [ ] No middleware.ts in architecture
- [ ] No direct process.env access documented (all via lib/env.ts)
- [ ] No business logic in route.ts
- [ ] No SQL concatenation in DAL design
- [ ] No missing idempotency for job design
- [ ] No SWR used without necessity

## Documentation Quality

- [ ] Component names are descriptive and domain-aligned
- [ ] Data flow diagrams use standard notation
- [ ] No jargon without explanation
- [ ] Assumptions are explicitly listed
- [ ] Open questions are explicitly listed
