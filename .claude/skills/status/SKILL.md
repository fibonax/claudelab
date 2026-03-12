---
name: status
description: Show progress dashboard with track overview, completion percentage, and current position. Use when the user says "status", "progress", "how far", "dashboard", or wants to see their learning progress.
---

# Progress Dashboard

Show the learner's progress through the cclab fundamentals track.

## Determine the Plugin Root

The plugin root is 3 levels up from this skill's base directory:
`<base-directory>/../../../` — this is where `exercises/` and `.claude-plugin/` live.
Store this path as `PLUGIN_ROOT` for all subsequent steps.

## Process

### Step 1: Load progress state

Read `~/.cclab/progress.json` using the Read tool.

**If the file does NOT exist (first run):**

Display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 cclab — Progress Dashboard
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

No progress yet. Run /cclab:start to begin the Fundamentals track!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Stop here.

**If the file exists:**

Parse the JSON. If it cannot be parsed, tell the user:
"Progress file is corrupted. Run `/cclab:start` to reset."
Stop here.

### Step 2: Discover all exercises

Use Glob to find all exercise directories: `$PLUGIN_ROOT/exercises/fundamentals/cc-*/metadata.json`

For each exercise, read its `metadata.json` to extract `id` and `title`. Sort by ID numerically (cc-001, cc-002, ...).

If no exercises are found, tell the user:
"No exercises are available yet. Check back later or verify the cclab plugin installation."
Stop here.

### Step 3: Calculate progress

From `progress.json`:
- `completed` array — list of completed exercise IDs
- `current_exercise` — the current exercise ID (or null if all done)

Count:
- `completed_count` = number of entries in `completed`
- `total_count` = total number of discovered exercises
- `percentage` = floor(completed_count / total_count * 100)

### Step 4: Render the dashboard

Build the exercise list. For each exercise (sorted by ID):
- If the exercise ID is in `completed`: prefix with `✓`
- If the exercise ID equals `current_exercise`: prefix with `→` and append `← current`
- Otherwise: prefix with a space (pending)

Display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 cclab — Progress Dashboard
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Fundamentals Track — <completed_count>/<total_count> complete (<percentage>%)

<exercise list>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Run /cclab:start to continue learning.
 Run /cclab:hint if you need help.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Exercise list format example:**

```
✓ cc-001  Hello Claude Code
✓ cc-002  Your First CLAUDE.md
✓ cc-003  Convention Enforcer
→ cc-004  Code Detective          ← current
  cc-005  The Great Refactor
  cc-006  Git Like a Pro
  cc-007  Command Center
  cc-008  Prompt Architect
```

If `current_exercise` is null (all done), replace the footer with:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 All exercises complete! Well done!
 Next up: the Workflows track — custom slash commands, hooks, and permissions.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
