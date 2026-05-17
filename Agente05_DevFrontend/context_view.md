# Agente05_DevFrontend — Context View

> This file is the compiled runtime context for the Dev Frontend agent. It replaces all build-time sources (`context/`, `lib/`) at runtime. Do not reference any file outside `Agente05_DevFrontend/` during task execution.

---

## 1. Server Component Pattern

**Definition:** A React component that runs exclusively on the server. It has no `"use client"` directive, can be `async`, and can directly call server-side data fetching functions.

**When to use:** By default. All components start as Server Components unless a Client Component is required.

**File location:** `app/[domain]/page.tsx`, `app/[domain]/layout.tsx`, `features/[domain]/components/[ComponentName].tsx`

**Pattern:**
```tsx
// NO "use client" directive — this is intentional
import { type EntityItem } from "@/features/[domain]/types"
import { getEntityList } from "@/features/[domain]/actions/getEntityList"
import { EmptyState } from "@/components/ui/EmptyState"
import { EntityCard } from "./EntityCard"

interface Props {
  organizationId: string
  filter?: string
}

// async is allowed — Server Components support top-level await
export default async function EntityList({ organizationId, filter }: Props) {
  // Data fetching directly — no useEffect, no useState, no SWR
  const items = await getEntityList({ organizationId, filter })

  // Loading is handled by parent loading.tsx or Suspense boundary
  // Error is handled by parent error.tsx or error boundary

  if (!items || items.length === 0) {
    return (
      <EmptyState
        icon="list"
        message="No items found"
        description="Items you create will appear here."
      />
    )
  }

  return (
    <ul className="space-y-4" aria-label="Entity list">
      {items.map((item) => (
        <li key={item.id}>
          <EntityCard item={item} />
        </li>
      ))}
    </ul>
  )
}
```

**Key rules:**
- No `useState`, `useEffect`, `useRef`, `useCallback`
- No event handlers (`onClick`, `onChange`)
- No browser APIs (`window`, `document`, `localStorage`)
- Can import Server Actions directly
- Props are typed from API contract types
- Always check and handle empty data

---

## 2. Client Component Pattern

**Definition:** A React component marked with `"use client"` that runs in the browser and can use React hooks and event handlers.

**When to use:** ONLY when the component requires: `useState`/`useReducer`, `useEffect`/`useRef`, event handlers, browser APIs, or a library that requires browser context (Recharts, etc.).

**Pattern:**
```tsx
"use client"
// JUSTIFICATION: uses useState for toggle visibility and onClick handler
import { useState } from "react"
import { type ActionResult } from "@/features/[domain]/actions/[actionName]"

interface Props {
  label: string
  onConfirm: (result: ActionResult) => void
}

export function ConfirmButton({ label, onConfirm }: Props) {
  const [isPending, setIsPending] = useState(false)

  // Data mutations go through Server Actions — never raw fetch()
  async function handleClick() {
    setIsPending(true)
    try {
      const result = await performAction()
      onConfirm(result)
    } finally {
      setIsPending(false)
    }
  }

  return (
    <button
      onClick={handleClick}
      disabled={isPending}
      aria-busy={isPending}
      aria-label={`Confirm ${label}`}
      className="px-4 py-2 bg-[var(--primary-color)] text-white rounded-md
                 hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-[var(--primary-color)]
                 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed
                 transition-colors"
    >
      {isPending ? "Processing..." : label}
    </button>
  )
}
```

**Key rules:**
- `"use client"` must be the very first line of the file
- Always include a comment explaining WHY it's a Client Component
- Mutations use Server Actions — never `fetch()` to internal API routes
- Accessibility attributes (`aria-busy`, `aria-disabled`, `aria-expanded`) must reflect state
- All Tailwind — no inline styles

---

## 3. Tailwind CSS v4 Patterns

**Rule:** Tailwind is the only styling mechanism. No `style={{}}`, no `.module.css`, no `styled-components`.

**Mobile-first breakpoints:**
```
Default (no prefix): < 640px (mobile)
sm:  ≥ 640px  (large mobile / small tablet)
md:  ≥ 768px  (tablet)
lg:  ≥ 1024px (desktop)
xl:  ≥ 1280px (large desktop)
2xl: ≥ 1536px (wide)
```

