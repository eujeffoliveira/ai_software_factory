# Bad Output — api-contract-design-skill

## Scenario

Same job board SaaS. 6 route handlers to cover.

## Produced API_Contract.json (excerpt — problematic)

```json
{
  "openapi": "3.0.3",
  "info": { "title": "API" },
  "paths": {
    "/api/jobs": {
      "get": {
        "summary": "List jobs",
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": { "type": "object" }
              }
            }
          }
        }
      },
      "post": {
        "summary": "Create job",
        "security": [{ "BearerAuth": [] }],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "type": "object",
                "properties": {
                  "title": { "type": "string" },
                  "status": { "type": "string" }
                }
              }
            }
          }
        },
        "responses": {
          "200": { "description": "Created" }
        }
      }
    }
  }
}
```

## Problems identified

| # | Problem | Rule violated |
|---|---------|--------------|
| 1 | `openapi: "3.0.3"` — must be 3.1.0 | Version requirement |
| 2 | `info` missing `version` and `description` fields | OpenAPI completeness |
| 3 | `BearerAuth` security scheme never defined in `components/securitySchemes` but referenced in POST | Dangling reference |
| 4 | GET `/api/jobs` has no `security` field — ambiguous, not explicitly public | Every endpoint must declare `security: []` or `security: [{ BearerAuth: [] }]` |
| 5 | GET `/api/jobs` 200 response is `type: object` with no properties — fully untyped | All schemas must be fully typed |
| 6 | POST `/api/jobs` request body has no `required` array — all fields optional by default | Required fields must be listed |
| 7 | POST `/api/jobs` only has `200` response — missing `400`, `401`, `403`, `500` | Minimum response codes required |
| 8 | GET `/api/jobs` has no pagination parameters | List endpoints must include page/limit/total |
| 9 | `/api/health` endpoint is missing entirely | Required for every project |
| 10 | Only 2 of 6 Architecture.md endpoints are covered | `all_architecture_endpoints_covered: false` |

## Gate result

`RETURNED_FOR_REVISION` — contract fails quality gate on 10 dimensions. Skill must rerun with full Architecture.md and PRD.md inputs.
