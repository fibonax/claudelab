# PRD: cclab MVP2 — Workflows Track

**Version:** 1.0
**Date:** 2026-03-13
**Author:** Thanh
**Status:** DRAFT

---

### 1. Problem Statement

Developers who complete the cclab Fundamentals track understand how to prompt Claude Code, create CLAUDE.md files, navigate codebases, and use git integration. But they stop there. They never discover the features that turn Claude Code from a smart assistant into a customizable, extensible development platform — hooks that automate repetitive tasks, skills that encode team workflows as reusable commands, subagents that delegate specialized work, MCP servers that connect external tools, and worktrees that enable parallel isolated work.

These features represent the difference between using Claude Code as a better autocomplete and using it as an autonomous development system. The official documentation covers each feature independently, but there's no structured, hands-on path that teaches developers how these pieces fit together. A developer might read about hooks in the docs but never connect that knowledge to practical workflows like auto-linting, pre-commit validation, or CI integration.

The Workflows track fills this gap. Where Fundamentals taught "how to talk to Claude Code," Workflows teaches "how to make Claude Code work for you." It takes the proven learn-by-doing format from MVP1 and applies it to the customization and extension layer — the features that power users rely on daily but most developers never discover.

### 2. Target Users

| User Persona | Description | Primary Need |
|---|---|---|
| **The Fundamentals Graduate** | Developer who completed the cclab Fundamentals track. Understands CLAUDE.md, prompting, git integration. Ready for the next level. | Structured path to power-user features without reading scattered docs |
| **The Advanced Newcomer** | Experienced developer who already knows Claude Code basics (from usage or other resources). Wants to jump directly into customization and extension. | Hands-on exercises for hooks, skills, subagents — not another intro tutorial |
| **The Team Champion** | Tech lead who wants to standardize Claude Code workflows across their team. Needs to teach skills authoring, shared hooks, and permission models. | Exercises they can assign to teammates to build consistent team practices |

### 3. Goals & Success Metrics

#### Goals
- G1: Deliver a Workflows track that teaches hooks, permissions, skills, subagents, MCP servers, and worktrees through validated exercises
- G2: Enable multi-track navigation — learners can move between Fundamentals and Workflows tracks
- G3: Maintain the <2 minute time-to-first-exercise standard from MVP1
- G4: Ensure advanced users can start Workflows without completing Fundamentals (recommended but not required)

#### Success Metrics
| Metric | Target | How to Measure |
|---|---|---|
| Exercise completion rate | >60% of users who start an exercise finish it | Local progress.json analysis |
| Feature adoption | >50% of completers use at least one learned feature in a real project within a week | Community feedback / survey |
| Track completion rate | >40% of users who start the Workflows track finish all exercises | progress.json analysis |
| Validation accuracy | >95% — pass means correct, fail means actually wrong | Manual QA + exercise-reviewer subagent |

### 4. MVP Scope

#### In Scope (MVP2)

**Workflows track content (6 topics):**
- **Hooks** — Pre/post command hooks, hook configuration, automation patterns
- **Permissions & Settings** — settings.json, allowlists, tool permissions, security model
- **Skills / Custom Slash Commands** — Creating SKILL.md files, skill triggers, arguments, structure
- **Subagents** — Agent markdown files, delegating tasks, specialized subagents
- **MCP Servers** — Model Context Protocol, connecting external tools, server configuration
- **Worktrees** — Git worktrees for parallel isolated work

**Infrastructure updates (minimal):**
- Refactor 5 learner-facing skills to support multi-track (replace hardcoded "fundamentals" paths with dynamic track lookup from exercise metadata)
- Add track selection/display to `/cclab:status`
- Update `/cclab:start` to handle track transitions (fundamentals → workflows)
- Update progress.json schema to track per-track completion (backward compatible)

**Exercise framework (unchanged):**
- Same folder structure: `exercises/{track}/{cc-NNN}/` with metadata.json, instructions.md, setup.sh, validate.sh, hints.md
- Same validation engine (shell-based, deterministic)
- Same progressive hint system (3 levels per exercise)
- Same local progress tracking

