// [TEMPLATE] Server Component
// File: features/[domain]/components/[EntityName]List.tsx
//
// Server Component — no "use client" directive.
// This component runs exclusively on the server.
// It can be async, can fetch data directly, and ships zero JavaScript to the browser.
//
// USAGE:
// 1. Replace [EntityName] with your entity name (PascalCase)
// 2. Replace [domain] with your feature domain (kebab-case)
// 3. Replace EntityItem type with your contract-derived type
// 4. Replace getEntityList with the appropriate Server Action
// 5. Remove this comment block

import Image from "next/image"
import { getEntityList } from "@/features/[domain]/actions/getEntityList"
import { EmptyState } from "@/components/ui/EmptyState"
import { EntityCard } from "./EntityCard"
import type { EntityItem, EntityListFilter } from "@/features/[domain]/types"

// Props are typed from API contract types, not invented
interface Props {
  organizationId: string
  filter?: EntityListFilter
  // Add additional props derived from the task spec and contract
}

// async is allowed for Server Components — data fetching at render time
export default async function EntityList({ organizationId, filter }: Props) {
  // Data fetching directly — no useEffect, no useState, no SWR
  // Loading is handled by parent loading.tsx or Suspense boundary
  // Error is handled by parent error.tsx or error boundary
  const items = await getEntityList({ organizationId, filter })

  // ALWAYS check for empty data before rendering the list
  if (!items || items.length === 0) {
    return (
      <EmptyState
        icon="list"
        message="No entities found"
        description="Entities you create will appear here."
        // Only add action if the user can actually create entities here
      />
    )
  }

  return (
    <section
      aria-label="Entity list"
      className="w-full"
    >
      {/* Responsive grid — mobile-first */}
      <ul
        className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4"
        role="list"
        aria-label={`${items.length} entities`}
      >
        {items.map((item: EntityItem) => (
          <li key={item.id} role="listitem">
            <EntityCard item={item} />
          </li>
        ))}
      </ul>

      {/* Accessible item count */}
      <p className="sr-only" aria-live="polite">
        Showing {items.length} entities
      </p>
    </section>
  )
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPANION FILES REQUIRED (create alongside this component):
//
// loading.tsx (in the parent route folder):
//   export default function Loading() { ... }
//
// error.tsx (in the parent route folder):
//   "use client"
//   export default function Error({ error, reset }) { ... }
//
// These are NOT optional. Missing them blocks Gate 4.
// ─────────────────────────────────────────────────────────────────────────────
