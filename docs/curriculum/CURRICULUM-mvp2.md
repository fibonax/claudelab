# Curriculum Design: cclab MVP2 — Workflows Track

**Version:** 1.0
**Date:** 2026-03-13
**PRD Reference:** docs/prd/PRD-mvp2.md
**Status:** DRAFT

---

### 1. Learning Objectives

After completing the Workflows track, users will be able to:

- **Objective 1:** Create hook configurations that automate tasks at specific points in Claude Code's lifecycle (PreToolUse, PostToolUse, Notification, etc.)
- **Objective 2:** Configure project-level permissions and tool allowlists in settings.json to control what Claude can and cannot do
- **Objective 3:** Author custom slash commands (skills) with SKILL.md files, including argument handling and trigger configuration
- **Objective 4:** Create specialized subagent definitions that delegate focused tasks to purpose-built agents
- **Objective 5:** Configure MCP server connections to extend Claude Code with external tools
- **Objective 6:** Use git worktrees to work on isolated changes in parallel without branch conflicts

### 2. Track Overview

| Track | Focus | Exercise Count | Target Audience |
|---|---|---|---|
| workflows | Customization and extension — hooks, permissions, skills, subagents, MCP, worktrees | 8 | Fundamentals graduates and advanced users |

MVP2 delivers the **workflows** track. The fundamentals track (8 exercises) remains unchanged from MVP1.

### 3. Exercise Sequence

#### Track: workflows

| ID | Title | Concept | Difficulty | Prerequisites | Est. Time |
|---|---|---|---|---|---|
| wf-001 | Hook Line | Hook configuration and automation | beginner | None | 10 min |
| wf-002 | Guard Rails | Permissions and settings.json | beginner | wf-001 | 10 min |
| wf-003 | Command Crafter | Creating a custom skill (SKILL.md) | beginner | wf-001 | 15 min |
| wf-004 | Skill Surgeon | Skills with arguments and advanced config | intermediate | wf-003 | 15 min |
| wf-005 | Agent Assembler | Creating a specialized subagent | intermediate | wf-003 | 15 min |
| wf-006 | Plan & Conquer | Combining skills + subagents into a workflow | intermediate | wf-004, wf-005 | 20 min |
| wf-007 | Plug It In | Configuring an MCP server connection | intermediate | wf-002 | 15 min |
| wf-008 | Branch Out | Git worktrees for parallel work | intermediate | wf-001 | 10 min |

**Total estimated time:** ~115 minutes

### 4. Prerequisite Graph

```
wf-001 (Hook Line)
│
├──▶ wf-002 (Guard Rails)
│    │
│    └──▶ wf-007 (Plug It In)
│
├──▶ wf-003 (Command Crafter)
│    │
│    ├──▶ wf-004 (Skill Surgeon) ──┐
│    │                              ├──▶ wf-006 (Plan & Conquer)
│    └──▶ wf-005 (Agent Assembler) ┘
│
└──▶ wf-008 (Branch Out)
```

**Sequencing rationale:**
- wf-001 is the gateway — introduces `.claude/settings.json` structure through hooks, the most tangible feature
- wf-002 builds on settings.json familiarity from wf-001 to teach permissions
- wf-003 branches into a new concept (`.claude/skills/`) but benefits from understanding the `.claude/` directory from wf-001
- wf-004 deepens skills with arguments and advanced frontmatter (requires wf-003)
- wf-005 teaches subagents which share the markdown-with-frontmatter pattern with skills (requires wf-003)
- wf-006 is the capstone for the authoring path — combines skills and subagents into a plan-then-implement workflow (requires both wf-004 and wf-005)
- wf-007 teaches MCP configuration, which uses settings files and benefits from permissions knowledge (requires wf-002)
- wf-008 is relatively standalone (git-based) and can be done after the gateway exercise

### 5. Exercise Definitions

---

#### Exercise: wf-001 — Hook Line

**Concept:** Creating hook configurations that automate tasks at specific points in Claude Code's lifecycle
**Track:** workflows
**Difficulty:** beginner
**Prerequisites:** None
**Estimated Time:** 10 minutes

