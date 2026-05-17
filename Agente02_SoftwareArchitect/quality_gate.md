# Quality Gate — Agente02_SoftwareArchitect

**Gate Number:** 2  
**Gate Name:** Architecture Approval  
**Owner:** Agente00_TechLead  
**Prepared by:** Agente02_SoftwareArchitect

---

## Objective

Gate 2 ensures the software architecture is technically sound, fully compliant with the Golden Model, risk-classified, and documented well enough that the Task Planner (Agente03) can decompose it into atomic implementation tasks without ambiguity.

---

## Entry Criteria

Gate 2 review begins when ALL of the following are true:

- [ ] `PRD.md` was approved at Gate 1
- [ ] Tech Lead has delivered `PRD.md` and `Open_Questions.md` to Agente02
- [ ] Agente02 has completed the Architecture Package (all mandatory artifacts below)
- [ ] Agente02 has run all checklists and self-reviewed the package

---

## Mandatory Artifacts

Every artifact below must be present and non-empty for Gate 2 to proceed:

| Artifact | Required | Description |
|----------|----------|-------------|
| `Architecture.md` | YES | System overview, layers, flows, integrations |
| `API_Contract.json` | YES | OpenAPI 3.1 specification for all endpoints |
| `DB_Schema.sql` or `Prisma_Schema_Proposal.prisma` | YES | Relational schema with Prisma conventions |
| `Architecture_Decisions.md` | YES | Log of all architectural decisions |
| `Risk_Register.md` | YES | Technical risk register with classifications |
| `Security_Strategy.md` | YES | Threat model and security controls |
| `Observability_Strategy.md` | YES | Logging, APM, healthcheck requirements |
| `Testing_Strategy.md` | YES | Test scope and tooling decisions |
| `Deployment_Strategy.md` | YES | Environments, migrations, rollback plan |
| `Handoff_To_Task_Planner.md` | YES | Handoff Package for Agente03 |

---

## Gate Status Codes

| Code | Meaning |
|------|---------|
| `APPROVED` | All artifacts present, compliant, risks mitigated. Gate passes. |
| `APPROVED_WITH_CONDITIONS` | Gate passes with minor items to be resolved in next iteration. |
| `RETURNED_FOR_REVISION` | Artifacts present but incomplete or non-compliant. Agente02 must revise. |
| `BLOCKED_PENDING_ADR` | Golden Path deviation found without approved ADR. Gate blocked until ADR submitted and approved. |
| `BLOCKED_PENDING_RISK_MITIGATION` | CRITICAL unmitigated risk found. Gate blocked until risk is addressed or escalated. |
| `BLOCKED_PENDING_HUMAN` | Decision requires human approval (e.g., destructive migration, CRITICAL security risk). |
| `BLOCKED_MISSING_ARTIFACT` | One or more mandatory artifacts are missing. |

---

## Blocking Conditions

The following conditions **block** Gate 2 regardless of other artifact quality:

1. **Missing mandatory artifact** → `BLOCKED_MISSING_ARTIFACT`
2. **Golden Path deviation without ADR** → `BLOCKED_PENDING_ADR`
3. **CRITICAL risk with no mitigation** → `BLOCKED_PENDING_RISK_MITIGATION`
4. **Destructive migration without human approval** → `BLOCKED_PENDING_HUMAN`
5. **CRITICAL security risk accepted unilaterally by Agente02** → `BLOCKED_PENDING_HUMAN`
6. **Architecture not traceable to PRD requirements** → `RETURNED_FOR_REVISION`

---

## Exit Criteria

Gate 2 is passed (`APPROVED` or `APPROVED_WITH_CONDITIONS`) when ALL of the following are true:

- [ ] All mandatory artifacts are present
- [ ] Architecture.md maps every non-functional requirement to an architectural decision
- [ ] Every Golden Path deviation has an ADR (status PROPOSED minimum)
- [ ] No CRITICAL unmitigated risks in Risk_Register.md
- [ ] Security_Strategy.md covers all endpoints (5 threat modeling questions answered)
- [ ] All PII fields are classified
- [ ] Migration risk classified for every schema change
- [ ] Rollback plan is present in Deployment_Strategy.md
- [ ] Healthcheck endpoint is defined
- [ ] Handoff_To_Task_Planner.md is complete

---

## When Agente02 Should Escalate to Tech Lead

Escalate (via Handoff Package or direct flag) when:

- A Golden Path deviation requires human cost approval
- A CRITICAL security or data protection compliance risk cannot be mitigated at architecture level
- A destructive migration has no safe rollback path
- There is a fundamental conflict between PRD requirements and technical feasibility
- A new paid external service is required
- There is a business-level trade-off between simplicity and scalability

---

## When a Human Decision Is Required

Human approval is required for:

- Accepting a CRITICAL security risk
- Approving a destructive database migration
- Approving a production deploy plan with no rollback path
- Approving a significant new operational cost (new paid service)
- Resolving scope conflicts between PRD and technical feasibility

The Tech Lead creates a `Human_Escalation_Request.md` and blocks the pipeline until a decision is received.

---

## Architecture Self-Review Checklist (run before submitting to Gate 2)

- [ ] Architecture.md covers all PRD functional requirements
- [ ] Architecture.md covers all PRD non-functional requirements
- [ ] All data flows are documented (read, mutation, cron)
- [ ] All integrations are identified
- [ ] proxy.ts is in the architecture
- [ ] auth.ts / NextAuth v5 is in the architecture
- [ ] lib/env.ts is in the architecture
- [ ] No business logic in route.ts
- [ ] No scattered process.env
- [ ] API_Contract.json covers all Architecture.md endpoints
- [ ] Every endpoint has auth requirements specified
- [ ] Prisma schema uses @map / @@map conventions
- [ ] All PII fields are classified
- [ ] audit_log instrumentation points identified
- [ ] sync_log instrumentation points identified
- [ ] /api/health endpoint defined
- [ ] Rollback plan present
- [ ] Every ADR is at least PROPOSED
- [ ] No CRITICAL risks without mitigation or escalation
