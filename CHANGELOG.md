# Changelog

## v0.2.0 — 2026-03-15

The first public release of ClaudeLab (cclab), a Claude Code plugin that teaches Claude Code through progressive, validated exercises — directly inside Claude Code.

### Highlights

- **16 hands-on exercises** across 2 learning tracks
- **6 learner-facing skills** for an interactive tutorial experience
- **Programmatic validation** — deterministic pass/fail, no vibes
- **Progressive hint system** — 3 levels per exercise
- **Offline-friendly** — works without network after install
- **cclab-validator** — Rust CLI for end-to-end exercise solvability testing

### Exercises

**Fundamentals Track** (8 exercises)

| ID | Title | Difficulty |
|--------|------------------------|--------------|
| cc-001 | Hello Claude Code | beginner |
| cc-002 | Your First CLAUDE.md | beginner |
| cc-003 | Convention Enforcer | beginner |
| cc-004 | Code Detective | beginner |
| cc-005 | The Great Refactor | intermediate |
| cc-006 | Git Like a Pro | intermediate |
| cc-007 | Command Center | beginner |
| cc-008 | Prompt Architect | intermediate |

**Workflows Track** (8 exercises)

| ID | Title | Difficulty |
|--------|------------------------|--------------|
| wf-001 | Hook Line | beginner |
| wf-002 | Guard Rails | beginner |
| wf-003 | Command Crafter | beginner |
| wf-004 | Skill Surgeon | intermediate |
| wf-005 | Agent Assembler | intermediate |
| wf-006 | Plan & Conquer | intermediate |
| wf-007 | Plug It In | intermediate |
| wf-008 | Branch Out | intermediate |

### Skills

**Learner-facing:** `/start`, `/check`, `/hint`, `/status`, `/reset`, `/setup`

**Dev-only:** `/create-exercise`, `/validate-exercise`, `/prd-create`, `/curriculum-design`, `/task-planning`, `/implement-task`

### cclab-validator

A Rust CLI tool (`tools/cclab-validator/`) that tests exercise solvability end-to-end. It spawns Claude Code to solve each exercise as a real learner would — running `/start`, solving the exercise, then running `/check` — and reports pass/fail. If an exercise fails, its instructions or validation are broken.

**Features:**

- Test a single exercise, an entire track, or all exercises at once
- Configurable model selection (default: sonnet)
- Per-exercise budget cap (default: $0.50)
- Verbose mode for debugging with full Claude output
- `--continue-on-fail` to run all exercises even after a failure
- Auto-detects plugin root directory

### Bug Fixes

- Fix ASCII art banner rendering in `/start` greeting
- Fix introduction panel ordering to show before tool calls
- Harden `cc-003` validation patterns (`module.exports` check)
- Integration testing QA fixes across exercises

### Documentation & Chores

- License changed from MIT to **AGPL-3.0**
- Added CONTRIBUTING.md and CODE_OF_CONDUCT.md
- Added Getting Started guidelines to all exercises
- Added package and offline install guides to README
