# PRD: cclab MVP1 — Learn Claude Code by Doing

**Version:** 1.0
**Date:** 2026-03-08
**Author:** Thanh
**Status:** DRAFT

---

### 1. Problem Statement

Claude Code is the most powerful agentic coding tool available, but it has a brutal discoverability problem. Developers install it, run a few prompts, get decent results, and assume that's all there is. They never discover CLAUDE.md context files, custom slash commands, skills, hooks, subagents, MCP servers, or the dozens of other features that turn Claude Code from "a chatbot in my terminal" into an autonomous development system. The gap between a novice and an expert is easily a 5-10x productivity difference — and there's no structured path to cross it.

Current learning options are broken. Official docs are reference-style — great for looking things up, terrible for building muscle memory. YouTube tutorials show someone else's screen, not yours. Blog posts go stale within weeks. Courses teach concepts in passive video-and-quiz formats, which is fundamentally wrong for a tool that lives in the terminal. You don't learn a CLI tool by watching slides. You learn it by typing commands, seeing what happens, and building habits.

The developer community solved this exact problem for programming languages — Rustlings (58k+ stars) teaches Rust through exercises you fix in your editor, Exercism does the same across dozens of languages, Githug teaches git through progressive challenges. But nobody has applied this proven "learn by doing with validation" model to AI development tools. That's the gap cclab fills.

### 2. Target Users

| User Persona | Description | Primary Need |
|---|---|---|
| **The Underusing Subscriber** | Mid-to-senior dev (3-10 yrs), has Claude Max/Pro, uses Claude Code a few times a week for basic tasks. Comfortable in the terminal, active on GitHub. | Structured path from "basic prompts" to power user without reading all the docs |
| **The Curious Newcomer** | Developer who just installed Claude Code (or is evaluating it). Wants to see what's possible before committing. | Quick, hands-on introduction that demonstrates real capabilities |
| **The Team Champion** | Senior dev or tech lead who wants their team to adopt Claude Code effectively. | Shareable learning path they can point teammates to |

### 3. Goals & Success Metrics

#### Goals
- G1: Deliver a working "Rustlings for Claude Code" experience — install plugin, type `/cclab:start`, learn by doing
- G2: Cover the Fundamentals track (CLAUDE.md, basic prompting, file context) with 8-10 validated exercises
- G3: Prove the format works — exercises are completable, validation is reliable, hints are helpful
- G4: Ship as an open-source Claude Code plugin installable via one command

#### Success Metrics
| Metric | Target | How to Measure |
|---|---|---|
| Exercise completion rate | >70% of users who start an exercise finish it | Local progress.json analysis (opt-in telemetry or community feedback) |
| Validation accuracy | >95% — pass means correct, fail means actually wrong | Manual QA + exercise-reviewer subagent |
| Time-to-first-exercise | <2 minutes from plugin install to first exercise | Manual testing |

### 4. MVP Scope

#### In Scope (MVP1)

**Delivery skills (learner-facing commands):**
- `/cclab:start` — Begin or resume learning; show current exercise instructions
- `/cclab:check` — Validate current exercise against assertions
- `/cclab:hint` — Show progressive hints (hint 1 gentle → hint 3 near-answer)
- `/cclab:status` — Show progress dashboard (completed/total, current position)
- `/cclab:reset` — Reset current exercise to starting state

**Exercise framework:**
- Exercise folder structure: `exercises/{track}/{nn-slug}/` with metadata.json, instructions.md, setup.sh, validate.sh, hints.md
- Deterministic validation engine (shell-based assertions, exit code 0/1)
- Progressive hint system (3 levels per exercise)
- Local progress tracking via progress.json (no server, no account)

**Content — Fundamentals track (8-10 exercises):**
- cc-001: Hello Claude Code (first prompt, verify setup works)
- cc-002: Creating a CLAUDE.md file (project context)
- cc-003: CLAUDE.md conventions (code style directives)
- cc-004: File reading and context (working with existing code)
- cc-005: Multi-file edits (coordinated changes)
- cc-006: Git integration basics (commits, diffs)
- cc-007: Using slash commands (built-in commands)
- cc-008: Basic prompt patterns (structured prompting)

**Plugin packaging:**
- plugin.json manifest
- README with install instructions (`claude plugin add`)
- MIT license

#### Out of Scope (Future)
- Workflows track (slash commands authoring, hooks, permissions) — MVP2
- Power User track (skills, subagents, MCP servers, worktrees) — MVP3
- Completion badges / SVG certificates
- Web dashboard or leaderboard
- Server-side telemetry or analytics
- LLM-based validation (behavioral tests)
- Exercise marketplace / community submission system
- CI/CD for exercise testing across Claude Code versions

