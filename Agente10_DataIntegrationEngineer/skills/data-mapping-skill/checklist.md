# data-mapping-skill Checklist

## Pre-Execution
- [ ] External API entity field list compiled from API documentation
- [ ] Prisma model definition reviewed
- [ ] Integration_Requirements.md requirements for this entity reviewed
- [ ] api-ingestion-skill output (External_API_Assessment.md) available

## Execution
- [ ] Every external field classified by transformation type
- [ ] Every external field classified by PII level
- [ ] All computed fields have explicit formulas
- [ ] All type coercions have explicit conversion formulas
- [ ] All enum/lookup maps are complete (including fallback for unknown values)
- [ ] All dropped fields have reasons documented
- [ ] All mapped fields have requirement_source references
- [ ] Reverse mapping produced for bidirectional integrations
- [ ] Field Ownership Table produced for bidirectional integrations
- [ ] Data lineage section completed for all internal fields
- [ ] Zod schema requirements produced with `.passthrough()`

## Runtime Knowledge Policy
- [ ] Knowledge sourced from `Agente10_DataIntegrationEngineer/knowledge/` only
- [ ] Template `templates/Data_Mapping.md` used
- [ ] `context/` and `lib/` not accessed

## Post-Execution
- [ ] `data_mapping_checklist.md` fully checked
- [ ] PII flag set correctly in output schema
- [ ] `data-privacy-risk-skill` queued if PII detected
- [ ] Data_Mapping.md ready for sync-strategy-skill
