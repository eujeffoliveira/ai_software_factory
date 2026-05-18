# Integration Readiness Checklist

> Run this checklist before submitting to Gate 3.5. All items must be checked or explicitly marked N/A with justification.

## Pre-Execution: Inputs Available

- [ ] `Architecture.md` received with Gate 3 APPROVED status
- [ ] Integration surface identified in `Architecture.md` — list of external systems confirmed
- [ ] `Integration_Requirements.md` available with requirements per external system
- [ ] External API documentation available for each external system in scope
- [ ] `API_Contract.json` received from Agente02_SoftwareArchitect
- [ ] Prisma schema available (or explicitly documented as not yet available)

## Coverage: All Integrations Specified

- [ ] Every external system in `Architecture.md` has an `Integration_Spec.md` section
- [ ] Every external system has an `External_API_Assessment.md` entry
- [ ] Every integration has a `Data_Mapping.md` with bidirectional field mappings (or "outbound-only" / "inbound-only" declared)
- [ ] Every recurring sync job has a `Sync_Strategy.md`
- [ ] `Data_Risks.md` produced with RISK-NNN entries for all identified risks
- [ ] `Data_Quality_Checklist.md` produced for all ingestion integrations

## Idempotency: All Sync Operations Covered

- [ ] Every sync operation has a documented idempotency strategy (upsert key, idempotency table, or cursor)
- [ ] Upsert key identified for every sync that creates or updates records
- [ ] External ID field named and confirmed present in the external API response
- [ ] Cursor-based pagination specified for all syncs estimated at > 1,000 records per run
- [ ] No `create` without upsert appears in any sync spec
- [ ] Cursor update timing documented: update only after successful DB commit

## Privacy: LGPD Compliance

- [ ] PII field inventory completed for all integrations (scan all Data_Mapping.md files)
- [ ] `data-privacy-risk-skill` invoked for all integrations with personal data
- [ ] LGPD legal basis documented for every personal data flow
- [ ] SENSITIVE PII fields have CONSENT as legal basis (no other basis accepted)
- [ ] Data retention periods documented for each system per integration
- [ ] Data Processing Agreement (DPA) status documented for each external system
- [ ] PII fields excluded from `sync_log.errorMsg` and `console.log()` calls (specified in sync spec)
- [ ] No personal data flow without legal basis in `Data_Risks.md` (if any exists → BLOCKED_LGPD_VIOLATION)

## Observability: All Sync Jobs Instrumented

- [ ] `sync_log` fields defined for every automated sync job (cron or webhook handler)
- [ ] `syncLog()` placement specified as `finally` block — not just success path
- [ ] `counts` object includes: `{ processed, created, updated, skipped, errors }`
- [ ] Job name defined in kebab-case for sync_log `job` field
- [ ] Alert thresholds defined for consecutive failures

## Technical Compliance: Golden Model

- [ ] External integration client path specified as `lib/integrations/[service].client.ts`
- [ ] No external API call specified inside a Prisma transaction (`$transaction()`)
- [ ] All credential references use `env.VARIABLE_NAME` — no literal values
- [ ] All environment variable names listed in "Environment Variables Required" section
- [ ] `guardCron()` specified as first call in all cron route handlers
- [ ] Zod schema requirements stated for every external API response
- [ ] `.passthrough()` specified for Zod schemas on unstable external APIs
- [ ] API version pinned in client base URL

## Error Handling: Resilience Specified

- [ ] Timeout value specified for each external API client (default: 10,000ms)
- [ ] Retry configuration specified (max_attempts, backoff strategy)
- [ ] Circuit breaker configuration specified
- [ ] Dead letter disposition defined (quarantine table / error log / alert)
- [ ] HTTP error code handling table specified per client
- [ ] Rate limit handling documented for APIs with documented limits

## Data Quality: Acceptance Criteria Defined

- [ ] Critical fields identified with QUARANTINE disposition on failure
- [ ] Identity field (externalId source) identified with REJECT disposition on missing
- [ ] Non-critical fields identified with ACCEPT_WITH_FLAG or DEFAULT disposition
- [ ] Deduplication key specified and mapped to `@unique` Prisma field
- [ ] Record disposition policy covers all 5 scenarios
- [ ] `integration_quarantine` table schema defined (if quarantine is used)

## Post-Execution: Gate 3.5 Submission Ready

- [ ] All blocking criteria verified as clear (BK-01 through BK-07)
- [ ] `handoff_schema.json` fields completed for this integration cycle
- [ ] `idempotency_coverage.uncovered` = 0
- [ ] `lgpd_flows.missing_legal_basis` = 0
- [ ] `blocking_issues` array is empty
- [ ] `gate_ready` = true in the Handoff Package JSON

## Runtime Knowledge Policy

At runtime, this checklist is consulted from `Agente10_DataIntegrationEngineer/checklists/`. The agent reads only from its own folder and project input artifacts. `context/` and `lib/` are blocked at runtime.
