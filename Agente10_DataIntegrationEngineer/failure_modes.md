# Agente10_DataIntegrationEngineer — Failure Modes

This document catalogs the 10 known failure modes for the Data Integration Engineer agent. Each entry includes the failure mode ID, symptom (how to detect it), root cause, corrective action, prevention rule, and gate impact.

---

## FM-01: Non-Idempotent Sync

**ID:** FM-01
**Name:** Non-Idempotent Sync Operation

**Symptom:** Integration spec calls for `prisma.model.create()` inside a cron job or webhook handler without an existence check. Alternatively, the spec describes inserting a record without specifying an upsert key or processed-events mechanism. Duplicate records appear in production after a retry or network hiccup causes double execution.

**Root Cause:** Designer assumed the job would run exactly once, overlooking that Vercel Cron retries on function timeout, network errors can cause webhook re-delivery, and manual re-runs are common during incident recovery.

**Impact:** Duplicate records in the database. Downstream reports count the same event twice. Financial calculations are wrong. Data cleanup is expensive and error-prone.

**Corrective Action:**
1. Replace all `create` calls in sync jobs with `upsert` using the external system's unique ID as the where clause
2. Define the idempotency key field in the Sync_Strategy.md
3. Invoke `idempotent-sync-design-skill` to produce a complete idempotency design
4. Verify the updated spec with `sync_idempotency_checklist.md`

**Prevention Rule:** No sync operation may be specified with `create` without an upsert alternative. Every sync spec must include a "Idempotency Strategy" section before Gate 3.5 review.

**Gate Impact:** **Blocks Gate 3.5** — status code `BLOCKED_MISSING_IDEMPOTENCY`

---

## FM-02: PII Without Legal Basis

**ID:** FM-02
**Name:** Personal Data Flow Without Documented Legal Basis

**Symptom:** Integration spec includes fields classified as PERSONAL or SENSITIVE PII (name, email, CPF, phone, health data) in a data mapping or sync job, but no LGPD legal basis is documented. `Data_Risks.md` either does not exist or does not include LGPD entries for those fields. The `data-privacy-risk-skill` was not invoked.

**Root Cause:** Integration was designed for functional requirements only, without considering data privacy obligations. "We'll handle compliance later" deferred the legal analysis. Designer was unaware of which fields constitute PII under LGPD.

**Impact:** LGPD violation — Lei 13.709/2018, Art. 7. Potential regulatory fine up to 2% of revenue, capped at R$50M per violation. Reputational damage. Data subject rights cannot be exercised if the processing basis is not documented.

**Corrective Action:**
1. Halt integration design immediately upon identifying PII without legal basis
2. Escalate to Agente00_TechLead — this is a CRITICAL blocker
3. Invoke `data-privacy-risk-skill` to complete the LGPD assessment
4. Establish the legal basis with the organization's data protection officer (DPO)
5. If no legal basis can be established, remove the PII fields from the integration scope

**Prevention Rule:** Before designing any data mapping, run the PII field inventory step from `data_privacy_risk_checklist.md`. Any field containing personal data triggers mandatory LGPD assessment.

**Gate Impact:** **Blocks Gate 3.5** — status code `BLOCKED_LGPD_VIOLATION`. Escalation to Agente00_TechLead required.

---

## FM-03: Missing Zod on External Response

**ID:** FM-03
**Name:** External API Response Without Zod Validation Requirement

**Symptom:** Integration spec or External_API_Assessment.md describes an external API client that uses the response directly without specifying a Zod schema requirement. The spec shows `const data = await response.json()` or `as SomeType` type assertion instead of `SomeSchema.parse(await response.json())`.

**Root Cause:** Designer trusted the external API to always return the documented shape, forgetting that external APIs change without warning, return partial data on errors, or send undocumented fields that cause runtime failures.

**Impact:** Runtime type errors when the external API returns unexpected data. Malformed data silently persists to the database. Debugging is difficult because the failure occurs far from the validation point.

**Corrective Action:**
1. Add a "Zod Schema Requirements" section to the External_API_Assessment.md for the affected API
2. Define the minimum required fields (not all fields — use `.passthrough()` for unknown fields)
3. Specify that the schema must be validated using `.parse()` or `.safeParse()` before any use of the response data
4. Run `external_api_checklist.md` item "Zod schema defined for all response shapes"

**Prevention Rule:** Every external API response must have a corresponding Zod schema requirement in the integration spec. No integration spec is complete without it.

**Gate Impact:** **Blocks Gate 3.5** — status code `BLOCKED_MISSING_ZOD`

---

## FM-04: Sync Inside Prisma Transaction

**ID:** FM-04
**Name:** External API Call Specified Inside a Prisma Transaction

**Symptom:** Integration spec includes a workflow where an external API call (HTTP request to a third-party service) is wrapped inside a Prisma `$transaction()` block. The spec shows the external call as a step between `prisma.$transaction.begin()` and `prisma.$transaction.commit()`.

**Root Cause:** Designer was trying to ensure atomicity: "if the external call fails, the DB write should roll back." While the intent is valid, the implementation violates the database transaction isolation principle — Prisma transactions hold a database connection open for their entire duration, and external HTTP calls can take seconds or minutes.

