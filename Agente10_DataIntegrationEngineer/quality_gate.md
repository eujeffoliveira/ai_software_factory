# Agente10_DataIntegrationEngineer — Quality Gate 3.5 (Data Integration Review)

## Gate Overview

| Field | Value |
|-------|-------|
| Gate number | 3.5 |
| Gate name | Data Integration Review |
| Data Integration Engineer role | **Owner and sole evaluator** |
| Submitters | Agente02_SoftwareArchitect (via Gate 3 APPROVED) |
| Can be overridden by Tech Lead | **NO** |
| Prerequisite | Gate 3 APPROVED (Architecture.md with integration surface defined) |
| Activates when | Project has external integrations or data sync requirements |
| Output if APPROVED | Integration Handoff Package → Agente03_SoftwareEngineer |
| Output if BLOCKED | Block notice + missing items list → Agente00_TechLead |
| Output if RETURNED | Return Package + gap analysis → Agente02_SoftwareArchitect |

> **Gate 3.5 is conditional.** It is only activated when the project's `Architecture.md` identifies at least one external integration or data sync requirement. If there are no external integrations, Gate 3.5 is skipped and the pipeline advances directly from Gate 3 to Gate 4. The Tech Lead (Agente00) confirms whether Gate 3.5 applies.

> **Inviolability notice:** Gate 3.5 is owned by the Data Integration Engineer. The Tech Lead may escalate unresolved gate blocks to a human decision-maker, but cannot mark Gate 3.5 as passed. The only path to Gate 3.5 APPROVED is full coverage of all blocking criteria and positive evaluation by this agent.

---

## Gate 3.5 Objective

Validate that all data integration dimensions are fully specified before task planning begins, ensuring:

1. **Complete integration surface coverage** — every external system identified in Architecture.md has a corresponding Integration_Spec.md section
2. **Idempotency guaranteed** — every sync operation has a documented and viable idempotency strategy
3. **Privacy-compliant** — every personal data flow has a documented legal basis under LGPD
4. **Observable** — every automated sync job has sync_log field definitions
5. **Validated at boundaries** — every external API response has a Zod schema requirement
6. **Isolated** — external integration clients are specified at `lib/integrations/[service].client.ts`, never inside Prisma transactions
7. **Data quality defined** — acceptance criteria exist for incoming data

---

## Entry Criteria

All of the following must be present before Gate 3.5 evaluation starts:

| # | Entry Criterion | If Missing → |
|---|----------------|-------------|
| 1 | `Architecture.md` from Agente02_SoftwareArchitect with `gate_decision: APPROVED` at Gate 3 | RETURNED — Gate 3 must be approved first |
| 2 | Integration Requirements section in `Architecture.md` lists external systems | RETURNED — architecture incomplete |
| 3 | External API documentation provided for each external system | BLOCKED_PENDING_DOCS — cannot assess without documentation |
| 4 | `API_Contract.json` available | RETURNED_FOR_REVISION — architecture incomplete |
| 5 | Prisma schema available (or explicitly absent with explanation) | Proceed with note |

---

## Blocking Criteria (Gate 3.5 BLOCKED)

Any of the following conditions causes an immediate **BLOCKED** status. The gate cannot be approved until all blocks are resolved:

### BK-01: Missing Idempotency Strategy
**Condition:** Any sync operation in the Integration_Spec.md does not have a documented idempotency strategy.
**Status:** `BLOCKED_MISSING_IDEMPOTENCY`
**Resolution:** Invoke `idempotent-sync-design-skill` for each unspecified sync operation.

### BK-02: PII Flow Without Legal Basis
**Condition:** A data flow involves PERSONAL or SENSITIVE PII fields without a documented LGPD legal basis.
**Status:** `BLOCKED_LGPD_VIOLATION`
**Resolution:** Document legal basis via `data-privacy-risk-skill` or remove the personal data from the integration scope. Escalation to Agente00_TechLead required.

### BK-03: Missing sync_log Specification
**Condition:** An automated sync job (cron or webhook handler) does not have sync_log field definitions in its Sync_Strategy.md.
**Status:** `BLOCKED_MISSING_SYNC_LOG`
**Resolution:** Complete Sync_Strategy.md with sync_log fields for each job.

### BK-04: Sync Inside Prisma Transaction Specified
**Condition:** Any integration spec calls for an external API to be invoked inside a Prisma transaction.
**Status:** `BLOCKED_TRANSACTION_VIOLATION`
**Resolution:** Restructure the spec to call external API before opening the transaction.

