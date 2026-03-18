---
name: cclab:reset
description: Reset the current exercise by restoring its workspace and clearing hint progress. Use when the user says "reset", "restart", "start over", "redo", or wants to redo the current exercise from scratch.
---

# Reset Exercise

Reset the current exercise to its initial state. Re-runs setup, clears hints, preserves other progress.

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
"All exercises are complete! There's no current exercise to reset. If you'd like to redo an exercise, run `/cclab:start` to see your options."
Stop here.

### Step 3: Resolve exercise path

Use Glob to find the exercise: `$PLUGIN_ROOT/exercises/*/<current_exercise>/metadata.json`

The exercise may be in any track directory (e.g., `exercises/fundamentals/cc-003/` or `exercises/workflows/wf-001/`).
Store the matched track directory name as `TRACK`. The exercise path is: `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/`

### Step 4: Confirm with the user

Read `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/metadata.json` to get the exercise title.

Ask the user for confirmation using the AskUserQuestion tool:

"Are you sure you want to reset **<current_exercise> — <title>**? This will restore the workspace to its initial state and clear your hint progress for this exercise. Other exercises will not be affected. (yes/no)"

If the user does NOT confirm (answers anything other than a clear affirmative like "yes", "y", "sure", "ok", "go ahead"), tell the user:
"Reset cancelled."
Stop here.

### Step 5: Re-run setup

Check if `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/setup.sh` exists.

If it exists, run it using the Bash tool:

```bash
bash "$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/setup.sh"
```

The setup script is idempotent — it recreates the workspace directory and restores scaffold files to their initial state.

If setup.sh does not exist, tell the user:
"No setup script found for <current_exercise>. Workspace was not modified."

### Step 6: Clear hint progress

Update `~/.cclab/progress.json`:
- Set `hints_seen.<current_exercise>` to `0` (or remove the entry)
- Do NOT modify the `completed` array — other exercises' progress is preserved
- Do NOT change `current_exercise` — the user stays on the same exercise
- Update `updated_at` to current ISO timestamp

Write the updated JSON back to the file.

### Step 7: Confirm reset

Display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Reset — <title>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Exercise <current_exercise> has been reset to its initial state.
Hint progress cleared. Your other exercises are unchanged.

 Workspace: ~/.cclab/workspace/<current_exercise>/
 Run /cclab:start to see the instructions again.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
