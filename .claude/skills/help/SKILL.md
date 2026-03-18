---
name: cclab:help
description: Show a summary of all available cclab skills with commands, descriptions, and quick examples. Use when the user says "help", "commands", "what can I do", "how does cclab work", or wants to see available skills.
---

# cclab Help

Show a summary of all available cclab skills.

## Process

### Step 1: Display the help panel

Output the following **as a single text message** with no tool calls. Use the exact formatting below.

First, output the banner inside a fenced code block:

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

Then output the skill table:

```
Here's a summary of all available cclab skills:

| Skill     | Command        | Description                                       |
|-----------|----------------|---------------------------------------------------|
| start     | /cclab:start   | Begin or resume learning — loads the next exercise |
| check     | /cclab:check   | Validate your work and advance on success          |
| hint      | /cclab:hint    | Get a progressive hint (up to 3 levels)            |
| status    | /cclab:status  | Show progress dashboard across all tracks          |
| reset     | /cclab:reset   | Restart current exercise from scratch              |
| setup     | /cclab:setup   | Configure permissions for fewer prompts            |
| help      | /cclab:help    | This help page                                     |
```

Then output quick examples:

```
Quick examples:
- /cclab:start — pick up where you left off
- /cclab:check — see if your exercise passes validation
- /cclab:hint — stuck? get a nudge (runs 3 times for increasingly specific hints)
- /cclab:status — see how far you've progressed
- /cclab:reset — wipe the current exercise and start it over
```

Then output the key info:

```
Key info: Exercises live in ~/.cclab/workspace/<exercise-id>/. Progress is tracked in ~/.cclab/progress.json. Each exercise has setup, instructions, validation, and hints — all self-contained.

Need details on a specific skill? Just ask or run the command directly.
```

### Step 2: Done

That's it. No tool calls, no file reads. Just output the text above as a single response.
