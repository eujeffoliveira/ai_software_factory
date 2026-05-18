# Data Mapping Checklist

> Run before finalizing `Data_Mapping.md`. Invoke after api-ingestion-skill and before sync-strategy-skill.

## Pre-Execution: Inputs Ready

- [ ] External API documentation reviewed and field list compiled
- [ ] Prisma schema for the target model reviewed
- [ ] `Integration_Spec.md` specifies the integration_id and system_type
- [ ] Data direction confirmed (inbound / outbound / bidirectional)

## Source → Target Mapping

- [ ] Every field in the external API entity is accounted for (mapped, dropped, or defaulted)
- [ ] Every mapped field has an explicit `transformation_type` (DIRECT / TYPE_COERCION / COMPUTED / LOOKUP / DEFAULTED / DROPPED)
- [ ] Type coercions are explicitly documented with the formula (e.g., `new Date(value)`, `.toISOString()`)
- [ ] Computed fields have the formula documented (e.g., `"${firstName} ${lastName}"`)
- [ ] Lookup/enum maps are fully defined — no unmapped values without a fallback
- [ ] Defaulted fields have the default value and the condition documented
- [ ] Dropped fields have a reason for exclusion documented

## Target → Source Mapping (Outbound)

- [ ] Reverse mapping documented for all fields in bidirectional integrations
- [ ] Outbound-only internal fields documented as "not sent" with reason
- [ ] Type conversions for outbound mapped (e.g., `DateTime.toISOString()`)

## Field Ownership (Bidirectional Only)

- [ ] Field Ownership Table produced for all fields in bidirectional integrations
- [ ] Every field has exactly one `owner`: EXTERNAL / INTERNAL / COMPUTED
- [ ] Conflict resolution strategy specified for each bidirectional field
- [ ] Conflict detection mechanism specified (timestamp, version counter, ETag)

## PII Classification

- [ ] Every field has a `pii_classification` value
- [ ] Fields classified as PERSONAL or SENSITIVE trigger `data-privacy-risk-skill` invocation
- [ ] PII fields appear in the LGPD section of `Data_Risks.md`
- [ ] No SENSITIVE PII field without CONSENT as legal basis

## Requirements Traceability

- [ ] Every mapped field has a `requirement_source` reference (Architecture.md §N, INT-REQ-NNN)
- [ ] No field added to the mapping without a requirement trace
- [ ] Dropped fields that were requested but excluded have a reason documented

## Data Lineage

- [ ] Data lineage section completed: every internal field has a documented source
- [ ] Computed fields: formula documented
- [ ] System-generated fields (`syncedAt`, `qualityFlags`): generation method documented

## Zod Schema Requirements

- [ ] Zod schema requirements section produced for all inbound fields
- [ ] Minimum required fields list is complete
- [ ] `.passthrough()` specified for external schemas (not `.strict()`)
- [ ] Optional fields use `.nullable().optional()`
- [ ] Enum values fully listed in Zod `.enum([...])` calls

## Post-Execution: Quality Check

- [ ] `Data_Mapping.md` produced using the `templates/Data_Mapping.md` template
- [ ] Mapping covers 100% of external API entity fields (mapped or explicitly dropped)
- [ ] `data-privacy-risk-skill` invoked if any PII fields detected
- [ ] Ready to pass to sync-strategy-skill

## Runtime Knowledge Policy

At runtime, this checklist is consulted from `Agente10_DataIntegrationEngineer/checklists/`. The agent reads only from its own folder and project input artifacts. `context/` and `lib/` are blocked at runtime.