**Learning Goal:** After this exercise, the user will understand how Claude Code hooks work — what events are available, how to configure them in settings.json, and how to write a hook script that runs automatically.

**Setup:**
- Create workspace at `~/.cclab/workspace/wf-001/`
- Scaffold a simple project:
  - `src/app.ts` — a small TypeScript application
  - `src/utils.ts` — utility functions
  - `package.json` — project config
  - `CLAUDE.md` — project description
- No `.claude/` directory exists yet

**Instructions Summary:**
- Explain that hooks are shell commands that execute at specific points in Claude Code's lifecycle
- Introduce the key hook events: PreToolUse, PostToolUse, Notification
- Ask the user to create a `.claude/settings.json` with a hook configuration:
  - A `PostToolUse` hook that matches `Write` or `Edit` tools
  - The hook runs a script that logs the action to a file
- Ask the user to create the hook script at `scripts/log-edits.sh`:
  - The script reads JSON from stdin (tool name, file path)
  - Appends a log line to `edit-log.txt`
  - Exits with code 0 (allow the action to proceed)

**Validation Strategy:**
- **File exists:** `.claude/settings.json` in workspace
- **Content check:** settings.json contains `"hooks"` (hook configuration present)
- **Content check:** settings.json contains `"PostToolUse"` or `"PreToolUse"` (a valid event name)
- **Content check:** settings.json contains `"matcher"` (hook matcher configured)
- **Content check:** settings.json contains `"command"` (hook command configured)
- **File exists:** `scripts/log-edits.sh` exists
- **Content check:** `scripts/log-edits.sh` contains `exit 0` or `exit` (proper exit handling)
- **Permission check:** `scripts/log-edits.sh` is executable (`test -x`)

**Hints:**
1. (Gentle) Hooks live in `.claude/settings.json` under the `"hooks"` key. Each hook event (like `PostToolUse`) contains an array of matchers, and each matcher specifies which tools to match and what command to run.
2. (Specific) Create `.claude/settings.json` with this structure: `{"hooks": {"PostToolUse": [{"matcher": "...", "hooks": [{"type": "command", "command": "..."}]}]}}`. The matcher is a regex matching tool names like `"Write|Edit"`. Also create `scripts/log-edits.sh` that reads stdin and logs to a file.
3. (Near-answer) Create `.claude/settings.json` with a `PostToolUse` hook that matches `"Write|Edit"` and runs `"./scripts/log-edits.sh"`. Then create `scripts/log-edits.sh` with: `#!/bin/bash`, read stdin, append to `edit-log.txt`, and `exit 0`. Make it executable with `chmod +x scripts/log-edits.sh`.

---

#### Exercise: wf-002 — Guard Rails

**Concept:** Configuring project-level permissions and tool allowlists to control Claude Code's access
**Track:** workflows
**Difficulty:** beginner
**Prerequisites:** wf-001
**Estimated Time:** 10 minutes

**Learning Goal:** After this exercise, the user will understand Claude Code's permission model — how to allow, deny, and restrict tools using settings.json, and how project vs user settings interact.

**Setup:**
- Create workspace at `~/.cclab/workspace/wf-002/`
- Scaffold a project with sensitive and regular files:
  - `src/app.ts` — main application
  - `src/db.ts` — database connection module
  - `.env` — environment variables with fake credentials
  - `secrets/api-keys.json` — fake API keys file
  - `CLAUDE.md` — project description mentioning security practices
- Create a `.claude/` directory (empty, no settings.json yet)

**Instructions Summary:**
- Explain the three permission levels: allow (auto-approved), deny (blocked), ask (prompts user)
- Explain tool pattern syntax: `Tool(specifier)` — e.g., `Bash(npm test)`, `Read(/src/**)`, `Edit(.env)`
- Ask the user to create `.claude/settings.json` with permission rules:
  - **Allow:** `Read` for all files, `Bash(npm *)` commands, `Grep`, `Glob`
  - **Deny:** `Edit(.env)`, `Edit(/secrets/**)`, `Bash(rm *)`, `Bash(curl *)`
  - The configuration must have at least 3 allow rules and at least 2 deny rules

