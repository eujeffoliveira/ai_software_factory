# Data Integration Risk Register

> **Document ID:** RISKS-[PROJ]-[NNN]
> **Integrations covered:** INT-[SYSTEM]-001, INT-[SYSTEM]-002
> **Produced by:** Agente10_DataIntegrationEngineer
> **Gate 3.5 submission date:** YYYY-MM-DD
> **Delivered to:** Agente00_TechLead, Agente07_DevSecOps

---

## Risk Summary

| Classification | Count | Blocking Gate 3.5 |
|---------------|-------|-------------------|
| CRITICAL | [N] | [N] |
| HIGH | [N] | [N] |
| MEDIUM | [N] | 0 |
| LOW | [N] | 0 |
| **Total** | **[N]** | **[N]** |

---

## RISK-001: [Risk Title]

| Field | Value |
|-------|-------|
| **Risk ID** | RISK-001 |
| **Risk Type** | LGPD_COMPLIANCE / IDEMPOTENCY / DATA_QUALITY / EXTERNAL_API_RELIABILITY / SECURITY / PERFORMANCE / DATA_LOSS / ARCHITECTURAL |
| **Classification** | CRITICAL / HIGH / MEDIUM / LOW |
| **Likelihood** | HIGH / MEDIUM / LOW |
| **Impact** | CRITICAL / HIGH / MEDIUM / LOW |
| **Affected Integration** | INT-[SYSTEM]-001 |
| **Blocks Gate 3.5** | Yes / No |
| **Escalate To** | Agente00_TechLead / Agente07_DevSecOps / client_dpo / none |

**Description:**
[Detailed description of the risk. What is the threat? What could go wrong? What is the potential business impact? Be specific — include which fields, which systems, and what the consequences are if the risk materializes.]

**Mitigation:**
[Concrete, actionable mitigation steps. Not "we should be careful" — specific technical or process controls that reduce the likelihood or impact. Include file paths, patterns, or rules where applicable.]

**Mitigation Status:** DEFINED / IN_PROGRESS / IMPLEMENTED / ACCEPTED / NONE

---

## RISK-002: [LGPD Risk Title — if applicable]

| Field | Value |
|-------|-------|
| **Risk ID** | RISK-002 |
| **Risk Type** | LGPD_COMPLIANCE |
| **Classification** | HIGH |
| **Likelihood** | HIGH |
| **Impact** | HIGH |
| **Affected Integration** | INT-[SYSTEM]-001 |
| **Blocks Gate 3.5** | Yes |
| **Escalate To** | Agente00_TechLead, client_dpo |

**Description:**
Integration INT-[SYSTEM]-001 syncs the following personal data fields from [external-system]: `[field1]` (PERSONAL), `[field2]` (PERSONAL). The legal basis for this processing is [CONSENT / CONTRACT / LEGITIMATE_INTEREST].

[Describe the specific LGPD risk: is the legal basis questionable? Is the retention period unclear? Is there a cross-border transfer? Is the DPA missing?]

**LGPD Detail:**

| Field | Value |
|-------|-------|
| PII fields involved | `[field1]`, `[field2]` |
| PII classification | PERSONAL |
| Legal basis | [CONSENT / CONTRACT / LEGAL_OBLIGATION / LEGITIMATE_INTEREST] |
| Legal basis documented | Yes / No |
| Data retention (internal) | [N] years |
| Data retention (external system) | [N] years / Unknown |
| Cross-border transfer | Yes (EU) / No / Unknown |
| DPA required | Yes / No |
| DPA status | Signed / Pending / Not required / Unknown |

**Mitigation:**
1. [Specific action: document legal basis in integration spec]
2. [Specific action: set retention policy and create deletion cron job]
3. [Specific action: ensure DPA is signed before go-live]
4. [Specific action: exclude [field] from sync_log and console.log]

**Mitigation Status:** DEFINED

---

## RISK-003: [External API Reliability Risk]

| Field | Value |
|-------|-------|
| **Risk ID** | RISK-003 |
| **Risk Type** | EXTERNAL_API_RELIABILITY |
| **Classification** | MEDIUM |
| **Likelihood** | MEDIUM |
| **Impact** | MEDIUM |
| **Affected Integration** | INT-[SYSTEM]-001 |
| **Blocks Gate 3.5** | No |
| **Escalate To** | none |

**Description:**
[External system] does not have a published SLA. Historical reliability is unknown. The integration topology is polling, so a provider outage causes data staleness but not data corruption. Peak usage windows may cause increased latency.

**Mitigation:**
1. Implement circuit breaker (5 failures / 60s threshold) in `lib/integrations/[system].client.ts`
2. Add retry with exponential backoff (3 attempts, jitter)
3. Monitor `sync_log.status = "error"` — alert on 3 consecutive failures
4. Design sync to be resumable from cursor — no data is lost on outage, just delayed

**Mitigation Status:** DEFINED

---

## RISK-004: [Idempotency Risk — template example]

| Field | Value |
|-------|-------|
| **Risk ID** | RISK-004 |
| **Risk Type** | IDEMPOTENCY |
| **Classification** | HIGH |
| **Likelihood** | MEDIUM |
| **Impact** | HIGH |
| **Affected Integration** | INT-[SYSTEM]-001 |
| **Blocks Gate 3.5** | Yes (if not mitigated) |
| **Escalate To** | none |

**Description:**
If the cron job for INT-[SYSTEM]-001 is retried by Vercel after a timeout (functions can timeout after 10s by default), duplicate records may be created without idempotency protection.

**Mitigation:**
Upsert strategy using `externalId` as the unique key: `prisma.[model].upsert({ where: { externalId }, ... })`. This ensures that any number of retries produces the same result. The `externalId` field has a `@unique` constraint in the Prisma schema.

**Mitigation Status:** DEFINED

---

## Open Risk Actions

| Risk ID | Action Required | Owner | Due |
|---------|----------------|-------|-----|
| RISK-002 | Client DPO to sign DPA with [external system] | client_dpo | Before go-live |
| RISK-002 | Document consent flow in product spec | Agente01_ProductOwner | Before Gate 3.5 |
| [RISK-NNN] | [Action] | [owner] | [timing] |

---

*Produced by Agente10_DataIntegrationEngineer using templates/Data_Risks.md*
*Shared with: Agente00_TechLead, Agente07_DevSecOps*