#### Out of Scope (Future)
- Memory system exercises (`/memory`, persistent context)
- Headless mode / CI integration exercises
- Web dashboard or leaderboard
- Completion badges / certificates
- LLM-based validation
- Exercise marketplace / community submissions
- IDE integration exercises (VS Code, JetBrains)

#### Non-Goals
- We will NOT change the exercise format or validation engine — it works, keep it
- We will NOT require infrastructure beyond what MVP1 requires (Claude Code + git + POSIX shell)
- We will NOT build inter-exercise state dependencies (each exercise is self-contained)
- We will NOT add telemetry or analytics

### 5. User Stories

#### Story 1: Start the Workflows Track
**As a** Fundamentals graduate, **I want to** start the Workflows track after completing Fundamentals, **so that** I can continue learning without reinstalling or reconfiguring anything.
**Acceptance Criteria:**
- [ ] `/cclab:start` detects Fundamentals completion and offers Workflows track
- [ ] Workflows exercises appear in `/cclab:status` as a separate track
- [ ] Progress from Fundamentals is preserved

#### Story 2: Jump Into Workflows Directly
**As an** advanced user, **I want to** start the Workflows track without completing Fundamentals, **so that** I don't waste time on concepts I already know.
**Acceptance Criteria:**
- [ ] `/cclab:start` allows selecting Workflows track even without Fundamentals completion
- [ ] A recommendation message suggests completing Fundamentals first (non-blocking)
- [ ] All Workflows exercises work independently of Fundamentals progress

#### Story 3: Learn Hooks Through Practice
**As a** developer who has never configured hooks, **I want to** create a working hook in a guided exercise, **so that** I understand how to automate tasks in Claude Code.
**Acceptance Criteria:**
- [ ] Exercise scaffolds a project where a hook would be useful
- [ ] Validation checks that the hook configuration exists and is correctly structured
- [ ] After completing, the learner has a working hook they understand

#### Story 4: Create a Custom Skill
**As a** developer, **I want to** learn how to create a custom slash command (skill), **so that** I can encode my team's workflows as reusable commands.
**Acceptance Criteria:**
- [ ] Exercise guides the learner through creating a SKILL.md file
- [ ] Validation checks file structure, trigger configuration, and content
- [ ] The skill is invokable after creation

#### Story 5: Configure Permissions
**As a** developer concerned about security, **I want to** learn how Claude Code's permission model works, **so that** I can set appropriate boundaries for my projects.
**Acceptance Criteria:**
- [ ] Exercise explains the permission model (allow, deny, ask)
- [ ] Learner creates or modifies a settings.json with permission rules
- [ ] Validation confirms correct permission configuration

#### Story 6: Delegate Work to a Subagent
**As a** developer working on complex tasks, **I want to** learn how to create and use subagents, **so that** I can delegate specialized work to focused agents.
**Acceptance Criteria:**
- [ ] Exercise scaffolds a scenario where subagent delegation is appropriate
- [ ] Learner creates an agent markdown file with proper instructions
- [ ] Validation checks agent file structure and content

#### Story 7: Connect an MCP Server
**As a** developer, **I want to** learn how to configure an MCP server, **so that** I can extend Claude Code with external tools.
**Acceptance Criteria:**
- [ ] Exercise walks through MCP server configuration
- [ ] Validation checks that the MCP configuration is correctly structured
- [ ] Learner understands the MCP protocol basics

#### Story 8: Use Worktrees for Parallel Work
**As a** developer juggling multiple tasks, **I want to** learn how to use git worktrees with Claude Code, **so that** I can work on isolated changes in parallel.
**Acceptance Criteria:**
- [ ] Exercise scaffolds a git repo where parallel work is needed
- [ ] Learner creates and uses a worktree
- [ ] Validation checks worktree existence and correct branch setup

#### Story 9: View Multi-Track Progress
**As a** learner, **I want to** see my progress across both tracks, **so that** I can track my overall learning journey.
**Acceptance Criteria:**
- [ ] `/cclab:status` shows both Fundamentals and Workflows tracks
- [ ] Each track shows completion percentage and current position
- [ ] Overall progress is visible at a glance

