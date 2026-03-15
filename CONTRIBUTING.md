# Contributing to ClaudeLab

Thanks for your interest in contributing to ClaudeLab! This guide will help you get started.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Ways to Contribute](#ways-to-contribute)
- [Development Setup](#development-setup)
- [Exercise Anatomy](#exercise-anatomy)
- [Creating a New Exercise](#creating-a-new-exercise)
- [Development Pipeline](#development-pipeline)
- [Coding Conventions](#coding-conventions)
- [Submitting a Pull Request](#submitting-a-pull-request)
- [Reporting Issues](#reporting-issues)
- [License](#license)

## Code of Conduct

Please read our [Code of Conduct](./CODE_OF_CONDUCT.md) before contributing. It covers both community standards and exercise quality requirements — especially that exercises must be based on official references and must be clear and easy to adapt.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/<your-username>/claudelab.git
   cd claudelab
   ```
3. Add the upstream remote:
   ```bash
   git remote add upstream https://github.com/fibonax/claudelab.git
   ```
4. Install [Claude Code](https://docs.anthropic.com/en/docs/claude-code) if you haven't already — it's both the runtime and the development tool for this project.

## Ways to Contribute

- **New exercises** — The most impactful contribution. See [Creating a New Exercise](#creating-a-new-exercise).
- **Improve existing exercises** — Better instructions, clearer hints, more robust validation.
- **Bug fixes** — Broken validation scripts, incorrect metadata, setup issues.
- **Documentation** — Typos, unclear sections, missing context.
- **Track proposals** — Ideas for new exercise tracks (open an issue first to discuss).

## Development Setup

ClaudeLab is a Claude Code plugin. To develop locally:

```bash
cd claudelab
claude
```

Claude Code auto-detects the plugin from the local project. You can test exercises by running `/start` inside Claude Code.

### Runtime Directory

Exercises scaffold their workspaces under `~/.cclab/workspace/`. This directory is separate from the repository — your working tree stays clean.

## Exercise Anatomy

Each exercise lives in `exercises/<track>/<exercise-id>/` and contains exactly these files:

```
exercises/fundamentals/cc-001/
├── metadata.json      # ID, title, track, difficulty, order, prerequisites
├── instructions.md    # What the learner sees
├── setup.sh           # Scaffolds the workspace at ~/.cclab/workspace/cc-001/
├── validate.sh        # Deterministic pass/fail checks (exit 0 = pass)
└── hints.md           # 3 progressive hint levels
```

### metadata.json

```json
{
  "id": "cc-001",
  "title": "Hello Claude Code",
  "track": "fundamentals",
  "difficulty": "beginner",
  "order": 1,
  "prerequisites": [],
  "estimatedMinutes": 5,
  "concept": "First prompt, verify setup works"
}
```

- **id**: `cc-NNN` for fundamentals, `wf-NNN` for workflows
- **track**: `fundamentals`, `skills`, `workflows`, or `advanced`
- **difficulty**: `beginner` or `intermediate`
- **order**: Position within the track (sequential, no gaps)
- **prerequisites**: Array of exercise IDs that must be completed first

### validate.sh

Validation scripts must be deterministic — no LLM calls. They should:

- Print `FAIL: <reason>` for each failing check
- Print `All checks passed!` on success
- Exit `0` on pass, non-zero on fail
- Use the workspace path `$HOME/.cclab/workspace/<exercise-id>/`

### hints.md

Use three progressive levels separated by `## Hint N` headers:

1. **Hint 1** — Gentle nudge, points the learner in the right direction
2. **Hint 2** — More specific, narrows down the approach
3. **Hint 3** — Nearly gives the answer, just short of a full solution

## Creating a New Exercise

The recommended way to create exercises is with Claude Code's built-in skill:

```
/create-exercise
```

If you prefer to create one manually, follow the [Exercise Anatomy](#exercise-anatomy) structure above and ensure:

- Every exercise has **all five files** (metadata, instructions, setup, validate, hints)
- The validation script has at least one check
- `setup.sh` is idempotent (safe to run multiple times)
- Hints are progressive (not all equally specific)

### Validating Your Exercise

Use the validator skill inside Claude Code:

```
/validate-exercise
```

Or use the `cclab-validator` CLI tool for end-to-end testing:

```bash
cd tools/cclab-validator
cargo build --release
cclab-validator --exercise cc-001 --verbose
```

This spawns Claude Code to solve the exercise as a real learner would — if it fails, your instructions or validation are broken.

## Development Pipeline

For larger features (new tracks, new skills, infrastructure changes), we use a phase-gated pipeline. Each phase produces a document that must be reviewed and approved before moving on:

1. **PRD** — `/prd-create` produces a product requirements document
2. **Curriculum** — `/curriculum-design` produces a curriculum design
3. **Task Planning** — `/task-planning` produces task definitions
4. **Implementation** — `/implement-task TASK-NNN` builds the exercises

Do **not** skip phases or auto-advance. Open a draft PR or issue to discuss if you're unsure about scope.

## Coding Conventions

### General

- **Markdown** for all content files (instructions, hints, skills)
- **JSON** for metadata and configuration (no trailing commas)
- **Bash** for setup and validation scripts (use `#!/usr/bin/env bash`)
- **TypeScript** with strict mode when applicable (ES modules, named exports)
- Use kebab-case for file names

### Shell Scripts

- Always set `WORKSPACE="$HOME/.cclab/workspace/<exercise-id>"` at the top
- Quote variables: `"$WORKSPACE"`, not `$WORKSPACE`
- Use `set -euo pipefail` in setup scripts
- Make scripts executable: `chmod +x setup.sh validate.sh`

### Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(exercises): add cc-009 memory management exercise
fix(validate): handle missing file in cc-003 validation
docs(readme): update exercise table with new track
refactor(skills): simplify hint delivery logic
test(validator): add edge case for empty workspace
chore(ci): update validator build step
```

Format: `type(scope): description`

**Types**: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`
**Scope**: `exercises`, `skills`, `validate`, `readme`, `validator`, etc.

## Submitting a Pull Request

1. Create a feature branch from `main`:
   ```bash
   git checkout -b feature/short-description main
   ```

2. Make your changes, following the conventions above.

3. Test your changes:
   - For exercises: run `/validate-exercise` or `cclab-validator`
   - For skills: test the slash command manually in Claude Code
   - For docs: review the rendered markdown

4. Commit with a conventional commit message.

5. Push and open a PR:
   ```bash
   git push -u origin feature/short-description
   gh pr create
   ```

6. In your PR description, include:
   - **What changed** — summary of the changes
   - **Why** — motivation and context
   - **How to test** — steps for reviewers to verify

7. All PRs require at least one review pass before merging. Squash commits before merge.

## Reporting Issues

Open an issue on GitHub with:

- **Exercise ID** (if applicable, e.g., `cc-003`)
- **What happened** vs. **what you expected**
- **Steps to reproduce**
- **Environment** — OS, Claude Code version

For exercise bugs, include the output of `/check` if possible.

## License

By contributing, you agree that your contributions will be licensed under the [AGPL-3.0 License](./LICENSE.txt), the same license that covers the project.
