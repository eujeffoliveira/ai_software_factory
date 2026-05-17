# Example: Good Architecture — Task Management SaaS

_This is a realistic good example of Architecture.md produced by Agente02_SoftwareArchitect._

---

# Architecture.md — TaskFlow SaaS

**Version:** 1.0  
**Date:** 2026-05-17  
**Golden Path Status:** FULLY_COMPLIANT

## 1. Executive Summary

TaskFlow is a multi-tenant task management SaaS built as a Next.js 16 fullstack monorepo deployed on Vercel. The architecture follows the Golden Path fully — no ADRs are required. The system manages projects, tasks, and team members with role-based access control and a daily digest cron job.

## 2. Architecture Style

**Style:** fullstack-monorepo  
**Justification:** PRD NFR-01 (response time < 500ms for initial load) and NFR-02 (operational budget constraint) both favor a Next.js monorepo with Server Components. No use case requires a separate service.

## 3. System Components

| Component | Type | Location | Responsibility |
|-----------|------|----------|----------------|
| Proxy Guard | proxy | `proxy.ts` | Session check, cron protection |
| Auth | auth | `auth.ts` | NextAuth v5 Google OAuth, domain restriction, user status |
| Health | route-handler | `app/api/health/route.ts` | DB + app liveness |
| Projects Page | server-component | `app/(protected)/projects/page.tsx` | List all projects for user |
| Task Detail | server-component | `app/(protected)/tasks/[id]/page.tsx` | Task details with subtasks |
| Create Task | server-action | `actions/tasks.ts` | Create task with validation |
| Tasks API | route-handler | `app/api/tasks/route.ts` | SWR polling (task status updates) |
| Daily Digest | cron-route | `app/api/cron/daily-digest/route.ts` | Send daily summary |
| Tasks DAL | dal | `lib/db/tasks.ts` | All task queries |
| Projects DAL | dal | `lib/db/projects.ts` | All project queries |
| Task Service | service | `features/tasks/tasks.service.ts` | Task business logic |
| Digest Job | job | `lib/jobs/daily-digest.ts` | Build and send digest |

## 4. Data Flows

### Stable Read
```
Browser → proxy.ts → Server Component (auth()) → lib/db/tasks.ts → PostgreSQL
```

### Mutation
```
Browser → Server Action → auth() → role check → features/tasks/tasks.service.ts → lib/db/tasks.ts → audit_log → revalidatePath()
```

### Cron
```
Vercel Cron → /api/cron/daily-digest → guardCron() → lib/jobs/daily-digest.ts → lib/db/ → sync_log
```

## 5. PRD Traceability

| PRD Requirement | Architectural Decision | Component |
|----------------|----------------------|-----------|
| NFR-01: < 500ms initial load | Server Components for all project/task lists | app/(protected)/ |
| NFR-02: Audit trail for task operations | audit_log on create/update/delete | lib/db/audit-log.ts |
| FR-01: Google login only | NextAuth v5 + Google OAuth + domain restriction | auth.ts |
| FR-05: Daily email digest | Vercel Cron + digest job + sync_log | lib/jobs/daily-digest.ts |
