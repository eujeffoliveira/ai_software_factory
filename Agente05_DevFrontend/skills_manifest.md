# Agente05_DevFrontend — Skills Manifest

This document indexes all 10 authorized skills for the Dev Frontend agent. Each entry documents purpose, trigger conditions, inputs, outputs, key failure modes, Gate 4 quality reference, permitted RAG collections, and architecture compliance notes.

---

## Skill Index

| # | Skill ID | Type | Gate Relevance |
|---|----------|------|----------------|
| 1 | server-component-selection-skill | Decision | Foundation — runs before every component implementation |
| 2 | nextjs-react-component-skill | Implementation | Primary — implements every component in the task |
| 3 | tailwind-v4-design-system-skill | Styling | Required — applied to all components |
| 4 | accessibility-check-skill | Quality | Required before Gate 4 submission |
| 5 | frontend-state-management-skill | Architecture | For any component requiring state decisions |
| 6 | swr-polling-skill | Implementation | For real-time polling use cases |
| 7 | recharts-dashboard-skill | Implementation | For all chart/visualization components |
| 8 | frontend-error-state-skill | Implementation | For every page route and async component |
| 9 | responsive-layout-skill | Implementation | For all layout components |
| 10 | design-token-compliance-skill | Quality | Run before Gate 4 submission — reviews all components |

---

## Skill 1: server-component-selection-skill

**Purpose:** Determines whether a component should be a Server Component or Client Component. Produces a typed decision with justification and template selection. Must be run before implementing any new component.

**When to Use:**
- Before implementing any new component
- When reviewing an existing component that may have an incorrect `"use client"` directive
- When unclear whether a component needs interactivity

**Inputs:**
- Component requirements: data needs, interactivity, event handlers, browser APIs
- Component name and file path

**Outputs:**
- Component type decision: `SERVER_COMPONENT` or `CLIENT_COMPONENT`
- Written justification (1-3 sentences)
- Recommended template to use from `templates/`

**Key Failure Modes:**
- Defaulting to Client Component "to be safe" (FM-01)
- Missing `"use client"` on a component that actually needs it (rare — compile error)
- Adding `"use client"` to a component that only needs read-only data (FM-01)

**Quality Gate Reference:** Gate 4 — `checklists/server_vs_client_component_checklist.md`

**RAG Collections Permitted:** `frontend_engineering`

**Architecture Compliance:**
- A component MUST be Server Component if it only reads data (async fetch, no hooks)
- A component MUST be Client Component ONLY IF it uses state, effects, handlers, or browser APIs
- "Client Component because it's simpler" is not a valid justification

---

## Skill 2: nextjs-react-component-skill

**Purpose:** Implements a complete, production-quality React component (Server or Client) following the Golden Path. Applies loading/error/empty states, accessibility, TypeScript typing, and Tailwind styling.

**When to Use:**
- Any task that requires creating or modifying a React component
- Implementing page components (Server Components by default)
- Implementing interactive UI elements (Client Components with justification)

**Inputs:**
- Component spec from atomic task (name, type, props, behavior, file path)
- Component type decision from `server-component-selection-skill`
- Endpoint(s) from `API_Contract.json` that the component will consume
- Relevant templates from `templates/`

**Outputs:**
- TypeScript/TSX file at the specified path
- Loading state (loading.tsx or Suspense fallback) if async
- Error state (error.tsx) if page route
- Empty state if the component renders a list or table

**Key Failure Modes:**
- `"use client"` added without justification (FM-01)
- `<img>` used instead of `<Image>` from `next/image` (FM-05)
- Missing empty state for a list component (FM-04)
- Missing loading state for an async page (FM-02)
- Business logic placed inside the component (FM-08)

**Quality Gate Reference:** Gate 4 — `checklists/frontend_quality_checklist.md`

**RAG Collections Permitted:** `frontend_engineering`, `ui_design_patterns`, `api_contract_consumption`

