# Agente05_DevFrontend — Decision Rules

> If-then rules for deterministic frontend decisions. When the condition matches, apply the rule without deliberation.

---

## DR001 — Client Component Trigger: State
**IF** a component uses `useState` or `useReducer`
**THEN** it MUST have `"use client"` as its first line
**AND** add comment: `// JUSTIFICATION: uses [useState|useReducer] for [specific reason]`
**AND** consider whether the state can be lifted to a Server Component parent (passing callbacks down)

---

## DR002 — Client Component Trigger: Effects
**IF** a component uses `useEffect`, `useLayoutEffect`, `useInsertionEffect`, `useRef`, or `useImperativeHandle`
**THEN** it MUST have `"use client"` as its first line
**AND** evaluate: can the effect be replaced with a Server Component data fetch? If yes, prefer Server Component.

---

## DR003 — Client Component Trigger: Event Handlers
**IF** a component attaches `onClick`, `onChange`, `onSubmit`, `onKeyDown`, `onFocus`, `onBlur`, or any other DOM event handler
**THEN** it MUST have `"use client"` as its first line
**AND** ensure all data mutations call Server Actions, never `fetch()` to internal API routes

---

## DR004 — Client Component Trigger: Browser APIs
**IF** a component accesses `window`, `document`, `localStorage`, `sessionStorage`, `navigator`, `IntersectionObserver`, `ResizeObserver`, or any other browser-only API
**THEN** it MUST have `"use client"` as its first line
**AND** add a guard for SSR: `if (typeof window === "undefined") return null` when appropriate

---

## DR005 — Client Component Trigger: Recharts
**IF** a component imports from `recharts`
**THEN** it MUST have `"use client"` as its first line
**AND** comment: `// JUSTIFICATION: Recharts requires browser APIs — must be Client Component`
**AND** wrap the chart in `<ResponsiveContainer width="100%" height="100%">`

---

## DR006 — Server Component: Read-Only Data
**IF** a component only reads data from props or from a Server Action/service function
**AND** it does NOT use any of DR001-DR005 triggers
**THEN** it MUST be a Server Component (no `"use client"`)
**AND** if it fetches async data, it MUST be declared as `async`

---

## DR007 — Mandatory Loading State
**IF** a page route at `app/[domain]/page.tsx` performs any async operation
**THEN** `app/[domain]/loading.tsx` MUST exist
**OR** the async content MUST be wrapped in `<Suspense fallback={<SkeletonComponent />}>`
**BLOCKING:** Missing loading state blocks Gate 4 — `RETURNED_FOR_REVISION`

---

## DR008 — Mandatory Error State
**IF** ANY page route (`app/[domain]/page.tsx`) exists
**THEN** `app/[domain]/error.tsx` MUST exist
**AND** `error.tsx` MUST have `"use client"` as its first line (Next.js requirement)
**AND** `error.tsx` MUST accept `{ error: Error & { digest?: string }, reset: () => void }`
**AND** `error.message` MUST NOT be displayed to the user
**BLOCKING:** Missing error state blocks Gate 4 — `RETURNED_FOR_REVISION`

---

## DR009 — Mandatory Empty State
**IF** a component renders a list (`<ul>`, `<ol>`, `.map()`) or a table (`<table>`, `<tbody>`)
**THEN** it MUST check `if (!items || items.length === 0)` BEFORE the map
**AND** return an `<EmptyState>` component with appropriate message and description
**BLOCKING:** Missing empty state blocks Gate 4 — `RETURNED_FOR_REVISION`

---

## DR010 — Forbidden: Raw `<img>` Tag
**IF** a component needs to display an image
**THEN** ALWAYS use `<Image>` from `next/image`
**NEVER** use `<img src="..." />` raw HTML
**BLOCKING:** Any `<img>` tag blocks Gate 4 — `BLOCKED_DESIGN_SYSTEM_VIOLATION`

---

## DR011 — Forbidden: Inline Styles
**IF** a component needs a visual property (color, spacing, size, etc.)
**THEN** use Tailwind utility classes
**NEVER** use `style={{ ... }}` prop on any element
**NEVER** use `<style>` tags in component files
**BLOCKING:** Any `style={{}}` blocks Gate 4 — `BLOCKED_DESIGN_SYSTEM_VIOLATION`

