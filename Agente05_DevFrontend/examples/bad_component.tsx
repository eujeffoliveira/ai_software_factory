// BAD EXAMPLE: Poorly-implemented component — DO NOT USE
// File: features/projects/components/ProjectList.tsx
//
// Violations (each is a Gate 4 blocker or major issue):
// ✗ "use client" used unnecessarily — component only reads data (FM-01)
// ✗ useEffect + useState for data fetching — should be Server Component (FM-09)
// ✗ <img> tag used instead of next/image (FM-05, blocks Gate 4)
// ✗ Inline styles used instead of Tailwind (FM-06, blocks Gate 4)
// ✗ Hardcoded hex colors (FM-10, blocks Gate 4)
// ✗ No empty state — blank space when no data (FM-04)
// ✗ No loading state — content pops in suddenly (FM-02)
// ✗ No error state — white screen on fetch failure (FM-03)
// ✗ Business logic inside component (FM-08)
// ✗ TypeScript `any` used — no contract derivation (P12 violation)
// ✗ Not accessible — no aria-labels, no semantic HTML

"use client"
// WRONG: "use client" with no justification comment
// This component does NOT use state that requires the client —
// it only fetches and displays data. Should be a Server Component.

import { useEffect, useState } from "react"

// WRONG: TypeScript `any` — no contract derivation, no type safety
function ProjectList() {
  // WRONG: useEffect + useState for data fetching
  // This causes: JS bundle cost, waterfall loading, no streaming
  // FIX: Remove "use client", make component async, use Server Action
  const [projects, setProjects] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // WRONG: raw fetch() to an internal API route
    // FIX: Use a Server Action imported from features/projects/actions/
    fetch("/api/projects")
      .then((r) => r.json())
      .then((data) => {
        // WRONG: business logic in component — sorting, filtering
        // FIX: Extract to features/projects/projects.utils.ts
        const sorted = data.projects
          .filter((p: any) => p.status !== "deleted")
          .sort((a: any, b: any) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
          .map((p: any) => ({
            ...p,
            // WRONG: business logic in component — computing display name
            displayName: p.name.length > 20 ? p.name.substring(0, 20) + "..." : p.name,
          }))
        setProjects(sorted)
        setLoading(false)
      })
  }, [])

  // WRONG: spinner instead of skeleton loading state
  // And: the loading check is INSIDE the component, not via loading.tsx
  if (loading) return <div>Loading...</div>

  // WRONG: No empty state — blank space when projects array is empty
  // FIX: Add if (!projects || projects.length === 0) return <EmptyState ... />

  return (
    // WRONG: inline style instead of Tailwind classes (blocks Gate 4)
    <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: "16px" }}>
      {projects.map((project) => (
        // WRONG: key on the wrong element, div instead of article
        <div
          key={project.id}
          // WRONG: hardcoded hex colors (blocks Gate 4)
          style={{
            backgroundColor: "#ffffff",
            border: "1px solid #e5e7eb",
            borderRadius: "8px",
            padding: "16px",
          }}
        >
          {/* WRONG: <img> instead of next/image (blocks Gate 4) */}
          <img
            src={project.thumbnailUrl}
            // WRONG: no alt text on image
            width={40}
            height={40}
          />

          {/* WRONG: hardcoded color in className — not a design token */}
          <h3 style={{ color: "#111827", fontWeight: "600" }}>
            {project.displayName}
          </h3>

          {/* WRONG: hardcoded gray text color — not a design token */}
          <p style={{ color: "#6b7280", fontSize: "14px" }}>
            {project.description}
          </p>

          {/* WRONG: no aria-label on icon button */}
          <button onClick={() => window.location.href = `/projects/${project.id}`}>
            {/* Icon with no accessible text */}
            →
          </button>
        </div>
      ))}
    </div>
  )
}

export default ProjectList

// ─────────────────────────────────────────────────────────────────────────────
// CORRECTIVE ACTIONS REQUIRED:
//
// 1. Remove "use client" — use Server Component pattern (see good_component.tsx)
// 2. Remove useEffect + useState — use async Server Component with Server Action
// 3. Replace <img> with <Image> from next/image
// 4. Replace all inline styles with Tailwind classes
// 5. Replace all hex colors with design tokens (var(--token-name))
// 6. Add empty state: if (!projects || projects.length === 0) return <EmptyState>
// 7. Add loading.tsx companion file for the route
// 8. Add error.tsx companion file for the route
// 9. Extract business logic (filter, sort, transform) to features/projects/projects.utils.ts
// 10. Add aria-labels and semantic HTML
// 11. Replace `any` types with contract-derived TypeScript interfaces
// ─────────────────────────────────────────────────────────────────────────────
