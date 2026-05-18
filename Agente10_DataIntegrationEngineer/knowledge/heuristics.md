# Agente10_DataIntegrationEngineer — Decision Heuristics

> Practical rules of thumb for integration design decisions. Applied when the correct pattern is not immediately obvious from first principles. Each heuristic is a synthesis of patterns from the build-time bibliography.

---

## H1 — Idempotency Key = External System's Unique ID

**When to apply:** Designing a sync job that creates or updates records.

**Heuristic:** The primary idempotency key for a sync operation is always the external system's unique identifier for the record (e.g., `external_id`, `crm_contact_id`, `erp_order_number`). Never use our internal sequential ID as the idempotency key — it doesn't exist before the record is created.

**Application:** Map the external system's primary key to a `externalId` column (or system-specific name like `crmId`) in the Prisma schema. Use it as the `where` clause in `upsert`.

**Source:** Fundamentals of Data Engineering (Reis & Housley) — Ch. 7

---

## H2 — Prefer Webhooks, Fall Back to Polling

**When to apply:** Choosing between push (webhook) and pull (polling) topology for an integration.

**Heuristic:** If the external system supports webhooks with reliable delivery and signature verification, use webhooks for near-real-time sync. Add a scheduled reconciliation job (daily or hourly) that polls for missed events — the webhook catches real-time changes, the job catches delivery failures.

**Application:** Specify both webhook handler and cron reconciliation job in the Sync_Strategy.md. The reconciliation job covers the period since `last_successful_sync_at`.

**Source:** Building Event-Driven Microservices (Bellemare) — Ch. 5: Reliability

---

## H3 — Cursor Beats Offset for Pagination

**When to apply:** Designing pagination strategy for a sync job that fetches records in batches.

**Heuristic:** Never use offset-based pagination (`?page=2&limit=100`) for sync jobs. If new records are inserted between page 1 and page 2 fetches, offset pagination skips records. Use cursor-based pagination (`?since=<timestamp>` or `?after_id=<external_id>`) where the cursor is the last-seen record's timestamp or ID.

**Application:** Store the cursor in a `sync_cursors` table keyed by `(job_name, external_system)`. Update the cursor only after each batch is successfully committed to the database.

**Source:** Designing Data-Intensive Applications (Kleppmann) — Ch. 11

---

## H4 — One Zod Schema Per Response Shape, Not Per Endpoint

**When to apply:** Defining Zod schema requirements for external API responses.

**Heuristic:** External APIs often return the same entity shape from multiple endpoints (list, get, create, update). Define one Zod schema per entity shape, not one per endpoint. Reuse the entity schema across endpoint parsers.

**Application:** In External_API_Assessment.md, define `ExternalContactSchema`, `ExternalOrderSchema`, etc. Document that each endpoint result is parsed with the corresponding entity schema.

**Source:** P4 — Zod at Every Boundary; TypeScript best practices

---

## H5 — Deduplication Key ≠ Idempotency Key

**When to apply:** Designing deduplication for ingested records.