### BK-05: Missing Zod Requirement for External Response
**Condition:** An external API client specification does not include Zod schema requirements for the API response.
**Status:** `BLOCKED_MISSING_ZOD`
**Resolution:** Invoke `api-ingestion-skill` and add Zod schema requirements.

### BK-06: Hardcoded Credentials in Spec
**Condition:** Integration spec includes literal API keys, tokens, or passwords (not `env.VARIABLE_NAME` references).
**Status:** `BLOCKED_CREDENTIAL_VIOLATION`
**Resolution:** Replace all credential references with `env.VARIABLE_NAME` from `lib/env.ts`.

### BK-07: CRITICAL Risk Without Mitigation
**Condition:** `Data_Risks.md` contains a RISK with classification CRITICAL and no mitigation strategy.
**Status:** `BLOCKED_UNMITIGATED_CRITICAL_RISK`
**Resolution:** Define a mitigation strategy or escalate to Agente00_TechLead for architectural decision.

---

## Gate 3.5 Evaluation Checklist

### Section A: Coverage (all items must be YES)

- [ ] Every external system in Architecture.md has an `Integration_Spec.md` section
- [ ] Every external system has an `External_API_Assessment.md` entry
- [ ] Every integration has a `Data_Mapping.md` with bidirectional field mappings
- [ ] Every recurring sync has a `Sync_Strategy.md`
- [ ] `Data_Risks.md` has been produced with RISK-NNN entries
- [ ] `Data_Quality_Checklist.md` has been produced

### Section B: Idempotency (all items must be YES)

- [ ] Every sync operation has a documented idempotency strategy (upsert key, idempotency table, or cursor)
- [ ] Upsert keys are identified and the external ID field is named
- [ ] Cursor-based pagination is specified for all large dataset syncs (>1,000 records)
- [ ] No `create` without existence check appears in any sync spec

### Section C: Privacy (all items must be YES or N/A)

- [ ] PII field inventory has been completed for each integration
- [ ] LGPD legal basis is documented for each personal data flow
- [ ] Data retention periods are specified per system
- [ ] Data Processing Agreement (DPA) status is noted for each external system
- [ ] No SENSITIVE PII flows without explicit consent basis

### Section D: Observability (all items must be YES)

- [ ] sync_log fields defined for every automated sync job
- [ ] Error handling strategy specified (retry logic, dead letter disposition)
- [ ] Rate limit handling documented for each external API with limits
- [ ] Timeout values specified for all external API calls

### Section E: Technical Compliance (all items must be YES)

- [ ] External integration client path specified as `lib/integrations/[service].client.ts`
- [ ] Zod schema requirements stated for all external API responses
- [ ] Credential references use `env.VARIABLE_NAME` — no literals
- [ ] No sync operation specified inside a Prisma transaction
- [ ] `guardCron()` included in all cron route specifications

---

## Gate Status Codes

| Status Code | Meaning |
|------------|---------|
| `APPROVED` | All sections pass, no blocking criteria, gate cleared |
| `BLOCKED_MISSING_IDEMPOTENCY` | BK-01 triggered — sync operation lacks idempotency strategy |
| `BLOCKED_LGPD_VIOLATION` | BK-02 triggered — PII flow without legal basis |
| `BLOCKED_MISSING_SYNC_LOG` | BK-03 triggered — automated job without sync_log spec |
| `BLOCKED_TRANSACTION_VIOLATION` | BK-04 triggered — external call inside transaction |
| `BLOCKED_MISSING_ZOD` | BK-05 triggered — external response without Zod requirement |
| `BLOCKED_CREDENTIAL_VIOLATION` | BK-06 triggered — hardcoded credentials |
| `BLOCKED_UNMITIGATED_CRITICAL_RISK` | BK-07 triggered — CRITICAL risk with no mitigation |
| `BLOCKED_MISSING_DOCS` | External API documentation unavailable |
| `RETURNED_FOR_REVISION` | Architecture.md incomplete — returned to Agente02 |
| `APPROVED_WITH_CONDITIONS` | Minor gaps noted but not blocking; conditions must be resolved before Gate 4 |

---

## Gate 3.5 Output

When Gate 3.5 is APPROVED, produce the Integration Handoff Package (`handoff_schema.json`) containing:

1. `Integration_Spec.md` — master integration document
2. `Data_Mapping.md` — field mapping per integration
3. `Sync_Strategy.md` — sync job design per integration
4. `Data_Quality_Checklist.md` — quality acceptance criteria
5. `Data_Risks.md` — all identified risks
6. `External_API_Assessment.md` — external API evaluation

Deliver the Handoff Package JSON to Agente03_SoftwareEngineer. Send `Data_Risks.md` also to Agente00_TechLead and Agente07_DevSecOps.
