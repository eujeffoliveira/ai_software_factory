# Bad Output — Execution Plan Generation Skill

## Scenario: Same UserProfile feature — WRONG approach

This example shows what happens when the skill is applied incorrectly: mega-tasks, missing fields, and a false gate_ready.

```json
{
  "plan_id": "plan-bad",
  "version": "1.0",
  "project": "UserProfile Feature",
  "tasks": [
    {
      "task_id": "TASK-001",
      "title": "Build the whole user profile system",
      "description": "Implement everything for user profiles.",
      "type": "backend",
      "file_path": null,
      "depends_on": [],
      "acceptance_criteria": [],
      "test_requirements": {},
      "security_requirements": {},
      "estimated_complexity": "M",
      "status": "pending"
    }
  ],
  "critical_path": [],
  "gate_ready": true
}
```

## Problems (7 blocking conditions)

1. **Missing architecture_version and prd_version** — cannot trace plan to source documents
2. **Mega-task TASK-001** — "the whole user profile system" should be 3–5 atomic tasks (DR001, FM-01)
3. **file_path: null** — dev agent cannot know which file to create (DR004, FM-06)
4. **acceptance_criteria: []** — no way to verify the task is complete (P4, FM-03)
5. **test_requirements: {}** — no test type defined (P7, FM-09)
6. **security_requirements: {}** — auth, validation, audit log all missing (P6, DR007–DR008, FM-08)
7. **gate_ready: true** — falsely set; this plan would be RETURNED_FOR_REVISION at Gate 3

## Correct Gate Status

```
gate_status: RETURNED_FOR_REVISION
gate_ready: false
blocking_issues: [
  "TASK-001 has file_path: null — DR004",
  "TASK-001 has empty acceptance_criteria — P4",
  "TASK-001 has empty test_requirements — P7",
  "TASK-001 has incomplete security_requirements — DR007, DR008",
  "TASK-001 complexity M is an underestimate — actual scope is XL, must split — DR001"
]
```
