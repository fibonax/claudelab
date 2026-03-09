# Curriculum Design: cclab MVP1 — Fundamentals Track

**Version:** 1.0
**Date:** 2026-03-09
**PRD Reference:** docs/prd/PRD-mvp1.md
**Status:** DRAFT

---

### 1. Learning Objectives

After completing the Fundamentals track, users will be able to:

- **Objective 1:** Verify their Claude Code setup works and understand the basic interaction loop (prompt → plan → execute → observe)
- **Objective 2:** Create and maintain CLAUDE.md files that give Claude effective project context and enforce coding conventions
- **Objective 3:** Use Claude to read, understand, and navigate existing codebases using file context, Grep, and Glob
- **Objective 4:** Direct Claude to make coordinated multi-file edits and review diffs before accepting changes
- **Objective 5:** Use Claude's git integration to create branches, stage changes, and write conventional commits
- **Objective 6:** Use built-in slash commands (/help, /init, /compact, /clear, /memory) effectively
- **Objective 7:** Apply structured prompt patterns that consistently produce better results from Claude

### 2. Track Overview

| Track | Focus | Exercise Count | Target Audience |
|---|---|---|---|
| fundamentals | Core Claude Code concepts — CLAUDE.md, file context, edits, git, commands, prompting | 8 | Beginners and underusing subscribers |

MVP1 delivers only the **fundamentals** track. Future tracks are out of scope:
- **workflows** (skills authoring, hooks, permissions) — planned for MVP2
- **advanced** (subagents, MCP servers, worktrees, agent teams) — planned for MVP3

### 3. Exercise Sequence

#### Track: fundamentals

| ID | Title | Concept | Difficulty | Prerequisites | Est. Time |
|---|---|---|---|---|---|
| cc-001 | Hello Claude Code | First prompt, verify setup works | beginner | None | 5 min |
| cc-002 | Your First CLAUDE.md | Creating a CLAUDE.md file (project context) | beginner | cc-001 | 10 min |
| cc-003 | Convention Enforcer | CLAUDE.md code style directives | beginner | cc-002 | 10 min |
| cc-004 | Code Detective | File reading and navigating context | beginner | cc-002 | 10 min |
| cc-005 | The Great Refactor | Multi-file coordinated edits | intermediate | cc-004 | 15 min |
| cc-006 | Git Like a Pro | Git integration — branches and commits | intermediate | cc-004 | 15 min |
| cc-007 | Command Center | Built-in slash commands | beginner | cc-001 | 10 min |
| cc-008 | Prompt Architect | Structured prompt patterns | intermediate | cc-003, cc-004 | 15 min |

**Total estimated time:** ~90 minutes

### 4. Prerequisite Graph

```
cc-001 (Hello Claude Code)
│
├──▶ cc-002 (Your First CLAUDE.md)
│    │
│    ├──▶ cc-003 (Convention Enforcer)
│    │    │
│    │    └──▶ cc-008 (Prompt Architect) ◀── cc-004
│    │
│    └──▶ cc-004 (Code Detective)
│         │
│         ├──▶ cc-005 (The Great Refactor)
│         │
│         └──▶ cc-006 (Git Like a Pro)
│
└──▶ cc-007 (Command Center)
```

**Sequencing rationale:**
- cc-001 is the gateway — confirms the tool works, builds confidence
- cc-002 and cc-007 branch from cc-001 (independent introductions to CLAUDE.md vs. commands)
- cc-003 deepens CLAUDE.md with conventions (builds on cc-002)
- cc-004 teaches file reading (needs CLAUDE.md context from cc-002)
- cc-005 and cc-006 require file navigation skills from cc-004
- cc-008 is the capstone — combines conventions (cc-003) and file context (cc-004) into prompt engineering

### 5. Exercise Definitions

---

#### Exercise: cc-001 — Hello Claude Code

**Concept:** First interaction with Claude Code — verify setup, understand the prompt-execute loop
**Track:** fundamentals
**Difficulty:** beginner
**Prerequisites:** None
**Estimated Time:** 5 minutes

