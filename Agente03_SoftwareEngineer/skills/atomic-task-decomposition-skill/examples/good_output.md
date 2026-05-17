# Good Output — Atomic Task Decomposition Skill

## Input: User Authentication Feature (XL component)

**component_name:** "User Authentication"
**estimated_total_complexity:** XL
**files_affected:** NextAuth config, middleware-proxy, Prisma User model, migration, login page, session hook

---

## Good Decomposition Output

Decomposed into 5 atomic tasks:

**TASK-001: Create users table migration**
- file_path: `prisma/migrations/20260115_create_users/migration.sql`
- type: database | complexity: S
- depends_on: []

**TASK-002: Define User Prisma model**
- file_path: `prisma/schema.prisma`
- type: database | complexity: S
- depends_on: [TASK-001]

**TASK-003: Configure NextAuth v5 with Google OAuth**
- file_path: `lib/auth.ts`
- type: security | complexity: M
- depends_on: [TASK-002]
- function_signatures: `export const { handlers, auth, signIn, signOut } = NextAuth({ ... })`

**TASK-004: Implement login page Server Component**
- file_path: `app/(auth)/login/page.tsx`
- type: frontend | complexity: S
- depends_on: [TASK-003]

**TASK-005: Write Playwright E2E auth tests**
- file_path: `tests/auth.spec.ts`
- type: testing | complexity: M
- depends_on: [TASK-003, TASK-004]

**decomposition_rationale:** "XL component split along file boundaries: migration, schema, auth config, UI page, and E2E test are each self-contained and independently testable. No task exceeds M complexity."

**xl_eliminated:** true | **coverage_confirmed:** true
