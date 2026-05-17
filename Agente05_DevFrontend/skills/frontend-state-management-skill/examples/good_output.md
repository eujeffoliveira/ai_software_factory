# Good Output: frontend-state-management-skill

Input: "We need to show the current sync job status that updates every 30 seconds"

```json
{
  "strategy": "swr_polling",
  "rationale": "Data changes on a 30-second schedule independent of user actions. A Server Component cannot auto-refresh without a page reload. SWR with refreshInterval: 30000 is correct.",
  "implementation_guidance": "Use swr-polling-skill. Endpoint: GET /api/jobs/sync/status from API_Contract.json. Client Component justified by DR005 (SWR uses browser APIs for polling).",
  "warning": null
}
```