**Learning Goal:** After this exercise, the user will have confirmed their Claude Code installation works and understand that Claude can create files based on natural language instructions.

**Setup:**
- Create an empty workspace directory at `~/.cclab/workspace/cc-001/`
- No files exist yet

**Instructions Summary:**
- Ask Claude to create a file called `hello.md` in the workspace
- The file must contain a greeting message and at least one fact about Claude Code
- Verify the file exists and has content

**Validation Strategy:**
- **File exists:** `hello.md` exists in `~/.cclab/workspace/cc-001/`
- **Content check:** file is not empty (at least 3 lines)
- **Content check:** file contains the word "Claude" (case-insensitive)

**Hints:**
1. (Gentle) Claude can create files for you — just ask it in plain English. Try something like "Create a file called hello.md with..."
2. (Specific) Your hello.md needs to exist in the workspace directory and mention Claude Code. Make sure you're asking Claude to write the file, not just telling you what to write.
3. (Near-answer) Ask Claude: "Create a file called hello.md that contains a greeting and one interesting fact about Claude Code." Then run `/cclab:check` to verify.

---

#### Exercise: cc-002 — Your First CLAUDE.md

**Concept:** Creating a CLAUDE.md file that gives Claude project context
**Track:** fundamentals
**Difficulty:** beginner
**Prerequisites:** cc-001
**Estimated Time:** 10 minutes

**Learning Goal:** After this exercise, the user will understand what CLAUDE.md is, why it matters, and how to create one with essential sections that Claude reads at session start.

**Setup:**
- Create workspace at `~/.cclab/workspace/cc-002/`
- Scaffold a minimal project: `src/index.ts` (simple TypeScript file), `package.json` (basic Node.js project), `tsconfig.json`
- No CLAUDE.md exists yet

**Instructions Summary:**
- Explain that CLAUDE.md is the "briefing document" Claude reads at the start of every session
- Ask the user to create a `CLAUDE.md` file in the project root with at least these sections:
  - Project description (what the project does)
  - Tech stack (what technologies it uses)
  - Commands (how to build, test, run)
- The file should be between 10 and 100 lines

**Validation Strategy:**
- **File exists:** `CLAUDE.md` in `~/.cclab/workspace/cc-002/`
- **Content check:** contains a heading with "Project" or "Description" (case-insensitive)
- **Content check:** contains a heading or section about commands (matches `## Commands` or `## Development` or similar)
- **Content check:** mentions at least one technology (e.g., "TypeScript", "Node", "npm")
- **Line count:** file is between 10 and 100 lines

**Hints:**
1. (Gentle) Think about what a new team member would need to know on their first day working on this project. CLAUDE.md serves the same purpose — but for Claude.
2. (Specific) Your CLAUDE.md needs at least: a project description section, a commands section (how to build/test/run), and it should mention the tech stack. Use `##` markdown headings to structure it.
3. (Near-answer) Create a CLAUDE.md with these sections: `## Project Description` (explain what the project does), `## Tech Stack` (mention TypeScript, Node.js), `## Commands` (list `npm install`, `npm run build`, `npm test`). Make sure it's at least 10 lines.

---

#### Exercise: cc-003 — Convention Enforcer

**Concept:** Using CLAUDE.md to enforce code style directives and project conventions
**Track:** fundamentals
**Difficulty:** beginner
**Prerequisites:** cc-002
**Estimated Time:** 10 minutes

**Learning Goal:** After this exercise, the user will understand how to write CLAUDE.md directives that control Claude's code output — naming conventions, import style, formatting rules — and verify Claude follows them.

**Setup:**
- Create workspace at `~/.cclab/workspace/cc-003/`
- Scaffold a project with:
  - `src/utils.ts` — a file using CommonJS `require()` and `var` declarations (intentionally "wrong" style)
  - `package.json` with `"type": "module"`
  - An empty `CLAUDE.md` that has a project description but NO code style section