**Validation Strategy:**
- **File exists:** `.claude/settings.json` in workspace
- **Content check:** settings.json contains `"permissions"` (permissions block present)
- **Content check:** settings.json contains `"allow"` (allow rules exist)
- **Content check:** settings.json contains `"deny"` (deny rules exist)
- **Content check:** settings.json mentions `.env` or `secrets` (sensitive file protection)
- **Content check:** settings.json mentions `Bash` or `Read` or `Edit` (tool-specific rules)
- **JSON validity:** settings.json is valid JSON (`python3 -c "import json; json.load(open('...'))"` or grep-based structure check)

**Hints:**
1. (Gentle) Permissions go in `.claude/settings.json` under `"permissions"`. Think about what Claude should be able to do freely (read code, run tests) and what it should never do (edit secrets, delete files). Use `"allow"` and `"deny"` arrays.
2. (Specific) Create `.claude/settings.json` with `{"permissions": {"allow": [...], "deny": [...]}}`. Allow rules use patterns like `"Read"` (all reads) or `"Bash(npm *)"` (npm commands). Deny rules protect files: `"Edit(.env)"` blocks editing .env. Include at least 3 allow and 2 deny rules.
3. (Near-answer) Create this settings.json: `{"permissions": {"allow": ["Read", "Bash(npm *)", "Grep", "Glob"], "deny": ["Edit(.env)", "Edit(/secrets/**)", "Bash(rm *)"]}}`. This allows reading and npm commands while blocking edits to .env, secrets, and destructive bash commands.

---

#### Exercise: wf-003 — Command Crafter

**Concept:** Creating a custom slash command by writing a SKILL.md file
**Track:** workflows
**Difficulty:** beginner
**Prerequisites:** wf-001
**Estimated Time:** 15 minutes

**Learning Goal:** After this exercise, the user will know how to create a custom slash command (skill) with proper frontmatter and instructions, and understand how Claude Code discovers and invokes skills.

**Setup:**
- Create workspace at `~/.cclab/workspace/wf-003/`
- Scaffold a project:
  - `src/index.ts` — a small application
  - `src/utils.ts` — utility functions
  - `package.json` — project config
  - `CLAUDE.md` — project description
- Create `.claude/skills/` directory (empty, no skills yet)

**Instructions Summary:**
- Explain that skills are custom slash commands defined by SKILL.md files
- Explain the SKILL.md structure: YAML frontmatter (name, description) + markdown instructions
- Explain where skills live: `.claude/skills/{skill-name}/SKILL.md`
- Ask the user to create a skill called `explain-code` that:
  - Has a `name` and `description` in frontmatter
  - Contains instructions for Claude to read a file and explain it in plain English
  - Includes at least 3 numbered steps in the instructions
- The skill should be at `.claude/skills/explain-code/SKILL.md`

**Validation Strategy:**
- **File exists:** `.claude/skills/explain-code/SKILL.md` in workspace
- **Content check:** SKILL.md contains `name:` in frontmatter (has name field)
- **Content check:** SKILL.md contains `description:` in frontmatter (has description field)
- **Content check:** SKILL.md contains `---` (frontmatter delimiters present, at least 2 occurrences)
- **Content check:** SKILL.md contains numbered steps (matches regex `[1-3]\.` or `Step`)
- **Line count:** SKILL.md is at least 10 lines (not a stub)

**Hints:**
1. (Gentle) A skill is a markdown file with YAML frontmatter at the top (between `---` delimiters). The frontmatter tells Claude Code the skill's name and when to use it. The body tells Claude what to do when the skill is invoked. Create it at `.claude/skills/explain-code/SKILL.md`.
2. (Specific) Your SKILL.md needs frontmatter with `name: explain-code` and `description: Explain a code file in plain English`. Below the frontmatter, write numbered instructions: 1. Read the specified file, 2. Analyze the code structure, 3. Write a clear explanation. Make sure the file is at least 10 lines.
3. (Near-answer) Create `.claude/skills/explain-code/SKILL.md` with: `---\nname: explain-code\ndescription: Read a code file and explain it in plain English\n---\n\n# Explain Code\n\n1. Read the file specified by the user\n2. Analyze the code structure, functions, and logic\n3. Write a clear, plain-English explanation\n\n...` Add enough detail to reach 10+ lines.

