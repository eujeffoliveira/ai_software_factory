# Skill: data-mapping-skill

## Purpose

Produce a complete, bidirectional field-level mapping between an external system's data model and the internal Prisma schema. The output (`Data_Mapping.md`) is consumed by Agente03_SoftwareEngineer (task creation) and Agente04_DevBackend (implementation).

## When to Use

Invoke this skill whenever an integration requires understanding which external API fields correspond to which internal Prisma model fields. Invoke once per external entity type per integration (e.g., one invocation for CRM Contacts, one for CRM Companies).

**Prerequisite:** `api-ingestion-skill` must have been completed first — its External_API_Assessment.md documents the API response shape that this skill maps.

## Inputs

| Input | Source | Required |
|-------|--------|----------|
| `external_api_response_schema` | External API documentation | Yes |
| `prisma_model_definition` | `prisma/schema.prisma` | Yes |
| `integration_requirements` | `Integration_Requirements.md` | Yes |
| `external_api_assessment` | Output of `api-ingestion-skill` | Yes |
| `data_direction` | Architecture.md integration surface | Yes |

## Outputs

| Output | Description |
|--------|-------------|
| `Data_Mapping.md` | Complete bidirectional field mapping document |
| PII field list | List of fields requiring LGPD assessment |
| Zod schema requirements | Inbound validation schemas (input to `api-ingestion-skill`) |

## Constraints

- Every external API field must be accounted for: mapped, computed, defaulted, or explicitly dropped with a reason
- Every mapped field must have: external type, internal type, transformation type, formula (if computed/coerced), nullability, PII classification, requirement source
- Field Ownership Table is mandatory for bidirectional integrations
- No PERSONAL or SENSITIVE PII field may appear without triggering `data-privacy-risk-skill`
- Zod schema requirements must use `.passthrough()` not `.strict()` by default
- The idempotency key field (`externalId`) must always be included in the Source→Target mapping

## Step-by-Step Execution

1. **Compile external field list:** Extract all fields from the external API documentation for the target entity. Include optional and nullable fields.

2. **Compile internal field list:** Extract all fields from the Prisma model definition. Note `@unique` constraints (idempotency key candidates), required vs optional fields, and enum definitions.

3. **Classify each external field by PII level:** Use the trigger list (H6): name, email, phone, CPF, address, IP, location, health data, financial data, biometrics → PERSONAL or SENSITIVE. Others → NOT_PII.

4. **Determine data direction:** Confirm whether the mapping is inbound-only, outbound-only, or bidirectional.

5. **Map Source → Target:** For each external field, determine: internal field name, transformation type, formula if applicable, nullability, PII level, requirement source. Document dropped fields explicitly.

6. **Map Target → Source (if bidirectional):** For each internal field, determine whether it is sent to the external system. Document outbound transformation or "not sent" with reason.

7. **Build Enum/Lookup Maps:** For each enum or status field, produce a complete mapping table including a fallback for unmapped values.

8. **Build Field Ownership Table (if bidirectional):** Declare the authoritative system for each field and the conflict resolution strategy.

9. **Build Data Lineage section:** For every internal field, document the source: DIRECT, COMPUTED, LOOKUP, DEFAULTED, or SYSTEM_GENERATED.

10. **Produce Zod Schema Requirements:** Define minimum required fields and the schema structure. Always use `.passthrough()`. Format: one `z.object({...}).passthrough()` block per external entity, where each field entry is `fieldName: z.type().optional()` or `fieldName: z.type()` (required). Include `z.string()`, `z.number()`, `z.boolean()`, `z.null()`, `z.enum([...])` as appropriate. Example entry: `externalId: z.string(), email: z.string().email().optional(), status: z.enum(["active", "inactive", "pending"]).optional()`. Nullable fields use `.nullable()` not `.optional()` when the API guarantees their presence with possible null value.

11. **Flag PII fields:** If any PERSONAL or SENSITIVE fields found, note that `data-privacy-risk-skill` must be invoked.

12. **Run `data_mapping_checklist.md`:** Verify all items checked before marking the output as complete.

## Knowledge Access Policy

At runtime, this skill reads from:
- `Agente10_DataIntegrationEngineer/knowledge/` (principles P3, P4, P7; heuristics H4, H5, H6, H10, H14; decision rules DR004, DR008, DR012)
- `Agente10_DataIntegrationEngineer/templates/Data_Mapping.md`
- `Agente10_DataIntegrationEngineer/checklists/data_mapping_checklist.md`
- `Agente10_DataIntegrationEngineer/examples/good_data_mapping.md`
- Project input artifacts: external API documentation, Prisma schema

**Blocked at runtime:** `context/`, `lib/`, `*.pdf`, any other agent's folder.
