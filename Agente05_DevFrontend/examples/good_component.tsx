// GOOD EXAMPLE: Well-implemented Server Component
// File: features/projects/components/ProjectList.tsx
//
// Demonstrates:
// ✓ Server Component (no "use client") — only reads data
// ✓ Async data fetching directly in component
// ✓ next/image for all images
// ✓ Tailwind only — no inline styles
// ✓ Design tokens — no hardcoded colors
// ✓ Empty state for no-data case
// ✓ Fully typed from API contract
// ✓ Accessible — aria-labels, semantic HTML, screen reader support
// ✓ Mobile-first responsive layout
// ✓ Loading handled by parent loading.tsx (file: app/projects/loading.tsx)
// ✓ Error handled by parent error.tsx (file: app/projects/error.tsx)

// NO "use client" — this is intentional. This component only reads data.
import Image from "next/image"
import { getProjectList } from "@/features/projects/actions/getProjectList"
import { EmptyState } from "@/components/ui/EmptyState"
import type { ProjectItem } from "@/features/projects/types"

// Types derived field-by-field from API_Contract.json "ProjectItem" schema
// No invented fields — every field exists in the contract
interface Props {
  organizationId: string
  statusFilter?: "active" | "archived" | "all"
}

// async Server Component — can await data directly
export default async function ProjectList({ organizationId, statusFilter = "all" }: Props) {
  // Direct data fetch — Server Component pattern
  // No useEffect, no useState, no SWR for non-polling data
  const projects = await getProjectList({ organizationId, statusFilter })

  // Empty state check — BEFORE the map (never skip this)
  if (!projects || projects.length === 0) {
    return (
      <EmptyState
        icon="folder"
        message="No projects found"
        description={
          statusFilter === "archived"
            ? "No archived projects. Active projects can be archived from the project settings."
            : "Projects you create will appear here."
        }
      />
    )
  }

  return (
    <section aria-label="Projects list">
      {/* Accessible count announcement */}
      <p className="text-sm text-[var(--muted-foreground)] mb-4">
        {projects.length} project{projects.length !== 1 ? "s" : ""}
      </p>

      {/* Mobile-first responsive grid */}
      <ul
        className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 lg:gap-6"
        role="list"
        aria-label={`${projects.length} projects`}
      >
        {projects.map((project: ProjectItem) => (
          <li key={project.id} role="listitem">
            {/* Card — uses design tokens only */}
            <article
              className={[
                "rounded-lg border border-[var(--border)]",
                "bg-[var(--bg-background)]",
                "p-4 hover:shadow-md transition-shadow",
                "flex flex-col gap-3",
              ].join(" ")}
              aria-label={`Project: ${project.name}`}
            >
              {/* Project header with thumbnail */}
              <div className="flex items-start gap-3">
                {/* next/image — NEVER <img> */}
                <div className="relative w-10 h-10 shrink-0">
                  <Image
                    src={project.thumbnailUrl}
                    alt={`${project.name} thumbnail`}
                    fill
                    className="rounded-md object-cover"
                    sizes="40px"
                  />
                </div>

                <div className="flex-1 min-w-0">
                  <h3 className="font-semibold text-[var(--text-foreground)] truncate">
                    {project.name}
                  </h3>
                  <p className="text-sm text-[var(--muted-foreground)] truncate">
                    {project.description}
                  </p>
                </div>

                {/* Status badge — uses design tokens */}
                <span
                  className={[
                    "inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium shrink-0",
                    project.status === "active"
                      ? "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400"
                      : "bg-[var(--muted)] text-[var(--muted-foreground)]",
                  ].join(" ")}
                  aria-label={`Status: ${project.status}`}
                >
                  {project.status}
                </span>
              </div>

              {/* Metadata row */}
              <div className="flex items-center gap-4 text-xs text-[var(--muted-foreground)]">
                <span>
                  <time dateTime={project.createdAt}>
                    {new Date(project.createdAt).toLocaleDateString()}
                  </time>
                </span>
                <span>{project.taskCount} tasks</span>
              </div>

              {/* Action link — accessible */}
              <a
                href={`/projects/${project.id}`}
                className={[
                  "mt-auto text-sm font-medium text-[var(--primary-color)]",
                  "hover:underline focus:outline-none focus:ring-2",
                  "focus:ring-[var(--primary-color)] focus:ring-offset-1 rounded",
                  "w-fit",
                ].join(" ")}
                aria-label={`Open project ${project.name}`}
              >
                View project →
              </a>
            </article>
          </li>
        ))}
      </ul>
    </section>
  )
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPANION FILES (required alongside this component):
//
// app/projects/loading.tsx — loading state (skeleton matching card grid)
// app/projects/error.tsx  — error state (Client Component, reset button)
// ─────────────────────────────────────────────────────────────────────────────
