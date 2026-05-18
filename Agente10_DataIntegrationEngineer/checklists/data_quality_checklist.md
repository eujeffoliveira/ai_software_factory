# Data Quality Checklist (Execution)

> Run for every integration that ingests external data. Invoke after data-mapping-skill.

## Pre-Execution: Inputs Ready

- [ ] `Data_Mapping.md` completed — all fields classified and typed
- [ ] Integration_Spec.md specifies estimated record volume per run
- [ ] Business rules for data validity confirmed with Agente01_ProductOwner (via Agente00 if needed)

## Quality Dimensions

- [ ] Completeness threshold defined (minimum % of required fields that must be present)
- [ ] Timeliness requirement defined (maximum age of `updated_at`) — or N/A if not applicable
- [ ] Uniqueness requirement defined (deduplication key identified)
- [ ] Validity rules defined (business-specific constraints beyond format validation)

## Critical Field Validation

- [ ] Identity field (`id` or equivalent) has REJECT disposition — missing identity = cannot identify record
- [ ] All required business fields have QUARANTINE disposition on failure
- [ ] Enum fields have complete enum map (all valid values listed, fallback for unknown values defined)
- [ ] DateTime fields validated as ISO8601 parseable
- [ ] Numeric fields validated with range constraints where applicable
- [ ] Email fields validated with `z.string().email()` pattern

## Non-Critical Field Validation

- [ ] Optional fields have nullable/optional Zod types
- [ ] Default values documented for DEFAULTED fields
- [ ] ACCEPT_WITH_FLAG disposition specified for non-critical failures
- [ ] Quality flags specification defined (field name: `qualityFlags`, type: string array)

## Record Disposition Policy

- [ ] ACCEPT path defined (all critical pass → proceed to upsert)
- [ ] QUARANTINE path defined (any critical fail → move to `integration_quarantine` table)
- [ ] REJECT path defined (identity field missing → log error, discard)
- [ ] SKIP path defined (duplicate detected → count in `skipped`, do not insert)
- [ ] ACCEPT_WITH_FLAG path defined (only non-critical fail → upsert with quality annotation)
- [ ] All 5 dispositions covered in the Data_Quality_Checklist.md

## Deduplication

- [ ] Deduplication key specified and documented
- [ ] Deduplication key maps to `@unique` constraint in Prisma schema
- [ ] Deduplication scope defined (all-time or windowed)
- [ ] Soft delete handling defined (if the external system deletes records)

## Quarantine Table

- [ ] `integration_quarantine` table schema defined (if QUARANTINE disposition is used)
- [ ] Table includes: `id, job_name, external_system, external_id, raw_payload, error_message, failed_at, retry_count, resolved_at, resolution_note`
- [ ] No PII fields stored in `raw_payload` without encryption or exclusion (check PII classification in Data_Mapping.md)

## Sync Log Quality Metrics

- [ ] `counts.errors` incremented for QUARANTINED and REJECTED records
- [ ] `counts.skipped` incremented for SKIPPED (duplicate) records
- [ ] Alert thresholds defined for error counts and error rates per run

## Post-Execution: Review

- [ ] `Data_Quality_Checklist.md` produced using `templates/Data_Quality_Checklist.md`
- [ ] All field-level validation rules expressed in Zod-compatible syntax
- [ ] Quarantine table schema included in `Integration_Spec.md` if used
- [ ] Quality requirements ready to be consumed by Agente04_DevBackend for implementation

## Runtime Knowledge Policy

At runtime, this checklist is consulted from `Agente10_DataIntegrationEngineer/checklists/`. The agent reads only from its own folder and project input artifacts. `context/` and `lib/` are blocked at runtime.
