# Skill: data-privacy-risk-skill

## Purpose

Assess all personal data flows in an integration against LGPD (Lei Geral de Proteção de Dados) requirements. Classifies PII fields, documents legal bases, identifies privacy risks, and produces the LGPD section of `Data_Risks.md`.

## When to Use

Invoke whenever any field in `Data_Mapping.md` is classified as PERSONAL or SENSITIVE PII. This skill must be invoked before Gate 3.5 for any integration touching personal data. Gate 3.5 blocks if this skill was required but not invoked (BLOCKED_LGPD_VIOLATION).

**Trigger:** Any of these fields appear in the mapping: name, email, phone, CPF, CNPJ (individual), address, date of birth, IP address, geolocation, health data, financial data, behavioral data, photos, biometrics.

## Inputs

| Input | Source | Required |
|-------|--------|----------|
| `data_mapping` | Output of `data-mapping-skill` | Yes |
| `integration_spec` | `Integration_Spec.md` | Yes |
| `legal_context` | Client or organization input | Yes |
| `external_system_dpa_status` | Client/provider info | Yes |

## Outputs

| Output | Description |
|--------|-------------|
| `Data_Risks.md` (LGPD section) | RISK-NNN entries for all personal data flows |
| PII field inventory | Classified field list with legal bases |
| DPA requirements | Which external systems require DPA |
| Data subject rights impact | How data subject rights are exercised |
| Retention schedule | Per-system data retention periods |

## Constraints

- SENSITIVE PII requires CONSENT or LEGAL_OBLIGATION — no other LGPD basis accepted (DR005)
- If legal basis cannot be established → field must be excluded from integration scope
- If SENSITIVE PII without consent/legal obligation → escalate to Agente00_TechLead immediately
- DPA status must be documented for all external systems handling personal data
- PII fields must be excluded from sync_log and console.log (specified in the output)
- Cross-border transfers must be assessed and documented
- Data retention must follow LGPD Art. 15 (retain only as long as necessary)

## Step-by-Step Execution

1. **Compile PII inventory:** Extract all PERSONAL and SENSITIVE fields from `Data_Mapping.md`. Organize by classification level.

2. **Assess legal basis for each flow:** For each personal data flow (inbound and outbound), determine the LGPD legal basis. Document the basis. For LEGITIMATE_INTEREST, document the proportionality test with all four required elements: (a) **Controller interest** — the specific, concrete benefit the controller receives from the processing; (b) **Data subject impact** — how and how much the processing affects the data subject (intrusive? unexpected? harmful?); (c) **Necessity** — whether the same controller interest could be achieved with less personal data or without processing at all; (d) **Less-invasive alternatives** — list at least one alternative that was considered and why it is insufficient. If any element cannot be documented, LEGITIMATE_INTEREST is not established — use a different basis or exclude the field.

3. **Flag SENSITIVE PII:** For any SENSITIVE fields (health, biometrics, ethnicity, religion, sexual orientation, criminal record), verify that CONSENT or LEGAL_OBLIGATION is the basis. No other basis.

4. **Assess DPA requirements:** For each external system that processes personal data: determine if a Data Processing Agreement is required and document its status.

5. **Assess data retention:** Document retention periods for each system. Apply shorter-period rule (H15).

6. **Assess cross-border transfers:** If data leaves Brazil, assess adequacy of data protection in destination country.

7. **Assess data subject rights impact:** How can data subjects exercise: access, correction, deletion, portability rights?

8. **Produce RISK-NNN entries:** For each identified privacy risk, produce a RISK entry in Data_Risks.md with: pii_fields_involved, pii_classification, legal_basis, legal_basis_documented, data_retention_days, dpa_required, dpa_status.

9. **Document technical controls:** PII exclusion from logs, encryption requirements, access control requirements.

10. **Run `data_privacy_risk_checklist.md`.**

## Knowledge Access Policy

At runtime, this skill reads from:
- `Agente10_DataIntegrationEngineer/knowledge/` (principles P2, P9; heuristics H6, H15; decision rules DR004, DR005, DR009, DR019; cards Card007, Card015)
- `Agente10_DataIntegrationEngineer/templates/Data_Risks.md`
- `Agente10_DataIntegrationEngineer/checklists/data_privacy_risk_checklist.md`
- Project input artifacts: Data_Mapping.md, Integration_Requirements.md, client DPO input

**Blocked at runtime:** `context/`, `lib/`, `*.pdf`, any other agent's folder.
