# Agente05_DevFrontend — Failure Modes

This document catalogs the 10 known failure modes for the Dev Frontend agent. Each entry includes the failure mode ID, symptom (how to detect it), root cause, impact, corrective action, and whether it blocks Gate 4.

---

## FM-01: Client Component Overuse

**Symptom:** `"use client"` appears on most or all component files. Components that only read props or render data are marked as Client Components. No Server Components in the feature folder.

**Root Cause:** Developer adds `"use client"` by default because it "avoids errors" or because of habit from older React patterns. The reflex of marking everything as a Client Component without checking whether client-side features are actually used.

**Impact:** Eliminates all Server Component benefits: no server-side data fetching, no direct database access, larger JavaScript bundle sent to the browser, worse performance, slower Time-to-First-Byte (TTFB). Components that should stream from the server now wait for JavaScript to load before rendering.

**Gate 4 Blocking:** YES — `RETURNED_FOR_REVISION` if more than 20% of components are `"use client"` without documented justification.

**Corrective Action:**
1. Run `server-component-selection-skill` on each component flagged as `"use client"`
2. For components that only read data: remove `"use client"`, convert to `async` Server Component, fetch data directly
3. For components that truly need client features: keep `"use client"` and add a justification comment: `// JUSTIFICATION: uses useState for [reason]`
4. Verify: every `"use client"` in the PR has a comment with one of: state, effect, event handler, browser API, or Recharts

**Artifact to Fix:** Any `.tsx` file with `"use client"` that doesn't need it.

---

## FM-02: Missing Loading State

**Symptom:** Async page routes have no `loading.tsx` file and no `<Suspense>` boundary. Data appears after a perceptible delay with no visual feedback. Content "pops in" suddenly.

**Root Cause:** Developer implemented the data-fetching component but forgot that Next.js App Router requires a `loading.tsx` in the same folder as the `page.tsx` to provide automatic Suspense.

**Impact:** Poor user experience — no visual feedback that data is loading. Screen readers receive no status update. Users may think the page is broken during the loading period. Potential layout shift when content finally appears.

**Gate 4 Blocking:** YES — `BLOCKED_MISSING_TESTS` is extended to cover missing UI states. QA will flag as `RETURNED_FOR_REVISION`.

**Corrective Action:**
1. Create `app/[domain]/loading.tsx` next to every `page.tsx` that fetches async data
2. Skeleton must match the approximate layout of the actual content (not a spinner alone for complex pages)
3. Add `role="status"` and `aria-label="Loading content"` to the loading container
4. For nested async components: wrap in `<Suspense fallback={<SkeletonComponent />}>`

**Artifact to Fix:** `app/[domain]/loading.tsx` — must be created for every async route.

---

## FM-03: Missing Error Boundary

**Symptom:** Page route has no `error.tsx`. When a Server Component throws during data fetching or a Client Component throws during render, the browser shows a white blank screen or the Next.js error page. No user-friendly recovery path.

**Root Cause:** Developer implemented the happy path but did not create the `error.tsx` companion file for the route.

**Impact:** White screen of death on any fetch failure, API timeout, or unexpected error. Users have no way to recover without a full page reload. No information about what went wrong (which is actually good — but user still needs guidance).

**Gate 4 Blocking:** YES — `RETURNED_FOR_REVISION`.

**Corrective Action:**
1. Create `app/[domain]/error.tsx` next to every `page.tsx`
2. Must add `"use client"` as first line (Next.js requirement for `error.tsx`)
3. Must accept `{ error, reset }` props typed as `{ error: Error & { digest?: string }, reset: () => void }`
4. Must NOT display `error.message` to users
5. Must include a "Try again" button that calls `reset()`
6. Must have `role="alert"` on the error container

**Artifact to Fix:** `app/[domain]/error.tsx` — must exist for every page route.

---

## FM-04: Missing Empty State