---

#### Exercise: wf-004 — Skill Surgeon

**Concept:** Creating a skill with arguments, advanced frontmatter options, and structured instructions
**Track:** workflows
**Difficulty:** intermediate
**Prerequisites:** wf-003
**Estimated Time:** 15 minutes

**Learning Goal:** After this exercise, the user will know how to create skills that accept arguments (using `$ARGUMENTS` and `$0`/`$1` substitution), configure advanced frontmatter fields like `argument-hint` and `disable-model-invocation`, and write structured skill instructions.

**Setup:**
- Create workspace at `~/.cclab/workspace/wf-004/`
- Scaffold a project:
  - `src/` — several TypeScript source files
  - `CLAUDE.md` — project description with code style conventions
  - `.claude/skills/` — empty skills directory

**Instructions Summary:**
- Explain argument handling in skills: `$ARGUMENTS` (full argument string), `$0` (first arg), `$1` (second arg)
- Explain `argument-hint:` frontmatter field (shown in autocomplete)
- Explain `disable-model-invocation:` (manual-only skills for dangerous operations)
- Ask the user to create a skill called `refactor` at `.claude/skills/refactor/SKILL.md` that:
  - Accepts a file path as an argument (`$ARGUMENTS` or `$0`)
  - Has `argument-hint: <file-path>` in frontmatter
  - Has `disable-model-invocation: true` (should only run when explicitly invoked)
  - Contains structured instructions with at least 4 numbered steps:
    1. Read the target file
    2. Analyze for code smells
    3. Propose refactoring plan
    4. Apply changes after confirmation

**Validation Strategy:**
- **File exists:** `.claude/skills/refactor/SKILL.md` in workspace
- **Content check:** SKILL.md contains `name:` with value (has name field)
- **Content check:** SKILL.md contains `description:` (has description field)
- **Content check:** SKILL.md contains `$ARGUMENTS` or `$0` (uses argument substitution)
- **Content check:** SKILL.md contains `argument-hint:` (has argument hint)
- **Content check:** SKILL.md contains `disable-model-invocation:` (has manual-only flag)
- **Content check:** SKILL.md contains at least 4 numbered steps (matches regex `[1-4]\.`)
- **Line count:** SKILL.md is at least 15 lines

**Hints:**
1. (Gentle) Skills can accept arguments — when a user types `/refactor src/app.ts`, the `src/app.ts` part is available as `$ARGUMENTS` (full string) or `$0` (first argument) in your SKILL.md. Add `argument-hint:` to frontmatter to show users what arguments to provide.
2. (Specific) Create `.claude/skills/refactor/SKILL.md` with frontmatter including `name: refactor`, `description:`, `argument-hint: <file-path>`, and `disable-model-invocation: true`. In the body, reference `$ARGUMENTS` or `$0` for the file path, and include 4+ numbered steps for the refactoring workflow.
3. (Near-answer) Create the SKILL.md with: `---\nname: refactor\ndescription: Refactor a file for better code quality\nargument-hint: <file-path>\ndisable-model-invocation: true\n---\n\n# Refactor\n\nRefactor the file at `$ARGUMENTS`:\n\n1. Read the target file\n2. Analyze for code smells and duplication\n3. Propose a refactoring plan\n4. Apply changes after user confirms\n\n...`

---

#### Exercise: wf-005 — Agent Assembler

**Concept:** Creating a specialized subagent with focused tools, instructions, and configuration
**Track:** workflows
**Difficulty:** intermediate
**Prerequisites:** wf-003
**Estimated Time:** 15 minutes

**Learning Goal:** After this exercise, the user will know how to create subagent definitions — markdown files in `.claude/agents/` that define specialized agents with restricted tools, focused instructions, and appropriate configuration.

**Setup:**
- Create workspace at `~/.cclab/workspace/wf-005/`
- Scaffold a project:
  - `src/` — several source files with varying code quality
  - `src/api/handlers.ts` — API handler with no error handling
  - `src/utils/logger.ts` — logging utility
  - `CLAUDE.md` — project description
  - `.claude/agents/` — empty agents directory