**Heuristic:** The idempotency key (safe to re-execute the operation) and the deduplication key (same record should not be inserted twice) are often different. The idempotency key is operation-scoped (includes event type, timestamp). The deduplication key is record-scoped (the external entity's unique ID).

**Application:** For webhook ingestion, the idempotency key is `hash(event_id + webhook_delivery_id)`. The deduplication key is the entity's `externalId`. Both must be specified in the Sync_Strategy.md.

**Source:** Enterprise Integration Patterns (Hohpe & Woolf) — Idempotent Receiver pattern

---

## H6 — LGPD Trigger: Any Field That Could Identify a Natural Person

**When to apply:** Deciding whether to invoke the `data-privacy-risk-skill`.

**Heuristic:** If any of the following fields appear in a data mapping, trigger LGPD assessment immediately: name, email, phone, CPF, CNPJ (of individuals), address, date of birth, IP address, geolocation, health data, financial data, behavioral data, photos, biometrics. When in doubt, classify as PERSONAL and assess.

**Application:** Scan Data_Mapping.md field list against this trigger list before proceeding to sync strategy design. If any field matches, invoke `data-privacy-risk-skill` before continuing.

**Source:** LGPD Art. 5, I — Definition of Personal Data; Art. 11 — Sensitive Personal Data

---

## H7 — Retry with Jitter, Not Fixed Interval

**When to apply:** Specifying retry logic for external API calls.

**Heuristic:** Exponential backoff with jitter is always superior to fixed-interval retry. Fixed-interval retry causes "thundering herd" — all failed jobs retry at the same moment, generating a spike that overwhelms the external API and causes more failures. Jitter spreads the retries randomly within the backoff window.

**Application:** Specify retry strategy as: `delay = min(cap, base * 2^attempt) + random(0, jitter)`. Example: `base=1000ms, cap=30000ms, jitter=500ms`. Maximum 3 retries for synchronous paths; 5 retries for background jobs.

**Source:** Building Event-Driven Microservices (Bellemare) — Ch. 7: Retry and Backoff

---

## H8 — Circuit Breaker Threshold: 5 Failures in 60 Seconds

**When to apply:** Specifying circuit breaker configuration for external API clients.

**Heuristic:** A reasonable default circuit breaker threshold for external API integrations is 5 consecutive failures within a 60-second window. After this threshold, the circuit opens (stops calling the external API) for 30 seconds, then enters half-open state to test recovery. Adjust based on the API's documented SLA.

**Application:** Document in External_API_Assessment.md: `circuit_breaker: { failure_threshold: 5, window_seconds: 60, open_duration_seconds: 30 }`. This prevents cascading failures when an external dependency is degraded.

**Source:** Designing Data-Intensive Applications (Kleppmann) — Ch. 8: Distributed System Trouble

---

## H9 — Dead Letter = Quarantine Table, Not Log Entry

**When to apply:** Designing the disposition for records that exhaust all retries.

**Heuristic:** Records that fail processing after all retries should be moved to a `integration_quarantine` table, not just logged as errors. A log entry is transient and queryable only with effort. A quarantine table row is persistent, queryable, retryable, and auditable. It also gives operators a path to replay the record after the issue is fixed.

**Application:** Define `integration_quarantine` table schema in the Integration_Spec.md: `{ id, job_name, external_system, external_id, raw_payload, error_message, failed_at, retry_count, resolved_at }`. Specify a cron job to alert when `COUNT(*) > threshold`.

**Source:** Enterprise Integration Patterns (Hohpe & Woolf) — Dead Letter Channel pattern

---

## H10 — Data Lineage: Every Field Has a Source

**When to apply:** Producing Data_Mapping.md for a complex integration with derived or computed fields.

**Heuristic:** Every field in the target schema has exactly one documented source: direct mapping from external field, computation from multiple external fields, internal default value, or system-generated. "I'm not sure where this comes from" is not an acceptable answer in a data mapping document.

**Application:** Add a `source_type` column to Data_Mapping.md rows: `DIRECT | COMPUTED | DEFAULT | SYSTEM_GENERATED`. For COMPUTED rows, document the formula. For DEFAULT rows, document the value and the condition.

**Source:** Data Mesh (Dehghani) — Ch. 5: Data as a Product (data observability)

---

## H11 — Batch Size Sweet Spot: 100–500 Records

**When to apply:** Specifying batch size for a cron-based sync job.

**Heuristic:** For most external API integrations, a batch size of 100–500 records per API call balances throughput against memory pressure, rate limit consumption, and failure blast radius. Smaller batches mean more API calls (rate limit risk); larger batches mean higher memory usage and more records lost on failure.

**Application:** Default to `batch_size: 100` in Sync_Strategy.md. Increase to 500 for high-volume, low-complexity integrations. Decrease to 25 for integrations with aggressive rate limits or large record payloads.

**Source:** Fundamentals of Data Engineering (Reis & Housley) — Ch. 7: Batch vs Micro-Batch

---

## H12 — Webhook Replay: Always Test the Sad Path

**When to apply:** Specifying webhook ingestion design.

**Heuristic:** External webhook providers retry delivery when they receive a non-2xx response. Webhooks can arrive out of order, be delayed by hours, or be replayed during provider incidents. Design the webhook handler to handle each of these cases: duplicate event, out-of-order event, stale event.

**Application:** Specify in the Integration_Spec.md webhook section: (1) signature verification, (2) idempotency key from the event ID header, (3) timestamp staleness check (reject events older than 24 hours), (4) graceful handling of unknown event types (return 200, log, skip). Never return 5xx for unknown event types — it triggers retries.

**Source:** Building Event-Driven Microservices (Bellemare) — Ch. 4: Webhook Consumer

---

## H13 — ETL vs ELT Decision: Target Schema Flexibility

**When to apply:** Choosing between ETL and ELT pipeline patterns.

**Heuristic:** Use ETL when the target schema is defined (Prisma PostgreSQL) and transformations must happen before load. Use ELT when the target is a columnar data warehouse (BigQuery, Snowflake, Redshift) with native transformation compute. In the Golden Model (Next.js + Prisma + PostgreSQL), ETL is always the correct choice for the operational database. ELT is only relevant if a separate analytics layer exists.

**Application:** Default to ETL. Document in etl-planning-skill output: Extract (API), Transform (TypeScript job), Load (Prisma upsert). If an analytics warehouse is in scope, document the raw-layer ELT separately.

**Source:** Fundamentals of Data Engineering (Reis & Housley) — Ch. 8: ETL vs ELT

---

## H14 — Conflict Resolution: External Wins for Master Data, Internal Wins for Derived Data

**When to apply:** Specifying conflict resolution for bidirectional sync.

**Heuristic:** Fields that represent master data (contact details, product catalog, organizational hierarchy) — the external system (ERP, CRM) is usually the source of truth. External wins. Fields that our system derives, enriches, or computes (internal scores, preferences, calculated flags) — Internal wins. Fields that represent state (status, lifecycle stage) — require explicit policy: which system drives state transitions?

**Application:** In the Field Ownership Table, classify each field as MASTER_DATA, DERIVED, or STATE. Apply the heuristic to set the default `conflict_resolution` policy, then annotate exceptions.

**Source:** Data Mesh (Dehghani) — Ch. 4: Domain Data Ownership; Enterprise Integration Patterns (Hohpe & Woolf)

---

## H15 — LGPD Retention: Match the Shorter Period

**When to apply:** Specifying data retention for personal data in sync integrations.

**Heuristic:** When personal data exists in both the external system and our internal database, and the retention periods differ, apply the shorter retention period to our internal copy. If the external CRM retains contact data for 5 years but our legal obligation (or contractual basis) only requires 2 years, our system should delete or anonymize after 2 years.

**Application:** In `data-privacy-risk-skill` output, document both the external system's retention period and our internal retention period. Flag cases where our period is longer than legally required as a risk (MEDIUM or HIGH depending on data sensitivity).

**Source:** LGPD Art. 15 — Data retention; Art. 16 — Deletion after end of legal basis
