# api-contract-design-skill Checklist

## Pre-execution
- [ ] `Architecture.md` is complete and available (all route handlers listed)
- [ ] `PRD.md` is approved (Gate 1 passed)
- [ ] All functional requirements from PRD enumerated and mapped to endpoints
- [ ] Pagination style confirmed (offset or cursor) — check PRD for list-heavy features
- [ ] Authentication strategy confirmed: NextAuth v5 + BearerAuth unless ADR says otherwise

## During execution
- [ ] `openapi` field set to `"3.1.0"` — not 3.0.x
- [ ] `info.title`, `info.version`, and `info.description` filled
- [ ] `BearerAuth` security scheme defined in `components/securitySchemes`
- [ ] Every endpoint from `Architecture.md` route handler list is represented
- [ ] Every protected endpoint has `security: [{ BearerAuth: [] }]`
- [ ] Every public endpoint has `security: []` (explicit, not omitted)
- [ ] `/api/health` GET endpoint present: returns `{ "status": "ok", "timestamp": "string" }`
- [ ] All request bodies have fully-typed schemas (no bare `type: object`)
- [ ] All `required` arrays populated — no optional-by-default assumptions
- [ ] Responses defined for: `200/201`, `400`, `401`, `403`, `404`, `500` (as applicable per endpoint)
- [ ] `ErrorResponse` component defined and reused for all error shapes
- [ ] List endpoints have pagination fields: `page`, `limit`, `total` (or cursor equivalent)
- [ ] No business logic implied by the contract (route.ts remains thin shell)
- [ ] PII fields in request/response noted for security-architecture-skill review

## Post-execution
- [ ] `API_Contract.json` validated against OpenAPI 3.1 schema (no parse errors)
- [ ] All endpoints in Architecture.md covered — `uncovered_endpoints` list is empty
- [ ] Summary entry appended to `Architecture_Decisions.md`
- [ ] Ready for `security-architecture-skill` to consume as input

## Runtime Knowledge Policy
- [ ] Skill does not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime
- [ ] Consult: `Agente02_SoftwareArchitect/knowledge/`, `Agente02_SoftwareArchitect/context_view.md`, and project artifacts as input only