### 6. Functional Requirements

#### FR-001: Multi-Track Support in Learner Skills
**Priority:** P0 (must have)
**Description:** Refactor the 5 learner-facing skills (`/start`, `/check`, `/hint`, `/reset`, `/status`) to dynamically resolve exercise track from metadata instead of hardcoding "fundamentals".
**Acceptance Criteria:**
- [ ] Skills read the `track` field from exercise `metadata.json` to construct paths
- [ ] Exercise discovery scans all track directories under `exercises/`
- [ ] Existing Fundamentals exercises continue to work without changes
- [ ] No breaking changes to progress.json (backward compatible)

#### FR-002: Track Selection & Transitions
**Priority:** P0 (must have)
**Description:** `/cclab:start` handles track transitions — when a learner completes Fundamentals, it presents the Workflows track. Advanced users can select Workflows directly.
**Acceptance Criteria:**
- [ ] On Fundamentals completion, `/start` offers Workflows as the next track
- [ ] Learners who haven't completed Fundamentals see a recommendation but can proceed
- [ ] Track context is preserved in progress.json

#### FR-003: Workflows Track — Hooks Exercises
**Priority:** P0 (must have)
**Description:** Exercises teaching Claude Code hook configuration, hook events, and automation patterns.
**Acceptance Criteria:**
- [ ] Exercise(s) cover: hook file structure, hook events (PreToolUse, PostToolUse, Notification, etc.), practical automation patterns
- [ ] Validation checks hook configuration files exist and are correctly structured
- [ ] Learner creates at least one working hook

#### FR-004: Workflows Track — Permissions & Settings Exercises
**Priority:** P0 (must have)
**Description:** Exercises teaching the Claude Code permission model and settings.json configuration.
**Acceptance Criteria:**
- [ ] Exercise(s) cover: settings.json structure, allow/deny rules, tool-specific permissions
- [ ] Validation checks settings.json content and structure
- [ ] Learner understands the security model (project vs user settings)

#### FR-005: Workflows Track — Skills / Slash Commands Exercises
**Priority:** P0 (must have)
**Description:** Exercises teaching custom SKILL.md file creation and skill authoring.
**Acceptance Criteria:**
- [ ] Exercise(s) cover: SKILL.md format, skill description/triggers, skill arguments, skill instructions
- [ ] Validation checks SKILL.md file structure and required fields
- [ ] Learner creates a functional custom skill

#### FR-006: Workflows Track — Subagents Exercises
**Priority:** P0 (must have)
**Description:** Exercises teaching subagent creation and task delegation.
**Acceptance Criteria:**
- [ ] Exercise(s) cover: agent markdown file format, agent specialization, delegation patterns
- [ ] Validation checks agent file structure and content
- [ ] Learner creates at least one subagent definition

#### FR-007: Workflows Track — MCP Servers Exercises
**Priority:** P1 (should have)
**Description:** Exercises teaching MCP server configuration and external tool integration.
**Acceptance Criteria:**
- [ ] Exercise(s) cover: MCP protocol basics, server configuration in settings, tool availability
- [ ] Validation checks MCP configuration structure
- [ ] Learner configures at least one MCP server connection

#### FR-008: Workflows Track — Worktrees Exercises
**Priority:** P1 (should have)
**Description:** Exercises teaching git worktree usage with Claude Code for parallel isolated work.
**Acceptance Criteria:**
- [ ] Exercise(s) cover: worktree creation, branch isolation, parallel task execution
- [ ] Validation checks worktree existence and branch setup
- [ ] Learner creates and uses a worktree

#### FR-009: Updated Progress Dashboard
**Priority:** P1 (should have)
**Description:** `/cclab:status` displays multi-track progress with per-track completion stats.
**Acceptance Criteria:**
- [ ] Shows each track with its own completion percentage
- [ ] Current exercise is highlighted within its track
- [ ] Overall progress across all tracks is visible

### 7. Non-Functional Requirements

