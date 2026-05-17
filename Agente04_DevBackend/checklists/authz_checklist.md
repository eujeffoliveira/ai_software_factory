# Authentication and Authorization Checklist

**When to run:** For every Server Action and Route Handler implemented.  
**Purpose:** Prevent auth bypass (FM-03) and IDOR vulnerabilities.

---

## Authentication Checks

For every Server Action:
- [ ] `const session = await auth()` is the VERY FIRST statement in the function body
- [ ] Null check immediately follows: `if (!session?.user?.id) { throw new Error("Unauthorized") }`
- [ ] No input parsing, no logging, no variable declarations before the auth check
- [ ] Test case covers null session (throws Unauthorized)

For every Route Handler:
- [ ] `const session = await auth()` is the VERY FIRST statement in the handler function
- [ ] Null check returns 401 immediately: `return NextResponse.json({ error: "Unauthorized" }, { status: 401 })`
- [ ] No input parsing, no query execution, nothing before the auth check
- [ ] Test case covers null session (returns 401)

---

## Authorization Checks (Resource-Level)

For every Server Action or Route Handler that accesses or mutates a specific resource:
- [ ] Resource is fetched from DB via DAL after auth check: `const resource = await dal.findById(input.id)`
- [ ] Existence check: if resource is null, return 404 (not 403 — don't reveal the resource exists)
- [ ] Ownership check: `if (resource.userId !== session.user.id)` → throw Forbidden or return 403
- [ ] The ownership check uses `session.user.id` — never a value from the request body or query params
- [ ] Test case covers: authenticated user attempts to access another user's resource (should fail with 403)

---

## Role-Based Checks (Only When Applicable)

If the endpoint is role-restricted (e.g., admin only):
- [ ] Role check performed AFTER the basic auth check
- [ ] Role sourced from `session.user.role` (or equivalent from the session object)
- [ ] Never trust a role value sent by the client in the request body
- [ ] Return 403 (not 401) when authenticated but wrong role

---

## Status Code Reference

| Scenario | Correct Status |
|----------|---------------|
| Session is null (not authenticated) | 401 Unauthorized |
| Session exists but user doesn't own resource | 403 Forbidden |
| Resource doesn't exist | 404 Not Found (even for ownership failures — don't reveal existence) |
| Role check fails | 403 Forbidden |

---

## Common Mistakes

| Mistake | Correct Pattern |
|---------|----------------|
| `const data = await req.json()` before auth check | Auth check FIRST, then parse |
| `if (!session)` without checking `session.user.id` | `if (!session?.user?.id)` |
| Using `input.userId` for ownership check | Use `session.user.id` — never trust client-supplied IDs |
| Returning 403 when resource doesn't exist | Return 404 (don't confirm the resource exists to the attacker) |
| Checking auth but skipping resource ownership | Both checks required for mutations |

---

## Runtime Knowledge Policy

This checklist is part of the agent's local runtime knowledge.  
Do NOT consult `context/`, `lib/`, or global architecture documents to resolve authorization questions.  
All required patterns are defined in `context_view.md §9` and `knowledge/decision_rules.md` (DR011, DR012).
