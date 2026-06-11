# CCA Exam Knowledge vs. cclab Architecture Options

**Date:** 2026-03-18
**Context:** Mapping the Claude Certified Architect (CCA) Foundations exam domains to cclab's architecture options, evaluating which architectures can teach which exam knowledge, and identifying extensibility paths.

**Source:** Official CCA Exam Guide (v0.1, Feb 10 2025, Anthropic Confidential NTK)

---

## CCA Exam Structure (Quick Reference)

| Domain | Weight | Core Topics |
|--------|--------|-------------|
| D1: Agentic Architecture & Orchestration | 27% | Agentic loops, multi-agent, subagents, hooks, session management, task decomposition |
| D2: Tool Design & MCP Integration | 18% | Tool descriptions, structured errors, MCP servers, built-in tools (Read/Write/Edit/Bash/Grep/Glob) |
| D3: Claude Code Configuration & Workflows | 20% | CLAUDE.md hierarchy, commands/skills, .claude/rules/, plan mode, CI/CD, iterative refinement |
| D4: Prompt Engineering & Structured Output | 20% | Few-shot prompting, JSON schemas, tool_use, validation-retry loops, batch processing, multi-pass review |
| D5: Context Management & Reliability | 15% | Context preservation, escalation patterns, error propagation, codebase exploration, human review, provenance |

**6 Exam Scenarios:** Customer Support Agent, Code Generation with Claude Code, Multi-Agent Research System, Developer Productivity, CI/CD Integration, Structured Data Extraction

---

## What cclab Can Teach Today

cclab's current exercises (fundamentals + workflows tracks) focus on **learning to use Claude Code interactively** — creating files, using tools, writing CLAUDE.md, etc. This maps almost exclusively to **Domain 3** and a slice of **Domain 2** (built-in tools).

### Coverage gap is massive

| Domain | Current cclab coverage | Gap |
|--------|----------------------|-----|
| D1 (27%) | ~5% — Exercises don't involve building agents, loops, or orchestration | **~22%** |
| D2 (18%) | ~8% — Covers built-in tools; no MCP server design, error responses, or tool distribution | **~10%** |
| D3 (20%) | ~15% — Covers CLAUDE.md basics, some skills; missing .claude/rules/, plan mode depth, CI/CD | **~5%** |
| D4 (20%) | ~2% — No exercises on prompt engineering, JSON schemas, tool_use, or batch processing | **~18%** |
| D5 (15%) | ~1% — No exercises on context management, escalation, error propagation, or provenance | **~14%** |
| **Total** | **~31% addressable** | **~69% gap** |

The bottom line: **cclab currently addresses roughly a third of the CCA exam surface area.** The remaining two-thirds requires exercises that go beyond "use Claude Code interactively" into "build production systems with Claude."

---

## Domain-by-Domain Analysis: What Each Architecture Enables

### Domain 1: Agentic Architecture & Orchestration (27%)

**What the exam tests:**
- Agentic loop lifecycle (`stop_reason`, `tool_use` vs `end_turn`)
- Hub-and-spoke multi-agent patterns (coordinator + subagents)
- `Task` tool, `AgentDefinition`, `allowedTools` configuration
- Hooks (`PostToolUse`) for interception and data normalization
- Workflow enforcement (prerequisite gates, handoff protocols)
- Task decomposition strategies (prompt chaining vs dynamic)
- Session management (`--resume`, `fork_session`)

**Architecture applicability:**

| Option | Can teach D1? | How |
|--------|:---:|------|
| A: Pure Plugin | Minimal | Can explain concepts in instructions; can't have learner build an agent |
| B: Hooks | Partial | Exercise: "Write a PostToolUse hook that blocks refunds > $500". Validates the hook file exists and works. Directly tests Task 1.5 |
| C: Wrapper CLI | Partial | Could demonstrate stream-json event parsing (shows stop_reason, tool_use events). But learner watches, doesn't build |
| D: Companion CLI | No | CLI doesn't touch agent concepts |
| **E: MCP Server** | **Yes** | Learner builds an MCP server with tools, then uses it from Claude Code. Server can simulate an agentic workflow. Covers Task 2.1-2.4 deeply |
| **F: Hybrid** | **Best** | Hooks teach Task 1.5 directly. MCP server exercises teach tool design. Plugin skills teach session management patterns |

