// [TEMPLATE] Empty State Component
// File: components/ui/EmptyState.tsx
//
// Reusable empty state component for lists, tables, and data-driven sections.
// Uses the pattern: contextual icon + headline + optional description + optional CTA.
//
// USAGE IN SERVER COMPONENT:
//   if (!items || items.length === 0) {
//     return (
//       <EmptyState
//         icon="list"
//         message="No entities yet"
//         description="Entities you create will appear here."
//         action={{ label: "Create entity", href: "/entities/new" }}
//       />
//     )
//   }
//
// RULES:
// - This component is a Server Component (no interactivity needed)
// - The message must be clear about WHAT is empty (not just "Empty" or "No data")
// - CTA is optional — only include when user can take direct action
// - role="status" + aria-label for screen readers
// - Remove this comment block after adapting

type IconType = "list" | "search" | "document" | "chart" | "user" | "folder"

interface CTAAction {
  label: string
  href?: string      // navigation CTA
  onClick?: () => void  // functional CTA (requires Client Component wrapper)
}

interface EmptyStateProps {
  icon?: IconType
  message: string
  description?: string
  action?: CTAAction
  className?: string
}

// Icon SVG paths for each icon type
function EmptyIcon({ type }: { type: IconType }) {
  const paths: Record<IconType, string> = {
    list: "M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01",
    search: "M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z",
    document: "M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z",
    chart: "M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z",
    user: "M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z",
    folder: "M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z",
  }

  return (
    <svg
      className="w-12 h-12"
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      strokeWidth={1.5}
      aria-hidden="true"
    >
      <path strokeLinecap="round" strokeLinejoin="round" d={paths[type]} />
    </svg>
  )
}

export function EmptyState({
  icon = "list",
  message,
  description,
  action,
  className = "",
}: EmptyStateProps) {
  return (
    <div
      className={[
        "flex flex-col items-center justify-center",
        "py-16 px-4 text-center",
        className,
      ].join(" ")}
      role="status"
      aria-label={message}
    >
      {/* Contextual icon */}
      <div className="mb-4 text-[var(--muted-foreground)]" aria-hidden="true">
        <EmptyIcon type={icon} />
      </div>

      {/* Headline — describes WHAT is empty */}
      <h3 className="text-base font-semibold text-[var(--text-foreground)] mb-2">
        {message}
      </h3>

      {/* Optional description */}
      {description && (
        <p className="text-sm text-[var(--muted-foreground)] mb-6 max-w-xs leading-relaxed">
          {description}
        </p>
      )}

      {/* Optional CTA */}
      {action && (
        <>
          {action.href ? (
            // Link CTA — works without JavaScript
            <a
              href={action.href}
              className={[
                "inline-flex items-center gap-2 px-4 py-2 rounded-md text-sm font-medium",
                "bg-[var(--primary-color)] text-white",
                "hover:opacity-90 focus:outline-none focus:ring-2",
                "focus:ring-[var(--primary-color)] focus:ring-offset-2",
                "transition-colors",
              ].join(" ")}
            >
              {action.label}
            </a>
          ) : (
            // Button CTA — requires "use client" wrapper if parent is Server Component
            <button
              onClick={action.onClick}
              className={[
                "inline-flex items-center gap-2 px-4 py-2 rounded-md text-sm font-medium",
                "bg-[var(--primary-color)] text-white",
                "hover:opacity-90 focus:outline-none focus:ring-2",
                "focus:ring-[var(--primary-color)] focus:ring-offset-2",
                "transition-colors",
              ].join(" ")}
              aria-label={`${action.label} — start creating`}
            >
              {action.label}
            </button>
          )}
        </>
      )}
    </div>
  )
}