#### Non-Goals
- We will NOT build a web UI — the entire experience stays in the terminal
- We will NOT require user accounts or authentication
- We will NOT collect telemetry without explicit opt-in
- We will NOT support Claude Code versions older than the current stable release

### 5. User Stories

#### Story 1: First-Time Setup
**As a** developer who just found cclab, **I want to** install and start learning in under 2 minutes, **so that** I can quickly see if this is worth my time.
**Acceptance Criteria:**
- [ ] `claude plugin add` installs cclab with no additional setup
- [ ] `/cclab:start` immediately presents the first exercise
- [ ] Exercise instructions are clear without needing external docs

#### Story 2: Complete an Exercise
**As a** learner working on an exercise, **I want to** validate my work with a single command, **so that** I get immediate feedback on whether I did it right.
**Acceptance Criteria:**
- [ ] `/cclab:check` runs validation and clearly reports PASS or FAIL
- [ ] On FAIL, the output explains what's wrong (not just "failed")
- [ ] On PASS, progress is saved and the next exercise is presented

#### Story 3: Get Unstuck
**As a** learner who is stuck on an exercise, **I want to** get progressive hints, **so that** I can make progress without just being given the answer.
**Acceptance Criteria:**
- [ ] `/cclab:hint` shows hint level 1 (gentle nudge) on first call
- [ ] Calling `/cclab:hint` again shows hint level 2 (more specific)
- [ ] Hint level 3 nearly gives the answer but still requires action
- [ ] Hints are specific to the current exercise

#### Story 4: Track My Progress
**As a** learner working through the track, **I want to** see how far I've progressed, **so that** I feel motivated and know what's ahead.
**Acceptance Criteria:**
- [ ] `/cclab:status` shows completed/total exercises
- [ ] Current exercise is highlighted
- [ ] Track structure is visible (exercise titles + completion status)

#### Story 5: Restart an Exercise
**As a** learner who messed up an exercise, **I want to** reset it to the starting state, **so that** I can try again cleanly.
**Acceptance Criteria:**
- [ ] `/cclab:reset` restores the exercise scaffold to its original state
- [ ] Progress for that exercise is cleared
- [ ] The learner is not forced to redo previously completed exercises

#### Story 6: Resume After a Break
**As a** learner returning after closing my terminal, **I want to** resume where I left off, **so that** I don't lose progress or repeat exercises.
**Acceptance Criteria:**
- [ ] `/cclab:start` detects existing progress and resumes at the current exercise
- [ ] progress.json persists between sessions
- [ ] The learner sees their current exercise instructions immediately

#### Story 7: Learn CLAUDE.md Through Practice
**As a** developer who has never created a CLAUDE.md file, **I want to** learn what it does by creating one in a guided exercise, **so that** I understand how project context works in Claude Code.
**Acceptance Criteria:**
- [ ] Exercise provides a project that needs a CLAUDE.md
- [ ] Validation checks that the CLAUDE.md exists and contains required directives
- [ ] After completing, the learner understands what CLAUDE.md does and how Claude Code uses it

### 6. Functional Requirements

#### FR-001: Plugin Installation
**Priority:** P0 (must have)
**Description:** cclab installs as a Claude Code plugin via standard plugin mechanism. No external dependencies beyond Claude Code itself.
**Acceptance Criteria:**
- [ ] Valid plugin.json manifest with correct metadata
- [ ] Plugin installs via `claude plugin add <repo-url>`
- [ ] All 5 delivery skills are available after install

#### FR-002: Exercise Loader
**Priority:** P0 (must have)
**Description:** The `/cclab:start` skill loads exercise content from the exercises directory, reads progress.json, and presents the current exercise instructions to the learner.
**Acceptance Criteria:**
- [ ] Reads exercise metadata.json for ordering and prerequisites
- [ ] Reads instructions.md and displays it to the learner
- [ ] Runs setup.sh if the exercise requires project scaffolding
- [ ] Handles first-run (no progress) and resume (existing progress) cases

#### FR-003: Validation Engine
**Priority:** P0 (must have)
**Description:** The `/cclab:check` skill runs the current exercise's validate.sh script and reports results.
**Acceptance Criteria:**
- [ ] Executes validate.sh in the exercise working directory
- [ ] Reports PASS (exit 0) with congratulations + next exercise preview
- [ ] Reports FAIL (exit non-zero) with the script's stdout as feedback
- [ ] Updates progress.json on PASS

#### FR-004: Progressive Hint System
**Priority:** P0 (must have)
**Description:** The `/cclab:hint` skill shows hints in order of increasing specificity.
**Acceptance Criteria:**
- [ ] Reads hints.md which contains 3 hint levels separated by markers
- [ ] Tracks which hint level the learner has seen (per exercise)
- [ ] Each subsequent call reveals the next level
- [ ] Resets hint counter when exercise is reset