**Key insight:** To teach D1 properly, learners need to **write code** — not just use Claude Code. This requires exercises where the deliverable is a Python/TypeScript file that implements an agentic loop or MCP server. The current setup.sh/validate.sh pattern can handle this (scaffold a project, validate the output), but the exercises need to be fundamentally different from "create hello.md."

**Specific exercise ideas:**
- Build an agentic loop that processes `stop_reason` correctly (validate: run the script, check output)
- Write a `PostToolUse` hook that normalizes timestamps (validate: hook file exists + runs correctly)
- Design an `AgentDefinition` with restricted `allowedTools` (validate: JSON structure)
- Implement prerequisite gates blocking `process_refund` until `get_customer` succeeds (validate: run test scenarios)

---

### Domain 2: Tool Design & MCP Integration (18%)

**What the exam tests:**
- Writing clear tool descriptions that differentiate similar tools
- Structured error responses (`isError`, `errorCategory`, `isRetryable`)
- Tool distribution across agents (scoping, least privilege)
- `tool_choice` configuration (`auto`, `any`, forced selection)
- MCP server scoping (project `.mcp.json` vs user `~/.claude.json`)
- Environment variable expansion in `.mcp.json`
- MCP resources for content catalogs
- Built-in tools: Grep, Glob, Read/Write/Edit, Bash — selection criteria

**Architecture applicability:**

| Option | Can teach D2? | How |
|--------|:---:|------|
| A: Pure Plugin | Partial | Exercises on using built-in tools (Task 2.5). Cannot teach MCP server design |
| B: Hooks | Partial | Same as A, plus can validate which built-in tools the learner used |
| C: Wrapper CLI | No | Doesn't help learners design tools |
| D: Companion CLI | No | Same |
| **E: MCP Server** | **Excellent** | The MCP server IS the exercise deliverable. Learner builds a server, writes tool descriptions, implements error responses. Then configures it in `.mcp.json`. This is the single best architecture for D2 |
| **F: Hybrid** | **Excellent** | MCP exercises + built-in tool exercises via hooks |

**Key insight:** Option E (MCP Server) is the natural fit here. The exam literally tests MCP server design. Having learners build and configure MCP servers as exercises would directly cover Task Statements 2.1-2.4. The existing plugin architecture can cover Task 2.5 (built-in tools).

**Specific exercise ideas:**
- Write tool descriptions for `get_customer` vs `lookup_order` that prevent misrouting (validate: description quality via pattern matching)
- Build an MCP server with structured error responses including `errorCategory` and `isRetryable` (validate: run test requests against the server)
- Configure `.mcp.json` with environment variable expansion for credentials (validate: file structure)
- Design tool distribution: given 3 agents, assign tools with least privilege (validate: JSON config files)

---

### Domain 3: Claude Code Configuration & Workflows (20%)

**What the exam tests:**
- CLAUDE.md hierarchy (user/project/directory), `@import` syntax
- `.claude/rules/` with YAML frontmatter `paths` for conditional loading
- `.claude/commands/` (project-scoped) vs `~/.claude/commands/` (personal)
- `.claude/skills/` with `context: fork`, `allowed-tools`, `argument-hint`
- Plan mode vs direct execution decision-making
- Iterative refinement (input/output examples, TDD, interview pattern)
- CI/CD: `-p` flag, `--output-format json`, `--json-schema`, session isolation
- `/compact`, `--resume`, Explore subagent

**Architecture applicability:**