**Architecture Compliance:**
- Server Components: no `"use client"`, async, direct data fetch
- Client Components: `"use client"` first line, justified comment
- All images: `next/image` only
- All styling: Tailwind only
- All data shapes: from `API_Contract.json`

---

## Skill 3: tailwind-v4-design-system-skill

**Purpose:** Applies design tokens and Tailwind CSS v4 classes to a component or set of components. Removes any hardcoded values, inline styles, or non-token colors and replaces them with the correct Tailwind/token equivalents.

**When to Use:**
- After implementing any component (as a final styling pass)
- When reviewing a component for design system compliance
- When migrating legacy inline styles to Tailwind

**Inputs:**
- Component TSX file (or code snippet)
- Project design token map (from `context_view.md` § Design Token Reference)

**Outputs:**
- Updated TSX file with all styling converted to Tailwind + design tokens
- List of changes made (what was replaced and why)

**Key Failure Modes:**
- Leaving hardcoded hex colors (`#3b82f6`) (FM-10)
- Using inline `style={{}}` prop (FM-06)
- Using Tailwind fixed colors (`text-blue-500`) instead of tokens
- Missing responsive classes (FM not captured — leads to broken mobile)

**Quality Gate Reference:** Gate 4 — `checklists/design_system_checklist.md`

**RAG Collections Permitted:** `tailwind_design_system`

**Architecture Compliance:**
- All colors MUST reference design tokens via `var(--token-name)` or token aliases
- All spacing/sizing MUST use Tailwind scale (no `style={{ marginTop: "16px" }}`)
- No CSS modules, no `styled-components`, no emotion
- Responsive classes MUST be mobile-first

---

## Skill 4: accessibility-check-skill

**Purpose:** Audits one or more components for WCAG AA compliance. Checks ARIA attributes, keyboard navigation, focus management, color contrast, semantic HTML, and screen reader announcements. Produces a report with issues and fixes.

**When to Use:**
- Before every Gate 4 submission (mandatory for all interactive components)
- When implementing forms, buttons, modals, or any interactive UI
- When implementing data tables or lists

**Inputs:**
- Component TSX file(s) to audit
- Optional: interaction scenarios to verify (modal open/close, form submit, etc.)

**Outputs:**
- Accessibility review report (`schemas/accessibility_review.schema.json`)
- List of issues by severity: CRITICAL, HIGH, MEDIUM, LOW
- Corrected code snippets for each issue
- Boolean `wcag_aa_compliant`