- **Performance:** All skills respond in <3 seconds. Validation scripts complete in <10 seconds per exercise.
- **Reliability:** Validation scripts produce consistent results. No flaky tests. Hook and permission exercises must not modify the user's actual Claude Code settings — use isolated workspace configurations.
- **Portability:** Works on macOS and Linux. POSIX shell only — no `jq`, `node`, or `python` in validation scripts.
- **Backward Compatibility:** Existing progress.json files from MVP1 must continue to work. No migration required.
- **Safety:** Exercises that involve hooks, permissions, or MCP configuration must operate within the exercise workspace (`~/.cclab/workspace/wf-NNN/`). They must NOT modify the user's real `~/.claude/settings.json`. The sample MCP server runs locally within the exercise workspace.
- **Privacy:** All data stays local. No network calls for progress tracking.

### 8. Constraints & Dependencies

- **Constraint:** Exercises involving hooks, permissions, and MCP servers must be sandboxed — learners create config files but validation checks structure/content, not runtime behavior.
- **Constraint:** MCP exercises bundle a sample local MCP server (minimal, no external dependencies). Learners connect to it during the exercise.
- **Constraint:** Worktree exercises require git to be installed and a valid git repository (setup.sh initializes this).
- **Constraint:** Minimal infrastructure changes — refactor hardcoded paths in 5 skills, keep everything else the same.
- **Dependency:** Claude Code must be installed and authenticated (same as MVP1).
- **Dependency:** MVP1 Fundamentals track must be complete and stable (it is).
- **Dependency:** Claude Code plugin API must continue to support the current skill/agent patterns.

### 9. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Hook/permission exercises accidentally modify user's real settings | Medium | High | All exercises work in isolated `~/.cclab/workspace/` directories. Validation checks file content, not runtime behavior. Clear instructions warn against modifying real settings. |
| Sample MCP server adds complexity or breaks on some systems | Medium | Medium | Keep the sample server minimal (single-file, POSIX shell or Node.js with no deps). Test on macOS and Linux. Provide fallback validation that checks config structure if server can't start. |
| Multi-track refactoring breaks existing Fundamentals flow | Low | High | Refactoring is minimal (path resolution only). Comprehensive testing of all 8 Fundamentals exercises after changes. |
| Worktree exercises fail on systems without git worktree support | Low | Low | Require git 2.5+ (released 2015). Check in setup.sh and fail with clear message. |
| Exercise count is too large, learners don't finish the track | Medium | Medium | Let curriculum design determine optimal count. Target ~90-120 minutes total (similar to Fundamentals). |
| Claude Code plugin API changes between MVP1 and MVP2 | Medium | High | Keep plugin surface area minimal. Monitor Claude Code changelog. Pin to tested versions. |

### 10. Design Decisions (Resolved)

| Question | Decision | Rationale |
|---|---|---|
| Exercise ID scheme | Track-specific prefix: `wf-001`, `wf-002`, ... | Clearer track membership at a glance; avoids confusion with `cc-NNN` Fundamentals IDs; each track owns its own ID namespace |
| MCP exercise depth | Provide a sample local MCP server that learners connect to | Config-only exercises feel artificial; a real server makes the learning tangible and practical |
| Multi-track refactoring delivery | Bundled with content in a single MVP2 release | Avoids shipping infrastructure without content; reduces coordination overhead; one review cycle |
| Topic ordering within Workflows track | hooks → permissions → skills → subagents → MCP → worktrees | Progresses from simple config (hooks) to authoring (skills) to delegation (subagents) to external integration (MCP) to advanced workflow (worktrees) |

### 11. References & Prior Art

- cclab MVP1 PRD: `docs/prd/PRD-mvp1.md`
- cclab MVP1 Curriculum: `docs/curriculum/CURRICULUM-mvp1.md`
- Claude Code official documentation: https://docs.anthropic.com/en/docs/claude-code
- Claude Code hooks documentation: https://docs.anthropic.com/en/docs/claude-code/hooks
- Claude Code MCP documentation: https://docs.anthropic.com/en/docs/claude-code/mcp
- Claude Code custom slash commands: https://docs.anthropic.com/en/docs/claude-code/skills
- Rustlings (prior art for learn-by-doing): https://github.com/rust-lang/rustlings