| Option | Can teach D3? | How |
|--------|:---:|------|
| **A: Pure Plugin** | **Good** | This is cclab's sweet spot. Exercises create CLAUDE.md files, configure rules, build skills. Validated by checking file existence and content |
| **B: Hooks** | **Better** | Same as A, plus can validate that the learner used plan mode (detect plan-related tool calls), or used specific built-in tools |
| C: Wrapper CLI | Partial | Could demonstrate `-p` mode and `--output-format json` for CI/CD scenarios. But the wrapper approach conflicts with interactive learning |
| D: Companion CLI | Minimal | CLI itself doesn't teach Claude Code config |
| E: MCP Server | Partial | MCP config in `.mcp.json` is D3 content, but most of D3 is plugin/config work |
| **F: Hybrid** | **Best** | Plugin for config exercises, hooks for validating tool/mode choices |

**Key insight:** The current architecture already handles most of D3. The gaps are:
1. `.claude/rules/` with path-scoped frontmatter (can add exercises with current architecture)
2. Plan mode decision-making (hard to validate — can use hooks to detect plan mode entry)
3. CI/CD integration (need exercises where learner runs `claude -p` and checks output)
4. Skill frontmatter (`context: fork`, `allowed-tools`) — can validate by checking SKILL.md files

**Specific exercise ideas (all feasible with Option A or B):**
- Create `.claude/rules/testing.md` with `paths: ["**/*.test.*"]` (validate: file + frontmatter)
- Build a project-scoped `/review` command in `.claude/commands/` (validate: file exists, content follows command format)
- Create a skill with `context: fork` and `allowed-tools` restrictions (validate: SKILL.md frontmatter)
- Design a CLAUDE.md hierarchy for a monorepo (validate: files at correct locations)
- Run `claude -p` with `--output-format json` and parse the output (validate: script produces correct JSON)

---

### Domain 4: Prompt Engineering & Structured Output (20%)

**What the exam tests:**
- Explicit criteria over vague instructions for review/analysis tasks
- Few-shot prompting for ambiguous scenarios, format consistency, generalization
- `tool_use` with JSON schemas for guaranteed structured output
- `tool_choice` (`auto`/`any`/forced) configuration
- Schema design: required vs optional, nullable, enum + "other" + detail fields
- Validation-retry loops (retry-with-error-feedback, limits of retry)
- Batch processing: Message Batches API, `custom_id`, SLA-aware scheduling
- Multi-pass review: session isolation, per-file + integration passes

**Architecture applicability:**

| Option | Can teach D4? | How |
|--------|:---:|------|
| A: Pure Plugin | Minimal | Can explain concepts but cannot have learner write API code or design JSON schemas interactively |
| B: Hooks | Minimal | Same — hooks don't help with prompt engineering exercises |
| C: Wrapper CLI | No | |
| D: Companion CLI | No | |
| **E: MCP Server** | **Good** | Learner builds MCP tools with JSON schemas. Server validates schema compliance. Can simulate validation-retry loops |
| **F: Hybrid** | **Good** | MCP for schema/tool exercises; plugin for prompting pattern exercises |

**Key insight:** D4 requires learners to **write code that calls the Claude API.** This is fundamentally different from using Claude Code interactively. Exercises would need to:
1. Scaffold a Python/TypeScript project with Anthropic SDK
2. Have the learner write prompts, design schemas, implement retry loops
3. Validate by running the code against a test case (or mock)

This is possible with the current setup.sh/validate.sh pattern, but requires a different exercise template — one that scaffolds an API project instead of a workspace for Claude Code interaction.

**Specific exercise ideas:**
- Design a JSON schema for `extract_invoice` with nullable fields and enum + detail (validate: schema structure)
- Write a system prompt with explicit review criteria for a code review scenario (validate: pattern matching for required elements)
- Create 2-3 few-shot examples for an ambiguous extraction task (validate: examples cover edge cases)
- Implement a validation-retry loop in Python/TypeScript (validate: run the script, check it retries correctly)
- Design a batch processing workflow: calculate submission frequency for 30-hour SLA with 24-hour batch window (validate: answer file)

