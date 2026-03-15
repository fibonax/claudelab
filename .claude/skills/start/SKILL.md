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
| |   | |    | |      / /\ \ |  _ <      cclab: learn Claude Code inside Claude Code
| |___| |____| |____ / ____ \| |_) |     v0.2.1 · 2 tracks · 16 exercises
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

### Step 3: Discover all exercises

Use Glob to find all exercise metadata: `$PLUGIN_ROOT/exercises/*/*/metadata.json`

For each matched file, read the `metadata.json` to extract `id`, `title`, `track`, and `order`.

Group exercises by `track`. The track order is:
1. `fundamentals` (first)
2. `workflows` (second)
3. Any other tracks alphabetically

Within each track, sort by the `order` field.

Build a flat ordered list of all exercise IDs following this track order.

If no exercises are found, tell the user: "No exercises are available yet. Check back later or verify the cclab plugin installation." Stop here.

### Step 4: Load or create progress state

Read `~/.cclab/progress.json` using the Read tool.

**If the file does NOT exist (first run):**

1. Set the first exercise from the ordered list as `current_exercise`
2. Write `~/.cclab/progress.json` using the Write tool:

```json
{
  "current_exercise": "<first-exercise-id>",
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

### Step 5: Check for track completion and transitions

Using the ordered exercise list from Step 3 and the `completed` array from progress.json:

**If `current_exercise` is null or ALL exercises across ALL tracks are in `completed`:**

Display:

```
You've completed all cclab tracks — Fundamentals and Workflows!
You've mastered CLAUDE.md, prompting, git, hooks, skills, subagents, MCP, and worktrees.
Go build something amazing with your new Claude Code superpowers!
```

Stop here — do not proceed further.

**If all exercises in the CURRENT track are complete but exercises remain in the NEXT track:**

Determine the current track from `current_exercise`. If all exercises in that track are in `completed`, and there is a next track with uncompleted exercises:

1. Find the first uncompleted exercise in the next track
2. Set `current_exercise` to that exercise
3. Display a track transition message:

```
You've completed the Fundamentals track! Moving on to Workflows — hooks, skills, subagents, MCP, and worktrees.
```

(Adjust the message based on which track was completed and which is next.)

### Step 5.5: Handle direct Workflows start (no Fundamentals completed)

If `current_exercise` is a Workflows exercise (track = "workflows") and the `completed` array does NOT contain all Fundamentals exercises, this is fine — the user chose to start Workflows directly or was advanced to it. No blocking, no warning needed at this point (the recommendation was shown when they first selected the track).

If the user has no progress at all and wants to start with Workflows instead of Fundamentals, they can manually set their `current_exercise` to "wf-001" or the skill can offer track selection (see Step 5 transition logic).

### Step 6: Validate current exercise exists

Use Glob to find: `$PLUGIN_ROOT/exercises/*/<current_exercise>/metadata.json`

If no match is found (exercise doesn't exist on disk), find the first available uncompleted exercise from the ordered list and warn: "Exercise <id> was not found. Resuming from <new-id>."

Store the matched track directory as `TRACK`.

### Step 7: Run exercise setup

Check if `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/setup.sh` exists.

If it exists, run it using the Bash tool:

```bash
bash "$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/setup.sh"
```

The setup script is idempotent — safe to run multiple times. It creates the workspace directory and scaffolds initial files.

If setup.sh does not exist, skip this step silently.

### Step 8: Present the exercise

1. Read `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/metadata.json` — extract `title`, `difficulty`, `estimatedMinutes`, `track`
2. Read `$PLUGIN_ROOT/exercises/<TRACK>/<current_exercise>/instructions.md`
3. Display to the user in this format:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 cclab — <title>
 Exercise <exercise-id> | <track> | <difficulty> | ~<estimatedMinutes> min
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

<instructions.md content>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Workspace: ~/.cclab/workspace/<exercise-id>/
 When you're done: /cclab:check
 Need help: /cclab:hint
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 9: Update timestamp

Update `updated_at` in `~/.cclab/progress.json` to the current ISO timestamp and write it back.