**Instructions Summary:**
- The project has code that violates modern conventions (uses `require()` instead of `import`, uses `var` instead of `const`/`let`)
- Add a `## Code Style` section to the existing CLAUDE.md with at least 3 rules:
  1. Use ES modules (`import`/`export`), never CommonJS (`require`)
  2. Use `const` by default, `let` when mutation is needed, never `var`
  3. Use TypeScript strict mode
- After updating CLAUDE.md, ask Claude to fix `src/utils.ts` to follow the new conventions

**Validation Strategy:**
- **Content check:** `CLAUDE.md` contains a section matching `Code Style` or `Conventions` (case-insensitive)
- **Content check:** `CLAUDE.md` mentions `import` or `ES module` (case-insensitive)
- **Content check:** `CLAUDE.md` mentions `const` or `var` (indicating a variable declaration rule)
- **File NOT contains:** `src/utils.ts` does NOT contain `require(`
- **File NOT contains:** `src/utils.ts` does NOT contain `var ` (with trailing space)

**Hints:**
1. (Gentle) CLAUDE.md isn't just documentation — it's an instruction set. If you write "always use ES modules", Claude will follow that when writing or fixing code. Add a Code Style section with your rules.
2. (Specific) Add `## Code Style` to your CLAUDE.md with rules about imports (`import` not `require`) and variable declarations (`const`/`let` not `var`). Then ask Claude to fix `src/utils.ts` to match these conventions.
3. (Near-answer) Add this to CLAUDE.md: `## Code Style\n- Use ES modules (import/export), never CommonJS (require)\n- Use const by default, let when mutation is needed, never var\n- Use TypeScript strict mode`. Then tell Claude: "Fix src/utils.ts to follow the code style rules in CLAUDE.md."

---

#### Exercise: cc-004 — Code Detective

**Concept:** Using Claude to read, navigate, and understand existing codebases
**Track:** fundamentals
**Difficulty:** beginner
**Prerequisites:** cc-002
**Estimated Time:** 10 minutes

**Learning Goal:** After this exercise, the user will know how to ask Claude to explore a codebase — reading files, searching for patterns, and answering questions about code structure — before making any changes.

**Setup:**
- Create workspace at `~/.cclab/workspace/cc-004/`
- Scaffold a small multi-file project (5-8 files):
  - `src/index.ts` — entry point that imports from other modules
  - `src/routes/users.ts` — user route handlers
  - `src/routes/posts.ts` — post route handlers
  - `src/models/user.ts` — user model with a deliberate bug (typo in a field name)
  - `src/models/post.ts` — post model
  - `src/utils/validate.ts` — validation helpers
  - `CLAUDE.md` — basic project description
- One file contains a deliberate bug: `src/models/user.ts` references a field `emial` instead of `email`

**Instructions Summary:**
- You've inherited a codebase. Before changing anything, you need to understand it.
- Ask Claude to explore the project and answer these questions (write answers in a file called `answers.md`):
  1. How many route files are there and what do they handle?
  2. What models does the project define?
  3. Can you find any bugs in the code?
- The `answers.md` file must contain answers to all three questions and identify the `emial` typo

**Validation Strategy:**
- **File exists:** `answers.md` in `~/.cclab/workspace/cc-004/`
- **Content check:** `answers.md` mentions "route" or "routes" (case-insensitive)
- **Content check:** `answers.md` mentions "user" and "post" as models (case-insensitive)
- **Content check:** `answers.md` mentions "emial" or "email" typo or "bug" (case-insensitive)
- **Line count:** `answers.md` is at least 5 lines

**Hints:**
1. (Gentle) Don't jump into fixing code. First, ask Claude to read and explore. Try: "Read through this project and tell me what it does." Claude can use Grep and Glob to search the codebase.
2. (Specific) Ask Claude three things: (1) "What route files exist and what do they handle?" (2) "What models does this project define?" (3) "Are there any bugs in the code?" Save the answers in `answers.md`.
3. (Near-answer) Ask Claude: "Explore this codebase. List all route files, list all models, and look for any bugs or typos. Write your findings to answers.md." Claude should find the `emial` typo in `src/models/user.ts`.

---