---

### Domain 5: Context Management & Reliability (15%)

**What the exam tests:**
- Progressive summarization risks (losing numerical values, dates)
- "Lost in the middle" effect, position-aware input ordering
- Tool output trimming (keeping only relevant fields)
- Structured fact extraction ("case facts" blocks, persistent context layers)
- Escalation patterns (explicit criteria, honoring customer preferences, policy gaps)
- Error propagation (structured error context, failure type, partial results)
- Context degradation in long sessions, scratchpad files, `/compact`
- Crash recovery (structured state exports, coordinator manifests)
- Human review workflows (confidence calibration, stratified sampling)
- Information provenance (claim-source mappings, temporal data, conflict annotation)

**Architecture applicability:**

| Option | Can teach D5? | How |
|--------|:---:|------|
| A: Pure Plugin | Minimal | Can teach `/compact` and scratchpad patterns via Claude Code exercises |
| B: Hooks | Minimal | Hooks don't observe context management |
| C: Wrapper CLI | Partial | Stream-json shows context growth; could visualize token usage |
| D: Companion CLI | No | |
| **E: MCP Server** | **Good** | Server can simulate multi-turn conversations with context degradation. Can implement escalation tools. Can require structured error responses |
| **F: Hybrid** | **Good** | MCP for reliability/escalation exercises; plugin for context management basics |

**Key insight:** D5 is the hardest domain to teach interactively. Most concepts (summarization risks, escalation calibration, provenance tracking) are architectural decisions, not hands-on tool usage. The exam tests judgment — "which approach is correct for this scenario?" — more than implementation.

Teaching strategies:
1. **Scenario-based exercises** with written analysis (validate: answer contains required concepts)
2. **System prompt design** exercises (write an escalation prompt with explicit criteria)
3. **Code exercises** implementing structured error responses, context extraction
4. **Claude Code exercises** using `/compact`, scratchpad files, Explore subagent

---

## Architecture Extensibility for CCA Prep: Summary Matrix

| Architecture | D1 (27%) | D2 (18%) | D3 (20%) | D4 (20%) | D5 (15%) | Total Addressable |
|---|---|---|---|---|---|---|
| **A: Pure Plugin** | 5% | 8% | 15% | 2% | 2% | ~32% |
| **B: Hooks** | 10% | 10% | 17% | 2% | 2% | ~41% |
| **C: Wrapper CLI** | 8% | 8% | 16% | 3% | 5% | ~40% |
| **D: Companion CLI** | 5% | 8% | 15% | 2% | 2% | ~32% |
| **E: MCP Server** | 15% | 16% | 16% | 12% | 8% | ~67% |
| **F: Hybrid (B+E)** | 18% | 17% | 18% | 13% | 9% | **~75%** |

The remaining ~25% is pure judgment/knowledge that's hard to teach via exercises (batch API SLA calculations, confidence calibration math, provenance theory). Those are better served by study guides, flashcards, or scenario-based quizzes.

---

## The Missing Piece: Code-Based Exercises

All architecture options share one gap: **cclab doesn't currently support exercises where the deliverable is running code** (Python/TypeScript that calls the Claude API, builds an MCP server, or implements an agentic loop).

To cover CCA Domains 1, 2, 4, and 5 meaningfully, cclab needs a new exercise template:

### Current template (interactive Claude Code exercise):
```
setup.sh    → creates workspace files for the learner to edit within Claude Code
validate.sh → checks file existence, content patterns, git state
```

### New template needed (code project exercise):
```
setup.sh    → scaffolds a Python/TypeScript project (package.json, requirements.txt, starter code)
validate.sh → runs the learner's code against test cases, checks output
```

