#!/usr/bin/env bash
# Setup for adv-006: Plugin Architect
# Scaffolds a workspace for packaging a skill + hook into a plugin. Idempotent.

WORKSPACE="$HOME/.cclab/workspace/adv-006"

# Reset learner-created artifacts so /cclab:reset restores the initial state
rm -rf "$WORKSPACE/wordsmith"

mkdir -p "$WORKSPACE"

# CLAUDE.md — explains the goal
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Wordsmith

## Project Description

This workspace is for building **wordsmith** — a distributable Claude Code
plugin that helps writers. It bundles two capabilities into one shareable
package:

1. A **prose-linting skill** (`lint-prose`) that checks writing for passive
   voice, overlong sentences, and jargon
2. A **PostToolUse hook** that logs a line to `prose-log.txt` every time a
   file is written or edited, so writers can see how much prose churn a
   session produced

## Goal

Build the complete plugin directory at `wordsmith/` inside this workspace:

- `wordsmith/.claude-plugin/plugin.json` — the plugin manifest
- `wordsmith/skills/lint-prose/SKILL.md` — the prose-linting skill
- `wordsmith/hooks/hooks.json` — the bundled hook configuration
- `wordsmith/scripts/count-prose.sh` — the hook script (executable)

See `notes.md` for the plugin layout reference.
EOF

# notes.md — plugin layout reference
cat > "$WORKSPACE/notes.md" << 'EOF'
# Plugin Layout Reference

A Claude Code plugin is just a directory with a manifest. Anyone can install
it from a marketplace or a git repo, and everything inside activates as a
unit — no manual settings edits.

## Directory layout

```
wordsmith/
├── .claude-plugin/
│   └── plugin.json          # the manifest — the only REQUIRED file
├── skills/
│   └── lint-prose/
│       └── SKILL.md         # a bundled skill (becomes /wordsmith:lint-prose)
├── hooks/
│   └── hooks.json           # bundled hooks — active whenever the plugin is enabled
└── scripts/
    └── count-prose.sh       # scripts the hooks call
```

## The manifest (.claude-plugin/plugin.json)

- `name` is the only required field — it namespaces the plugin's skills
- Common fields: `version`, `description`, `author`
- `skills`: an array of paths to skill directories, e.g.
  `["./skills/lint-prose/"]`
- `hooks`: a path to a hooks JSON file, e.g. `"./hooks/hooks.json"`

## Bundled hooks (hooks/hooks.json)

Same event/matcher/command shape as `.claude/settings.json` hooks, wrapped
in a top-level `"hooks"` key:

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolA|ToolB",
        "hooks": [
          { "type": "command", "command": "..." }
        ]
      }
    ]
  }
}
```

Key difference from settings hooks: a plugin gets installed to a path you
don't control, so hook commands must reference bundled scripts via the
`${CLAUDE_PLUGIN_ROOT}` variable — Claude Code expands it to the plugin's
install directory at runtime:

```
"command": "${CLAUDE_PLUGIN_ROOT}/scripts/my-script.sh"
```

## Hook script contract

- Receives the tool event as JSON on stdin
- For PostToolUse, exit 0 means "noted, carry on"
EOF
