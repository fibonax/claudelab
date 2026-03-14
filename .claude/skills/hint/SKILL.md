---
name: hint
description: Show a progressive hint for the current exercise. Each call reveals a more specific hint (up to 3 levels). Use when the user says "hint", "help me", "I'm stuck", "give me a clue", or needs guidance on the current exercise.
---

# Get Hint

Show a progressive hint for the current exercise. Each call reveals a more specific hint, up to 3 levels.

## Determine the Plugin Root

The plugin root is 3 levels up from this skill's base directory:
`<base-directory>/../../../` — this is where `exercises/` and `.claude-plugin/` live.
Store this path as `PLUGIN_ROOT` for all subsequent steps.

## Process

### Step 1: Load progress state

Read `~/.cclab/progress.json` using the Read tool.

If the file doesn't exist, tell the user:
"No progress found. Run `/cclab:start` first to begin."
Stop here.

Parse the JSON. If it cannot be parsed, tell the user:
"Progress file is corrupted. Run `/cclab:start` to reset."
Stop here.

### Step 2: Check for current exercise

If `current_exercise` is null, tell the user:
"All exercises are complete! No hints needed."
Stop here.

### Step 3: Resolve exercise path

Use Glob to find the exercise: `$PLUGIN_ROOT/exercises/*/<current_exercise>/metadata.json`

The exercise may be in any track directory (e.g., `exercises/fundamentals/cc-003/` or `exercises/workflows/wf-001/`).
Store the matched track directory name as `TRACK`. The exercise path is: `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/`

### Step 4: Determine hint level

Look up `hints_seen` in progress.json for the current exercise ID:

- If no entry exists for this exercise: next hint level = **1**
- If entry value is 1: next hint level = **2**
- If entry value is 2: next hint level = **3**
- If entry value is 3 (already seen all): show level **3** again (max level)

### Step 5: Read the hint

Read `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/hints.md` using the Read tool.

If the file doesn't exist, tell the user:
"No hints available for this exercise. Review the instructions with `/cclab:start` or ask Claude for help directly."
Stop here.

Parse the file to extract the hint at the determined level. The file uses these section markers:

- `## Hint 1` — Gentle nudge
- `## Hint 2` — More specific guidance
- `## Hint 3` — Near-answer

Extract the content under the matching `## Hint <level>` heading — everything from that heading to the next `## Hint` heading or end of file.

If the expected section is not found, show whatever content is available and note: "Hint format is non-standard. Showing available content."

### Step 6: Update hint tracking

Update `~/.cclab/progress.json`:
- Set `hints_seen.<current_exercise>` to the hint level just shown (1, 2, or 3)
- Update `updated_at` to current ISO timestamp

Write the updated JSON back to the file.

### Step 7: Display the hint

Read `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/metadata.json` to get the exercise title.

Display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Hint <level>/3 — <title>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

<hint content>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

After the hint box, add a contextual footer:

- **Level 1 or 2:** "Still stuck? Run `/cclab:hint` again for a more specific hint."
- **Level 3:** "This is the most specific hint available. If you're still stuck, review the instructions with `/cclab:start`."
