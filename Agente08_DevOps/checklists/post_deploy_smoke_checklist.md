# Post-Deploy Smoke Test Checklist
## Gate 7 — Smoke Test Execution

Run this checklist immediately after every production deployment. All 4 tests must pass for Gate 7 APPROVED.

---

## Pre-Execution Setup

- [ ] Production deployment is complete (Vercel status: Ready)
- [ ] Production URL is confirmed: [production_url]
- [ ] Test credentials are available (for Test 3 — authenticated test)
- [ ] Playwright smoke suite is configured for production target URL

---

## Test 1 — App Loads

**What:** `GET [production_url]/` returns HTTP 200 and a non-error page.

**Command:**
```bash
curl -s -o /dev/null -w "%{http_code}" [production_url]/
```
Or via Playwright: `const response = await page.goto("/")`

**Pass criteria:** HTTP 200, page renders without error content

**Result:** [ ] **PASS** | [ ] **FAIL**

If FAIL: Check Vercel function logs for startup errors. Verify Zod env validation. Check if application builds correctly.

---

## Test 2 — Unauthenticated Redirect

**What:** An unauthenticated request to a protected route (e.g., `/dashboard`) redirects to `/auth/signin`.

**Command (Playwright):**
```javascript
await page.goto("/dashboard")
await expect(page).toHaveURL(/\/auth\/signin/)
```

**Pass criteria:** Final URL contains `/auth/signin` (may redirect through intermediaries)

**Result:** [ ] **PASS** | [ ] **FAIL**

If FAIL: Check NextAuth v5 configuration in production. Verify `NEXTAUTH_URL` matches production domain. Check auth redirect configuration.

---

## Test 3 — Authenticated Primary Feature

**What:** A user who has authenticated via Google OAuth can access and perform the primary application feature.

**Setup:** Use a pre-configured test account or execute the OAuth flow in Playwright.

**Pass criteria:** User is logged in, primary feature page loads, primary feature can be initiated

**Result:** [ ] **PASS** | [ ] **FAIL**

If FAIL: Check Google OAuth callback URL in Google Cloud Console — must include production domain. Verify `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` are correct for production. Check session configuration.

---

## Test 4 — API Healthcheck

**What:** `GET [production_url]/api/healthcheck` returns HTTP 200 with valid body.

**Command:**
```bash
curl -s [production_url]/api/healthcheck | jq .
```

**Pass criteria:** HTTP 200, response body contains `{"status": "ok", "timestamp": "...", "version": "..."}`

**Result:** [ ] **PASS** | [ ] **FAIL**

If FAIL: Healthcheck failure — this is also FM-03. Follow FM-03 procedure (check DB connectivity, check startup errors, potentially trigger rollback).

---

## Summary

| Test | Result | Retry Count | Rollback Trigger? |
|------|--------|-------------|-------------------|
| 1 — App loads | [ ] PASS / [ ] FAIL | 0 | If FAIL: YES |
| 2 — Auth redirect | [ ] PASS / [ ] FAIL | 0 | If FAIL: YES |
| 3 — Primary feature | [ ] PASS / [ ] FAIL | 0 | If FAIL: YES |
| 4 — Healthcheck | [ ] PASS / [ ] FAIL | 0 | If FAIL: YES |

**Overall result:** [4/4 PASS — no rollback] / [FAIL — rollback triggered]

**Retry policy:** One retry allowed per test for potential flakiness. Two consecutive FAILs on any test = rollback trigger (DR006).

---

## If Any Test Fails

1. Retry once to rule out transient network issue
2. If still FAIL: initiate rollback (see `checklists/rollback_checklist.md`)
3. Notify Tech Lead within 5 minutes of rollback trigger
4. Document failure in `Post_Deploy_Report.md` with `BLOCKED_SLO_VIOLATION` status

---

## Runtime Knowledge Policy

This checklist is consulted at runtime from `Agente08_DevOps/checklists/post_deploy_smoke_checklist.md`. Smoke test specifications are in `context_view.md` Section 7 and `knowledge/knowledge_cards.md` Card 006. Decision rules applied: DR006 (smoke test failure triggers rollback). Do not access `context/` or `lib/` to complete this checklist.
