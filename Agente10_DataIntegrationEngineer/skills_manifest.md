# Agente10_DataIntegrationEngineer — Skills Manifest

> Index of all authorized skills. At runtime, invoke skills by name. Each skill folder contains the complete definition, schemas, checklist, and examples.

---

## Skill Index

| # | Skill ID | Folder | Primary Output | Trigger Condition |
|---|----------|--------|---------------|-------------------|
| 1 | `data-mapping-skill` | `skills/data-mapping-skill/` | `Data_Mapping.md` | External system has fields that must be mapped to internal entities |
| 2 | `sync-strategy-skill` | `skills/sync-strategy-skill/` | `Sync_Strategy.md` | A recurring data sync job is required between systems |
| 3 | `data-quality-validation-skill` | `skills/data-quality-validation-skill/` | `Data_Quality_Checklist.md` | Incoming data quality requirements need formal specification |
| 4 | `etl-planning-skill` | `skills/etl-planning-skill/` | ETL Plan section in `Integration_Spec.md` | Bulk data migration or transformation pipeline is needed |
| 5 | `api-ingestion-skill` | `skills/api-ingestion-skill/` | `External_API_Assessment.md` | External REST/GraphQL API must be consumed |
| 6 | `idempotent-sync-design-skill` | `skills/idempotent-sync-design-skill/` | Idempotency section in `Sync_Strategy.md` | A sync operation must be made safe for repeated execution |
| 7 | `data-privacy-risk-skill` | `skills/data-privacy-risk-skill/` | `Data_Risks.md` (LGPD sections) | Data flow involves personal data subject to LGPD or equivalent regulation |

---

## Skill Descriptions

### 1. data-mapping-skill

**Purpose:** Produce a complete, bidirectional field-level mapping between an external system's data model and the internal Prisma schema.

**When to Invoke:** Whenever an integration requires understanding which external fields map to which internal fields and vice versa. Invoke once per integration surface (one invocation per external system/entity pair).

**Key Outputs:**
- Source→Target field mapping table with types and transformations
- Target→Source reverse mapping table
- Field ownership declaration for each field
- Conflict resolution policy for bidirectional fields
- Dropped fields (explicitly documented)

**Blocks Gate 3.5 if missing:** Yes — every integration requires a Data_Mapping.md.

---

### 2. sync-strategy-skill

**Purpose:** Design the complete synchronization strategy for a data flow, including trigger mechanism, frequency, batch size, cursor pagination, conflict resolution, and observability requirements.

**When to Invoke:** Whenever an integration requires automated, recurring data transfer between systems (cron job, webhook handler, event consumer).

**Key Outputs:**
- Sync trigger type and schedule (cron expression or webhook event)
- Batch size and cursor-based pagination strategy
- Sync state persistence mechanism (cursor storage)
- Conflict resolution policy
- sync_log field definitions
- Error handling and retry strategy
- Vercel Cron configuration

**Blocks Gate 3.5 if missing:** Yes — every automated sync requires a Sync_Strategy.md.

---

### 3. data-quality-validation-skill

**Purpose:** Define formal data quality acceptance criteria for incoming external data, including completeness thresholds, format rules, deduplication logic, and record disposition policy.

**When to Invoke:** Whenever an integration ingests external data that must meet quality standards before being persisted. Invoke after data-mapping-skill.

**Key Outputs:**
- Quality dimension checklist (completeness, accuracy, consistency, timeliness, uniqueness, validity)
- Field-level validation rules (Zod-compatible)
- Deduplication key specification
- Record disposition policy (accept / accept-with-flag / quarantine / reject / skip)
- Quality metrics to capture in sync_log

**Blocks Gate 3.5 if missing:** No — recommended but not blocking unless data quality failures are HIGH risk.

---

### 4. etl-planning-skill

**Purpose:** Plan a full Extract-Transform-Load pipeline for bulk data migration or initial data load scenarios, including extraction strategy, transformation rules, load order, rollback plan, and performance estimates.

**When to Invoke:** When an integration requires one-time or periodic bulk data migration (initial load, historical data import, data warehouse sync). Do NOT invoke for incremental sync — use sync-strategy-skill instead.

**Key Outputs:**
- Extraction plan (API pagination, file format, batch size)
- Transformation pipeline definition (TypeScript transformation functions)
- Load order (respecting referential integrity)
- Idempotency strategy for bulk load
- Rollback plan
- Performance and time estimate

**Blocks Gate 3.5 if missing:** Only if Architecture.md specifies a migration requirement.

---

### 5. api-ingestion-skill

**Purpose:** Assess an external REST or GraphQL API and produce the client specification for `lib/integrations/[service].client.ts`, including authentication method, Zod response schemas, rate limit handling, timeout configuration, and resilience patterns.

**When to Invoke:** Whenever an external API must be consumed. This is typically the first skill invoked for a new integration — its output feeds into data-mapping-skill and sync-strategy-skill.

**Key Outputs:**
- API capability assessment table
- Client file specification (`lib/integrations/[service].client.ts` structure)
- Zod response schema requirements
- Authentication configuration
- Rate limit and timeout parameters
- Resilience pattern recommendations (retry, circuit breaker, dead letter)
- Webhook security requirements (if applicable)

**Blocks Gate 3.5 if missing:** Yes — every external API integration requires an External_API_Assessment.md.

---

### 6. idempotent-sync-design-skill

**Purpose:** Design the idempotency mechanism for a specific sync operation, selecting and documenting the appropriate strategy (upsert key, idempotency key table, cursor state, event deduplication).

**When to Invoke:** For every sync operation before it is specified in Sync_Strategy.md. This skill is a prerequisite sub-step of sync-strategy-skill.

**Key Outputs:**
- Idempotency strategy selection with rationale
- Idempotency key definition (field name, source, computation method)
- Upsert key configuration for Prisma
- Processed-events table schema (when using idempotency key table)
- Test scenarios for idempotency validation

**Blocks Gate 3.5 if missing:** Yes — every sync operation must have a documented idempotency strategy.

---

### 7. data-privacy-risk-skill

**Purpose:** Assess all personal data flows in an integration against LGPD (Lei Geral de Proteção de Dados) requirements, classify PII fields, document legal bases, identify risks, and produce the LGPD section of Data_Risks.md.

**When to Invoke:** Whenever a data flow involves fields classified as PERSONAL or SENSITIVE PII. This skill must be invoked before Gate 3.5 if any integration touches personal data.

**Key Outputs:**
- PII field inventory with classification level
- Legal basis documentation for each personal data flow
- Data retention specification per system
- Cross-border transfer assessment
- Data subject rights impact assessment
- Data Processing Agreement (DPA) requirements
- LGPD risk entries for Data_Risks.md (RISK-NNN format)

**Blocks Gate 3.5 if missing:** Yes — any integration with personal data without LGPD assessment blocks Gate 3.5.

---

## Invocation Order (Typical)

```
For each external system:
  1. api-ingestion-skill          → External_API_Assessment.md
  2. data-privacy-risk-skill      → Data_Risks.md (LGPD section)  [if personal data]
  3. data-mapping-skill           → Data_Mapping.md
  4. idempotent-sync-design-skill → Idempotency spec
  5. sync-strategy-skill          → Sync_Strategy.md
  6. etl-planning-skill           → ETL plan                      [if bulk migration]
  7. data-quality-validation-skill → Data_Quality_Checklist.md
Compile: Integration_Spec.md (master document)
```
