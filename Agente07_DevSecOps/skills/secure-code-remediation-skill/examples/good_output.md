# Good Output — Secure Code Remediation Skill

**Example remediation item for SEC-001 (BLOCKED_AUTH_BYPASS):**

**Wrong Pattern** (`features/reports/actions/get-report.action.ts:5-10`):
```typescript
export async function getReport(reportId: string) {
  const report = await prisma.report.findUnique({ where: { id: reportId } }); // DB before auth!
  const session = await auth();
  if (!session) return { error: "Unauthorized" };
  return report; // IDOR: no ownership check
}
```

**Correct Pattern:**
```typescript
export async function getReport(reportId: string) {
  const session = await auth(); // auth() FIRST
  if (!session) return { error: "Unauthorized" }; // guard immediately after
  const report = await prisma.report.findFirst({
    where: { id: reportId, userId: session.user.id } // ownership check prevents IDOR
  });
  if (!report) return { error: "Not found" }; // 404, not 403
  return report;
}
```

**Additional steps:** None — code change sufficient.
