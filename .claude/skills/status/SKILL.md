---
name: status
description: Show progress dashboard with track overview, completion percentage, and current position. Use when the user says "status", "progress", "how far", "dashboard", or wants to see their learning progress.
---

# Progress Dashboard

Show the learner's progress across all cclab tracks.

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

No progress yet. Run /cclab:start to begin!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Stop here.

**If the file exists:**

Parse the JSON. If it cannot be parsed, tell the user:
"Progress file is corrupted. Run `/cclab:start` to reset."
Stop here.

### Step 2: Discover all exercises

Use Glob to find all exercise metadata: `$PLUGIN_ROOT/exercises/*/*/metadata.json`

For each matched file, read the `metadata.json` to extract `id`, `title`, `track`, and `order`.

Group exercises by `track`. The track order is:
1. `fundamentals` (first)
2. `workflows` (second)
3. Any other tracks alphabetically

Within each track, sort by the `order` field.

If no exercises are found, tell the user:
"No exercises are available yet. Check back later or verify the cclab plugin installation."
Stop here.

### Step 3: Calculate progress

From `progress.json`:
- `completed` array — list of completed exercise IDs
- `current_exercise` — the current exercise ID (or null if all done)

For each track, count:
- `track_completed` = number of exercises in that track whose ID appears in `completed`
- `track_total` = total exercises in that track
- `track_percentage` = floor(track_completed / track_total * 100)

Overall:
- `total_completed` = total entries in `completed`
- `total_exercises` = total across all tracks
- `overall_percentage` = floor(total_completed / total_exercises * 100)

### Step 4: Render the dashboard

Build the exercise list for each track. For each exercise (sorted by order within track):
- If the exercise ID is in `completed`: prefix with `✓`
- If the exercise ID equals `current_exercise`: prefix with `→` and append `← current`
- Otherwise: prefix with a space (pending)

Display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 cclab — Progress Dashboard
 Overall: <total_completed>/<total_exercises> exercises (<overall_percentage>%)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Fundamentals Track — <track_completed>/<track_total> complete (<track_percentage>%)

<fundamentals exercise list>

## Workflows Track — <track_completed>/<track_total> complete (<track_percentage>%)

<workflows exercise list>

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

**If only one track has exercises** (e.g., workflows track hasn't been created yet), show only that track section.

If `current_exercise` is null (all done), replace the footer with:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 All exercises complete! Well done!
 You've mastered both Fundamentals and Workflows.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
