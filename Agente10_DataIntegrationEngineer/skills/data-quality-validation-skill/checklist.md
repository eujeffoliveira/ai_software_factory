# data-quality-validation-skill Checklist

## Pre-Execution
- [ ] Data_Mapping.md available with field criticality classification
- [ ] Business rules reviewed from Integration_Requirements.md

## Execution
- [ ] Identity field identified with REJECT disposition
- [ ] Critical fields classified with QUARANTINE disposition
- [ ] Non-critical fields classified with ACCEPT_WITH_FLAG or DEFAULT disposition
- [ ] All validation rules expressed in Zod-compatible syntax
- [ ] Enum fields have complete enum maps with fallback for unknown values
- [ ] Deduplication key identified and mapped to @unique Prisma field
- [ ] Record disposition policy covers all 5 scenarios
- [ ] Quarantine table schema defined (if QUARANTINE disposition used)
- [ ] No PII in raw_payload without exclusion or encryption
- [ ] Quality metrics mapped to sync_log.counts fields
- [ ] Alert thresholds defined

## Runtime Knowledge Policy
- [ ] Knowledge from Agente10_DataIntegrationEngineer/knowledge/ only
- [ ] context/ and lib/ not accessed

## Post-Execution
- [ ] Data_Quality_Checklist.md produced using template
- [ ] identity_field_defined = true in output
- [ ] quarantine_table_defined = true if QUARANTINE disposition used
- [ ] Ready for Agente04_DevBackend implementation
