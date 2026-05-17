# API Contract Validation Checklist

> Use when running `api-contract-test-skill`. Validates every endpoint in `API_Contract.json`.

---

## Pre-Validation

- [ ] `API_Contract.json` is present and accessible
- [ ] All endpoints are enumerated (list them before starting)
- [ ] For each endpoint, the contract specifies: method, path, request schema (if applicable), response schema, auth requirement

---

## For Each Endpoint in API_Contract.json

Repeat this block for every endpoint defined in the contract:

**Endpoint:** `[METHOD] /api/[path]`

### Auth Behavior (for protected endpoints)

- [ ] A test exists that calls the endpoint with NO session (no auth cookie/header)
- [ ] That test asserts: `response.status === 401`
- [ ] That test asserts: response body is `{ error: "Unauthorized" }` (not a redirect, not a 500)
- [ ] If endpoint is explicitly public (documented in contract): skip this section, mark as NOT_APPLICABLE

### Success Path

- [ ] A test exists that calls the endpoint with valid input and a valid session
- [ ] That test asserts the correct HTTP status code:
  - GET → 200
  - POST (creates resource) → 201
  - DELETE, PATCH with no body response → 204
  - POST (action, not resource creation) → 200
- [ ] The response body is captured and validated with Zod schema from the contract
- [ ] `ResponseSchema.safeParse(body).success === true`
- [ ] All required fields are present with correct types

### Validation Error Path (for endpoints with request body)

- [ ] A test exists that sends an invalid/malformed request body
- [ ] That test asserts: `response.status === 400`
- [ ] That test asserts: response body is `{ error: "..." }` (not 500, not schema error details)

### Ownership Check (for resource endpoints)

- [ ] If the endpoint operates on a user-owned resource (task, record, etc.):
  - [ ] A test exists with an authenticated user accessing ANOTHER user's resource
  - [ ] That test asserts: `response.status === 403` or `404` (not 200, not 500)
- [ ] If public resource or admin endpoint: mark as NOT_APPLICABLE

### Response Shape Validation

- [ ] Response body is extracted from the test response
- [ ] Zod schema from `API_Contract.json` is applied: `ResponseSchema.safeParse(body)`
- [ ] If `safeParse.success === false`: document the diff (which fields are missing/wrong type)
- [ ] Extra unexpected fields in the response: flag as contract deviation

### Error Format

- [ ] For any error response (4xx): body is `{ error: "string" }` — a human-readable message
- [ ] Body does NOT contain `stack`, `trace`, `message` from an exception object
- [ ] Body does NOT contain database table names, column names, or internal identifiers
- [ ] Body does NOT contain TypeScript error class names

---

## Overall Validation Summary

- [ ] Every endpoint in `API_Contract.json` has been evaluated
- [ ] `total_endpoints == fully_validated + partially_validated + not_validated`
- [ ] Any `NOT_VALIDATED` endpoint → `BLOCKED_MISSING_TESTS`
- [ ] Any `shape_mismatch` → `BLOCKED_QA_FAILURE` with precise diff documented
- [ ] API Contract Validation Report (ACV-NNN-C1) produced and complete

---

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 5 (API Contract Validation), `knowledge/decision_rules.md` (DR004, DR010), `schemas/api_contract_validation.schema.json`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
