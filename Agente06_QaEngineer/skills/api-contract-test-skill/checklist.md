# api-contract-test-skill — Execution Checklist

## Per Endpoint

- [ ] Success status code test present and PASSING
- [ ] Auth behavior test present and PASSING (for protected endpoints)
- [ ] Request body validation test present and PASSING (for endpoints with body)
- [ ] Response shape validated with Zod (not just type assertions)
- [ ] Error format verified: `{ error: "string" }` — no stack trace, no exception details
- [ ] Ownership/403 test present (for user-owned resources)

## Overall

- [ ] Every endpoint in API_Contract.json has been evaluated
- [ ] No NOT_VALIDATED endpoints (all have at least one test)
- [ ] Shape mismatches documented with the specific diff
- [ ] Report produced with endpoint-level results

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 5 (API Contract Validation), `knowledge/decision_rules.md` (DR004, DR010), `checklists/api_contract_validation_checklist.md`, `schemas/api_contract_validation.schema.json`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
