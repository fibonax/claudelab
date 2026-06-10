# Plugin Architect

This is the advanced-track capstone. You've built skills, subagents, and
hooks — but so far each one lived in a single project's `.claude/`
directory, configured by hand. A **plugin** packages those pieces into one
distributable directory that anyone can install. Skills, hooks, and scripts
travel together, activate together, and uninstall together.

Here's the meta moment: **cclab itself is a plugin built exactly this
way**. The `/cclab:start` and `/cclab:check` commands you've been using are
bundled skills, and the tool logging that validated cc-009 is a bundled
`PostToolUse` hook — installed automatically when you enabled the plugin,
without you ever touching a settings file. In this exercise you build the
same machinery from scratch.

## How Plugins Work

A plugin is a directory with a manifest at `.claude-plugin/plugin.json`:

- `name` is the only **required** field — it namespaces the plugin's
  skills (skill `lint-prose` in plugin `wordsmith` becomes
  `/wordsmith:lint-prose`)
- Common metadata: `version`, `description`, `author`
- `skills`: an array of paths to skill directories, e.g.
  `["./skills/lint-prose/"]`
- `hooks`: a path to a hooks JSON file, e.g. `"./hooks/hooks.json"`

Bundled hooks are the part that makes plugins more than a zip of skills:
they **activate automatically when the plugin is enabled** — no user edits
to `.claude/settings.json`. Because the plugin is installed to a path you
don't control, hook commands reference bundled scripts through the
`${CLAUDE_PLUGIN_ROOT}` variable, which Claude Code expands to the plugin's
install directory at runtime.

## Your Task

Build **wordsmith**, a plugin for writers, at `wordsmith/` inside the
workspace. It bundles a prose-linting skill and a hook that logs prose
churn. Four pieces:

### Part 1: The manifest

Create `wordsmith/.claude-plugin/plugin.json` — valid JSON with:

- `"name": "wordsmith"`
- `"version"` and `"description"`
- `"skills"` array that includes `"./skills/lint-prose/"`
- `"hooks": "./hooks/hooks.json"`

### Part 2: The bundled skill

Create `wordsmith/skills/lint-prose/SKILL.md` with:

- YAML frontmatter: `name: lint-prose` and a `description:` that says when
  to use it (e.g., "Lint prose for passive voice, long sentences, and
  jargon. Use when the user asks to review or polish writing.")
- A body with a `#` heading and **at least 3 numbered steps** describing
  the linting procedure — check for passive voice, flag sentences over ~25
  words, call out jargon and buzzwords

### Part 3: The bundled hook

Create `wordsmith/hooks/hooks.json` — valid JSON wiring a `PostToolUse`
hook with:

- A `"matcher"` of `"Write|Edit"` (fire whenever prose gets written or
  edited)
- A `"type": "command"` hook whose `"command"` is
  `${CLAUDE_PLUGIN_ROOT}/scripts/count-prose.sh`

### Part 4: The hook script

Create `wordsmith/scripts/count-prose.sh` that:

1. Reads the event JSON from **stdin** (e.g., `input="$(cat)"`)
2. Appends one line to `prose-log.txt` in the current directory (a
   timestamp, a byte count — anything that records the event)
3. Exits `0` — a PostToolUse observer should never break the session

Make it executable: `chmod +x wordsmith/scripts/count-prose.sh`.

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/adv-006/
```

Read `notes.md` — it has the full plugin layout reference, the manifest
fields, and the hooks.json shape. The workspace is otherwise empty on
purpose: building the whole `wordsmith/` tree is the exercise.

A good order: scaffold the directories first, then manifest → skill →
hooks.json → script. Each part is small; the craft is in getting the
wiring between them right.

## Requirements

- `wordsmith/.claude-plugin/plugin.json` exists, is valid JSON, names the
  plugin `wordsmith`, lists the skill in a `"skills"` array, and points
  `"hooks"` at the hooks file
- `wordsmith/skills/lint-prose/SKILL.md` has `name: lint-prose` and
  `description:` in its frontmatter, a `#` heading, and at least 3
  numbered steps
- `wordsmith/hooks/hooks.json` is valid JSON with a `PostToolUse` event, a
  matcher covering `Write` and `Edit`, and a command that uses
  `${CLAUDE_PLUGIN_ROOT}`
- `wordsmith/scripts/count-prose.sh` is executable, reads stdin, appends
  to `prose-log.txt`, and exits `0`

The script check is **behavioral** — the validator actually runs
`count-prose.sh` with a payload on stdin and expects exit `0` plus a
freshly written `prose-log.txt`. A script that merely looks right won't
pass.

## Tips

- The hooks.json shape is the same one you used in adv-002's
  `.claude/settings.json`, just wrapped in a file of its own — event name,
  matcher, then a `hooks` array of `{ "type": "command", "command": ... }`
- Quote `${CLAUDE_PLUGIN_ROOT}` exactly — it's a literal string in the
  JSON; Claude Code expands it at runtime, not you
- Test your script the way the validator does — write a payload to a file
  and redirect it in (don't pipe strings into `sh`):
  ```bash
  cat > /tmp/payload.json << 'EOF'
  {"hook_event_name":"PostToolUse","tool_name":"Write","tool_input":{"file_path":"draft.md"}}
  EOF
  ./wordsmith/scripts/count-prose.sh < /tmp/payload.json; echo "exit: $?"
  cat prose-log.txt
  ```
- Compare with the real thing: the cclab plugin's own manifest and
  `hooks/hooks.json` follow this exact structure — you're rebuilding the
  pattern that delivered this very exercise

## When You're Done

Run `/cclab:check` to validate your work.
