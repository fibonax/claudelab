# ClaudeLab (cclab)

An interactive tutorial system that teaches Claude Code — directly inside Claude Code. Learn through progressive, validated exercises with setup, instructions, validation, and hints.

## Inspiration

When I started using Claude Code, I tried to find tutorials online but almost all of them were blogs or instructional videos, even the official course from Anthropic. At that time, I was also learning Rust and [Rustlings](https://github.com/rust-lang/rustlings) is a pretty neat CLI learning tool. It inspired me to create ClaudeLab (cclab).

## How It Works

ClaudeLab is a Claude Code plugin. Each exercise is self-contained with:

- **Metadata** — ID (`cc-NNN`), track, difficulty
- **Setup** — scaffolds a workspace at `~/.cclab/workspace/cc-NNN/`
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

More tracks planned: **Skills**, **Workflows**, **Advanced**.

## Getting Started

### Package Install

```bash
# 1. Launch Claude Code
claude

# 2. Add the plugin marketplace
/plugin marketplace add 3t-dev/claudelab

# 3. Install the plugin
/plugin install cclab@3t-dev-claudelab

# 4. Start learning
/start
```

### Offline Install

If you prefer to install from a local clone:

```bash
# 1. Clone the repository
git clone https://github.com/3t-dev/claudelab.git

# 2. Launch Claude Code from the cloned directory
cd claudelab
claude

# 3. Start learning — the plugin loads automatically from the local project
/start
```

## Development

See [CLAUDE.md](./CLAUDE.md) for project conventions and the development pipeline.

## License

MIT
