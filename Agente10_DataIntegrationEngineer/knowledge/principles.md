# Agente10_DataIntegrationEngineer — Operating Principles

> Distilled from build-time bibliography and reference architecture. These principles govern every integration design decision made at runtime. Do not consult raw sources at runtime.

---

## P1 — Idempotency First

**Source:** Designing Data-Intensive Applications (Kleppmann) — Ch. 11: Stream Processing; Fundamentals of Data Engineering (Reis & Housley) — Ch. 7: Serving Data

Every sync operation must produce the same result when executed once or multiple times with the same input. This is not an optimization — it is a correctness requirement. Distributed systems guarantee at-least-once delivery; consumers must compensate for duplicates.

**Applied rule:** Use `upsert` with the external system's unique ID as the primary idempotency mechanism. Store the idempotency key in a `processed_events` table when the operation has side effects beyond database writes. Never design a sync job that relies on "this will only be called once."

**Violation signature:** `prisma.model.create()` in a cron job or webhook handler without an existence check.
**Correct form:** `prisma.model.upsert({ where: { externalId }, create: {...}, update: {...} })`

**Gate enforcement:** Gate 3.5 BLOCKED_MISSING_IDEMPOTENCY if any sync spec violates this principle.

---

## P2 — Data Privacy by Design

**Source:** Lei Geral de Proteção de Dados (LGPD — Lei 13.709/2018), Art. 7; GDPR Article 25 (Privacy by Design)

Privacy is not a feature added after integration design is complete. It is a design constraint applied from the first field mapping decision. The question is not "did we think about privacy?" but "what is the documented legal basis for each personal data flow?"

**Applied rule:** Before mapping any field, classify it (SENSITIVE / PERSONAL / PSEUDONYMIZED / ANONYMOUS). For PERSONAL or SENSITIVE fields, document the LGPD legal basis before the integration spec is considered complete. If no legal basis can be established, the field cannot be synced.

**Violation signature:** PII field appears in Data_Mapping.md without a corresponding entry in the LGPD section of Data_Risks.md.
**Correct form:** Every PERSONAL field has a `legal_basis` column in Data_Mapping.md and a corresponding RISK-NNN entry in Data_Risks.md.

**Gate enforcement:** Gate 3.5 BLOCKED_LGPD_VIOLATION if any personal data flow lacks documented legal basis.

---

## P3 — Source of Truth Ownership

**Source:** Data Mesh (Dehghani) — Ch. 4: Domain Data Ownership; Enterprise Integration Patterns (Hohpe & Woolf) — Ch. 5: Message Routing

Every data field has exactly one authoritative system. In a multi-system landscape, allowing multiple systems to update the same field without a declared owner creates a race condition that eventually corrupts the data. Ownership must be declared, not inferred.

**Applied rule:** Every field in a bidirectional sync must have a declared owner system and a conflict resolution rule. The Field Ownership Table is mandatory in Data_Mapping.md for any bidirectional integration. Unowned fields are a design defect.

**Violation signature:** Bidirectional Data_Mapping.md without a "Field Ownership" column or conflict resolution section.
**Correct form:** Each field row has `owner: EXTERNAL | INTERNAL | COMPUTED` and `conflict_resolution: EXTERNAL_WINS | INTERNAL_WINS | LAST_WRITE_WINS | MERGE`.

---

## P4 — Zod at Every Boundary

**Source:** Fundamentals of Data Engineering (Reis & Housley) — Ch. 6: Storage; Agente04_DevBackend P2

External API responses cross a trust boundary. The API contract is a promise, not a guarantee. External systems add fields, remove fields, change types, and return null where they previously returned a value — all without warning. Validation at the boundary catches these changes before they corrupt the database.

**Applied rule:** Every external API response must be validated with a Zod schema before any field is accessed. The schema must be defined at module level. Use `.passthrough()` for fields not yet mapped (do not reject unknown fields — forward compatibility). Use `.strict()` only when the API contract is fully stable and versioned.

**Violation signature:** Integration spec shows `response.json()` without Zod validation.
**Correct form:** `const validated = ExternalResponseSchema.parse(await response.json())` — where `ExternalResponseSchema` is a Zod object schema with at minimum all required fields.

**Gate enforcement:** Gate 3.5 BLOCKED_MISSING_ZOD if any external API client spec lacks Zod schema requirements.

---

## P5 — Sync Observability

**Source:** Fundamentals of Data Engineering (Reis & Housley) — Ch. 9: Pipeline Observability; Agente04_DevBackend P6

A sync job that cannot be monitored is a liability. Operators need to know: did the job run? How many records were processed? Did it fail? How long did it take? Without this data, production incidents take hours to diagnose instead of minutes.

**Applied rule:** Every automated sync job must produce a `sync_log` entry via `syncLog({ job, executedAt, durationMs, status, counts, errorMsg })`. The call must be in a `finally` block — so it records execution even when the job fails. The `counts` object must include: `{ processed, created, updated, skipped, errors }`.

**Violation signature:** Sync_Strategy.md without a "Sync Log" section. Cron job spec without `finally { syncLog(...) }`.
**Correct form:** Sync_Strategy.md includes sync_log field definitions and specifies the `finally` placement.

