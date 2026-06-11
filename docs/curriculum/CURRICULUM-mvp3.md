# Curriculum Design: cclab MVP3 — Advanced Track

**Version:** 1.0
**Date:** 2026-06-11
**Status:** DRAFT (built autonomously per goal directive; pending review)

---

### 1. Scope and Relationship to the Workflows Track

The workflows track already introduces subagents (wf-005), MCP configuration
(wf-007), and worktree basics (wf-008). The advanced track does NOT repeat
those introductions — every exercise goes one level deeper:

| Workflows taught… | Advanced teaches… |
|---|---|
| creating a subagent (wf-005) | tool/model/permission specialization |
| logging hooks (wf-001) | **blocking** hooks with stdin JSON + exit 2 |
| configuring an MCP connection (wf-007) | **authoring** an MCP server |
| one worktree (wf-008) | parallel worktrees + merging both |
| skill arguments (wf-004) | named arguments + `context: fork` |
| using a plugin (cclab itself) | **building** a plugin |

### 2. Exercise Sequence

#### Track: advanced

| ID | Title | Concept | Difficulty | Prerequisites | Est. Time |
|---|---|---|---|---|---|
| adv-001 | Specialist Squad | Subagent specialization: tools, disallowedTools, model, permissionMode | advanced | wf-005 | 15 min |
| adv-002 | Iron Gate | Blocking PreToolUse hooks: stdin JSON, exit 2 semantics | advanced | wf-001 | 20 min |
| adv-003 | Server Smith | Authoring a stdio MCP server (JSON-RPC, stdlib only) | advanced | wf-007 | 25 min |
| adv-004 | Parallel Worlds | Two parallel worktrees, independent branches, merging both | advanced | wf-008 | 20 min |
| adv-005 | Forked Context | Skills with named arguments and context: fork | advanced | wf-004 | 15 min |
| adv-006 | Plugin Architect | Capstone: package a skill + hook into a distributable plugin | advanced | adv-002, adv-005 | 25 min |

**Total estimated time:** ~120 minutes

### 3. Prerequisite Graph

```
wf-005 ──▶ adv-001 (Specialist Squad)
wf-001 ──▶ adv-002 (Iron Gate) ──────┐
wf-007 ──▶ adv-003 (Server Smith)    ├──▶ adv-006 (Plugin Architect)
wf-008 ──▶ adv-004 (Parallel Worlds) │
wf-004 ──▶ adv-005 (Forked Context) ─┘
```

### 4. Exercise Definitions

#### adv-001 — Specialist Squad
**Goal:** configure a subagent precisely: an `auditor` agent with a read-only
tools allowlist, an explicit `disallowedTools` line, a `model:` override
(haiku — cheap and fast for scanning), and `permissionMode: plan`.
**Setup:** project with several source files containing audit-worthy issues;
empty `.claude/agents/`.
**Validation:** frontmatter-scoped checks for `tools:` without Edit/Write,
`disallowedTools:` containing Write, `model:` with a valid value
(haiku|sonnet|opus|inherit), `permissionMode:` present, body ≥ 8 lines.

#### adv-002 — Iron Gate
**Goal:** write a PreToolUse hook that BLOCKS dangerous Bash commands:
reads the hook event JSON from stdin, inspects `tool_input.command`,
exits 2 (block, stderr shown to Claude) for `rm -rf` targeting `/` or `~`,
exits 0 otherwise. Wire it in `.claude/settings.json` with a `Bash` matcher.
**Validation (behavioral — the validator EXECUTES the learner's hook):**
pipe a dangerous payload into the hook script → expect exit 2;
pipe a safe payload → expect exit 0; settings.json declares the hook
under PreToolUse with a Bash matcher.

#### adv-003 — Server Smith
**Goal:** implement a minimal stdio MCP server in Python 3 (stdlib only)
that answers `initialize`, `tools/list` (one tool: `word_count`), and
`tools/call`. Register it in `.mcp.json` (type stdio).
**Validation (behavioral):** the validator sends JSON-RPC requests to the
server's stdin and checks responses: `initialize` → result with
protocolVersion; `tools/list` → contains `word_count`; `tools/call` with a
text argument → correct count in the response. `.mcp.json` registers it.

#### adv-004 — Parallel Worlds
**Goal:** create TWO worktrees (`.worktrees/feature-stats`,
`.worktrees/feature-export`) on separate branches, add a distinct file +
commit in each, then merge BOTH branches back into main.
**Validation:** both branches exist and are merged into main
(`git branch --merged main`), both feature files exist on main,
working tree clean, ≥ 3 commits on main.

#### adv-005 — Forked Context
**Goal:** author a `summarize` skill that declares
`arguments: [target, audience]` in frontmatter, uses `$target` and
`$audience` placeholders in the body, and sets `context: fork` so the
skill runs in an isolated context.
**Validation:** frontmatter-scoped: `arguments:` list with two names,
`context: fork`, body references `$target` and `$audience`,
`disable-model-invocation: true`, body ≥ 10 lines.

#### adv-006 — Plugin Architect (capstone)
**Goal:** assemble a distributable plugin `wordsmith`:
`.claude-plugin/plugin.json` manifest (name, version, description, skills),
one skill (`skills/lint-prose/SKILL.md`), and bundled
`hooks/hooks.json` with a PostToolUse Write|Edit hook calling a script via
`${CLAUDE_PLUGIN_ROOT}`.
**Validation:** manifest is valid JSON with required fields; skill exists
with valid frontmatter; hooks.json valid with PostToolUse + matcher +
`${CLAUDE_PLUGIN_ROOT}` reference; hook script exists and is executable.

### 5. Conventions

Same as MVP1/MVP2: each exercise ships `metadata.json`, `instructions.md`,
`setup.sh` (idempotent, removes learner artifacts), `validate.sh`
(POSIX + grep/sed/awk; python3 allowed ONLY where the exercise itself
already requires it, with a fallback message), `hints.md` (3 levels).
Track value: `advanced`. IDs: `adv-NNN`.
