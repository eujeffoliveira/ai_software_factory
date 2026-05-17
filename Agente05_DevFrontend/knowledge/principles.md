# Agente05_DevFrontend — Operating Principles

> Distilled from build-time bibliography (Eloquent JavaScript, Designing Interfaces, High Performance Browser Networking, CSS Secrets) and the Golden Path reference architecture. These principles govern every implementation decision made at runtime. Do not consult raw sources at runtime.

---

## P1 — Server Components Are the Default Rendering Unit

**Source:** Next.js App Router architecture + High Performance Browser Networking (Grigorik) — resource loading, reducing client-side JavaScript

React Server Components render on the server, zero JavaScript shipped to the browser, direct access to data sources. They are the default. `"use client"` is the exception, not the norm. Every component begins its lifecycle as a Server Component. The burden of proof is on Client Components — they need a reason to exist as client-side code.

**Applied rule:** Before writing any component, ask: does this need state, effects, handlers, or browser APIs? If no to all four, it is a Server Component. No `"use client"` directive.

**Violation signature:** `"use client"` on a component that only receives props and renders data.
**Correct form:** `async function EntityCard({ item }: { item: Entity }) { return <div>...</div> }` — no directive, no hooks.

---

## P2 — Client Boundary Is a Deliberate Architectural Decision

**Source:** Eloquent JavaScript (Haverbeke) — module system, closures, JavaScript execution model

`"use client"` creates a client/server boundary in the React tree. Everything below this component (in the tree, not in the import graph) runs in the browser. This boundary has real performance costs: the component and all its imports are added to the JavaScript bundle. Treat it like adding a dependency — justified, documented, minimal.

**Applied rule:** `"use client"` requires a comment explaining exactly which client feature necessitates it (state, effect, handler, browser API, Recharts). No comment = violation.

**Violation signature:** `"use client"` at the top of a file with no explanation.
**Correct form:** `"use client"\n// JUSTIFICATION: uses useState for modal open/close state`

---

## P3 — Design System Enforces Visual Consistency

**Source:** CSS Secrets (Lea Verou) — CSS techniques, visual design patterns; Designing Interfaces (Tidwell) — visual consistency principles

The design system (Tailwind CSS v4 + design tokens) is the only visual language in the application. Inline styles and hardcoded colors create divergence. Every CSS decision made outside the design system is a technical debt entry that costs more to fix than to prevent. Visual consistency is built once, at the token level.

**Applied rule:** All colors are design tokens. All spacing is Tailwind scale. All typography is Tailwind. Zero `style={{}}` props. If a value cannot be expressed with Tailwind, escalate — do not hack it.

**Violation signature:** `style={{ color: "#3b82f6" }}` or `className="bg-blue-500"`.
**Correct form:** `className="bg-[var(--primary-color)]"` or `className="bg-primary"`.

---

## P4 — Accessibility Is Not Optional — It Is a Functional Requirement

**Source:** Designing Interfaces (Tidwell) — inclusive design, accessible interaction patterns; WCAG 2.1 AA standard

An inaccessible component is a broken component. Users who rely on screen readers, keyboard navigation, or high-contrast modes cannot use a visually functional but semantically broken UI. Accessibility is not a post-implementation audit — it is built in at authoring time. Every `<button>` has meaning. Every image has `alt`. Every dynamic update has an `aria-live` region.

**Applied rule:** `accessibility-check-skill` runs before every Gate 4 submission. CRITICAL and HIGH findings block submission.

**Violation signature:** `<button onClick={...}>X</button>` with no accessible text.
**Correct form:** `<button onClick={...} aria-label="Close dialog">X</button>`

---

## P5 — Loading, Error, and Empty States Are First-Class Concerns

**Source:** Designing Interfaces (Tidwell) — empty states, progressive disclosure, feedback patterns

The three states of any data-dependent UI: waiting for data (loading), failed to get data (error), got data but it's empty (empty). Each requires its own designed response. An application that handles only the success state leaves users confused, frustrated, or stuck 30% of the time. These are not edge cases — they are the normal operating states of a networked application.

**Applied rule:** For every async page: `loading.tsx` + `error.tsx`. For every list/table component: an empty state branch. No exceptions.

**Violation signature:** A page route with `page.tsx` but no `loading.tsx` or `error.tsx`.
**Correct form:** Three files always: `page.tsx`, `loading.tsx`, `error.tsx`.

---

## P6 — Recharts Is the Authorized Charting Library

**Source:** Reference Architecture — Golden Path, single approved charting library

Chart libraries have significant bundle cost and API diversity. Authorizing one library ensures: consistent visual style, predictable behavior, known accessibility patterns, controlled bundle impact. Recharts is the choice. All other charting libraries (Chart.js, Victory, D3 direct, Nivo, etc.) require an ADR approved by Agente00_TechLead before use.

**Applied rule:** All charts use Recharts v3. `ResponsiveContainer` is mandatory. Charts are Client Components. Empty data renders an empty state, not a blank chart area.

