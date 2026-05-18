# Agente10_DataIntegrationEngineer — Decision Rules

> If-then rules for integration design decisions. Rules are numbered DR001–DR020. Each rule specifies the condition that triggers it and the action to take. Applied mechanically — no interpretation required.

---

## DR001 — Webhook vs Polling Topology

**Condition:** External system supports webhooks with HMAC signature verification AND expected event volume is under 50,000 events/day AND real-time latency is required (< 5 minutes).

**Action:** Specify webhook topology as primary. Add daily reconciliation cron job as fallback to catch missed events.

**Source:** H2; Building Event-Driven Microservices (Bellemare) — Ch. 5

---

## DR002 — Polling Topology When Webhook Not Available

**Condition:** External system does NOT support webhooks OR has no signature verification mechanism OR event volume exceeds 50,000/day.

**Action:** Specify polling topology with cursor-based pagination. Define cron schedule based on latency requirements: near-real-time → every 5 minutes; acceptable latency → hourly or daily.

**Source:** H2; H3; Fundamentals of Data Engineering (Reis & Housley) — Ch. 7

---

## DR003 — Upsert Required for All Create Operations in Sync Jobs

**Condition:** A sync job creates or updates records in the internal database.

**Action:** Always specify `upsert` with external system's unique ID as the where clause. Never specify plain `create`. Document the idempotency key field name in Sync_Strategy.md.

**Source:** P1; H1; DR003 is always active — no exceptions

---

## DR004 — LGPD Assessment Required

**Condition:** Any field in the Data_Mapping.md list includes: name, email, phone, CPF, CNPJ (individual), address, date of birth, IP address, geolocation, health data, financial data, behavioral/usage data, photo, biometric data, or any field that could identify a natural person.

**Action:** Invoke `data-privacy-risk-skill` immediately. Do not proceed with sync strategy design until LGPD assessment is complete and legal basis is documented.

**Source:** P2; H6; LGPD Art. 5, Art. 7, Art. 11

---

## DR005 — Sensitive PII Requires Explicit Consent

