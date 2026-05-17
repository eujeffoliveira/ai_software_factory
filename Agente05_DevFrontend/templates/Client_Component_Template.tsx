"use client"
// [TEMPLATE] Client Component
// File: features/[domain]/components/[EntityName]ActionButton.tsx
//
// JUSTIFICATION: uses useState for [pending state / modal open state / etc.]
//               and onClick event handler for [user action description]
//
// This directive is intentional and justified. Client Components ship JavaScript
// to the browser. Only mark as Client Component when required.
//
// USAGE:
// 1. Replace [EntityName] with your entity name (PascalCase)
// 2. Replace [domain] with your feature domain (kebab-case)
// 3. Replace the action import with your actual Server Action
// 4. Update Props interface to match your use case
// 5. Remove this comment block

import { useState } from "react"
import { performEntityAction } from "@/features/[domain]/actions/performEntityAction"
import type { ActionResult } from "@/features/[domain]/actions/performEntityAction"

// Props typed explicitly — no any, no type assertions
interface Props {
  entityId: string
  entityName: string
  onSuccess?: (result: ActionResult) => void
  onError?: (message: string) => void
}

export function EntityActionButton({ entityId, entityName, onSuccess, onError }: Props) {
  // Local UI state — transient, not shared
  const [isPending, setIsPending] = useState(false)
  const [statusMessage, setStatusMessage] = useState<string | null>(null)

  // Mutations go through Server Actions — never raw fetch() to internal routes
  async function handleAction() {
    setIsPending(true)
    setStatusMessage(null)

    try {
      // Direct Server Action call — Next.js serializes over the network
      const result = await performEntityAction({ entityId })

      if (result.success) {
        setStatusMessage("Action completed successfully")
        onSuccess?.(result)
      } else {
        setStatusMessage(result.error ?? "Action failed. Please try again.")
        onError?.(result.error ?? "Action failed")
      }
    } catch {
      // Never expose caught error details to users — generic message only
      setStatusMessage("An unexpected error occurred. Please try again.")
      onError?.("Unexpected error")
    } finally {
      setIsPending(false)
    }
  }

  return (
    <div>
      {/* Accessible live region for status announcements */}
      <div
        aria-live="polite"
        aria-atomic="true"
        className="sr-only"
      >
        {statusMessage}
      </div>

      {/* Button with full accessibility attributes */}
      <button
        onClick={handleAction}
        disabled={isPending}
        aria-label={`Perform action on ${entityName}`}
        aria-busy={isPending}
        aria-disabled={isPending}
        className={[
          "inline-flex items-center gap-2 px-4 py-2 rounded-md text-sm font-medium",
          "bg-[var(--primary-color)] text-white",
          "hover:opacity-90 focus:outline-none focus:ring-2",
          "focus:ring-[var(--primary-color)] focus:ring-offset-2",
          "transition-colors",
          "disabled:opacity-50 disabled:cursor-not-allowed",
        ].join(" ")}
      >
        {/* Loading indicator — accessible */}
        {isPending && (
          <svg
            className="animate-spin h-4 w-4"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            aria-hidden="true"
          >
            <circle
              className="opacity-25"
              cx="12"
              cy="12"
              r="10"
              stroke="currentColor"
              strokeWidth="4"
            />
            <path
              className="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
            />
          </svg>
        )}
        {isPending ? "Processing..." : "Perform Action"}
      </button>

      {/* Visible status message (non-critical feedback) */}
      {statusMessage && !isPending && (
        <p
          className="mt-2 text-sm text-[var(--muted-foreground)]"
          role="status"
          aria-live="polite"
        >
          {statusMessage}
        </p>
      )}
    </div>
  )
}
