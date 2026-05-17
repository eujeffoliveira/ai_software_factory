# Agente05_DevFrontend — Decision Heuristics

> Practical rules of thumb for fast, correct frontend decisions at runtime. When facing an implementation choice, consult these heuristics before making the call.

---

## H1 — Server vs. Client Component: The Four-Question Test

Ask these four questions about the component in order:

1. Does it use `useState` or `useReducer`? → Client Component
2. Does it use `useEffect`, `useRef`, `useCallback`, or `useLayoutEffect`? → Client Component
3. Does it attach event handlers (`onClick`, `onChange`, `onSubmit`, etc.)? → Client Component
4. Does it need browser-only APIs (`window`, `document`, `localStorage`, `navigator`, `IntersectionObserver`)? → Client Component
5. Does it use Recharts, react-dnd, or another library that requires browser context? → Client Component

If ALL five are NO → Server Component. No exceptions. The "it might need interactivity later" argument is not a valid reason to pre-emptively mark as Client Component.

---

## H2 — SWR vs. Server Component: The Staleness Question

Ask: "Does this data change while the user is actively looking at the page?"

- If data changes only when the USER does something → Server Component (reload on navigation)
- If data changes on a schedule or from another source → SWR with polling
- If data changes in real-time (WebSocket-like) → SWR with polling or SSE

Additional filter: "Is the polling interval ≥ 5 seconds?" If faster than 5s is needed, escalate — that likely requires WebSockets, not SWR polling.

---

## H3 — When to Add a Suspense Boundary

Add `<Suspense>` when:
- A Server Component fetches data asynchronously AND its parent needs to render other content immediately
- Multiple async components on the same page should load independently (waterfall avoidance)
- You want a specific skeleton for a section, different from the page-level `loading.tsx`

Do NOT add Suspense when:
- The component is synchronous (no data fetching)
- The entire page is async — `loading.tsx` handles this automatically

---

## H4 — Loading State Granularity

Rule of thumb: **one skeleton per distinct content area**.

A page with a header, a stats row, and a table should have THREE loading skeletons, not one full-page spinner. Each section can resolve independently. Use `<Suspense>` boundaries at section boundaries to enable parallel loading.

However: if all sections depend on the same data fetch, a single `loading.tsx` is correct — don't add artificial complexity.

---

## H5 — Chart Data Preparation

**Prepare data OUTSIDE the chart component.** Chart components only receive clean, typed data arrays.

Before passing to a Recharts component:
1. Transform raw API response into the `{ label: string, value: number }` shape (or whatever the chart expects)
2. Sort by the display order (chronological, alphabetical, etc.)
3. Handle null/undefined values (replace with 0 or filter out)
4. Limit data points if needed (too many points → unreadable chart)

The chart component itself only renders — no data preparation logic inside chart components.

---

## H6 — Accessibility Quick Checks (in-code heuristics)

Before submitting any component, scan for:
- Every `<button>` that has no visible text → needs `aria-label`
- Every `<img>` → needs `alt` (empty string for decorative)
- Every `<input>`, `<select>`, `<textarea>` → needs associated `<label>`
- Any list of items (`<ul>`, `<ol>`) → `aria-label` on the list
- Any modal or dialog → `role="dialog"`, `aria-modal="true"`, `aria-labelledby`
- Any loading indicator → `role="status"`, `aria-live="polite"`
- Any error message → `role="alert"`, `aria-live="assertive"`
- Any interactive component that changes visual state → update `aria-*` attributes to match

---

## H7 — Mobile-First Breakpoint Selection

Use this as a starting point:

| Layout goal | Classes |
|-------------|---------|
| 1 col mobile → 2 col tablet → 3 col desktop | `grid-cols-1 sm:grid-cols-2 lg:grid-cols-3` |
| Full-width mobile → fixed-width desktop | `w-full lg:w-[specific-size]` |
| Stack mobile → side-by-side desktop | `flex flex-col lg:flex-row` |
| Hide on mobile | `hidden sm:block` |
| Show only mobile | `block sm:hidden` |
| Smaller text mobile → larger text desktop | `text-base lg:text-lg` |

Always test: "If the viewport is 375px wide, is this usable?"

---

## H8 — Form Validation: Client vs. Server

**Client-side validation** (in the Client Component):
- Use for: immediate feedback on format errors (email format, min length, required fields)
- Shows while user is typing, before form submit
- Uses HTML5 attributes (`required`, `minLength`, `pattern`) or a client-side schema library
- Example: "Email must be valid format"

