# Hints for adv-006: Plugin Architect

## Hint 1

Four files, one wiring idea: the manifest at
`wordsmith/.claude-plugin/plugin.json` declares everything else. Its
`"skills"` array points at the skill directory, and its `"hooks"` field
points at `./hooks/hooks.json`. Scaffold the tree first
(`mkdir -p wordsmith/.claude-plugin wordsmith/skills/lint-prose
wordsmith/hooks wordsmith/scripts`), then fill in the files. `notes.md` in
the workspace has the exact layout and field names — and the cclab plugin
you're using right now follows the same structure if you want a living
example.

## Hint 2

The manifest needs `"name": "wordsmith"`, a `"version"`, a
`"description"`, `"skills": ["./skills/lint-prose/"]`, and
`"hooks": "./hooks/hooks.json"`. The SKILL.md needs frontmatter
(`name: lint-prose`, `description: ...`) plus a body with a `#` heading
and at least 3 numbered steps (passive voice, sentences over ~25 words,
jargon). The hooks.json is the adv-002 shape wrapped in a top-level
`"hooks"` key: event `PostToolUse`, matcher `Write|Edit`, and a command of
`${CLAUDE_PLUGIN_ROOT}/scripts/count-prose.sh` — keep that variable
literal; Claude Code expands it at install location, not you. The script
reads stdin, appends one line to `prose-log.txt`, and ends with `exit 0`.
Don't forget `chmod +x`.

## Hint 3

Create `wordsmith/.claude-plugin/plugin.json`:

```json
{
  "name": "wordsmith",
  "version": "1.0.0",
  "description": "Prose linting skill plus a hook that logs prose churn",
  "skills": ["./skills/lint-prose/"],
  "hooks": "./hooks/hooks.json"
}
```

Create `wordsmith/skills/lint-prose/SKILL.md`:

```markdown
---
name: lint-prose
description: Lint prose for passive voice, long sentences, and jargon. Use when the user asks to review or polish writing.
---

# Lint Prose

Review the given text and report issues:

1. Flag passive voice constructions ("was written by") and suggest an
   active rewrite.
2. Flag sentences longer than 25 words and propose where to split them.
3. Flag jargon and buzzwords ("synergy", "leverage", "utilize") and offer
   plain alternatives.
```

Create `wordsmith/hooks/hooks.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/count-prose.sh"
          }
        ]
      }
    ]
  }
}
```

Create `wordsmith/scripts/count-prose.sh`:

```bash
#!/usr/bin/env bash
input="$(cat)"
echo "$(date '+%Y-%m-%d %H:%M:%S') prose event: ${#input} bytes" >> prose-log.txt
exit 0
```

Make it executable, then verify with a payload file (don't pipe strings
into sh):

```bash
chmod +x wordsmith/scripts/count-prose.sh
cat > /tmp/payload.json << 'EOF'
{"hook_event_name":"PostToolUse","tool_name":"Write","tool_input":{"file_path":"draft.md"}}
EOF
./wordsmith/scripts/count-prose.sh < /tmp/payload.json; echo "exit: $?"
cat prose-log.txt   # expect one appended line
```