**Design token integration:**
```tsx
// Correct — using CSS variable tokens via Tailwind
<div className="bg-[var(--bg-background)] text-[var(--text-foreground)] border border-[var(--border)]">

// Correct — semantic Tailwind classes (when mapped to tokens in tailwind.config)
<div className="bg-background text-foreground border-border">

// WRONG — hardcoded hex color
<div style={{ backgroundColor: "#3b82f6" }}>

// WRONG — hardcoded Tailwind color (not a token)
<div className="bg-blue-500">
```

**Dark mode:**
```tsx
// Use dark: variant — tokens handle the color switch
<div className="bg-background dark:bg-background text-foreground dark:text-foreground">
// (When tokens are set up correctly, dark mode is automatic)
```

**Common layout patterns:**
```tsx
// Responsive grid
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">

// Responsive flex
<div className="flex flex-col sm:flex-row items-start sm:items-center gap-4">

// Container with padding
<div className="container mx-auto px-4 sm:px-6 lg:px-8">

// Card
<div className="rounded-lg border border-[var(--border)] bg-[var(--bg-background)] p-4 shadow-sm">
```

---

## 4. Loading State Pattern

**Rule:** Every async route must have a `loading.tsx`. Every async nested component should have a Suspense fallback.

**`loading.tsx` (auto-Suspense by Next.js App Router):**
```tsx
// app/[domain]/loading.tsx
export default function Loading() {
  return (
    <div
      className="w-full space-y-4 p-4"
      aria-label="Loading content"
      role="status"
      aria-live="polite"
    >
      {/* Skeleton UI — must match the layout of the real content */}
      <div className="animate-pulse space-y-3">
        <div className="h-8 bg-muted rounded-md w-1/3" />
        <div className="h-4 bg-muted rounded-md w-full" />
        <div className="h-4 bg-muted rounded-md w-5/6" />
        <div className="h-4 bg-muted rounded-md w-4/6" />
      </div>
    </div>
  )
}
```

**Suspense boundary for nested components:**
```tsx
import { Suspense } from "react"
import { EntityListSkeleton } from "@/components/skeletons/EntityListSkeleton"
import { EntityList } from "./EntityList"

export default function Page() {
  return (
    <main>
      <h1 className="text-2xl font-bold text-[var(--text-foreground)]">Entities</h1>
      <Suspense fallback={<EntityListSkeleton />}>
        <EntityList />
      </Suspense>
    </main>
  )
}
```

---

## 5. Error State Pattern

**Rule:** Every page route must have an `error.tsx`. Must be a Client Component (Next.js requirement). Never expose `error.message` to users.

```tsx
"use client"
// error.tsx — Client Component required by Next.js App Router
// JUSTIFICATION: Next.js requires error.tsx to be a Client Component

interface ErrorProps {
  error: Error & { digest?: string }
  reset: () => void
}

export default function Error({ error, reset }: ErrorProps) {
  // Log internally — never display error.message to users
  // In production, use a structured logger
  console.error("[page/error] Unhandled error:", { digest: error.digest })

  return (
    <div
      role="alert"
      className="flex flex-col items-center justify-center min-h-[400px] p-8 text-center"
    >
      <div className="mb-4 text-destructive" aria-hidden="true">
        {/* Error icon */}
        <svg className="w-12 h-12 mx-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
            d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
        </svg>
      </div>
      <h2 className="text-xl font-semibold text-[var(--text-foreground)] mb-2">
        Something went wrong
      </h2>
      <p className="text-[var(--muted-foreground)] mb-6 max-w-md">
        An unexpected error occurred. Your data is safe. Please try again.
      </p>
      <button
        onClick={reset}
        className="px-4 py-2 bg-[var(--primary-color)] text-white rounded-md
                   hover:opacity-90 focus:outline-none focus:ring-2
                   focus:ring-[var(--primary-color)] focus:ring-offset-2
                   transition-colors"
        aria-label="Try loading the page again"
      >
        Try again
      </button>
    </div>
  )
}
```

---

## 6. Empty State Pattern

**Rule:** Every list, table, or data-driven section must render an empty state when no data is returned. Never leave a blank space.

