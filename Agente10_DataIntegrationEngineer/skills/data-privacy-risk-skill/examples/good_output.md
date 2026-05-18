# Good Output: data-privacy-risk-skill

A correct LGPD assessment produces:

**RISK-001 (LGPD_COMPLIANCE, HIGH):**
```
PII fields: email, full_name, phone
PII classification: PERSONAL
Legal basis: CONTRACT — processing necessary to deliver the service the data subject contracted
Legal basis documented: Yes — confirmed by DPO on 2026-05-01
Data retention: 5 years from contract end (internal), 7 years (CRM — apply shorter period internally)
DPA required: Yes — signed with CRM provider on 2026-04-15
Escalate to: none (legal basis established and documented)
```

**Technical controls specified:**
- `email` and `phone` excluded from `sync_log.errorMsg`
- `email` and `phone` excluded from `console.log()` in job logic
- `raw_payload` in `integration_quarantine` excludes `email` and `phone` fields

**Data subject rights impact:**
- Access: Contactable via support — our DB mirrors CRM, requests forwarded to CRM
- Deletion: Soft delete in our DB + notify CRM via `DELETE /v2/contacts/{externalId}` outbound call
- Portability: Exportable via our API in JSON format

**All flows have legal basis: TRUE → Gate 3.5 APPROVED for privacy dimension**