**Symptom:** A list, table, or data-driven section renders nothing (blank space, empty `<ul>`, or empty table body) when the data array is empty or null. User sees a visually broken section.

**Root Cause:** Developer implemented the populated state but did not add a conditional check for empty data. Assumed the API would always return data.

**Impact:** Confusing UX — users don't know if the section failed to load, if they have no items, or if there's a bug. Screen readers read nothing for the section. New users always experience this state on first login.

**Gate 4 Blocking:** YES — `RETURNED_FOR_REVISION`.

**Corrective Action:**
1. Add a null/empty check before rendering the list: `if (!items || items.length === 0) { return <EmptyState ... /> }`
2. Use the `EmptyState` component with an appropriate `message` and optional `description`
3. Consider whether the empty state should have a call-to-action (e.g., "Create your first item")
4. Apply the same pattern to tables: `if (!rows.length) return <EmptyState ... />`

**Artifact to Fix:** The component file containing the list or table.

---

## FM-05: Raw `<img>` Tag Used

**Symptom:** `<img src="..." />` appears anywhere in the component. `<Image>` from `next/image` is not used.

**Root Cause:** Developer used standard HTML syntax instead of the Next.js Image component. Common in developers migrating from plain React to Next.js.

**Impact:** Missing Next.js image optimization: no automatic WebP conversion, no lazy loading, no layout shift prevention (no `width`/`height` intrinsic size), no CDN caching optimization. Also a Gate 4 blocker that will fail the QA review.

**Gate 4 Blocking:** YES — hard blocker, `BLOCKED_DESIGN_SYSTEM_VIOLATION`.

**Corrective Action:**
1. Replace all `<img src={...} alt={...}>` with `<Image src={...} alt={...} width={N} height={N} />` from `next/image`
2. If the image needs to fill its container: use `fill` prop with a `relative`-positioned parent div
3. Add `sizes` prop when using `fill` for responsive optimization
4. External image domains must be in `next.config.js` — escalate if a new domain is needed

**Artifact to Fix:** Every component file containing `<img>`.

---

## FM-06: Inline Styles in Component

**Symptom:** `style={{ color: "#3b82f6", marginTop: "16px" }}` or `style="..."` appears anywhere in the component code. Tailwind classes are not used for that property.

**Root Cause:** Developer used inline styles for a "quick fix", for a dynamic value that seemed hard to express in Tailwind, or out of habit from non-Tailwind projects.

**Impact:** Breaks the design system — inline styles cannot use design tokens, cannot be responsive, cannot support dark mode, and cannot be overridden by Tailwind's cascade. Visually inconsistent with the rest of the application.

**Gate 4 Blocking:** YES — hard blocker, `BLOCKED_DESIGN_SYSTEM_VIOLATION`.

**Corrective Action:**
1. Replace `style={{ color: "#..." }}` with `className="text-[var(--token-name)]"` or Tailwind color class
2. Replace `style={{ marginTop: "16px" }}` with `className="mt-4"` (Tailwind spacing)
3. For dynamic values: use Tailwind's JIT arbitrary syntax: `className="mt-[${value}px]"` or conditional classes
4. If a value cannot be expressed in Tailwind, escalate to Tech Lead — do not use inline styles

**Artifact to Fix:** Every component file containing `style={{}}`

---

## FM-07: Invented API Endpoint

**Symptom:** A component or SWR hook calls a URL like `/api/entities/summary` that does not exist in `API_Contract.json`. Or a Server Action is called with parameters that don't match the contract.

**Root Cause:** Developer assumed an endpoint existed or needed one and created the client-side call before verifying the contract. Sometimes happens when the backend task has not yet been completed.

**Impact:** Runtime 404 errors when the component tries to fetch. The component fails silently or shows an error state permanently. The QA review will flag the invented endpoint immediately.

**Gate 4 Blocking:** YES — `RETURNED_FOR_REVISION` + escalation to Agente00_TechLead required.

