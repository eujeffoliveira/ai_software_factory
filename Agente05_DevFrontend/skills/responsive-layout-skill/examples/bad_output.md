# Bad Output: responsive-layout-skill

```json
{
  "tailwind_classes": "grid lg:grid-cols-3 gap-4",
  "mobile_first_verified": false
}
```

Missing `grid-cols-1` default — on mobile, this grid has NO column definition (defaults to 1 column but this is accidental, not intentional). The `lg:grid-cols-3` without a mobile override is a mobile-first violation (DR020). On a 375px viewport, the layout may be confusing or broken depending on child widths.