#### Exercise: cc-005 — The Great Refactor

**Concept:** Using Claude to make coordinated changes across multiple files
**Track:** fundamentals
**Difficulty:** intermediate
**Prerequisites:** cc-004
**Estimated Time:** 15 minutes

**Learning Goal:** After this exercise, the user will know how to direct Claude to make consistent changes across multiple files — renaming, moving code, updating imports — and verify nothing breaks.

**Setup:**
- Create workspace at `~/.cclab/workspace/cc-005/`
- Scaffold a project with a function `getUserData()` used across 4+ files:
  - `src/services/user-service.ts` — defines and exports `getUserData()`
  - `src/routes/users.ts` — imports and calls `getUserData()`
  - `src/routes/admin.ts` — imports and calls `getUserData()`
  - `src/middleware/auth.ts` — imports and calls `getUserData()`
  - `src/tests/user.test.ts` — imports and tests `getUserData()`
  - `CLAUDE.md` — project description

**Instructions Summary:**
- The function `getUserData()` needs to be renamed to `fetchUserProfile()` across the entire codebase
- Ask Claude to rename the function in all files — the definition, all imports, and all call sites
- All files must consistently use the new name with zero references to the old name

**Validation Strategy:**
- **File NOT contains (all files):** No file in `src/` contains `getUserData` (old name is completely gone)
- **Content check:** `src/services/user-service.ts` contains `fetchUserProfile`
- **Content check:** `src/routes/users.ts` contains `fetchUserProfile`
- **Content check:** `src/routes/admin.ts` contains `fetchUserProfile`
- **Content check:** `src/middleware/auth.ts` contains `fetchUserProfile`
- **Content check:** `src/tests/user.test.ts` contains `fetchUserProfile`
- **Grep match:** `grep -r "getUserData" src/` returns no results (exit code 1)

**Hints:**
1. (Gentle) Claude can rename things across your entire codebase in one go. Just tell it what to rename and what the new name should be. Claude will find all the references.
2. (Specific) Ask Claude to rename `getUserData` to `fetchUserProfile` everywhere — in the function definition, all imports, and all call sites. Say "rename across all files."
3. (Near-answer) Tell Claude: "Rename the function `getUserData` to `fetchUserProfile` in every file in the src/ directory. Update the definition in user-service.ts, and update all imports and call sites in users.ts, admin.ts, auth.ts, and user.test.ts."

---

#### Exercise: cc-006 — Git Like a Pro

**Concept:** Using Claude's git integration for branches, staging, and conventional commits
**Track:** fundamentals
**Difficulty:** intermediate
**Prerequisites:** cc-004
**Estimated Time:** 15 minutes

**Learning Goal:** After this exercise, the user will know how to use Claude to create feature branches, make changes, and create well-formatted conventional commits — all through natural language.

**Setup:**
- Create workspace at `~/.cclab/workspace/cc-006/`
- Initialize a git repo with an initial commit:
  - `src/app.ts` — simple app file
  - `CLAUDE.md` — includes a Git section specifying conventional commits format
  - Initial commit: "chore: initial project setup"
- The repo has a clean working tree on the `main` branch

**Instructions Summary:**
- Step 1: Ask Claude to create a new feature branch called `feature/add-logging`
- Step 2: Ask Claude to add a `src/logger.ts` file with a simple logging utility
- Step 3: Ask Claude to commit the change with a proper conventional commit message (should be `feat(logging): ...`)
- Step 4: Verify the branch, the file, and the commit message are all correct

**Validation Strategy:**
- **Command check:** `git branch --list feature/add-logging` returns output (branch exists)
- **Command check:** `git log --oneline -1` on `feature/add-logging` contains `feat` (conventional commit)
- **File exists:** `src/logger.ts` exists
- **Content check:** `src/logger.ts` is not empty (at least 3 lines)
- **Command check:** `git status` shows clean working tree (everything committed)
- **Command check:** current branch is `feature/add-logging` (via `git branch --show-current`)

