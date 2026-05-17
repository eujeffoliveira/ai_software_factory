"use client"
// [TEMPLATE] Recharts Chart Component
// File: features/[domain]/components/[MetricName]Chart.tsx
//
// JUSTIFICATION: Recharts requires browser APIs (SVG, DOM measurement) — must be Client Component.
//               Decision Rule DR005-recharts applies.
//
// RULES:
// - "use client" is REQUIRED (Recharts cannot run server-side)
// - ResponsiveContainer MUST wrap the chart (never fixed width/height)
// - Parent container MUST have an explicit height (Recharts requires it)
// - ALWAYS handle empty data BEFORE rendering the chart
// - Colors MUST use design tokens (var(--primary-color), not hex)
// - role="img" + aria-label on the wrapper (chart is visual content)
// - Data preparation happens OUTSIDE this component (in the parent or a util function)
//
// USAGE:
// 1. Replace [MetricName] with your metric name (e.g., SalesMetrics, UserGrowth)
// 2. Replace [domain] with your feature domain (kebab-case)
// 3. Update ChartDataPoint to match the data shape from API_Contract.json
// 4. Choose the appropriate chart type (see Card 006 in knowledge_cards.md)
// 5. Update axis dataKeys to match your data shape
// 6. Remove this comment block

import {
  ResponsiveContainer,
  LineChart,
  Line,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  type TooltipProps,
} from "recharts"

// TypeScript interface derived from API_Contract.json — never invented
// Replace this with the actual contract-derived type for your data
interface ChartDataPoint {
  label: string      // X-axis label (date, category name, etc.)
  value: number      // Primary metric value
  secondary?: number // Optional secondary series
}

interface Props {
  data: ChartDataPoint[]
  title: string
  height?: number
  // Add additional props as needed (e.g., color overrides, unit labels)
}

// Custom Tooltip for branded styling (optional — remove if default is acceptable)
function CustomTooltip({ active, payload, label }: TooltipProps<number, string>) {
  if (!active || !payload?.length) return null

  return (
    <div
      className={[
        "rounded-md border border-[var(--border)]",
        "bg-[var(--bg-background)] shadow-md p-3",
        "text-xs text-[var(--text-foreground)]",
      ].join(" ")}
      role="tooltip"
    >
      <p className="font-semibold mb-1">{label}</p>
      {payload.map((entry) => (
        <p key={entry.name} className="text-[var(--muted-foreground)]">
          {entry.name}: <span className="font-medium text-[var(--text-foreground)]">{entry.value}</span>
        </p>
      ))}
    </div>
  )
}

export function MetricNameChart({ data, title, height = 300 }: Props) {
  // ALWAYS check empty data before rendering Recharts
  // An empty chart is a broken chart — render EmptyState instead
  if (!data || data.length === 0) {
    return (
      <div
        className="flex flex-col items-center justify-center bg-[var(--bg-background)]
                   rounded-lg border border-[var(--border)] text-[var(--muted-foreground)]"
        style={{ height: `${height}px` }}
        aria-label={`${title} — no data available`}
        role="img"
      >
        <svg
          className="w-8 h-8 mb-2"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          strokeWidth={1.5}
          aria-hidden="true"
        >
          <path strokeLinecap="round" strokeLinejoin="round"
            d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
        </svg>
        <span className="text-sm">No data available</span>
      </div>
    )
  }

  return (
    // Accessible wrapper: role="img" + descriptive aria-label
    <div
      role="img"
      aria-label={`${title} line chart showing ${data.length} data points`}
      className="w-full"
      style={{ height: `${height}px` }}
    >
      {/* ResponsiveContainer is MANDATORY — never fixed width */}
      <ResponsiveContainer width="100%" height="100%">
        <LineChart
          data={data}
          margin={{ top: 5, right: 20, left: 0, bottom: 5 }}
        >
          {/* Grid lines use border token */}
          <CartesianGrid
            strokeDasharray="3 3"
            stroke="var(--border)"
            opacity={0.5}
          />

          {/* X Axis — muted foreground for labels */}
          <XAxis
            dataKey="label"
            tick={{ fill: "var(--muted-foreground)", fontSize: 12 }}
            axisLine={{ stroke: "var(--border)" }}
            tickLine={{ stroke: "var(--border)" }}
          />

          {/* Y Axis — muted foreground for labels */}
          <YAxis
            tick={{ fill: "var(--muted-foreground)", fontSize: 12 }}
            axisLine={{ stroke: "var(--border)" }}
            tickLine={{ stroke: "var(--border)" }}
            width={40}
          />

          {/* Custom tooltip */}
          <Tooltip content={<CustomTooltip />} />

          {/* Legend — only include if multiple series */}
          <Legend
            wrapperStyle={{
              fontSize: "12px",
              color: "var(--muted-foreground)",
            }}
          />

          {/* Primary data series — MUST use design token color */}
          <Line
            type="monotone"
            dataKey="value"
            name="Value"
            stroke="var(--primary-color)"
            strokeWidth={2}
            dot={{ fill: "var(--primary-color)", r: 3 }}
            activeDot={{ r: 5, fill: "var(--primary-color)" }}
          />

          {/* Optional secondary series */}
          {data.some((d) => d.secondary !== undefined) && (
            <Line
              type="monotone"
              dataKey="secondary"
              name="Secondary"
              stroke="var(--secondary-color)"
              strokeWidth={2}
              strokeDasharray="5 5"
              dot={{ fill: "var(--secondary-color)", r: 3 }}
            />
          )}
        </LineChart>
      </ResponsiveContainer>

      {/* Accessible data table — visually hidden, available to screen readers */}
      <table className="sr-only" aria-label={`${title} data table`}>
        <thead>
          <tr>
            <th scope="col">Label</th>
            <th scope="col">Value</th>
          </tr>
        </thead>
        <tbody>
          {data.map((point) => (
            <tr key={point.label}>
              <td>{point.label}</td>
              <td>{point.value}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
