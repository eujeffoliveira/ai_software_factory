# Good Output — api-contract-design-skill

## Scenario

A job board SaaS. Architecture.md defined 6 route handlers: POST /api/jobs, GET /api/jobs, GET /api/jobs/{id}, PATCH /api/jobs/{id}, DELETE /api/jobs/{id}, and GET /api/health.

## Produced API_Contract.json (excerpt)

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "Job Board API",
    "version": "1.0.0",
    "description": "Internal API for the Job Board SaaS. All protected endpoints require NextAuth v5 session token."
  },
  "components": {
    "securitySchemes": {
      "BearerAuth": {
        "type": "http",
        "scheme": "bearer",
        "bearerFormat": "JWT",
        "description": "NextAuth v5 session JWT token"
      }
    },
    "schemas": {
      "Job": {
        "type": "object",
        "required": ["id", "title", "companyId", "status", "createdAt"],
        "properties": {
          "id": { "type": "string", "format": "uuid" },
          "title": { "type": "string", "maxLength": 200 },
          "companyId": { "type": "string", "format": "uuid" },
          "status": { "type": "string", "enum": ["DRAFT", "PUBLISHED", "CLOSED"] },
          "createdAt": { "type": "string", "format": "date-time" }
        }
      },
      "ErrorResponse": {
        "type": "object",
        "required": ["error", "code"],
        "properties": {
          "error": { "type": "string" },
          "code": { "type": "string" },
          "details": { "type": "array", "items": { "type": "string" } }
        }
      }
    }
  },
  "paths": {
    "/api/health": {
      "get": {
        "operationId": "healthCheck",
        "summary": "Liveness check",
        "security": [],
        "responses": {
          "200": {
            "description": "Service is healthy",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "required": ["status", "timestamp"],
                  "properties": {
                    "status": { "type": "string", "const": "ok" },
                    "timestamp": { "type": "string", "format": "date-time" }
                  }
                }
              }
            }
          }
        }
      }
    },
    "/api/jobs": {
      "get": {
        "operationId": "listJobs",
        "summary": "List jobs with pagination",
        "security": [{ "BearerAuth": [] }],
        "parameters": [
          { "name": "page", "in": "query", "schema": { "type": "integer", "minimum": 1, "default": 1 } },
          { "name": "limit", "in": "query", "schema": { "type": "integer", "minimum": 1, "maximum": 100, "default": 20 } },
          { "name": "status", "in": "query", "schema": { "type": "string", "enum": ["DRAFT", "PUBLISHED", "CLOSED"] } }
        ],
        "responses": {
          "200": {
            "description": "Paginated job list",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "required": ["data", "total", "page", "limit"],
                  "properties": {
                    "data": { "type": "array", "items": { "$ref": "#/components/schemas/Job" } },
                    "total": { "type": "integer" },
                    "page": { "type": "integer" },
                    "limit": { "type": "integer" }
                  }
                }
              }
            }
          },
          "401": { "description": "Unauthenticated", "content": { "application/json": { "schema": { "$ref": "#/components/schemas/ErrorResponse" } } } },
          "500": { "description": "Internal error", "content": { "application/json": { "schema": { "$ref": "#/components/schemas/ErrorResponse" } } } }
        }
      }
    }
  }
}
```

## Why this is a good output

- `openapi: "3.1.0"` set correctly
- `BearerAuth` defined once in `components/securitySchemes` and referenced per-endpoint
- `/api/health` is present with `security: []` (explicitly public)
- `/api/jobs GET` has `security: [{ BearerAuth: [] }]` (protected)
- Request/response schemas fully typed — no bare `type: object`
- Reusable `Job` and `ErrorResponse` components defined and referenced via `$ref`
- Pagination fields (`page`, `limit`, `total`) present on list endpoint
- All 6 Architecture.md endpoints covered (verified by skill output: `all_architecture_endpoints_covered: true`)
- `compliance_issues: []` — passes quality gate