**Instructions Summary:**
- Explain that subagents are specialized agents defined by markdown files in `.claude/agents/`
- Explain the subagent file format: YAML frontmatter (name, description, tools) + markdown body with instructions
- Explain key frontmatter fields: `name`, `description`, `tools` (allowed tools list), `model`
- Ask the user to create a code review subagent at `.claude/agents/code-reviewer.md` that:
  - Has `name: code-reviewer` and a meaningful `description`
  - Restricts tools to read-only: `tools: Read, Grep, Glob, Bash`
  - Specifies a review checklist in the body (error handling, naming, duplication, security)
  - Has at least 4 review criteria
  - Organizes feedback by priority (critical, warnings, suggestions)

**Validation Strategy:**
- **File exists:** `.claude/agents/code-reviewer.md` in workspace
- **Content check:** agent file contains `name:` in frontmatter
- **Content check:** agent file contains `description:` in frontmatter
- **Content check:** agent file contains `tools:` in frontmatter (tool restrictions)
- **Content check:** agent file mentions `Read` or `Grep` (read-only tools listed)
- **Content check:** agent file does NOT contain `Edit` or `Write` in the tools line (read-only agent)
- **Content check:** agent file body mentions "review" or "check" (review instructions present)
- **Line count:** agent file is at least 15 lines

**Hints:**
1. (Gentle) Subagents live in `.claude/agents/` as markdown files. Like skills, they have YAML frontmatter (between `---`) with configuration, and a markdown body with instructions. The key difference is the `tools:` field — you control exactly which tools the agent can use.
2. (Specific) Create `.claude/agents/code-reviewer.md` with frontmatter containing `name: code-reviewer`, `description: Expert code reviewer...`, and `tools: Read, Grep, Glob, Bash` (read-only, no Edit/Write). In the body, list a review checklist with 4+ criteria and organize feedback into priority levels.
3. (Near-answer) Create the file with: `---\nname: code-reviewer\ndescription: Reviews code for quality, security, and maintainability\ntools: Read, Grep, Glob, Bash\n---\n\nYou are a code reviewer. When invoked:\n1. Read the specified files\n2. Check for: error handling, naming conventions, code duplication, security issues\n3. Organize feedback as:\n- Critical (must fix)\n- Warnings (should fix)\n- Suggestions (nice to have)\n...`

---

#### Exercise: wf-006 — Plan & Conquer

**Concept:** Combining a planning skill and implementation subagents into a real workflow — plan once, execute in parallel
**Track:** workflows
**Difficulty:** intermediate
**Prerequisites:** wf-004, wf-005
**Estimated Time:** 20 minutes

**Learning Goal:** After this exercise, the user will know how to compose skills and subagents into a real workflow — a planning skill that produces a task list, and an implementation subagent that executes individual tasks. They will also practice spawning multiple subagents in parallel.

**Setup:**
- Create workspace at `~/.cclab/workspace/wf-006/`
- Scaffold a project with multiple improvement opportunities:
  - `src/api/handlers.ts` — API handler with no input validation and no error handling
  - `src/api/types.ts` — type definitions (incomplete, missing several interfaces)
  - `src/services/user-service.ts` — user service with hardcoded values and no logging
  - `src/utils/logger.ts` — a stub logger that only has `console.log`
  - `package.json` — project config
  - `CLAUDE.md` — project description listing known issues
  - `.claude/skills/` — empty skills directory
  - `.claude/agents/` — empty agents directory
- The project intentionally has 3-4 clear improvement areas so the planning skill has real work to discover