**Corrective Action:**
1. Open `API_Contract.json` and verify every endpoint the component calls is defined there
2. If an endpoint is missing: STOP and escalate to Agente00_TechLead via the human operator — do not submit
3. If the endpoint exists but the response shape is different: update the TypeScript interface to match the contract
4. Never create a workaround by calling a different endpoint or hardcoding data

**Artifact to Fix:** The component or SWR hook containing the invented call.

---

## FM-08: Business Logic in Component

**Symptom:** A component file contains: data transformation logic (sorting, filtering, aggregating), validation functions, or domain rules (e.g., `if (user.plan === "free" && items.length > 5) { ... }`). The component file is longer than ~80 lines of JSX.

**Root Cause:** Developer placed logic directly in the component file for convenience. Common when "just one calculation" escalates into embedded business flow.

**Impact:** Untestable UI logic (hard to unit test in isolation), coupling between presentation and domain layers, violations of Single Responsibility Principle. Logic duplicated across components because it's not shared from a central feature module.

**Gate 4 Blocking:** YES — `RETURNED_FOR_REVISION`.

**Corrective Action:**
1. Extract the logic to `features/[domain]/[domain].utils.ts` or a custom hook `features/[domain]/hooks/use[Name].ts`
2. Import and call from the component: `const processedData = transformEntityList(rawData)`
3. The component body should only contain: props destructuring, derived state from props, JSX
4. Data fetching logic belongs in Server Actions or `features/[domain]/actions/`

**Artifact to Fix:** The component file — extract logic to `features/`.

---

## FM-09: SWR Used as Primary Data Fetcher

**Symptom:** A component uses `useSWR` to fetch data that does not require real-time polling (no `refreshInterval`), or SWR is used as the default way to get data for any component. The same data could be fetched in a Server Component.

**Root Cause:** Developer is familiar with SWR from non-App Router React patterns and defaults to it for all data needs without considering Server Components first.

**Impact:** Unnecessary JavaScript bundle sent to the browser (SWR + Client Component overhead). Slower initial page load (data not available until JS runs and SWR fetches). Potential waterfall: page JS loads → SWR fetches → render. Server Components avoid this entirely.

**Gate 4 Blocking:** YES — `RETURNED_FOR_REVISION`.

**Corrective Action:**
1. Apply `frontend-state-management-skill` to determine the correct strategy
2. If data does not need real-time refresh: convert to Server Component with direct data fetch
3. If data needs real-time polling: keep SWR but add `refreshInterval` and document the polling requirement
4. Check `API_Contract.json` — if the endpoint is a GET that returns stable data, it belongs in a Server Component

**Artifact to Fix:** The Client Component using SWR for non-polling data.

---

## FM-10: Design Token Violation

**Symptom:** A component uses hardcoded hex colors (`#3b82f6`, `rgb(59, 130, 246)`), hardcoded Tailwind color scales (`bg-blue-500`, `text-gray-700`), or custom CSS variable names not in the project token map.

**Root Cause:** Developer used Tailwind's built-in color palette without checking against the project design token system. Or copied a color hex from a design mockup directly into the code.

**Impact:** The component does not adapt to theme changes or dark mode. If the organization's primary color changes, this component requires manual updates. Visual inconsistency with correctly tokenized components.

**Gate 4 Blocking:** YES — hard blocker, `BLOCKED_DESIGN_SYSTEM_VIOLATION`.

**Corrective Action:**
1. Run `design-token-compliance-skill` on all component files
2. Replace `bg-blue-500` with `bg-[var(--primary-color)]` or the project's configured Tailwind alias
3. Replace `text-gray-700` with `text-[var(--muted-foreground)]`
4. Replace `border-gray-200` with `border-[var(--border)]`
5. Consult `context_view.md` § Design Token Reference for the full token map
6. If a needed token doesn't exist in the project: escalate to Agente00_TechLead — do not use a hardcoded value

**Artifact to Fix:** All component files with hardcoded color values.
