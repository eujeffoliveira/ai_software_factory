"use client"
// [TEMPLATE] Error State
// File: app/[domain]/error.tsx
//
// JUSTIFICATION: Next.js App Router requires error.tsx to be a Client Component.
//               The reset() function is a client-side callback.
//
// RULES:
// - MUST be a Client Component — "use client" on first line (Next.js requirement)
// - MUST accept { error, reset } props with the exact type signature below
// - MUST NOT display error.message to users (information disclosure risk)
// - MUST include a "Try again" button that calls reset()
// - MUST log the error internally (digest is safe to log — not a full stack trace)
// - MUST have role="alert" for screen readers
// - User-facing message must be generic and friendly
//
// USAGE:
// 1. Place this file at app/[domain]/error.tsx
// 2. Customize the message if needed for the domain context
// 3. Remove this comment block

// Log only digest — never expose error.message or stack to users
function logError(error: Error & { digest?: string }) {
  // In production: replace console.error with your structured logger
  console.error("[page/error] Unhandled error:", {
    digest: error.digest,
    // Do NOT log: error.message, error.stack
  })
}

interface ErrorProps {
  error: Error & { digest?: string }
  reset: () => void
}

export default function Error({ error, reset }: ErrorProps) {
  // Log internally — NOT displayed to users
  logError(error)

  return (
    <div
      role="alert"
      aria-live="assertive"
      className="flex flex-col items-center justify-center min-h-[400px] p-8 text-center"
    >
      {/* Error icon — aria-hidden, decorative */}
      <div className="mb-6 text-[var(--destructive)]" aria-hidden="true">
        <svg
          className="w-16 h-16 mx-auto"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          strokeWidth={1.5}
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"
          />
        </svg>
      </div>

      {/* Error headline */}
      <h2 className="text-xl font-semibold text-[var(--text-foreground)] mb-3">
        Something went wrong
      </h2>

      {/* User-friendly description — NEVER show error.message here */}
      <p className="text-[var(--muted-foreground)] mb-8 max-w-md text-sm leading-relaxed">
        An unexpected error occurred. Your data is safe. Please try again. If the
        problem persists, contact support.
      </p>

      {/* Recovery actions */}
      <div className="flex flex-col sm:flex-row gap-3">
        {/* Primary: try again */}
        <button
          onClick={reset}
          className={[
            "px-6 py-2.5 rounded-md text-sm font-medium",
            "bg-[var(--primary-color)] text-white",
            "hover:opacity-90 focus:outline-none focus:ring-2",
            "focus:ring-[var(--primary-color)] focus:ring-offset-2",
            "transition-colors",
          ].join(" ")}
          aria-label="Try loading the page again"
        >
          Try again
        </button>

        {/* Secondary: go back (optional — include only if navigation makes sense) */}
        <button
          onClick={() => window.history.back()}
          className={[
            "px-6 py-2.5 rounded-md text-sm font-medium",
            "border border-[var(--border)] text-[var(--text-foreground)]",
            "hover:bg-[var(--muted)] focus:outline-none focus:ring-2",
            "focus:ring-[var(--border)] focus:ring-offset-2",
            "transition-colors",
          ].join(" ")}
          aria-label="Go back to the previous page"
        >
          Go back
        </button>
      </div>

      {/* Debug info for developers only — never in production */}
      {process.env.NODE_ENV === "development" && error.digest && (
        <p className="mt-4 text-xs text-[var(--muted-foreground)] font-mono">
          Error digest: {error.digest}
        </p>
      )}
    </div>
  )
}