**Instructions Summary:**
- Explain the "plan then implement" pattern: a skill analyzes the codebase and produces a structured task list, then subagents execute individual tasks from that list in parallel
- Ask the user to create two things:

  **Part 1: Planning Skill**
  - Create `.claude/skills/plan/SKILL.md` that:
    - Has `name: plan` and a description about analyzing a codebase and producing a task list
    - Instructs Claude to explore the codebase, identify improvements, and write a numbered task list to `plan.md`
    - Each task in the output should have: a number, a title, the target file(s), and a brief description of what to do
    - Uses `$ARGUMENTS` to optionally scope the analysis (e.g., `/plan src/api/`)

  **Part 2: Implementation Subagent**
  - Create `.claude/agents/implementer.md` that:
    - Has `name: implementer` and a description about implementing a single task from a plan
    - Has tools that include `Read`, `Edit`, `Write`, `Grep`, `Glob` (needs write access)
    - Instructs the agent to: read the plan, pick the assigned task, implement it, and report what was done

  **Part 3: Run the Workflow**
  - Invoke the planning skill (or ask Claude to plan) to generate `plan.md` with at least 3 tasks
  - Ask Claude to spawn 2-3 subagents (using the implementer agent) to work on tasks from the plan
  - Each subagent should produce a result file at `results/task-N.md` summarizing what was done

**Validation Strategy:**
- **File exists:** `.claude/skills/plan/SKILL.md` in workspace
- **Content check:** plan SKILL.md contains `name:` in frontmatter
- **Content check:** plan SKILL.md contains `description:` in frontmatter
- **Content check:** plan SKILL.md mentions `plan.md` or `task` (references output format)
- **File exists:** `.claude/agents/implementer.md` in workspace
- **Content check:** implementer agent contains `name:` in frontmatter
- **Content check:** implementer agent contains `description:` in frontmatter
- **Content check:** implementer agent contains `tools:` in frontmatter
- **Content check:** implementer agent mentions `Edit` or `Write` (has write access)
- **File exists:** `plan.md` in workspace (planning skill was executed)
- **Content check:** `plan.md` contains at least 3 numbered items (matches regex for `1\.`, `2\.`, `3\.`)
- **Line count:** `plan.md` is at least 10 lines
- **Directory exists:** `results/` directory exists
- **File count:** at least 2 files in `results/` directory (evidence of multiple subagent runs)

**Hints:**
1. (Gentle) This exercise has three parts: first create a planning skill that outputs a task list, then create a subagent that implements tasks, then run the workflow. Start with the skill in `.claude/skills/plan/SKILL.md` — it should tell Claude to explore the code and write a numbered list of improvements to `plan.md`.
2. (Specific) Part 1: Create `.claude/skills/plan/SKILL.md` with frontmatter (`name: plan`, `description: ...`) and instructions to read the codebase and output a numbered task list to `plan.md`. Part 2: Create `.claude/agents/implementer.md` with frontmatter (`name: implementer`, `tools: Read, Edit, Write, Grep, Glob`) and instructions to implement one task from the plan. Part 3: Run the plan, then ask Claude to "use the implementer agent to work on task 1" (repeat for 2-3 tasks). Each result goes in `results/task-N.md`.
3. (Near-answer) Create the skill: `---\nname: plan\ndescription: Analyze codebase and produce improvement task list\n---\n\nExplore the codebase and identify improvements. Write a numbered task list to plan.md...`. Create the agent: `---\nname: implementer\ndescription: Implement a single task from the plan\ntools: Read, Edit, Write, Grep, Glob\n---\n\nRead plan.md, implement the assigned task, save a summary to results/task-N.md...`. Then: ask Claude to run /plan, then "Use the implementer agent to work on tasks 1, 2, and 3 from the plan. Write results to results/task-1.md, results/task-2.md, results/task-3.md."

---

#### Exercise: wf-007 — Plug It In

**Concept:** Configuring an MCP server connection to extend Claude Code with external tools
**Track:** workflows
**Difficulty:** intermediate
**Prerequisites:** wf-002
**Estimated Time:** 15 minutes

**Learning Goal:** After this exercise, the user will understand the MCP (Model Context Protocol) — how to configure server connections, what transport types exist (stdio, http), and how MCP tools become available to Claude Code.

**Setup:**
- Create workspace at `~/.cclab/workspace/wf-007/`
- Scaffold a project:
  - `CLAUDE.md` — project description
  - `tools/timestamp-server.py` — a sample MCP server (Python3) that exposes two tools:
    - `get_timestamp` — returns current timestamp in various formats
    - `word_count` — counts words in provided text
  - The sample server implements the MCP stdio protocol (JSON-RPC over stdin/stdout)
  - `tools/README.md` — brief explanation of what the sample server does