---

## DR012 — Forbidden: Hardcoded Colors
**IF** a component needs a color value
**THEN** use a design token: `bg-[var(--primary-color)]`, `text-[var(--text-foreground)]`, etc.
**NEVER** use hardcoded hex: `bg-[#3b82f6]`
**NEVER** use Tailwind's color scale directly: `bg-blue-500`, `text-gray-700`
**EXCEPTION:** Semantic status colors with both light and dark variants are acceptable if no token exists, but escalate first
**BLOCKING:** Any hardcoded color blocks Gate 4 — `BLOCKED_DESIGN_SYSTEM_VIOLATION`

---

## DR013 — Chart Rule: ResponsiveContainer
**IF** any Recharts chart component is rendered
**THEN** it MUST be wrapped in `<ResponsiveContainer width="100%" height="100%">` (or specific `height` value)
**AND** the wrapper MUST have a defined height (either `height` class or `h-[Npx]` Tailwind class)
**BLOCKING:** Chart without `ResponsiveContainer` will render at 0×0 or incorrect dimensions

---

## DR014 — SWR: Polling Requirement
**IF** `useSWR` is used in a component
**THEN** `refreshInterval` MUST be explicitly specified in the options
**AND** the requirement for real-time polling MUST be documented in the acceptance criteria or task spec
**IF** no polling requirement exists → replace with a Server Component
**BLOCKING:** SWR without polling justification triggers `RETURNED_FOR_REVISION`

---

## DR015 — API Endpoint Verification
**IF** a component calls any URL (via SWR or direct fetch)
**THEN** that URL MUST exist in `API_Contract.json`
**IF** the URL does not exist in the contract → STOP, do not implement, escalate to Agente00_TechLead
**BLOCKING:** Invented endpoints block Gate 4 — `RETURNED_FOR_REVISION` + escalation required

---

## DR016 — Business Logic Extraction
**IF** a component contains any of the following:
- Data sorting, filtering, or aggregation logic
- Domain business rules (if/else based on business conditions)
- Data transformation from one shape to another
**THEN** extract the logic to `features/[domain]/[domain].utils.ts` or a custom hook
**AND** import and call the extracted function from the component
**BLOCKING:** Business logic in component triggers `RETURNED_FOR_REVISION`

---

## DR017 — Server Action for Mutations
**IF** a Client Component needs to create, update, or delete data
**THEN** import the Server Action from `features/[domain]/actions/[actionName]`
**THEN** call the Server Action directly (not via `fetch()`)
**NEVER** call `fetch("/api/[resource]", { method: "POST", body: ... })` for internal mutations
**NOTE:** SWR can be used to read (GET), but mutations go through Server Actions

---

## DR018 — TypeScript Interface from Contract
**IF** a component needs a TypeScript type for data received from the API
**THEN** derive the interface field-by-field from `API_Contract.json`
**NEVER** write an interface from memory or assumption
**NEVER** use `any` as a type for API response data
**NEVER** use `as TypeName` without first validating the data

---

## DR019 — Accessibility: Interactive Elements
**IF** a component renders a button, link, or other interactive element
**THEN** verify:
  - Text content is descriptive OR `aria-label` is present
  - Focus ring is visible (`:focus` or `focus:ring-*` Tailwind class)
  - Keyboard activation works (`Enter` for buttons, `Enter`/`Space` for custom interactive elements)
  - `aria-disabled` reflects disabled state when applicable
**BLOCKING:** Missing accessibility on interactive elements → `BLOCKED_ACCESSIBILITY_FAILURE`

---

## DR020 — Mobile-First Layout
**IF** a layout component specifies responsive classes
**THEN** the DEFAULT class (no breakpoint prefix) MUST define the mobile layout
**AND** `sm:`, `md:`, `lg:` classes add features for larger screens
**NEVER** write `className="hidden lg:block"` without a mobile alternative somewhere in the UI
**NEVER** start responsive design from the desktop breakpoint
