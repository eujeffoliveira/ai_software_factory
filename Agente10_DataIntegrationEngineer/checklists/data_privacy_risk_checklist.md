# Data Privacy Risk Checklist (LGPD)

> Run for every integration that touches personal data. Mandatory before Gate 3.5.
> If any PERSONAL or SENSITIVE PII field is detected in Data_Mapping.md — this checklist must be run.

## Pre-Execution: PII Field Inventory

- [ ] All fields in `Data_Mapping.md` reviewed for PII content
- [ ] PII trigger list checked: name, email, phone, CPF, CNPJ (individual), address, date of birth, IP address, geolocation, health data, financial data, behavioral data, photos, biometrics
- [ ] Every field classified: SENSITIVE / PERSONAL / PSEUDONYMIZED / ANONYMOUS / NOT_PII
- [ ] Any field classified as PERSONAL or SENSITIVE → this checklist must continue
- [ ] Any field classified as SENSITIVE → CONSENT is the only valid legal basis (DR005)

## Legal Basis Documentation

- [ ] Legal basis identified for EACH personal data flow (one basis per flow)
- [ ] Legal basis is one of: CONSENT / CONTRACT / LEGAL_OBLIGATION / VITAL_INTERESTS / PUBLIC_INTEREST / LEGITIMATE_INTEREST
- [ ] If LEGITIMATE_INTEREST: proportionality test documented (what is the legitimate interest? Is it proportionate to the privacy impact?)
- [ ] If CONSENT: consent specificity verified (consent covers this specific integration purpose, not just "using the service")
- [ ] Legal basis documented in the LGPD section of `Data_Risks.md`
- [ ] No personal data flow without a documented legal basis (if any found → BLOCKED_LGPD_VIOLATION)

## SENSITIVE PII Handling

- [ ] SENSITIVE PII fields identified (health, biometrics, ethnicity, religion, sexual orientation, criminal record)
- [ ] Legal basis for SENSITIVE PII is CONSENT or LEGAL_OBLIGATION only — no other basis accepted
- [ ] SENSITIVE PII fields excluded from integration scope if consent/legal obligation cannot be established
- [ ] Escalation to Agente00_TechLead documented if SENSITIVE PII cannot be excluded

## Data Retention

- [ ] Retention period documented for each system (external and internal)
- [ ] Internal retention period does not exceed the legal obligation period
- [ ] If internal retention > legally required: flagged as MEDIUM risk in Data_Risks.md
- [ ] Deletion mechanism specified (manual deletion, cron-based purge, or soft-delete + anonymization)
- [ ] Retention periods aligned with DPA if applicable

## Cross-Border Transfers

- [ ] Cross-border transfer status assessed for each integration (does data leave Brazil?)
- [ ] If cross-border transfer: adequate data protection in destination country assessed
- [ ] Cross-border transfer documented in Data_Risks.md
- [ ] Standard Contractual Clauses (SCCs) or adequacy decision status noted if transfer occurs

## Data Subject Rights

- [ ] Access rights impact assessed: can data subjects exercise the right of access?
- [ ] Deletion rights impact assessed: can data subjects request deletion? How does deletion propagate to the external system?
- [ ] Portability rights impact assessed: can data subjects receive their data in a portable format?
- [ ] Data subject rights impact documented in Data_Risks.md LGPD section

## Data Processing Agreement (DPA)

- [ ] DPA requirement assessed for each external system that processes personal data
- [ ] DPA status documented: signed / pending / not required / unknown
- [ ] If DPA is required but not signed: RISK-NNN entry added with MEDIUM or HIGH classification
- [ ] If DPA is required and status is unknown: escalation to client DPO documented

## Technical Privacy Controls

- [ ] PII fields excluded from `console.log()` in sync job specifications
- [ ] PII fields excluded from `sync_log.errorMsg` field
- [ ] PII fields excluded from `integration_quarantine.raw_payload` (or encryption specified)
- [ ] Data transmitted over TLS 1.2+ minimum (documented in External_API_Assessment.md)
- [ ] PII fields masked or tokenized in monitoring dashboards (if applicable)

## LGPD Risk Entries in Data_Risks.md

- [ ] At least one RISK-NNN entry of type LGPD_COMPLIANCE produced for each personal data flow
- [ ] RISK entries include: pii_fields_involved, pii_classification, legal_basis, legal_basis_documented, data_retention_days, dpa_required, dpa_status
- [ ] CRITICAL and HIGH LGPD risks escalated to Agente00_TechLead and client_dpo

## Post-Execution: Gate 3.5 Privacy Summary

- [ ] `lgpd_flows.total_personal_data_flows` count accurate in Handoff Package
- [ ] `lgpd_flows.with_legal_basis` count accurate
- [ ] `lgpd_flows.missing_legal_basis` = 0 (if > 0 → BLOCKED_LGPD_VIOLATION)
- [ ] Gate 3.5 privacy check: PASS

## Runtime Knowledge Policy

At runtime, this checklist is consulted from `Agente10_DataIntegrationEngineer/checklists/`. The agent reads only from its own folder and project input artifacts. `context/` and `lib/` are blocked at runtime.
