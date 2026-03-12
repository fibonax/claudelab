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

### Step 1: Display introduction panel and greeting

**IMPORTANT: Output the greeting and panel as a SINGLE text message BEFORE making any tool calls.** This ensures the user sees everything immediately.

First, pick a fun, short greeting message. Choose one from this pool or generate a similar one in the same warm, encouraging tone — vary it each time so it feels fresh:

- "Hello cclab! It's great to be learning."
- "Welcome back! Let's sharpen those Claude Code skills."
- "Hey there! Ready to level up?"
- "Good to see you! Let's dive into some hands-on learning."
- "cclab time! Let's make some magic happen."
- "Let's learn something new today — you've got this!"
- "Welcome to cclab! Your next challenge awaits."
- "Hey! Grab your keyboard — it's learning time."
- "Another day, another skill to master. Let's go!"
- "You're back! Time to unlock some Claude Code superpowers."

Keep it to one or two sentences. Output the greeting first, then immediately after, output the cclab introduction panel **inside a fenced code block** (triple backticks). The code block is required — it prevents Markdown from stripping leading spaces and misinterpreting backslashes in the ASCII art.

The banner must appear exactly like this (the triple backticks are part of your output):

````
```
  _____ _____ _               ____
 / ____/ ____| |        /\   |  _ \
| |   | |    | |       /  \  | |_) |
| |   | |    | |      / /\ \ |  _ <      cclab: learn Claude Code by using Claude Code
| |___| |____| |____ / ____ \| |_) |     v0.1.0 · fundamentals · 8 exercises
 \_____\_____|______/_/    \_\____/      thanhtt@fibonax.dev
```
````

**All values in the panel are hardcoded — no tool calls needed to render it.**

### Step 1.5: Check permissions and show setup tip

Check if `~/.claude/settings.json` exists and contains any cclab permission rule (an entry matching `~/.cclab/*` in `permissions.allow`). If cclab permissions are **not** configured, display this tip:

```
Tip: Run /cclab:setup for a smoother learning experience (fewer permission prompts).
```

If permissions are already configured, skip this tip silently.

### Step 2: Initialize cclab environment

Using the Bash tool, create the runtime directories if they don't exist:

```bash
mkdir -p ~/.cclab/workspace
```

### Step 3: Load or create progress state

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

### Step 4: Check for completion

Discover all exercise IDs from `$PLUGIN_ROOT/exercises/fundamentals/cc-*/metadata.json`.

If `current_exercise` is null or all discovered exercises appear in the `completed` array, display:

```
You've completed the Fundamentals track!
Next up: the Workflows track — custom slash commands, hooks, and permissions.
Stay tuned for future updates!
```

Stop here — do not proceed further.

### Step 5: Validate current exercise exists

If `current_exercise` references an exercise that doesn't exist on disk (no matching directory under `exercises/fundamentals/`), reset to the first available uncompleted exercise and warn: "Exercise <id> was not found. Resuming from <new-id>."

### Step 6: Run exercise setup

Check if `$PLUGIN_ROOT/exercises/fundamentals/<current_exercise>/setup.sh` exists.

If it exists, run it using the Bash tool:

```bash
bash "$PLUGIN_ROOT/exercises/fundamentals/<current_exercise>/setup.sh"
```

The setup script is idempotent — safe to run multiple times. It creates the workspace directory and scaffolds initial files.

If setup.sh does not exist, skip this step silently.

### Step 7: Present the exercise

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

### Step 8: Update timestamp

Update `updated_at` in `~/.cclab/progress.json` to the current ISO timestamp and write it back.
