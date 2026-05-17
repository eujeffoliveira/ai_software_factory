# Agente05_DevFrontend — Knowledge Cards

> Reusable concept cards distilled from the bibliography. Each card is a self-contained reference for a specific concept, pattern, or technique used in frontend development.

---

## Card 001 — React Server Components (RSC) Architecture

**Source:** Next.js App Router documentation + High Performance Browser Networking (Grigorik) — JavaScript bundle cost

**Concept:** React Server Components execute on the server only. Their output (serialized React tree) is streamed to the browser. No JavaScript for the component itself is included in the client bundle.

**Key properties:**
- Can be `async` — `await` data fetching at the top level
- Cannot use hooks (`useState`, `useEffect`, etc.)
- Cannot use event handlers
- Cannot access browser APIs
- CAN import server-only modules (database clients, secret access)
- CAN pass data down to Client Components as props

**When it matters:** A Server Component that renders a list of 50 items and each item has a "Delete" button — the list component is Server, the button is a Client Component (has `onClick`). The entire list logic stays on the server, only the button ships JavaScript.

**Bundle impact:** Server Components add ZERO bytes to the JavaScript bundle. Each Client Component boundary you add ships code to the browser.

---

## Card 002 — Next.js App Router File Conventions

**Source:** Next.js App Router documentation

**Special files in each route folder:**

| File | Purpose | Component type |
|------|---------|----------------|
| `page.tsx` | The UI for the route | Server Component (default) |
| `layout.tsx` | Shared layout wrapping pages | Server Component (default) |
| `loading.tsx` | Loading UI (auto-wraps in Suspense) | Server Component |
| `error.tsx` | Error UI (shown on thrown error) | Client Component (required) |
| `not-found.tsx` | 404 UI | Server Component (default) |
| `template.tsx` | Like layout but re-mounts on nav | Server or Client |

**Nesting:** Route folders can nest. `app/dashboard/page.tsx` is at `/dashboard`. `app/dashboard/settings/page.tsx` is at `/dashboard/settings`. Each nested route inherits its parent `layout.tsx`.

---

## Card 003 — Tailwind CSS v4 Design Token Integration

**Source:** CSS Secrets (Lea Verou) — CSS custom properties; Tailwind CSS v4 documentation

Tailwind v4 integrates with CSS custom properties (design tokens) via the `@theme` layer or the `css()` function. Components reference tokens using `var(--token-name)` inside Tailwind's arbitrary value syntax:

```
bg-[var(--primary-color)]       → background: var(--primary-color)
text-[var(--text-foreground)]   → color: var(--text-foreground)
border-[var(--border)]          → border-color: var(--border)
```

Alternatively, if the project has configured Tailwind aliases in `tailwind.config.ts`:
```
bg-primary     → background: var(--primary-color)
text-foreground → color: var(--text-foreground)
border-border  → border-color: var(--border)
```

**Key insight:** When tokens change (theme switch, white-label, dark mode), components using token-based classes update automatically. Components using `bg-blue-500` do not.

---

## Card 004 — Loading Skeleton Pattern

**Source:** Designing Interfaces (Tidwell) — progressive disclosure, feedback patterns

A skeleton is a low-fidelity placeholder that mimics the structure of the content that will appear. It reduces perceived loading time and prevents layout shift.

**Anatomy:**
- Skeleton shapes match the dimensions of the real content
- `animate-pulse` (Tailwind) creates a fade in/out animation
- Use `bg-muted` for the skeleton blocks (uses the muted background token)
- Include `role="status"` and `aria-label="Loading content"` on the skeleton container
- `aria-live="polite"` on the content container (NOT the skeleton) announces when content loads

**Skeleton vs. Spinner:**
- Use a skeleton when the content has a defined shape (cards, lists, tables)
- Use a spinner when the content shape is unknown or the wait is very short (< 1s)
- Prefer skeletons for data-heavy pages — they feel faster even when they aren't

---

## Card 005 — Empty State Design

**Source:** Designing Interfaces (Tidwell) — empty states; first-use experience

