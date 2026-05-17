# api-contract-test-skill

## Purpose

Validates that every endpoint defined in `API_Contract.json` has tests covering: HTTP status code (success + error), response shape (Zod-validated), auth behavior (401 for protected endpoints), and error format (`{ error: "string" }` with no stack traces).

## When to Use

- In every Gate 4 evaluation cycle — always runs after acceptance-criteria-validation-skill
- Any endpoint without tests → `BLOCKED_MISSING_TESTS`

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `api_contract` | `API_Contract.json` | Yes |
| `vitest_test_files` | Submitted Vitest/supertest test files | Yes |

## Outputs

- API Contract Validation Report (ACV-NNN-C1)
- List of endpoints without tests (BLOCKED_MISSING_TESTS)
- List of response shape mismatches (BLOCKED_QA_FAILURE)

## Procedure

1. **Enumerate endpoints** — list every endpoint in `API_Contract.json` (method + path)
2. **For each endpoint**: search test files for tests that call this endpoint
3. **Check success status code**: test asserts correct HTTP status (200/201/204)
4. **Check auth behavior**: for protected endpoints, test asserts 401 when no session
5. **Check response shape**: test applies Zod schema from contract to the actual response
6. **Check error format**: error responses are `{ error: "string" }` — no stack traces
7. **Record results** per endpoint: PASSED, FAILED, MISSING for each check
8. **Produce report** using `schemas/api_contract_validation.schema.json`

## Constraints

- Every endpoint in the contract must have tests — no exceptions
- Response shape validation must use Zod — type assertions don't count
- Auth test must verify 401 with null session — not just "endpoint requires auth"
- Error format test must assert the body structure — not just that an error occurred

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente06_QaEngineer/knowledge/`, `Agente06_QaEngineer/context_view.md`, `Agente06_QaEngineer/checklists/api_contract_validation_checklist.md`, `Agente06_QaEngineer/schemas/api_contract_validation.schema.json`, and project input artifacts.
