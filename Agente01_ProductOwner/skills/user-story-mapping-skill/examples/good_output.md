# User Story Mapping Skill — Good Output Example

_GOOD EXAMPLE — Story map for a Task Management Platform with 2 personas, 3 activities, 6 stories._

---

## Output JSON

```json
{
  "artifact_path": "project/User_Story_Map.md",
  "stories": [
    {
      "id": "US-001",
      "persona": "Team Member",
      "activity": "Manage Daily Tasks",
      "story": "As a team member, I want to create a task with a title, description, and due date, so that my work items are tracked in one place and I don't lose track of commitments",
      "priority": "MUST",
      "invest_pass": true
    },
    {
      "id": "US-002",
      "persona": "Team Member",
      "activity": "Manage Daily Tasks",
      "story": "As a team member, I want to mark a task as completed, so that my manager can see my progress without asking me directly",
      "priority": "MUST",
      "invest_pass": true
    },
    {
      "id": "US-003",
      "persona": "Team Member",
      "activity": "Manage Daily Tasks",
      "story": "As a team member, I want to filter my task list by status (open, in progress, completed), so that I can focus on what needs attention without scrolling through all tasks",
      "priority": "SHOULD",
      "invest_pass": true
    },
    {
      "id": "US-004",
      "persona": "Project Manager",
      "activity": "Monitor Team Progress",
      "story": "As a project manager, I want to view all open tasks assigned to my team on a single dashboard, so that I can identify bottlenecks without asking each team member individually",
      "priority": "MUST",
      "invest_pass": true
    },
    {
      "id": "US-005",
      "persona": "Project Manager",
      "activity": "Monitor Team Progress",
      "story": "As a project manager, I want to reassign an open task from one team member to another, so that workload can be rebalanced when a team member is unavailable",
      "priority": "SHOULD",
      "invest_pass": true
    },
    {
      "id": "US-006",
      "persona": "Project Manager",
      "activity": "Reporting",
      "story": "As a project manager, I want to export a summary of completed tasks for a selected date range as a CSV file, so that I can include the data in weekly status reports without manual re-entry",
      "priority": "COULD",
      "invest_pass": true
    }
  ],
  "mvp_story_ids": ["US-001", "US-002", "US-004"],
  "invest_validation_passed": true,
  "invest_failures": [],
  "features_without_stories": []
}
```

## Why This is Good

- All 6 stories have the 3-part format with a genuine business benefit in "so that"
- Stories organized by persona (Team Member, Project Manager) then by activity
- INVEST pass = true for all stories
- MVP boundary is explicit: US-001, US-002, US-004 (3 MUST stories)
- No technical tasks (no "database setup" story)
- No duplicate stories
- features_without_stories is empty — all features are covered
