# Good Output: server-component-selection-skill

## Input

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

## Output

```json
{
  "component_name": "EntityCard",
  "component_type": "ServerComponent",
  "justification": "EntityCard only reads props and renders content — no state, effects, event handlers, browser APIs, or browser-only libraries. All client-trigger checks (DR001–DR005) return false. Server Component is correct.",
  "client_trigger": null,
  "recommended_template": "Server_Component_Template.tsx",
  "companion_files_needed": {
    "loading_tsx": false,
    "error_tsx": false,
    "empty_state": false
  }
}
```

## Why This Output Is Good

- Correctly identifies Server Component — no triggers apply
- Justification is specific (references DR001–DR005 explicitly)
- No companion files needed — EntityCard is not a page route
- Recommends the correct template