**Violation signature:** `import { Chart } from "chart.js"` or any non-Recharts chart library.
**Correct form:** `import { ResponsiveContainer, LineChart, ... } from "recharts"`

---

## P7 — SWR Is for Polling, Not Primary Data Fetching

**Source:** High Performance Browser Networking (Grigorik) — HTTP caching, resource loading strategy, server-sent updates

SWR introduces client-side JavaScript for data fetching that Server Components can handle entirely server-side. Using SWR for static or rarely-changing data adds bundle cost, network round trips, and rendering complexity for no benefit. SWR's appropriate use is narrow: real-time updates via polling where the data changes faster than the page navigation interval.

**Applied rule:** SWR requires a `refreshInterval` value when used. If no polling is needed, use a Server Component instead. The question to ask: "Does this data need to update while the user is looking at the page, without them doing anything?" If no, use a Server Component.

**Violation signature:** `useSWR("/api/entities")` with no `refreshInterval`.
**Correct form:** `useSWR("/api/entities/status", fetcher, { refreshInterval: 30_000 })`

---

## P8 — API Contract Is the Single Source of Truth for Data Shapes

**Source:** Reference Architecture — API_Contract.json as contract authority

The frontend never invents the shape of data it receives. Inventing a response shape that doesn't match what the backend returns causes silent runtime failures: properties are undefined, TypeScript inference is wrong, and bugs are masked until production. Every TypeScript interface for a server response is derived from `API_Contract.json`, not from a guess.

**Applied rule:** Before writing a component that consumes server data, open `API_Contract.json`. Copy the response schema. Derive the TypeScript interface exactly. Never add fields that aren't in the contract.

**Violation signature:** `interface EntityResponse { someFieldThatIsntInTheContract: string }`.
**Correct form:** Interface derived field-for-field from the `API_Contract.json` response schema.

---

## P9 — Performance Is Measured, Not Assumed

**Source:** High Performance Browser Networking (Grigorik) — Core Web Vitals, bundle size, render performance; Eloquent JavaScript (Haverbeke) — JavaScript performance

"It feels fast" is not a performance guarantee. Performance decisions — Server vs. Client Component, when to use `React.memo`, when to split a bundle, image optimization — are driven by measurable impact. Premature optimization is still waste, but architectural decisions with known performance implications (like Client Component overuse) are not premature — they are predictable costs.

**Applied rule:** Client Component boundaries are justified by more than "it might need interactivity." Image usage always uses `next/image`. Data fetching follows the priority order: Server Components → Server Actions → SWR.

**Violation signature:** Converting a Server Component to a Client Component because "it's easier."
**Correct form:** Server Component unless a concrete client feature is required.

---

## P10 — Component Responsibility Is Singular

**Source:** Clean Code principles (via Eloquent JavaScript — Haverbeke) — Single Responsibility Principle

A component should do one thing: render a specific piece of UI given specific props. Business logic (calculations, domain rules, transformations) belongs in `features/[domain]/`. Data fetching belongs in Server Actions or service functions. A component that contains both rendering and complex logic is harder to test, harder to reuse, and harder to read.

**Applied rule:** If a component file exceeds ~80 lines (excluding JSX template), something probably belongs in `features/`. Extract utilities to `[domain].utils.ts`, custom hooks to `use[Name].ts`, and data fetching to Server Actions.

**Violation signature:** 200-line component with data transformation logic, business rules, and JSX all mixed.
**Correct form:** Component body is JSX. Logic is in imported functions.

---

## P11 — Mobile-First Responsive Design

**Source:** CSS Secrets (Lea Verou) — layout techniques, adaptive design; Designing Interfaces (Tidwell) — responsive patterns

Mobile is the most constrained viewport. If a layout works on mobile, it can be extended for larger screens. The reverse is not true — retrofitting a desktop layout for mobile is always harder. Tailwind's mobile-first breakpoints (`sm:`, `md:`, `lg:`) enforce this discipline. The default (no prefix) styles must produce a usable mobile experience.

**Applied rule:** Every layout component starts with the mobile CSS (no prefix). Larger breakpoints add columns, space, or features. Never `md:` as the first and only responsive class.

**Violation signature:** `className="hidden lg:block"` with no mobile alternative presented anywhere in the UI.
**Correct form:** `className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4"` — mobile first.

---

## P12 — Type Safety Propagates from API Contract to Component Props

**Source:** Eloquent JavaScript (Haverbeke) — TypeScript typing, type inference; Reference Architecture — TypeScript 5 requirement

The type system is the first line of defense against integration bugs. When TypeScript interfaces are derived from `API_Contract.json` and propagated through component props, a contract change surfaces as a compile error before the code runs. The alternative — using `any`, loose typing, or invented interfaces — removes this safety net entirely.

**Applied rule:** No `any`. No `as SomeType` without a guard. Interfaces for server data derived from the contract. Props typed explicitly. Generic components use type parameters.

**Violation signature:** `const data = response as EntityList` — type assertion without validation.
**Correct form:** `const data: EntityListResponse = EntityListSchema.parse(response)` — or trust the typed Server Action return type.
