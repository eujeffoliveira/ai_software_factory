# Bad Output: recharts-dashboard-skill

```json
{
  "file_path": "features/metrics/components/RevenueLineChart.tsx",
  "has_responsive_container": false,
  "has_empty_state": false,
  "has_aria_label": false,
  "uses_token_colors": false
}
```

The component uses `<LineChart width={600} height={300}>` — fixed pixels, no ResponsiveContainer. Result: chart is 600px on mobile (overflow), 600px on desktop (not full width). Missing empty state means a blank area when no data. Hardcoded `stroke="#3b82f6"` blocks Gate 4. No aria-label means screen readers skip the chart entirely.
