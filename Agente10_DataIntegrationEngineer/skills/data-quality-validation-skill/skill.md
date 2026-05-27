# Skill: data-quality-validation-skill

## Purpose

Define formal data quality acceptance criteria for incoming external data, producing `Data_Quality_Checklist.md`. Specifies field-level validation rules (Zod-compatible), deduplication logic, record disposition policy, and quarantine table schema.

## When to Use

Invoke for every integration that ingests external data into the internal database. Invoke after `data-mapping-skill` (field classification is a prerequisite). This skill is not required for outbound-only integrations.

## Inputs

| Input | Source | Required |
|-------|--------|----------|
| `data_mapping` | Output of `data-mapping-skill` | Yes |
| `integration_spec` | `Integration_Spec.md` | Yes |
| `business_rules` | Integration_Requirements.md | Yes |
| `estimated_volume` | Integration_Requirements.md | Yes |

## Outputs

| Output | Description |
|--------|-------------|
| `Data_Quality_Checklist.md` | Quality acceptance criteria, validation rules, disposition policy |
| Quarantine table schema | `integration_quarantine` table definition |
| Alert thresholds | Quality failure alert configuration |

## Constraints

- Identity field (external ID) must have REJECT disposition — missing identity = discard
- Critical fields must have QUARANTINE disposition on failure
- Non-critical fields must have ACCEPT_WITH_FLAG or DEFAULT disposition
- Deduplication key must map to a `@unique` Prisma constraint
- `integration_quarantine` table schema must be defined when QUARANTINE is used
- No PII in `raw_payload` column without encryption or exclusion
- Quality metrics must be mapped to `sync_log.counts` fields

## Step-by-Step Execution

1. **Identify identity field:** The field that uniquely identifies a record (maps to `externalId`). This field gets REJECT disposition — a record without an identity cannot be processed.

2. **Classify field criticality:** For each field in `Data_Mapping.md`, determine: critical (business processes fail without it) vs. non-critical (optional, has a reasonable default). **Reasonable default** for a non-critical field is a value that: (a) allows the record to be stored without violating a NOT NULL constraint, (b) does not produce incorrect business logic results when used, and (c) is explicitly listed in `integration_requirements.md` OR is a universally safe value for the field type (e.g., `""` for optional text, `0` for optional counters, `false` for optional flags). If no safe default exists, the field must be reclassified as critical.

3. **Define validation rules:** For each field, specify the Zod validation rule: type, format, enum values, min/max length, range.

4. **Define dispositions:** Map criticality and validation outcome to disposition: ACCEPT, ACCEPT_WITH_FLAG, QUARANTINE, REJECT, SKIP.

5. **Define deduplication:** Specify the deduplication key and scope.

6. **Define timeliness (if required):** Specify `updated_at` staleness threshold.

7. **Define quarantine table schema:** If QUARANTINE is used, produce the full table schema.

8. **Map quality metrics to sync_log:** Define which quality metrics appear in `counts`.

9. **Define alert thresholds:** Specify both absolute count and percentage-based thresholds. Error rate = `(failed_records / total_records) × 100`. Alert condition: trigger if `error_rate > threshold_pct` OR `failed_records > threshold_abs` — whichever is reached first. Default thresholds unless overridden by `integration_requirements.md`: `threshold_pct = 5%`, `threshold_abs = 50`. Runs with `total_records = 0` do not trigger rate-based alerts but do trigger if any records are unexpectedly absent (separate `no_records_received` alert if `total_records = 0` on a run where records were expected).

10. **Run `data_quality_checklist.md`:** Verify all items before marking output complete.

## Knowledge Access Policy

At runtime, this skill reads from:
- `Agente10_DataIntegrationEngineer/knowledge/` (principles P8; heuristics H5, H9; knowledge cards Card016)
- `Agente10_DataIntegrationEngineer/templates/Data_Quality_Checklist.md`
- `Agente10_DataIntegrationEngineer/checklists/data_quality_checklist.md`
- Project input artifacts: Data_Mapping.md, Integration_Requirements.md

**Blocked at runtime:** `context/`, `lib/`, `*.pdf`, any other agent's folder.
