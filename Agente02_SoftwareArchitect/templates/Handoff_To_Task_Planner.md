# Handoff Package — Agente02_SoftwareArchitect → Agente03_SoftwareEngineer

**Date:** YYYY-MM-DD  
**Architecture Version:** 1.0  
**Gate Status:** [READY_FOR_GATE_2 | REQUIRES_HUMAN_APPROVAL | BLOCKED_PENDING_ADR]

---

## Artifact Produced

Architecture Package v1.0 for [Project Name]

---

## Summary

[2-3 sentences describing what was designed. Include: architecture style, key components, database approach, and any notable deviations from the Golden Path.]

---

## Architecture Package Contents

| Artifact | Status | Notes |
|----------|--------|-------|
| `Architecture.md` | ✅ Complete | [Notes] |
| `API_Contract.json` | ✅ Complete | [N] endpoints defined |
| `Prisma_Schema_Proposal.prisma` | ✅ Complete | [N] models |
| `DB_Schema.sql` | ✅ Complete | Supplementary |
| `Architecture_Decisions.md` | ✅ Complete | [N] decisions logged |
| `ADR-*.md` | ✅ / ⚠️ | [N] ADRs required, [N] drafted |
| `Risk_Register.md` | ✅ Complete | [Summary: N CRITICAL, N HIGH, N MEDIUM, N LOW] |
| `Security_Strategy.md` | ✅ Complete | [Notes] |
| `Observability_Strategy.md` | ✅ Complete | [Notes] |
| `Testing_Strategy.md` | ✅ Complete | [Notes] |
| `Deployment_Strategy.md` | ✅ Complete | [Notes] |

---

## Assumptions

| # | Assumption | Impact if Wrong |
|---|-----------|-----------------|
| 1 | [Assumption 1] | [Impact] |
| 2 | [Assumption 2] | [Impact] |

---

## Open Questions

| # | Question | Blocking? | Context |
|---|----------|-----------|---------|
| 1 | [Question requiring Tech Lead or human input] | Yes/No | [Context] |

---

## Risks

| RISK-ID | Classification | Description | Mitigation | Blocks Gate 2 |
|---------|---------------|-------------|------------|---------------|
| RISK-001 | HIGH | [Risk] | [Mitigation] | No |

---

## ADRs Created

| ADR-ID | Title | Status |
|--------|-------|--------|
| ADR-001 | [Title] | Proposed |

---

## Required Next Agent

**Agente03_SoftwareEngineer**

---

## Validation Checklist

- [ ] Architecture.md covers all PRD functional requirements
- [ ] Architecture.md covers all PRD non-functional requirements
- [ ] API_Contract.json covers all endpoints in Architecture.md
- [ ] Every endpoint has auth requirements specified
- [ ] Database schema follows Prisma conventions (@map / @@map)
- [ ] All PII fields classified
- [ ] Every Golden Path deviation has an ADR (minimum PROPOSED)
- [ ] No CRITICAL unmitigated risks
- [ ] Security_Strategy.md: threat model covers all endpoints
- [ ] audit_log and sync_log instrumentation points identified
- [ ] /api/health endpoint defined
- [ ] Rollback plan present in Deployment_Strategy.md
- [ ] Handoff Package validated against handoff_schema.json

---

## Instructions for Agente03_SoftwareEngineer

1. Read `Architecture.md` completely before creating the Execution Plan.
2. Use `API_Contract.json` as the authoritative contract for all endpoint implementations.
3. Use `Prisma_Schema_Proposal.prisma` as the authoritative data model.
4. Check `Architecture_Decisions.md` for all ADRs and approved deviations.
5. For each atomic task, reference the specific Architecture.md section and API endpoint.
6. Prioritize tasks in order: auth → core data model → primary CRUD → secondary features → cron jobs.
7. Flag any architecture ambiguity back to Tech Lead before decomposing unclear tasks.