**Hints:**
1. (Gentle) Claude understands git natively. You can ask it in plain English: "Create a branch", "Add a file", "Commit with a conventional message." Try it step by step.
2. (Specific) First: "Create a feature branch called feature/add-logging." Then: "Create a logger utility in src/logger.ts." Finally: "Commit this change with a conventional commit message starting with feat(logging):".
3. (Near-answer) Tell Claude: "Switch to a new branch called feature/add-logging, create src/logger.ts with a simple log function, then commit everything with the message 'feat(logging): add logging utility'." Make sure the working tree is clean after the commit.

---

#### Exercise: cc-007 — Command Center

**Concept:** Using Claude Code's built-in slash commands effectively
**Track:** fundamentals
**Difficulty:** beginner
**Prerequisites:** cc-001
**Estimated Time:** 10 minutes

**Learning Goal:** After this exercise, the user will know the most useful built-in slash commands and when to use each one.

**Setup:**
- Create workspace at `~/.cclab/workspace/cc-007/`
- Scaffold a project with:
  - Several source files (to give Claude context to work with)
  - `CLAUDE.md` — basic project description
  - No `.claude/` directory yet

**Instructions Summary:**
- Complete a series of mini-tasks, each using a different slash command:
  1. Use `/init` in the workspace to generate or update the CLAUDE.md (if supported) or manually verify how `/init` works
  2. Use the `/help` command and record 3 commands you didn't know about in `commands.md`
  3. Create a `commands.md` file listing at least 5 built-in slash commands with a one-line description of each

**Validation Strategy:**
- **File exists:** `commands.md` in `~/.cclab/workspace/cc-007/`
- **Content check:** `commands.md` contains at least 5 lines starting with `/` (slash commands)
- **Content check:** `commands.md` mentions `/help` (case-insensitive)
- **Content check:** `commands.md` mentions `/compact` or `/clear` (case-insensitive)
- **Line count:** `commands.md` is at least 8 lines

**Hints:**
1. (Gentle) Claude Code has many built-in commands. Start by typing `/help` to see what's available. Your goal is to document what you find.
2. (Specific) Run `/help` in Claude Code to see the list of commands. Pick at least 5 commands (including `/help` and `/compact` or `/clear`) and write a short description of each in `commands.md`.
3. (Near-answer) Create `commands.md` with entries like: `/help - Shows available commands and usage`, `/compact - Compresses conversation context`, `/clear - Resets the conversation`, etc. List at least 5 commands with descriptions, one per line.

---

#### Exercise: cc-008 — Prompt Architect

**Concept:** Structured prompt patterns that produce consistently better results
**Track:** fundamentals
**Difficulty:** intermediate
**Prerequisites:** cc-003, cc-004
**Estimated Time:** 15 minutes

**Learning Goal:** After this exercise, the user will understand three key prompt patterns — Explore First, Verify Against, and Step-by-Step — and demonstrate each one in practice.

**Setup:**
- Create workspace at `~/.cclab/workspace/cc-008/`
- Scaffold a project with:
  - `src/api/handlers.ts` — API handler with a function that has no input validation
  - `src/api/types.ts` — type definitions
  - `src/tests/` — empty test directory
  - `CLAUDE.md` — project description with code style conventions

**Instructions Summary:**
- Complete three prompt challenges, writing each prompt and its result:
  1. **Explore First:** Before making changes, ask Claude to explore the codebase and summarize the API structure. Save the summary in `exploration.md`.
  2. **Verify Against:** Write a prompt that asks Claude to write tests FIRST, then implement input validation for the API handler. The tests must exist in `src/tests/handlers.test.ts` before or alongside the implementation.
  3. **Step-by-Step:** Write a prompt that breaks a task into numbered steps. Ask Claude to (1) identify what input validation is missing, (2) list the validation rules needed, (3) implement the validation. Save the step-by-step plan in `plan.md`.

