# Bad Output: frontend-state-management-skill

Input: "We need to display the list of entities for the organization"

```json
{
  "strategy": "swr_polling",
  "rationale": "Using SWR to fetch entities for display.",
  "implementation_guidance": "Add useSWR('/api/entities') to the component."
}
```

Problems:
1. "Display a list" is a read-only, page-load operation → should be `none_server_component`
2. No polling requirement mentioned → SWR is wrong strategy (FM-09)
3. No `refreshInterval` → SWR without polling is explicitly forbidden
4. The correct answer is `strategy: "none_server_component"` with a Server Component using a Server Action.
