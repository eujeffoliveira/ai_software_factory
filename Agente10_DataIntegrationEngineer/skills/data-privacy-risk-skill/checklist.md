# data-privacy-risk-skill Checklist

## Pre-Execution
- [ ] All PII fields identified from Data_Mapping.md
- [ ] PII trigger list checked (H6)
- [ ] External system DPA requirement assessed

## Execution
- [ ] Legal basis documented for each personal data flow
- [ ] SENSITIVE PII: CONSENT or LEGAL_OBLIGATION only — no exceptions
- [ ] LEGITIMATE_INTEREST basis: proportionality test documented
- [ ] DPA status documented for each external system
- [ ] Data retention periods documented per system
- [ ] Shorter-period rule applied (H15)
- [ ] Cross-border transfer assessed
- [ ] Data subject rights impact assessed (access, deletion, portability)
- [ ] Technical controls specified (PII out of logs, encryption)
- [ ] RISK-NNN entries produced for all personal data flows
- [ ] Escalation documented if legal basis cannot be established

## Runtime Knowledge Policy
- [ ] Knowledge from Agente10_DataIntegrationEngineer/knowledge/ only
- [ ] context/ and lib/ not accessed

## Post-Execution
- [ ] data_privacy_risk_checklist.md fully checked
- [ ] all_flows_have_legal_basis = true (if false → BLOCKED_LGPD_VIOLATION)
- [ ] RISK entries added to Data_Risks.md
- [ ] Shared with Agente00_TechLead and Agente07_DevSecOps
