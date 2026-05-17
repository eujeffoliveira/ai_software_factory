# api-contract-design-skill

## Purpose

Produce a complete OpenAPI 3.1 specification (`API_Contract.json`) that defines every HTTP endpoint in the system: URL, method, request body, path/query parameters, response schemas, authentication requirements, and error codes. The contract is the authoritative interface definition — implementation must conform to it, not vice versa.

## When to Use

- After `Architecture.md` is complete and all system components are identified
- When defining endpoints for a new feature or service
- When revising contracts after a Gate 2 rejection
- When a security review requests formal endpoint documentation

## Inputs

- `Architecture.md` — completed; provides component inventory, server action list, route handler list
- `PRD.md` — approved; provides functional requirements, acceptance criteria, and user-facing operations
- `context_view_path` — `Agente02_SoftwareArchitect/context_view.md` (§5.2 Route Handler Rule, §1.2 Golden Path)
- `templates/API_Contract.json` — base OpenAPI 3.1 skeleton

## Outputs

- `API_Contract.json` — OpenAPI 3.1 specification (primary output)
- Summary section appended to `Architecture_Decisions.md` listing endpoint count and security schemes used

## Procedure

1. **Enumerate all endpoints** — from `Architecture.md`, list every route handler. For each: path, HTTP method, purpose, and whether it requires authentication.

2. **Map PRD requirements to endpoints** — every FR in the PRD must trace to at least one endpoint or server action. Note that server actions are documented in a dedicated section, not as HTTP routes.

3. **Define security scheme** — the project uses NextAuth v5 + Google OAuth. Apply `BearerAuth` (JWT session token) as the primary security scheme for all protected endpoints. Define it once in `components/securitySchemes`.

4. **Mark authentication requirements** — every endpoint that reads or mutates user data must have `security: [{ BearerAuth: [] }]`. Public endpoints (e.g., `/api/health`) must be explicitly marked with `security: []` (empty, meaning intentionally public).

5. **Write fully-typed request schemas** — for every endpoint with a request body:
   - Use `$ref` to reusable schema components where the same shape appears twice
   - No `type: object` without `properties`
   - No `additionalProperties: true` unless explicitly justified
   - All required fields listed in `required` array

6. **Write fully-typed response schemas** — for every status code returned:
   - `200` / `201`: success payload (fully typed)
   - `400`: validation error (Zod parse error shape)
   - `401`: unauthenticated
   - `403`: unauthorized (authenticated but forbidden)
   - `404`: not found
   - `409`: conflict (duplicates, constraint violations)
   - `500`: internal server error (no sensitive info exposed)

7. **Apply thin-shell route principle** — route handlers in Next.js 16 are thin shells. No business logic in route.ts. If an endpoint design implies branching logic in the route, flag it for redesign. The contract must describe the I/O, not encode business flow.

8. **Document error response shapes** — use a shared `ErrorResponse` component:
   ```json
   { "error": "string", "code": "string", "details": ["string"] }
   ```

9. **Add pagination to list endpoints** — any endpoint returning a list must include `page`, `limit`, and `total` in the response, or use cursor-based pagination if stated in PRD.

10. **Validate completeness** — run `checklists/api_contract_checklist.md`. Every endpoint in `Architecture.md` must appear in `API_Contract.json`.

## Quality Gate

`API_Contract.json` passes this skill's quality check when:
- OpenAPI version is `3.1.0`
- Every endpoint from `Architecture.md` is represented
- Every protected endpoint has `security: [{ BearerAuth: [] }]`
- Every request body has a fully-typed schema (no bare `type: object`)
- Every endpoint has at least `200`, `400`, and `401` responses defined
- `/api/health` endpoint is present, returns `200` with `{ "status": "ok" }`
- No business logic implied by the contract shape (route.ts must remain a thin shell)

## Failure Modes

- **Missing auth on protected endpoints:** Endpoint touches user data but has no `security` declaration → add `security: [{ BearerAuth: [] }]`
- **Vague schemas:** Request body is `type: object` with no properties → define all fields; use Zod-generated shapes as reference
- **Missing error codes:** Only `200` response defined → add at minimum `400`, `401`, `500`
- **Logic implied in routes:** Contract design requires the route handler to make decisions (branching, DB calls) → redesign to push logic into server actions
- **Missing health endpoint:** `/api/health` not in contract → always add it; it is required by deployment and observability tooling

## RAG Policy

Authorized collections at runtime:
- `architecture_reference_full` (context_view.md §5 Route Handler Rule, §8 Security)
- `domain_driven_design` (knowledge/knowledge_cards.md — bounded context, entity definitions)

Blocked at runtime: `context/`, `lib/`, raw PDFs

## Architecture Compliance

This skill's output must comply with:
- `context_view.md §5.2` — Route Handler Rule (thin shells only)
- `context_view.md §8` — Security (NextAuth v5, bearer tokens)
- `checklists/api_contract_checklist.md`

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:
- its local files (`skill.md`, schemas, checklist, examples)
- `Agente02_SoftwareArchitect/knowledge/`
- `Agente02_SoftwareArchitect/context_view.md`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
