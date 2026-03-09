# ClaudeLab (cclab)

## What is this project?
cclab is a Claude Code plugin that teaches Claude Code itself through progressive,
validated exercises — directly inside Claude Code. Think of it as an interactive
tutorial system where each exercise has setup, instructions, validation, and hints.

## Tech Stack
- Claude Code plugin (skills + subagents + hooks)
- Markdown (SKILL.md files, exercise content, documentation)
- JSON (plugin.json manifest, metadata, settings)
- Shell scripts (hooks, validation commands)

## Project Structure
cclab/
├── CLAUDE.md
├── README.md
├── LICENSE                             # MIT
├── plugin.json                         # Plugin manifest
├── .gitignore
│
├── .claude/
│   ├── settings.json                   # Project permissions & hooks
│   │
│   ├── skills/                         # All skills (11 total)
│   │   │
│   │   │ ## Learner-facing skills (5) — delivered via plugin
│   │   ├── start/                      # /cclab:start — begin or resume
│   │   │   └── SKILL.md
│   │   ├── check/                      # /cclab:check — validate exercise
│   │   │   └── SKILL.md
│   │   ├── hint/                       # /cclab:hint — progressive hints
│   │   │   └── SKILL.md
│   │   ├── status/                     # /cclab:status — progress dashboard
│   │   │   └── SKILL.md
│   │   ├── reset/                      # /cclab:reset — restart exercise
│   │   │   └── SKILL.md
│   │   │
│   │   │ ## Dev-only skills (6) — for building exercises
│   │   ├── create-exercise/
│   │   │   └── SKILL.md
│   │   ├── validate-exercise/
│   │   │   └── SKILL.md
│   │   ├── prd-create/
│   │   │   └── SKILL.md
│   │   ├── curriculum-design/
│   │   │   └── SKILL.md
│   │   ├── task-planning/
│   │   │   └── SKILL.md
│   │   └── implement-task/
│   │       └── SKILL.md
│   │
│   └── agents/
│       └── exercise-reviewer.md        # QA subagent for exercises
│
├── exercises/                          # Pre-built exercise content (read-only)
│   └── fundamentals/                   # Track: 8 exercises (cc-001..cc-008)
│       └── cc-NNN/                     # Each exercise folder contains:
│           ├── metadata.json           #   ID, track, difficulty, prereqs
│           ├── instructions.md         #   What the learner sees
│           ├── setup.sh                #   Scaffolds ~/.cclab/workspace/cc-NNN/
│           ├── validate.sh             #   Deterministic pass/fail checks
│           └── hints.md                #   3 progressive hint levels
│
└── docs/                               # Development documents (not shipped)
    ├── prd/
    │   └── PRD-mvp1.md
    ├── curriculum/
    │   └── CURRICULUM-mvp1.md
    └── tasks/                          # Task definitions

## Runtime Structure (on user's machine)
~/.cclab/                               # Created by /cclab:start on first run
├── progress.json                       # Learner state: completed, current, hints seen
└── workspace/                          # Exercise working directories
    ├── cc-001/                         # Scaffolded by setup.sh
    │   └── hello.md                    # (user creates during exercise)
    ├── cc-002/
    │   ├── src/index.ts                # (scaffold)
    │   ├── package.json                # (scaffold)
    │   ├── tsconfig.json               # (scaffold)
    │   └── CLAUDE.md                   # (user creates during exercise)
    └── ...

## Commands
- `claude` — start Claude Code in the project
- `gh pr create` — create a pull request
- `gh issue list` — list open issues

## Development Rules
- Every exercise MUST have at least one validation test.
- Exercise IDs use the format: `cc-NNN` (e.g., cc-001, cc-002).
- Exercises are grouped into tracks: fundamentals, skills, workflows, advanced.
- Each exercise has: metadata, setup script, instructions (markdown), validation script, hints (progressive).
- When creating a new exercise, use the `/create-exercise` skill.
- When validating exercise logic, use the `/validate-exercise` skill.

## Development Pipeline
Use the phase-gated pipeline for feature development:
1. `/prd-create` → PRD document (review & approve)
2. `/curriculum-design` → Curriculum design document (review & approve)
3. `/task-planning` → Task list + individual task files (review & approve)
4. `/implement-task TASK-NNN` → Exercise content, validation, commit

IMPORTANT: NEVER auto-advance between pipeline phases.
Each phase produces a document. I review it. I approve it. Only then proceed.

## Architecture Decisions
- Exercises are self-contained: each exercise folder has everything needed to run it.
- Validation is programmatic (not LLM-based) where possible — deterministic checks beat vibes.
- The hint system is progressive: hint 1 is gentle, hint 2 is more specific, hint 3 nearly gives the answer.
- Plugin hooks into Claude Code's skill system for exercise delivery.

## PR & Review
- All PRs need at least one review pass.
- Use `gh pr create` via Claude Code for PR creation.
- PR descriptions must include: what changed, why, how to test.