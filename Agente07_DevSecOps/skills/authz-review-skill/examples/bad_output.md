# Bad Output — Authz Review Skill

**FAIL — missed CRITICAL finding:**

Report says "Auth verified in all routes" but missed `features/reports/actions/get-report.action.ts`:
```typescript
export async function getReport(reportId: string) {
  const report = await prisma.report.findUnique({ where: { id: reportId } }); // No auth! No userId scope!
  const session = await auth(); // Auth AFTER DB access
  if (!session) return { error: "Unauthorized" };
  return report;
}
```

Two CRITICAL findings missed: (1) DB access before auth() — DR002; (2) IDOR — report fetched without userId scope — DR010. The audit report would need to show `BLOCKED_AUTH_BYPASS` for both.