**Impact:** Database connection pool exhaustion. Deadlocks when multiple transactions wait for external services. Degraded system performance under load. In the worst case, the system becomes unresponsive because all DB connections are held by transactions waiting for slow external APIs.

**Corrective Action:**
1. Restructure the spec to follow the correct pattern:
   - Step 1: Call external API (outside any transaction)
   - Step 2: Validate the response with Zod
   - Step 3: Open Prisma transaction and persist the result
   - Step 4: Close transaction
2. Handle the case where the external call succeeds but the DB write fails (retry the DB write, log the external call result for replay)
3. Update the Integration_Spec.md sequence diagram to show the correct order

**Prevention Rule:** External API calls and Prisma transactions are mutually exclusive execution contexts. The spec must never place them inside the same boundary.

**Gate Impact:** **Blocks Gate 3.5** — status code `BLOCKED_TRANSACTION_VIOLATION`

---

## FM-05: Missing sync_log

**ID:** FM-05
**Name:** Automated Sync Job Without sync_log Specification

**Symptom:** Sync_Strategy.md for a cron job or automated sync does not include a "Sync Log" section defining the `syncLog()` call fields. The spec shows the job logic but omits the observability requirement. Alternatively, the spec shows `syncLog()` only on the success path, not in a `finally` block.

**Root Cause:** Observability treated as optional or deferred. Designer focused on the happy path and forgot that failed jobs must also be logged (especially important for debugging production incidents).

**Impact:** Silent failures in production. When a sync job fails, there is no record of what was processed, how many records were affected, or when the failure occurred. Operators cannot distinguish "job ran and failed" from "job never ran." Data drift goes undetected.

**Corrective Action:**
1. Add a "Sync Log" section to the Sync_Strategy.md with the complete `syncLog()` fields:
   - `job`: kebab-case job identifier
   - `executedAt`: UTC execution start timestamp
   - `durationMs`: wall-clock duration
   - `status`: `success` | `error` | `partial`
   - `counts`: `{ processed, created, updated, skipped, errors }`
   - `errorMsg`: error message (only when status is error/partial)
2. Specify that `syncLog()` must be called in a `finally` block — not just in success/error branches
3. Run `sync_idempotency_checklist.md` item "sync_log in finally block specified"

**Prevention Rule:** Every sync job spec must include a Sync Log section. "In the finally block" must be explicitly stated in the spec.

**Gate Impact:** **Blocks Gate 3.5** — status code `BLOCKED_MISSING_SYNC_LOG`

---

## FM-06: Hardcoded Credentials

**ID:** FM-06
**Name:** API Keys or Secrets Hardcoded in Integration Specification

**Symptom:** Integration_Spec.md or External_API_Assessment.md contains literal API key values, bearer tokens, passwords, or secret strings. Alternatively, the client specification shows `Authorization: Bearer sk-actual-key-value-here` instead of `Authorization: Bearer ${env.SERVICE_API_KEY}`.

**Root Cause:** Designer copied the API key from a test environment directly into the spec for illustration purposes, not realizing that spec documents are committed to version control and reviewed by multiple agents.

**Impact:** Secret exposure in version control history. Even if the literal is later removed, it may remain in git history. Rotating the key requires updating the spec document, creating a maintenance burden. Secrets in specs cannot be managed by secret management systems.

**Corrective Action:**
1. Replace all literal credential values with `env.VARIABLE_NAME` references
2. Add the environment variable name to the "Environment Variables Required" section of the Integration_Spec.md
3. Specify that the variable must be defined in `lib/env.ts` using Zod
4. If the literal was already committed, rotate the actual credential immediately

**Prevention Rule:** Integration specs never contain literal credentials. All credential references use `env.VARIABLE_NAME` format. The spec documents the variable name, not the value.

**Gate Impact:** **Blocks Gate 3.5** — status code `BLOCKED_CREDENTIAL_VIOLATION`

---

## FM-07: Missing Error Handling on External Call

**ID:** FM-07
**Name:** External API Call Without Error Handling Specification

**Symptom:** Integration spec shows an external API call sequence without specifying what happens when the call fails (non-2xx response, timeout, network error). No retry logic, no timeout value, no circuit breaker threshold, and no dead letter disposition is documented.

**Root Cause:** Designer assumed the external API would always succeed. Error handling deferred to "the implementation team will figure it out," resulting in undefined behavior in the spec.

**Impact:** Unhandled rejections crash the job. Timeout causes the job to hang indefinitely, consuming a serverless function slot. Retried jobs without backoff cause retry storms that worsen external API degradation. Failed records are silently lost.

**Corrective Action:**
1. Add an "Error Handling" section to the External_API_Assessment.md and Sync_Strategy.md:
   - Timeout: specify milliseconds (default: 10,000ms)
   - Retry: specify max attempts and backoff strategy (exponential, with jitter)
   - Circuit breaker: specify failure threshold before opening circuit
   - Dead letter: specify disposition for records that exhaust retries (quarantine table, alert, skip with log)