```tsx
// components/ui/EmptyState.tsx — reusable empty state component
interface EmptyStateProps {
  icon?: "list" | "search" | "document" | "chart"
  message: string
  description?: string
  action?: {
    label: string
    onClick: () => void
  }
}

export function EmptyState({ icon = "list", message, description, action }: EmptyStateProps) {
  return (
    <div
      className="flex flex-col items-center justify-center py-12 px-4 text-center"
      role="status"
      aria-label={message}
    >
      <div className="mb-4 text-[var(--muted-foreground)]" aria-hidden="true">
        {/* Icon based on type */}
        <svg className="w-12 h-12 mx-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5}
            d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
        </svg>
      </div>
      <h3 className="text-lg font-medium text-[var(--text-foreground)] mb-1">{message}</h3>
      {description && (
        <p className="text-sm text-[var(--muted-foreground)] mb-4 max-w-xs">{description}</p>
      )}
      {action && (
        <button
          onClick={action.onClick}
          className="px-4 py-2 text-sm bg-[var(--primary-color)] text-white rounded-md
                     hover:opacity-90 focus:outline-none focus:ring-2
                     focus:ring-[var(--primary-color)] focus:ring-offset-2"
        >
          {action.label}
        </button>
      )}
    </div>
  )
}
```

**Inline usage pattern:**
```tsx
if (!data || data.length === 0) {
  return (
    <EmptyState
      message="No items found"
      description="Items you create will appear here."
    />
  )
}
```

---

## 7. Recharts Pattern

**Rule:** All charts use Recharts. `ResponsiveContainer` is mandatory. Charts are Client Components (Recharts uses browser APIs). Every chart handles the empty data case. Chart wrappers are accessible.

```tsx
"use client"
// JUSTIFICATION: Recharts requires browser APIs — must be Client Component
import {
  ResponsiveContainer, LineChart, BarChart, AreaChart,
  Line, Bar, Area, XAxis, YAxis, CartesianGrid, Tooltip, Legend
} from "recharts"

interface ChartDataPoint {
  label: string
  value: number
  [key: string]: string | number  // extensible for multi-series
}

interface Props {
  data: ChartDataPoint[]
  title: string
  height?: number
}

export function MetricsLineChart({ data, title, height = 300 }: Props) {
  // ALWAYS handle empty data before rendering the chart
  if (!data || data.length === 0) {
    return (
      <div
        className="flex items-center justify-center h-[300px] text-[var(--muted-foreground)]"
        aria-label={`${title} — no data available`}
        role="img"
      >
        <span className="text-sm">No data available</span>
      </div>
    )
  }

  return (
    // Accessible wrapper with role="img" and aria-label
    <div
      className={`w-full h-[${height}px]`}
      role="img"
      aria-label={`${title} line chart`}
    >
      {/* ResponsiveContainer is MANDATORY — never fixed width/height */}
      <ResponsiveContainer width="100%" height="100%">
        <LineChart data={data} margin={{ top: 5, right: 30, left: 20, bottom: 5 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
          <XAxis
            dataKey="label"
            tick={{ fill: "var(--muted-foreground)", fontSize: 12 }}
          />
          <YAxis
            tick={{ fill: "var(--muted-foreground)", fontSize: 12 }}
          />
          <Tooltip
            contentStyle={{
              backgroundColor: "var(--bg-background)",
              border: "1px solid var(--border)",
              borderRadius: "6px",
            }}
          />
          <Legend />
          <Line
            type="monotone"
            dataKey="value"
            stroke="var(--primary-color)"
            strokeWidth={2}
            activeDot={{ r: 6 }}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  )
}
```

---

## 8. SWR Pattern

**Rule:** SWR is used ONLY for polling (real-time updates at intervals). Never use SWR where a Server Component would work. If data does not need live refresh, it belongs in a Server Component.

**When to use SWR:**
- Live status indicators that update every N seconds
- Metrics dashboards with auto-refresh
- Real-time notifications or unread counts
- Progress indicators for long-running background jobs