Empty states communicate three things: (1) the feature exists, (2) no data is here yet, and (3) what to do about it.

**Anatomy:**
1. **Contextual icon** — visually communicates what type of content is empty
2. **Headline** — clear statement of what's empty ("No entities yet")
3. **Supporting text** — context or explanation ("Entities appear after you create them")
4. **CTA (optional)** — next action ("Create your first entity")

**When to include a CTA:**
- The user CAN take action (they have permission)
- The action is the obvious next step
- The feature is new-user facing

**When NOT to include a CTA:**
- Read-only sections that an admin must fill
- Search results with no matches (offer to clear search instead)
- Error-dependent empty states

---

## Card 006 — Recharts Component Architecture

**Source:** Recharts v3 documentation + CSS Secrets (Lea Verou) — responsive containers

Recharts renders SVG-based charts using React components. All Recharts components require browser APIs (SVG, DOM measurement) → they MUST be Client Components.

**Mandatory architecture:**
```tsx
"use client"
// ... imports from recharts

export function MyChart({ data }: Props) {
  // 1. Guard: empty state first
  if (!data?.length) return <EmptyChartState />

  return (
    // 2. ResponsiveContainer: ALWAYS — never fixed width
    <ResponsiveContainer width="100%" height={300}>
      // 3. Chart type: LineChart, BarChart, AreaChart, etc.
      <LineChart data={data}>
        // 4. Axes, grid, tooltip, legend
        <CartesianGrid />
        <XAxis dataKey="label" />
        <YAxis />
        <Tooltip />
        // 5. Data series with token colors
        <Line dataKey="value" stroke="var(--primary-color)" />
      </LineChart>
    </ResponsiveContainer>
  )
}
```

**Chart type guide:**
| Chart type | When to use |
|------------|-------------|
| `LineChart` | Trends over time |
| `BarChart` | Comparison between categories |
| `AreaChart` | Volume/cumulative over time |
| `PieChart` | Parts of a whole (limit to ≤ 5 slices) |
| `ComposedChart` | Mixed types (bar + line on same axes) |

---

## Card 007 — SWR Polling Configuration

**Source:** High Performance Browser Networking (Grigorik) — HTTP polling, server-sent events; SWR documentation

SWR (Stale-While-Revalidate) is a React hook for data fetching with built-in caching and revalidation. In the Golden Path, it is used ONLY for polling.

**Key configuration options for polling:**
```tsx
const { data, error, isLoading } = useSWR(key, fetcher, {
  refreshInterval: 30_000,    // poll every 30 seconds
  revalidateOnFocus: false,   // don't revalidate when window regains focus
  revalidateOnReconnect: true, // revalidate on network reconnect
  dedupingInterval: 5_000,    // deduplicate identical requests within 5s
  errorRetryCount: 3,          // stop retrying after 3 failures
})
```

**Fetcher pattern (typed):**
```tsx
const fetcher = <T>(url: string): Promise<T> =>
  fetch(url).then((r) => {
    if (!r.ok) throw new Error(`HTTP ${r.status}`)
    return r.json() as Promise<T>
  })
```

**Key insight from Grigorik:** HTTP polling is the lowest-tech real-time mechanism but has the highest server cost at high frequency. Keep intervals ≥ 30s unless the requirement explicitly calls for something faster.

---

## Card 008 — next/image Optimization

**Source:** High Performance Browser Networking (Grigorik) — image delivery, WebP, lazy loading; Next.js Image documentation

`next/image` provides automatic:
- WebP conversion when the browser supports it
- Responsive image sizes via the `srcSet` attribute
- Lazy loading by default (except with `priority` prop)
- Layout shift prevention (requires width+height or fill)
- CDN delivery via Vercel's image optimization service

**Critical: `priority` prop for above-the-fold images:**
LCP (Largest Contentful Paint) is a Core Web Vital. The hero image or first visible image on a page should use `priority={true}` to disable lazy loading and hint the browser to fetch it early.