**Validation Strategy:**
- **File exists:** `exploration.md` in workspace (explore-first pattern)
- **Content check:** `exploration.md` mentions "API" or "handler" or "endpoint" (case-insensitive)
- **Content check:** `exploration.md` is at least 5 lines
- **File exists:** `src/tests/handlers.test.ts` (verify-against pattern)
- **Content check:** `src/tests/handlers.test.ts` contains "test" or "describe" or "it(" (has actual test code)
- **File exists:** `plan.md` in workspace (step-by-step pattern)
- **Content check:** `plan.md` contains numbered steps (matches regex `[1-3]\.` or `Step [1-3]`)
- **Content check:** `src/api/handlers.ts` contains "validate" or "validation" or a type check (validation was implemented)

**Hints:**
1. (Gentle) Good prompts have structure. Three patterns to try: (1) Ask Claude to explore before acting, (2) Give Claude something to verify against (like tests), (3) Break tasks into numbered steps.
2. (Specific) For exploration: "Read through this project and summarize the API structure in exploration.md." For tests-first: "Write tests for input validation in src/tests/handlers.test.ts, then implement the validation in the handler." For step-by-step: "Create a plan in plan.md with numbered steps to add input validation."
3. (Near-answer) Three prompts: (1) "Explore the codebase and write a summary of the API structure to exploration.md." (2) "Write tests in src/tests/handlers.test.ts that verify input validation, then add validation to src/api/handlers.ts." (3) "Create plan.md with steps: 1. What validation is missing? 2. What rules are needed? 3. Implement the validation."

---

### 6. Validation Patterns Reference

| Pattern | When to Use | Example | Shell Implementation |
|---|---|---|---|
| File exists | User must create a file | `hello.md exists` | `test -f "$FILE"` |
| File contains | User must include specific content | `contains "## Commands"` | `grep -qi "## Commands" "$FILE"` |
| File NOT contains | User must remove or avoid something | `no require( calls` | `! grep -q "require(" "$FILE"` |
| Line count range | File must be reasonable size | `between 10-100 lines` | `lines=$(wc -l < "$FILE"); [ "$lines" -ge 10 ] && [ "$lines" -le 100 ]` |
| Command succeeds | A command must exit 0 | `git status clean` | `git status --porcelain \| grep -q "^" && exit 1 \|\| exit 0` |
| Grep no match | A pattern must not exist anywhere | `no old function name` | `! grep -rq "getUserData" src/` |
| Branch exists | A git branch must exist | `feature/add-logging` | `git branch --list "feature/add-logging" \| grep -q .` |
| Commit message | Commit follows format | `conventional commit` | `git log --oneline -1 \| grep -qi "^[a-f0-9]* feat\|fix\|docs"` |
| Regex match | Content matches a pattern | `numbered steps` | `grep -qE "[1-3]\." plan.md` |

### 7. Resolved Questions

- [x] **Linear vs. parallel paths?** → Present exercises linearly in the UI (cc-001 through cc-008 in order). The prerequisite graph exists in metadata for future non-linear navigation (MVP2+), but MVP1 follows a fixed sequence for simplicity.
- [x] **Shell commands assumed?** → POSIX builtins (`test`, `[`, `echo`, `exit`) + POSIX utilities (`grep`, `wc`, `sed`, `awk`, `tr`, `sort`) + `git`. Do NOT assume `jq`, `node`, `npm`, `python`, or `rg`. For JSON, use `grep`/`sed` on known structures.
- [x] **Who creates the workspace directory?** → `/cclab:start` creates `~/.cclab/` and `~/.cclab/workspace/` (parent dirs). Each exercise's `setup.sh` creates its own `~/.cclab/workspace/cc-NNN/` subdirectory and scaffolds files. `setup.sh` must be idempotent (`mkdir -p`, overwrite files) so `/cclab:reset` can re-run it safely.
- [x] **Graduation message after cc-008?** → Yes. Short congratulations + teaser (3-4 lines): "You've completed the Fundamentals track! Next up: the Workflows track — custom slash commands, hooks, and permissions." No specific exercise listings from future tracks.
- [x] **cc-004 bug subtlety?** → Keep the obvious `emial` typo. This is a beginner exercise teaching exploration, not debugging skill. Obvious bugs build confidence and make validation reliable.
