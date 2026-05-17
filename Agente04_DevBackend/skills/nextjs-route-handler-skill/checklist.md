# nextjs-route-handler-skill — Execution Checklist

---

## Pre-Execution

- [ ] `route_path` confirmed from API contract
- [ ] `http_method` confirmed
- [ ] `delegates_to` service/function identified in `features/`

## Implementation Checks

- [ ] File location is `app/api/[resource]/route.ts`
- [ ] Function name matches HTTP method: `export async function GET/POST/PUT/PATCH/DELETE`
- [ ] Zod schemas defined at module level (not inside function)
- [ ] Total lines ≤ 30 per handler — if longer, extract to service

## Auth

- [ ] `const session = await auth()` is first statement
- [ ] `if (!session) return NextResponse.json({ error: "Unauthorized" }, { status: 401 })` immediately after
- [ ] No code before auth check

## Validation

- [ ] `.safeParse()` used (not `.parse()`) — returns 400 on failure
- [ ] `if (!query.success) return 400` before accessing parsed data

## Delegation

- [ ] Calls features/ service or action — NEVER calls prisma or DAL directly
- [ ] No business logic in this file
- [ ] No if/else business decisions

## Response

- [ ] Success: `NextResponse.json(result)` with correct status (200 or 201)
- [ ] Error: `{ error: "Internal server error" }` with status 500
- [ ] `error.message` NEVER in response body

## Runtime Knowledge Policy

Use only local artifacts: this checklist, `context_view.md §4`, `examples/good_route_handler.ts`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