- No MCP configuration exists yet

**Instructions Summary:**
- Explain what MCP is: a protocol that lets Claude Code communicate with external tool servers
- Explain transport types: `stdio` (local process), `http` (remote API)
- Explain tool naming: MCP tools appear as `mcp__<server-name>__<tool-name>`
- Ask the user to create an MCP configuration file (`.mcp.json`) that:
  - Configures the sample `timestamp-server` using stdio transport
  - Points to the `tools/timestamp-server.py` script
  - Uses `python3` as the command
- Also ask the user to add the MCP tools to the project's permission allowlist in `.claude/settings.json`:
  - Allow `mcp__timestamp__*` (all tools from the timestamp server)

**Validation Strategy:**
- **File exists:** `.mcp.json` in workspace
- **Content check:** `.mcp.json` contains `"mcpServers"` (MCP config block)
- **Content check:** `.mcp.json` contains `"timestamp"` or `"timestamp-server"` (server name)
- **Content check:** `.mcp.json` contains `"command"` (stdio transport command)
- **Content check:** `.mcp.json` contains `"python3"` or `"python"` (correct command for the server)
- **File exists:** `.claude/settings.json` in workspace
- **Content check:** settings.json contains `"mcp__"` or `"mcp_"` (MCP tool permission)
- **File exists:** `tools/timestamp-server.py` (sample server still present)

**Hints:**
1. (Gentle) MCP configuration goes in `.mcp.json` at the project root. Each server has a name and connection details. For a local script, use `"type": "stdio"` with a `"command"` and `"args"` array. Also add the MCP tools to your permissions in `.claude/settings.json`.
2. (Specific) Create `.mcp.json` with: `{"mcpServers": {"timestamp": {"type": "stdio", "command": "python3", "args": ["tools/timestamp-server.py"]}}}`. Then create or update `.claude/settings.json` to allow MCP tools: `{"permissions": {"allow": ["mcp__timestamp__*"]}}`.
3. (Near-answer) Two files needed: (1) `.mcp.json`: `{"mcpServers": {"timestamp": {"type": "stdio", "command": "python3", "args": ["./tools/timestamp-server.py"]}}}` and (2) `.claude/settings.json`: `{"permissions": {"allow": ["mcp__timestamp__*"]}}`. The sample server at `tools/timestamp-server.py` is already provided — you're just configuring Claude Code to connect to it.

---

#### Exercise: wf-008 — Branch Out

**Concept:** Using git worktrees for parallel isolated work
**Track:** workflows
**Difficulty:** intermediate
**Prerequisites:** wf-001
**Estimated Time:** 10 minutes

**Learning Goal:** After this exercise, the user will understand git worktrees — how to create isolated working directories that share repository history, enabling parallel work on different branches without conflicts.

**Setup:**
- Create workspace at `~/.cclab/workspace/wf-008/`
- Initialize a git repo with an initial commit:
  - `src/app.ts` — main application
  - `src/auth.ts` — authentication module (needs improvement)
  - `src/dashboard.ts` — dashboard module (needs a new feature)
  - `CLAUDE.md` — project description
  - Initial commit: "chore: initial project setup"
- The repo has a clean working tree on the `main` branch

**Instructions Summary:**
- Explain what git worktrees are: separate working directories that share the same repository
- Explain the benefit: work on multiple features simultaneously without stashing or switching branches
- Explain how Claude Code uses worktrees: `claude --worktree <name>` or manual `git worktree add`
- Ask the user to:
  1. Create a worktree at `.worktrees/feature-auth/` on a new branch `feature/improve-auth`
  2. In the worktree, create or modify a file (e.g., add `src/auth-utils.ts`)
  3. Commit the change in the worktree
  4. Return to the main working directory and verify the worktree exists with `git worktree list`
- The main working directory should remain on `main` branch, unchanged