**Pattern:**
```tsx
"use client"
// JUSTIFICATION: requires real-time polling with SWR — data changes outside user interaction
import useSWR from "swr"
import type { EntityStatus } from "@/features/[domain]/types"

const fetcher = (url: string) => fetch(url).then((r) => {
  if (!r.ok) throw new Error("Failed to fetch")
  return r.json() as Promise<EntityStatus>
})

interface Props {
  entityId: string
  pollInterval?: number  // ms — default 30s
}

export function LiveStatusIndicator({ entityId, pollInterval = 30_000 }: Props) {
  const { data, error, isLoading } = useSWR<EntityStatus>(
    `/api/entities/${entityId}/status`,
    fetcher,
    {
      refreshInterval: pollInterval,
      revalidateOnFocus: false,  // avoid excessive revalidation
    }
  )

  if (isLoading) {
    return (
      <div className="animate-pulse h-4 w-20 bg-muted rounded" aria-label="Loading status" />
    )
  }

  if (error) {
    return (
      <span className="text-sm text-destructive" role="alert" aria-live="polite">
        Status unavailable
      </span>
    )
  }

  return (
    <span
      className={`inline-flex items-center gap-1.5 text-sm font-medium ${
        data?.status === "active"
          ? "text-green-600 dark:text-green-400"
          : "text-[var(--muted-foreground)]"
      }`}
      aria-label={`Status: ${data?.status ?? "unknown"}`}
      aria-live="polite"
    >
      <span
        className={`h-2 w-2 rounded-full ${
          data?.status === "active" ? "bg-green-500" : "bg-gray-400"
        }`}
        aria-hidden="true"
      />
      {data?.status ?? "Unknown"}
    </span>
  )
}
```

---

## 9. Server Action Integration

**Rule:** Mutations are performed via Server Actions (defined in `features/[domain]/actions/`). Never call `fetch()` to internal API routes from Client Components. Import and call Server Actions directly.

**Pattern:**
```tsx
"use client"
// JUSTIFICATION: form submission with optimistic updates — requires useState
import { useState } from "react"
import { createEntity } from "@/features/[domain]/actions/createEntity"
import type { CreateEntityInput } from "@/features/[domain]/schemas/entity.schema"

export function CreateEntityForm() {
  const [error, setError] = useState<string | null>(null)
  const [isPending, setIsPending] = useState(false)

  async function handleSubmit(formData: FormData) {
    setError(null)
    setIsPending(true)
    try {
      // Direct Server Action call — no fetch(), no API route
      const result = await createEntity({
        name: formData.get("name") as string,
        description: formData.get("description") as string,
      } satisfies CreateEntityInput)

      if (!result.success) {
        setError(result.error ?? "An error occurred")
      }
    } catch {
      setError("Failed to create. Please try again.")
    } finally {
      setIsPending(false)
    }
  }

  return (
    <form action={handleSubmit} aria-label="Create entity form" noValidate>
      {error && (
        <div role="alert" aria-live="assertive" className="text-destructive text-sm mb-4">
          {error}
        </div>
      )}
      <div className="space-y-4">
        <div>
          <label htmlFor="name" className="block text-sm font-medium text-[var(--text-foreground)] mb-1">
            Name
          </label>
          <input
            id="name"
            name="name"
            type="text"
            required
            className="w-full border border-[var(--border)] rounded-md px-3 py-2
                       bg-[var(--bg-background)] text-[var(--text-foreground)]
                       focus:outline-none focus:ring-2 focus:ring-[var(--primary-color)]"
            aria-required="true"
          />
        </div>
        <button
          type="submit"
          disabled={isPending}
          aria-busy={isPending}
          className="w-full px-4 py-2 bg-[var(--primary-color)] text-white rounded-md
                     hover:opacity-90 disabled:opacity-50 disabled:cursor-not-allowed
                     focus:outline-none focus:ring-2 focus:ring-[var(--primary-color)] focus:ring-offset-2"
        >
          {isPending ? "Creating..." : "Create Entity"}
        </button>
      </div>
    </form>
  )
}
```

---

## 10. `next/image` Usage

**Rule:** `<img>` is forbidden. Always use `<Image>` from `next/image`.

**Required props:**
- `src` — image URL (from API contract or static import)
- `alt` — descriptive text (empty string `""` for decorative images)
- Either `width` and `height` (fixed size) OR `fill` (fill parent container)

**Fixed size:**
```tsx
import Image from "next/image"

<Image
  src={user.avatarUrl}
  alt={`${user.name}'s avatar`}
  width={40}
  height={40}
  className="rounded-full object-cover"
/>
```

**Fill (responsive):**
```tsx
<div className="relative w-full h-48">
  <Image
    src={item.imageUrl}
    alt={item.description}
    fill
    className="object-cover rounded-lg"
    sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
  />
