# TASK-021: Sample MCP Server + Exercise wf-007 — Plug It In

**Priority:** P1
**Estimated Effort:** 3h
**Status:** TODO
**Dependencies:** TASK-014
**Blocked By:** TASK-014

---

### Objective

Create the MCP exercise including a sample Python3 MCP server that learners configure and connect to. The sample server exposes two simple tools (`get_timestamp`, `word_count`) via the MCP stdio protocol. Learners create `.mcp.json` and add MCP tool permissions to `.claude/settings.json`.

### Scope

#### Files to Create
- `exercises/workflows/wf-007/metadata.json` — id "wf-007", track "workflows", order 7, prerequisites ["wf-002"]
- `exercises/workflows/wf-007/instructions.md` — Instructions explaining MCP protocol, transport types, tool naming, and how to configure the sample server
- `exercises/workflows/wf-007/setup.sh` — Scaffolds workspace with CLAUDE.md, tools/timestamp-server.py (sample MCP server), tools/README.md
- `exercises/workflows/wf-007/validate.sh` — Checks: .mcp.json exists with mcpServers/timestamp/command/python3, .claude/settings.json exists with mcp__ permission, sample server still present
- `exercises/workflows/wf-007/hints.md` — 3 progressive hints
- Sample MCP server: `tools/timestamp-server.py` embedded in setup.sh (written by setup.sh to workspace)

#### Files NOT Touched
- Any files in `exercises/fundamentals/`

### Acceptance Criteria

- [ ] AC-1: `metadata.json` has prerequisites ["wf-002"]
- [ ] AC-2: Sample MCP server (`tools/timestamp-server.py`) implements JSON-RPC over stdio with `initialize`, `tools/list`, and `tools/call` methods
- [ ] AC-3: Sample server exposes exactly 2 tools: `get_timestamp` and `word_count`
- [ ] AC-4: Sample server requires only Python3 standard library (no pip dependencies)
- [ ] AC-5: `validate.sh` checks all 8 validation criteria from curriculum
- [ ] AC-6: `instructions.md` explains MCP protocol, stdio transport, and tool naming convention
- [ ] AC-7: Exercise passes `/validate-exercise wf-007`

### Technical Notes

- The sample MCP server must be a single Python3 file using only stdlib (sys, json, datetime).
- MCP stdio protocol: server reads JSON-RPC messages from stdin (one per line), writes responses to stdout.
- Key methods to implement:
  - `initialize` — return server info and capabilities
  - `tools/list` — return tool definitions with names, descriptions, input schemas
  - `tools/call` — execute the requested tool and return results
- `get_timestamp` tool: returns current time in ISO, Unix, and human-readable formats
- `word_count` tool: accepts a `text` parameter and returns word/character/line counts
- The server must handle the MCP protocol correctly but doesn't need to be production-quality.
- setup.sh writes the entire server script to `$WORKSPACE/tools/timestamp-server.py` and makes it executable.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-007 (MCP Servers) | wf-007 |
