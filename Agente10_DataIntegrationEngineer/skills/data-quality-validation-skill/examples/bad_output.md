# Bad Output: data-quality-validation-skill

A bad Data_Quality_Checklist.md has these violations:

**No identity field REJECT:**
The `id` field has no special handling — if missing, the record is inserted with a null/empty externalId, causing a Prisma unique constraint error that crashes the entire job.

**No disposition policy:**
Spec just says "validate all fields" without specifying what happens when validation fails. Agente04 will guess — probably silently skip bad records without logging.

**Missing quarantine table:**
QUARANTINE disposition is mentioned but no `integration_quarantine` table schema is defined. Agente04 has to design the table ad hoc during implementation.

**PII in raw_payload:**
Quarantine table stores full `raw_payload` including `email`, `phone`, and `full_name`. These are PERSONAL PII fields stored in a table without encryption or access controls — LGPD violation.

**No alert thresholds:**
Errors accumulate silently. Operators have no threshold to trigger investigation. A degraded integration with 40% error rate runs unnoticed for weeks.