2. Specify that HTTP errors (4xx, 5xx) are caught and logged with structured error context
3. Run `external_api_checklist.md` item "Error handling strategy defined"

**Prevention Rule:** Every external API call in the spec must have a corresponding error handling section. No API call specification is complete without timeout, retry, and dead letter disposition.

**Gate Impact:** Does not block Gate 3.5 by itself, but becomes blocking if classified as HIGH risk in `Data_Risks.md`.

---

## FM-08: Bidirectional Conflict Not Handled

**ID:** FM-08
**Name:** Bidirectional Sync Without Conflict Resolution Policy

**Symptom:** `Data_Mapping.md` documents a bidirectional sync (data flows both directions) but does not specify a conflict resolution policy. The mapping does not declare which system owns each field. "Last write wins" is not stated — it is simply assumed or absent.

**Root Cause:** Designer specified the happy-path sync flow without considering that both systems may update the same record simultaneously, creating a conflict that must be resolved deterministically.

**Impact:** Data corruption when simultaneous updates occur. One system's write silently overwrites the other's. Debugging is nearly impossible because both writes look valid independently. In financial systems, this can cause balance discrepancies or duplicate charges.

**Corrective Action:**
1. Add a "Field Ownership Table" to the Data_Mapping.md declaring the authoritative system for each field
2. Specify the conflict resolution strategy for each field class:
   - `EXTERNAL_WINS`: External system is always authoritative (overwrite internal)
   - `INTERNAL_WINS`: Internal system is always authoritative (do not overwrite with external)
   - `LAST_WRITE_WINS`: Compare `updated_at` timestamps, most recent wins
   - `MERGE`: Specific merge rule documented per field
3. Specify how conflicts are detected (timestamp comparison, version counter, ETag)
4. Run `data_mapping_checklist.md` item "Conflict resolution policy defined for bidirectional fields"

**Prevention Rule:** Every bidirectional mapping must include a Field Ownership Table and conflict resolution policy before Gate 3.5.

**Gate Impact:** Does not block Gate 3.5 directly, but triggers BLOCKED_UNMITIGATED_CRITICAL_RISK if the conflict scenario is assessed as CRITICAL.

---

## FM-09: Missing Data Quality Checks

**ID:** FM-09
**Name:** Integration Spec Without Data Quality Acceptance Criteria

**Symptom:** Integration_Spec.md and Sync_Strategy.md do not include a data quality section. There is no `Data_Quality_Checklist.md`. The spec assumes all incoming records are valid and does not define what happens with incomplete, malformed, or duplicate records.

**Root Cause:** Data quality treated as an implementation detail rather than a design requirement. Designer focused on the integration topology without specifying the acceptance criteria that make the integration reliable.

**Impact:** Malformed records silently persist to the database, corrupting downstream reports and features. Incomplete records cause runtime errors in business logic that expect required fields. Duplicate records inflate counts and analytics.

**Corrective Action:**
1. Invoke `data-quality-validation-skill` to produce `Data_Quality_Checklist.md`
2. Define field-level validation rules for all ingested fields
3. Specify the record disposition policy (accept / accept-with-flag / quarantine / reject / skip)
4. Add quality dimension metrics to the sync_log `counts` object
5. Specify the alert threshold for quality failures

**Prevention Rule:** Every integration that ingests external data must have a `Data_Quality_Checklist.md` before the integration spec is considered complete.

**Gate Impact:** Recommended but not blocking for Gate 3.5 unless the integration involves HIGH-volume critical data flows. In those cases, becomes blocking.

---

## FM-10: Scope Creep — Undocumented Endpoints

**ID:** FM-10
**Name:** Integration Spec Includes API Endpoints Not in Architecture Contract

**Symptom:** Integration_Spec.md specifies API endpoints, data fields, or capabilities from an external system that were not mentioned in `Architecture.md` or `API_Contract.json`. New endpoints were added because they seemed useful or were discovered during API documentation review.

**Root Cause:** Data Integration Engineer expanded scope beyond the requirements during the design phase, adding "bonus" integrations that were not discussed with the Product Owner or Architect. This is the integration-design equivalent of feature creep.

**Impact:** Implementation effort exceeds estimates. New endpoints introduce untested surface area. External API calls incur unexpected rate limit consumption or costs. Downstream agents (Agente03, Agente04) receive tasks for functionality not in the product requirements.

**Corrective Action:**
1. Remove all endpoints, fields, and capabilities not explicitly required by `Architecture.md` or `Integration_Requirements.md`
2. Document the discovered additional capabilities as "Out of Scope" in the External_API_Assessment.md as future options
3. If the additional capability genuinely addresses a requirement, escalate to Agente00_TechLead to determine if the scope change is approved before including it in the spec
4. Never add endpoints without explicit requirements traceability

**Prevention Rule:** Every integration endpoint or data field in the spec must trace to a requirement in `Architecture.md` or `Integration_Requirements.md`. The traceability column in Data_Mapping.md enforces this.

**Gate Impact:** Does not block Gate 3.5, but RETURNED_FOR_REVISION if scope creep affects the Architecture.md integration surface definition.
