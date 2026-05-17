# ADR Required Checklist

_Use this checklist to determine whether an ADR is required for a given decision._

---

## Automatic ADR triggers (any YES = ADR required)

### Technology Deviations

- [ ] Proposing a framework other than Next.js 16? → ADR required
- [ ] Using pages/ instead of App Router? → ADR required
- [ ] Using middleware.ts in Next.js 16? → ADR required
- [ ] Using a database other than PostgreSQL? → ADR required
- [ ] Using an ORM other than Prisma 7? → ADR required
- [ ] Deploying to a platform other than Vercel? → ADR required
- [ ] Using an auth provider other than Google OAuth? → ADR required
- [ ] Using a test framework other than Vitest or Playwright? → ADR required
- [ ] Using a charts library other than Recharts? → ADR required
- [ ] Using a CSS framework other than Tailwind v4? → ADR required

### Architecture Deviations

- [ ] Separating frontend and backend into different repositories? → ADR required
- [ ] Adding a dedicated backend service (not monorepo)? → ADR required
- [ ] Adding a dedicated worker service? → ADR required
- [ ] Adding an async queue (Redis/BullMQ/SQS)? → ADR required
- [ ] Adding a Python/FastAPI service? → ADR required
- [ ] Adding a data pipeline service? → ADR required
- [ ] Adding an AI/embeddings service? → ADR required
- [ ] Using WebSockets with persistent runtime? → ADR required
- [ ] Universal RLS without a conditional policy decision? → ADR required
- [ ] Mixing Prisma Migrate and Supabase CLI as migration tools? → ADR required

### High-Impact Decisions

- [ ] Migration that is irreversible or destructive? → ADR required
- [ ] New critical external service dependency? → ADR required
- [ ] Change in authentication/authorization model? → ADR required
- [ ] Significant increase in operational cost (new paid service)? → ADR required
- [ ] Decision that would be expensive or disruptive to reverse? → ADR required

---

## ADR Creation Template

When an ADR is required:

1. Use `templates/ADR_Template.md` as the base
2. Set status to `Proposed`
3. Save as `docs/adr/ADR-NNN-kebab-case-title.md`
4. Reference in `Architecture_Decisions.md`
5. Include ADR-NNN in the relevant component in `Architecture.md`

---

## ADR Approval Flow

```
Agente02_SoftwareArchitect creates ADR (PROPOSED)
  → Submits to Agente00_TechLead via Handoff Package
    → TechLead reviews → APPROVED or REJECTED
      → If APPROVED: Gate 2 can proceed
      → If REJECTED: Agente02 revises architecture to avoid the deviation, or proposes alternative ADR
```
