# User Story Mapping Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

---

## Output JSON (WRONG)

```json
{
  "artifact_path": "project/User_Story_Map.md",
  "stories": [
    {
      "id": "S1",
      "persona": "user",
      "activity": "general",
      "story": "As a user, I want to manage tasks",
      "priority": "HIGH",
      "invest_pass": true
    },
    {
      "id": "S2",
      "persona": "user",
      "activity": "general",
      "story": "As a developer, I want to create the task API so that tasks can be stored",
      "priority": "MUST",
      "invest_pass": true
    },
    {
      "id": "S1",
      "persona": "user",
      "activity": "general",
      "story": "As a user, I want to manage tasks",
      "priority": "HIGH",
      "invest_pass": true
    }
  ],
  "mvp_story_ids": [],
  "invest_validation_passed": true,
  "invest_failures": [],
  "features_without_stories": []
}
```

<!-- PROBLEMA 1: Story ID "S1" does not follow US-NNN convention. ID must be US-001, US-002, etc.
     PROBLEMA 2: "S1" appears twice — duplicate story. This means the INVEST "Independent" check was not run properly.
     PROBLEMA 3: Persona "user" is not a defined persona. It is too generic to be useful. What type of user? What role?
     PROBLEMA 4: Activity "general" is not an activity — it is a placeholder. Activities should be named user goals (e.g., "Manage Daily Tasks", "Monitor Team Progress").
     PROBLEMA 5: Story "As a user, I want to manage tasks" has no "so that [benefit]" clause. Incomplete story format. Would fail INVEST Valuable and Testable.
     PROBLEMA 6: Priority "HIGH" is not a valid value. Must be MUST / SHOULD / COULD.
     PROBLEMA 7: Story S2 — "As a developer" is a technical task, not a user story. The Valuable dimension fails immediately.
     PROBLEMA 8: invest_pass = true for all stories including the broken ones — INVEST check was clearly not run.
     PROBLEMA 9: invest_validation_passed = true and invest_failures = [] despite obvious failures — contradicts reality.
     PROBLEMA 10: mvp_story_ids is empty — the MVP boundary is undefined. -->
