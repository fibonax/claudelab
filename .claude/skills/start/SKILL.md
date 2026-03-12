---
name: start
description: Begin or resume the cclab learning experience. Loads the current exercise, runs setup, and presents instructions. Use when the user says "start", "begin", "resume", "next exercise", or wants to start learning Claude Code.
---

# Start Exercise

Begin or resume the cclab learning experience.

## Determine the Plugin Root

The plugin root is 3 levels up from this skill's base directory:
`<base-directory>/../../../` — this is where `exercises/` and `.claude-plugin/` live.
Store this path as `PLUGIN_ROOT` for all subsequent steps.

## Process

### Step 1: Initialize cclab environment

Using the Bash tool, create the runtime directories if they don't exist:

```bash
mkdir -p ~/.cclab/workspace
```

### Step 2: Load or create progress state

Read `~/.cclab/progress.json` using the Read tool.

**If the file does NOT exist (first run):**

1. Discover all exercises by listing directories under `$PLUGIN_ROOT/exercises/fundamentals/` that match the `cc-NNN` pattern (use Glob: `exercises/fundamentals/cc-*/metadata.json`)
2. Sort them by ID numerically (cc-001, cc-002, ...)
3. If no exercises are found, tell the user: "No exercises are available yet. Check back later or verify the cclab plugin installation." Stop here.
4. Set the first exercise as `current_exercise`
5. Write `~/.cclab/progress.json` using the Write tool:

```json
{
  "current_exercise": "cc-001",
  "completed": [],
  "hints_seen": {},
  "started_at": "<current ISO timestamp>",
  "updated_at": "<current ISO timestamp>"
}
```

**If the file exists (resuming):**

1. Parse the JSON content
2. If the JSON is corrupted (cannot parse), back it up to `~/.cclab/progress.json.bak`, create a fresh one as above, and warn the user: "Progress file was corrupted. A backup was saved and progress has been reset."
3. Use the `current_exercise` field to determine which exercise to load

### Step 3: Check for completion

Discover all exercise IDs from `$PLUGIN_ROOT/exercises/fundamentals/cc-*/metadata.json`.

If `current_exercise` is null or all discovered exercises appear in the `completed` array, display:

```
You've completed the Fundamentals track!
Next up: the Workflows track — custom slash commands, hooks, and permissions.
Stay tuned for future updates!
```

Stop here — do not proceed further.

### Step 4: Validate current exercise exists

If `current_exercise` references an exercise that doesn't exist on disk (no matching directory under `exercises/fundamentals/`), reset to the first available uncompleted exercise and warn: "Exercise <id> was not found. Resuming from <new-id>."

### Step 5: Run exercise setup

Check if `$PLUGIN_ROOT/exercises/fundamentals/<current_exercise>/setup.sh` exists.

If it exists, run it using the Bash tool:

```bash
bash "$PLUGIN_ROOT/exercises/fundamentals/<current_exercise>/setup.sh"
```

The setup script is idempotent — safe to run multiple times. It creates the workspace directory and scaffolds initial files.

If setup.sh does not exist, skip this step silently.

### Step 6: Present the exercise

1. Read `$PLUGIN_ROOT/exercises/fundamentals/<current_exercise>/metadata.json` — extract `title`, `difficulty`, `estimatedMinutes`
2. Read `$PLUGIN_ROOT/exercises/fundamentals/<current_exercise>/instructions.md`
3. Display to the user in this format:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 cclab — <title>
 Exercise <exercise-id> | <difficulty> | ~<estimatedMinutes> min
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

<instructions.md content>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Workspace: ~/.cclab/workspace/<exercise-id>/
 When you're done: /cclab:check
 Need help: /cclab:hint
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 7: Update timestamp

Update `updated_at` in `~/.cclab/progress.json` to the current ISO timestamp and write it back.