**Key Failure Modes:**
- Icon buttons without `aria-label` — screen readers announce nothing
- Form inputs without associated `<label>` elements
- Missing `aria-live` on dynamic content
- Focus not trapped in modal dialogs
- Missing keyboard handler (clicks work but keyboard doesn't)
- Low color contrast (below 4.5:1)

**Quality Gate Reference:** Gate 4 — `checklists/accessibility_checklist.md`

**RAG Collections Permitted:** `accessibility`

**Architecture Compliance:**
- CRITICAL or HIGH issues BLOCK Gate 4 submission (`BLOCKED_ACCESSIBILITY_FAILURE`)
- Every interactive element must be keyboard operable
- Every visual state change must have a screen reader equivalent
- `aria-label` is required when button/link text is ambiguous or absent

---

## Skill 5: frontend-state-management-skill

**Purpose:** Decides the state management strategy for a component or feature. Determines whether to use: (a) no state (Server Component), (b) local UI state (`useState`), (c) Server Action for mutations, or (d) SWR for polling. Prevents inappropriate use of state.

**When to Use:**
- Whenever a component has state requirements
- When deciding whether SWR or a Server Component should fetch the data
- When deciding the scope of state (local vs. lifted vs. global)

**Inputs:**
- State requirement description: what data, how often it changes, what triggers changes
- Component context: where in the tree, what it renders

**Outputs:**
- State strategy recommendation with rationale
- Implementation guidance (which template, which hook, which pattern)
- Warnings if the requirement suggests a Server Component should be used instead

**Key Failure Modes:**
- Using `useState` + `useEffect` for data that could be a Server Component (FM-09)
- Using SWR for non-polling data (FM-09 variant)
- Creating global state for data that is already available via Server Component props
- `useEffect` for mutation (should be Server Action)

**Quality Gate Reference:** Gate 4 — `checklists/frontend_quality_checklist.md`

**RAG Collections Permitted:** `frontend_engineering`, `swr_patterns`

**Architecture Compliance:**
- If data only needs to be fetched once → Server Component
- If data needs real-time refresh → SWR with interval
- If user triggers a change → Server Action
- If UI state is transient (modal open, tab selected) → `useState` in Client Component

---

## Skill 6: swr-polling-skill

**Purpose:** Implements a real-time polling Client Component using `useSWR`. Handles loading, error, and stale states. Configures appropriate polling interval and revalidation strategy.

**When to Use:**
- When the task spec requires real-time or near-real-time data updates
- Status indicators that update without user interaction
- Metrics dashboards with auto-refresh
- Progress indicators for background jobs

**Inputs:**
- Polling requirement: endpoint URL, expected response type (from API_Contract.json), polling interval in ms
- Endpoint URL and response type from `API_Contract.json`

**Outputs:**
- Client Component TSX with `useSWR` implementation
- Proper loading state (skeleton or pulse indicator)
- Proper error state (inline, non-blocking)
- Proper stale state handling

**Key Failure Modes:**
- Using SWR for non-polling data (FM-09)
- No loading state for SWR (FM-02)
- No error state for SWR (FM-03)
- Polling interval too short (< 5s) without justification — excessive API calls
- Endpoint not in API_Contract.json (FM-07)

**Quality Gate Reference:** Gate 4 — `checklists/frontend_quality_checklist.md`, `checklists/api_contract_usage_checklist.md`

**RAG Collections Permitted:** `swr_patterns`, `frontend_engineering`

**Architecture Compliance:**
- SWR endpoint MUST exist in `API_Contract.json` — no invented routes
- `refreshInterval` MUST be explicitly set (no accidental default polling)
- `revalidateOnFocus` should be `false` unless specifically justified
- Loading and error states are MANDATORY

---

## Skill 7: recharts-dashboard-skill

**Purpose:** Implements Recharts chart components. Ensures `ResponsiveContainer` wraps every chart, proper TypeScript interfaces for chart data, empty state handling, accessible wrappers, and design token colors.

**When to Use:**
- Any task that requires chart or data visualization components
- Line charts, bar charts, area charts, pie charts

**Inputs:**
- Chart spec: chart type (line/bar/area/pie), data shape, metrics to display, dimensions
- Data type definition from `API_Contract.json`

**Outputs:**
- Client Component TSX with Recharts implementation
- `ResponsiveContainer` wrapper (mandatory)
- Empty state for no-data case
- Accessible `role="img"` + `aria-label` wrapper
- TypeScript interfaces for chart data

**Key Failure Modes:**
- Missing `ResponsiveContainer` — chart renders at fixed width (breaks responsiveness)
- Missing empty state for no-data case (FM-04)
- Hardcoded chart colors instead of design tokens (FM-10)
- No `aria-label` on chart wrapper (accessibility violation)
- Non-TypeScript data interface (runtime errors on malformed data)

**Quality Gate Reference:** Gate 4 — `checklists/frontend_quality_checklist.md`, `checklists/accessibility_checklist.md`

**RAG Collections Permitted:** `recharts_patterns`, `frontend_engineering`

**Architecture Compliance:**
- `ResponsiveContainer` MUST wrap every chart — no exceptions
- Chart MUST be a Client Component (Recharts requires browser APIs)
- Colors MUST use `var(--primary-color)`, `var(--secondary-color)` etc.
- Empty data MUST render an empty state — not a blank chart

---

## Skill 8: frontend-error-state-skill

**Purpose:** Implements `error.tsx` files for page routes and error boundary components for nested components. Ensures user-friendly messages (never `error.message`), a reset button, and accessible markup.

**When to Use:**
- For every page route in the task scope
- For any async component that wraps a data-dependent subtree
- When implementing forms or actions that can fail

**Inputs:**
- Page/route path that needs an error boundary
- Error recovery strategy (reset button, redirect, contact support link)

**Outputs:**
- `error.tsx` file at the route folder
- Client Component (Next.js requirement)
- User-friendly message, no internal error details
- `reset()` button
- Accessible `role="alert"` wrapper

**Key Failure Modes:**
- Missing `"use client"` on `error.tsx` (Next.js throws — FM-03 variant)
- `error.message` displayed to user (FM-03 + information disclosure)
- No `reset()` button — user cannot recover without page refresh
- Missing `role="alert"` (screen readers miss the error)

**Quality Gate Reference:** Gate 4 — `checklists/frontend_quality_checklist.md`, `checklists/accessibility_checklist.md`

**RAG Collections Permitted:** `ui_design_patterns`, `frontend_engineering`, `accessibility`

**Architecture Compliance:**
- `error.tsx` MUST be a Client Component — `"use client"` on first line
- `error.message` MUST never be displayed to users
- `reset()` function MUST be provided as a recovery mechanism
- Internal error logging MUST happen (not to the user, but to the console/logger)

---

## Skill 9: responsive-layout-skill

**Purpose:** Implements responsive layouts using Tailwind CSS v4 breakpoints. Ensures mobile-first design, correct grid and flex usage, and consistent spacing at all screen sizes.

**When to Use:**
- Any component that needs to adapt between mobile and desktop
- Page layouts with sidebars, multi-column grids, or dashboard panels
- Navigation components

**Inputs:**
- Layout specification: column count at each breakpoint, component arrangement
- Components that will live inside the layout

**Outputs:**
- Layout TSX with mobile-first Tailwind breakpoints
- Grid or flex container with appropriate responsive classes
- Spacing that scales with screen size

**Key Failure Modes:**
- Starting with desktop layout and trying to fit mobile (wrong direction)
- Using fixed pixel widths in Tailwind (e.g., `w-[320px]` without responsive override)
- Missing mobile view (layout only specified for `lg:` and up)
- Overflow issues on mobile (content wider than viewport)

**Quality Gate Reference:** Gate 4 — `checklists/responsive_layout_checklist.md`

**RAG Collections Permitted:** `tailwind_design_system`

**Architecture Compliance:**
- MUST be mobile-first (default classes for mobile, `sm:`/`md:`/`lg:` for larger)
- MUST use Tailwind grid/flex — not CSS Grid or Flexbox directly in `style`
- Containers MUST have max-width and horizontal padding for edge readability

---

## Skill 10: design-token-compliance-skill

**Purpose:** Reviews one or more components for design token compliance. Finds hardcoded hex values, non-token Tailwind colors, inline styles, and CSS modules. Produces a compliance report with violations and corrections.

**When to Use:**
- Before every Gate 4 submission (mandatory — run on all files in the PR)
- When reviewing a component during implementation
- When onboarding a new design token into the system

**Inputs:**
- Array of component file paths to review
- Current design token map

**Outputs:**
- Compliance report: list of violations (file, line, type, severity)
- Corrected code snippets for each violation
- Boolean `design_token_compliant`
- Count of violations by type: inline_style, hardcoded_color, non_token_class

**Key Failure Modes:**
- `style={{ color: "#..." }}` in any component (FM-06)
- `bg-blue-500` or any non-token Tailwind color (FM-10)
- `className="text-gray-700"` instead of `text-[var(--muted-foreground)]`
- Missing response classes creating inconsistent cross-device appearance

**Quality Gate Reference:** Gate 4 — `checklists/design_system_checklist.md`

**RAG Collections Permitted:** `tailwind_design_system`

**Architecture Compliance:**
- Any `style={{...}}` prop BLOCKS Gate 4 (`BLOCKED_DESIGN_SYSTEM_VIOLATION`)
- Any hardcoded hex value BLOCKS Gate 4
- All colors MUST reference tokens — not Tailwind's predefined color palette
- Violations must be fixed and skill re-run before submission