**Server-side validation** (in the Server Action):
- Use for: ALL validation — Zod schema validates the entire input
- Authorization checks, business rule validation, uniqueness constraints
- Client-side validation can be bypassed — server validation cannot be
- Server Action returns `{ success: false, error: "..." }` on validation failure

**Rule:** Both layers validate. Client-side is UX convenience. Server-side is correctness guarantee.

---

## H9 — `next/image` Optimization Hints

- Use `priority` prop for above-the-fold images (hero images, logos) to avoid LCP penalty
- Use `sizes` prop when using `fill` — helps browser calculate correct image size to download
- Use `quality` only when you need it: default (75) is usually fine
- For user avatars: fixed `width={40}` + `height={40}` + `className="rounded-full object-cover"`
- For hero images: `fill` + `className="object-cover"` + positioned parent + `sizes="100vw"`
- For product/card thumbnails: fixed dimensions + `className="object-cover rounded-md"`

---

## H10 — Dark Mode Token Application

The design token system handles dark mode automatically when tokens are configured correctly:
- `--bg-background` is light in light mode, dark in dark mode
- `--text-foreground` is dark in light mode, light in dark mode

The component author's job:
1. Use tokens instead of hardcoded colors
2. Never add `dark:` variants to override token-based classes (tokens already handle it)
3. For colors not covered by tokens: use Tailwind `dark:` variants

When to use `dark:` explicitly:
- Custom decorative elements not covered by the token system
- Status colors (green for success, red for error) that need dark variants

---

## H11 — Choosing Between `loading.tsx` and `<Suspense>`

| Situation | Use |
|-----------|-----|
| Entire page is async | `loading.tsx` (auto-wraps entire page in Suspense) |
| Specific section of a page is async | `<Suspense fallback={<SectionSkeleton />}>` |
| Multiple async sections loading independently | Multiple `<Suspense>` boundaries |
| Third-party async component | `<Suspense>` with appropriate fallback |
| Server Component inside Client Component | `<Suspense>` (cannot use `loading.tsx` here) |

Never use both for the same content — they overlap. `loading.tsx` is the page-level default; explicit `<Suspense>` is for finer-grained control.

---

## H12 — When to Extract a Custom Hook

Extract a custom hook from a Client Component when:
- The same state + effect logic is needed in more than one component
- The hook has testable behavior independent of the rendering
- The hook is more than ~10 lines of state/effect logic

Do NOT extract a hook for:
- Simple `useState(false)` toggles — inline is cleaner
- Data that belongs in a Server Component (use a Server Action instead)
- Logic that belongs in `features/[domain]/` (not a hook — a utility function)

**Naming:** `use[Noun]` or `use[Verb][Noun]` — e.g., `useEntityFilter`, `useModalState`.

---

## H13 — Empty State Anatomy

A good empty state has:
1. **An icon** that communicates the context (list icon for lists, search icon for search results, chart icon for no-data charts)
2. **A headline** that clearly states what's empty: "No entities yet" (not "Empty" or "No data")
3. **An optional description** with more context: "Entities you create will appear here."
4. **An optional CTA** that helps the user take the next action: "Create your first entity"

The CTA is OPTIONAL — only add it when there's a clear action the user can take. Don't add a CTA just to fill space.

---

## H14 — When to Use `aria-live`

Use `aria-live="polite"` for:
- Status updates that don't interrupt (loading complete, save successful, filter applied)
- Non-critical updates the user should eventually know about
- SWR polling updates that change a live counter or status

Use `aria-live="assertive"` for:
- Error messages after form submission
- Critical alerts (payment failed, session expired)
- Anything that requires IMMEDIATE attention

Never put `aria-live` on a container that renders large amounts of content — screen readers read the entire container on change.

---

## H15 — Recharts Tooltip and Legend Accessibility

Recharts tooltips are visual-only by default. To make charts more accessible:
1. Provide a data table as an accessible alternative (hidden visually with `sr-only` class, visible to screen readers)
2. Add `aria-label` to the chart container: `aria-label="Sales performance — January to June 2026"`
3. Add `role="img"` to the container so screen readers treat it as an image
4. The Tooltip is a visual enhancement — don't rely on it for accessible data communication

For simple charts, an `aria-label` that summarizes the key insight works: "Line chart showing 23% growth over 6 months."
