# User Story Mapping Skill — Checklist

## Before Execution
- [ ] All personas have been confirmed through elicitation (not invented)
- [ ] All features in the feature_list have been confirmed (not assumed)
- [ ] Business problem is clearly articulated before writing stories

## During Execution
- [ ] Each story follows the 3-part format: "As a [user], I want [action], so that [benefit]"
- [ ] "So that [benefit]" is a genuine business benefit — not a restatement of the action
- [ ] No story has "developer", "system", or "admin backend" as the persona (must be a real user role)
- [ ] Stories are organized by persona → activity → task
- [ ] INVEST checklist is run for each story individually before it is added to the map
- [ ] Epics found during mapping are decomposed before inclusion

## Output Validation
- [ ] All features from the input feature_list are traceable to at least one user story
- [ ] `invest_validation_passed` is true — no story has a failing INVEST dimension
- [ ] `features_without_stories` array is empty (no coverage gap)
- [ ] MVP boundary is explicit: all MUST stories listed in `mvp_story_ids`
- [ ] Story IDs are sequential: US-001, US-002, etc. with no gaps
- [ ] No two stories are duplicates of each other

## Runtime Knowledge Policy
- [ ] Skill reads only from `Agente01_ProductOwner/` and project inputs — never from `context/`, `lib/`, or raw books
- [ ] INVEST criteria applied from `checklists/invest_checklist.md` — not from external references
