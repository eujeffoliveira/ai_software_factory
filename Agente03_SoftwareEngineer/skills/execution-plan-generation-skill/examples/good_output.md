# Good Output — Execution Plan Generation Skill

## Scenario: 3-task fragment for UserProfile feature

This example shows a well-formed 3-task fragment of an execution plan covering: DB migration, Prisma model definition, and a Server Action for updating a user profile.

```json
{
  "plan_id": "plan-userprofile-fragment",
  "version": "1.0",
  "project": "UserProfile Feature — Fragment",
  "created_at": "2026-01-15T10:00:00Z",
  "architecture_version": "v1.1",
  "prd_version": "v1.3",
  "tasks": [
    {
      "task_id": "TASK-001",
      "title": "Create user_profiles table migration",
      "description": "Creates the migration for the user_profiles table with fields: id, user_id, display_name, bio, avatar_url, created_at, updated_at.",
      "type": "database",
      "layer": "infrastructure",
      "file_path": "prisma/migrations/20260115000001_create_user_profiles/migration.sql",
      "function_signatures": [],
      "depends_on": [],
      "acceptance_criteria": [
        "user_profiles table created with all specified columns",
        "Foreign key constraint to users table is correct",
        "prisma migrate deploy succeeds in CI"
      ],
      "test_requirements": {
        "unit_required": false,
        "integration_required": true,
        "integration_tool": "Vitest",
        "e2e_required": false
      },
      "security_requirements": {
        "auth_required": false,
        "authorization_check": false,
        "input_validation_required": false,
        "audit_log_required": false
      },
      "estimated_complexity": "S",
      "status": "pending",
      "blocking_reason": null
    },
    {
      "task_id": "TASK-002",
      "title": "Define UserProfile Prisma model",
      "description": "Adds UserProfile model to prisma/schema.prisma with relation to User model and all required fields.",
      "type": "database",
      "layer": "infrastructure",
      "file_path": "prisma/schema.prisma",
      "function_signatures": [],
      "depends_on": ["TASK-001"],
      "acceptance_criteria": [
        "UserProfile model defined with correct Prisma types",
        "@relation to User model is correctly mapped",
        "prisma generate produces correct TypeScript types"
      ],
      "test_requirements": {
        "unit_required": false,
        "integration_required": true,
        "integration_tool": "Vitest",
        "e2e_required": false
      },
      "security_requirements": {
        "auth_required": false,
        "authorization_check": false,
        "input_validation_required": false,
        "audit_log_required": false
      },
      "estimated_complexity": "S",
      "status": "pending",
      "blocking_reason": null
    },
    {
      "task_id": "TASK-003",
      "title": "Implement updateUserProfile Server Action",
      "description": "Server Action that validates input with UpdateUserProfileSchema, updates the user profile record via DAL, and writes audit_log entry with event 'profile.updated'.",
      "type": "backend",
      "layer": "business-logic",
      "file_path": "features/profile/actions/updateUserProfile.ts",
      "function_signatures": [
        "'use server'",
        "export const UpdateUserProfileSchema = z.object({ display_name: z.string().min(1).max(100), bio: z.string().max(500).optional(), avatar_url: z.string().url().optional() })",
        "export async function updateUserProfile(input: UpdateUserProfileInput): Promise<ActionResult<UserProfile>>"
      ],
      "depends_on": ["TASK-001", "TASK-002"],
      "acceptance_criteria": [
        "Function validates input with UpdateUserProfileSchema",
        "Function returns updated UserProfile on success",
        "Unauthenticated calls return { error: 'UNAUTHORIZED' }",
        "Function writes audit_log entry with event 'profile.updated'"
      ],
      "test_requirements": {
        "unit_required": true,
        "unit_tool": "Vitest",
        "unit_coverage_target": 85,
        "integration_required": true,
        "integration_tool": "Vitest",
        "e2e_required": false,
        "mock_requirements": ["Prisma client", "NextAuth getServerSession"]
      },
      "security_requirements": {
        "auth_required": true,
        "authorization_check": true,
        "authorization_level": "authenticated",
        "input_validation_required": true,
        "zod_schema_name": "UpdateUserProfileSchema",
        "audit_log_required": true,
        "audit_event_type": "profile.updated"
      },
      "estimated_complexity": "M",
      "status": "pending",
      "blocking_reason": null
    }
  ],
  "critical_path": ["TASK-001", "TASK-002", "TASK-003"],
  "parallel_tracks": [],
  "gate_ready": true
}
```

## Why This is Good

- TASK-001 is the root (no dependencies), enabling topological sort
- TASK-002 correctly depends on TASK-001 (migration must run before schema is updated)
- TASK-003 depends on both TASK-001 and TASK-002 (needs table + model)
- All tasks have file_path, acceptance_criteria, test_requirements, security_requirements
- No XL tasks — all are S or M
- gate_ready: true is valid given all checks pass
