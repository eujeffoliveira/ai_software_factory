# Bad Output: data-privacy-risk-skill

A bad LGPD assessment has these violations:

**Missing legal basis:**
"We sync email and name from the CRM because we need them." — This is not a legal basis. LGPD Art. 7 requires one of 6 enumerated bases. "We need them" is not one of them.

**SENSITIVE PII with wrong basis:**
Integration syncs employee health data from an HR system. Legal basis documented as LEGITIMATE_INTEREST. VIOLATION: Health data is SENSITIVE PII under LGPD Art. 11. Only CONSENT or LEGAL_OBLIGATION applies. LEGITIMATE_INTEREST is explicitly excluded for sensitive data.

**No DPA status:**
"DPA status: unknown" — The CRM provider processes thousands of contact records with personal data. A DPA is legally required. Documenting "unknown" without escalation is not acceptable.

**PII in logs:**
Technical controls do not exclude `email` from sync_log or console.log. Every sync job failure log contains customer email addresses — a secondary LGPD violation (unauthorized disclosure through log access).

**No data subject rights impact:**
Rights impact assessment omitted entirely. When a customer requests deletion, no one knows whether the CRM integration re-imports the deleted contact on the next sync.

**Result: all_flows_have_legal_basis = FALSE → BLOCKED_LGPD_VIOLATION**