**`sizes` prop for fill images:**
```tsx
// Tells the browser the rendered size at each viewport width
sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
```
Without `sizes`, the browser downloads full-resolution images unnecessarily.

---

## Card 009 — WCAG AA Color Contrast Requirements

**Source:** WCAG 2.1 AA standard; Designing Interfaces (Tidwell) — visual accessibility

**Contrast ratios (WCAG AA):**
- Normal text (< 18px regular, < 14px bold): minimum 4.5:1
- Large text (≥ 18px regular or ≥ 14px bold): minimum 3:1
- UI components and graphical objects: minimum 3:1
- Inactive UI components: no requirement

**Practical token guidance:**
- `text-foreground` on `bg-background` → should be ≥ 4.5:1 by token design
- `muted-foreground` on `bg-background` → check — muted colors sometimes fail 4.5:1
- White text on `primary-color` → verify at project setup (primary color determines contrast)
- `destructive` text → must meet 4.5:1 against its background

**Tools for checking:** Browser DevTools Accessibility panel, axe browser extension.

---

## Card 010 — JavaScript Module Patterns (Server Actions)

**Source:** Eloquent JavaScript (Haverbeke) — ES modules, closures, async/await patterns

Server Actions are TypeScript functions exported from `features/[domain]/actions/` files marked with `"use server"`. They are called directly from Client Components — Next.js serializes the call over the network automatically.

**Key patterns:**
```tsx
// features/domain/actions/createEntity.ts
"use server"
export async function createEntity(input: CreateEntityInput): Promise<ActionResult> {
  // ... validation, auth, DB call
}

// components/CreateForm.tsx
"use client"
import { createEntity } from "@/features/domain/actions/createEntity"

// Call like a regular async function — no fetch() needed
const result = await createEntity(formData)
```

**Closure capture (pitfall):** Server Actions run on the server. They cannot capture browser-side variables (like DOM refs). All input must be passed as serializable arguments.

**Error handling:** Server Actions should return `{ success: boolean, error?: string, data?: T }` — never throw unhandled errors to the Client Component without a try/catch in the action itself.

---

## Card 011 — Progressive Enhancement for Forms

**Source:** Designing Interfaces (Tidwell) — form patterns; Eloquent JavaScript (Haverbeke) — browser event model

Next.js App Router forms support progressive enhancement: the form works without JavaScript using a Server Action as the `action` attribute, and JavaScript enhances it with optimistic UI.

**Pattern:**
```tsx
// Works without JS (HTML form action)
<form action={createEntity}>
  <input name="name" required />
  <button type="submit">Create</button>
</form>

// Enhanced with JS (useFormStatus / useActionState)
"use client"
import { useActionState } from "react"
import { createEntity } from "@/features/domain/actions/createEntity"

const [state, action, isPending] = useActionState(createEntity, null)
```

**When to use `useActionState`:**
- When you need optimistic updates
- When you need to display server-side validation errors inline
- When you need loading state feedback during submission

---

## Card 012 — Responsive Grid Design (CSS Grid Fundamentals)

**Source:** CSS Secrets (Lea Verou) — grid layout techniques; Designing Interfaces (Tidwell) — grid-based layouts

Tailwind's CSS Grid utilities wrap CSS Grid, the most powerful layout system for 2D content arrangements.

**Responsive grid patterns:**
```tsx
// Auto-fill grid: fills as many columns as fit at minimum width
className="grid grid-cols-[repeat(auto-fill,minmax(240px,1fr))] gap-4"

// Fixed breakpoint grid:
className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 lg:gap-6"

// Grid with sidebar:
className="grid grid-cols-1 lg:grid-cols-[240px_1fr] gap-6"

// Dashboard stats row (2 mobile, 4 desktop):
className="grid grid-cols-2 xl:grid-cols-4 gap-4"
```

**Grid vs. Flex:**
- Use Grid when content is 2-dimensional (rows AND columns matter)
- Use Flex when content is 1-dimensional (either rows OR columns, but not both)
- Dashboard card grids → Grid
- Navbar with items → Flex
- Card header with icon + title + button → Flex
