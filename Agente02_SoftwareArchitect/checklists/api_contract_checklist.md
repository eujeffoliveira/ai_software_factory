# API Contract Checklist

_Run before finalizing API_Contract.json._

---

## Completeness

- [ ] Every endpoint listed in Architecture.md appears in API_Contract.json
- [ ] Every endpoint has: method, path, operationId, summary
- [ ] OpenAPI version is 3.1.x
- [ ] At least one server URL defined
- [ ] /api/health endpoint is defined

## Authentication

- [ ] `securitySchemes` is defined in `components`
- [ ] Every protected endpoint has a `security` requirement
- [ ] Public endpoints have `security: []` (explicitly empty)
- [ ] Cron endpoints document the Authorization header and x-cron-secret header

## Request Schemas

- [ ] Every POST/PUT/PATCH endpoint has a `requestBody` with fully typed `content`
- [ ] No `type: object` without properties (all schemas are fully typed)
- [ ] Query parameters have types and constraints (minimum, maximum, pattern)
- [ ] Path parameters have types

## Response Schemas

- [ ] Every endpoint has at least one 2xx response with schema
- [ ] Every protected endpoint has a 401 Unauthorized response
- [ ] Every endpoint with authorization has a 403 Forbidden response
- [ ] Every endpoint has a 500 Internal Server Error response
- [ ] Error responses use the standard `ErrorResponse` schema from components

## Route Handler Correctness

- [ ] No endpoint design implies business logic in route.ts
- [ ] All endpoints follow REST conventions (GET for reads, POST/PUT/PATCH for mutations, DELETE for deletions)
- [ ] Cron endpoints use GET (Vercel Cron convention)
- [ ] No batch operations that would require long-running requests (>30s) without a dedicated job

## Naming

- [ ] operationIds are camelCase and unique
- [ ] Schema names are PascalCase
- [ ] Path parameters use camelCase in braces: {itemId}