**Gate enforcement:** Gate 3.5 BLOCKED_MISSING_SYNC_LOG if any automated sync job lacks sync_log spec.

---

## P6 — Decoupled Integration

**Source:** Building Event-Driven Microservices (Bellemare) — Ch. 3: Event-Driven Architecture; Enterprise Integration Patterns (Hohpe & Woolf) — Ch. 3: Message Channel

External integration clients are infrastructure-level components, not business logic. They belong at `lib/integrations/[service].client.ts`, isolated from the domain layer. This isolation makes them testable (mock the client, not the HTTP layer), replaceable (swap the provider without touching features), and observable (single location for retry/circuit breaker logic).

**Applied rule:** Every integration spec must specify the client file path as `lib/integrations/[service].client.ts`. No direct `fetch()` calls in Server Actions, Route Handlers, or anywhere in `features/`. No external API calls inside Prisma `$transaction()` blocks.

**Violation signature:** Spec shows `fetch('https://external-api.example.com/...')` in a Server Action or inside a Prisma transaction.
**Correct form:** Spec shows `import { serviceClient } from '@/lib/integrations/service.client'` and calls `serviceClient.getResource(id)`.

---

## P7 — Forward-Compatible Contracts

**Source:** Designing Data-Intensive Applications (Kleppmann) — Ch. 4: Encoding and Evolution

External APIs change. New fields are added, deprecated fields return null, error formats change, authentication methods rotate. A rigid integration breaks when the API evolves. A forward-compatible integration degrades gracefully.

**Applied rule:** Integration specs must include: (1) the API version being targeted, (2) a list of minimum required fields (the spec must survive the addition of new optional fields), (3) Zod `.passthrough()` for unknown fields by default, (4) a degradation plan for when required fields are missing. Pin the API version in the client base URL when the provider supports versioning.

**Violation signature:** Integration spec assumes all documented API fields will always be present. No version pinning. Zod schema uses `.strict()` on an unstable external API.
**Correct form:** Client path includes version (`/api/v2/`). Zod schema uses `.passthrough()`. Required fields are explicitly listed as the minimum viable set.

---

## P8 — Data Quality Gates

**Source:** Fundamentals of Data Engineering (Reis & Housley) — Ch. 8: Data Validation; Data Mesh (Dehghani) — Ch. 5: Data as a Product

Garbage in, garbage out. An integration that persists low-quality data produces a database full of garbage that corrupts downstream features and reports. Data quality must be checked and enforced at ingestion time, before data reaches the database.

**Applied rule:** Every ingestion integration must have a `Data_Quality_Checklist.md` defining: required fields, format constraints, uniqueness rules, and record disposition policy (accept / quarantine / reject). Failed records are never silently dropped — they are counted in `sync_log.counts.errors` and moved to a quarantine mechanism.

**Violation signature:** Integration spec with no mention of data quality checks. Records with missing required fields silently skipped.
**Correct form:** `Data_Quality_Checklist.md` exists. Disposition policy defined. Quality failures counted in `counts.errors`. Alert threshold specified.

---

## P9 — Explicit Dependency Direction

**Source:** Data Mesh (Dehghani) — Ch. 6: Data Mesh Architecture; Enterprise Integration Patterns (Hohpe & Woolf) — Ch. 8: Message Router

Integration flows must form a directed acyclic graph (DAG). Circular dependencies between systems — where System A depends on System B which depends on System A — are integration anti-patterns that create deadlocks, data loops, and cascading failures.

**Applied rule:** Every integration spec must explicitly state the dependency direction: which system is upstream (source) and which is downstream (consumer). Integration maps are drawn as directed graphs. If a proposed integration creates a cycle in the dependency graph, stop and escalate to Agente00_TechLead before continuing.

**Violation signature:** Integration spec describes System A pushing to System B while System B pushes to System A on the same entity without conflict resolution — a logical cycle.
**Correct form:** Data_Mapping.md field ownership table declares one system as authoritative for each field, breaking the apparent cycle.

---

## P10 — Fail Fast, Log Always

**Source:** Designing Data-Intensive Applications (Kleppmann) — Ch. 8: Distributed System Trouble; Building Event-Driven Microservices (Bellemare) — Ch. 7: Error Handling

A failing integration that announces its failure loudly allows operators to respond quickly. A failing integration that silently swallows errors corrupts data for hours before anyone notices. External calls must have configured timeouts (never unlimited), retry limits with exponential backoff, and structured error logs that include the operation, external system name, and relevant context.

**Applied rule:** Every external API call in the spec must have: (1) timeout in milliseconds (default: 10,000ms), (2) retry configuration (max 3 retries, exponential backoff starting at 1s), (3) circuit breaker threshold, (4) structured error log specification including `job`, `externalSystem`, `operation`, and sanitized error context (no PII in logs). Errors that exhaust retries go to a dead letter queue or quarantine table — never silently discarded.

**Violation signature:** External API call in spec with no timeout, no retry logic, no error handling specification.
**Correct form:** Error handling section in External_API_Assessment.md with timeout, retry, circuit breaker, and dead letter disposition.
