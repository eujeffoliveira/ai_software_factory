// BAD EXAMPLE: Poorly-implemented dashboard page — DO NOT USE
// File: app/dashboard/page.tsx
//
// Violations (all are Gate 4 blockers or major quality issues):
// ✗ Everything as Client Component — no Server Components (FM-01)
// ✗ useEffect for data fetching — should be Server Component + Server Actions (FM-09)
// ✗ Missing loading states — content pops in abruptly (FM-02)
// ✗ Missing error boundary — white screen on failure (FM-03)
// ✗ Missing empty states for charts and lists (FM-04)
// ✗ Charts without ResponsiveContainer — fixed pixel widths (DR013 violation)
// ✗ No aria-labels anywhere — inaccessible (blocks Gate 4, FM not numbered but CRITICAL)
// ✗ Hardcoded colors — no design tokens (FM-10, blocks Gate 4)
// ✗ Inline styles throughout (FM-06, blocks Gate 4)
// ✗ Business logic in component (FM-08)

"use client"
// WRONG: entire page as Client Component unnecessarily
// The page only READS data — it should be a Server Component

import { useState, useEffect } from "react"
import { LineChart, Line, XAxis, YAxis } from "recharts" // WRONG: missing ResponsiveContainer

// WRONG: any types — no contract derivation
function DashboardPage() {
  const [metrics, setMetrics] = useState<any>(null)
  const [revenue, setRevenue] = useState<any[]>([])
  const [users, setUsers] = useState<any[]>([])
  const [activity, setActivity] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  // WRONG: useEffect for data that should be Server Component data
  useEffect(() => {
    // WRONG: multiple separate fetch calls instead of parallel Server Actions
    // WRONG: raw fetch() to internal API instead of Server Actions
    fetch("/api/dashboard/metrics")
      .then((r) => r.json())
      .then((data) => {
        // WRONG: business logic in component
        const processedMetrics = {
          ...data,
          revenueFormatted: `$${(data.totalRevenue / 1000).toFixed(1)}k`,
          growthPercent: ((data.currentRevenue - data.previousRevenue) / data.previousRevenue * 100).toFixed(1),
        }
        setMetrics(processedMetrics)
      })

    fetch("/api/dashboard/revenue-series")
      .then((r) => r.json())
      .then((data) => setRevenue(data.series))

    fetch("/api/dashboard/user-growth")
      .then((r) => r.json())
      .then((data) => {
        setUsers(data.growth)
        setLoading(false) // WRONG: setting loading false in the last fetch only
      })
  }, [])

  // WRONG: generic loading spinner instead of skeleton matching content
  if (loading) return <div>Loading...</div>

  return (
    // WRONG: inline styles instead of Tailwind
    <div style={{ padding: "24px" }}>
      <h1 style={{ fontSize: "24px", fontWeight: "bold", color: "#111827" }}>
        Dashboard
      </h1>

      {/* Stats row — WRONG: hardcoded colors and no responsive layout */}
      <div style={{ display: "flex", gap: "16px", marginTop: "24px" }}>
        {/* WRONG: hardcoded background color — not a design token */}
        <div style={{ backgroundColor: "#f9fafb", padding: "16px", borderRadius: "8px", flex: 1 }}>
          <p style={{ color: "#6b7280", fontSize: "14px" }}>Total Revenue</p>
          {/* WRONG: hardcoded color */}
          <p style={{ fontSize: "28px", fontWeight: "bold", color: "#111827" }}>
            {metrics?.revenueFormatted}
          </p>
        </div>
        <div style={{ backgroundColor: "#f9fafb", padding: "16px", borderRadius: "8px", flex: 1 }}>
          <p style={{ color: "#6b7280", fontSize: "14px" }}>Active Users</p>
          <p style={{ fontSize: "28px", fontWeight: "bold", color: "#111827" }}>
            {metrics?.activeUsers}
          </p>
        </div>
      </div>

      {/* Charts — WRONG: no ResponsiveContainer, fixed pixel dimensions */}
      <div style={{ marginTop: "32px", display: "flex", gap: "24px" }}>
        <div style={{ border: "1px solid #e5e7eb", borderRadius: "8px", padding: "16px" }}>
          <h2 style={{ marginBottom: "16px" }}>Revenue</h2>
          {/* WRONG: LineChart without ResponsiveContainer — renders at 0x0 or fixed pixels */}
          {/* WRONG: no empty state check — if revenue is empty, chart renders nothing */}
          {/* WRONG: no aria-label — screen readers get nothing */}
          {/* WRONG: hardcoded color instead of design token */}
          <LineChart width={400} height={200} data={revenue}>
            <XAxis dataKey="label" />
            <YAxis />
            <Line dataKey="value" stroke="#3b82f6" />
          </LineChart>
        </div>

        <div style={{ border: "1px solid #e5e7eb", borderRadius: "8px", padding: "16px" }}>
          <h2 style={{ marginBottom: "16px" }}>User Growth</h2>
          {/* WRONG: same issues — fixed width, no empty state, no accessibility */}
          <LineChart width={400} height={200} data={users}>
            <XAxis dataKey="label" />
            <YAxis />
            <Line dataKey="count" stroke="#10b981" />
          </LineChart>
        </div>
      </div>

      {/* Activity list — WRONG: no empty state */}
      <div style={{ marginTop: "32px" }}>
        <h2>Recent Activity</h2>
        {/* WRONG: if activity is empty, renders nothing — blank space */}
        {activity.map((item) => (
          <div key={item.id} style={{ padding: "8px 0", borderBottom: "1px solid #e5e7eb" }}>
            {item.description}
          </div>
        ))}
      </div>
    </div>
  )
}

export default DashboardPage

// ─────────────────────────────────────────────────────────────────────────────
// CORRECTIVE ACTIONS:
//
// 1. Remove "use client" — convert to Server Component (async function)
// 2. Remove useEffect + useState — use parallel Server Actions with Promise.all
// 3. Add companion loading.tsx with skeleton (stats row + charts + activity list)
// 4. Add companion error.tsx (Client Component, generic message, reset button)
// 5. Add empty state to each chart and the activity list
// 6. Add ResponsiveContainer to ALL Recharts charts
// 7. Add aria-labels to all charts (role="img" + aria-label on wrapper)
// 8. Replace ALL inline styles with Tailwind classes
// 9. Replace ALL hardcoded hex colors with design tokens (var(--primary-color), etc.)
// 10. Replace `any` types with contract-derived TypeScript interfaces
// 11. Extract business logic (revenueFormatted, growthPercent) to features/dashboard/utils.ts
// 12. Add mobile-first responsive layout (grid-cols-1 → grid-cols-4 for stats)
// ─────────────────────────────────────────────────────────────────────────────
