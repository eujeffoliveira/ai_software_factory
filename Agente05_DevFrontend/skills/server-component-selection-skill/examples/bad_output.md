# Bad Output: server-component-selection-skill

## Input (same as good example)

```json
{
  "component_name": "EntityCard",
  "component_requirements": [
    "Display entity name, description, status badge",
    "Show entity thumbnail image",
    "Show creation date",
    "Link to entity detail page"
  ],
  "uses_state": false,
  "uses_effects": false,
  "uses_event_handlers": false,
  "uses_browser_apis": false,
  "uses_recharts": false,
  "file_path": "features/entities/components/EntityCard.tsx"
}
```

## BAD Output

```json
{
  "component_name": "EntityCard",
  "component_type": "ClientComponent",
  "justification": "Made it a Client Component for safety, in case we need interactivity later.",
  "client_trigger": null,
  "recommended_template": "Client_Component_Template.tsx"
}
```

## Why This Output Is Bad

1. **Wrong component type** — EntityCard has zero client triggers. Should be ServerComponent.
2. **Invalid justification** — "for safety" and "in case we need it later" are explicitly invalid justifications per P2 and the checklist.
3. **`client_trigger` is null but `component_type` is ClientComponent** — contradiction. Client Components MUST have a trigger.
4. **Wrong template** — Client_Component_Template.tsx would add `"use client"` unnecessarily.
5. **Impact of this mistake** — EntityCard would ship JavaScript to the browser unnecessarily, prevent server-side rendering, and add to bundle size. This is FM-01: Client Component Overuse.

## Correct Outcome

The correct output is `component_type: "ServerComponent"`. "Use client for safety" is not a reason — it is a violation.