**Condition:** A data flow involves SENSITIVE PII (health data, biometrics, ethnicity, religion, political opinion, sexual orientation, criminal record, financial data classified as sensitive by the organization's DPO).

**Action:** Legal basis must be CONSENT. No other LGPD legal basis is sufficient for sensitive data flows. If consent cannot be obtained or documented, the field must be excluded from the integration scope. Escalate to Agente00_TechLead.

**Source:** P2; LGPD Art. 11 — Sensitive Personal Data

---

## DR006 — Cursor Pagination Required Above 1,000 Records

**Condition:** A sync job is estimated to process more than 1,000 records per run.

**Action:** Specify cursor-based pagination strategy in Sync_Strategy.md. Define cursor storage mechanism (`sync_cursors` table or equivalent). Define batch size (default: 100; adjust based on API rate limits and payload size). Prohibit offset-based pagination (`?page=N`).

**Source:** H3; H11; Designing Data-Intensive Applications (Kleppmann) — Ch. 11

---

## DR007 — Message Queue Recommended Above 100,000 Events/Day

**Condition:** Expected data volume exceeds 100,000 events/day OR multiple internal services need to consume the same external events.

**Action:** Recommend message queue architecture (e.g., Redis Queue, BullMQ, or Supabase Realtime for internal events) to Agente00_TechLead and Agente02_SoftwareArchitect. Document the recommendation in External_API_Assessment.md as a scaling consideration. Do not design queue infrastructure unilaterally — this requires architectural approval.

**Source:** Building Event-Driven Microservices (Bellemare) — Ch. 2: Event-Driven Architecture

---

## DR008 — Conflict Resolution Policy Required for Bidirectional Sync

**Condition:** A data flow is bidirectional — data flows from external system to internal AND from internal to external for the same entity type.

**Action:** Produce a Field Ownership Table in Data_Mapping.md declaring the authoritative system for each field. Specify conflict resolution strategy (EXTERNAL_WINS / INTERNAL_WINS / LAST_WRITE_WINS / MERGE) per field class. Gate 3.5 review requires this table.

**Source:** P3; H14; Enterprise Integration Patterns (Hohpe & Woolf)

---

## DR009 — Block: PII Without Legal Basis

**Condition:** PII field appears in Data_Mapping.md AND no legal basis is documented in Data_Risks.md.

**Action:** STOP. Do not produce Sync_Strategy.md. Add RISK-NNN entry to Data_Risks.md with classification CRITICAL. Escalate to Agente00_TechLead. Gate 3.5 status: BLOCKED_LGPD_VIOLATION.

**Source:** P2; LGPD Art. 7

---

## DR010 — Block: Missing Idempotency Key on Sync

**Condition:** Sync_Strategy.md describes a cron job or webhook handler that creates or updates records WITHOUT specifying an idempotency mechanism.

**Action:** STOP. Invoke `idempotent-sync-design-skill`. Do not advance to Gate 3.5 until the idempotency strategy is defined. Gate 3.5 status: BLOCKED_MISSING_IDEMPOTENCY.

**Source:** P1; FM-01

---

## DR011 — Block: External Call Inside Transaction

**Condition:** Integration spec describes calling an external API (HTTP request to outside the system) inside a Prisma `$transaction()` block.

**Action:** STOP. Restructure the spec: call external API first (outside transaction), validate response with Zod, then open transaction to persist results. Gate 3.5 status: BLOCKED_TRANSACTION_VIOLATION.

**Source:** P6; FM-04; Agente04_DevBackend principles

---

## DR012 — Zod Schema for Every External API Response

**Condition:** Integration spec references a response from an external API.

**Action:** Define Zod schema requirements for the response shape in External_API_Assessment.md. Include minimum required fields. Use `.passthrough()` for unknown fields unless API version is pinned and stable. Gate 3.5 blocks without this.

**Source:** P4; FM-03

---

## DR013 — sync_log Required for Every Automated Job

**Condition:** Sync_Strategy.md describes any automated sync mechanism (cron job, event consumer, webhook processor).

**Action:** Add "Sync Log" section to Sync_Strategy.md defining `syncLog()` call fields: `job`, `executedAt`, `durationMs`, `status`, `counts`, `errorMsg`. Specify `finally` block placement. Gate 3.5 blocks without this.

**Source:** P5; FM-05; Agente04_DevBackend P6

---

## DR014 — ETL Pattern for Operational DB, ELT for Analytics

**Condition:** Deciding between ETL and ELT pipeline design.

**Action:** If target database is PostgreSQL via Prisma (Golden Model operational DB), use ETL: extract from API, transform in TypeScript job, load via Prisma upsert. If target is a columnar analytics warehouse (BigQuery, Snowflake), use ELT: load raw to staging, transform with SQL/dbt. Never apply ELT pattern to the operational Prisma database.

**Source:** H13; Fundamentals of Data Engineering (Reis & Housley) — Ch. 8

---

## DR015 — Rate Limit: Honor Retry-After Header

**Condition:** External API returns HTTP 429 (Too Many Requests) with a `Retry-After` header.

**Action:** Specify in External_API_Assessment.md that the client must parse the `Retry-After` header value and pause for that duration before retrying. Do not use fixed backoff when the API explicitly communicates the retry window. Document the API's rate limit in requests/minute or requests/day.

**Source:** H7; Enterprise Integration Patterns (Hohpe & Woolf) — Throttling

---

## DR016 — Webhook Signature Verification: Mandatory

**Condition:** Integration spec includes a webhook endpoint (`app/api/webhooks/[provider]/route.ts`).

**Action:** Specify webhook signature verification as a mandatory first step in the endpoint logic. Document the verification algorithm (typically HMAC-SHA256 with a shared secret from `lib/env.ts`). Endpoints that proceed without valid signature must return HTTP 401. No exceptions.

**Source:** H12; Agente07_DevSecOps security requirements

---

## DR017 — Dead Letter Queue for Failed Records

**Condition:** A sync job or webhook handler processes records that may fail validation or processing.

**Action:** Specify a dead letter mechanism in Sync_Strategy.md. Default: `integration_quarantine` table row with fields `{ id, job_name, external_system, external_id, raw_payload, error_message, failed_at, retry_count }`. Count dead-lettered records in `sync_log.counts.errors`. Alert when count exceeds configured threshold.

**Source:** H9; Enterprise Integration Patterns (Hohpe & Woolf) — Dead Letter Channel

---

## DR018 — API Versioning: Pin the Version in Client Base URL

**Condition:** External API uses URL-based versioning (e.g., `/api/v2/`) or header-based versioning.

**Action:** Hardcode the API version in the client base URL: `${env.SERVICE_BASE_URL}/v2/`. Document the API version being targeted in External_API_Assessment.md. Define the upgrade policy: when the provider releases v3, an ADR is required before the client is updated.

**Source:** P7; Fundamentals of Data Engineering (Reis & Housley)

---

## DR019 — Data Retention: Apply Shorter Period to Internal Copy

**Condition:** Personal data is synced from an external system with a different retention period than our internal legal obligation.

**Action:** Apply the shorter retention period to the internal database copy. Document both retention periods in `data-privacy-risk-skill` output. If our internal period is longer than legally required, flag as MEDIUM risk and recommend a deletion cron job.

**Source:** H15; LGPD Art. 15, Art. 16

---

## DR020 — Escalate: New Integration Service Not in Golden Model

**Condition:** Integration requires a service, library, or infrastructure component that is not in the Golden Model (e.g., a message queue platform, a new database, a CDC tool not currently approved).

**Action:** STOP. Do not design integration topology requiring the new service. Document the requirement in External_API_Assessment.md as a "Pending Architecture Decision." Escalate to Agente00_TechLead for an ADR. Gate 3.5 will be APPROVED_WITH_CONDITIONS pending the ADR decision.

**Source:** CLAUDE.md — Golden Model deviations require ADR; Agente00_TechLead governance
