# Good Output: recharts-dashboard-skill

Output record:
```json
{
  "file_path": "features/metrics/components/RevenueLineChart.tsx",
  "has_responsive_container": true,
  "has_empty_state": true,
  "has_aria_label": true,
  "has_sr_table": true,
  "uses_token_colors": true,
  "typescript_interface": "RevenueDataPoint"
}
```

The component correctly: wraps chart in ResponsiveContainer, uses `var(--primary-color)` for line stroke, handles `data.length === 0` with an EmptyState, adds `role="img"` + `aria-label` on wrapper, includes `<table class="sr-only">` for screen readers.
