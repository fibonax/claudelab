---
name: cclab:check
description: Validate the current exercise and report pass/fail. Updates progress on success. Use when the user says "check", "validate", "verify", "am I done?", "did I pass?", or wants to test their work.
---

# Check Exercise

Validate the current exercise and report pass or fail.

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

### Step 2: Check for completion

If `current_exercise` is null, tell the user:
"All exercises are complete! Run `/cclab:start` to see your graduation message."
Stop here.

### Step 3: Resolve exercise path

Use Glob to find the exercise: `$PLUGIN_ROOT/exercises/*/<current_exercise>/metadata.json`

The exercise may be in any track directory (e.g., `exercises/fundamentals/cc-003/` or `exercises/workflows/wf-001/`).
Store the matched track directory name as `TRACK`. The exercise path is: `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/`

### Step 4: Verify workspace exists

Check if `~/.cclab/workspace/<current_exercise>/` exists.

If it doesn't, tell the user:
"Workspace not set up for <current_exercise>. Run `/cclab:start` first."
Stop here.

### Step 5: Run validation

Check if `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/validate.sh` exists.

If it doesn't exist, tell the user:
"Validation script not found for <current_exercise>. The exercise may be incomplete."
Stop here.

Execute the validation script using the Bash tool:

```bash
cd ~/.cclab/workspace/<current_exercise> && bash "$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/validate.sh"
```

Capture:
- The exit code (0 = PASS, non-zero = FAIL)
- The stdout output (feedback message)

### Step 6: Report results

Read `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/metadata.json` to get the exercise title.

**On PASS (exit code 0):**

1. Update `~/.cclab/progress.json`:
   - Add `current_exercise` to the `completed` array (if not already present)
   - Discover all exercises from `$PLUGIN_ROOT/exercises/*/*/metadata.json` (all tracks), read each metadata.json to get `id`, `track`, and `order`
   - Sort exercises: group by track (fundamentals first, then workflows), within each track sort by `order`
   - Find the next exercise in this ordered list that is NOT in `completed`
   - Set `current_exercise` to that next exercise ID, or `null` if all are done
   - Update `updated_at` to current ISO timestamp
   - Write the updated JSON back to the file

2. Count completed and total exercises for the progress display.

3. Display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 PASS — <title>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

<stdout output from validate.sh, if any>

Well done! Exercise <exercise-id> is complete.
Progress: <completed-count>/<total-count> exercises done.

Run /cclab:start to begin the next exercise.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**On FAIL (non-zero exit code):**

Display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 NOT YET — <title>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

<stdout output from validate.sh>

Keep going! Review the instructions and try again.
Need help? Run /cclab:hint for a nudge.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Do NOT update progress.json on failure (no state change).