**Example: "Build an MCP Server with Structured Errors" exercise:**
```bash
# setup.sh
mkdir -p "$WORKSPACE"
cat > "$WORKSPACE/package.json" << 'EOF'
{ "name": "cclab-mcp-exercise", "type": "module", "dependencies": { "@modelcontextprotocol/sdk": "^1.0" } }
EOF
cat > "$WORKSPACE/server.ts" << 'EOF'
// TODO: Implement an MCP server with 2 tools:
// 1. get_customer(id) — returns customer details
// 2. lookup_order(order_id) — returns order details
//
// Requirements:
// - Tool descriptions must clearly differentiate the two tools
// - Errors must include: errorCategory, isRetryable, description
// - Business rule violations must return isRetryable: false
//
// See instructions.md for full requirements.
export {};
EOF

# validate.sh
cd "$WORKSPACE"
npm install 2>/dev/null

# Check server.ts has required patterns
grep -q 'isError' server.ts || { echo "FAIL: No structured error handling found"; exit 1; }
grep -q 'errorCategory' server.ts || { echo "FAIL: Missing errorCategory in error responses"; exit 1; }
grep -q 'isRetryable' server.ts || { echo "FAIL: Missing isRetryable field"; exit 1; }

# Check tool descriptions are substantive (not minimal)
DESC_LINES=$(grep -c 'description' server.ts)
[ "$DESC_LINES" -ge 2 ] || { echo "FAIL: Need detailed tool descriptions"; exit 1; }

# Try to compile
npx tsc --noEmit server.ts 2>/dev/null || { echo "FAIL: TypeScript compilation errors"; exit 1; }

echo "All checks passed"
```

This template works with **all architecture options** — it's an exercise design change, not an architecture change. But some architectures support it better:

| Architecture | Support for code exercises |
|---|---|
| A: Pure Plugin | Works — validate.sh can run tests. But can't verify the learner used Claude Code to help write the code |
| B: Hooks | Works + can verify Claude Code tool usage during development |
| E: MCP Server | Works + the exercise deliverable (an MCP server) can be tested by the cclab MCP server itself |
| F: Hybrid | Best — hooks verify process, MCP server can provide live feedback during development |

---

## Recommendation for CCA Exam Prep Extensibility

### Phase 1: Expand exercise types (no architecture change needed)

Create new tracks targeting CCA domains using the **existing plugin architecture**:

| New Track | CCA Domain | Exercise Count | Architecture Needed |
|---|---|---|---|
| `claude-code-advanced` | D3 | 6-8 | Option A (current) |
| `tool-design` | D2 | 5-6 | Option A + B (hooks) |
| `agentic-patterns` | D1 | 6-8 | Option A (code exercises) |
| `prompt-engineering` | D4 | 5-6 | Option A (code exercises) |
| `reliability` | D5 | 4-5 | Option A (scenario exercises) |

These exercises scaffold code projects and validate via tests. No new architecture needed.

### Phase 2: Add hooks for tool-usage validation (Option B)

Required for exercises like:
- "Use the Edit tool to fix this bug" (D2, Task 2.5)
- "Write a PostToolUse hook" (D1, Task 1.5)
- "Use plan mode for this architectural change" (D3, Task 3.4)

### Phase 3: Add MCP server exercises (Option E, if demand warrants)

Build a lightweight cclab MCP server that:
- Provides an `exercise_submit` tool for knowledge-check exercises
- Simulates external systems (customer database, order system) for agentic exercises
- Validates MCP server implementations built by learners (meta: MCP server that tests MCP servers)

This phase is highest value for D1 and D2, which together account for **45% of the exam**.

### What NOT to build

- **Wrapper CLI (Option C):** Doesn't help teach CCA content. The `cclab-validator` already handles automated testing.
- **Companion CLI (Option D):** No CCA teaching value. Nice UX but not worth the investment for this goal.
- **Full LMS platform:** Overkill. Shell scripts + file validation cover 90% of what's needed.

---

## Detailed CCA Task Statement → Exercise Mapping

