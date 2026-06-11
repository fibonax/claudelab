# cclab Architecture: Deep Analysis of Alternatives

**Date:** 2026-03-17
**Context:** cclab is currently a pure Claude Code plugin (markdown skills + shell validation). This document evaluates alternative architectures, with particular attention to the validation problem: *how do you verify that a user actually invoked a specific tool or skill?*

---

## Table of Contents

1. [The Core Problem](#the-core-problem)
2. [Option A: Status Quo — Pure Plugin](#option-a-status-quo--pure-plugin)
3. [Option B: Hooks-based Tool Logging](#option-b-hooks-based-tool-logging)
4. [Option C: Wrapper CLI (spawns Claude Code)](#option-c-wrapper-cli-spawns-claude-code)
5. [Option D: Companion CLI (runs alongside)](#option-d-companion-cli-runs-alongside)
6. [Option E: MCP Server](#option-e-mcp-server)
7. [Option F: Hybrid — CLI + Plugin + Hooks](#option-f-hybrid--cli--plugin--hooks)
8. [Comparison Matrix](#comparison-matrix)
9. [Recommendation](#recommendation)

---

## The Core Problem

Today, cclab validates exercises by checking **side effects** — file existence, content patterns, git state. This works for most exercises but breaks down when the exercise goal is the *process*, not the *artifact*:

- "Use the Grep tool to find the API key" — the artifact (finding the key) could be done by reading the file manually.
- "Use /commit to make a conventional commit" — you could validate the commit exists, but not that `/commit` was used vs manual `git commit`.
- "Use the Edit tool (not Write) to fix the bug" — both produce the same file, but the learning goal is about Edit specifically.

**The question: can we observe what tools/skills Claude Code actually used during a session?**

---

## Option A: Status Quo — Pure Plugin

### How it works today

```
User runs Claude Code → invokes /cclab:start → solves exercise → /cclab:check
                          (SKILL.md)                               (validate.sh)
```

Everything is markdown (SKILL.md) and shell scripts (setup.sh, validate.sh). No external CLI, no server, no compilation step. Skills are recipes that Claude follows; validation checks file-system artifacts.

### What it can validate

| Can validate                     | Cannot validate                          |
|----------------------------------|------------------------------------------|
| File exists / content matches    | Which tool created the file              |
| Git commits / branch state       | Which skill was invoked                  |
| JSON validity / schema checks    | Whether user typed a prompt or used a UI |
| Line count / pattern presence    | Tool call sequence or count              |
| Command output (via setup traps) | Time spent, cost, conversation flow      |

### Pros

- **Zero dependencies.** No binary to install, no server to run. Just `claude` + the plugin.
- **Portable.** Works on any OS where Claude Code runs.
- **Easy to author.** Exercise creators write markdown and shell scripts — skills they already have.
- **Debuggable.** Run `bash validate.sh` directly to test validation. Read SKILL.md to understand flow.
- **Low maintenance.** No build step, no versions to track, no compilation matrix.
- **Idiomatic.** Uses Claude Code the way it was designed to be used. Plugin authors are the target audience.

### Cons

- **Cannot observe tool usage.** Validation is limited to side effects.
- **No guardrails during exercise.** Can't prevent the user from wandering off-task.
- **UX is prompt-driven.** User must remember `/cclab:check`, `/cclab:hint`, etc.
- **No telemetry.** No way to know which exercises are hard, where learners get stuck, or how long things take.
- **Skill recipes are fragile.** Claude may interpret SKILL.md instructions differently across models or context states.

### Verdict

Good enough for 80% of exercises. The limitation is real but narrow — most exercises can be designed around artifact validation. The question is whether the remaining 20% (tool-usage exercises) justify a more complex architecture.

---

## Option B: Hooks-based Tool Logging

### How it works

Claude Code's hook system (`PreToolUse`, `PostToolUse`) can intercept every tool call. A hook writes each invocation to a log file. Validation scripts read this log.

```
Claude Code session
  ├─ User invokes Grep tool
  │   └─ PostToolUse hook fires → appends to ~/.cclab/workspace/cc-NNN/.tool_log.jsonl
  ├─ User invokes Edit tool
  │   └─ PostToolUse hook fires → appends to ~/.cclab/workspace/cc-NNN/.tool_log.jsonl
  └─ User runs /cclab:check
      └─ validate.sh reads .tool_log.jsonl → checks for expected tool calls
```

### Implementation

**1. Add a logging hook to `.claude/settings.json`:**

The hook needs to capture tool name and relevant input, then append to the current exercise's workspace. Hook commands receive tool information via environment variables.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "type": "command",
        "command": "bash -c 'PROGRESS=\"$HOME/.cclab/progress.json\"; if [ -f \"$PROGRESS\" ]; then EX=$(python3 -c \"import json; print(json.load(open(\\\"$PROGRESS\\\"))[\\\"current_exercise\\\"])\"); LOGDIR=\"$HOME/.cclab/workspace/$EX\"; if [ -d \"$LOGDIR\" ]; then echo \"{\\\"tool\\\":\\\"$CLAUDE_TOOL_NAME\\\",\\\"ts\\\":\\\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\\\"}\" >> \"$LOGDIR/.tool_log.jsonl\"; fi; fi'"
      }
    ]
  }
}
```

(In practice, this would be a small shell script rather than an inline command.)

**2. Exercise validation can now check tool usage:**

```bash
# validate.sh for "Use the Grep tool" exercise
TOOL_LOG="$WORKSPACE/.tool_log.jsonl"

# Check that Grep was actually used
if [ -f "$TOOL_LOG" ] && grep -q '"tool":"Grep"' "$TOOL_LOG"; then
  echo "PASS: Grep tool was used"
else
  echo "FAIL: You need to use the Grep tool to search for the pattern"
  exit 1
fi

# Also check the artifact
grep -q "API_KEY=sk-" "$WORKSPACE/answer.txt" || { echo "FAIL: wrong answer"; exit 1; }
```

### What it can validate (new capabilities)

| Now possible                       | Still not possible                      |
|------------------------------------|-----------------------------------------|
| Which tools were called            | Tool call *input parameters* (partial)  |
| How many times each tool was used  | Full conversation flow                  |
| Order of tool invocations          | What the user *typed* as prompts        |
| Whether a skill was invoked        | Cost / token usage per exercise         |
| Timestamp of each tool call        | Whether user read Claude's output       |

### Pros

- **Solves the tool-validation problem** within the current architecture.
- **No new binary.** Still a pure plugin — just adds a hook.
- **Minimal complexity increase.** One hook + one log file.
- **Composable.** Exercises that don't need tool validation simply ignore the log.
- **Opt-in per exercise.** Only exercises that check `.tool_log.jsonl` depend on it.

### Cons

- **Hook reliability.** If the user modifies their settings or the hook fails silently, the log is incomplete.
- **Hook environment variables.** What's available in `PostToolUse` env is limited — tool name is clear, but input parameters may not be fully exposed (depends on Claude Code version).
- **Overhead.** Every tool call writes to disk. Negligible in practice but non-zero.
- **Privacy concern.** Logging all tool calls could feel intrusive. Needs clear opt-in messaging.
- **Setup dependency.** `/cclab:setup` must install the hook. If the user skips setup or has conflicting hooks, validation breaks.
- **Fragile parsing.** Log format is a JSON line — validation scripts must parse it correctly.

### Verdict

**This is the highest-leverage option.** It solves the specific problem (tool validation) with minimal architectural change. The main risk is hook reliability, which can be mitigated by clear setup and a fallback to artifact-only validation.

---

## Option C: Wrapper CLI (spawns Claude Code)

### How it works

A standalone CLI application (Rust, Go, or Node) that **owns the session lifecycle**. The user runs `cclab` instead of `claude`. The CLI spawns `claude` as a subprocess, monitors its output, and handles validation externally.

This is essentially the `cclab-validator` pattern but for learners, not just testing.

```
User runs: cclab start cc-001
  │
  ├─ CLI sets up workspace (~/.cclab/workspace/cc-001/)
  ├─ CLI displays exercise instructions (rich terminal output)
  ├─ CLI spawns: claude --plugin-dir <cclab> --output-format stream-json
  │     └─ User interacts with Claude Code normally
  │     └─ CLI parses stream-json events in real-time
  │         ├─ Detects tool_use events (name, input)
  │         ├─ Detects skill invocations
  │         ├─ Tracks cost and token usage
  │         └─ Can display live progress sidebar
  ├─ When Claude session ends:
  │     └─ CLI runs validate.sh + checks tool log
  └─ CLI displays results, updates progress
```

### Implementation sketch

```
cclab/
├── cli/                          # New: Wrapper CLI
│   ├── Cargo.toml                # (or package.json, go.mod)
│   ├── src/
│   │   ├── main.rs
│   │   ├── session.rs            # Spawn claude, parse stream-json
│   │   ├── exercise.rs           # Load metadata, instructions
│   │   ├── validator.rs          # Run validate.sh + tool-log checks
│   │   ├── progress.rs           # Read/write progress.json
│   │   └── ui.rs                 # Terminal UI (colors, panels, progress bar)
│   └── ...
├── exercises/                    # Same as today
└── .claude/                      # Plugin skills (still used by Claude inside the session)
```

**Key commands:**

```bash
cclab start                     # Start next exercise (or resume current)
cclab start cc-003              # Jump to specific exercise
cclab check                     # Validate current exercise
cclab hint                      # Show next hint
cclab status                    # Progress dashboard
cclab reset                     # Reset current exercise
```

### What it can validate

| Can validate                         | How                                      |
|--------------------------------------|------------------------------------------|
| All tool calls with full parameters  | Parse stream-json `tool_use` events      |
| Skill invocations                    | Detect Skill tool calls in stream        |
| Tool call sequence and timing        | Event timestamps in stream               |
| Cost per exercise                    | `result` event contains `total_cost_usd` |
| Whether Claude completed the task    | Parse final output for markers           |
| Everything from Option A             | Still runs validate.sh                   |

### Pros

- **Full observability.** Stream-json gives you every tool call, every text block, every result — with parameters.
- **Rich terminal UX.** Spinners, progress bars, colored output, live status — not constrained by Claude Code's rendering.
- **Enforced guardrails.** Can set `--max-budget-usd`, timeout, permission mode.
- **Simpler user experience.** One command (`cclab start`) vs remembering `/cclab:start`.
- **Telemetry-ready.** Cost, duration, hint usage, tool patterns — all available from the stream.
- **Independent progress management.** CLI owns progress.json, not a skill recipe.
- **Can support non-interactive validation.** Useful for CI/CD testing of exercises.

### Cons

- **Requires binary distribution.** Users must install the CLI (via npm, brew, cargo install, or download).
- **Claude runs in `-p` or piped mode.** Loses interactive conversation feel. User types into the wrapper, not directly into Claude. (Or: wrapper launches interactive claude but can only observe stdout, not intercept.)
- **Significant development effort.** Stream-json parsing, TUI rendering, cross-platform support, error handling.
- **Two systems to maintain.** CLI code + plugin skills. Changes to exercise flow require updating both.
- **Version coupling.** CLI depends on Claude Code's stream-json format, which may change across versions.
- **Latency.** Stream-json adds overhead. CLI must buffer and parse in real-time.
- **Interactive vs. piped tension.** If using `-p` mode, the user loses the interactive Claude experience (follow-up questions, clarification). If using interactive mode, the CLI becomes a thin launcher with limited observability (can't easily parse the interactive TUI output).

### The Interactive Mode Problem

This is the fundamental tension. There are two sub-approaches:

**C1: Non-interactive (`claude -p`)**
- CLI sends a single prompt, Claude solves autonomously.
- Full stream-json parsing, full observability.
- But: no back-and-forth. The learner doesn't *interact* with Claude — they just watch.
- This is what `cclab-validator` does. Great for testing, poor for learning.

**C2: Interactive launcher**
- CLI spawns `claude` in interactive mode (allocates a PTY).
- User interacts normally with Claude.
- CLI can observe stdout but parsing a TUI stream is extremely hard (escape codes, screen updates).
- Practically, the CLI becomes just a launcher/wrapper with pre/post hooks.

**C2 is more realistic for learners but sacrifices most of the observability advantage.** You'd be building a complex Rust binary that mostly just runs `claude` and checks files afterward — not much better than Option B.

### Verdict

**Powerful but heavy.** The observability is real, but the interactive-mode problem undermines the main advantage. For a learning tool where the user needs to *interact* with Claude Code, Option C either kills interactivity (bad for learning) or gives up observability (negating the reason to build it). The `cclab-validator` already covers the non-interactive use case.

---

## Option D: Companion CLI (runs alongside Claude Code)

### How it works

A lightweight CLI that handles **exercise management** separately from Claude Code. The user runs both tools independently: `cclab` for navigation/validation, `claude` for learning.

```
Terminal 1:                         Terminal 2 (or same terminal):
$ cclab start cc-003                $ claude
  → Sets up workspace                → User learns inside Claude Code
  → Prints instructions               → Uses /cclab:start if they want (optional)
  → Says "now open Claude Code"        → Works on exercise

$ cclab check
  → Runs validate.sh
  → Updates progress
  → Shows result

$ cclab hint
  → Shows progressive hint
```

### Implementation

The CLI is simpler than Option C because it doesn't spawn or monitor Claude. It's purely a state manager:

```rust
// Simplified — handles exercise lifecycle only
enum Command {
    Start { exercise: Option<String> },
    Check,
    Hint,
    Status,
    Reset,
}
```

No stream-json parsing. No PTY management. No Claude subprocess handling.

### Pros

- **Simple to build.** Just file I/O, shell script execution, terminal output. Could be ~500 lines of code.
- **Clean separation.** CLI owns state; Claude Code owns the learning experience.
- **No Claude dependency.** CLI works without Claude running. Good for: checking if an exercise passes after manual edits, resetting state, viewing progress offline.
- **Can be distributed easily.** Small binary, no complex dependencies.
- **Better terminal UX than skills.** Rich output, colors, tables for progress dashboard.

### Cons

- **Still can't observe tool usage.** The CLI doesn't see what happens inside Claude Code.
- **Split experience.** User manages two tools. "Where do I type /cclab:check — in Claude or my terminal?"
- **Redundant with skills.** The plugin already has /cclab:start, /cclab:check, etc. Now there are two ways to do everything.
- **Doesn't solve the core problem.** Tool validation is still impossible without hooks.
- **Onboarding friction.** "Install this CLI, then also install this Claude Code plugin" is worse than "install this plugin."

### Verdict

**Nice but doesn't solve the problem.** If the goal is better UX for non-Claude operations (progress dashboard, quick reset), this has merit. But it doesn't help with tool validation and adds cognitive overhead (two tools). Consider only if you need an offline/standalone exercise runner.

---

## Option E: MCP Server

### How it works

An MCP (Model Context Protocol) server provides structured tools that Claude Code can call. Instead of skills reading/writing files directly, Claude calls MCP tools with structured input/output.

```
Claude Code ←→ MCP Server (cclab-server)
                 ├─ exercise.start(id) → { instructions, workspace_path }
                 ├─ exercise.check(id) → { passed, feedback }
                 ├─ exercise.hint(id)  → { hint_text, level }
                 ├─ exercise.submit(id, answer) → { correct, feedback }
                 └─ progress.get()     → { completed, current, stats }
```

### Implementation

```typescript
// MCP server (Node.js or Python)
const server = new McpServer({ name: "cclab" });

server.tool("exercise_start", { id: z.string() }, async ({ id }) => {
  // Run setup.sh, read instructions.md, update progress
  return { instructions: "...", workspace: "..." };
});

server.tool("exercise_check", { id: z.string() }, async ({ id }) => {
  // Run validate.sh, parse output
  return { passed: true, feedback: "All checks passed" };
});

server.tool("exercise_submit", {
  id: z.string(),
  answer: z.string()
}, async ({ id, answer }) => {
  // Validate the answer programmatically
  // This is the key: the MCP call itself IS the validation
  return { correct: answer === "expected", feedback: "..." };
});
```

### The Submit Pattern — A New Validation Approach

Here's where MCP gets interesting. Instead of validating side effects, the exercise can require the user to **call an MCP tool as the deliverable**:

> "Use the Grep tool to find the secret key in the codebase, then call `exercise_submit` with the key."

The MCP server validates the answer directly. The exercise doesn't need to check files — the submission *is* the validation.

This also enables a new class of exercises:

- **"Call exercise_submit with the output of ..."** — validates understanding, not just file creation.
- **"Call exercise_submit after you've configured X"** — server checks system state on demand.
- **Knowledge-check exercises** — no file artifacts at all, just Q&A through MCP tools.

### Pros

- **Structured validation.** MCP tools have typed inputs — no more parsing shell output.
- **Submit-based exercises.** New exercise pattern where the tool call IS the answer.
- **Server-side logic.** Validation can be arbitrarily complex (run tests, check APIs, query databases) without shell script limitations.
- **Stateful server.** Can track tool calls within the session if the server maintains state.
- **Standard protocol.** MCP is an emerging standard. Other AI tools could use the same server.
- **Composable.** Multiple MCP servers can coexist. cclab server + other educational servers.

### Cons

- **Cannot observe other tool calls.** MCP server only sees calls *to itself*. It can't see if the user used Grep, Edit, or Write — only its own tools.
- **Server lifecycle management.** User must start the MCP server (or configure Claude Code to auto-start it). Added friction.
- **Configuration complexity.** User must add MCP server config to their Claude Code settings. More setup than a plugin.
- **Exercises become MCP-dependent.** If the server crashes or isn't running, exercises don't work.
- **Different authoring model.** Exercise creators now write TypeScript/Python server code, not just markdown + shell.
- **Not a plugin anymore.** Shifts from Claude Code's plugin system to MCP's tool system. Different distribution model.
- **Overhead for simple exercises.** "Create a file called hello.md" doesn't need an MCP server.

### Pros compared to hooks

The submit pattern gives you something hooks can't: **validated answers without file artifacts.** A hook can tell you "the user called Grep", but an MCP submit tool can tell you "the user found the right answer using whatever method."

### Verdict

**Interesting for a specific class of exercises** (knowledge checks, submit-based validation) but **overkill for the common case** (create/edit files). Best used as a complement to the current system, not a replacement. The submit pattern is genuinely novel and worth exploring.

---

## Option F: Hybrid — Plugin + Hooks + Optional CLI

### How it works

Combine the strengths of Options A, B, and D:

1. **Core: Pure plugin** (current architecture) — handles 80% of exercises via artifact validation.
2. **Enhancement: Hooks** — adds tool-call logging for the 20% of exercises that need it.
3. **Optional: Companion CLI** — for users who prefer terminal commands over `/cclab:` skills.

```
┌─────────────────────────────────────────────────┐
│                  Claude Code                     │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │ /cclab:  │  │  Hooks   │  │  Exercise    │  │
│  │ skills   │  │ (logging)│  │  workspace   │  │
│  └────┬─────┘  └────┬─────┘  └──────┬───────┘  │
│       │              │               │           │
│       └──────────────┼───────────────┘           │
│                      ▼                           │
│              ~/.cclab/workspace/cc-NNN/           │
│              ├── .tool_log.jsonl  (from hooks)   │
│              ├── answer.txt       (from user)    │
│              └── ...              (artifacts)    │
│                                                  │
└─────────────────────────────────────────────────┘
                       │
                       ▼  (optional)
              ┌────────────────┐
              │  cclab CLI     │
              │  (companion)   │
              │  cclab check   │
              │  cclab status  │
              └────────────────┘
```

### The three validation tiers

| Tier | Method | Example exercise | Complexity |
|------|--------|------------------|------------|
| 1 | Artifact-only | "Create hello.md with 3 lines" | validate.sh checks file |
| 2 | Artifact + tool log | "Use Edit (not Write) to fix the bug" | validate.sh checks file + .tool_log.jsonl |
| 3 | Submit-based (future) | "What flag enables strict mode?" | MCP submit tool (if added later) |

### Implementation plan

**Phase 1 (now): Add hook-based tool logging**
- Create a small shell script: `tools/log-tool.sh`
- Add PostToolUse hook to `.claude/settings.json`
- Update `/cclab:setup` to install the hook in user settings
- Create one exercise that validates tool usage as proof-of-concept

**Phase 2 (later, if needed): Companion CLI**
- Build minimal CLI for `cclab check`, `cclab status`, `cclab reset`
- Keep skills as the primary interface; CLI is optional shortcut
- Distribute via `npm install -g @cclab/cli` or similar

**Phase 3 (future, if needed): MCP submit pattern**
- Build a small MCP server with `exercise_submit` tool
- Use only for knowledge-check exercises that don't have file artifacts
- Keep shell validation for everything else

### Pros

- **Incremental.** Each phase adds capability without breaking what exists.
- **Right-sized.** Don't build what you don't need yet. Hooks solve the immediate problem.
- **Backwards-compatible.** Old exercises work unchanged. New exercises can opt into tool logging.
- **Low risk.** Phase 1 is a few hours of work. Phase 2 and 3 are optional.
- **Best of each world.** Plugin simplicity + hook observability + CLI convenience (optional).

### Cons

- **Complexity creeps.** Three systems to understand (plugin + hooks + optional CLI).
- **Hook setup is required.** If a user skips `/cclab:setup`, tool-logging exercises won't validate. Need clear error messages.
- **Testing surface grows.** Must test: with hooks, without hooks, with CLI, without CLI.

### Verdict

**This is the pragmatic path.** Start with hooks (Option B) to solve the immediate tool-validation problem. Add the CLI later only if users need it. Keep the plugin as the primary interface.

---

## Comparison Matrix

| Criteria                     | A: Pure Plugin | B: Hooks | C: Wrapper CLI | D: Companion CLI | E: MCP Server | F: Hybrid |
|------------------------------|:-:|:-:|:-:|:-:|:-:|:-:|
| **Validates artifacts**      | Y | Y | Y | Y | Y | Y |
| **Validates tool usage**     | N | Y | Y (piped only) | N | Own tools only | Y |
| **Interactive experience**   | Y | Y | Degraded | Y | Y | Y |
| **Install complexity**       | Low | Low | High | Medium | Medium | Low→Medium |
| **Authoring complexity**     | Low | Low | High | Low | Medium | Low |
| **Maintenance burden**       | Low | Low | High | Medium | Medium | Low→Medium |
| **New binary required**      | N | N | Y | Y | Y (server) | Optional |
| **Works offline**            | Y | Y | Y | Y | N (needs server) | Y |
| **Telemetry / cost tracking**| N | Partial | Y | N | Partial | Partial |
| **Incremental adoption**     | N/A | Y | N | Y | Y | Y |
| **Solves the question**      | N | **Y** | **Y** | N | Partial | **Y** |

---

## Recommendation

**Start with Option B (hooks-based tool logging). Evolve toward Option F if needed.**

### Why

1. **It solves the immediate problem.** You asked "how do I validate that a user used a specific tool?" Hooks answer this directly.
2. **Minimal disruption.** No new binary, no new server, no architecture change. Just a hook + a log file.
3. **The wrapper CLI (Option C) has a fundamental flaw for learning.** Non-interactive mode kills the learning experience. Interactive mode negates the observability advantage. The `cclab-validator` already covers automated testing.
4. **MCP is interesting but premature.** The submit pattern is novel, but only matters for exercises without file artifacts — a small minority today.
5. **The companion CLI (Option D) is nice-to-have, not need-to-have.** Plugin skills already provide the commands. A CLI adds convenience but not capability.

### Immediate next step

Build a proof-of-concept:
1. Write `tools/log-tool.sh` — a hook script that appends tool calls to `.tool_log.jsonl`
2. Add the PostToolUse hook to the setup skill
3. Create one exercise (e.g., cc-009 "Master the Edit Tool") that requires using Edit and validates via the tool log
4. Test it end-to-end

If hooks prove insufficient (e.g., Claude Code doesn't expose enough info in hook env vars), then re-evaluate Option C or E.