**Validation Strategy:**
- **Command check:** `git worktree list` shows more than 1 entry (worktree exists)
- **Command check:** `git branch --list "feature/improve-auth"` or similar branch exists
- **File exists:** `.worktrees/feature-auth/src/auth-utils.ts` or similar new file in worktree
- **Command check:** `git -C .worktrees/feature-auth/ log --oneline -1` shows a commit (work was committed)
- **Command check:** `git branch --show-current` returns `main` (main directory still on main)
- **Command check:** `git status --porcelain` is empty on main (clean working tree)

**Hints:**
1. (Gentle) Git worktrees let you have multiple checkouts of the same repo. Think of it as cloning your repo into a subdirectory, but sharing the git history. Use `git worktree add <path> -b <branch-name>` to create one.
2. (Specific) Run `git worktree add .worktrees/feature-auth -b feature/improve-auth` to create a worktree. Then `cd .worktrees/feature-auth/` and create a file like `src/auth-utils.ts`. Commit the change there, then `cd` back to the main directory.
3. (Near-answer) Step by step: (1) `git worktree add .worktrees/feature-auth -b feature/improve-auth` (2) Create a file in `.worktrees/feature-auth/src/auth-utils.ts` (3) In the worktree, run `git add . && git commit -m "feat(auth): add auth utilities"` (4) Return to main directory and verify with `git worktree list`.

---

### 6. Validation Patterns Reference

| Pattern | When to Use | Example | Shell Implementation |
|---|---|---|---|
| File exists | User must create a config file | `settings.json exists` | `test -f "$FILE"` |
| File contains | Config must have specific keys | `contains "hooks"` | `grep -q '"hooks"' "$FILE"` |
| File NOT contains | Config must exclude something | `no "Edit" in tools line` | `! grep -q '"Edit"' "$FILE"` |
| Line count range | File must be substantive | `at least 15 lines` | `lines=$(wc -l < "$FILE"); [ "$lines" -ge 15 ]` |
| JSON validity | Config must be valid JSON | `settings.json parses` | `python3 -c "import json; json.load(open('$FILE'))"` |
| Command succeeds | Git or system state | `worktree exists` | `git worktree list \| grep -q "feature-auth"` |
| Executable check | Script must be runnable | `hook script is +x` | `test -x "$FILE"` |
| Frontmatter check | SKILL.md has proper metadata | `has name: field` | `grep -q "^name:" "$FILE"` |
| Grep no match | A pattern must not exist | `no "Write" in tools` | `! grep -q "Write" "$FILE"` |
| Directory exists | User must create structure | `.claude/skills/explain-code/` | `test -d "$DIR"` |
| Branch exists | Git branch must be created | `feature/improve-auth` | `git branch --list "feature/improve-auth" \| grep -q .` |
| File count in dir | Multiple outputs exist | `at least 2 result files` | `[ "$(ls -1 results/ \| wc -l)" -ge 2 ]` |
| Multi-file consistency | Related configs agree | `MCP + permissions aligned` | Check both `.mcp.json` and `settings.json` |

### 7. Resolved Questions

- [x] **Exercise ID scheme?** → Track-specific prefix: `wf-001` through `wf-008`. Fundamentals keep `cc-NNN`.
- [x] **How many exercises?** → 8 exercises, ~115 minutes total. Skills gets 2 exercises (basics + arguments), and a capstone exercise (wf-006) combines skills + subagents into a plan-then-implement workflow.
- [x] **MCP sample server?** → Provide a Python3 `timestamp-server.py` that exposes 2 simple tools via stdio. Python3 is available on macOS/Linux. Validation checks config structure + server existence.
- [x] **Cross-track prerequisites?** → Workflows track is self-contained. It recommends Fundamentals completion (especially cc-002 for CLAUDE.md familiarity) but does not require it.
- [x] **Graduation message after wf-008?** → Congratulations + stats. No teaser for a future track since none is planned yet. Emphasize applying these skills to real projects.
- [x] **Validation of runtime behavior?** → We validate config file structure and content, not runtime behavior. Hooks, permissions, MCP, and skills are validated by checking that config files exist and contain correct patterns. This is deterministic and reliable.
- [x] **Workspace isolation for sensitive exercises?** → All exercises work in `~/.cclab/workspace/wf-NNN/`. Hook scripts, permission configs, MCP configs, and skill files are created within the exercise workspace, never in the user's real `~/.claude/` directory.
