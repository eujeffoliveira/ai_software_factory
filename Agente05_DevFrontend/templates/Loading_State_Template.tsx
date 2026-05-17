// [TEMPLATE] Loading State
// File: app/[domain]/loading.tsx
//
// This file is automatically used by Next.js App Router as a Suspense fallback
// for the page.tsx in the same route folder.
//
// RULES:
// - This is a Server Component (no "use client" needed)
// - It renders immediately while page.tsx awaits async data
// - The skeleton must visually match the layout of the actual content
// - Must have role="status" and aria-label for screen readers
// - Use animate-pulse with bg-muted for skeleton blocks
//
// USAGE:
// 1. Replace the skeleton structure to match your page's actual layout
// 2. Keep the aria attributes — they are mandatory
// 3. Remove this comment block

export default function Loading() {
  return (
    <div
      className="w-full"
      role="status"
      aria-label="Loading content"
      aria-live="polite"
    >
      {/* Page header skeleton */}
      <div className="animate-pulse mb-6">
        <div className="h-8 bg-muted rounded-md w-48 mb-2" />
        <div className="h-4 bg-muted rounded-md w-72" />
      </div>

      {/* Stats row skeleton — matches a 4-column stat grid */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        {Array.from({ length: 4 }).map((_, i) => (
          <div
            key={i}
            className="rounded-lg border border-[var(--border)] bg-[var(--bg-background)] p-4 animate-pulse"
          >
            <div className="h-4 bg-muted rounded w-3/4 mb-3" />
            <div className="h-8 bg-muted rounded w-1/2" />
          </div>
        ))}
      </div>

      {/* Content section skeleton — matches a 3-column card grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {Array.from({ length: 6 }).map((_, i) => (
          <div
            key={i}
            className="rounded-lg border border-[var(--border)] bg-[var(--bg-background)] p-4 animate-pulse"
          >
            {/* Card avatar/image placeholder */}
            <div className="flex items-center gap-3 mb-4">
              <div className="h-10 w-10 bg-muted rounded-full shrink-0" />
              <div className="flex-1">
                <div className="h-4 bg-muted rounded w-3/4 mb-2" />
                <div className="h-3 bg-muted rounded w-1/2" />
              </div>
            </div>
            {/* Card body lines */}
            <div className="space-y-2">
              <div className="h-3 bg-muted rounded w-full" />
              <div className="h-3 bg-muted rounded w-5/6" />
              <div className="h-3 bg-muted rounded w-4/6" />
            </div>
            {/* Card footer */}
            <div className="mt-4 pt-4 border-t border-[var(--border)] flex justify-between">
              <div className="h-4 bg-muted rounded w-16" />
              <div className="h-4 bg-muted rounded w-20" />
            </div>
          </div>
        ))}
      </div>

      {/* Screen reader announcement */}
      <span className="sr-only">Loading entities, please wait...</span>
    </div>
  )
}
