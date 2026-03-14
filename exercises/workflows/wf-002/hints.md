# Hints for wf-002: Guard Rails

## Hint 1

Permissions go in `.claude/settings.json` under `"permissions"`. Think about
what Claude should be able to do freely (read code, run tests, search files)
and what it should never do (edit secrets, delete files). Use `"allow"` and
`"deny"` arrays to set your rules.

## Hint 2

Create `.claude/settings.json` with `{"permissions": {"allow": [...], "deny":
[...]}}`. Allow rules use tool patterns like `"Read"` (all reads) or
`"Bash(npm *)"` (npm commands only). Deny rules protect files:
`"Edit(.env)"` blocks editing .env. Include at least 3 allow rules and at
least 2 deny rules.

## Hint 3

Create this settings.json:

```json
{
  "permissions": {
    "allow": ["Read", "Bash(npm *)", "Grep", "Glob"],
    "deny": ["Edit(.env)", "Edit(/secrets/**)", "Bash(rm *)"]
  }
}
```

This allows reading and npm commands while blocking edits to `.env`, the
`secrets/` directory, and destructive bash commands like `rm`.
