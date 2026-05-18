# Good Output: data-quality-validation-skill

A correct Data_Quality_Checklist.md includes:

**Identity field with REJECT:**
`id` field: `z.string().min(1)` — if missing → REJECT (cannot identify record, discard immediately)

**Critical field with QUARANTINE:**
`email` field: `z.string().email()` — if invalid → QUARANTINE (move to integration_quarantine, counts.errors++)

**Non-critical field with default:**
`phone` field: `z.string().nullable().optional()` — if invalid format → ACCEPT_WITH_FLAG, use null as default

**Complete disposition policy:**
All 5 scenarios covered: ACCEPT, ACCEPT_WITH_FLAG, QUARANTINE, REJECT, SKIP

**Quarantine table schema defined:**
`integration_quarantine` table with all required fields including `external_id`, `raw_payload`, `error_message`

**PII exclusion noted:**
`raw_payload` excludes `email` and `phone` fields (PERSONAL PII — stored separately or omitted)