</div>
```

**External domains** must be configured in `next.config.js` — escalate if a new domain is needed.

---

## 11. API Contract Consumption

**Rule:** The frontend never invents endpoint paths or response shapes. All data shapes come from `API_Contract.json`. All endpoint paths come from `API_Contract.json`.

**Process:**
1. Read `API_Contract.json` for the relevant feature domain
2. Note the response schema for each endpoint you need
3. Define TypeScript interfaces that match the contract exactly
4. Use those interfaces as prop types for components

**Pattern:**
```tsx
// types derived directly from API_Contract.json — never invented
interface EntityResponse {
  id: string
  name: string
  status: "active" | "inactive" | "pending"  // from contract enum
  createdAt: string  // ISO 8601 — from contract format
  organizationId: string
}

// In Server Component — data shape matches contract
const entity = await getEntity(id)
// entity: EntityResponse | null
```

If the contract does not define the needed shape, stop and escalate to Agente00_TechLead.

---

## 12. Design Token Reference

**Available tokens (apply via CSS variables in Tailwind):**

| Token | Usage |
|-------|-------|
| `--primary-color` | Brand primary — buttons, links, active states |
| `--secondary-color` | Brand secondary — accents, secondary actions |
| `--text-foreground` | Primary text color |
| `--bg-background` | Page/card background |
| `--muted` | Muted background (badges, tags, skeletons) |
| `--muted-foreground` | Secondary text, placeholder text |
| `--border` | Border color for cards, inputs, dividers |
| `--destructive` | Error/danger actions and states |
| `--destructive-foreground` | Text on destructive background |

**Usage in Tailwind:**
```tsx
// Background
className="bg-[var(--bg-background)]"
// or via configured Tailwind aliases:
className="bg-background"

// Text
className="text-[var(--text-foreground)]"

// Border
className="border-[var(--border)]"

// Primary color
className="bg-[var(--primary-color)] text-white"
```

---

## 13. Accessibility Patterns

**Mandatory checklist:**
- Every `<button>` without descriptive text must have `aria-label`
- Every `<img>` with visual meaning must have a descriptive `alt` attribute
- Every form `<input>` must have an associated `<label>` (via `id`/`for` or wrapping)
- Every interactive element must be reachable via keyboard (`Tab`, `Enter`, `Space`)
- Every element with a visible focus state must have a visible `:focus` ring
- Dynamic content changes must be announced via `aria-live="polite"` (or `"assertive"` for errors)
- Modal dialogs must trap focus and have `role="dialog"` + `aria-modal="true"`
- Minimum contrast: 4.5:1 for normal text, 3:1 for large text (WCAG AA)
- Icon-only buttons: always have `aria-label` + `aria-hidden="true"` on the icon SVG

**Pattern:**
```tsx
// Icon button with aria-label
<button
  onClick={handleDelete}
  aria-label={`Delete ${item.name}`}
  className="p-2 rounded hover:bg-muted focus:outline-none focus:ring-2 focus:ring-[var(--primary-color)]"
>
  <TrashIcon className="w-4 h-4" aria-hidden="true" />
</button>

// Status live region
<div aria-live="polite" aria-atomic="true">
  {statusMessage && <p className="text-sm text-green-600">{statusMessage}</p>}
</div>
```

---

## 14. Responsive Layout Patterns

**Mobile-first principle:** Default styles target the smallest screen. Add `sm:`, `md:`, `lg:` prefixes for larger breakpoints.

**Common patterns:**
```tsx
// Dashboard grid: 1 col mobile → 2 col tablet → 3 col desktop → 4 col wide
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 lg:gap-6">

// Sidebar layout: stacked mobile → side-by-side desktop
<div className="flex flex-col lg:flex-row gap-6">
  <aside className="w-full lg:w-64 shrink-0">...</aside>
  <main className="flex-1 min-w-0">...</main>
</div>

// Stats row: wrap on small screens
<div className="grid grid-cols-2 md:grid-cols-4 gap-4">

// Responsive typography
<h1 className="text-2xl sm:text-3xl lg:text-4xl font-bold">

// Hide/show at breakpoints
<div className="hidden lg:block">Desktop only content</div>
<div className="block lg:hidden">Mobile only content</div>
```
