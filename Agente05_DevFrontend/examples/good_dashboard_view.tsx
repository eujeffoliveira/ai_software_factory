// GOOD EXAMPLE: Full dashboard page implementation
// File: app/dashboard/page.tsx
//
// Demonstrates the complete dashboard pattern:
// ✓ Server Component page (no "use client")
// ✓ Multiple Recharts charts as Client Components (justified DR005)
// ✓ Proper data fetching via Server Actions
// ✓ Loading skeleton via loading.tsx (companion file)
// ✓ Error boundary via error.tsx (companion file)
// ✓ Empty states for each data section
// ✓ Responsive grid layout (mobile-first)
// ✓ Accessible labels on all elements
// ✓ Design tokens throughout — no hardcoded colors

// ─── Page Component (Server Component) ───────────────────────────────────────
// NO "use client" — this page reads data, delegates rendering to children

import { Suspense } from "react"
import { getDashboardMetrics } from "@/features/dashboard/actions/getDashboardMetrics"
import { getRevenueTimeSeries } from "@/features/dashboard/actions/getRevenueTimeSeries"
import { getUserGrowthSeries } from "@/features/dashboard/actions/getUserGrowthSeries"
import { StatCard } from "@/features/dashboard/components/StatCard"
import { RevenueChart } from "@/features/dashboard/components/RevenueChart"
import { UserGrowthChart } from "@/features/dashboard/components/UserGrowthChart"
import { RecentActivityList } from "@/features/dashboard/components/RecentActivityList"
import { StatCardSkeleton } from "@/components/skeletons/StatCardSkeleton"
import { ChartSkeleton } from "@/components/skeletons/ChartSkeleton"
import type { DashboardMetrics } from "@/features/dashboard/types"

// Page-level props (from Next.js App Router searchParams)
interface PageProps {
  searchParams: { period?: "7d" | "30d" | "90d" }
}

export default async function DashboardPage({ searchParams }: PageProps) {
  const period = searchParams.period ?? "30d"

  // Parallel data fetching — Promise.all for performance
  const [metrics, revenueSeries, userGrowthSeries] = await Promise.all([
    getDashboardMetrics({ period }),
    getRevenueTimeSeries({ period }),
    getUserGrowthSeries({ period }),
  ])

  return (
    <main className="w-full">
      {/* Page header */}
      <div className="mb-8">
        <h1 className="text-2xl sm:text-3xl font-bold text-[var(--text-foreground)]">
          Dashboard
        </h1>
        <p className="mt-1 text-sm text-[var(--muted-foreground)]">
          Overview for the last {period === "7d" ? "7 days" : period === "30d" ? "30 days" : "90 days"}
        </p>
      </div>

      {/* Stats row — 2 cols mobile, 4 cols desktop */}
      <section aria-label="Key metrics" className="mb-8">
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <Suspense fallback={<StatCardSkeleton />}>
            <StatCard
              label="Total Revenue"
              value={metrics?.totalRevenue ?? 0}
              format="currency"
              trend={metrics?.revenueTrend}
            />
          </Suspense>
          <Suspense fallback={<StatCardSkeleton />}>
            <StatCard
              label="Active Users"
              value={metrics?.activeUsers ?? 0}
              format="number"
              trend={metrics?.userTrend}
            />
          </Suspense>
          <Suspense fallback={<StatCardSkeleton />}>
            <StatCard
              label="New Signups"
              value={metrics?.newSignups ?? 0}
              format="number"
              trend={metrics?.signupTrend}
            />
          </Suspense>
          <Suspense fallback={<StatCardSkeleton />}>
            <StatCard
              label="Conversion Rate"
              value={metrics?.conversionRate ?? 0}
              format="percent"
              trend={metrics?.conversionTrend}
            />
          </Suspense>
        </div>
      </section>

      {/* Charts row — 1 col mobile, 2 cols desktop */}
      <section aria-label="Performance charts" className="mb-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Revenue chart — Client Component (Recharts requires DR005) */}
          <div className="rounded-lg border border-[var(--border)] bg-[var(--bg-background)] p-4">
            <h2 className="text-base font-semibold text-[var(--text-foreground)] mb-4">
              Revenue Over Time
            </h2>
            {/* RevenueChart is a Client Component — Recharts justification */}
            <RevenueChart data={revenueSeries} title="Revenue Over Time" height={280} />
          </div>

          {/* User growth chart */}
          <div className="rounded-lg border border-[var(--border)] bg-[var(--bg-background)] p-4">
            <h2 className="text-base font-semibold text-[var(--text-foreground)] mb-4">
              User Growth
            </h2>
            <UserGrowthChart data={userGrowthSeries} title="User Growth" height={280} />
          </div>
        </div>
      </section>

      {/* Recent activity — full width */}
      <section aria-label="Recent activity" className="mb-8">
        <div className="rounded-lg border border-[var(--border)] bg-[var(--bg-background)] p-4">
          <h2 className="text-base font-semibold text-[var(--text-foreground)] mb-4">
            Recent Activity
          </h2>
          {/* Server Component — reads a list, handles empty state internally */}
          <RecentActivityList period={period} />
        </div>
      </section>
    </main>
  )
}

// ─── RevenueChart (Client Component) ─────────────────────────────────────────
// File: features/dashboard/components/RevenueChart.tsx
// (shown here inline for illustration — would be in its own file)
//
// "use client"
// // JUSTIFICATION: Recharts requires browser APIs — DR005-recharts
// import { ResponsiveContainer, AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip } from "recharts"
//
// interface RevenueDataPoint {
//   label: string  // from API_Contract.json
//   revenue: number
// }
//
// interface Props {
//   data: RevenueDataPoint[]
//   title: string
//   height: number
// }
//
// export function RevenueChart({ data, title, height }: Props) {
//   if (!data || data.length === 0) {
//     return (
//       <div
//         className="flex items-center justify-center text-[var(--muted-foreground)]"
//         style={{ height }}
//         role="img"
//         aria-label={`${title} — no data available`}
//       >
//         <span className="text-sm">No revenue data for this period</span>
//       </div>
//     )
//   }
//
//   return (
//     <div role="img" aria-label={`${title} area chart`} style={{ height }}>
//       <ResponsiveContainer width="100%" height="100%">
//         <AreaChart data={data}>
//           <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
//           <XAxis dataKey="label" tick={{ fill: "var(--muted-foreground)", fontSize: 12 }} />
//           <YAxis tick={{ fill: "var(--muted-foreground)", fontSize: 12 }} width={50} />
//           <Tooltip />
//           <Area
//             type="monotone"
//             dataKey="revenue"
//             stroke="var(--primary-color)"
//             fill="var(--primary-color)"
//             fillOpacity={0.1}
//             strokeWidth={2}
//           />
//         </AreaChart>
//       </ResponsiveContainer>
//     </div>
//   )
// }

// ─── Companion Files (required) ────────────────────────────────────────────────
// app/dashboard/loading.tsx — skeleton matching stats row + 2 chart areas + activity list
// app/dashboard/error.tsx   — Client Component, reset button, no error.message exposed