Below is a mapping of every CCA task statement to a concrete exercise idea and the architecture needed.

### Domain 1: Agentic Architecture & Orchestration

| Task | Exercise Idea | Architecture | Validation Strategy |
|---|---|---|---|
| 1.1 Agentic loops | Build a Python script with `stop_reason` handling loop | A | Run script, check it processes 3 tool calls and terminates on `end_turn` |
| 1.2 Multi-agent orchestration | Design coordinator prompt that dynamically selects subagents | A | Check prompt file covers routing criteria |
| 1.3 Subagent invocation | Write `AgentDefinition` JSON with `allowedTools` and isolated context | A | Validate JSON structure and tool restrictions |
| 1.4 Enforcement & handoff | Implement prerequisite gate blocking `process_refund` without `get_customer` | A or E | Run test scenarios, check gate works |
| 1.5 Hooks for interception | Write a `PostToolUse` hook that normalizes timestamps | **B** | Check hook file exists + run it against test input |
| 1.6 Task decomposition | Given a scenario, produce a decomposition plan | A | Pattern match for required decomposition elements |
| 1.7 Session management | Use `--resume` and describe when to start fresh vs resume | A | Answer file with reasoning |

### Domain 2: Tool Design & MCP Integration

| Task | Exercise Idea | Architecture | Validation Strategy |
|---|---|---|---|
| 2.1 Tool descriptions | Rewrite minimal descriptions to differentiate similar tools | A | Check descriptions include input formats, edge cases, boundaries |
| 2.2 Structured error responses | Implement MCP tool with `isError`, `errorCategory`, `isRetryable` | A or **E** | Compile + pattern match for required fields |
| 2.3 Tool distribution | Design tool assignments for 3-agent system with scoped access | A | Validate JSON config, check no agent has >5 tools |
| 2.4 MCP server configuration | Configure `.mcp.json` with env var expansion + user-scoped server | A | Validate JSON structure, check `${GITHUB_TOKEN}` pattern |
| 2.5 Built-in tools | Use Grep/Glob/Edit/Read correctly for codebase exploration task | **B** | Tool log shows correct tool selection |

### Domain 3: Claude Code Configuration & Workflows

| Task | Exercise Idea | Architecture | Validation Strategy |
|---|---|---|---|
| 3.1 CLAUDE.md hierarchy | Create user + project + directory CLAUDE.md files for a monorepo | A | Check files at correct paths with appropriate content |
| 3.2 Custom commands & skills | Build a `/review` command and a skill with `context: fork` | A | Check file location, frontmatter structure |
| 3.3 Path-specific rules | Create `.claude/rules/testing.md` with `paths: ["**/*.test.*"]` | A | YAML frontmatter validation |
| 3.4 Plan mode vs direct | Given 3 scenarios, write which mode to use and why | A or **B** | Answer validation; hooks can detect if plan mode was actually used |
| 3.5 Iterative refinement | Write input/output examples for an ambiguous transformation | A | Check examples cover edge cases |
| 3.6 CI/CD integration | Write a script that runs `claude -p` with `--output-format json` | A | Run script, validate JSON output |

### Domain 4: Prompt Engineering & Structured Output

| Task | Exercise Idea | Architecture | Validation Strategy |
|---|---|---|---|
| 4.1 Explicit criteria | Rewrite vague review prompt with specific severity criteria | A | Pattern match for categorical criteria |
| 4.2 Few-shot prompting | Write 3 few-shot examples for ambiguous extraction task | A | Check examples show reasoning, cover edge cases |
| 4.3 tool_use + JSON schemas | Design extraction schema with enum, nullable, "other"+detail | A | JSON schema validation |
| 4.4 Validation-retry loops | Implement retry loop in Python/TS that passes error context on retry | A | Run script against test cases |
| 4.5 Batch processing | Calculate batch submission frequency for SLA constraints | A | Answer validation |
| 4.6 Multi-pass review | Design a two-pass review architecture (per-file + integration) | A | Check architectural document for required components |

