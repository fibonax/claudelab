```
  _____ _____ _               ____
 / ____/ ____| |        /\   |  _ \
| |   | |    | |       /  \  | |_) |
| |   | |    | |      / /\ \ |  _ <      cclab: learn Claude Code inside Claude Code
| |___| |____| |____ / ____ \| |_) |     v0.2.0 · 2 tracks · 16 exercises
 \_____\_____|______/_/    \_\____/      thanhtt@fibonax.dev
```

# ClaudeLab (cclab)

An interactive tutorial system that teaches Claude Code — directly inside Claude Code. Learn through progressive, validated exercises with setup, instructions, validation, and hints.

## Inspiration

When I started using Claude Code, I tried to find tutorials online but almost all of them were blogs or instructional videos, even the official course from Anthropic. At that time, I was also learning Rust and [Rustlings](https://github.com/rust-lang/rustlings) is a pretty neat CLI learning tool. It inspired me to create ClaudeLab (cclab).

## How It Works

ClaudeLab is a Claude Code plugin. Each exercise is self-contained with:

- **Metadata** — ID (`cc-NNN` / `wf-NNN`), track, difficulty
- **Setup** — scaffolds a workspace at `~/.cclab/workspace/<exercise-id>/`
- **Instructions** — what to do (markdown)
- **Validation** — programmatic (deterministic) checks for correctness
- **Hints** — progressive: gentle → specific → near-answer

Use these slash commands inside Claude Code:

| Command | Description |
|---|---|
| `/start` | Begin or resume the next exercise |
| `/check` | Validate your current exercise |
| `/hint` | Get a progressive hint (up to 3 levels) |
| `/status` | View your progress dashboard |
| `/reset` | Restart the current exercise from scratch |
| `/setup` | Configure permissions for fewer prompts |

## Exercises

### Fundamentals Track (8 exercises)

| # | Exercise | Difficulty | What You'll Learn |
|---|---|---|---|
| cc-001 | Hello Claude Code | Beginner | Your first prompt — verify setup and get comfortable |
| cc-002 | Your First CLAUDE.md | Beginner | Create a CLAUDE.md briefing document for a project |
| cc-003 | Convention Enforcer | Beginner | Use CLAUDE.md directives to enforce code style automatically |
| cc-004 | Code Detective | Beginner | Explore codebases by reading files and searching patterns |
| cc-005 | The Great Refactor | Intermediate | Coordinated multi-file edits (rename, restructure) |
| cc-006 | Git Like a Pro | Intermediate | Git workflow — branches, staging, conventional commits |
| cc-007 | Command Center | Beginner | Discover and document built-in slash commands |
| cc-008 | Prompt Architect | Intermediate | Structured prompt patterns for better results (capstone) |

### Workflows Track (8 exercises)

| # | Exercise | Difficulty | What You'll Learn |
|---|---|---|---|
| wf-001 | Hook Line | Beginner | Configure hooks that automate tasks on file edits |
| wf-002 | Guard Rails | Beginner | Set up permissions to allow/deny tools and protect secrets |
| wf-003 | Command Crafter | Beginner | Create a custom slash command with a SKILL.md file |
| wf-004 | Skill Surgeon | Intermediate | Skills with arguments, hints, and manual-only invocation |
| wf-005 | Agent Assembler | Intermediate | Create a specialized subagent with restricted tools |
| wf-006 | Plan & Conquer | Intermediate | Combine a planning skill + implementation subagents (capstone) |
| wf-007 | Plug It In | Intermediate | Configure an MCP server to extend Claude Code with tools |
| wf-008 | Branch Out | Intermediate | Use git worktrees for parallel isolated work |

More tracks planned: **Advanced**.

> **Known issue:** After installing, you may see additional developer-only skills
> (e.g., `/create-exercise`, `/prd-create`, `/task-planning`). These are internal tools for
> exercise authors — learners can safely ignore them. Only use the 6 skills listed above.

## Getting Started

### Package Install

```bash
# 1. Launch Claude Code
claude

# 2. Add the plugin marketplace
/plugin marketplace add fibonax/claudelab

# 3. Install the plugin
/plugin install cclab@fibonax-claudelab

# 4. Start learning
/start
```

### Offline Install

If you prefer to install from a local clone:

```bash
# 1. Clone the repository
git clone https://github.com/fibonax/claudelab.git

# 2. Launch Claude Code from the cloned directory
cd claudelab
claude

# 3. Start learning — the plugin loads automatically from the local project
/start
```

> **Note:** Your exercise files are created in `~/.cclab/workspace/`, not in the
> cloned repository. The plugin source directory stays clean.

## cclab-validator

`cclab-validator` is a Rust CLI tool (in `tools/cclab-validator/`) that tests exercise solvability end-to-end. It spawns Claude Code to solve each exercise as a real learner would — running `/start`, solving the exercise, then running `/check` — and reports pass/fail.

If an exercise fails, its instructions or validation are broken.

### Build

```bash
cd tools/cclab-validator
cargo build --release
```

### Usage

```bash
# Test a single exercise
cclab-validator --exercise cc-001

# Test an entire track
cclab-validator --track fundamentals

# Test all exercises
cclab-validator --all

# Use a specific model (default: sonnet)
cclab-validator --model opus --exercise cc-001

# Show Claude's full output for debugging
cclab-validator --exercise cc-001 --verbose

# Keep going after a failure
cclab-validator --all --continue-on-fail
```

### Options

| Flag | Description |
|---|---|
| `-e, --exercise <id>` | Run a specific exercise (e.g., `cc-001`, `wf-003`) |
| `-t, --track <name>` | Run all exercises in a track (e.g., `fundamentals`) |
| `-a, --all` | Run all exercises |
| `-m, --model <model>` | Model to use (default: `sonnet`) |
| `--max-budget <usd>` | Max budget per exercise in USD (default: `0.50`) |
| `-v, --verbose` | Show Claude's full output stream |
| `-c, --continue-on-fail` | Continue running after a failure |
| `--plugin-dir <path>` | Path to cclab plugin root (auto-detected if not set) |

### How It Works

1. Resets the exercise workspace and `progress.json` to a clean state
2. Spawns `claude -p` with a prompt that instructs Claude to run `/cclab:start`, solve the exercise, and run `/cclab:check`
3. Parses the output for `PASS` or `FAIL` markers
4. Reports results with timing and cost data

This tool is meant for exercise authors to validate that exercises are solvable before shipping them.

## Development

See [CLAUDE.md](./CLAUDE.md) for project conventions and the development pipeline.

## License

AGPL-3.0