#### FR-005: Progress Tracking
**Priority:** P0 (must have)
**Description:** Local JSON file tracks learner state across sessions.
**Acceptance Criteria:**
- [ ] progress.json stores: completed exercises, current exercise, hint levels seen, timestamps
- [ ] File is created on first `/cclab:start`
- [ ] File persists across terminal sessions
- [ ] No server or network calls required

#### FR-006: Exercise Reset
**Priority:** P1 (should have)
**Description:** The `/cclab:reset` skill restores the current exercise to its initial state.
**Acceptance Criteria:**
- [ ] Re-runs setup.sh to restore scaffold files
- [ ] Clears hint progress for that exercise
- [ ] Does not affect other exercises' progress

#### FR-007: Progress Dashboard
**Priority:** P1 (should have)
**Description:** The `/cclab:status` skill displays a visual progress overview.
**Acceptance Criteria:**
- [ ] Shows track name and description
- [ ] Lists all exercises with completion status (checkmark / current / locked)
- [ ] Shows completion percentage

#### FR-008: Fundamentals Track Content
**Priority:** P0 (must have)
**Description:** 8-10 exercises teaching Claude Code fundamentals, each with instructions, validation, and hints.
**Acceptance Criteria:**
- [ ] Each exercise has: metadata.json, instructions.md, validate.sh, hints.md, setup.sh
- [ ] Exercises progress from simple to complex
- [ ] All validation scripts are deterministic and reliable
- [ ] Each exercise is completable in 5-15 minutes

### 7. Non-Functional Requirements

- **Performance:** All skills respond in <3 seconds. Validation scripts complete in <10 seconds per exercise.
- **Reliability:** Validation scripts produce consistent results — same input always gives same pass/fail. No flaky tests.
- **Portability:** Works on macOS and Linux. No Windows-specific requirements for MVP1.
- **Simplicity:** Zero external dependencies. No npm install, no Docker, no database. Just Claude Code + the plugin.
- **Privacy:** All data stays local. No network calls for progress tracking or telemetry.

### 8. Constraints & Dependencies

- **Constraint:** Claude Code plugin API is relatively new — must design for potential breaking changes by keeping plugin surface area minimal.
- **Constraint:** Exercises run in the user's local environment — cannot assume specific tooling beyond Claude Code, git, and a POSIX shell.
- **Dependency:** Claude Code must be installed and authenticated (valid subscription).
- **Dependency:** The plugin system must support skill-based commands (`/cclab:*` pattern).
- **Constraint:** Validation must be deterministic (shell scripts, file checks, grep/regex) — no LLM-based validation in MVP1.

### 9. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Claude Code plugin API changes break cclab | Medium | High | Keep plugin surface area small; pin to tested Claude Code versions; monitor changelog |
| Exercise validation produces false positives/negatives | Medium | High | Extensive QA via exercise-reviewer subagent; test each exercise manually 3+ times |
| Exercises are too easy or too hard for target audience | Medium | Medium | Beta test with 5-10 developers; adjust difficulty based on completion rates |
| Users expect more tracks immediately | Low | Medium | Clear messaging that Fundamentals is the first track; roadmap visible in README |
| Setup/install friction causes drop-off | Medium | High | Test install flow on clean machines; provide troubleshooting in README |

### 10. Design Decisions (Resolved)

| Question | Decision | Rationale |
|---|---|---|
| Workspace location | Dedicated `~/.cclab/workspace/` | Plugin dir stays read-only; learner work is isolated; easy to reset without corrupting the plugin |
| Claude Code version handling | Pin to current stable; add `min_claude_code_version` in plugin.json; fail fast on old versions | MVP1 validation checks file content/structure, not CLI output — version drift risk is low; revisit in MVP2 |
| Auto-run setup.sh? | Yes — `/cclab:start` auto-runs setup.sh | Zero friction for first exercise; aligns with <2 min time-to-first-exercise target; future exercises can teach manual setup as part of the task |
| plugin.json schema | Requires technical spike — research current Claude Code plugin API and reference existing plugins (e.g., learn-faster-kit) | Keep manifest minimal: name, version, skills list, min version |
| progress.json location | `~/.cclab/progress.json` (user-level) | Survives plugin updates/reinstalls; consistent with Unix convention; co-located with workspace under `~/.cclab/` |

### 11. References & Prior Art

- Rustlings (Rust learning tool, 58.9k GitHub stars): https://github.com/rust-lang/rustlings
- Exercism (multi-language exercises): https://exercism.org
- Githug (git learning game): https://github.com/Gazler/githug
- learn-faster-kit (Claude Code educational plugin): https://github.com/hugolau/learn-faster-kit
- awesome-claude-code (resource directory): https://github.com/hesreallyhim/awesome-claude-code
- Claude Code official docs: https://docs.anthropic.com/en/docs/claude-code