### Domain 5: Context Management & Reliability

| Task | Exercise Idea | Architecture | Validation Strategy |
|---|---|---|---|
| 5.1 Context preservation | Extract "case facts" from a verbose tool output | A | Check extracted facts preserve numerical values |
| 5.2 Escalation patterns | Write escalation criteria with few-shot examples | A | Pattern match for explicit criteria |
| 5.3 Error propagation | Implement structured error response with failure type, partial results | A or E | Check response structure |
| 5.4 Large codebase context | Use Explore subagent + scratchpad pattern | **B** | Tool log shows Explore subagent usage |
| 5.5 Human review workflows | Design confidence-based routing with field-level scores | A | Check design document |
| 5.6 Information provenance | Build claim-source mapping output format | A | Validate output structure |

---

## Final Assessment

### Architecture ranking for CCA exam prep

1. **Option B (Hooks)** — Best immediate ROI. Adds tool-usage validation with minimal effort. Directly teaches Task 1.5 (hooks). Unlocks validation for ~10 additional CCA-relevant exercises.

2. **Option E (MCP Server)** — Highest long-term value for CCA coverage. Enables exercises where learners build MCP servers (D2), implement agentic tools (D1), and practice structured error handling (D5). Adds ~20% more exam coverage.

3. **Option A (Current)** — Already sufficient for most exercises. Code project exercises (scaffold + validate via tests) work without architecture changes. Covers D3 well, D4 partially.

4. **Option F (Hybrid B+E)** — The endgame. Hooks for validation + MCP for interactive exercises = ~75% of exam addressable.

5. **Option C (Wrapper CLI)** — No meaningful CCA teaching value.

6. **Option D (Companion CLI)** — No CCA teaching value.

### The real bottleneck isn't architecture — it's exercise content

The current architecture (Option A) can already support ~60% of CCA exercises via code project scaffolding. The architecture debate is about the remaining ~15% that needs tool-usage validation (hooks) or interactive MCP tool exercises.

**The highest-leverage next step is writing exercises, not changing architecture.**

Create a `cca-prep` track with 25-30 exercises covering all 5 domains. Use the existing setup.sh/validate.sh pattern. Add hooks (Option B) for the handful of exercises that need tool-usage validation. Evaluate MCP (Option E) after the first batch ships.

---

## Key Finding (TL;DR)

**The CCA exam covers 5 domains, but cclab currently only teaches ~31% of the surface area** (mostly Domain 3: Claude Code Configuration). The gap analysis:

| Domain | Weight | cclab Today | Gap |
|---|---|---|---|
| D1: Agentic Architecture | 27% | ~5% | Learners need to *build* agents, not just use Claude Code |
| D2: Tool Design & MCP | 18% | ~8% | MCP server design is testable — current exercises don't touch it |
| D3: Claude Code Config | 20% | ~15% | Best coverage. Missing: `.claude/rules/`, plan mode depth, CI/CD |
| D4: Prompt Engineering | 20% | ~2% | Requires API code exercises (JSON schemas, retry loops, batch) |
| D5: Context & Reliability | 15% | ~1% | Architectural judgment — hardest to teach interactively |

**Architecture ranking for CCA prep:**

1. **Option B (Hooks)** — Best immediate ROI. Directly teaches exam Task 1.5 (PostToolUse hooks). Unlocks ~10 more exercises.
2. **Option E (MCP Server)** — Highest long-term value. Learners *build* MCP servers as exercises, directly covering D1+D2 (45% of exam).
3. **Option F (B+E combined)** — The endgame: ~75% of exam addressable.

**But the real insight: the bottleneck isn't architecture, it's exercise content.** The current architecture can already support ~60% of CCA exercises by adding **code project exercises** (scaffold a Python/TS project in setup.sh, validate by running tests). No architecture change needed for that.
